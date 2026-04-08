-- DATA EXPLORATION

-- 1) Retrieve the total number of customers in the database:

      SELECT COUNT(*) AS total_customers
	  FROM customers;

	  
-- 2) Retrieve the total number of orders placed:

      SELECT COUNT(*) AS total_orders
	  FROM orders;
	  

-- 3) Calculate the total revenue generated from all orders:

      SELECT SUM(total_amount) AS total_revenue
	  FROM orders;

	  
-- 4) Find the average order value:

      SELECT AVG(total_amount) AS avg_order_value
	  FROM orders;

	  
-- 5) Show the first and last order dates:

      SELECT 
	  MIN(order_date) AS first_order_date,
	  MAX(order_date) AS last_order_date
	  FROM orders;

	  
-- SALES ANALYSIS

-- 6) Retrieve total revenue generated for each month:

      SELECT 
	  TO_CHAR(order_date, 'YYYY-MM') AS month,
	  SUM(total_amount) AS monthly_revenue
	  FROM orders
	  GROUP BY month
	  ORDER BY month;

	  
-- 7) Find the month with the highest revenue:

      SELECT 
	  DATE_TRUNC('month', order_date) AS month,
	  SUM(total_amount) AS monthly_revenue
	  FROM orders
	  GROUP BY month
	  ORDER BY monthly_revenue DESC
	  LIMIT 1;

	  
-- 8) Retrieve the top 10 highest value orders:

      SELECT 
	  order_id,
	  customer_id,
	  product_id,
	  total_amount
	  FROM orders
	  ORDER BY total_amount DESC
	  LIMIT 10;

	  
-- 9) Find the cities that generate the most revenue:

      SELECT c.city, SUM(o.total_amount) AS total_revenue
	  FROM customers AS c
	  JOIN orders AS o
	  ON c.customer_id = o.customer_id
	  GROUP BY c.city
	  ORDER BY total_revenue DESC;

	  
-- 10) Calculate the average revenue per order:

       SELECT
	   AVG(total_amount ) AS avg_revenue_per_order
	   FROM orders;
	 
	   
-- CUSTOMER ANALYSIS

-- 11) Retrieve the top 10 customers by total spending:

       SELECT c.customer_id, c.customer_name,
	   SUM(o.total_amount) AS total_spent
	   FROM customers c
	   JOIN orders o
	   ON c.customer_id = o.customer_id
	   GROUP BY c.customer_id, c.customer_name
	   ORDER BY total_spent DESC
	   LIMIT 10;

	   
-- 12) Find customers who placed more than one order:

       SELECT c.customer_id, c.customer_name,
	   COUNT(o.order_id) AS order_count
	   FROM customers c
	   JOIN orders o
	   ON c.customer_id = o.customer_id
	   GROUP BY c.customer_id, c.customer_name
	   HAVING COUNT(o.order_id) > 1
	   ORDER BY order_count DESC;

	   
-- 13) Retrieve the number of customers from each city:

       SELECT city, COUNT(customer_id) AS total_customers
	   FROM customers
	   GROUP BY city
	   ORDER BY total_customers DESC;
	   
	   
-- 14) Find customers who have not placed any orders recently:

       SELECT customer_id,
	   MAX(order_date) AS last_order_date
	   FROM orders
	   GROUP BY customer_id
	   HAVING MAX(order_date) < CURRENT_DATE - INTERVAL '6 months';
	   
	  
-- 15) Calculate the lifetime value of each customer:

       SELECT c.customer_id, c.customer_name,
	   SUM(o.total_amount) AS customer_lifetime_value
	   FROM customers c
	   JOIN orders o
	   ON c.customer_id = o.customer_id
	   GROUP BY c.customer_id, c.customer_name
	   ORDER BY customer_lifetime_value DESC;

	   
-- 16) Retrieve the top selling products by quantity sold:

       SELECT p.product_id, p.product_name, 
	   SUM(o.quantity) AS total_quantity_sold
	   FROM products p
	   JOIN orders o
	   ON p.product_id = o.product_id
	   GROUP BY p.product_id, p.product_name
	   ORDER BY  total_quantity_sold DESC
	   LIMIT 10;

	   
	   
-- 17) Find the product categories generating the most revenue:

       SELECT p.category, SUM(o.total_amount) AS total_revenue
	   FROM products p
	   JOIN orders o
	   ON p.product_id = o.product_id
	   GROUP BY p.category
	   ORDER BY total_revenue DESC;
	   
	   
-- 18) Retrieve the lowest performing products by revenue:

       SELECT p.product_id, p.product_name,
	   SUM(o.total_amount) AS total_revenue
	   FROM products p
	   JOIN orders o
	   ON p.product_id = o.product_id
	   GROUP BY p.product_id, p.product_name
	   ORDER BY total_revenue
	   LIMIT 10;
	   
	   
-- 19) Calculate the average quantity of products per order:

       SELECT 
	   AVG(quantity) AS avg_quantity_per_order
	   FROM orders;

	
-- 20) Rank products by total revenue using a window function:

       SELECT p.product_id, p.product_name,
	   SUM(o.total_amount) AS total_revenue,
	   RANK() OVER (ORDER BY SUM(o.total_amount) DESC)
	   AS revenue_rank
	   FROM products p
	   JOIN orders o
	   ON p.product_id = o.product_id
	   GROUP BY p.product_id, p.product_name;

	   