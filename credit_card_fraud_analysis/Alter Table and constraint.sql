--CARD HOLDER TABLE
Alter TABLE Card_Holder
	Alter Column Card_Holder_ID varchar(50)

--CREDIT CARD TABLE
ALTER TABLE Credit_Card
	ALTER COLUMN Credit_Card_Number VARCHAR(50)
go

ALTER TABLE Credit_Card
	ALTER COLUMN Card_Holder_ID INT
go

--MERCHANT CATEGORY TABLE
ALTER TABLE Merchant_Category
	ALTER COLUMN Merchant_Category_Name VARCHAR(50)
GO

--TRANSACTION TABLE
ALTER TABLE Transactions
	ALTER COLUMN Credit_Card_Number VARCHAR(50)

ALTER TABLE Transactions
	ALTER COLUMN Transaction_Amount FLOAT

ALTER TABLE Transactions
	ALTER COLUMN Transaction_Date	DATETIME 	



USE [Credit_Card_Details]
GO

ALTER TABLE [dbo].[Credit_Card] DROP CONSTRAINT [FK_credit_card_card_holder]

ALTER TABLE [dbo].[Merchant_Names] DROP CONSTRAINT [FK_Merchant_Name_merchant_category_id]

ALTER TABLE [dbo].[TRANSACTIONS] DROP CONSTRAINT [FK_Transaction_card_holder]

ALTER TABLE [dbo].[TRANSACTIONS] DROP CONSTRAINT [FK_Transaction_Merchant_Name_ID]

ALTER TABLE [dbo].[Card_Holder] DROP CONSTRAINT [PK_card_holder] WITH ( ONLINE = OFF )

ALTER TABLE [dbo].[Credit_Card] DROP CONSTRAINT [PK_credit_card] WITH ( ONLINE = OFF )

ALTER TABLE [dbo].[Merchant_Category] DROP CONSTRAINT [PK_merchant_category] WITH ( ONLINE = OFF )

ALTER TABLE [dbo].[Merchant_Names] DROP CONSTRAINT [PK_merchant_name] WITH ( ONLINE = OFF )

ALTER TABLE [dbo].[TRANSACTIONS] DROP CONSTRAINT [PK_transaction_ID] WITH ( ONLINE = OFF )


































