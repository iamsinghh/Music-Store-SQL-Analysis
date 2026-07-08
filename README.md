# Music Store SQL Analysis

A SQL-based data analysis project using **MySQL** to analyze the Chinook Music Store database and solve real-world business problems through SQL querying and analytical techniques.

---

## 📌 Project Overview

This project explores customer behavior, sales performance, music genres, artists, and revenue trends using SQL. The objective is to answer business-oriented questions by applying SQL concepts such as joins, aggregations, subqueries, Common Table Expressions (CTEs), and window functions.

---

## 🛠 Tech Stack

- MySQL 8.0
- MySQL Workbench
- Git
- GitHub

---

## 📚 SQL Concepts Covered

- SELECT Statements
- Filtering (`WHERE`)
- Sorting (`ORDER BY`)
- Aggregate Functions (`SUM`, `COUNT`, `AVG`)
- GROUP BY
- INNER JOIN
- Subqueries
- Common Table Expressions (CTEs)
- Window Functions
- RANK()

---

## 📈 Business Questions Solved

- Senior-most employee based on job title
- Countries with the highest number of invoices
- Top 3 invoice totals
- City generating the highest revenue
- Best customer by total spending
- Rock music listeners
- Top 10 Rock artists
- Tracks longer than the average song length
- Customer spending on each artist
- Most popular music genre for each country
- Highest spending customer for each country

---

## 🗄 Database Schema

![ER Diagram](ER_Diagram.png)

---

# ⭐ Featured Solution 1

## Business Question

**Find the Top 10 Rock Artists based on the number of Rock tracks.**

### SQL

```sql
SELECT ARTIST.NAME,
COUNT(TRACK.TRACK_ID) AS TOTAL_TRACKS
FROM ARTIST
JOIN ALBUM
ON ARTIST.ARTIST_ID = ALBUM.ARTIST_ID
JOIN TRACK
ON ALBUM.ALBUM_ID = TRACK.ALBUM_ID
JOIN GENRE
ON TRACK.GENRE_ID = GENRE.GENRE_ID
WHERE GENRE.NAME = 'ROCK'
GROUP BY ARTIST.NAME, ARTIST.ARTIST_ID
ORDER BY TOTAL_TRACKS DESC
LIMIT 10;
```

### Sample Output

| Artist | Total Tracks |
|---------|-------------:|
| Led Zeppelin | 114 |
| U2 | 112 |
| Deep Purple | 92 |
| Iron Maiden | 81 |
| Pearl Jam | 54 |
| Van Halen | 52 |
| Queen | 45 |
| The Rolling Stones | 41 |
| Creedence Clearwater Revival | 40 |
| Kiss | 35 |

---

# ⭐ Featured Solution 2

## Business Question

**Determine the most popular music genre for each country.**

### SQL

```sql
WITH genre_count AS
(
SELECT invoice.billing_country,
genre.name,
SUM(invoice_line.unit_price * invoice_line.quantity) AS purchases
FROM invoice
JOIN invoice_line
ON invoice.invoice_id = invoice_line.invoice_id
JOIN track
ON invoice_line.track_id = track.track_id
JOIN genre
ON track.genre_id = genre.genre_id
GROUP BY invoice.billing_country, genre.name
),

ranked AS
(
SELECT *,
RANK() OVER(
PARTITION BY billing_country
ORDER BY purchases DESC
) AS genre_rank
FROM genre_count
)

SELECT billing_country,
name,
purchases
FROM ranked
WHERE genre_rank = 1
ORDER BY purchases DESC;
```

### Sample Output

| Country | Genre | Purchases |
|---------|-------|----------:|
| USA | Rock | 555.39 |
| Canada | Rock | 329.67 |
| France | Rock | 208.89 |
| Brazil | Rock | 202.95 |
| Germany | Rock | 192.06 |
| United Kingdom | Rock | 164.34 |
| Czech Republic | Rock | 141.57 |
| Portugal | Rock | 106.92 |

*Output truncated for brevity.*

---

# ⭐ Featured Solution 3

## Business Question

**Find the highest spending customer in each country.**

### SQL

```sql
WITH cust_country AS
(
SELECT
customer.customer_id,
customer.first_name,
customer.last_name,
customer.country,
SUM(invoice.total) AS total_spent
FROM customer
JOIN invoice
ON customer.customer_id = invoice.customer_id
GROUP BY
customer.customer_id,
customer.first_name,
customer.last_name,
customer.country
),

ranked AS
(
SELECT *,
RANK() OVER(
PARTITION BY country
ORDER BY total_spent DESC
) AS customer_rank
FROM cust_country
)

SELECT
customer_id,
first_name,
last_name,
country,
total_spent
FROM ranked
WHERE customer_rank = 1
ORDER BY total_spent DESC;
```

### Sample Output

| Country | Customer | Total Spent |
|---------|----------|------------:|
| Czech Republic | František Wichterlová | 144.54 |
| Ireland | Hugh O'Reilly | 114.84 |
| India | Manoj Pareek | 111.87 |
| Brazil | Luís Gonçalves | 108.90 |
| Portugal | João Fernandes | 102.96 |
| Canada | François Tremblay | 99.99 |
| France | Wyatt Girard | 99.99 |
| Spain | Enrique Muñoz | 98.01 |

*Output truncated for brevity.*

---

## 💡 Key Insights

- Rock is the most popular genre across the majority of countries.
- Led Zeppelin has the highest number of Rock tracks in the dataset.
- Customer spending patterns vary across different countries.
- Window functions were used to identify top-performing customers and genres.
- SQL can be effectively used to solve business-oriented analytical problems.

---

## 📂 Repository Structure

```
Music-Store-SQL-Analysis/
│
├── README.md
├── Music_Store_Analysis.sql
└── ER_Diagram.png
```

---

## 🚀 How to Run

1. Import the Chinook (Music Store) database into MySQL.
2. Open `Music_Store_Analysis.sql`.
3. Execute the queries sequentially using MySQL Workbench.

---

## 👨‍💻 Author

**Aman Singh**

Data Analyst | SQL | Excel | Power BI | Python
