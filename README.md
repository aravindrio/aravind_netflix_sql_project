# SQL Portfolio Project: Analysis of Netflix Movies and TV Shows Dataset by Aravind


![](https://)

## Overview
As someone with a background in Marketing, Strategy, and Technology, I built this SQL project to bridge analytical thinking with real-world business decision-making. This project focuses on an in-depth analysis of Netflix’s Movies and TV Shows dataset using SQL.

Through this project, I applied SQL to structure, clean, and analyze raw data to answer key business questions, such as identifying genre trends, production country dominance, and patterns in content release over time. The analysis also demonstrates how SQL-based insights can support strategic planning in media and entertainment domains.

This README outlines the project objectives, analytical approach, SQL techniques used, findings, and business implications derived from the data.

## Objectives

In this project, I set out to explore Netflix’s dataset through the lens of data-driven business insights. Specifically, I aimed to:

- Analyze the distribution of content types (Movies vs. TV Shows) to understand how Netflix balances its content strategy across different formats.

- Identify the most common ratings for both movies and TV shows to gain insights into audience targeting and regional content compliance.

- Examine and compare content based on release years, countries of production, and durations, highlighting trends in global content creation and audience evolution over time.

- Explore and categorize titles using specific criteria and keywords, such as themes or genres, to demonstrate how SQL-based text analysis can help in market segmentation and personalized recommendations.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
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
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
	type,
	COUNT(show_id) AS total_count	
FROM netflix
GROUP BY type;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
SELECT 
	type,
	COUNT(show_id) AS total_count	
FROM netflix
GROUP BY type;
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2021)

```sql
SELECT 
 	*
FROM netflix
WHERE 
	type = 'Movie' 
	AND release_year= 2021;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT 
	UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
	COUNT(show_id) AS total_content
FROM netflix
GROUP BY new_country
ORDER BY total_content DESC
LIMIT 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT *
FROM netflix
WHERE 
	type = 'Movie'
	AND duration = (SELECT MAX(duration) FROM netflix);
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT 
	*
FROM netflix
WHERE TO_DATE(date_added, 'MONTH DD, YYYY') >= CURRENT_DATE - INTERVAL  '5 years'

SELECT CURRENT_DATE - INTERVAL '5 years'
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Gautham Vasudev Menon'

```sql
SELECT *
FROM netflix
WHERE director ILIKE  '%Gautham Vasudev Menon%';
```

**Objective:** List all content directed by 'Gautham Vasudev Menon'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT 
	*
FROM netflix
WHERE 
	type = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::numeric > 5;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
	COUNT(show_id) AS total_count
FROM netflix
GROUP BY genre
ORDER BY total_count DESC;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
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
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
SELECT 
	*
FROM netflix
WHERE listed_in ILIKE '%documentaries%';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT
	*
FROM netflix
WHERE director IS NULL;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT 
	*
FROM netflix
WHERE 
	casts ILIKE '%Salman Khan%'
	AND  
	release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors,
	COUNT(show_id) as total_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY actors
ORDER BY total_content DESC

LIMIT 10;
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## Author - ARAVIND R

This project is part of my portfolio, demonstrating how I leverage SQL to extract actionable insights from real-world datasets which is a skill crucial for roles in data analysis, marketing analytics, and product strategy.


- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/aravind-iift/)

Thank you for your support, and I look forward to connecting with you!
