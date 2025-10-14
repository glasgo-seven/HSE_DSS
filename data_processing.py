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

import pandas as pd
import uuid

def data_preprocessing():
	"""
		Генерация бизнес-ключей для хабов \n
		H_CUSTOMER	= Segment + State + City + Postal Code			<br>
		H_LOCATION	= Country + City + State + Postal Code + Region	<br>
		H_PRODUCT	= Category + Sub-Category						<br>
		H_ORDER		= Sales + Quantity + Discount + Profit			<br>
	"""
	df = pd.read_csv("./SampleSuperstore.csv")
	
	df['H_CUSTOMER'] = df['Segment'] + "_" + df['State'] + "_" + df['City'] + "_" + df['Postal Code'].astype(str)
	mapping = {	group: str(uuid.uuid4())
				for group in df['H_CUSTOMER'].unique() }
	df['H_CUSTOMER_ID'] = df['H_CUSTOMER'].map(mapping)

	df = df.drop(['H_CUSTOMER'], axis=1)

	df.to_csv('./SampleSuperstore_processed.csv', index=False)

def data_load_greenplum():
	pass



if __name__ == "__main__":
	data_preprocessing()
	data_load_greenplum()