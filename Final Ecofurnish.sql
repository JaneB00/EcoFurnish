--List all Product available in the inventory
select * from dimproduct;

--Find the total number of customers in the database.
select count (*) as TotalCustomers from dimcustomer;

--Display distinct categories of products sold.
select * from dimproduct;
select distinct category from dimproduct;

--Identify customers who signed up in 2023.
select * from dimcustomer;
select firstname, lastname, signupyear from dimcustomer
where signupyear = 2023;
-- came out blank because no customer signed up in 2023
select firstname, lastname, signupyear from dimcustomer
where signupyear = 2022;

--List products priced above $500. also for a range of 200 and 500
select * from dimproduct;
select productid, productname, price from dimproduct
where price > 500;
select productid, productname, price from dimproduct
where price between 200 and 500;

--Show products with less than 50 items in stock.
select * from dimproduct;
select productid, productname, stockquantity from dimproduct
where stockquantity < 50;

--List all sales transactions.
select * from factsales;

--Count the total number of sales transactions.
select count (*) as TotalSales from factsales;

--List customer emails that contain 'gmail'.
select email from dimcustomer
where email like '%cus%';

--Display the top 10 most expensive products.
select * from dimproduct
order by price desc
limit 10;

--Find the average sale amount per transaction.
select round (avg (saleamount),2) as avgsales from factsales;

--Calculate the total revenue generated from sales.
select round (sum(saleamount),2) as totalRevenue from factsales;

--Round the average price of all the products to 2 decimal places.
select round (avg (price),2) as avgprice from dimproduct;

--Display all products with 'Eco' in the product name.
select * from dimproduct
where productname ilike '%Eco%';
-- came out blank as no product has "Eco" in their name

--List the first 5 sales transactions in ascending order of SaleAmount.
select * from factsales
order by saleamount asc
limit 5;

--Display products priced between $100 and $300.
select * from dimproduct
where price between 100 and 300;

--Count the number of products in each category.
select category, count(productid) from dimproduct
group by category;

--Calculate the minimum, maximum, and average price of products in each category.
select category, Min(price) from dimproduct
group by category;

select category, Max(price) from dimproduct
group by category;

select category, round (Avg(price),2) from dimproduct
group by category;

--List all sales transactions between January 1, 2023, and December 31,2023.
select * from factsales
where saledate between '2023-01-01' and '2023-12-31';

--Find the total quantity of products sold for each product.
select productid, count(quantitysold) from factsales
group by productid
order by productid asc;
-- returned only for 19 products out of 20, productid 6 wasn't sold at all


--IDENTIFYING top 5 LOYAL CUSTOMERS
-- at least 5 purchases in the past year showing their total spend.
select customerid,quantitysold,saleamount from factsales
where quantitysold >= 5
limit 5;
--No customer has made up to 5 purchases. The Highest purchase made was 4

--analyze the sales data to recommend which product categories should be highlighted in the promotional campaign based on their profitability.
SELECT
    category,
    SUM(saleamount) AS total_sales_amount,
    SUM(saleamount - price) AS total_profit
FROM
    factsales , dimProduct 
WHERE
   factsales.productid = dimproduct.productid 
GROUP BY
    category
ORDER BY
    total_profit DESC;

-- Determine the average sale amount for each product category.
SELECT dimproduct.Category, AVG(factsales.SaleAmount) AS AverageSaleAmount
FROM DimProduct
INNER JOIN FactSales ON dimproduct.ProductID = factsales.ProductID
GROUP BY dimproduct.Category;

-- List customers and their purchase counts who have bought more than 3 items.
SELECT dimcustomer.FirstName, dimcustomer.LastName, COUNT(factsales.SaleID) AS NumberOfPurchases
FROM DimCustomer
INNER JOIN FactSales ON dimcustomer.CustomerID = factsales.CustomerID
GROUP BY dimcustomer.CustomerID
HAVING COUNT(factsales.SaleID) > 3;

-- List all products and any sales data, including products that have not been sold and sales without a linked product.
SELECT dimproduct.ProductName, factsales.SaleID, factsales.SaleAmount
FROM DimProduct 
FULL OUTER JOIN FactSales ON dimproduct.ProductID = factsales.ProductID;

-- Show all customers and any sales transactions, including customers with no purchases.
SELECT dimcustomer.FirstName, dimcustomer.LastName, factsales.SaleID
FROM DimCustomer
FULL OUTER JOIN FactSales ON dimcustomer.CustomerID = factsales.CustomerID;

-- Find total sales and stock quantities for all products, including those never sold.
SELECT dimproduct.ProductName, SUM(factsales.QuantitySold) AS TotalSold, dimproduct.StockQuantity
FROM DimProduct
FULL OUTER JOIN FactSales ON dimproduct.ProductID = factsales.ProductID
GROUP BY dimproduct.ProductName, dimproduct.StockQuantity;

--List all sales transactions and match them with product information, including sales with unlisted products.
SELECT factsales.SaleID, dimproduct.ProductName, dimproduct.Price
FROM FactSales
RIGHT JOIN DimProduct ON factsales.ProductID = dimproduct.ProductID;

--Show every product and its last sale date, including products that have never been sold.
SELECT dimproduct.ProductName, MAX(factsales.SaleDate) AS LastSaleDate
FROM DimProduct
RIGHT JOIN FactSales ON dimproduct.ProductID = factsales.ProductID
GROUP BY dimproduct.ProductName;

--Show all products along with any customers who have purchased them, including products that have not been purchased by any customer.
SELECT dp.ProductName, dc.FirstName, dc.LastName
FROM DimProduct dp
LEFT JOIN FactSales fs ON dp.ProductID = fs.ProductID
LEFT JOIN DimCustomer dc ON fs.CustomerID = dc.CustomerID;

--Identify products that have never been sold.
SELECT dp.ProductName
FROM DimProduct dp
LEFT JOIN FactSales fs ON dp.ProductID = fs.ProductID
WHERE fs.SaleID IS NULL;

--Find customers who have not made any purchases.
SELECT dc.FirstName, dc.LastName
FROM DimCustomer dc
LEFT JOIN FactSales fs ON dc.CustomerID = fs.CustomerID
WHERE fs.SaleID IS NULL;