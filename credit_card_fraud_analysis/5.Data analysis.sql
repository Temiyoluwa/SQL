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

--DATA ANALYSIS

--WHAT MERCHANT  HAD THE MOST TRANSACTIONS AND WHAT WAS THE TOTAL TRANSACTION AMOUNt
SELECT 
MN.Merchant_NAME, COUNT (TR.TRANSACTION_ID) as [Total Number of Transaction by Merchant], SUM(TR.Transaction_Amount) as [Total Transaction Amount]
FROM TRANSACTIONS TR
JOIN Merchant_Names MN
ON TR.Merchant_Name_ID = MN.Merchant_Name_ID
GROUP BY Merchant_NAME
ORDER BY [Total Number of Transaction by Merchant] DESC, [Total Transaction Amount] DESC


--What is the average transaction amount
SELECT AVG(Transaction_Amount) 
FROM TRANSACTIONS

--What are the Top 5 highest transactions carried out ?
select TOP 5
	CH.Card_Holder_ID, MAX(Transaction_Amount)[Highest Transaction Amount], Merchant_Category_Name, Merchant_NAME
FROM TRANSACTIONS TR
JOIN Merchant_Names MN ON MN.Merchant_Name_ID = TR.Merchant_Name_ID
JOIN Merchant_Category MC ON MC.Merchant_Category_ID = MN.Merchant_Category_ID
JOIN Credit_Card CC ON CC.Credit_Card_Number = TR.Credit_Card_Number
JOIN Card_Holder CH ON CH.Card_Holder_ID = CC.Card_Holder_ID
GROUP BY CH.Card_Holder_ID, Transaction_Amount, Merchant_Category_Name, Merchant_NAME
ORDER BY [Highest Transaction Amount] DESC
GO

--Most credit card fraud are carried out in an unsuspecting manner. such transactions can be less than or equal to $2.00, hence reason for this analysis 
----what month has the highest fraud transaction?
SELECT [Transaction Month], SUM([countS of transactions]) AS Fraud_Transactions
FROM(
	SELECT FORMAT(TransactionDate,'MMM') AS Transaction_Month , COUNT(Transaction_Id) AS total_Transactions
	FROM TRANSACTIONS TR
		JOIN Merchant_Names MN ON MN.Merchant_Name_ID = TR.Merchant_Name_ID
		JOIN Merchant_Category MC ON MC.Merchant_Category_ID = MN.Merchant_Category_ID
		JOIN Credit_Card CC ON CC.Credit_Card_Number = TR.Credit_Card_Number
		JOIN Card_Holder CH ON CH.Card_Holder_ID = CC.Card_Holder_ID
	WHERE Transaction_Amount <= 2.00 --AND DATEPART(HOUR, TransactioN_Time)  NOT IN (7,9)
GROUP BY
	TransactionDate) AS [Fraud Transaction Month]
GROUP BY
	[Transaction Month]
ORDER BY
	[Total Fraud Transactions] DESC

--What are the Top Five merchants prone to being hacked using small Transactions in early morning of the day
SELECT TOP(5) Merchant_NAME, COUNT(Transaction_Id) AS small_transaction_count
FROM TRANSACTIONS TR
JOIN Merchant_Names MN ON MN.Merchant_Name_ID = TR.Merchant_Name_ID
JOIN Merchant_Category MC ON MC.Merchant_Category_ID = MN.Merchant_Category_ID
WHERE Transaction_amount <= 2.00  
AND DATEPART(HOUR, Transaction_Time) BETWEEN 7 AND 9 
GROUP BY Merchant_Name
ORDER BY [Nuber of Transactions] DESC








