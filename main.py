from pyspark.sql import SparkSession
from pyspark.sql.functions import col, hour, when
import os
import requests
import time

def download_file(url, local_path):
    """Download file from URL to local path"""
    print(f"Downloading {url} to {local_path}...")
    response = requests.get(url)
    response.raise_for_status()
    
    os.makedirs(os.path.dirname(local_path), exist_ok=True)
    
    with open(local_path, 'wb') as f:
        f.write(response.content)
    print(f"Downloaded {local_path}")

def main():
    # Download data files if they don't exist locally
    trip_files = [
        ("https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2025-01.parquet", "data/trips/yellow_tripdata_2025-01.parquet"),
        ("https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2025-02.parquet", "data/trips/yellow_tripdata_2025-02.parquet"),
        ("https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2025-03.parquet", "data/trips/yellow_tripdata_2025-03.parquet"),
        ("https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2025-04.parquet", "data/trips/yellow_tripdata_2025-04.parquet"),
        ("https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2025-05.parquet", "data/trips/yellow_tripdata_2025-05.parquet"),
        ("https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2025-06.parquet", "data/trips/yellow_tripdata_2025-06.parquet")
    ]
    
    zones_file = ("https://d37ci6vzurychx.cloudfront.net/misc/taxi+_zone_lookup.csv", "data/zones/taxi_zone_lookup.csv")
    
    # Download trip data files
    for url, local_path in trip_files:
        if not os.path.exists(local_path):
            download_file(url, local_path)
        else:
            print(f"File already exists: {local_path}")
    
    # Download zones file
    if not os.path.exists(zones_file[1]):
        download_file(zones_file[0], zones_file[1])
    else:
        print(f"File already exists: {zones_file[1]}")
    
    # Wait a bit for downloads to complete
    time.sleep(2)
    
    # Initialize Spark session
    spark = SparkSession.builder \
        .appName("Yellow Taxi Data Processing") \
        .master("spark://spark-master:7077") \
        .config("spark.sql.adaptive.enabled", "true") \
        .config("spark.sql.adaptive.coalescePartitions.enabled", "true") \
        .config("spark.sql.execution.arrow.pyspark.enabled", "true") \
        .getOrCreate()
    
    # Set log level to reduce verbosity
    spark.sparkContext.setLogLevel("WARN")
    
    try:
        # 1-2. Load data from multiple Parquet files
        print("Loading trip data...")
        trip_df = spark.read.parquet("data/trips/")
        
        # 3. Clean the dataset based on conditions
        print("Cleaning data...")
        cleaned_df = trip_df.filter(
            (col("tpep_pickup_datetime") >= "2025-01-01 00:00:00") &
            (col("tpep_pickup_datetime") <= "2025-06-30 23:59:59") &
            (col("tpep_dropoff_datetime") >= "2025-01-01 00:00:00") &
            (col("tpep_dropoff_datetime") <= "2025-06-30 23:59:59") &
            (col("trip_distance") > 0) &
            (col("passenger_count") > 0)
        )
        
        print(f"Original records: {trip_df.count()}")
        print(f"Cleaned records: {cleaned_df.count()}")
        
        # 4. Add columns for pickup and dropoff hours
        df_with_hours = cleaned_df.withColumn("pickup_hour", hour(col("tpep_pickup_datetime"))) \
                                 .withColumn("dropoff_hour", hour(col("tpep_dropoff_datetime")))
        
        # 5. Select only required columns
        selected_df = df_with_hours.select(
            "tpep_pickup_datetime",
            "tpep_dropoff_datetime", 
            "passenger_count",
            "trip_distance",
            "PULocationID",
            "DOLocationID",
            "total_amount",
            "pickup_hour",
            "dropoff_hour"
        )
        
        # 6. Load zones data
        print("Loading zones data...")
        zones_df = spark.read.option("header", "true").csv("data/zones/taxi_zone_lookup.csv")
        
        # 7. Join trip data with zones to get zone names
        # Join for pickup zones
        df_with_pickup_zones = selected_df.join(
            zones_df.alias("pickup_zones"), 
            selected_df.PULocationID == zones_df.LocationID, 
            "inner"
        ).select(
            col("tpep_pickup_datetime"),
            col("tpep_dropoff_datetime"),
            col("passenger_count"),
            col("trip_distance"),
            col("PULocationID"),
            col("DOLocationID"),
            col("total_amount"),
            col("pickup_hour"),
            col("dropoff_hour"),
            col("pickup_zones.Zone").alias("pickup_zone_name"),
            col("pickup_zones.Borough").alias("pickup_borough")
        )
        
        # Join for dropoff zones
        final_df = df_with_pickup_zones.join(
            zones_df.alias("dropoff_zones"),
            df_with_pickup_zones.DOLocationID == zones_df.LocationID,
            "inner"
        ).select(
            col("tpep_pickup_datetime"),
            col("tpep_dropoff_datetime"),
            col("passenger_count"),
            col("trip_distance"),
            col("pickup_zone_name"),
            col("dropoff_zones.Zone").alias("dropoff_zone_name"),
            col("total_amount"),
            col("pickup_hour"),
            col("dropoff_hour")
        )
        
        # 8. Create dataset with hourly aggregation of orders by pickup zone
        print("Creating hourly aggregation by pickup zone...")
        hourly_agg = final_df.groupBy("pickup_zone_name", "pickup_hour") \
                            .count() \
                            .withColumnRenamed("count", "order_count")
        
        # 9. Create pivot table with average orders per zone per hour
        print("Creating pivot table with average orders per zone per hour...")
        # First aggregate by zone and hour, then calculate averages
        zone_hour_avg = final_df.groupBy("pickup_zone_name", "pickup_hour").count()
        
        # Group by zone and pivot on hour to get average orders per hour per zone
        pivot_df = zone_hour_avg.groupBy("pickup_zone_name") \
                               .pivot("pickup_hour", [i for i in range(24)]) \
                               .sum("count")  # Using sum instead of avg to get total orders per hour per zone
        
        # If you want average per hour, you might need to calculate it differently
        # For now, let's calculate the average orders per hour across all zones
        # First, we need to calculate the average for each zone-hour combination
        zone_hour_stats = zone_hour_avg.groupBy("pickup_zone_name", "pickup_hour").agg({"count": "avg"})
        zone_hour_stats = zone_hour_stats.withColumnRenamed("avg(count)", "avg_orders")
        
        # Create the final pivot with averages
        pivot_avg_df = zone_hour_stats.groupBy("pickup_zone_name") \
                                     .pivot("pickup_hour", [i for i in range(24)]) \
                                     .agg({"avg_orders": "first"})
        
        # Fill null values with 0
        for i in range(24):
            pivot_avg_df = pivot_avg_df.fillna(0, subset=[str(i)])
        
        print(f"Final pivot table schema (should have 25 columns):")
        print(f"Number of columns: {len(pivot_avg_df.columns)}")
        pivot_avg_df.printSchema()
        
        # 10. Save the final dataset in Parquet format
        print("Saving final dataset...")
        output_path = "/app/output/taxi_hourly_avg_orders_2025"
        pivot_avg_df.write.mode("overwrite").parquet(output_path)
        
        print(f"Final dataset saved to: {output_path}")
        
        # Show some statistics
        print(f"Total number of pickup zones: {pivot_avg_df.count()}")
        print("Final dataset preview:")
        pivot_avg_df.show(10)
        
        # Show sample data from the original processed dataset
        print("Sample of original processed data:")
        final_df.show(5)
        
    except Exception as e:
        print(f"Error occurred: {str(e)}")
        raise
    finally:
        # Stop Spark session
        spark.stop()
        print("Spark session stopped.")

if __name__ == "__main__":
    main()