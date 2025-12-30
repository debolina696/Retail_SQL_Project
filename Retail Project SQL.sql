/* =====================================================
   STEP 2: CREATE DATABASE
===================================================== */

CREATE DATABASE Retail_Sales_Analytics;
GO

USE Retail_Sales_Analytics;
GO

/* =====================================================
   TABLE 1: Customers
===================================================== */

CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15),
    City VARCHAR(50),
    RegistrationDate DATE NOT NULL DEFAULT GETDATE()
);

/* =====================================================
   TABLE 2: Products
===================================================== */

CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) CHECK (Price > 0),
    CreatedDate DATE DEFAULT GETDATE()
);

/* =====================================================
   TABLE 3: Orders
===================================================== */

CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    OrderStatus VARCHAR(20) 
        CHECK (OrderStatus IN ('Placed', 'Shipped', 'Delivered', 'Cancelled')),
    CONSTRAINT FK_Orders_Customers 
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

/* =====================================================
   TABLE 4: Order_Items
===================================================== */

CREATE TABLE Order_Items (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) CHECK (UnitPrice > 0),
    CONSTRAINT FK_OrderItems_Orders 
        FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderItems_Products 
        FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

/* =====================================================
   SCHEMA VALIDATION
===================================================== */

SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM Order_Items;
/* =====================================================
   INSERT DATA: Customers
===================================================== */

INSERT INTO Customers (CustomerName, Email, Phone, City, RegistrationDate)
VALUES
('Amit Sharma', 'amit.sharma@gmail.com', '9876543210', 'Delhi', '2024-01-10'),
('Neha Verma', 'neha.verma@gmail.com', '9876543211', 'Mumbai', '2024-02-15'),
('Rahul Singh', 'rahul.singh@gmail.com', '9876543212', 'Bangalore', '2024-03-05'),
('Pooja Mehta', 'pooja.mehta@gmail.com', '9876543213', 'Ahmedabad', '2024-01-25'),
('Ankit Roy', 'ankit.roy@gmail.com', '9876543214', 'Kolkata', '2024-04-01'),
('Sneha Iyer', 'sneha.iyer@gmail.com', '9876543215', 'Chennai', '2024-02-20'),
('Vikas Malhotra', 'vikas.m@gmail.com', '9876543216', 'Delhi', '2024-03-18'),
('Riya Kapoor', 'riya.kapoor@gmail.com', '9876543217', 'Pune', '2024-04-05'),
('Kunal Jain', 'kunal.j@gmail.com', '9876543218', 'Jaipur', '2024-01-30'),
('Meera Nair', 'meera.nair@gmail.com', '9876543219', 'Kochi', '2024-02-08');

/* =====================================================
   INSERT DATA: Products
===================================================== */

INSERT INTO Products (ProductName, Category, Price, CreatedDate)
VALUES
('Wireless Mouse', 'Electronics', 899.00, '2024-01-01'),
('Bluetooth Headphones', 'Electronics', 2499.00, '2024-01-05'),
('Laptop Backpack', 'Accessories', 1299.00, '2024-01-10'),
('Office Chair', 'Furniture', 6499.00, '2024-02-01'),
('Standing Desk', 'Furniture', 15999.00, '2024-02-10'),
('Smart Watch', 'Electronics', 4999.00, '2024-03-01'),
('Notebook Set', 'Stationery', 299.00, '2024-03-05'),
('Water Bottle', 'Accessories', 499.00, '2024-03-10'),
('Desk Lamp', 'Furniture', 1999.00, '2024-03-15'),
('USB-C Cable', 'Electronics', 399.00, '2024-04-01');

/* =====================================================
   INSERT DATA: Orders
===================================================== */

INSERT INTO Orders (CustomerID, OrderDate, OrderStatus)
VALUES
(1, '2024-04-01', 'Delivered'),
(2, '2024-04-03', 'Shipped'),
(3, '2024-04-05', 'Placed'),
(4, '2024-04-06', 'Delivered'),
(5, '2024-04-07', 'Cancelled'),
(6, '2024-04-08', 'Delivered'),
(7, '2024-04-10', 'Shipped'),
(8, '2024-04-11', 'Placed'),
(9, '2024-04-12', 'Delivered'),
(10, '2024-04-13', 'Placed');

/* =====================================================
   INSERT DATA: Order_Items
===================================================== */

