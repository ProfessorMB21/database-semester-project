-- Insert sample data for demonstration
INSERT INTO Customers VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '555-1001', '123 Main St, City', '2023-01-15'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '555-1002', '456 Oak Ave, Town', '2023-02-20');

INSERT INTO Suppliers VALUES
(1, 'TechGadgets Inc.', 'Mike Johnson', 'contact@techgadgets.com', '555-2001', '789 Industrial Blvd'),
(2, 'FashionTrends Ltd.', 'Sarah Lee', 'info@fashiontrends.com', '555-2002', '321 Design Street');

INSERT INTO Products VALUES
(1, 'Smartphone X', 'Latest flagship phone', 1, 999.99, 50, 1),
(2, 'Wireless Earbuds', 'Noise-cancelling', 1, 199.99, 100, 1),
(3, 'Designer Jeans', 'Premium denim', 2, 89.99, 200, 2);

INSERT INTO Employees VALUES
(1, 'Alex', 'Brown', 'alex@store.com', 'Manager', '2022-01-10', 60000.00, NULL),
(2, 'Emily', 'Davis', 'emily@store.com', 'Sales Associate', '2023-03-15', 40000.00, 1);

INSERT INTO Orders VALUES
(1, 1, '2023-10-01 14:30:00', 1199.98, 'Delivered', '123 Main St, City'),
(2, 2, '2023-10-05 10:15:00', 89.99, 'Processing', '456 Oak Ave, Town');

INSERT INTO Order_Items VALUES
(1, 1, 1, 1, 999.99),
(2, 1, 2, 1, 199.99),
(3, 2, 3, 1, 89.99);

INSERT INTO Payments VALUES
(1, 1, 'Credit Card', 1199.98, '2023-10-01 14:35:00', 'Completed'),
(2, 2, 'PayPal', 89.99, '2023-10-05 10:20:00', 'Pending');