  USE sakila;
  
  # 1. In the previous lab we wrote a query to find first name, last name, and emails of 
  # all the customers who rented Action movies. Convert the query into a simple stored procedure. 
  
  DELIMITER //
  CREATE PROCEDURE action_movies()
  BEGIN
  SELECT 
	first_name, 
    last_name, 
    email
  FROM 
	customer
  JOIN rental USING (customer_id)
  JOIN inventory USING (inventory_id)
  JOIN film_category USING (film_id)
  JOIN category USING (category_id)
  WHERE 
	category.name = "Action"
  GROUP BY 
	first_name, 
    last_name, 
    email;
  END //
  DELIMITER ;
  
  CALL action_movies();
  
  # 2. Now keep working on the previous stored procedure to make it more dynamic. 
  # Update the stored procedure in a such manner that it can take a string argument 
  # for the category name and return the results for all customers that rented movie of that category/genre. 
  # For e.g., it could be action, animation, children, classics, etc.
    
  DELIMITER //
  CREATE PROCEDURE filter_movies(in category_name char(20))
  BEGIN
  SELECT 
	first_name, 
    last_name, 
    email
  FROM 
	customer
  JOIN rental USING (customer_id)
  JOIN inventory USING (inventory_id)
  JOIN film_category USING (film_id)
  JOIN category USING (category_id)
  WHERE 
	category.name = category_name
  GROUP BY 
	first_name, 
    last_name, 
    email;
  END //
  DELIMITER ;
  
  CALL filter_movies("Action");
  
  # 3. Write a query to check the number of movies released in each movie category. 
  # Convert the query in to a stored procedure to filter only those categories 
  # that have movies released greater than a certain number. 
  # Pass that number as an argument in the stored procedure.

  DELIMITER //
  CREATE PROCEDURE filter_movies(in threshold int)
  BEGIN
  WITH counted_movies AS (
  SELECT 
		category.name AS category_name, 
		COUNT(*) AS number_of_releases
  FROM film
  JOIN film_category USING(film_id)
  JOIN category USING(category_id)
  GROUP BY
		category_name)
  SELECT 
		category_name, 
        number_of_releases
  FROM 
		counted_movies
  WHERE 
		number_of_releases > threshold
  GROUP BY 
		category_name, 
		number_of_releases
  ORDER BY number_of_releases DESC;
  END //
  DELIMITER ;
  
  CALL filter_movies(70);

# Window function
  WITH counted_movies AS (
  SELECT 
		category.name AS category_name, 
		COUNT(*) OVER(PARTITION BY category.name) AS number_of_releases
  FROM film
  JOIN film_category USING(film_id)
  JOIN category USING(category_id))
  SELECT 
		category_name, 
        number_of_releases
  FROM 
		counted_movies
  WHERE 
		number_of_releases > 0
  GROUP BY 
		category_name, 
		number_of_releases
  ORDER BY number_of_releases DESC;
  
  # Normal aggregation
  WITH counted_movies AS (
  SELECT 
		category.name AS category_name, 
		COUNT(*) AS number_of_releases
  FROM film
  JOIN film_category USING(film_id)
  JOIN category USING(category_id)
  GROUP BY
		category_name)
  SELECT 
		category_name, 
        number_of_releases
  FROM 
		counted_movies
  WHERE 
		number_of_releases > 0
  GROUP BY 
		category_name, 
		number_of_releases
  ORDER BY number_of_releases DESC;