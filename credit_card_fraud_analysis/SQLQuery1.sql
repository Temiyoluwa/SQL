DECLARE @TestVariable AS VARCHAR(100) = 'Hello World'
PRINT @TestVariable

--DECLARE @MyVariables TABLE (
--    MeanValue FLOAT,
--    SDValue FLOAT,
--    CutoffValue FLOAT,
--    LowerBound DECIMAL(18, 2),
--    UpperBound DECIMAL(18, 2)
--);

---- Populate the table variable with values
--INSERT INTO @MyVariables (MeanValue, SDValue, CutoffValue, LowerBound, UpperBound)
--SELECT 
--    AVG(Transaction_amount),
--    STDEVP(Transaction_amount),
--    STDEVP(Transaction_amount) * 3,
--    AVG(Transaction_amount) - (STDEVP(Transaction_amount) * 3),
--    AVG(Transaction_amount) + (STDEVP(Transaction_amount) * 3)
--FROM 
--    TRANSACTIONS;

---- Example usage of the variables from the table variable
--SELECT * FROM @MyVariables; -- Access the values stored in the table variable


-- FINDING OUTLIERS USING STANDARD DEVIATION
DECLARE @MEAN FLOAT;
DECLARE @SD FLOAT;
SELECT @MEAN = AVG(Transaction_amount) from TRANSACTIONS
SELECT @SD = STDEVP(Transaction_amount) from TRANSACTIONS		
DECLARE @CUTOFF FLOAT;
SELECT @CUTOFF = @SD*3
DECLARE @lowerBound DECIMAL(18, 2) =  @mean-@cutoff  ; -- Define lower bound threshold
DECLARE @upperBound DECIMAL(18, 2) = @mean+@cutoff  ; -- Define upper bound threshold

select Card_Holder_Name,TransactionDate, Transaction_Time, Merchant_Category_Name,Transaction_Amount
from 
	TRANSACTIONS TR
JOIN 
	Merchant_Names MN
ON MN.Merchant_Name_ID = TR.Merchant_Name_ID
JOIN
	Merchant_Category MC 
ON MC.Merchant_Category_ID = MN.Merchant_Category_ID
JOIN
	Credit_Card CC
ON CC.Credit_Card_Number = TR.Credit_Card_Number
JOIN
	Card_Holder CH
ON CH.Card_Holder_ID = CC.Card_Holder_ID
where 
	Transaction_Amount < @lowerBound OR Transaction_Amount > @upperBound 
GROUP BY Card_Holder_Name,Transaction_Time,TransactionDate, Merchant_Category_Name,Transaction_Amount
GO

--CREATING NON OUTLIERS
DECLARE @MEAN FLOAT;
DECLARE @SD FLOAT;
SELECT @MEAN = AVG(Transaction_amount) from TRANSACTIONS
SELECT @SD = STDEVP(Transaction_amount) from TRANSACTIONS		
DECLARE @CUTOFF FLOAT;
SELECT @CUTOFF = @SD*3
DECLARE @lowerBound DECIMAL(18, 2) =  @mean-@cutoff  ; -- Define lower bound threshold
DECLARE @upperBound DECIMAL(18, 2) = @mean+@cutoff  ; -- Define upper bound threshold
SELECT *
INTO NonOutliers
FROM Transactions
WHERE Transaction_Amount >= @LowerBound AND Transaction_Amount <= @UpperBound;

--NON OUTLIERS
SELECT 
	CH.Card_Holder_NAME,SUM(Transaction_Amount)[Sum of Transaction], CR.Card_Holder_ID
from
	NonOutliers NR
JOIN
	Credit_Card CR
ON NR.Credit_Card_Number = CR.Credit_Card_Number
JOIN
	Card_Holder CH
ON CH.Card_Holder_ID = CR.Card_Holder_ID
GROUP BY
	CH.Card_Holder_NAME, CR.Card_Holder_ID
ORDER BY [Sum of Transaction] DESC








--EARLY HOUR ANALYSIS between 7 and 9 based on Transaction <= $2.00

--Total Number of transactions that are less than $2.00  and are between the early hours of 7 and 9
select
	CH.Card_Holder_ID,COUNT(CH.Card_Holder_ID) [Count of Transactions]
from 
	TRANSACTIONS TR
JOIN 
	Merchant_Names MN
ON MN.Merchant_Name_ID = TR.Merchant_Name_ID
JOIN
	Merchant_Category MC 
ON MC.Merchant_Category_ID = MN.Merchant_Category_ID
JOIN
	Credit_Card CC
ON CC.Credit_Card_Number = TR.Credit_Card_Number
JOIN
	Card_Holder CH
ON CH.Card_Holder_ID = CC.Card_Holder_ID
WHERE
  Transaction_Amount <= 2.00 AND DATEPART(HOUR, TransactioN_Time) BETWEEN 7 AND 9
