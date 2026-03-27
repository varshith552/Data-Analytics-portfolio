USE bank_crm;

--                                                                           OJECTIVE QUESTIONS
-- 2)Top 5 customers with highest Estimated Salary in the last quarter (Oct–Dec).
SELECT CustomerId, Surname, EstimatedSalary
FROM bank_churn
WHERE MONTH(`Bank DOJ`) BETWEEN 10 AND 12
ORDER BY EstimatedSalary DESC
LIMIT 5;

-- 3)Calculate the average number of products used by customers who have a credit card (SQL)
SELECT AVG(NumOfProducts) 
AS Avg_Products_CreditCard
FROM Bank_Churn
WHERE HasCrCard = 1;

-- 5)Compare the average credit score of customers who have exited and those who remain.
SELECT 
    Exited,
    AVG(CreditScore) AS Avg_CreditScore
FROM Bank_Churn
GROUP BY Exited;

-- 6)Which gender has a higher average estimated salary, and how does it relate to the number of active accounts? (SQL)
SELECT 
    GenderCategory,
    AVG(EstimatedSalary) AS Avg_Salary,
    SUM(IsActiveMember) AS Active_Accounts
FROM Bank_Churn
GROUP BY GenderCategory;

-- 7)Segment the customers based on their credit score and identify the segment with the highest exit rate. (SQL)
SELECT 
    CreditScoreGroup,
    COUNT(CustomerId) AS Total_Customers,
    SUM(Exited) AS Exited_Customers,
    ROUND((SUM(Exited) / COUNT(CustomerId)) * 100,2) AS Exit_Rate
FROM Bank_Churn
GROUP BY CreditScoreGroup
ORDER BY Exit_Rate DESC;

-- 8)Find out which geographic region has the highest number of active customers with a tenure greater than 5 years. (SQL)

SELECT 
    GeographyLocation,
    COUNT(CustomerId) AS Active_Customers
FROM Bank_Churn
WHERE IsActiveMember = 1
AND Tenure > 5
GROUP BY GeographyLocation
ORDER BY Active_Customers DESC;

-- 11)Examine the trend of customers joining over time and identify any seasonal patterns (yearly or monthly). Prepare the data through SQL and then visualize it.

SELECT 
    YEAR(`Bank DOJ`) AS Join_Year,
    COUNT(CustomerId) AS Customers_Joined
FROM Bank_Churn
GROUP BY Join_Year
ORDER BY Join_Year;

-- 15)Using SQL, find the gender-wise average income in each geography and rank the genders based on average income.

SELECT 
    GeographyLocation,
    GenderCategory,
    round( AVG(EstimatedSalary),2 ) AS Avg_Income,
    RANK() OVER (
        PARTITION BY GeographyLocation 
        ORDER BY AVG(EstimatedSalary) DESC
    ) AS Rank_In_Geography
FROM Bank_Churn
GROUP BY GeographyLocation, GenderCategory;

-- 16)Find the average tenure of customers who have exited in each age bracket (18–30, 30–50, 50+). (SQL)

SELECT 
    age_group,
    AVG(Tenure) AS Avg_Tenure
FROM Bank_Churn
WHERE Exited = 1
GROUP BY Age_Group;

-- 19)Rank each bucket of credit score as per the number of customers who have churned the bank.

SELECT 
    CreditScoreGroup,
    COUNT(CustomerId) AS Churned_Customers,
    RANK() OVER (ORDER BY COUNT(CustomerId) DESC) AS Rank_By_Churn
FROM Bank_Churn
WHERE Exited = 1
GROUP BY CreditScoreGroup;

-- 20)According to age buckets, find the number of customers who have a credit card. Also retrieve those buckets that have lesser than average number of credit cards per bucket. (SQL)

WITH Age_Card_Count AS (
    SELECT 
        Age_Group,
        COUNT(CustomerId) AS CreditCard_Customers
    FROM Bank_Churn
    WHERE HasCrCard = 1
    GROUP BY Age_Group
),
Avg_Value AS (
    SELECT AVG(CreditCard_Customers) AS Avg_Cards
    FROM Age_Card_Count
)
SELECT 
    a.Age_Group,
    a.CreditCard_Customers
FROM Age_Card_Count a, Avg_Value b
WHERE a.CreditCard_Customers < b.Avg_Cards;

-- 21)Rank the locations based on number of customers who have churned and average balance. (SQL)

SELECT 
    GeographyLocation,
    COUNT(CASE WHEN Exited = 1 THEN 1 END) AS Churned_Customers,
    ROUND(AVG(Balance),2) AS Avg_Balance,
    RANK() OVER (
        ORDER BY COUNT(CASE WHEN Exited = 1 THEN 1 END) DESC, 
                 AVG(Balance) DESC
    ) AS Rank_By_Churn_And_Balance
FROM Bank_Churn
GROUP BY GeographyLocation;