INSERT INTO Order_Items (OrderID, ProductID, Quantity, UnitPrice)
VALUES
(1, 1, 2, 899.00),
(1, 7, 3, 299.00),
(2, 2, 1, 2499.00),
(3, 3, 1, 1299.00),
(4, 4, 1, 6499.00),
(4, 10, 2, 399.00),
(6, 6, 1, 4999.00),
(7, 8, 2, 499.00),
(9, 5, 1, 15999.00),
(10, 9, 1, 1999.00);

/* =====================================================
   DATA CHECK
===================================================== */

SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM Order_Items;
/* =====================================================
   GROUP A – BASIC & CORE SQL QUESTIONS & SOLUTIONS
===================================================== */

-------------------------------------------------------
-- A1. Add a new column LoyaltyPoints to Customers table
-------------------------------------------------------
ALTER TABLE Customers
ADD LoyaltyPoints INT DEFAULT 0;


-------------------------------------------------------
-- A2. Add CHECK constraint to ensure product price > 0
-------------------------------------------------------
ALTER TABLE Products
ADD CONSTRAINT CHK_Products_Price
CHECK (Price > 0);


-------------------------------------------------------
-- A3. Add FOREIGN KEY using ALTER on Orders table
-------------------------------------------------------
-- A3. Add FOREIGN KEY using ALTER (safe check)
IF NOT EXISTS (
    SELECT 1 
    FROM sys.foreign_keys 
    WHERE name = 'FK_Orders_Customers'
)
BEGIN
    ALTER TABLE Orders
    ADD CONSTRAINT FK_Orders_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers(CustomerID);
END;


-------------------------------------------------------
-- A4. Update loyalty points for customers with delivered orders
-------------------------------------------------------
UPDATE Customers
SET LoyaltyPoints = LoyaltyPoints + 100
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Orders
    WHERE OrderStatus = 'Delivered'
);


-------------------------------------------------------
-- A5. Calculate number of days since customer registration
-------------------------------------------------------
SELECT 
    CustomerName,
    RegistrationDate,
    DATEDIFF(DAY, RegistrationDate, GETDATE()) AS Days_Since_Registration
FROM Customers;


-------------------------------------------------------
-- A6. Extract month and year from order date
-------------------------------------------------------
SELECT 
    OrderID,
    OrderDate,
    MONTH(OrderDate) AS Order_Month,
    YEAR(OrderDate) AS Order_Year
FROM Orders;


-------------------------------------------------------
-- A7. Retrieve TOP 5 most expensive products
-------------------------------------------------------
SELECT TOP 5
    ProductName,
    Category,
    Price
FROM Products
ORDER BY Price DESC;


-------------------------------------------------------
-- A8. Retrieve bottom 3 cheapest products
-------------------------------------------------------
SELECT TOP 3
    ProductName,
    Price
FROM Products
ORDER BY Price ASC;


-------------------------------------------------------
-- A9. Rename column CreatedDate to ProductCreatedDate
-------------------------------------------------------
EXEC sp_rename 
    'Products.CreatedDate', 
    'ProductCreatedDate', 
    'COLUMN';


-------------------------------------------------------
-- A10. Add NOT NULL constraint to OrderStatus column
-------------------------------------------------------
ALTER TABLE Orders
ALTER COLUMN OrderStatus VARCHAR(20) NOT NULL;


-------------------------------------------------------
-- A11. Calculate order age in days
-------------------------------------------------------
SELECT 
    OrderID,
    OrderDate,
    DATEDIFF(DAY, OrderDate, GETDATE()) AS Order_Age_Days
FROM Orders;


-------------------------------------------------------
-- A12. Fetch orders placed in the last 7 days
-------------------------------------------------------
SELECT *
FROM Orders
WHERE OrderDate >= DATEADD(DAY, -7, GETDATE());


-------------------------------------------------------
-- A13. Increase product price by 10% for Electronics category
-------------------------------------------------------
UPDATE Products
SET Price = Price * 1.10
WHERE Category = 'Electronics';


-------------------------------------------------------
-- A14. Add UNIQUE constraint on customer email
-------------------------------------------------------
ALTER TABLE Customers
ADD CONSTRAINT UQ_Customers_Email UNIQUE (Email);


-------------------------------------------------------
-- A15. Delete cancelled orders from Orders table
-------------------------------------------------------
DELETE FROM Orders
WHERE OrderStatus = 'Cancelled';

/* B1. Show all orders with customer details */
SELECT o.OrderID, c.CustomerName, c.City, o.OrderDate, o.OrderStatus
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID;

/* B2. Show order items with product details */
SELECT oi.OrderItemID, oi.OrderID, p.ProductName, p.Category, oi.Quantity, oi.UnitPrice
FROM Order_Items oi
JOIN Products p ON oi.ProductID = p.ProductID;

