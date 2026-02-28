/*1.Are there any tables with duplicate or missing null values? If so, how would you handle them?*/
/*Checking for NULL Values*/

-- users
SELECT * FROM users
WHERE id IS NULL OR username IS NULL OR created_at IS NULL;

-- photos
SELECT * FROM photos
WHERE id IS NULL OR image_url IS NULL OR user_id IS NULL OR created_at IS NULL;

-- comments
SELECT * FROM comments
WHERE id IS NULL OR comment_text IS NULL OR user_id IS NULL OR photo_id IS NULL OR created_at IS NULL;

-- likes
SELECT * FROM likes
WHERE user_id IS NULL OR photo_id IS NULL OR created_at IS NULL;

-- follows
SELECT * FROM follows
WHERE follower_id IS NULL OR followee_id IS NULL OR created_at IS NULL;

-- tags
SELECT * FROM tags
WHERE id IS NULL OR tag_name IS NULL OR created_at IS NULL;

-- photo_tags
SELECT * FROM photo_tags
WHERE photo_id IS NULL OR tag_id IS NULL;

/*Checking for Duplicate Records*/

-- users
SELECT username, COUNT(*) FROM users GROUP BY username HAVING COUNT(*) > 1;

-- photos
SELECT image_url, COUNT(*) FROM photos GROUP BY image_url HAVING COUNT(*) > 1;

-- comments
SELECT comment_text, user_id, photo_id, COUNT(*)
FROM comments
GROUP BY comment_text, user_id, photo_id
HAVING COUNT(*) > 1;

-- tags
SELECT tag_name, COUNT(*) FROM tags GROUP BY tag_name HAVING COUNT(*) > 1;

/* 2.What is the distribution of user activity levels (e.g., number of posts, likes, comments) across the user base?*/

SELECT activity_level, COUNT(*) AS user_count
FROM (
    SELECT u.id,
           (COUNT(DISTINCT p.id) 
            + COUNT(DISTINCT l.photo_id) 
            + COUNT(DISTINCT c.id)) AS total_activity,
           CASE 
               WHEN (COUNT(DISTINCT p.id) 
                     + COUNT(DISTINCT l.photo_id) 
                     + COUNT(DISTINCT c.id)) = 0 
                     THEN 'Inactive'
               WHEN (COUNT(DISTINCT p.id) 
                     + COUNT(DISTINCT l.photo_id) 
                     + COUNT(DISTINCT c.id)) BETWEEN 1 AND 50 
                     THEN 'Low Activity'
               WHEN (COUNT(DISTINCT p.id) 
                     + COUNT(DISTINCT l.photo_id) 
                     + COUNT(DISTINCT c.id)) BETWEEN 51 AND 200 
                     THEN 'Medium Activity'
               ELSE 'High Activity'
           END AS activity_level
    FROM users u
    LEFT JOIN photos p ON u.id = p.user_id
    LEFT JOIN likes l ON u.id = l.user_id
    LEFT JOIN comments c ON u.id = c.user_id
    GROUP BY u.id
) AS activity_data
GROUP BY activity_level
ORDER BY user_count DESC;


/* 3. Calculate the average number of tags per post (photo_tags and photos tables).*/

SELECT 
    ROUND(COUNT(pt.tag_id) / COUNT(DISTINCT p.id), 2) AS avg_tags_per_post
FROM photos p
LEFT JOIN photo_tags pt 
    ON p.id = pt.photo_id;
    

/* 4.4.	Identify the top users with the highest engagement rates (likes, comments) on their posts and rank them.  */

WITH user_engagement AS (
    SELECT 
        u.id,
        u.username,
        COUNT(DISTINCT p.id) AS total_posts,
        COUNT(DISTINCT l.user_id, l.photo_id) AS total_likes_received,
        COUNT(DISTINCT c.id) AS total_comments_received
    FROM users u
    LEFT JOIN photos p ON u.id = p.user_id
    LEFT JOIN likes l ON p.id = l.photo_id
    LEFT JOIN comments c ON p.id = c.photo_id
    GROUP BY u.id, u.username
)
SELECT 
    id,
    username,
    total_posts,
    total_likes_received,
    total_comments_received,
    ROUND(
        (total_likes_received + total_comments_received) 
        / NULLIF(total_posts, 0), 2
    ) AS engagement_rate,
    RANK() OVER (
        ORDER BY 
        (total_likes_received + total_comments_received) 
        / NULLIF(total_posts, 0) DESC
    ) AS user_rank
FROM user_engagement
WHERE total_posts > 0;

/* 5.Which users have the highest number of followers and followings?*/

SELECT 
    u.id,
    u.username,
    COUNT(DISTINCT f1.follower_id) AS total_followers,
    COUNT(DISTINCT f2.followee_id) AS total_following
