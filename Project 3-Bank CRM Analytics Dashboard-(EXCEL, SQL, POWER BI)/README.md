
# 📊 Bank CRM Analytics Dashboard [EXCEL, SQL, POWER BI]
## 📌 Problem Statement
As an Analytical CRM specialist, the objective of this project is to analyze customer data to identify key factors driving customer churn and support data-driven strategies to improve retention, service delivery, and customer satisfaction in a banking environment.

## 🗂Dataset
- The dataset consists of multiple relational tables, including customer information, credit card details, activity status, geography, and exit information.
- These datasets were integrated into a single master dataset using Excel Power Query, enabling a unified view of customer demographics, financial attributes, product usage, and churn status.

## 🛠 Approach
- The analysis began with data cleaning and preprocessing using Excel Power Query, including handling inconsistencies and transforming data into a structured format.
- SQL was used for data querying, aggregation, and deriving key metrics. Power BI was then used to build interactive dashboards for analyzing churn patterns, customer behavior, and engagement trends.
- The focus was on extracting actionable insights aligned with business objectives rather than isolated metrics

## 📈 EDA Insights
- Customers with 1 product show higher churn (27.71%), while churn reduces significantly for customers with 2 products (7.58%).
- Inactive customers have a higher churn rate (26.85%) compared to active customers (14.27%), highlighting engagement as a key factor.
- Germany has the highest churn rate (32.44%) despite having a smaller customer base.
- Customers aged 50+ show the highest churn rate (44.65%), indicating higher risk among older customers
- Churn does not show a consistent trend across tenure, indicating multiple influencing factors.
  
## 📊 Performance Metrics & KPI Framework
Key performance metrics were developed to evaluate customer behavior and churn, including:
- Churn does not show a consistent trend across tenure, indicating multiple influencing factors.
- Total Customers
- Active vs Inactive Customers
- Churned Customers
- Churn Rate (%)
- Average Balance.
  
Churn rate and customer activity emerged as critical indicators, highlighting the importance of engagement and product usage in customer retention.


## 🏗 Architecture Overview

```
┌──────────────────────────────────────────────┐
│                DATA SOURCE                   │
│  CustomerInfo | Bank_Churn | Geography       │
│  Credit Card | Activity | Exit Data          │
└──────────────────────────────────────────────┘
                      │
                      ▼
┌──────────────────────────────────────────────┐
│           DATA PREPROCESSING LAYER           │
│  - Data Cleaning (Power Query)               │
│  - Handling Missing Values                   │
│  - Data Transformation                       │
└──────────────────────────────────────────────┘
                      │
                      ▼
┌──────────────────────────────────────────────┐
│         DATA INTEGRATION LAYER               │
│  - Merging multiple datasets                 │
│  - Creating Master Dataset                   │
└──────────────────────────────────────────────┘
                      │
                      ▼
┌──────────────────────────────────────────────┐
│           ANALYTICAL PROCESSING              │
│  - SQL Queries (Aggregation, Joins)          │
│  - KPI Calculations                          │
│  - Churn Analysis                            │
└──────────────────────────────────────────────┘
                      │
                      ▼
┌──────────────────────────────────────────────┐
│           VISUALIZATION LAYER                │
│  - Power BI Dashboards                       │
│  - Customer Segmentation                     │
│  - Churn Analysis Visuals                    │
└──────────────────────────────────────────────┘
                      │
                      ▼
┌──────────────────────────────────────────────┐
│           BUSINESS INSIGHTS OUTPUT           │
│  - Churn Drivers                             │
│  - Customer Segmentation                     │
│  - Retention Strategies                      │
└──────────────────────────────────────────────┘

```

## 🚀 Future Improvements
- Implement predictive models for churn prediction
- Automate data pipelines for real-time KPI tracking
- Enhance segmentation using behavioral clustering
- Integrate additional financial and transactional data
- Build advanced dashboards with drill-through analysis