/* B3. Show customer, order and product purchased */
SELECT c.CustomerName, o.OrderID, p.ProductName, oi.Quantity, oi.UnitPrice
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Order_Items oi ON o.OrderID = oi.OrderID
JOIN Products p ON oi.ProductID = p.ProductID;

/* B4. Total amount per order */
SELECT o.OrderID, SUM(oi.Quantity * oi.UnitPrice) AS TotalOrderAmount
FROM Orders o
JOIN Order_Items oi ON o.OrderID = oi.OrderID
GROUP BY o.OrderID;

/* B5. Total spending by each customer */
SELECT c.CustomerName, SUM(oi.Quantity * oi.UnitPrice) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Order_Items oi ON o.OrderID = oi.OrderID
GROUP BY c.CustomerName
ORDER BY TotalSpent DESC;

/* B6. Total sales by product */
SELECT p.ProductName, SUM(oi.Quantity * oi.UnitPrice) AS TotalSales
FROM Products p
JOIN Order_Items oi ON p.ProductID = oi.ProductID
GROUP BY p.ProductName
ORDER BY TotalSales DESC;

/* B7. Delivered orders with customer name */
SELECT o.OrderID, c.CustomerName, o.OrderDate
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.OrderStatus = 'Delivered';

/* B8. Number of orders per customer */
SELECT c.CustomerName, COUNT(o.OrderID) AS TotalOrders
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerName;

/* B9. Top 3 customers by total spend */
SELECT TOP 3 c.CustomerName, SUM(oi.Quantity * oi.UnitPrice) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Order_Items oi ON o.OrderID = oi.OrderID
GROUP BY c.CustomerName
ORDER BY TotalSpent DESC;

/* B10. View: Customer Sales Summary */
CREATE VIEW vw_CustomerSalesSummary AS
SELECT c.CustomerID, c.CustomerName,
       SUM(oi.Quantity * oi.UnitPrice) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Order_Items oi ON o.OrderID = oi.OrderID
GROUP BY c.CustomerID, c.CustomerName;
--------- Group C --------------------
/* C1. Categorize customers based on total spend using CASE */
SELECT c.CustomerName,
       SUM(oi.Quantity * oi.UnitPrice) AS TotalSpent,
       CASE
           WHEN SUM(oi.Quantity * oi.UnitPrice) >= 5000 THEN 'High Value'
           WHEN SUM(oi.Quantity * oi.UnitPrice) BETWEEN 2000 AND 4999 THEN 'Medium Value'
           ELSE 'Low Value'
       END AS CustomerCategory
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Order_Items oi ON o.OrderID = oi.OrderID
GROUP BY c.CustomerName;

/* C2. Use CTE to calculate total order value */
WITH OrderTotals AS (
    SELECT o.OrderID,
           SUM(oi.Quantity * oi.UnitPrice) AS OrderAmount
    FROM Orders o
    JOIN Order_Items oi ON o.OrderID = oi.OrderID
    GROUP BY o.OrderID
)
SELECT * FROM OrderTotals;

/* C3. Customers whose total spend is above average (Subquery) */
SELECT CustomerName
FROM Customers
WHERE CustomerID IN (
    SELECT o.CustomerID
    FROM Orders o
    JOIN Order_Items oi ON o.OrderID = oi.OrderID
    GROUP BY o.CustomerID
    HAVING SUM(oi.Quantity * oi.UnitPrice) >
           (SELECT AVG(Quantity * UnitPrice) FROM Order_Items)
);

/* C4. Orders with delivery status label using CASE */
SELECT OrderID, OrderDate,
       CASE
           WHEN OrderStatus = 'Delivered' THEN 'Completed'
           WHEN OrderStatus = 'Shipped' THEN 'In Transit'
           ELSE 'Pending'
       END AS OrderStage
FROM Orders;

/* C5. CTE to find total sales per product */
WITH ProductSales AS (
    SELECT p.ProductName,
           SUM(oi.Quantity * oi.UnitPrice) AS TotalSales
    FROM Products p
    JOIN Order_Items oi ON p.ProductID = oi.ProductID
    GROUP BY p.ProductName
)
SELECT * FROM ProductSales
ORDER BY TotalSales DESC;

/* C6. Customers who placed more than 1 order (Subquery) */
SELECT CustomerName
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Orders
    GROUP BY CustomerID
    HAVING COUNT(OrderID) > 1
);

/* C7. Orders with total amount greater than 3000 */
SELECT o.OrderID,
       SUM(oi.Quantity * oi.UnitPrice) AS OrderAmount
