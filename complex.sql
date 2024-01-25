-- Active: 1705902334791@@127.0.0.1@3306@classicmodels
SELECT *
FROM customers;
SELECT *
FROM employees;
SELECT *
FROM offices;
SELECT *
FROM orderdetails;
SELECT *
FROM orders;
SELECT *
FROM payments;
SELECT *
FROM productlines;
SELECT *
FROM products;
-- 
-- TODO: Find the total number of orders placed by each customer, along with their contact details.
SELECT c.customerNumber,
    c.customerName,
    c.contactFirstName,
    c.contactLastName,
    c.phone,
    c.addressLine1,
    c.addressLine2,
    c.city,
    c.state,
    c.postalCode,
    c.country,
    COUNT(o.orderNumber) AS totalOrders
FROM customers AS c
    LEFT JOIN orders AS o ON o.customerNumber = c.customerNumber
GROUP BY c.customerNumber
ORDER BY totalOrders DESC;
-- TODO: Retrieve the top 5 products with the highest total sales amount.
SELECT p.productCode,
    p.productName,
    SUM(od.quantityOrdered * od.priceEach) AS totalSalesAmount
FROM products p
    JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode
ORDER BY totalSalesAmount DESC
LIMIT 5;
-- TODO: For each product line, find the average quantity ordered and the total revenue generated from orders.
SELECT p.`productCode`,
    AVG(od.`quantityOrdered`) AS avgQuantityOrdered,
    SUM(od.`quantityOrdered` * od.`priceEach`) AS totalRevenue
FROM products AS p
    LEFT JOIN orderdetails od ON od.`productCode` = p.`productCode`
GROUP BY p.`productCode`;
-- TODO: Identify customers who have not placed any orders.
SELECT c.`customerNumber`,
    c.`customerName`,
    c.`phone`,
    COUNT(o.`orderNumber`) AS totalOrders
FROM customers AS c
    LEFT JOIN orders AS o ON o.`customerNumber` = c.`customerNumber`
GROUP BY c.`customerNumber`
HAVING totalOrders = 0;
ORDER BY COUNT(o.`orderNumber`) ASC;
-- TODO: Calculate the total revenue and profit for each order, considering the product cost and selling price.
SELECT od.`orderNumber`,
    od.`priceEach`,
    p.`buyPrice`,
    SUM(od.`priceEach` * od.`quantityOrdered`) AS totalRevenue,
    SUM(
        (od.`priceEach` - p.`buyPrice`) * od.`quantityOrdered`
    ) AS totalProfit
FROM orderdetails AS od
    LEFT JOIN products AS p ON od.productCode = p.productCode
GROUP BY od.orderNumber;
-- TODO: Find the employee(s) who has/have processed the highest number of orders.
SELECT c.`customerName`,
    c.`customerNumber`,
    c.`phone`,
    COUNT(*) AS total_orders
FROM customers AS c
    LEFT JOIN orders AS o ON c.`customerNumber` = o.`customerNumber`
GROUP BY c.`customerNumber`
ORDER BY total_orders DESC
LIMIT 1;
-- TODO: List the offices with the highest and lowest total sales amount.
-- TODO: For each product, calculate the average time taken between order placement and delivery.
SELECT p.`productCode`,
    od.`orderNumber`,
    AVG(DATEDIFF(o.`shippedDate`, o.`orderDate`)) AS avgTimeTaken
FROM products p
    LEFT JOIN orderdetails AS od ON od.`productCode` = p.`productCode`
    LEFT JOIN orders AS o ON od.`orderNumber` = o.`orderNumber`
GROUP BY p.`productCode`;
-- TODO: Determine the month with the highest sales, considering the total order amount for that month.
SELECT EXTRACT(
        MONTH
        FROM o.`orderDate`
    ) AS month,
    EXTRACT(
        YEAR
        FROM o.`orderDate`
    ) AS year,
    COUNT(*) AS totalOrders,
    SUM(od.`priceEach` * od.`quantityOrdered`) AS totalSales
FROM orders AS o
    LEFT JOIN orderdetails AS od ON od.`orderNumber` = o.`orderNumber`
GROUP BY month,
    year;
-- TODO: Find the customers who have made payments for orders but have not received the products.
-- TODO: List the products that have not been ordered by any customer.
SELECT p.`productCode`,
    p.`productName`,
    p.`quantityInStock`,
    p.`buyPrice`,
    od.`productCode`
FROM products AS p
    LEFT JOIN orderdetails AS od ON p.`productCode` = od.`productCode`
