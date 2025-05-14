/*
  QUESTION ONE: 1NF
*/

-- Create database and use it
CREATE DATABASE ProductOrderSystem;
USE ProductOrderSystem;

-- Customers table with ID and name
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(100) NOT NULL
);

-- Orders table linking to customers
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Products in each order
CREATE TABLE OrderProducts (
    OrderProductID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL,
    Product VARCHAR(50) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Sample customers
INSERT INTO Customers (CustomerName) VALUES 
('James Mwangi'),
('Mary Wanjiku'),
('Peter Otieno');

-- Sample orders
INSERT INTO Orders (OrderID, CustomerID) VALUES
(101, 1),
(102, 2),
(103, 3);

-- Sample products in orders
INSERT INTO OrderProducts (OrderID, Product) VALUES
(101, 'Laptop'),
(101, 'Mouse'),
(102, 'Tablet'),
(102, 'Keyboard'),
(102, 'Mouse'),
(103, 'Phone');


/*
 QUESTION TWO: 2NF
 */

-- Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(100) NOT NULL
);

-- Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Order details with quantity
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL,
    Product VARCHAR(50) NOT NULL,
    Quantity INT NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Sample customers
INSERT INTO Customers (CustomerName) VALUES
('John Doe'),
('Jane Smith'),
('Emily Clark');

-- Sample orders
INSERT INTO Orders (OrderID, CustomerID) VALUES
(101, 1),
(102, 2),
(103, 3);

-- Sample order details
INSERT INTO OrderDetails (OrderID, Product, Quantity) VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);

-- Alternative 2NF approach

-- Add quantity column to existing table
ALTER TABLE OrderProducts 
ADD COLUMN Quantity INT NOT NULL DEFAULT 1 AFTER Product;

-- Add unique constraint on order and product
ALTER TABLE OrderProducts
ADD CONSTRAINT UK_OrderProduct UNIQUE (OrderID, Product);

-- Update quantity values
UPDATE OrderProducts SET Quantity = 
  CASE 
    WHEN OrderID = 101 AND Product = 'Laptop' THEN 2
    WHEN OrderID = 101 AND Product = 'Mouse' THEN 1
    WHEN OrderID = 102 AND Product = 'Tablet' THEN 3
    WHEN OrderID = 102 AND Product = 'Keyboard' THEN 1
    WHEN OrderID = 102 AND Product = 'Mouse' THEN 2
    WHEN OrderID = 103 AND Product = 'Phone' THEN 1
  END;

-- New table for 2NF-compliant order items
CREATE TABLE OrderItems_2NF (
    OrderID INT NOT NULL,
    Product VARCHAR(50) NOT NULL,
    Quantity INT NOT NULL,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Copy data to new table
INSERT INTO OrderItems_2NF (OrderID, Product, Quantity)
SELECT OrderID, Product, 
  CASE 
    WHEN OrderID = 101 AND Product = 'Laptop' THEN 2
    WHEN OrderID = 101 AND Product = 'Mouse' THEN 1
    WHEN OrderID = 102 AND Product = 'Tablet' THEN 3
    WHEN OrderID = 102 AND Product = 'Keyboard' THEN 1
    WHEN OrderID = 102 AND Product = 'Mouse' THEN 2
    WHEN OrderID = 103 AND Product = 'Phone' THEN 1
  END
FROM OrderProducts;


