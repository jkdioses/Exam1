--Show the top selling product in terms order quantity of sales per product category for each month

WITH   Exam1 (ROW_NUM,Month,MonthNum,ProductID,ProductName,TotalQty)
          AS (
		  SELECT    ROW_NUMBER() OVER ( PARTITION BY DATENAME(month,OrderDate)
		  ORDER BY SUM(SalesOrderDetail.OrderQty) DESC ) AS ROW_NUM,
             DATENAME(month,OrderDate) Month,
			 Month(OrderDate) MonthNum,
		     SalesOrderDetail.ProductID,
			 Product.Name as ProductName,
			 SUM(SalesOrderDetail.OrderQty) as TotalQty
             FROM Sales.SalesOrderDetail
             JOIN Sales.SalesOrderHeader
                   ON (SalesOrderHeader.SalesOrderID = SalesOrderDetail.SalesOrderID)
			 JOIN Production.Product
		           ON (Product.ProductID=SalesOrderDetail.ProductID)
GROUP BY SalesOrderDetail.ProductID, OrderDate , Product.Name
             )
    SELECT   Month, ProductID, ProductName, TotalQty
    FROM    Exam1	
    WHERE   ROW_NUM = 1
	order by MonthNum
