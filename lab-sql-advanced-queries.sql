USE sakila;

-- In this lab, you will be using the Sakila database of movie rentals.

# 1. List each pair of actors that have worked together.
WITH cte as (
	SELECT a.actor_id, CONCAT(a.first_name, ' ', a.last_name) AS actor_name, fa.film_id
	FROM film_actor AS fa 
	JOIN actor AS a 
	ON fa.actor_id= a.actor_id 
)
SELECT DISTINCT cte.actor_id AS id_1, cte.actor_name, a.actor_id AS id_2, CONCAT(a.first_name, ' ', a.last_name) AS actor_name_2
FROM cte  
JOIN film_actor AS fa 
ON cte.film_id = fa.film_id
JOIN actor AS a 
ON fa.actor_id = a.actor_id 
WHERE a.actor_id <> cte.actor_id
ORDER BY 1, 3;

# 2. For each film, list actor that has acted in more films.
SELECT * FROM film;  #film_id     title
SELECT * FROM actor; #actor_id   first_name     last_name
SELECT * FROM film_actor;  #actor_id     film_id

WITH CTE_film_count AS (
    SELECT a.actor_id, CONCAT(a.first_name, ' ', a.last_name) AS actor_name, COUNT(fa.film_id) AS film_count
    FROM film_actor AS fa
    JOIN actor AS a ON a.actor_id = fa.actor_id
    GROUP BY 1, 2
)
SELECT *
FROM (
    SELECT f.film_id, f.title, fc.actor_id, fc.actor_name, fc.film_count,
    RANK() OVER (PARTITION BY f.film_id ORDER BY fc.film_count DESC) AS `rank`
    FROM CTE_film_count AS fc
    JOIN actor AS a ON a.actor_id = fc.actor_id
    JOIN film_actor AS fa ON fa.actor_id = a.actor_id
    JOIN film AS f ON f.film_id = fa.film_id
) subquery
WHERE `rank` = 1;



