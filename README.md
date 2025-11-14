# 📚 Book Cafe SQL Analysis Project

## 📖 Overview  
The **Book Cafe SQL Analysis Project** analyzes book sales, café sales, customer behavior, and overall business performance for a fictional “Book Cafe.”  
This project uses **PostgreSQL** to derive insights, uncover patterns, and support data-driven decision-making.

---

## 🧰 Project Structure  
- [`book_cafe_dataset/`](https://github.com/lahiriyatin/Book_Cafe/tree/main/book_cafe_dataset)  
  Contains all dataset files:
  - CSV files for menu, customers, orders, order_items  
  - A `.sql` file containing **your PostgreSQL queries and solutions**

- `Book_Cafe_SQL_Analysis_Challenge.docx`  
  Contains the business scenario, list of SQL tasks, dataset description, and requirements  

- Main repository:  
  **https://github.com/lahiriyatin/Book_Cafe**

---

## 🎯 Objectives  
1. Explore and understand the dataset schema  
2. Write PostgreSQL queries to answer real-world business questions  
3. Analyze sales, customer patterns, and product performance  
4. Derive actionable insights from query results  

---

## 📋 Dataset Description  
The dataset includes the following key tables:

- `menu_books` — book listings  
- `menu_food` — café menu items  
- `customers` — customer information  
- `orders` — order headers  
- `order_items` — detailed items per order  

Important fields:

- IDs (book_id, food_id, customer_id, order_id)  
- Titles, authors, categories  
- Prices  
- order_date  
- item_type (`book` or `food`)  
- quantity  

### Relationships  
- **Customer → Orders** (1:N)  
- **Orders → Order Items** (1:N)  
- **Menu Items → Order Items** (1:N, via item_id + item_type)**  

All dataset files:  
👉 https://github.com/lahiriyatin/Book_Cafe/tree/main/book_cafe_dataset

---

## 📝 Challenge Document  
`Book_Cafe_SQL_Analysis_Challenge.docx` includes:

- Problem statement
- SQL questions to solve  
- Dataset explanation  
- Expected output formats  

---

## 📌 Solution File  
All PostgreSQL solution queries are stored in:

👉 **`book_cafe_dataset/book_cafe_dataset.sql`**  
(Located here: https://github.com/lahiriyatin/Book_Cafe/tree/main/book_cafe_dataset)

This `.sql` file contains:
- Table creation statements  
- Data loading  
- Complete SQL solutions for all challenge questions  
- Additional exploratory or advanced queries

---


