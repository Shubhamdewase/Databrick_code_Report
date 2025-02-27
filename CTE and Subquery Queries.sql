use AdventureWorksDW2022
select * from [dbo].[DimCustomer]
------- Current year vs preivious year sales with CTE---
WITH FactInternetSalesCTE As(
select productkey,
customerkey,
salesamount
 as Current_year_sales,
lag(Salesamount) over (order by orderdate asc) Previous_year_sales
 from FactInternetSales
 )
 select productkey,
customerkey,Current_year_sales,Previous_year_sales
 from FactInternetSalesCTE;




 ----Rank with CTE ---
 
 WITH RankCTE as(
 select productkey,
customerkey,
salesamount,
RANK() over( Order by Salesamount desc ) as rank
from factinternetsales
)
select productkey,
customerkey,
salesamount, 
rank from RankCTE
where rank = 1

  

-----dense_rank with CTE-----
  WITH Dense_RankCTE as(
 select productkey,
customerkey,
salesamount,
 dense_rank() over( Order by salesamount desc ) as dense_rank 
from factinternetsales
)
select productkey,
customerkey,
salesamount,DENSE_RANK
from Dense_RankCTE
where Dense_Rank = 2

-----Row Number With CTE----
WITH Row_number_CTE As(
 select FirstName,
customerkey,
MaritalStatus,
emailaddress,EnglishEducation,
row_number() over( partition by  EnglishEducation order by Yearlyincome asc ) as Row_Number
from DimCustomer
)
select FirstName,
customerkey,
MaritalStatus,
emailaddress,EnglishEducation ,ROW_NUMBER
from  Row_number_CTE




------Ntile with CTE---
 select FirstName,
customerkey,
MaritalStatus,
emailaddress,
ntile(50) Over (order by Yearlyincome desc) as Ntile
from DimCustomer


------- Current year vs preivious year sales with Subquery -------
select 
    productkey,
    customerkey,
    CurrentYearSales,
    PreviousYearSales
from (
    select
        productkey,
        customerkey,
        salesamount as CurrentYearSales,
        LAG(SalesAmount) over(order by orderdate asc) As PreviousYearSales
        from FactInternetSales
) As FactInternetSalesSub;

 ----Rank with subquery  ---

select 
    productkey,
    customerkey,
    salesamount,
    rank
from(
    select
        productkey,
        customerkey,
        salesamount,
        RANK() over  (order by Salesamount desc) As rank
    from FactInternetSales
) As RankSub
where rank = 1;


-----Dense_rank with Subquery----

select
    productkey,
    customerkey,
    salesamount,
    dense_rank
from (
    select 
        productkey,
        customerkey,
        salesamount,
        DENSE_RANK() over (order by salesamount desc) As dense_rank
    from FactInternetSales
) As DenseRankSub
where dense_rank = 2;


-----Row_Number with subquery----
Select  
    FirstName,
    customerkey,
    MaritalStatus,
    emailaddress,
    EnglishEducation,
    Row_Number
from (
    select
        FirstName,
        customerkey,
        MaritalStatus,
        emailaddress,
        EnglishEducation,
        ROW_NUMBER()over (partition by EnglishEducation order by Yearlyincome Asc) As Row_Number
    from DimCustomer
) As RowNumberSub
where Row_Number = 2;

----Ntile with subquery------
select 
    FirstName,
    customerkey,
    MaritalStatus,
    emailaddress,
    Ntile
from (
    select 
        FirstName,
        customerkey,
        MaritalStatus,
        emailaddress,
        Ntile(100)over (order by Yearlyincome Desc) As Ntile
    from DimCustomer
) As NtileSub;






