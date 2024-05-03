USE Credit_Card_Details
GO

--few data transformation steps
--splitting the date and time column
select
	Transaction_Date, PARSENAME(REPLACE(Transaction_Date, ' ','.'),1) 
from 
	TRANSACTIONS
go

--creating a  transaction_date column for just date so the 0:00 for time does'nt appear
ALTER TABLE
	Transactions
ADD 
	TransactionDate DATE
UPDATE
	TRANSACTIONS
SET
	TransactionDate =  CONVERT(date,transaction_date) from TRANSACTIONS
go

 -- Removing unwanted colums
 ALTER TABLE 
	Transactions
DROP COLUMN
	Temptime,
	Transaction_Date
go

--CHECKING FOR DUPLICATES
SELECT * 
FROM(
	SELECT *,
		ROW_NUMBER() OVER( PARTITION BY Transaction_Amount,
						Credit_Card_Number,
						Transaction_Time,
						TransactionDate 
						ORDER BY Transaction_ID) AS Duplicate_Row
	FROM
		TRANSACTIONS
) AS DUPLICATE
WHERE Duplicate_Row > 1
--No duplicates were found, else I would have updated code to remove duplicates

--Displaying records in the Tables
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

--What is the average transaction amount
SELECT AVG(Transaction_Amount) 
FROM TRANSACTIONS

--who are the top 5 card holder with the most transactions
SELECT 
	TOP 5 Card_Holder_NAME,
	COUNT(Transaction_Id) AS total_transcations
FROM
	Card_Holder AS CH
JOIN
	Credit_Card AS CR
ON CH.Card_Holder_ID = CR.Card_Holder_ID
JOIN
	TRANSACTIONS AS TR
ON TR.Credit_Card_Number = CR.Credit_Card_Number
GROUP BY
	CH.Card_Holder_NAME
ORDER BY total_transcations DESC










