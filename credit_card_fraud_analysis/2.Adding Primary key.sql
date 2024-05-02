--CARD HOLDER TABLE
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'.Card_Holder') AND type in (N'U'))
DROP TABLE Card_Holder

CREATE TABLE Card_Holder
(
	Card_Holder_ID varchar(20) NOT NULL,
	Card_Holder_NAME VARCHAR (50) NOT NULL
	CONSTRAINT PK_card_holder PRIMARY KEY(Card_Holder_ID)--table level constraint	
)

--CREDIT CARD TABLE
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'.Credit_Card') AND type in (N'U'))
DROP TABLE Credit_Card

CREATE TABLE Credit_Card
(
	Credit_Card_Number VARCHAR(20) NOT NULL CONSTRAINT PK_credit_card PRIMARY KEY,--column level constraint
	Card_Holder_ID varchar(20) NOT NULL
)

--MERCHANT NAME TABLE
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'.Merchant_Names') AND type in (N'U'))
DROP TABLE Merchant_Names

CREATE TABLE Merchant_Names
(
	Merchant_Name_ID INT NOT NULL,
	Merchant_NAME VARCHAR(255) NOT NULL,
	Merchant_Category_ID INT NOT NULL,
	CONSTRAINT PK_merchant_name PRIMARY KEY(Merchant_Name_ID)
)

--MERCHANT CATEGORY TABLE
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'.Merchant_Category') AND type in (N'U'))
DROP TABLE Merchant_Category

CREATE TABLE Merchant_Category
(
	Merchant_Category_ID INT NOT NULL,
	Merchant_Category_Name VARCHAR(20) NOT NULL
	CONSTRAINT PK_merchant_category PRIMARY KEY(Merchant_Category_ID)
)

--TRANSACTION TABLE
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'.Transactions') AND type in (N'U'))
DROP TABLE Transactions

CREATE TABLE TRANSACTIONS
(
	Transaction_Id INT NOT NULl,
	Transaction_Date TIMESTAMP NOT NULL,
	Transaction_Amount DECIMAL(19,9) NOT NULL,
	Credit_Card_Number VARCHAR(20) NOT NULL ,
	Merchant_Name_ID INT NOT NULL,
	CONSTRAINT PK_transaction_ID PRIMARY KEY(Transaction_ID)
)
	

--The "IF EXISTS" condition is a sql generated code that drops the table if it exists so it can be re-created with the new constraint rules




