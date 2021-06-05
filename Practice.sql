SELECT occurred_at, account_id, channel FROM web_events LIMIT 15;

# Write a query to return the 10 earliest orders in the orders table. Include the id, 
# occurred_at, and total_amt_usd.
SELECT id, occurred_at, total_amt_usd FROM orders ORDER BY occurred_at LIMIT 10;

# Write a query to return the top 5 orders in terms of largest total_amt_usd. 
# Include the id, account_id, and total_amt_usd.
SELECT id, account_id, total_amt_usd FROM orders ORDER BY total_amt_usd DESC LIMIT 5;

# Write a query to return the lowest 20 orders in terms of smallest total_amt_usd. 
# Include the id, account_id, and total_amt_usd.
SELECT id, account_id, total_amt_usd FROM orders ORDER BY total_amt_usd LIMIT 20;

# Write a query that displays the order ID, account ID, and total dollar amount for 
# all the orders, sorted first by the account ID (in ascending order), 
# and then by the total dollar amount (in descending order).
SELECT id, account_id, total_amt_usd 
FROM orders 
ORDER BY account_id, total_amt_usd DESC;

# Now write a query that again displays order ID, account ID, and total dollar amount 
# for each order, but this time sorted first by total dollar amount (in descending order), 
# and then by account ID (in ascending order).
SELECT id, account_id, total_amt_usd 
FROM orders 
ORDER BY total_amt_usd DESC, account_id;

# Pull the first 5 rows and all columns from the orders table that have a dollar amount of 
# gloss_amt_usd greater than or equal to 1000.
SELECT * 
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

# Pull the first 10 rows and all columns from the orders table that have 
# a total_amt_usd less than 500.
SELECT * 
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;

# Filter the accounts table to include the company name, website, and the 
# primary point of contact (primary_poc) just for the Exxon Mobil company in the 
# accounts table.
SELECT name, website, primary_poc 
FROM accounts
WHERE name = 'Exxon Mobil';

# Create a column that divides the standard_amt_usd by the standard_qty to find the 
# unit price for standard paper for each order. Limit the results to the first 10 orders,
# and include the id and account_id fields.
SELECT id, account_id, (standard_amt_usd/standard_qty) AS unit_price
FROM orders
LIMIT 10;

# Write a query that finds the percentage of revenue that comes from poster paper for 
# each order. You will need to use only the columns that end with _usd. 
# (Try to do this without using the total column.) Display the id 
#and account_id fields also.
SELECT id, account_id, (poster_amt_usd/total_amt_usd)*100 AS poster_revenue_percentage
FROM orders
LIMIT 10;

# All the companies whose names start with 'C'.
SELECT *
FROM accounts 
WHERE name LIKE 'C%';

# All companies whose names contain the string 'one' somewhere in the name.
SELECT *
FROM accounts
WHERE name LIKE '%one%';

# All companies whose names end with 's'.
SELECT *
FROM accounts
WHERE name LIKE '%s';

# Use the accounts table to find the account name, primary_poc, and sales_rep_id 
# for Walmart, Target, and Nordstrom.
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

# Use the web_events table to find all information regarding individuals who were 
# contacted via the channel of organic or adwords.
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');

# Use the accounts table to find the account name, primary poc, and sales rep id for all stores except 
# Walmart, Target, and Nordstrom.
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

# Write a query that returns all the orders where the standard_qty is over 1000, the poster_qty is 0, and the gloss_qty is 0.
SELECT * 
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0; 

# Using the accounts table, find all the companies whose names do not start with 'C' and end with 's'.
SELECT *
FROM accounts
WHERE name NOT LIKE 'C%s'; 


# When you use the BETWEEN operator in SQL, do the results include the values of your endpoints, or not? 
# Figure out the answer to this important question by writing a query that displays the order date and gloss_qty data 
# for all orders where gloss_qty is between 24 and 29. Then look at your output to see if the BETWEEN operator included 
# the begin and end values or not. ANS: YES, Inclusive!
SELECT id, occurred_at, gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29
ORDER BY gloss_qty;

