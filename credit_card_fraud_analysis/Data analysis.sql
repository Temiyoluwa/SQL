USE Credit_Card_Details
go


select 
	* 
from 
	TRANSACTIONS
go



--splitting the date and time column
select
	Transaction_Date, PARSENAME(REPLACE(Transaction_Date, ' ','.'),1) 
from 
	TRANSACTIONS
go
-- result is incorrect because of white spaces

ALTER TABLE
	TRANSACTIONS  
ADD
	Temptime varchar(20)

UPDATE  TRANSACTIONS
SET temptime = REPLACE(transaction_date, '  ', ' ') from transactions
select * from TRANSACTIONS

select PARSENAME( REPLACE(temptime, ' ', '.'),1) from TRANSACTIONS
go

ALTER TABLE
	TRANSACTIONS
ADD
	Transaction_Time time

UPDATE
	TRANSACTIONS
SET 
	Transaction_Time = PARSENAME( REPLACE(temptime, ' ', '.'),1) from TRANSACTIONS
go

select * from TRANSACTIONS

--creating a  the transaction_date column for just date
ALTER TABLE
	Transactions
ADD 
	TransactionDate DATE
UPDATE
	TRANSACTIONS
SET
	TransactionDate =  CONVERT(date,transaction_date) from TRANSACTIONS
go

SELECT * FROM TRANSACTIONS

 -- Removing unwanted colums
 ALTER TABLE 
	Transactions
DROP COLUMN
	Temptime,
	Transaction_Date
go

--CHECKING FOR DUPLICATES
SELECT
	* 
FROM(
	SELECT 
		*, ROW_NUMBER()
			OVER( PARTITION BY Transaction_Amount,
							Credit_Card_Number,
							Transaction_Time,
							TransactionDate
			ORDER BY
				Transaction_ID) as Duplicate_Row
FROM
	TRANSACTIONS
) AS DUPLICATE
WHERE 
	Duplicate_Row > 1




SELECT * FROM TRANSACTIONS
SELECT * FROM Credit_Card
SELECT * FROM Card_Holder
SELECT * FROM Merchant_Category
SELECT * FROM Merchant_Names


--DATA ANALYSIS

--WHAT MERCHANT  HAD THE MOST TRANSACTIONS AND WHAT WAS THE TOTAL TRANSACTION AMOUNt
SELECT 
	MN.Merchant_NAME, COUNT (TR.TRANSACTION_ID) as [Total Number of Transaction by Merchant], SUM(TR.Transaction_Amount) as [Total Transaction Amount]
FROM
	TRANSACTIONS TR
JOIN 
	Merchant_Names MN
ON 
	TR.Merchant_Name_ID = MN.Merchant_Name_ID
GROUP BY
	Merchant_NAME
ORDER BY
	[Total Number of Transaction by Merchant], [Total Transaction Amount] DESC
GO

--ANNALYZING CARD HOLDER TABLE
SELECT AVG(Transaction_Amount) 
FROM
	TRANSACTIONS
GROUP BY 

SELECT Card_Holder_NAME, Transaction_Amount, COUNT(Transaction_Amount),TransactionDate
FROM
	Card_Holder CH
join
	Credit_Card CR
on CH.Card_Holder_ID = CR.Card_Holder_ID
JOIN
	TRANSACTIONS TR
ON TR.Credit_Card_Number = CR.Credit_Card_Number
GROUP BY
	CH.Card_Holder_NAME, Transaction_Amount, TransactionDate




SELECT * FROM TRANSACTIONS
SELECT * FROM Credit_Card
SELECT * FROM Card_Holder
SELECT * FROM Merchant_Category
SELECT * FROM Merchant_Names




SELECT Merchant_Name, SUM

--SELECT TOP 5 A, NM FROM (
--SELECT
--	Merchant_NAME NM, Merchant_Category_ID	AS A
--FROM	
--	Merchant_Names
--GROUP BY
--	Merchant_NAME, Merchant_Category_ID	
--) AA ORDER BY A 









SELECT SUBSTRING(TRANSACTION_DATE,1,CHARINDEX('   ',Transaction_Date,-1)) FROM TRANSACTIONS



SELECT * FROM TRANSACTIONS
SELECT * FROM  Card_Holder
SELECT * FROM  Merchant_Names
SELECT * FROM Credit_Card
SELECT * FROM  Merchant_Category


