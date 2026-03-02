# AstroSage Call Center Performance Analysis

## 📌**Problem Statement**

AstroSage received a ₹1 crore investment to improve its call center operations.
The objective was to analyze historical consultation data to identify operational inefficiencies, customer satisfaction gaps, and profitability constraints.

The focus areas:

🔹Improve operational efficiency

🔹Enhance customer satisfaction

🔹Increase profitability

🔹Optimize staffing, training, and technology

## 📂 **Dataset**

The dataset contains 28,027 consultation interaction records, including:

🔹Call consultations

🔹Chat consultations

🔹 User ratings

🔹 Revenue metrics (amount, netAmount, astrologerEarnings)

🔹 Agent (Guru) information

🔹 Time attributes (Date, Month, Year, Hour)

After cleaning, 32 attributes were retained for analysis.

## 🛠 Approach

### Data Cleaning

🔹Removed duplicates using _id

🔹Standardized date-time formats

🔹Converted financial & duration columns to numeric

🔹Handled missing categorical values

🔹Created derived time fields (Date, Month, Hour, Month-Year)

### Exploratory Data Analysis (EDA)

🔹Pivot Tables for aggregation

🔹COUNT, SUM, AVERAGE, CORREL functions

🔹Daily & hourly trend analysis

🔹Revenue segmentation

🔹Agent workload benchmarking

### Visualization & Dashboard

🔹Interactive Excel Dashboard

🔹Slicers (Consultation Type, Year, Platform)

🔹Bar charts, column charts, distribution visuals

## 📊 EDA Insights
### 1. Call Completion Crisis

🔹Total Calls: 8,508

🔹Completed Calls: 3,450

🔹Completion Rate: 40.55%

🔹Failed/Unsuccessful Calls: 59.45%

🔹More than half of the calls are unsuccessful, indicating major operational inefficiency.

### 2. Revenue Dependency on Calls

🔹Total Revenue: ₹2,13,987.32

🔹Calls contribute 78.7% of revenue

🔹Chat contributes 21.3%

🔹Call performance directly drives business profitability.

### 3. Customer Satisfaction Gap

🔹Overall Average Rating: 2.93

🔹Call Rating: 3.50

🔹Chat Rating: 2.69

🔹Complimentary Rating: 4.50

🔹Service quality inconsistency impacts customer experience.

### 4️. Workload Imbalance

🔹Total Gurus: 128

🔹Average Calls per Guru: 66

🔹Small group handles majority of calls

🔹Uneven distribution increases burnout risk and service inconsistency.

### 5️. Peak Demand Pressure

🔹Peak Hour: 8 AM (660 calls)

🔹Peak Day: 10 December (430 calls)

🔹Staffing not aligned with demand spikes.

## 📈 Performance Metrics & KPI Framework

🔹Key metrics developed:

🔹Call Completion Rate

🔹Revenue by Consultation Type

🔹Average Rating by Platform

🔹Agent Workload Distribution

🔹Hourly & Daily Demand Patterns

Correlation between astrologer earnings and company revenue: 0.9999

## 🚀 Strategic Recommendations

🔹 Upgrade call routing & infrastructure

🔹 Optimize workforce allocation

🔹 Implement targeted training programs

🔹 Improve low-rated platforms

🔹 Introduce demand forecasting
