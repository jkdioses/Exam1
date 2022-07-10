/*
1. Create a select statement or stored prcedure that queries the products table 2 Display the results
of the query / stored procedure in a paginated manner.
2. Pagination should be x number of records / page
*/

--exec spGetProducts 10,0,0,'asc'
--select count(*) from Production.Product
create proc spGetProducts
@DisplayLength int,
@DisplayStart int,
@SortCol int,
@SortDir nvarchar(10)
as
begin
    Declare @FirstRec int, @LastRec int
    Set @FirstRec = @DisplayStart;
    Set @LastRec = @DisplayStart + @DisplayLength;
   
    With CTE_Product as
    (
         Select ROW_NUMBER() over (order by @SortCol 
         )
         as RowNum,
         COUNT(*) over() as TotalCount,
         *
         from Production.Product
    )
    Select *
    from CTE_Product
    where RowNum > @FirstRec and RowNum <= @LastRec
end
