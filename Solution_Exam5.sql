/*
1. Show the total sales per territory 7 day from any given date.
2. Do not use a date range. Get the past 7 days from a given date
*/
DECLARE @date DATETIME
SET @date = '07-01-2005';

WITH Exam5 (ROW_NUM,OrderDate,TerritoryID,Name,TotalSales)
AS
(
	select ROW_NUMBER () OVER (PARTITION BY b.TerritoryID
ORDER BY SUM(a.OrderQty * a.UnitPrice)Desc) AS ROW_NUM,
	b.OrderDate,
	b.TerritoryID,
	c.Name,
	SUM(a.OrderQty * a.UnitPrice) as TotalSales
	from Sales.SalesOrderDetail a 
	JOIN Sales.SalesOrderHeader b
	ON a.SalesOrderDetailID = b.SalesOrderID 
	JOIN Sales.SalesTerritory c
	ON  b.TerritoryID = c.TerritoryID AND
    b.OrderDate Between @date and dateadd(Day, 7, @date)
	Group BY b.TerritoryID,b.OrderDate,c.Name
)
select TerritoryID,Name,TotalSales
from Exam5
where ROW_NUM = 1 