FROM Orders o
JOIN Order_Items oi ON o.OrderID = oi.OrderID
GROUP BY o.OrderID
HAVING SUM(oi.Quantity * oi.UnitPrice) > 3000;

/* C8. Product price category using CASE */
SELECT ProductName, Price,
       CASE
           WHEN Price >= 5000 THEN 'Premium'
           WHEN Price BETWEEN 2000 AND 4999 THEN 'Mid Range'
           ELSE 'Budget'
       END AS PriceCategory
FROM Products;

/* C9. Latest order date for each customer (Subquery) */
SELECT CustomerName,
       (SELECT MAX(OrderDate)
        FROM Orders o
        WHERE o.CustomerID = c.CustomerID) AS LastOrderDate
FROM Customers c;

/* C10. CTE to rank customers by spending */
WITH CustomerSpending AS (
    SELECT c.CustomerName,
           SUM(oi.Quantity * oi.UnitPrice) AS TotalSpent
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN Order_Items oi ON o.OrderID = oi.OrderID
    GROUP BY c.CustomerName
)
SELECT *
FROM CustomerSpending
ORDER BY TotalSpent DESC;
--------- Group D ----------------
  /* D1. Create a scalar UDF to calculate order total */
CREATE FUNCTION dbo.fn_OrderTotal (@OrderID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Total DECIMAL(10,2);
    SELECT @Total = SUM(Quantity * UnitPrice)
    FROM Order_Items
    WHERE OrderID = @OrderID;
    RETURN @Total;
END;


/* D2. Use UDF to display order totals */
SELECT 
    OrderID,
    dbo.fn_OrderTotal(OrderID) AS OrderTotal
FROM Orders;


/* D3. Create an AFTER INSERT trigger to update LoyaltyPoints */
CREATE TRIGGER trg_UpdateLoyaltyPoints
ON Orders
AFTER INSERT
AS
BEGIN
    UPDATE c
    SET LoyaltyPoints = LoyaltyPoints + 50
    FROM Customers c
    JOIN inserted i ON c.CustomerID = i.CustomerID;
END;


/* D4. Verify trigger impact */
SELECT CustomerID, CustomerName, LoyaltyPoints
FROM Customers;


/* D5. Subquery to find customers who placed highest order value */
SELECT CustomerName
FROM Customers
WHERE CustomerID IN (
    SELECT o.CustomerID
    FROM Orders o
    JOIN Order_Items oi ON o.OrderID = oi.OrderID
    GROUP BY o.CustomerID
    HAVING SUM(oi.Quantity * oi.UnitPrice) =
           (SELECT MAX(TotalAmt)
            FROM (
                SELECT SUM(Quantity * UnitPrice) AS TotalAmt
                FROM Order_Items
                GROUP BY OrderID
            ) t)
);


/* D6. Window function to rank customers by total spend */
SELECT CustomerName,
       SUM(oi.Quantity * oi.UnitPrice) AS TotalSpent,
       RANK() OVER (ORDER BY SUM(oi.Quantity * oi.UnitPrice) DESC) AS SpendRank
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Order_Items oi ON o.OrderID = oi.OrderID
GROUP BY CustomerName;


/* D7. Window function to calculate running revenue */
SELECT o.OrderDate,
       SUM(oi.Quantity * oi.UnitPrice) AS DailyRevenue,
       SUM(SUM(oi.Quantity * oi.UnitPrice))
       OVER (ORDER BY o.OrderDate) AS RunningRevenue
FROM Orders o
JOIN Order_Items oi ON o.OrderID = oi.OrderID
GROUP BY o.OrderDate;


/* D8. Find customers whose spend is above average (subquery) */
SELECT CustomerName
FROM Customers
WHERE CustomerID IN (
    SELECT o.CustomerID
    FROM Orders o
    JOIN Order_Items oi ON o.OrderID = oi.OrderID
    GROUP BY o.CustomerID
    HAVING SUM(oi.Quantity * oi.UnitPrice) >
           (SELECT AVG(Quantity * UnitPrice) FROM Order_Items)
);


/* D9. Stored Procedure to get customer purchase summary */
CREATE PROCEDURE sp_CustomerSummary
AS
BEGIN
    SELECT c.CustomerName,
           COUNT(DISTINCT o.OrderID) AS TotalOrders,
           SUM(oi.Quantity * oi.UnitPrice) AS TotalSpent
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN Order_Items oi ON o.OrderID = oi.OrderID
    GROUP BY c.CustomerName;
END;


/* D10. Execute stored procedure */
EXEC sp_CustomerSummary;