-- 22)Create a column combining CustomerID and Surname in the format “CustomerID_Surname”. (SQL)

SELECT 
    CustomerId,
    Surname,
    CONCAT(CustomerId, '_', Surname) AS CustomerID_Surname
FROM bank_churn;

-- 23)Without using “Join”, can we get the “ExitCategory” from ExitCustomers table to Bank_Churn table? If yes do this using SQL
-- 
Select 
    b.CustomerID,
    b.CreditScore,
    b.Balance,
    b.ExitID,
    (
        Select e.ExitCategory
        From exitcustomer e
        Where e.ExitID = b.ExitID
    ) as ExitCategory
From bank_churn b
Order By b.Balance desc;

-- 25)Write the query to get the customer IDs, their last name, and whether they are active or not for the customers whose surname ends with “on”.

SELECT 
    CustomerId,
    Surname,
    ActiveCategory
FROM Bank_Churn
WHERE Surname LIKE '%on'; 

--                                                                SUBJECTIVE QUESTIONS

-- 1.	What patterns can be observed in the spending habits of long-term customers compared to new customers, and what might these patterns suggest about customer loyalty?

SELECT 
    CASE 
        WHEN Tenure >= 7 THEN 'Long-Term'
        WHEN Tenure <= 3 THEN 'New'
        ELSE 'Mid-Term'
    END AS Customer_Type,

    COUNT(*) AS Total_Customers,
    ROUND(AVG(Balance),2) AS Avg_Balance,
    ROUND(AVG(NumOfProducts),2) AS Avg_Products,
    ROUND(AVG(IsActiveMember)*100,2) AS Active_Rate,
    ROUND(AVG(Exited)*100,2) AS Churn_Rate

FROM bank_churn
GROUP BY Customer_Type;

-- 2)Product Affinity Study: Which bank products or services are most commonly used together, and how might this influence cross-selling strategies?

SELECT 
    NumOfProducts,
    COUNT(CustomerId) AS Total_Customers,
    ROUND(AVG(Exited)*100,2) AS Churn_Rate,
    ROUND(AVG(IsActiveMember)*100,2) AS Active_Rate
FROM bank_churn
GROUP BY NumOfProducts
ORDER BY NumOfProducts;

-- 3)How do economic indicators in different geographic regions correlate with the number of active accounts and customer churn rates?

SELECT 
    GeographyLocation,
    COUNT(CustomerId) AS Total_Customers,
    ROUND(AVG(Balance),2) AS Avg_Balance,
    ROUND(AVG(EstimatedSalary),2) AS Avg_Salary,
    ROUND(AVG(IsActiveMember)*100,2) AS Active_Rate,
    ROUND(AVG(Exited)*100,2) AS Churn_Rate
FROM Bank_Churn
GROUP BY GeographyLocation
ORDER BY Avg_Balance DESC;

-- 4)4.	Based on customer profiles, which demographic segments appear to pose the highest financial risk to the bank, and why?

SELECT 
    Age_Group,
    GenderCategory,
    GeographyLocation,
    COUNT(CustomerId) AS Total_Customers,
    ROUND(AVG(Balance),2) AS Avg_Balance,
    ROUND(AVG(Exited)*100,2) AS Churn_Rate
FROM Bank_Churn
GROUP BY Age_Group, GenderCategory, GeographyLocation
ORDER BY Churn_Rate DESC
LIMIT 10;

-- 5)How would you use the available data to model and predict the lifetime (tenure) value in the bank of different customer segments?

SELECT 
    Age_Group,
    GeographyLocation,
    ROUND(AVG(Balance * Tenure),2) AS Avg_Customer_Value,
    ROUND(AVG(Exited)*100,2) AS Churn_Rate
FROM Bank_Churn
GROUP BY Age_Group, GeographyLocation
ORDER BY Avg_Customer_Value DESC;

-- 9)Utilize SQL queries to segment customers based on demographics and account details.

-- Query 1 — High-Value Customers
SELECT 
    CustomerId,
    Age_Group,
    GeographyLocation,
    Balance,
    Tenure
FROM Bank_Churn
WHERE Balance > 100000
AND Tenure > 5;
-- Query 2 — High-Risk Customers
SELECT 
    CustomerId,
    Age_Group,
    GeographyLocation,
    NumOfProducts,
    IsActiveMember,
    Exited
FROM Bank_Churn
WHERE Exited = 1
AND NumOfProducts = 1
AND IsActiveMember = 0;
-- Query 3 — Low-Engagement Customers
SELECT 
    CustomerId,
    Age_Group,
    NumOfProducts,
    IsActiveMember
FROM Bank_Churn
WHERE NumOfProducts = 1
AND IsActiveMember = 0;

-- 14)In the “Bank_Churn” table how can you modify the name of the “HasCrCard” column to “Has_creditcard”?

ALTER TABLE Bank_Churn
CHANGE HasCrCard Has_creditcard INT;
