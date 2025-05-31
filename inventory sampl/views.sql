-- 1. Customer Order History (with total spending)
CREATE VIEW CustomerOrderHistory AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    MAX(o.order_date) AS last_order_date
FROM 
    Customers c
LEFT JOIN 
    Orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id;

-- 2. Product Sales Report (best-selling products)
CREATE VIEW ProductSalesReport AS
SELECT 
    p.product_id,
    p.name AS product_name,
    SUM(oi.quantity) AS total_sold,
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    s.name AS supplier_name
FROM 
    Products p
JOIN 
    Order_Items oi ON p.product_id = oi.product_id
JOIN 
    Suppliers s ON p.supplier_id = s.supplier_id
GROUP BY 
    p.product_id
ORDER BY 
    total_sold DESC;

-- 3. Employee Performance (orders processed)
CREATE VIEW EmployeePerformance AS
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.position,
    COUNT(o.order_id) AS orders_processed,
    SUM(o.total_amount) AS revenue_generated
FROM 
    Employees e
LEFT JOIN 
    Orders o ON e.employee_id = o.employee_id  -- Assuming employees handle orders
GROUP BY 
    e.employee_id;
