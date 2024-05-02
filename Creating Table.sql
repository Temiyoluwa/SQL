--CARD HOLDER TABLE
CREATE TABLE Card_Holder
(
		Card_Holder_ID varchar(20) NOT NULL,
		Card_Holder_NAME VARCHAR (50) NOT NULL
)


--CREDIT CARD TABLE
CREATE TABLE Credit_Card
(
	Credit_Card_Number VARCHAR(20) NOT NULL,
	Card_Holder_ID varchar(20) NOT NULL
)


--MERCHANT NAME TABLE
CREATE TABLE Merchant_Names
(
	Merchant_Name_ID INT NOT NULL,
	Merchant_NAME VARCHAR(255) NOT NULL,
	Merchant_Category_ID INT NOT NULL 
)



--MERCHANT CATEGORY TABLE
CREATE TABLE Merchant_Category
(
	Merchant_Category_ID INT NOT NULL,
	Merchant_Category_Name VARCHAR(20) NOT NULL
)


--TRANSACTION TABLE
CREATE TABLE Transactions
(
	Transaction_Id INT NOT NULl,
	Transaction_Date	TIMESTAMP NOT NULL,
	Transaction_Amount DECIMAL(19,9) NOT NULL,
	Credit_Card_Number VARCHAR(20) NOT NULL,
	Merchant_Name_ID INT NOT NULL
)
	

	
