FROM users u
LEFT JOIN follows f1 
    ON u.id = f1.followee_id
LEFT JOIN follows f2 
    ON u.id = f2.follower_id
GROUP BY u.id, u.username
ORDER BY total_followers DESC;

/*6. Calculate the average engagement rate (likes, comments) per post for each user.*/

WITH engagement_data AS (
    SELECT 
        u.id,
        u.username,
        COUNT(DISTINCT p.id) AS total_posts,
        COUNT(DISTINCT l.user_id, l.photo_id) AS total_likes_received,
        COUNT(DISTINCT c.id) AS total_comments_received
    FROM users u
    LEFT JOIN photos p 
        ON u.id = p.user_id
    LEFT JOIN likes l 
        ON p.id = l.photo_id
    LEFT JOIN comments c 
        ON p.id = c.photo_id
    GROUP BY u.id, u.username
)
SELECT 
    id,
    username,
    total_posts,
    total_likes_received,
    total_comments_received,
    ROUND(
        (total_likes_received + total_comments_received) 
        / NULLIF(total_posts, 0),
        2
    ) AS avg_engagement_per_post
FROM engagement_data
WHERE total_posts > 0
ORDER BY avg_engagement_per_post DESC;

/*7. 7.	Calculate the average engagement rate (likes, comments) per post for each user.*/


SELECT 
    u.id,
    u.username
FROM users u
WHERE NOT EXISTS (
    SELECT 1
    FROM likes l
    WHERE l.user_id = u.id
)
ORDER BY u.id;

/*8. How can you leverage user-generated content (posts, hashtags, photo tags) to create more personalized and engaging ad campaigns?*/

WITH tag_frequency AS (
    SELECT 
        pt.tag_id,
        COUNT(*) AS tag_usage_count
    FROM photo_tags pt
    GROUP BY pt.tag_id
)
SELECT 
    t.tag_name,
    ROUND(AVG(tag_usage_count), 2) AS avg_tag_usage
FROM tag_frequency tf
JOIN tags t 
    ON tf.tag_id = t.id
GROUP BY t.tag_name
ORDER BY avg_tag_usage DESC;


/*9. Are there any correlations between user activity levels and specific content types (e.g., photos, videos, reels)? How can this information guide content creation and curation strategies?*/

WITH uploads AS (
    SELECT 
        u.id AS user_id,
        COUNT(p.id) AS photo_uploads
    FROM users u
    LEFT JOIN photos p 
        ON u.id = p.user_id
    GROUP BY u.id
),
likes_received AS (
    SELECT 
        p.user_id,
        COUNT(l.photo_id) AS total_likes
    FROM photos p
    LEFT JOIN likes l 
        ON p.id = l.photo_id
    GROUP BY p.user_id
),
comments_received AS (
    SELECT 
        p.user_id,
        COUNT(c.id) AS total_comments
    FROM photos p
    LEFT JOIN comments c 
        ON p.id = c.photo_id
    GROUP BY p.user_id
),
combined AS (
    SELECT 
        u.photo_uploads,
        COALESCE(l.total_likes, 0) + COALESCE(c.total_comments, 0) AS total_engagement
    FROM uploads u
    LEFT JOIN likes_received l 
        ON u.user_id = l.user_id
    LEFT JOIN comments_received c 
        ON u.user_id = c.user_id
)
SELECT 
    photo_uploads,
    ROUND(AVG(total_engagement), 2) AS avg_engagement
FROM combined
GROUP BY photo_uploads
ORDER BY photo_uploads;

/*10. Calculate the total number of likes, comments, and photo tags for each user.*/  

WITH photo_level_metrics AS (
    SELECT 
        p.id AS photo_id,
        p.user_id,
        COUNT(DISTINCT l.user_id) AS likes_per_photo,
        COUNT(DISTINCT c.id) AS comments_per_photo,
        COUNT(DISTINCT pt.tag_id) AS tags_per_photo
    FROM photos p
    LEFT JOIN likes l 
        ON p.id = l.photo_id
    LEFT JOIN comments c 
        ON p.id = c.photo_id
    LEFT JOIN photo_tags pt 
        ON p.id = pt.photo_id
    GROUP BY p.id, p.user_id
)
SELECT 
    u.id AS user_id,
    u.username,
    COALESCE(SUM(pl.likes_per_photo), 0) AS total_likes,
    COALESCE(SUM(pl.comments_per_photo), 0) AS total_comments,
    COALESCE(SUM(pl.tags_per_photo), 0) AS total_photo_tags
FROM users u
LEFT JOIN photo_level_metrics pl 
    ON u.id = pl.user_id
GROUP BY u.id, u.username
ORDER BY total_likes DESC;

/*11.Rank users based on their total engagement (likes, comments) over a month.*/

