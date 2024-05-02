USE AdventureWorks2012
GO

--What is the total number of transactions in the SalesOrderHeader table.
SELECT 
	COUNT(*) as total_transactions 
FROM 
	Sales.SalesOrderHeader

--what are the unique product categories from the 'ProductCategory' table.
SELECT 
	DISTINCT name AS product_category
FROM
	Production.ProductCategory

--What is the average list price of all products.
SELECT 
	AVG(listprice) AS [Average list price]
FROM 
	Production.Product

--What are the top 10 customer ID based on their total order amount
SELECT TOP 10
	CustomerID, 
	SUM(totaldue) AS total_amount
FROM
	Sales.SalesOrderHeader
GROUP BY 
	CustomerID 
ORDER BY
	total_amount DESC

--What are the total sales amount for each year from the 'SalesOrderHeader' table.
SELECT 
	YEAR(ShipDate) as[Year]
	,SUM(totaldue)as [Sales amount by year] 
FROM 
	Sales.SalesOrderHeader 
GROUP BY
	YEAR(ShipDate)
ORDER BY 2 DESC
 
-- What are the top 10 most ordered products
SELECT 
	TOP 10 Name AS product, 
	COUNT(sd.SalesOrderID) AS total_orders 
FROM 
	Sales.SalesOrderHeader sh 
JOIN Sales.SalesOrderDetail AS sd ON sd.SalesOrderID = sh.SalesOrderID
join Production.Product pp ON pp.ProductID = sd.ProductID
GROUP BY 
	Name
ORDER BY 
	total_orders DESC

--What are the total sales amounts for each product category over the past year? and how do the product category rank each year
SELECT 
	Year,
	production_pc.Name AS product_category,
	SUM(OrderQty * UnitPrice) AS Total_sales,
	RANK() OVER(PARTITION BY (year) ORDER BY SUM(OrderQty * UnitPrice) DESC) AS product_cat_rank
FROM  
	(SELECT 
		SalesOrderID, 
		DATEPART(YEAR,OrderDate) AS year 
	FROM 
		Sales.SalesOrderHeader) AS subquery1,
		Sales.SalesOrderDetail AS sales_od
 JOIN Production.Product AS production_p on production_p.ProductID = sales_od.ProductID
 JOIN Production.ProductCategory AS production_pc ON production_pc.ProductCategoryID = production_p.ProductSubcategoryID 
GROUP BY 
	production_pc.Name, YEAR

--Which sales person met up with their quota, and how much did revenue did they generate
SELECT 
	full_name, OS.SalesQuota,SUM(UnitPrice*OrderQty) AS total_sales
FROM sales.SalesPerson AS sp,
	(SELECT 
		CONCAT(FirstName,' ',LastName) AS full_name, BusinessEntityID 
	 FROM 
		Person.Person) AS pp,
	(SELECT 
		SP.BusinessEntityID, SOD.OrderQty, UnitPrice,SP.SalesQuota
	FROM 
		Sales.SalesPerson SP 
	JOIN Sales.SalesOrderHeader SOH ON SP.BusinessEntityID = SOH.SalesPersonID
	JOIN Sales.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
	WHERE 
		SalesQuota IS NOT NULL) AS OS
WHERE 
	pp.BusinessEntityID = sp.BusinessEntityID AND
	SP.BusinessEntityID = OS.BUSINESSENTITYID --AND OS.SalesQuota IS NOT NULL
GROUP BY 
	sp.BusinessEntityID,full_name,OS.SalesQuota
HAVING 
	SUM(UnitPrice * OrderQty) > OS.SalesQuota

--What is the total cost,revenue, profit and profit percentage for each product
SELECT Name AS product, 
	total_cost,
	total_rev, 
	Profit,
	CONCAT(ROUND((Profit / Total_Rev) * 100,2),'%') AS Profit_Percentage 
FROM(
	select sod.ProductID ,
		SUM(StandardCost * OrderQty) as total_cost, 
		SUM(UnitPrice*OrderQty) AS total_rev, 
		(SUM(UnitPrice*OrderQty) - SUM(StandardCost * OrderQty)) AS Profit
	FROM 
		Sales.salesOrderDetail AS sod 
JOIN 
	Production.ProductCostHistory AS pch ON sod.productid = pch.productid
GROUP BY 
	sod.ProductID) AS subquery1,
	(SELECT 
		name, 
		ProductID 
	FROM 
		Production.Product AS product_name)as subquery2
	WHERE
		subquery1.ProductID = subquery2.ProductID
	GROUP BY 
		subquery1.ProductID, total_cost, total_rev,Profit,Name
