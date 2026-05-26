# 🏡 Real Estate Market & Sales Performance Analytics

![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![SQL](https://img.shields.io/badge/SQL-003B57?style=for-the-badge&logo=postgresql&logoColor=white)
![Google BigQuery](https://img.shields.io/badge/Google_BigQuery-669DF6?style=for-the-badge&logo=google-cloud&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)

---

## 📌 Project Overview

This end-to-end Business Intelligence and Data Analytics project analyzes a large-scale real estate dataset containing over **100,000+ records** to uncover actionable insights into housing markets, pricing behavior, regional performance, and sales trends.

The project leverages:

- **Power BI** for interactive dashboarding and advanced DAX calculations
- **Google BigQuery** for scalable cloud-based SQL analytics
- **Excel** for preprocessing and exploratory validation
- **Python** for additional analysis and automation

The dashboard helps stakeholders:

- monitor Year-over-Year market growth
- compare asking price vs final purchase price
- analyze pricing per square meter
- evaluate negotiation margins
- identify high-performing sales regions
- understand macroeconomic influences on housing demand

---

## 🚀 Key Business Objectives

- Analyze regional housing market trends
- Measure YoY growth in sales and revenue
- Compare asking price vs final purchase price
- Identify profitable property types
- Detect pricing patterns across locations
- Evaluate macroeconomic effects on housing prices
- Build scalable analytics architecture using cloud technologies

---

## 🏗️ Tech Stack

| Category | Tools Used |
|---|---|
| BI & Visualization | Power BI |
| Database & Warehousing | Google BigQuery |
| Query Language | SQL |
| Data Analysis | Python |
| Spreadsheet Analysis | Excel |
| Cloud Platform | Google Cloud Platform |
| Data Modeling | DAX + Star Schema |

---

## 📂 Repository Structure

```text
Real-Estate-Analytics/
│
├── README.md
├── Housing_Report.pbix
├── SQL_Scripts.sql
├── Python_Analysis.ipynb
├── Dataset/
├── Screenshots/
│   ├── dashboard1.png
│   ├── dashboard2.png
│   ├── dashboard3.png ```  

## ⚙️ Data Engineering & SQL Processing

Large-scale preprocessing and exploratory analysis were initially performed directly in BigQuery to optimize performance and reduce dashboard load times.

### 🔹 Base Data Cleaning & Extraction

```sql
SELECT 
    house_id,
    UPPER(region) AS region,
    sales_type,
    house_type,
    EXTRACT(YEAR FROM date) AS sales_year,
    purchase_price,
    offer_price,
    sqm,
    SAFE_DIVIDE(purchase_price, sqm) AS sqm_price,
    year_build
FROM 
    `gcp_project.housing_dataset.raw_sales_data`
WHERE 
    purchase_price IS NOT NULL
    AND sqm > 0;
```

### 🔹 Regional Summary View

```sql
CREATE OR REPLACE VIEW `gcp_project.housing_dataset.regional_summary` AS

SELECT 
    region,
    COUNT(DISTINCT house_id) AS total_units_sold,
    SUM(purchase_price) AS total_revenue,
    AVG(purchase_price) AS avg_purchase_price
FROM 
    `gcp_project.housing_dataset.raw_sales_data`
GROUP BY 
    region
ORDER BY 
    total_revenue DESC;
```

---

# 🧮 Advanced DAX Measures

Advanced DAX calculations were implemented to enable deep analytical insights and time-intelligence reporting.

### 🔹 Year-over-Year Sales Growth

```dax
YoY_Sales_Growth = 

VAR CurrentYearSales =
    CALCULATE(
        SUM(Housing[purchase_price]),
        YEAR(Housing[date]) = YEAR(MAX(Housing[date]))
    )

VAR PrevYearSales =
    CALCULATE(
        SUM(Housing[purchase_price]),
        YEAR(Housing[date]) = YEAR(MAX(Housing[date])) - 1
    )

RETURN 
    DIVIDE(
        CurrentYearSales - PrevYearSales,
        PrevYearSales,
        BLANK()
    )
```

### 🔹 Last 12 Months Sales

```dax
Sales_Last_12_Months =

CALCULATE(
    SUM(Housing[purchase_price]),
    DATESINPERIOD(
        Housing[date],
        MAX(Housing[date]),
        -12,
        MONTH
    )
)
```

### 🔹 Year-To-Date Sales

```dax
TotalYTD =

TOTALYTD(
    SUM(Housing[purchase_price]),
    Housing[date]
)
```

### 🔹 Median Sales Change

```dax
Median_Sales_Change =

VAR PrevYear =
    CALCULATE(
        MEDIAN(Housing[purchase_price]),
        YEAR(Housing[date]) =
        YEAR(MAX(Housing[date])) - 1
    )

VAR CurrYear =
    CALCULATE(
        MEDIAN(Housing[purchase_price]),
        YEAR(Housing[date]) =
        YEAR(MAX(Housing[date]))
    )

RETURN
    DIVIDE(
        CurrYear - PrevYear,
        PrevYear,
        BLANK()
    )
```

### 🔹 Sales by Region

```dax
Sales_By_Region =

CALCULATE(
    SUM(Housing[purchase_price]),
    ALLEXCEPT(
        Housing,
        Housing[region]
    )
)
```

---

# 📊 Dashboard Features & Insights

## 🏘️ 1. Housing Market Overview

Provides a high-level summary of market health and pricing dynamics.

### Key Visuals
- YoY Sales Growth by Sales Type
- Offer Price vs Purchase Price Scatter Plot
- Regional Median Price Growth
- Dynamic KPI Cards
- Revenue Trend Analysis

### Insights
- Identified high-growth housing regions
- Tracked seasonal pricing behavior
- Evaluated negotiation margins between offer and final sale prices

---

## 📈 2. Sales Performance Analytics

Focuses on volume, revenue generation, and square-meter valuations.

### Key Visuals
- Revenue by Region
- Average Price per Square Meter
- Monthly Sales Volume
- Sales-Type Performance Comparison

### Insights
- Detected top-performing revenue regions
- Compared sales distribution patterns
- Analyzed profitability per square meter

---

## 🏠 3. House Type & Economic Analysis

Drills down into specific property categories and macroeconomic factors.

### Key Visuals
- House-Type Performance Breakdown
- Inflation vs Mortgage Yield Trends
- Interest Rate Impact on Property Pricing
- Dynamic Area & City Filters

### Insights
- Studied macroeconomic impacts on housing demand
- Compared profitability across house categories
- Enabled hyper-local trend analysis

---

# 📈 Business Impact

This dashboard can help:

- Real estate firms optimize pricing strategies
- Investors identify profitable markets
- Analysts monitor housing growth trends
- Stakeholders evaluate regional performance
- Decision-makers track macroeconomic impacts

---

# 🧠 Key Skills Demonstrated

- SQL Query Optimization
- Cloud Data Warehousing
- Power BI Dashboard Development
- DAX Calculations
- Business Intelligence Reporting
- Data Cleaning & Transformation
- Time-Series Analysis
- KPI Development
- Data Modeling
- Statistical Analysis

---

# 🔗 Project Links

## Live Dashboard
[View the Live Interactive Dashboard](https://app.powerbi.com/view?r=eyJrIjoiM2Y5MTQzZGQtMjVlNS00ZTE5LThlNTgtMjllYjY2NDFiMjljIiwidCI6IjhmYmUwNDFmLTBjMDMtNDgxMS1iZTMzLWZlYWNhZGY2NTE3YiJ9)

## GitHub Repository
[GitHub Repository](https://github.com/flick-2me/Housing-Project.git)

---

# 👨‍💻 Developed By

**Shubham Chaudhary**  

### Skills
- SQL
- Power BI
- Tableau
- Python
- Excel
- Data Analytics
- Business Intelligence

---

# ⭐ Conclusion

This project was designed to simulate a real-world enterprise Business Intelligence workflow — from cloud-based data engineering and SQL preprocessing to advanced DAX analytics and executive-level dashboard reporting.

The goal was not just visualization, but transforming raw housing market data into strategic business insights.