WITH engagement_summary AS (
    SELECT 
        u.id AS user_id,
        u.username,
        COUNT(DISTINCT l.photo_id) AS total_likes,
        COUNT(DISTINCT c.id) AS total_comments,
        COUNT(DISTINCT l.photo_id) + COUNT(DISTINCT c.id) AS total_engagement
    FROM users u
    JOIN photos p 
        ON u.id = p.user_id
    LEFT JOIN likes l 
        ON p.id = l.photo_id
    LEFT JOIN comments c 
        ON p.id = c.photo_id
    GROUP BY u.id, u.username
)
SELECT *,
       DENSE_RANK() OVER (ORDER BY total_engagement DESC) AS engagement_rank
FROM engagement_summary
ORDER BY engagement_rank;

/*12. Retrieve the hashtags that have been used in posts with the highest average number of likes. Use a CTE to calculate the average likes for each hashtag first.*/

WITH hashtag_avg_likes AS (
    SELECT 
        t.tag_name,
        COUNT(l.photo_id) / COUNT(DISTINCT p.id) AS avg_likes
    FROM tags t
    JOIN photo_tags pt 
        ON t.id = pt.tag_id
    JOIN photos p 
        ON pt.photo_id = p.id
    LEFT JOIN likes l 
        ON p.id = l.photo_id
    GROUP BY t.tag_name
)
SELECT 
    tag_name,
    ROUND(avg_likes, 2) AS avg_likes
FROM hashtag_avg_likes
ORDER BY avg_likes DESC;

/*13. Retrieve the users who have started following someone after being followed by that person.*/

SELECT 
    u1.id AS user_id,
    u1.username AS user_name,
    u2.id AS followed_user_id,
    u2.username AS followed_user_name,
    f1.created_at AS followed_at,
    f2.created_at AS followed_back_at
FROM follows f1
JOIN follows f2 
    ON f1.follower_id = f2.followee_id
   AND f1.followee_id = f2.follower_id
JOIN users u1 
    ON f1.follower_id = u1.id
JOIN users u2 
    ON f1.followee_id = u2.id
WHERE f2.created_at < f1.created_at
ORDER BY user_id;


/*                                                  SUBJECTIVE QUESTIONS                                           */

/* 1.	Based on user engagement and activity levels, which users would you consider the most loyal or valuable? How would you reward or incentivize these users? */

WITH user_posts AS (
    SELECT user_id, COUNT(*) AS total_posts
    FROM photos
    GROUP BY user_id
),
user_engagement AS (
    SELECT 
        p.user_id,
        COUNT(DISTINCT l.user_id) AS total_likes_received,
        COUNT(DISTINCT c.id) AS total_comments_received
    FROM photos p
    LEFT JOIN likes l ON p.id = l.photo_id
    LEFT JOIN comments c ON p.id = c.photo_id
    GROUP BY p.user_id
)
SELECT 
    u.id AS user_id,
    u.username,
    COALESCE(up.total_posts, 0) AS total_posts,
    COALESCE(ue.total_likes_received, 0) AS total_likes,
    COALESCE(ue.total_comments_received, 0) AS total_comments,
    (COALESCE(ue.total_likes_received, 0) + 
     COALESCE(ue.total_comments_received, 0)) AS total_engagement
FROM users u
LEFT JOIN user_posts up ON u.id = up.user_id
LEFT JOIN user_engagement ue ON u.id = ue.user_id
ORDER BY total_engagement DESC;

/*2. For inactive users, what strategies would you recommend to re-engage them and encourage them to start posting or engaging again?*/

WITH user_activity AS (
    SELECT 
        u.id,
        u.username,
        COUNT(DISTINCT p.id) AS total_posts,
        COUNT(DISTINCT l.user_id) AS total_likes_received,
        COUNT(DISTINCT c.id) AS total_comments_received
    FROM users u
    LEFT JOIN photos p ON u.id = p.user_id
    LEFT JOIN likes l ON p.id = l.photo_id
    LEFT JOIN comments c ON p.id = c.photo_id
    GROUP BY u.id, u.username
)
SELECT *
FROM user_activity
WHERE total_posts = 0
  AND total_likes_received = 0
  AND total_comments_received = 0;

/*3. Which hashtags or content topics have the highest engagement
rates? How can this information guide content strategy and ad
campaigns?*/

WITH hashtag_engagement AS (
    SELECT 
        t.tag_name,
        COUNT(DISTINCT p.id) AS total_posts,
        COUNT(DISTINCT l.user_id) AS total_likes,
        COUNT(DISTINCT c.id) AS total_comments,
        COUNT(DISTINCT l.user_id) + COUNT(DISTINCT c.id) AS total_engagement
    FROM tags t
    JOIN photo_tags pt ON t.id = pt.tag_id
    JOIN photos p ON pt.photo_id = p.id
    LEFT JOIN likes l ON p.id = l.photo_id
    LEFT JOIN comments c ON p.id = c.photo_id
    GROUP BY t.tag_name
)
SELECT *
FROM hashtag_engagement
ORDER BY total_engagement DESC;

