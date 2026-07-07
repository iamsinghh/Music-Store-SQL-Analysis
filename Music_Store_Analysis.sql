use music_database;

-- Who is the senior most employee based on job title?
SELECT * FROM EMPLOYEE
ORDER BY LEVELS DESC
LIMIT 1;


-- Which countries have the most Invoices?
Select count(*), billing_country
from invoice
group by billing_country
order by count(*) desc;


-- What are top 3 values of total invoice?
select total from invoice
order by total desc
limit 3;


-- Which city has the best customers? We would like to throw a promotional Music 
-- Festival in the city we made the most money. Write a query that returns one city that 
-- has the highest sum of invoice totals. Return both the city name & sum of all invoice 
-- totals
select billing_city as city, SUM(total) as total_sales
FROM invoice
GROUP BY billing_city
ORDER BY total_sales DESC
LIMIT 1;


-- Who is the best customer? The customer who has spent the most money will be 
-- declared the best customer. Write a query that returns the person who has spent the 
-- most money
SELECT CUSTOMER.CUSTOMER_ID, CUSTOMER.FIRST_NAME, CUSTOMER.LAST_NAME, SUM(INVOICE.TOTAL) AS TOTAL
FROM CUSTOMER
JOIN INVOICE
ON CUSTOMER.CUSTOMER_ID= INVOICE.CUSTOMER_ID
GROUP BY 1,2,3
ORDER BY TOTAL DESC
LIMIT 1;


-- Write query to return the email, first name, last name, & Genre of all Rock Music 
-- listeners. Return your list ordered alphabetically by email starting with A 
SELECT DISTINCT CUSTOMER.EMAIL, CUSTOMER.FIRST_NAME, CUSTOMER.LAST_NAME, GENRE.NAME AS GENRE
FROM CUSTOMER
JOIN INVOICE
ON CUSTOMER.CUSTOMER_ID=INVOICE.CUSTOMER_ID
JOIN INVOICE_LINE
ON INVOICE.INVOICE_ID=INVOICE_LINE.INVOICE_ID
JOIN TRACK
ON INVOICE_LINE.TRACK_ID=TRACK.TRACK_ID
JOIN GENRE
ON TRACK.GENRE_ID=GENRE.GENRE_ID
WHERE GENRE.NAME='ROCK'
ORDER BY CUSTOMER.EMAIL ASC;


-- Let's invite the artists who have written the most rock music in our dataset. Write a 
-- query that returns the Artist name and total track count of the top 10 rock bands
SELECT ARTIST.NAME, count(TRACK.TRACK_ID) AS TOTAL_TRACKS FROM ARTIST
JOIN ALBUM ON ARTIST.ARTIST_ID=ALBUM.ARTIST_ID
JOIN TRACK ON ALBUM.ALBUM_ID=TRACK.ALBUM_ID
JOIN GENRE ON TRACK.GENRE_ID=GENRE.GENRE_ID
WHERE GENRE.NAME='ROCK'
GROUP BY ARTIST.NAME,ARTIST.ARTIST_ID
ORDER BY TOTAL_TRACKS DESC
LIMIT 10;


-- Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the 
-- longest songs listed first
SELECT NAME, MILLISECONDS FROM TRACK
WHERE MILLISECONDS > (SELECT Round(avg(MILLISECONDS)) FROM TRACK)
ORDER BY MILLISECONDS DESC;


-- Find how much amount spent by each customer on artists? Write a query to return 
-- customer name, artist name and total spent
SELECT CUSTOMER.CUSTOMER_ID, CUSTOMER.FIRST_NAME, CUSTOMER.LAST_NAME, ARTIST.NAME AS ARTIST, SUM(INVOICE_LINE.UNIT_PRICE) AS TOTAL_SPENT
FROM CUSTOMER
JOIN INVOICE ON CUSTOMER.CUSTOMER_ID = INVOICE.CUSTOMER_ID
JOIN INVOICE_LINE ON INVOICE.INVOICE_ID = INVOICE_LINE.INVOICE_ID
JOIN TRACK ON INVOICE_LINE.TRACK_ID = TRACK.TRACK_ID
JOIN ALBUM ON TRACK.ALBUM_ID = ALBUM.ALBUM_ID
JOIN ARTIST ON ALBUM.ARTIST_ID = ARTIST.ARTIST_ID
GROUP BY CUSTOMER.CUSTOMER_ID, CUSTOMER.FIRST_NAME, CUSTOMER.LAST_NAME, ARTIST
ORDER BY TOTAL_SPENT DESC;


-- We want to find out the most popular music Genre for each country. We determine the 
-- most popular genre as the genre with the highest amount of purchases. Write a query 
-- that returns each country along with the top Genre. For countries where the maximum 
-- number of purchases is shared return all Genres
WITH genre_count AS
(SELECT invoice.billing_country, genre.name, SUM(invoice_line.unit_price * invoice_line.quantity) AS purchases
FROM invoice
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
JOIN track ON invoice_line.track_id = track.track_id
JOIN genre ON track.genre_id = genre.genre_id
GROUP BY invoice.billing_country, genre.name), 
ranked AS
(SELECT *, RANK() OVER(PARTITION BY billing_country ORDER BY purchases DESC) AS genre_rank
FROM genre_count)
SELECT billing_country, name, purchases
FROM ranked
WHERE genre_rank = 1
ORDER BY purchases DESC;

-- Write a query that determines the customer that has spent the most on music for each 
-- country. Write a query that returns the country along with the top customer and how 
-- much they spent. For countries where the top amount spent is shared, provide all 
-- customers who spent this amount
WITH cust_country AS
(SELECT customer.customer_id, customer.first_name, customer.last_name, customer.country, SUM(invoice.total) AS total_spent from customer
JOIN invoice ON customer.customer_id=invoice.customer_id
GROUP BY 1,2,3,4),
ranked AS
(SELECT *,RANK() OVER(PARTITION BY country ORDER BY total_spent DESC) AS customer_rank
FROM cust_country)
SELECT customer_id, first_name, last_name, country, total_spent
FROM ranked
WHERE customer_rank=1
ORDER BY total_spent DESC;

