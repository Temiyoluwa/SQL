use Credit_Card_Details
go

--CARD HOLDER TABLE
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'.Card_Holder') AND type in (N'U'))
DROP TABLE Card_Holder

CREATE TABLE Card_Holder
(
	Card_Holder_ID INT NOT NULL,
	Card_Holder_NAME VARCHAR (50) NOT NULL
	CONSTRAINT PK_card_holder PRIMARY KEY(Card_Holder_ID)
)

--CREDIT CARD TABLE
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'.Credit_Card') AND type in (N'U'))
DROP TABLE Credit_Card

CREATE TABLE Credit_Card
(
	Credit_Card_Number VARCHAR(50) NOT NULL CONSTRAINT PK_credit_card PRIMARY KEY,
	Card_Holder_ID INT NOT NULL CONSTRAINT FK_credit_card_card_holder FOREIGN KEY (Card_Holder_ID) REFERENCES Card_Holder(Card_Holder_ID),
	--CONSTRAINT credit_card_len CHECK (Credit_Card_Number <=20)

)

--Switched Merchant Category and Name's position to enable me create a foreign key
--MERCHANT CATEGORY TABLE
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'.Merchant_Category') AND type in (N'U'))
DROP TABLE Merchant_Category

CREATE TABLE Merchant_Category
(
	Merchant_Category_ID INT NOT NULL,
	Merchant_Category_Name VARCHAR(50) NOT NULL
	CONSTRAINT PK_merchant_category PRIMARY KEY(Merchant_Category_ID)
)

--MERCHANT NAME TABLE
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'.Merchant_Names') AND type in (N'U'))
DROP TABLE Merchant_Names

CREATE TABLE Merchant_Names
(
	Merchant_Name_ID INT NOT NULL,
	Merchant_NAME VARCHAR(255) NOT NULL,
	Merchant_Category_ID INT NOT NULL CONSTRAINT FK_Merchant_Name_merchant_category_id FOREIGN KEY (Merchant_Category_ID) REFERENCES Merchant_Category (Merchant_Category_ID),
	CONSTRAINT PK_merchant_name PRIMARY KEY(Merchant_Name_ID)
)

--TRANSACTION TABLE
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'.Transactions') AND type in (N'U'))
DROP TABLE Transactions

CREATE TABLE TRANSACTIONS
(
	Transaction_Id INT NOT NULl,
	Transaction_Date	DATETIME NOT NULL,
	Transaction_Amount FLOAT NOT NULL,
	Credit_Card_Number VARCHAR(50) NOT NULL CONSTRAINT FK_Transaction_card_holder FOREIGN KEY (Credit_Card_Number) REFERENCES Credit_Card (Credit_Card_Number),
	Merchant_Name_ID INT NOT NULL CONSTRAINT FK_Transaction_Merchant_Name_ID FOREIGN KEY (Merchant_Name_ID) REFERENCES Merchant_Names (Merchant_Name_ID),
	CONSTRAINT PK_transaction_ID PRIMARY KEY(Transaction_ID)
)

	

	

	




















