-- Show the top performing person per territory per month in terms of total sales (unit price *quantity)
WITH Exam2 (ROW_NUM,Month,MonthNum,Name,TerritoryName,TotalSales)
AS(
SELECT ROW_NUMBER () OVER (PARTITION BY DATENAME(month,OrderDate)
ORDER BY SUM(SalesOrderDetail.OrderQty * SalesOrderDetail.UnitPrice)DESC) AS ROW_NUM,
  DATENAME(month,OrderDate) Month,
  MONTH(OrderDate) as MonthNum,
  CONCAT(Person.FirstName,' ',Person.MiddleName,' ',Person.LastName) AS Name,
  SalesTerritory.Name AS TerritoryName,
  SUM(SalesOrderDetail.OrderQty * SalesOrderDetail.UnitPrice) as TotalSales
FROM
  Sales.SalesOrderDetail
  JOIN
  Sales.SalesOrderHeader
    ON (SalesOrderHeader.SalesOrderID = SalesOrderDetail.SalesOrderID)
  JOIN Sales.SalesTerritory
	ON (SalesTerritory.TerritoryID = SalesOrderHeader.TerritoryID)
  JOIN Person.Person
    ON (Person.BusinessEntityID = SalesOrderHeader.SalesPersonID)
	GROUP BY SalesOrderHeader.SalesOrderID, SalesTerritory.Name,
	Person.FirstName,Person.MiddleName,Person.LastName,OrderDate

    )
    SELECT  Month, Name, TerritoryName, TotalSales
    FROM    Exam2	
    WHERE   ROW_NUM = 1
	ORDER BY MonthNum