GROUP BY od.`orderNumber`
HAVING od.`orderNumber` IS NULL;
--TODO: Calculate the average time taken for each product to go from order placement to delivery, considering only successfully delivered products.
SELECT p.`productCode`,
    p.`productName`,
    AVG(DATEDIFF(o.`shippedDate`, o.`orderDate`)) AS avgTime,
    o.status AS status
FROM products AS p
    LEFT JOIN orderdetails AS od ON od.`productCode` = p.`productCode`
    LEFT JOIN orders AS o ON o.`orderNumber` = od.`orderNumber`
WHERE o.`status` = 'Shipped'
GROUP BY p.`productCode`
HAVING avgTime IS NOT NULL;
-- TODO: Find the customers who have placed orders with a total value exceeding the average order value across all customers.
SELECT c.`customerNumber`,
    SUM(od.`priceEach` * od.`quantityOrdered`) AS totalOrderValue
FROM customers AS c
    LEFT JOIN orders AS o ON o.`customerNumber` = c.`customerNumber`
    LEFT JOIN orderdetails AS od ON od.`orderNumber` = o.`orderNumber`
GROUP BY c.`customerNumber`
HAVING totalOrderValue > (
        SELECT AVG(ndd.`priceEach` * ndd.`quantityOrdered`) AS avgOrderValue
        FROM orderdetails AS ndd
    )
ORDER BY c.`customerNumber` DESC;
-- give complex query
-- TODO: Identify products that have experienced a significant increase or decrease in sales quantity compared to the previous month.
SELECT p.`productCode`,
    p.`productName`,
    EXTRACT(
        MONTH
        FROM o.`orderDate`
    ) AS month,
    SUM(od.`quantityOrdered`) AS totalQuantity
FROM products AS p
    LEFT JOIN orderdetails AS od On p.`productCode` = od.`productCode`
    LEFT JOIN orders AS o ON o.`orderNumber` = od.`orderNumber`
GROUP BY p.`productCode`,
    month;
-- TODO: List the top 5 product lines with the highest average sales quantity per order.
SELECT p.`productCode`,
    od.`quantityOrdered`
FROM products AS p
    LEFT JOIN orderdetails AS od ON p.`productCode` = od.`productCode`
ORDER BY od.`quantityOrdered` DESC
LIMIT 5;
--TODO: Find the customers who have placed orders for products from at least three different product lines in a single order.
SELECT c.`customerNumber`,
    o.`orderNumber`,
    COUNT(*) AS totalProducts
FROM customers AS c
    LEFT JOIN orders AS o ON c.`customerNumber` = o.`customerNumber`
    LEFT JOIN orderdetails AS od ON o.`orderNumber` = od.`orderNumber`
GROUP BY od.`orderNumber`
HAVING totalProducts >= 3
ORDER BY totalProducts ASC;
--TODO: For each product line, find the top-selling product in terms of the total quantity sold.
SELECT p.`productName`,
    p.`productCode`,
    SUM(od.`quantityOrdered`) AS totalQuantity
FROM products AS p
    LEFT JOIN orderdetails AS od ON od.`productCode` = p.`productCode`
GROUP BY od.`productCode`
ORDER BY totalQuantity DESC
LIMIT 1;
-- TODO : Identify the products that have been ordered every month in the last year. (Not solved yet)
SELECT od.`productCode`,
    o.`orderNumber`,
    o.`orderDate`,
    EXTRACT(
        MONTH
        FROM o.`orderDate`
    ) AS order_month
FROM orders AS o
    JOIN orderdetails AS od ON od.`orderNumber` = o.`orderNumber`
HAVING order_month IS NOT NULL
ORDER BY od.`productCode` ASC
LIMIT 1000000;
SELECT od.`productCode`,
    COUNT(DISTINCT MONTH(o.`orderDate`)) AS distinctMonths,
    GROUP_CONCAT(DISTINCT MONTH(o.`orderDate`)) AS orderedMonths
FROM orderdetails AS od
    LEFT JOIN orders AS o ON od.`orderNumber` = o.`orderNumber`
GROUP BY od.`productCode`
ORDER BY MONTH(o.`orderDate`) DESC
LIMIT 1000;
SELECT od.`orderNumber` AS orderNumber,
    o.`orderDate` AS orderDate,
    od.`productCode` AS productCode,
    EXTRACT(
        MONTH
        FROM o.`orderDate`
    ) AS orderMonth
FROM orders AS o
    LEFT JOIN orderdetails AS od ON od.`orderNumber` = o.`orderNumber`
HAVING od.`productCode` = 'S12_1099'
ORDER BY o.`orderDate`
LIMIT 10000;
-- TODO: