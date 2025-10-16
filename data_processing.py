"""
	H_CUSTOMER
		Ship Mode
		Segment

	H_LOCATION
		Country
		City
		State
		Postal Code
		Region

	H_PRODUCT
		Category
		Sub-Category

	H_ORDER
		Sales
		Quantity
		Discount
		Profit

	LINK_ORDER_PRODUCT
	LINK_ORDER_CUSTOMER
	LINK_CUSTOMER_LOCATION


"""
import hashlib
import uuid

import pandas as pd
import psycopg2


db_conn = None


def log(src, msg):
	print(f"\033[32m[ {src} ]\033[0m  {msg}")

def connect_to_greenplum():
	"""
		Подключение к БД GreenPlum -> возвращается движок подключения
	"""
	GP_DB_HOST	= "rc1a-q1h1bect4ltivtlp.mdb.yandexcloud.net,rc1a-st22qvh84iqkso52.mdb.yandexcloud.net"
	GP_DB_PORT	= "6432"
	GP_DB_NAME	= "hse"
	GP_DB_USER	= "student2"
	GP_DB_PASS	= "dn2t3f8h7pg3f29n7k3s"

	conn = psycopg2.connect((f'host={GP_DB_HOST} port={GP_DB_PORT} dbname={GP_DB_NAME} user={GP_DB_USER} password={GP_DB_PASS}'))
	log("data_load_greenplum/connect_to_greenplum()", f"Greenplum is connected")
	with conn.cursor() as cur:
		cur.execute("select current_database(), version()")
		row = cur.fetchone()
		log("data_load_greenplum/connect_to_greenplum()", f"Database: {row[0]} | Version: {row[1].split(" on ")[0]}")

	return conn

def execute_sql_file(sql_file):
	sql = open(sql_file, "r", encoding="utf-8").read()

	with db_conn.cursor() as cur:
		cur.execute(sql)
	
	db_conn.commit()

	log("execute_sql_file()", f"SQL-file executed: {sql_file}")


def data_preprocessing():
	"""
		Генерация бизнес-ключей для хабов \n
		H_CUSTOMER	= Segment + State + City + Postal Code			<br>
		H_LOCATION	= Country + City + State + Postal Code + Region	<br>
		H_PRODUCT	= Category + Sub-Category						<br>
		H_SHIPPING	= Ship Mode										<br>
		(-) H_ORDER		= Sales + Quantity + Discount + Profit			<br>
	"""
	df = pd.read_csv("./SampleSuperstore.csv")

	hubs = {
		'H_CUSTOMER'	: ['Segment', 'State', 'City', 'Postal Code'],
		'H_LOCATION'	: ['Country', 'City', 'State', 'Postal Code', 'Region'],
		'H_PRODUCT'		: ['Category', 'Sub-Category'],
		'H_SHIPPING'	: ['Ship Mode'],
		# 'H_ORDER'		: ['Sales', 'Quantity', 'Discount', 'Profit'],
	}

	for hub, fields in hubs.items():
		df[hub] = df[fields].astype(str).agg('_'.join, axis=1)
		mapping = {	group: str(uuid.uuid4())
				for group in df[hub].unique() }
		df[f'{hub}_ID'] = df[hub].map(mapping)

		df = df.drop([hub], axis=1)

		log("data_preprocessing()", f"{hub}_ID\tis appended to Dataset from fields {fields}")
	
	df.to_csv('./SampleSuperstore_processed.csv', index=False)

def copy_data_from_csv():
	with db_conn.cursor() as cur:
		# Очищение данных в Superstore
		cur.execute("TRUNCATE TABLE student2.superstore")

		# Заполнение данными из CSV
		query = (
			"COPY student2.superstore (\n"
			"  ship_mode, segment, country, city, state, postal_code, region,\n"
			"  category, sub_category, sales, quantity, discount, profit,\n"
			"  H_CUSTOMER_ID, H_LOCATION_ID, H_PRODUCT_ID, H_SHIPPING_ID\n"
			") FROM STDIN WITH (FORMAT CSV, HEADER TRUE)"
		)
		with open("./SampleSuperstore_processed.csv", "r", encoding="utf-8") as f:
			cur.copy_expert(query, f)
			# with cur.copy_expert(query, f) as copy:
			# 	while data := f.read(8192):
			# 		copy.write(data)
	
	db_conn.commit()

	# Проверка количества загруженных строк
	with db_conn.cursor() as cur:
		cur.execute("SELECT count(*) FROM student2.superstore")
		rowcount = cur.fetchone()[0]
		return int(rowcount)

def data_load_greenplum():
	global db_conn
	db_conn = connect_to_greenplum()
	# df = pd.read_csv("./SampleSuperstore_processed.csv")

	# hubs = ['H_CUSTOMER', 'H_LOCATION', 'H_PRODUCT', 'H_SHIPPING', 'H_ORDER']
	# for hub in hubs:
	# 	df_hub = df[[f'{hub}_ID']].drop_duplicates()
	# 	df_hub[f'{hub}_Hash'] = df_hub[f'{hub}_ID'].apply(
	# 		lambda x : hashlib.md5(x.encode()).hexdigest()
	# 	)
	# 	df_hub['H_Load_Source']	= 'SampleSuperstore_processed.csv'
	# 	df_hub['H_Load_Date']	= pd.Timestamp.now()

	# 	df_hub.to_sql(
	# 		hub,
	# 		con=engine,
	# 		schema='student2',
	# 		if_exists='replace',
	# 		index=False,
	# 		method='multi'
	# 	)

	# 	print("data_load_greenplum()", f"{hub}\tis appended to student2/hse")

	execute_sql_file("./00_init_create.sql")

	rows = copy_data_from_csv()
	log("data_load_greenplum()", f"Rows uploaded to 'student2.superstore': {rows}")

	execute_sql_file("./10_create_DV_tables.sql")


if __name__ == "__main__":
	data_preprocessing()
	data_load_greenplum()