-- Aravind R's Netflix Movies and Shows Portfolii
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(7),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(210),
	casts VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(50),	
	release_year INT,	
	rating VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(100),
	description VARCHAR(250)
);

SELECT * FROM netflix;

SELECT 
	COUNT(*) AS total_content
FROM netflix;

SELECT DISTINCT
 	type
FROM netflix;

-- Business Analysis done using SQL 
-- 1. Count the number of Movies vs TV Shows 
SELECT 
	type,
	COUNT(show_id) AS total_count	
FROM netflix
GROUP BY type;



-- 2. Find the most common rating for movies and TV shows
SELECT
	type,
	rating
FROM

(SELECT
	type,
	rating,
	COUNT(show_id) AS count_of_ratings,
	RANK() OVER(PARTITION BY type ORDER BY COUNT(show_id) DESC) as ranking
FROM netflix
GROUP BY type,rating 
ORDER BY type, count_of_ratings DESC
) AS table1
WHERE ranking = 1;

--3. List all movies released in a specific year (e.g., 2021)
SELECT 
 	*
FROM netflix
WHERE 
	type = 'Movie' 
	AND release_year= 2021;

-- 4. Find the top 5 countries with the most content on Netflix
SELECT 
	UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
	COUNT(show_id) AS total_content
FROM netflix
GROUP BY new_country
ORDER BY total_content DESC
LIMIT 5;




-- 5. Identify the longest movie
SELECT *
FROM netflix
WHERE 
	type = 'Movie'
	AND duration = (SELECT MAX(duration) FROM netflix);



-- 6. Find content added in the last 5 years
SELECT 
	*
FROM netflix
WHERE TO_DATE(date_added, 'MONTH DD, YYYY') >= CURRENT_DATE - INTERVAL  '5 years'

SELECT CURRENT_DATE - INTERVAL '5 years'

-- 7. Find all the movies/TV shows by director 'Gautham Vasudev Menon'!
SELECT *
FROM netflix
WHERE director ILIKE  '%Gautham Vasudev Menon%';



-- 8. List all TV shows with more than 5 seasons
SELECT 
	*
FROM netflix
WHERE 
	type = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::numeric > 5;


-- 9. Count the number of content items in each genre
SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
	COUNT(show_id) AS total_count
FROM netflix
GROUP BY genre
ORDER BY total_count DESC;



-- 10.Find each year and the average numbers of content release in India on netflix and return top 5 year with highest avg content release!
SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added, 'MONTH DD, YYYY')) as year,
	COUNT(show_id),
	ROUND(
	COUNT(show_id):: numeric/(SELECT COUNT(show_id) FROM netflix WHERE country = 'India'):: numeric * 100, 2) as avg_content_per_year
FROM netflix
WHERE country ='India'
GROUP BY year
ORDER BY avg_content_per_year DESC

LIMIT 5;





-- 11. List all movies that are documentaries
SELECT 
	*
FROM netflix
WHERE listed_in ILIKE '%documentaries%';



--  12. Find all content without a director
SELECT
	*
FROM netflix
WHERE director IS NULL;


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT 
	*
FROM netflix
WHERE 
	casts ILIKE '%Salman Khan%'
	AND  
	release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;


14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors,
	COUNT(show_id) as total_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY actors
ORDER BY total_content DESC

LIMIT 10;



15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

WITH netflix_category
AS
(
SELECT
	*,
	CASE
		WHEN description ILIKe '%kill%' OR
			description ILIKE '%violence%' THEN 'Bad Content'
			ELSE 'Good Content'
	END category
FROM netflix
)


SELECT 
	category,
	COUNT(*) as total_content
FROM netflix_category
GROUP BY category;