USE SAKILA;

--  Task 1:  Display Firstname, Lastname, ActorId and details of LastUpd column of all actors.  

SELECT actor_id, first_name, last_name, last_update FROM actor;


--  Task 2 
-- 2.1 Display full names of all actors.

SELECT  CONCAT(first_name,' ',last_name) AS 'Full Name'  FROM actor;


-- 2.2 Display first names of all actors along with count of repetition.

SELECT first_name, 
count(first_name) AS 'Count Of FirstNames' 
FROM actor 
GROUP BY first_name ;


-- 2.3 Display last names of all actors along with count of repetition.

SELECT last_name, 
count(last_name) AS 'Count Of LastNames' 
FROM actor 
GROUP BY last_name;


--  Task 3:  Display rating-wise count of movies.

SELECT rating, 
count(film_id) AS 'Count Of Movies' 
FROM film 
GROUP BY rating;


--  Task 4:  Display rating-wise average rental rates.

SELECT rating, 
Round(avg(rental_rate),2) AS 'AverageRentalRate $' 
FROM film 
GROUP BY rating;


--  Task 5  
-- 5.1 Display movie titles where replacement cost is upto $9.

SELECT title ,
replacement_cost 
FROM film 
WHERE replacement_cost<=9 ;


-- 5.2 Display movie titles where replacement cost is between $15 & 20.

SELECT title ,
replacement_cost 
FROM film 
WHERE replacement_cost BETWEEN 15 AND 20;


-- 5.3 Display movie titles with highest replacement cost and lowest rental cost.

SELECT A.title, A.rental_rate, B.replacement_cost FROM
( SELECT F1.FILM_ID, F1.title, F1.rental_rate
FROM film  F1 
WHERE F1.rental_rate IN ( SELECT MIN(rental_rate) FROM film ) ) A
INNER JOIN 
(SELECT F2.FILM_ID, F2.title, F2.replacement_cost
FROM film  F2
WHERE F2.replacement_cost IN ( SELECT MAX(replacement_cost) FROM film ) )B
ON A.FILM_ID=B.FILM_ID


--  Task 6   Display movies along with no. of actors associated with it.

SELECT F.film_id, F.title, COUNT(FI.actor_id ) AS 'NumberOfActors'
FROM film F INNER JOIN film_actor FI 
ON F.film_id = FI.film_id 
GROUP BY F.film_id, F.title ;


--  Task 7   Display movie titles starting with the letter K and Q. 

SELECT title
FROM film 
WHERE title LIKE 'K%' OR title LIKE 'Q%' ;


--  Task 8   Display first and last names of all actors associated with 'AGENT TRUEMAN'

SELECT F.title, A.first_name, A.last_name
FROM film F INNER JOIN film_actor FA 
ON F.film_id = FA.film_id
INNER JOIN  actor A
ON FA.actor_id = A.actor_id
WHERE F.title LIKE 'AGENT TRUMAN' ;


--  Task 9   Display names of movies under family category.

SELECT F.title, C.name
FROM film F INNER JOIN film_category FC
ON F.film_id = FC.film_id
INNER JOIN category C
ON FC.category_id = C.category_id 
WHERE C.name='Family';


--  Task 10   Display names of most frequently rented movies, in desc order.

SELECT F.title, F.film_id, COUNT(*) AS Rental_Frequency
-- F.rental_duration, I.inventory_id , R.rental_id
FROM film F INNER JOIN inventory I
ON F.film_id = I.film_id
INNER JOIN rental R
ON I.inventory_id = R.inventory_id 
GROUP BY F.title, F.film_id
ORDER BY Rental_Frequency DESC ;


--  Task 11   Display no. of movie categories where avgdifference of replacement cost & rental rate > 15.

-- SELECT COUNT( X.category_id ) AS CategoryCount FROM (
SELECT FC.category_id, AVG(F.replacement_cost - F.rental_rate) AS AvgDifference 
FROM film F
INNER JOIN film_category FC
ON F.film_id = FC.film_id
GROUP BY FC.category_id 
HAVING AvgDifference > 15 
-- ) X WHERE X.AvgDifference > 15 ;


--  Task 12   Display category names and number of movies per category, sorted by latter.

SELECT  C.name, COUNT( F.film_id ) AS 'Number Of MoviesPerCategory'
FROM film F INNER JOIN film_category FC
ON F.film_id = FC.film_id
INNER JOIN category C
ON FC.category_id = C.category_id 
GROUP BY C.category_id, C.name
HAVING COUNT( F.film_id ) BETWEEN 60 AND 70 
ORDER BY COUNT( F.film_id ) ;