# Use the web_events table to find all information regarding individuals who were contacted via 
# the organic or adwords channels, and started their account at any point in 2016, sorted from newest to oldest.
SELECT * 
FROM web_events
WHERE channel IN ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01 00:00:00' AND '2016-12-31 23:59:59'
ORDER BY occurred_at DESC;

# Find list of orders ids where either gloss_qty or poster_qty is greater than 4000. Only include the id field in the resulting table.
SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;

#Write a query that returns a list of orders where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000.
SELECT * 
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty > 1000);

#Find all the company names that start with a 'C' or 'W', and the primary contact contains 'ana' or 'Ana', but it doesn't contain 'eana'.
SELECT name
FROM accounts
WHERE 	(name LIKE 'C%' OR name LIKE 'W%') AND
 		(primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') AND
 		(primary_poc NOT LIKE '%eana%');


#################################################################################
#																				#
#									JOIN										#
#																				#
#################################################################################

# 1st Join (Inner join)
SELECT 	orders.*,
		accounts.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

# Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.
SELECT 	orders.standard_qty, orders.gloss_qty, orders.poster_qty,
		accounts.website, accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

# Provide a table for all web_events associated with account name of Walmart. 
# There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event. 
# Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.
SELECT 	ev.occurred_at, ev.channel,
		acc.primary_poc, acc.name
FROM web_events ev
JOIN accounts acc
ON ev.account_id = acc.id
WHERE acc.name = 'Walmart';

# Provide a table that provides the region for each sales_rep along with their associated accounts. 
# Your final table should include three columns: the region name, the sales rep name, and the account name. 
# Sort the accounts alphabetically (A-Z) according to account name.
SELECT 	sales.name,
		reg.name,
		acc.name
FROM sales_reps sales
JOIN accounts acc ON sales.id = acc.sales_rep_id
JOIN region reg ON sales.region_id = reg.id
ORDER BY sales.name, acc.name;

# Provide the name for each region for every order, as well as the account name and the unit price 
# they paid (total_amt_usd/total) for the order. Your final table should have 3 columns: region name, account name, and unit price. 
# A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.
SELECT reg.name region_name, acc.name account_name, (ord.total_amt_usd / (ord.total + 0.01)) unit_price
FROM orders ord
JOIN accounts acc ON ord.account_id = acc.id
JOIN sales_reps salesman ON acc.sales_rep_id = salesman.id
JOIN region reg ON salesman.region_id = reg.id;


# Provide a table that provides the region for each sales_rep along with their associated accounts. 
# This time only for the Midwest region. Your final table should include 
# three columns: the region name, the sales rep name, and the account name. 
# Sort the accounts alphabetically (A-Z) according to account name.
SELECT reg.name region_name, salesman.name sales_rep_name, acc.name account_name
FROM sales_reps salesman
JOIN region reg ON salesman.region_id = reg.id AND reg.name = 'Midwest'
JOIN accounts acc ON salesman.id = acc.sales_rep_id
ORDER BY account_name;

# Provide a table that provides the region for each sales_rep along with their associated accounts. 
# This time only for accounts where the sales rep has a first name starting with S and in the Midwest region. 
# Your final table should include three columns: the region name, the sales rep name, and the account name. 
# Sort the accounts alphabetically (A-Z) according to account name.
SELECT reg.name region_name, salesman.name sales_rep_name, acc.name account_name
FROM sales_reps salesman
JOIN region reg ON salesman.region_id = reg.id AND reg.name = 'Midwest' AND salesman.name LIKE 'S%'
JOIN accounts acc ON salesman.id = acc.sales_rep_id
ORDER BY account_name;

# Provide a table that provides the region for each sales_rep along with their associated accounts. 
# This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. 
# Your final table should include three columns: the region name, the sales rep name, and the account name. 
# Sort the accounts alphabetically (A-Z) according to account name.
SELECT reg.name region_name, salesman.name sales_rep_name, acc.name account_name
FROM sales_reps salesman
JOIN region reg ON salesman.region_id = reg.id AND reg.name = 'Midwest' AND salesman.name LIKE '% K%'
JOIN accounts acc ON salesman.id = acc.sales_rep_id
ORDER BY account_name;

# Provide the name for each region for every order, as well as the account name and the unit price 
# they paid (total_amt_usd/total) for the order. However, you should only provide the results if 
# the standard order quantity exceeds 100. Your final table should have 3 columns: region name, account name, and unit price. 
# In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).
SELECT reg.name region_name, acc.name account_name, (ord.total_amt_usd / (ord.total + 0.01)) unit_price
FROM orders ord
JOIN accounts acc ON ord.account_id = acc.id
JOIN sales_reps salesman ON acc.sales_rep_id = salesman.id
JOIN region reg ON salesman.region_id = reg.id
WHERE ord.standard_qty > 100;

# Find all the orders that occurred in 2015. Your final table should have 
# 4 columns: occurred_at, account name, order total, and order total_amt_usd.
SELECT ord.occurred_at occurred_at, acc.name account_name, ord.total order_total, ord.total_amt_usd total_amt_usd
FROM orders ord
LEFT JOIN accounts acc ON ord.account_id = acc.id 
WHERE occurred_at BETWEEN '2015-01-01 00:00:00' AND '2015-12-31 23:59:59'
ORDER BY occurred_at;

# What are the different channels used by account id 1001? Your final table should have 
# only 2 columns: account name and the different channels. You can try SELECT DISTINCT to narrow down the results to 
# only the unique values.
SELECT DISTINCT acc.name account_name, ev.channel channels
FROM accounts acc 
JOIN web_events ev ON acc.id = ev.account_id AND acc.id = 1001;



#################################################################################
#																				#
#									AGGREGATION									#
#																				#
#################################################################################


# Find the total amount of poster_qty paper ordered in the orders table.
SELECT SUM(poster_qty) total_poster_qty
FROM orders;

# Find the total amount of standard_qty paper ordered in the orders table.
SELECT SUM(standard_qty) total_poster_qty
FROM orders;

# Find the total dollar amount of sales using the total_amt_usd in the orders table.
SELECT SUM(total_amt_usd) total_sales
FROM orders;

# Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. 
# This should give a dollar amount for each order in the table.


# When was the earliest order ever placed? You only need to return the date.
SELECT MIN(occurred_at) 
FROM orders;

# Try performing the same query as in question 1 without using an aggregation function.
SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1;

# When did the most recent (latest) web_event occur?
SELECT MAX(occurred_at) most_recent_event
FROM web_events;

# Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.
SELECT acc.name, acc.id, ord.occurred_at
FROM accounts acc
JOIN orders ord ON acc.id = ord.account_id
ORDER BY ord.occurred_at
LIMIT 1;

# Find the total sales in usd for each account. You should include two columns - 
# the total sales for each company's orders in usd and the company name.
SELECT a.name, SUM(o.total_amt_usd)
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.name
ORDER BY a.name;

# Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? 
# Your query should return only three values - the date, channel, and account name.
SELECT w.occurred_at, w.channel, a.name
FROM web_events w 
JOIN accounts a ON w.account_id = a.id
ORDER BY w.occurred_at DESC
LIMIT 1;

# Find the total number of times each type of channel from the web_events was used. 
# Your final table should have two columns - the channel and the number of times the channel was used.
SELECT channel, COUNT(*)
FROM web_events 
GROUP BY channel;

# Who was the primary contact associated with the earliest web_event?
SELECT a.primary_poc
FROM web_events w
JOIN accounts a ON w.account_id = a.id
ORDER BY w.occurred_at
LIMIT 1;

# What was the smallest order placed by each account in terms of total usd. 
# Provide only two columns - the account name and the total usd. 
# Order from smallest dollar amounts to largest.
SELECT a.name, MIN(o.total_amt_usd) min_order
FROM orders o 
JOIN accounts a ON a.id = o.account_id
GROUP BY a.name
ORDER BY min_order;

# Find the number of sales reps in each region. Your final table 
# should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.
SELECT r.name, COUNT(s.id) reps_count
FROM sales_reps s 
JOIN region r ON s.region_id = r.id
GROUP BY r.name
ORDER BY reps_count;

# For each account, determine the average amount of each type of paper they purchased across their orders. 
# Your result should have four columns - one for the account name and one for the average quantity 
# purchased for each of the paper types for each account.
SELECT 	a.name, 
		AVG(o.standard_qty) avg_standard_qty, 
		AVG(o.poster_qty) avg_poster_qty, 
		AVG(o.gloss_qty) avg_gloss_qty  
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.name;

# For each account, determine the average amount spent per order on each paper type. 
# Your result should have four columns - one for the account name and one for the 
# average amount spent on each paper type.
SELECT 	a.name, 
		AVG(o.standard_amt_usd) avg_standard_spend, 
		AVG(o.poster_amt_usd) avg_poster_spend, 
		AVG(o.gloss_amt_usd) avg_gloss_spend  
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.name;

# Determine the number of times a particular channel was used in the web_events table for each sales rep. 
# Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. 
# Order your table with the highest number of occurrences first.
SELECT s.name, w.channel, COUNT(w.id) occurrences	
FROM accounts a 
JOIN sales_reps s ON s.id = a.sales_rep_id
JOIN web_events w ON w.account_id = a.id
GROUP BY s.name, w.channel
ORDER BY occurrences DESC;

# Determine the number of times a particular channel was used in the web_events table for each region. 
# Your final table should have three columns - the region name, the channel, and the number of occurrences. 
# Order your table with the highest number of occurrences first.
SELECT r.name, w.channel, COUNT(w.id) occurrences	
FROM accounts a 
JOIN sales_reps s ON s.id = a.sales_rep_id
JOIN web_events w ON w.account_id = a.id
JOIN region r ON r.id = s.region_id
GROUP BY r.name, w.channel
ORDER BY occurrences DESC;

# Use DISTINCT to test if there are any accounts associated with more than one region.
SELECT DISTINCT a.name account_name, r.name region
FROM accounts a 
JOIN sales_reps s ON a.sales_rep_id = s.id 
JOIN region r ON s.region_id = r.id
ORDER BY account_name;

# Have any sales reps worked on more than one account?
SELECT DISTINCT s.name rep_name, a.name account_name
FROM sales_reps s 
JOIN accounts a ON s.id = a.sales_rep_id
ORDER BY rep_name;

# How many of the sales reps have more than 5 accounts that they manage?
SELECT s.name, COUNT(a.id) managed_acc
FROM sales_reps s 
JOIN accounts a ON s.id = a.sales_rep_id
GROUP BY s.name
HAVING COUNT(a.id) > 5
ORDER BY s.name;

# How many accounts have more than 20 orders?
SELECT a.name account_name, COUNT(o.id)
FROM accounts a 
JOIN orders o ON a.id = o.account_id
GROUP BY account_name
HAVING COUNT(o.id) > 20
ORDER BY account_name;

# Which account has the most orders?
SELECT a.name account_name, COUNT(o.id) order_qty
FROM accounts a 
JOIN orders o ON a.id = o.account_id
GROUP BY account_name
ORDER BY order_qty DESC
LIMIT 1;

# Which accounts spent more than 30,000 usd total across all orders?
SELECT a.name, SUM(o.total_amt_usd) total_spent
FROM orders o 
JOIN accounts a ON a.id = o.account_id
GROUP BY a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY a.name;

# Which accounts spent less than 1,000 usd total across all orders?
SELECT a.name, SUM(o.total_amt_usd) total_spent
FROM orders o 
JOIN accounts a ON a.id = o.account_id
GROUP BY a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY a.name;

# Which account has spent the most with us?
SELECT a.name, SUM(o.total_amt_usd) total_spent
FROM orders o 
JOIN accounts a ON a.id = o.account_id
GROUP BY a.name
ORDER BY total_spent DESC
LIMIT 1;

# Which account has spent the least with us?
SELECT a.name, SUM(o.total_amt_usd) total_spent
FROM orders o 
JOIN accounts a ON a.id = o.account_id
GROUP BY a.name
ORDER BY total_spent
LIMIT 1;

# Which accounts used facebook as a channel to contact customers more than 6 times?
SELECT a.name, COUNT(w.id) times_channel_used
FROM accounts a
JOIN web_events w ON a.id = w.account_id
GROUP BY a.name, w.channel
HAVING w.channel = 'facebook' AND COUNT(w.id) > 6;

# Which account used facebook most as a channel?
SELECT a.name, COUNT(w.id) times_channel_used
FROM accounts a
JOIN web_events w ON a.id = w.account_id
GROUP BY a.name, w.channel
HAVING w.channel = 'facebook' AND COUNT(w.id) > 6
ORDER BY times_channel_used DESC
LIMIT 1;

# Which channel was most frequently used by most accounts?
SELECT channel, COUNT(id)
FROM web_events
GROUP BY channel
ORDER BY COUNT(id) DESC
LIMIT 1;

# Find the sales in terms of total dollars for all orders in each year, 
# ordered from greatest to least. Do you notice any trends in the yearly sales totals?
SELECT DATE_TRUNC('year', occurred_at) AS fiscal_year, SUM(total_amt_usd) AS total_sales
FROM orders
GROUP BY DATE_TRUNC('year', occurred_at)
ORDER BY total_sales DESC;

# ALT
SELECT DATE_PART('year', occurred_at) AS fiscal_year, SUM(total_amt_usd) AS total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

# In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
SELECT DATE_TRUNC('month', o.occurred_at), SUM(o.gloss_amt_usd)
FROM orders o 
JOIN accounts a ON o.account_id = a.id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC;

# Write a query to display for each order, the account ID, total amount of the order, 
# and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, 
# or smaller than $3000.
SELECT 	account_id, total, 
		CASE WHEN total_amt_usd >= 3000 THEN 'Large' ELSE 'Samll' END AS volume
FROM orders;

# Write a query to display the number of orders in each of three categories, 
# based on the total number of items in each order. 
# The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.
SELECT 
		CASE
			WHEN total < 1000 THEN 'Less than 1000'
			WHEN total BETWEEN 1000 AND 2000 THEN 'Between 1000 and 2000'
			WHEN total >= 2000 THEN 'At Least 2000'
		END AS order_volume_type, COUNT(id)	
FROM orders
GROUP BY 1;

# We would like to understand 3 different levels of customers based on the amount associated with their purchases. 
# The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. 
# The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. 
# Provide a table that includes the level associated with each account. 
# You should provide the account name, the total sales of all orders for the customer, and the level. 
# Order with the top spending customers listed first.
SELECT 	a.name, SUM(total_amt_usd), 
		CASE 	WHEN SUM(total_amt_usd) > 200000 THEN 'Top Customer'
				WHEN SUM(total_amt_usd) <= 200000 AND SUM(total_amt_usd) >= 100000 THEN 'Mid Customer'
				WHEN SUM(total_amt_usd) < 100000 THEN 'Low Customer'
		END AS customer_level		
FROM orders o
JOIN accounts a ON o.account_id = a.id
GROUP BY a.name
ORDER BY 2 DESC;

# We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers only in 2016 and 2017. 
# Keep the same levels as in the previous question. Order with the top spending customers listed first.
SELECT 	a.name, SUM(total_amt_usd), 
		CASE 	WHEN SUM(total_amt_usd) > 200000 THEN 'Top Customer'
				WHEN SUM(total_amt_usd) <= 200000 AND SUM(total_amt_usd) >= 100000 THEN 'Mid Customer'
				WHEN SUM(total_amt_usd) < 100000 THEN 'Low Customer'
		END AS customer_level, DATE_PART('year', o.occurred_at)		
FROM orders o
JOIN accounts a ON o.account_id = a.id
GROUP BY a.name, DATE_PART('year', o.occurred_at)
HAVING DATE_PART('year', o.occurred_at) BETWEEN 2016 AND 2017
ORDER BY 2 DESC;

# We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. 
# Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if they have more than 200 orders. 
# Place the top sales people first in your final table.
SELECT 	s.name, COUNT(o.id) order_count,
		CASE WHEN COUNT(o.id) > 200 THEN 'Yes'
		END AS is_performer
FROM sales_reps s 
JOIN accounts a ON S.id = a.sales_rep_id
JOIN orders o ON a.id = o.account_id
GROUP BY s.name
ORDER BY 2 DESC;


































