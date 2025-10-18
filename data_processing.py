import uuid

import pandas as pd
import psycopg2

# Глобальная переменная подключения к БД
db_conn = None


def log(src, msg):
	"""
		Util-функция для форматированного вывода процесса работы программы
	"""
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
	
	#	Проверка успешности подключения
	with conn.cursor() as cur:
		cur.execute("select current_database(), version()")
		row = cur.fetchone()
		log("data_load_greenplum/connect_to_greenplum()", f"Database: {row[0]} | Version: {row[1].split(" on ")[0]}")

	return conn

def disconnect_from_db():
	if db_conn:
		db_conn.close()
		log("disconnect_from_db()", "Disconnected from Database")
		return
	log("disconnect_from_db()", "No Database connected")

def execute_sql_file(sql_file):
	"""
		Выполнение содержимого .sql файла в подключенной БД
	"""
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
	"""
	df = pd.read_csv("./SampleSuperstore.csv")

	hubs = {
		'H_CUSTOMER'	: ['Segment', 'State', 'City', 'Postal Code'],
		'H_LOCATION'	: ['Country', 'City', 'State', 'Postal Code', 'Region'],
		'H_PRODUCT'		: ['Category', 'Sub-Category'],
		'H_SHIPPING'	: ['Ship Mode']
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
	"""
		Перенос содержимого .csv файла в подключенную БД
	"""
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
	
	db_conn.commit()

	# Проверка количества загруженных строк
	with db_conn.cursor() as cur:
		cur.execute("SELECT count(*) FROM student2.superstore")
		rowcount = cur.fetchone()[0]
		return int(rowcount)

def data_load_greenplum():
	"""
		Загрузка данных в GreenPlum БД
	"""
	global db_conn
	db_conn = connect_to_greenplum()

	execute_sql_file("./sql/00_init_create.sql")

	rows = copy_data_from_csv()
	log("data_load_greenplum()", f"Rows uploaded to 'student2.superstore': {rows}")

	execute_sql_file("./sql/10_create_DV_hubs.sql")
	execute_sql_file("./sql/11_create_DV_links.sql")
	execute_sql_file("./sql/12_create_DV_sats.sql")

	execute_sql_file("./sql/20_populate_hubs.sql")
	execute_sql_file("./sql/21_populate_links.sql")
	execute_sql_file("./sql/22_populate_sats.sql")


if __name__ == "__main__":
	data_preprocessing()
	data_load_greenplum()
	disconnect_from_db()