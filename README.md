# Olist E-Commerce Data Analysis

## 📊 Project Overview

This project presents an end-to-end analysis of the Brazilian Olist E-Commerce dataset. The objective is to transform raw e-commerce data into meaningful business insights using Python, PostgreSQL, SQL, and Power BI.

The analysis focuses on sales performance, customer behavior, product performance, payment methods, reviews, sellers, and delivery performance.

---

## 🎯 Business Objectives

The main objectives of this project are:

* Analyze overall sales and revenue performance
* Calculate monthly revenue and Average Order Value (AOV)
* Analyze month-over-month revenue growth
* Identify top-performing products and categories
* Analyze customer purchasing behavior
* Compare state-wise sales performance
* Analyze payment methods and transaction behavior
* Evaluate delivery performance and late deliveries
* Analyze customer review scores
* Identify important business trends and patterns

---

## 🛠️ Tools & Technologies

* **Python** – Data cleaning and preprocessing
* **Pandas / NumPy** – Data manipulation and analysis
* **PostgreSQL** – Database management and SQL analysis
* **SQL** – Business queries, joins, aggregations, CTEs and window functions
* **Power BI** – Interactive dashboard and data visualization

---

## 📂 Dataset

The project uses the Brazilian Olist E-Commerce dataset containing information about:

* Orders
* Customers
* Order Items
* Products
* Sellers
* Payments
* Reviews
* Geolocation
* Product Category Translation

The dataset contains approximately 99K orders and 96K unique customers.

---

## 🧹 Data Cleaning & Preparation

The raw datasets were cleaned and prepared before analysis.

Major preprocessing tasks included:

* Handling missing values
* Removing duplicate records where required
* Standardizing text fields
* Converting date and numeric columns into appropriate formats
* Creating delivery-related metrics
* Creating monthly order information
* Preparing cleaned datasets for PostgreSQL analysis

---

## 🧮 SQL Analysis

PostgreSQL was used to perform business-oriented SQL analysis.

Key analyses include:

* Monthly revenue
* Month-over-month revenue growth
* Average Order Value (AOV)
* Top customers by revenue
* Product and category performance
* State-wise revenue
* Payment method analysis
* Seller performance
* Delivery performance
* Review analysis
* Customer and order analysis

The SQL analysis demonstrates the use of:

* `JOIN`
* `GROUP BY`
* Aggregate functions
* `CASE`
* `CTE`
* `RANK()`
* `LAG()`
* `DATE_TRUNC()`
* Filtering and ordering
* Subqueries

---

## 📊 Power BI Dashboard

An interactive Power BI dashboard was created to provide a visual overview of the business performance.

### Dashboard Pages

**1. Executive Overview**

* Total Revenue
* Total Orders
* Total Customers
* Monthly Revenue Trend
* Key business KPIs

**2. Sales & Product Analysis**

* Product/category performance
* Revenue analysis
* Top-performing products
* Sales trends

**3. Customer & Delivery Analysis**

* Customer analysis
* State-wise performance
* Delivery performance
* Late delivery analysis
* Customer review insights

---

## 📸 Dashboard Preview

### Executive Overview

![Executive Overview](screenshots/executive_overview.png)

### Sales & Product Analysis

![Sales & Product Analysis](screenshots/sales_product_analysis.png)

### Customer & Delivery Analysis

![Customer & Delivery Analysis](screenshots/customer_delivery_analysis.png)

---

## 🔍 Key Insights

The dashboard and SQL analysis were used to identify important patterns in:

* Revenue trends
* Customer purchasing behavior
* Product and category performance
* Regional sales performance
* Payment preferences
* Delivery performance
* Customer satisfaction

---

## 📁 Project Structure

```text
olist-ecommerce-data-analysis/
│
├── README.md
│
├── SQL/
│   └── olist_analysis.sql
│
├── Python/
│   └── data_cleaning.ipynb
│
├── PowerBI/
│   └── Olist_Ecommerce_Dashboard.zip
│
└── screenshots/
    ├── executive_overview.png
    ├── sales_product_analysis.png
    └── customer_delivery_analysis.png
```

---

## 🚀 Project Workflow

```text
Raw Dataset
     ↓
Data Cleaning using Python
     ↓
Data Storage in PostgreSQL
     ↓
SQL Business Analysis
     ↓
Data Modeling
     ↓
Power BI Dashboard
     ↓
Business Insights
```

---

## 💡 Skills Demonstrated

This project demonstrates practical experience in:

**Data Cleaning → SQL → Data Analysis → Data Visualization → Business Intelligence**

Key technical skills demonstrated:

* Python
* Pandas
* NumPy
* PostgreSQL
* Advanced SQL
* Data Cleaning
* Data Analysis
* Power BI
* Dashboard Development
* KPI Analysis
* Business Insight Generation

---

## 👩‍💻 Author

**Shivani singh**

Aspiring Data Analyst

Skills: Python | SQL | PostgreSQL | Power BI | Excel | Tableau

---

## ⭐ Project

If you find this project useful, feel free to explore the repository and the analysis files.
