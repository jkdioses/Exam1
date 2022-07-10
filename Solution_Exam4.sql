--show the list customers per territory who didn’t place an order in any given 30-day range

WITH EXAM4 (rownum,ShipToAddressID,OrderDate,ordermonth,TerritoryID)
AS
(
select ROW_NUMBER() OVER(PARTITION BY a.ShipToAddressID ORDER BY a.TerritoryID) as rownum,
a.ShipToAddressID,

a.OrderDate,
d.ordermonth,
a.TerritoryID
from Sales.SalesOrderHeader a
cross join (select distinct datefromparts(year(OrderDate), month(OrderDate), 1) ordermonth from Sales.SalesOrderHeader) d
where  not exists (
    select 1 
    from Sales.SalesOrderHeader b
    where 
        b.OrderDate > d.ordermonth 
        and b.OrderDate < dateadd(day, 30, d.ordermonth)
        and b.ShipToAddressID= a.ShipToAddressID

)

group by d.ordermonth,a.ShipToAddressID,a.TerritoryID,a.OrderDate
)
SELECT ShipToAddressID, OrderDate, TerritoryID
FROM EXAM4
WHERE rownum = 1
ORDER BY TerritoryID, ShipToAddressID
;