GROUP BY
	CH.Card_Holder_ID
ORDER BY
	[Count of Transactions] DESC



--Total Numbe OF FRAUDLENT TRANSACTIONS BY CARD HOLDER ID and Merchant Name
select 
	Card_Holder_ID, COUNT(Card_Holder_ID) [Count of Transactions <= $2.00]
from
(
--Top 100 highest transactions during early hours i.e. 7:00 to 9:00 AM
select TOP(100)
	CH.Card_Holder_ID,TransactionDate, Transaction_Time,Merchant_NAME, Merchant_Category_Name,Transaction_Amount
from 
	TRANSACTIONS TR
JOIN 
	Merchant_Names MN
ON MN.Merchant_Name_ID = TR.Merchant_Name_ID
JOIN
	Merchant_Category MC 
ON MC.Merchant_Category_ID = MN.Merchant_Category_ID
JOIN
	Credit_Card CC
ON CC.Credit_Card_Number = TR.Credit_Card_Number
JOIN
	Card_Holder CH
ON CH.Card_Holder_ID = CC.Card_Holder_ID
WHERE
  DATEPART(HOUR, Transaction_Time) BETWEEN 7 AND 9 
GROUP BY
		CH.Card_Holder_ID,TransactionDate, Transaction_Time,Merchant_NAME, Merchant_Category_Name,Transaction_Amount
--ORDER BY 
--	Card_Holder_ID , TransactionDate 
)[aa]
WHERE
	Transaction_Amount <=2.00
GROUP BY Card_Holder_ID
ORDER BY
	[Count of Transactions <= $2.00] DESC

/* Most fraudlent transactions are generally under $2.00, used for several small payments and which are typically ignored by cardholders.
	In a DESCENDING order, Card_Holder_ID 16 and 19 have the most transactions under $2.00, 4 and 3 transactions respectively. 
	This is most likely a fraudlent transaction as their transactions history identify such payment as being unusual.
*/
GO

--What are the Top Five merchants prone to being hacked using small Transactions
select TOP(5)
	Merchant_NAME, COUNT(Transaction_Id)[Nuber of Transactions]
from 
	TRANSACTIONS TR
JOIN 
	Merchant_Names MN
ON MN.Merchant_Name_ID = TR.Merchant_Name_ID
JOIN
	Merchant_Category MC 
ON MC.Merchant_Category_ID = MN.Merchant_Category_ID
WHERE
  DATEPART(HOUR, Transaction_Time) BETWEEN 7 AND 9 
AND Transaction_amount <= 2.00
GROUP BY
	Merchant_Name
ORDER BY
	[Nuber of Transactions] DESC
GO


--what month has the highest fraud transaction
select [Transaction Month], SUM([count of transactions])[Total Fraud Transactions] from(
select
	FORMAT(TransactionDate,'MMM') [Transaction Month] , COUNT(Transaction_Id) [Count of Transactions]
from 
	TRANSACTIONS TR
JOIN 
	Merchant_Names MN
ON MN.Merchant_Name_ID = TR.Merchant_Name_ID
JOIN
	Merchant_Category MC 
ON MC.Merchant_Category_ID = MN.Merchant_Category_ID
JOIN
	Credit_Card CC
ON CC.Credit_Card_Number = TR.Credit_Card_Number
JOIN
	Card_Holder CH
ON CH.Card_Holder_ID = CC.Card_Holder_ID
WHERE
  Transaction_Amount <= 2.00 AND DATEPART(HOUR, TransactioN_Time) BETWEEN 7 AND 9
GROUP BY
	TransactionDate
) [Fraud Transaction Month]
group by
	[Transaction Month]
ORDER BY
	[Total Fraud Transactions] DESC
GO



--GENERAL Analysis based on transactions less than $2.00 

-- What is the Count of transactions that are less than $2.00 per cardholder
select
	CH.Card_Holder_ID,COUNT(CH.Card_Holder_ID) [Count of Transactions]
from 
	TRANSACTIONS TR
JOIN 
	Merchant_Names MN
ON MN.Merchant_Name_ID = TR.Merchant_Name_ID
JOIN
	Merchant_Category MC 
ON MC.Merchant_Category_ID = MN.Merchant_Category_ID
JOIN
	Credit_Card CC
ON CC.Credit_Card_Number = TR.Credit_Card_Number
JOIN
	Card_Holder CH
ON CH.Card_Holder_ID = CC.Card_Holder_ID
WHERE
  Transaction_Amount <= 2.00 --AND DATEPART(HOUR, TransactioN_Time)  NOT IN (7,9)
GROUP BY
	CH.Card_Holder_ID
ORDER BY
	[Count of Transactions] desc
	
