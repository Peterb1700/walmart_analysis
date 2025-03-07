# Walmart Sales Data Analysis: End-to-End Data Pipeline & Visualization Project. Python, SQL, PowerBI



![Screenshot 2025-02-15 120422](https://github.com/user-attachments/assets/63c8c5c3-0f3c-486c-93ad-b30040d1dcb8)




---

## Project Overview

This project showcases an end-to-end data analysis pipeline using Walmart’s sales dataset from Kaggle with 10,000 records. It covers every stage—from environment setup, data acquisition and cleaning, to advanced SQL querying and interactive visualization with Power BI. The project demonstrates practical applications of Python, SQL, and Power BI to extract actionable insights from real-world sales data.

---

## Tech Stack & Tools

- **Programming Languages & Tools**: Python, SQL, Power BI, PostgreSQL, VS Code
- **Key Python Libraries**: 
  - `pandas` for data manipulation and cleaning
  - `sqlalchemy` for database connectivity
  - `pymysql` and `psycopg2` for SQL database interfacing
- **Data Source**: [Walmart Sales Dataset on Kaggle](https://www.kaggle.com/datasets/najir0123/walmart-10k-sales-datasets)  
- **Dashboarding**: Power BI for interactive visualizations and business insights  
- **Version Control**: Git & GitHub

---

## Project Workflow

### 1. Environment & Dataset Setup

- **VS Code & Virtual Environment**: 
  - Created a dedicated project folder in VS Code.
  - Set up a Python virtual environment using `python -m venv myenv` to manage dependencies.
- **Kaggle API Configuration**: 
  - Downloaded the `kaggle.json` API token from Kaggle.
  - Placed the token in the local `.kaggle` folder to authenticate and download datasets programmatically.
- **Dataset Download**: 
  - Retrieved the Walmart dataset using the command:
    ```bash
    kaggle datasets download -d najir0123/walmart-10k-sales-datasets
    ```
  - Unzipped the downloaded file to access the CSV data.

---

### 2. Data Acquisition & Cleaning

- **Data Loading**:
  - Loaded the CSV into a Pandas DataFrame:
    ```python
    import pandas as pd
    df = pd.read_csv('Walmart.csv', encoding_errors='ignore')
    ```
- **Data Exploration**:
  - Reviewed the dataset’s structure with `df.info()`, `df.describe()`, and `df.head()`.
  - Identified issues such as missing values, duplicates, and improper data types (e.g., `unit_price` stored as an object) :contentReference[oaicite:0]{index=0}.
- **Cleaning Process**:
  - **Duplicates & Missing Values**: Removed duplicates using `df.drop_duplicates(inplace=True)` and handled missing values with `df.dropna(inplace=True)`.
  - **Currency Conversion**: Removed the dollar sign from `unit_price` and converted it to a float:
    ```python
    df['unit_price'] = df['unit_price'].str.replace('$', '').astype(float)
    ```
  - **Feature Engineering**: Created a new column `total` by multiplying `unit_price` with `quantity` to compute transaction totals.
- **Outcome**: The refined dataset contained 9,969 records with 11 cleaned columns, ready for deeper analysis.

---

### 3. Data Loading & SQL Analysis

- **Database Setup**:
  - Configured PostgreSQL and MySQL connections using SQLAlchemy. Adjusted connection strings to handle special characters (e.g., replacing `@` with `%40` in passwords).
- **Data Import**:
  - Loaded the cleaned DataFrame into PostgreSQL:
    ```python
    from sqlalchemy import create_engine
    engine_psql = create_engine("postgresql+psycopg2://postgres:Banana%40@localhost:5432/walmart_db")
    df.to_sql(name='walmart', con=engine_psql, if_exists='append', index=False)
    ```
- **SQL Analysis**:
  - **Exploratory Queries**: Executed queries to get an overview of transactions, payment methods, and branch distribution.
  - **Advanced SQL Techniques**:
    - **Window Functions**: Utilized to rank branches by average ratings per category.
    - **Common Table Expressions (CTEs)**: Employed to identify the busiest day for each branch.
    - **Aggregations & Grouping**: Analyzed sales trends, payment methods, and profit margins across different dimensions.
  - **Sample SQL Query** (Busiest Day per Branch):
    ```sql
    WITH date_cte AS (
      SELECT branch, 
             TO_CHAR(TO_DATE(date, 'DD/MM/YY'), 'Day') as day_name,
             COUNT(*) as no_transactions,
             RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) as rank
      FROM walmart
      GROUP BY branch, day_name
    )
    SELECT branch, day_name, no_transactions
    FROM date_cte
    WHERE rank = 1;
    ```
  - These queries provided critical insights into sales patterns and customer behavior :contentReference[oaicite:1]{index=1}.

---

### 4. Visualization & Dashboard Development

- **Data Preparation in Power BI**:
  - Imported the cleaned data into Power BI.
  - Resolved date formatting issues by splitting and merging date components in the Power Query Editor, converting text dates in DD-MM-YYYY format to proper date types.
- **Dashboard Features**:
  - **Interactive Elements**: Added slicers for time of day, state, and payment method to enable dynamic filtering.
  - **Visualizations**:
    - **Pie Charts**: Displayed total spent per payment method.
    - **Column Charts**: Visualized total revenue per category.
    - **Line Charts**: Illustrated average ratings over time after resolving issues with dense date values.
  - **Segmentation**: Added a `time_of_day` column in SQL to categorize transactions into Morning, Afternoon, and Evening, enhancing the segmentation in visualizations.
- **Outcome**: The Power BI dashboard effectively communicates sales performance trends and offers interactive analysis capabilities for stakeholders.

---

## Challenges & Lessons Learned

- **Data Quality Issues**: Encountered challenges with missing values, duplicate records, and inconsistent data types. Overcame these by applying rigorous data cleaning steps.
- **Data Conversion**: Faced a hurdle in converting the `unit_price` column due to the presence of the dollar sign. Resolved it using a string replace method before type conversion.
- **SQL Connectivity**: Special characters in PostgreSQL passwords (like the `@` symbol) required URL encoding to establish a successful connection.
- **Date Formatting in Power BI**: Adjusting date formats in Power Query required splitting and merging date components, emphasizing the importance of data transformation in visualization tools.

---

## Key Insights

- **Sales Distribution**: Analysis revealed that credit card transactions dominated, but there’s significant volume across e-wallets and cash payments.
- **Branch Performance**: SQL queries identified branches with superior performance and highlighted trends in customer behavior.
- **Revenue & Profitability**: Calculations on transaction totals and profit margins provided actionable insights into product category performance.
- **Operational Efficiency**: The end-to-end pipeline—from data acquisition to visualization—demonstrates how integrating multiple tools can drive business intelligence and decision-making.

---
