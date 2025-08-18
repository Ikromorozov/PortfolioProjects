--this sql provides insight into sales data

select * 
from portfolio..Worksheet
order by 3


--most sold product
select [Product Name], SUM(cast(quantity as int))
from portfolio.dbo.Worksheet
group by [Product Name]
order by 2 desc


-- average profit per order
select AVG(profit) 
from portfolio.dbo.Worksheet


--most profitable product in sum and average per quantity
select [Product Name], SUM(cast(Profit as int)), AVG((cast(Profit as int))/(cast(Quantity as int)))
from portfolio.dbo.Worksheet
group by [Product Name]
order by 2 desc


--most profitable product in average per quantity
select [Product Name], AVG((cast(Profit as int))/(cast(Quantity as int)))
from portfolio.dbo.Worksheet
group by [Product Name]
order by 2 desc


--most profitable product category in sum
select [Category], SUM(cast(profit as int))
from portfolio.dbo.Worksheet
group by [Category]
order by 2 desc

--most profitable product sub-category in sum
select [Sub-category], SUM(cast(profit as int))
from portfolio.dbo.Worksheet
group by [Sub-category]
order by 2 desc


-- customer segments which are the most profitable
select Segment, SUM(convert(int, Profit)) as [Sum of profit]
from portfolio..Worksheet
group by Segment
order by 2 desc

--Correlation between discount and profit (there is no built-in function for it in sql server management studio)
SELECT
(COUNT(*) * SUM(discount * profit) - SUM(discount) * SUM(profit)) /
(SQRT(COUNT(*) * SUM(POWER(discount, 2)) - POWER(SUM(discount), 2)) *
SQRT(COUNT(*) * SUM(POWER(profit, 2)) - POWER(SUM(profit), 2))) AS correlation_coefficient
FROM    portfolio..Worksheet


--looking at which state has the most profits
select State, SUM(cast(profit as int))
from portfolio.dbo.Worksheet
group by State
order by 2 desc

--create view
Create view MonthlyTrends as 
SELECT
    FORMAT([Order Date], 'yyyy-MM') AS OrderMonth,
    SUM([Sales]) AS TotalSales
FROM portfolio.dbo.Worksheet
GROUP BY FORMAT([Order Date], 'yyyy-MM')

--average delays by shipping mode
SELECT
    [Ship Mode],
    AVG(DATEDIFF(DAY, [Order Date], [Ship Date])) AS AvgShippingDelay
FROM portfolio.dbo.Worksheet
GROUP BY [Ship Mode]
ORDER BY AvgShippingDelay DESC;