--What are the Top Five merchants prone to being hacked using small Transactions
select TOP(5)
	Merchant_NAME, COUNT(Transaction_Id)[Nuber of Transactions]
from 
	TRANSACTIONS TR
JOIN 
	Merchant_Names MN
ON MN.Merchant_Name_ID = TR.Merchant_Name_ID
JOIN
	Merchant_Category MC 
ON MC.Merchant_Category_ID = MN.Merchant_Category_ID
WHERE Transaction_amount <= 2.00  
--AND DATEPART(HOUR, Transaction_Time) BETWEEN 7 AND 9 
GROUP BY
	Merchant_Name
ORDER BY
	[Nuber of Transactions] DESC
go





-- General Transaction Analysis

--What are the Top 5 highest transactions carried out ?
select TOP 5
	CH.Card_Holder_ID, max(Transaction_Amount)[Highest Transaction Amount], Merchant_Category_Name, Merchant_NAME
from 
	TRANSACTIONS TR
JOIN 
	Merchant_Names MN
ON MN.Merchant_Name_ID = TR.Merchant_Name_ID
JOIN
	Merchant_Category MC 
ON MC.Merchant_Category_ID = MN.Merchant_Category_ID
JOIN
	Credit_Card CC
ON CC.Credit_Card_Number = TR.Credit_Card_Number
JOIN
	Card_Holder CH
ON CH.Card_Holder_ID = CC.Card_Holder_ID
GROUP BY
	CH.Card_Holder_ID, Transaction_Amount, Merchant_Category_Name, Merchant_NAME
ORDER BY [Highest Transaction Amount] DESC
GO


-- TOP 10 CUSTOMERS BY TRANSACTIONS
SELECT TOP 10
	CH.Card_Holder_NAME, CR.Card_Holder_ID, SUM(Transaction_Amount)[Sum of Transaction]
from
	TRANSACTIONS TR
JOIN
	Credit_Card CR
ON TR.Credit_Card_Number = CR.Credit_Card_Number
JOIN
	Card_Holder CH
ON CH.Card_Holder_ID = CR.Card_Holder_ID
GROUP BY
	CH.Card_Holder_NAME, CR.Card_Holder_ID
ORDER BY [Sum of Transaction] DESC
GO

----what month has the highest fraud transaction?
select [Transaction Month], SUM([count of transactions])[Total Fraud Transactions] from(
select
	FORMAT(TransactionDate,'MMM') [Transaction Month] , COUNT(Transaction_Id) [Count of Transactions]
from 
	TRANSACTIONS TR
JOIN 
	Merchant_Names MN
ON MN.Merchant_Name_ID = TR.Merchant_Name_ID
JOIN
	Merchant_Category MC 
ON MC.Merchant_Category_ID = MN.Merchant_Category_ID
JOIN
	Credit_Card CC
ON CC.Credit_Card_Number = TR.Credit_Card_Number
JOIN
	Card_Holder CH
ON CH.Card_Holder_ID = CC.Card_Holder_ID
WHERE
  Transaction_Amount <= 2.00 --AND DATEPART(HOUR, TransactioN_Time)  NOT IN (7,9)
GROUP BY
	TransactionDate
) [Fraud Transaction Month]
group by
	[Transaction Month]
ORDER BY
	[Total Fraud Transactions] DESC





SELECT 
	CH.Card_Holder_NAME,SUM(Transaction_Amount)[Sum of Transaction], CR.Card_Holder_ID
from
	TRANSACTIONS TR
JOIN
	Credit_Card CR
ON TR.Credit_Card_Number = CR.Credit_Card_Number
JOIN
	Card_Holder CH
ON CH.Card_Holder_ID = CR.Card_Holder_ID
GROUP BY
	CH.Card_Holder_NAME, CR.Card_Holder_ID
ORDER BY [Sum of Transaction] DESC




SELECT * FROM Card_Holder 
SELECT * FROM TRANSACTIONS
SELECT * FROM Credit_Card
SELECT * FROM Merchant_Category
SELECT * FROM Merchant_Names

















select Card_Holder_Name,TransactionDate, Transaction_Time, Merchant_Category_Name,Transaction_Amount
from 
	TRANSACTIONS TR
JOIN 
	Merchant_Names MN
ON MN.Merchant_Name_ID = TR.Merchant_Name_ID
JOIN
	Merchant_Category MC 
ON MC.Merchant_Category_ID = MN.Merchant_Category_ID
JOIN
	Credit_Card CC
ON CC.Credit_Card_Number = TR.Credit_Card_Number
JOIN
	Card_Holder CH
ON CH.Card_Holder_ID = CC.Card_Holder_ID
WHERE
	Card_Holder_NAME like ('%crystal clark') 
ORDER BY
	TransactionDate
GO