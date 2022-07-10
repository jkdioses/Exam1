-- Rank each territory according to total sales (unit price * quantity) for a given month
	---===========================================================
WITH Exam3 (RANK,Month,MonthNum,TerritoryName,TotalSales)
AS(

SELECT ROW_NUMBER () OVER (PARTITION BY DATENAME(month,OrderDate)
ORDER BY SUM(SalesOrderDetail.OrderQty * SalesOrderDetail.UnitPrice)Desc) AS RANK,
  DATENAME(month,OrderDate) Month,
  MONTH(OrderDate) as MonthNum,
  SalesTerritory.Name AS TerritoryName,
  SUM(SalesOrderDetail.OrderQty * SalesOrderDetail.UnitPrice) as TotalSales
FROM Sales.SalesTerritory
LEFt JOIN Sales.SalesOrderHeader
    ON (SalesTerritory.TerritoryID = SalesOrderHeader.TerritoryID)
JOIN Person.Person
    ON (Person.BusinessEntityID = SalesOrderHeader.SalesPersonID)
JOIN
  Sales.SalesOrderDetail
    ON (SalesOrderHeader.SalesOrderID = SalesOrderDetail.SalesOrderID)
	GROUP BY  SalesOrderHeader.TerritoryID,SalesTerritory.Name,OrderDate
    )
    SELECT  RANK, Month, TerritoryName, TotalSales 
    FROM    Exam3	
    WHERE   RANK <= 10
	ORDER BY MonthNum
	;