/*4. Are there any patterns or trends in user engagement based on
demographics (age, location, gender) or posting times? How can
these insights inform targeted marketing campaigns?*/


WITH user_engagement AS (
    SELECT 
        u.id,
        YEAR(u.created_at) AS joining_year,
        COUNT(DISTINCT p.id) AS total_posts,
        COUNT(DISTINCT l.user_id) + COUNT(DISTINCT c.id) AS total_engagement
    FROM users u
    LEFT JOIN photos p ON u.id = p.user_id
    LEFT JOIN likes l ON p.id = l.photo_id
    LEFT JOIN comments c ON p.id = c.photo_id
    GROUP BY u.id, joining_year
)
SELECT 
    joining_year,
    COUNT(*) AS user_count,
    ROUND(AVG(total_posts),2) AS avg_posts,
    ROUND(AVG(total_engagement),2) AS avg_engagement
FROM user_engagement
GROUP BY joining_year;

/*5. Based on follower counts and engagement rates, which users would be ideal candidates for influencer marketing campaigns? How would you approach and collaborate with these influencers?*/

WITH follower_count AS (
    SELECT followee_id AS user_id,
           COUNT(*) AS total_followers
    FROM follows
    GROUP BY followee_id
),
user_engagement AS (
    SELECT 
        u.id,
        u.username,
        COUNT(DISTINCT p.id) AS total_posts,
        COUNT(DISTINCT l.user_id) + COUNT(DISTINCT c.id) AS total_engagement
    FROM users u
    LEFT JOIN photos p ON u.id = p.user_id
    LEFT JOIN likes l ON p.id = l.photo_id
    LEFT JOIN comments c ON p.id = c.photo_id
    GROUP BY u.id, u.username
)
SELECT 
    ue.id,
    ue.username,
    COALESCE(fc.total_followers,0) AS followers,
    ue.total_posts,
    ue.total_engagement,
    ROUND(ue.total_engagement / NULLIF(ue.total_posts,0),2) AS engagement_per_post
FROM user_engagement ue
LEFT JOIN follower_count fc ON ue.id = fc.user_id
ORDER BY followers DESC, engagement_per_post DESC;

/*6. Based on user behavior and engagement data, how would you
segment the user base for targeted marketing campaigns or
personalized recommendations?
*/
SELECT user_segment, COUNT(*) 
FROM (
WITH user_metrics AS (
    SELECT 
        u.id,
        u.username,
        COUNT(DISTINCT p.id) AS total_posts,
        COUNT(DISTINCT l.user_id) + COUNT(DISTINCT c.id) AS total_engagement,
        ROUND(
            (COUNT(DISTINCT l.user_id) + COUNT(DISTINCT c.id)) / 
            NULLIF(COUNT(DISTINCT p.id),0), 2
        ) AS engagement_per_post
    FROM users u
    LEFT JOIN photos p ON u.id = p.user_id
    LEFT JOIN likes l ON p.id = l.photo_id
    LEFT JOIN comments c ON p.id = c.photo_id
    GROUP BY u.id, u.username
)
SELECT *,
    CASE 
        WHEN total_posts = 0 THEN 'Inactive Users'
        WHEN total_posts >= 5 AND engagement_per_post >= 35 THEN 'High-Value Creators'
        WHEN total_posts >= 5 AND engagement_per_post < 35 THEN 'Active Low-Engagement Users'
        WHEN total_posts BETWEEN 1 AND 4 THEN 'Emerging Users'
        ELSE 'Other'
    END AS user_segment
FROM user_metrics
) t
GROUP BY user_segment;

/*8.How can you use user activity data to identify potential brand ambassadors or advocates who could help promote Instagram's initiatives or events?*/

WITH user_metrics AS (
    SELECT 
        u.id,
        u.username,
        COUNT(DISTINCT p.id) AS total_posts,
        COUNT(DISTINCT l.user_id) + COUNT(DISTINCT c.id) AS total_engagement,
        ROUND(
            (COUNT(DISTINCT l.user_id) + COUNT(DISTINCT c.id)) / 
            NULLIF(COUNT(DISTINCT p.id),0), 2
        ) AS engagement_per_post
    FROM users u
    LEFT JOIN photos p ON u.id = p.user_id
    LEFT JOIN likes l ON p.id = l.photo_id
    LEFT JOIN comments c ON p.id = c.photo_id
    GROUP BY u.id, u.username
)
SELECT *
FROM user_metrics
WHERE total_posts >= 8
AND engagement_per_post >= 35
ORDER BY engagement_per_post DESC;