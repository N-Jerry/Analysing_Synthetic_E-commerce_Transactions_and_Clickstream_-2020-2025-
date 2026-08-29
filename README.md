# E-Commerce Transactions & Clickstream Analysis

## 📌 Project Overview

This project analyzes e-commerce transaction and clickstream data using **PostgreSQL** and **Python** to answer a set of business questions across different levels of analytical complexity.

The project combines transactional data with customer browsing behavior to investigate sales performance, customer behavior, product performance, and e-commerce activity.

Rather than loading the source CSV files directly into PostgreSQL, a data preparation process was implemented using **Python and Pandas** to ensure that the data was cleaned and loaded while maintaining the relational integrity of the database.

The project follows the workflow:

```text
Raw CSV Files
      │
      ▼
Python / Pandas
      │
      │  • Rename columns
      │  • Trim string values
      │  • Handle duplicates
      │  • Check for NULL values
      │  • Prepare data for ingestion
      ▼
PostgreSQL
      │
      ▼
SQL Analysis
      │
      ▼
Business Insights
```

---

## 🎯 Project Objectives

The main objectives of this project are to:

* Build a relational PostgreSQL database from raw e-commerce datasets.
* Establish appropriate primary and foreign key relationships between tables.
* Perform data quality checks and preparation before ingestion.
* Load cleaned data while preserving referential integrity.
* Use SQL to answer business questions ranging from basic descriptive analysis to more advanced analytical problems.
* Demonstrate practical PostgreSQL and SQL skills in an e-commerce analytics context.
* Extract actionable insights from transactional and clickstream data.

---

## 📂 Project Structure

```text
E-commerce-Transactions-Clickstream/
│
├── Analysis/
│   ├── Basic/
│   │   └── ...
│   ├── Intermediate/
│   │   └── ...
│   └── Advanced/
│       └── ...
│
├── Dataset/
│   ├── customers.csv
│   ├── products.csv
│   ├── sessions.csv
│   ├── events.csv
│   ├── orders.csv
│   ├── order_items.csv
│   └── reviews.csv
│
├── Power BI/
│   ├── images/
│   │   └── fact_clickstream :Having images of visuals related to this grain(clicks)
│   │   └── fact_review: Having images of visuals to this grain(review)
│       └── fact_sales: Having images of visuals to this grain(sales).
|      A row here is one per order which is different from the other fact not included in the images which is one row per order per product
|   
├── Table_Definition&Ingestion/
│   ├── table_definition.sql
│   ├── data_ingestion.sql
│   └── data_cleaning.ipynb
│
└── README.md
```

---

## 🗄️ Database

The project uses **PostgreSQL** as the relational database management system.

The database consists of seven related tables:

| Table         | Description                                                      |
| ------------- | ---------------------------------------------------------------- |
| `customers`   | Contains customer information                                    |
| `products`    | Contains product and product category information                |
| `sessions`    | Contains customer browsing sessions                              |
| `events`      | Contains individual clickstream events generated during sessions |
| `orders`      | Contains customer order information                              |
| `order_items` | Contains the products included in each order                     |
| `reviews`     | Contains customer reviews and ratings                            |

The tables are connected using primary and foreign key relationships to maintain consistency across the database.

---

# 🔧 Data Preparation & Ingestion

## 1. Table Definition

The `table_definition.sql` script creates the PostgreSQL tables and establishes the required relational constraints.

The tables are created in an order that allows the required foreign key relationships to be established correctly.

The script defines:

* Primary keys
* Foreign keys
* Appropriate PostgreSQL data types
* Required constraints
* Relationships between the datasets

---

## 2. Data Cleaning & Ingestion

The `data_cleaning.ipynb` notebook performs the preparation of the raw CSV files before they are loaded into PostgreSQL.

The notebook uses **Python and Pandas** to:

1. Read the CSV files.
2. Rename columns to follow a consistent naming convention.
3. Trim whitespace from string columns.
4. Identify and handle duplicate records.
5. Check for missing (`NULL`) values.
6. Prepare the cleaned datasets for database ingestion.
7. Load the cleaned data into PostgreSQL.

The datasets are inserted in the appropriate order based on their relationships and foreign key dependencies. This ensures that **referential integrity is maintained during ingestion**.

### Why Python was used for ingestion

The `data_ingestion.sql` script contains `\copy` psql commands for each table that could be used to populate the database if the source data were already clean and appropriately formatted.

However, because the raw CSV files require data preparation before insertion, the Python notebook provides a more suitable ingestion process.

The SQL ingestion script therefore serves as a reference for how the data could be inserted directly into PostgreSQL after appropriate cleaning.

---

# 📊 SQL Analysis

The `Analysis/` directory contains SQL scripts used to answer business questions based on the e-commerce data.

The questions are organized according to their level of complexity:

```text
Analysis/
│
├── Basic/
├── Intermediate/
└── Advanced/
```

### Basic Analysis

Focuses on fundamental SQL operations such as:

* Filtering
* Sorting
* Aggregation
* `GROUP BY`
* Basic joins
* Simple business metrics

### Intermediate Analysis

Introduces more complex analytical requirements using techniques such as:

* Multi-table joins
* Common Table Expressions (CTEs)
* Subqueries
* Conditional logic
* Date-based analysis
* More complex aggregations

### Advanced Analysis

Focuses on more sophisticated analytical problems and SQL techniques, including:

* Window functions
* Ranking
* Running totals
* Customer behavior analysis
* Clickstream analysis
* Complex CTEs
* Advanced aggregations
* Multi-step analytical queries

The goal is not simply to demonstrate SQL syntax, but to use SQL to answer **business-oriented questions and derive meaningful insights from the data**.

---

# 🛠️ Technologies Used

| Technology           | Purpose                                       |
| -------------------- | --------------------------------------------- |
| **Power BI**         | Data modeling and visualisation               |
| **PostgreSQL**       | Relational database and SQL analysis          |
| **SQL**              | Data analysis and business question answering |
| **Python**           | Data preparation and ingestion                |
| **Pandas**           | Data cleaning and transformation              |
| **Jupyter Notebook** | Data preparation workflow                     |
| **Git / GitHub**     | Version control and project documentation     |

---

# 🔄 End-to-End Workflow

The complete workflow of the project is:

### 1. Source Data

Raw e-commerce transaction and clickstream data is provided as CSV files.

### 2. Data Preparation

Python/Pandas is used to inspect and prepare the data before ingestion.

### 3. Database Creation

PostgreSQL tables and relationships are created using `table_definition.sql`.

### 4. Data Ingestion

Cleaned datasets are loaded into PostgreSQL in dependency order to preserve referential integrity.

### 5. Data Analysis

SQL scripts are used to answer business questions at basic, intermediate, and advanced levels.

### 6. Visualisation

Creating visuals in Power BI to better share findings and answer business questions on the 3 identified **"grains"** of our data.

---

# 📈 Key Analytical Areas

The analysis explores several aspects of the e-commerce business, including:

* Sales performance
* Customer purchasing behavior
* Product performance
* Order trends
* Customer reviews
* Website sessions
* Clickstream behavior
* Customer engagement
* E-commerce conversion behavior
* Relationships between browsing activity and purchasing behavior

---

# 🚀 Future Improvements

Potential extensions to the project include:

* Creating reusable SQL views for frequently used business metrics.
* Implementing automated data ingestion.
* Adding data quality checks before ingestion into postgres.

---

## 📚 Dataset

The project uses the **E-commerce Transactions + Clickstream** dataset published on Kaggle.

The dataset contains synthetic e-commerce transaction and clickstream data covering customers, products, sessions, events, orders, order items, and reviews.

**Source:** Kaggle — E-commerce Transactions + Clickstream
