📊 Social Media Marketing Analysis (SQL)

📌 Problem Statement

As a Data Analyst collaborating with the Marketing team, the objective was to leverage Instagram user data to identify engagement patterns, detect high-value creators, and design data-driven strategies to improve retention, engagement, and scalable platform growth.

🗂*Dataset*

The dataset consists of seven relational tables: Users, Photos, Likes, Comments, Follows, Tags, and Photo_Tags. These interconnected tables enable comprehensive analysis of user activity, content interaction, engagement behavior, and social network relationships across the platform.

🛠 Approach

The analysis began with data validation checks for NULL values and duplicates to ensure data integrity. SQL queries using multi-table JOINs, aggregations, CTEs, and window functions were then applied to calculate engagement metrics, segment users, rank influencers, and evaluate hashtag performance. The focus remained on extracting business-aligned insights rather than isolated statistics.

📈 EDA Insights

The analysis revealed that 26% of users are inactive, representing a major retention opportunity. Engagement is concentrated among the top 15–20% of creators, indicating a power-law distribution. Emotion-driven and lifestyle hashtags generate the highest interaction levels, and posting consistency shows a strong positive correlation with engagement growth. Emerging Users (53%) represent the largest scalable growth segment.

📊 Performance Metrics & KPI Framework

Key engagement metrics were developed, including engagement per post, total interaction volume, user segmentation efficiency, and influencer qualification thresholds. Engagement per post proved to be a stronger performance indicator than follower count, highlighting the importance of content quality and audience responsiveness over raw network size.

🏗 Architecture Overview 

┌──────────────────────────────────────────────┐
│                DATA SOURCE                   │
│  Users | Photos | Likes | Comments | Tags    │
│  Follows | Photo_Tags                        │
└──────────────────────────────────────────────┘
                      │
                      ▼
┌──────────────────────────────────────────────┐
│             DATA VALIDATION LAYER            │
│  - NULL checks                               │
│  - Duplicate detection                       │
│  - Schema integrity verification             │
└──────────────────────────────────────────────┘
                      │
                      ▼
┌──────────────────────────────────────────────┐
│         ENGAGEMENT METRIC ENGINE             │
│  - Multi-table JOINs                         │
│  - Aggregations (COUNT, AVG)                 │
│  - CTEs                                      │
│  - Window Functions (RANK, DENSE_RANK)       │
└──────────────────────────────────────────────┘
                      │
                      ▼
┌──────────────────────────────────────────────┐
│            ANALYTICAL MODULES                │
│  - User Activity Distribution                │ 
│  - Engagement per Post Calculation           │
│  - Hashtag Performance Analysis              │
│  - Upload vs Engagement Correlation          │
│  - Cohort Analysis                           │
└──────────────────────────────────────────────┘
                      │
                      ▼
┌──────────────────────────────────────────────┐
│           USER SEGMENTATION LAYER            │
│  - High-Value Creators                       │
│  - Emerging Users                            │
│  - Inactive Users                            │
└──────────────────────────────────────────────┘
                      │
                      ▼
┌──────────────────────────────────────────────┐
│        INFLUENCER IDENTIFICATION LOGIC       │
│  - Engagement per Post Threshold             │
│  - Posting Consistency Filter                │
│  - Performance Ranking                       │
└──────────────────────────────────────────────┘
                      │
                      ▼
┌──────────────────────────────────────────────┐
│            BUSINESS STRATEGY OUTPUT          │
│  - Retention Strategy                        │
│  - Growth Strategy                           │
│  - Influencer Campaign Planning              │
│  - KPI Framework                             │ 
└──────────────────────────────────────────────┘


🚀 Future Improvements

Future enhancements may include dashboard visualization using Power BI, automated KPI tracking pipelines, cohort retention modeling across longer timelines, and integration of advertisement performance data (CTR, conversions) for complete funnel analysis
