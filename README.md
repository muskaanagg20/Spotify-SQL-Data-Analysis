# Spotify SQL Data Analysis 
# <img src="https://www.logo.wine/a/logo/Spotify/Spotify-Icon-Logo.wine.svg" alt="Spotify Logo" width="80" height="80">  <img src="https://github.com/user-attachments/assets/3e206741-69c8-4eb1-bc9d-52e031f15a38" alt="Data Preparation Logo" width="80" height="80">  <img src="https://github.com/user-attachments/assets/84a1540e-c509-45a1-b4c3-c3ae8e44b932" alt="sql Logo" width="80" height="80">  <img src="https://github.com/user-attachments/assets/24a8a0fb-0e5f-41c1-a0eb-a2fd6eb53572" alt="data Logo" width="80" height="80">

## Overview

This project involves the analysis of a **Spotify dataset** using **SQL** to extract insights about artists, albums, tracks, and user interactions. The primary goal is to perform advanced SQL querying and practice SQL best practices on a real-world dataset. The project covers the full spectrum from **basic SQL queries** to complex **window functions**.

---

## Dataset Information
The Spotify dataset contains rich data on tracks, albums, artists, and engagement metrics like views, likes, and comments. The key columns used in the analysis are:

| **Column**         | **Description**                                             |
| ------------------ | ----------------------------------------------------------- |
| **Artist**         | The artist who created the track                           |
| **Track**          | The track title                                            |
| **Album**          | The album to which the track belongs                       |
| **Album Type**     | Specifies whether it is a single, album, or other types   |
| **Danceability**   | A score indicating the danceability of the track           |
| **Energy**         | Measures the intensity and activity of a track             |
| **Loudness**       | Overall loudness of the track in decibels                  |
| **Speechiness**    | The presence of spoken words in a track                    |
| **Acousticness**   | A measure of the acoustic quality of the track             |
| **Instrumentalness** | Predicts whether a track contains no vocals               |
| **Liveness**       | Detects the presence of an audience in the recording       |
| **Valence**        | A measure of musical positiveness                           |
| **Tempo**          | The tempo of the track in beats per minute                 |
| **Duration_min**   | Duration of the track in minutes                            |
| **Channel**        | The channel through which the track is available            |
| **Views**          | Total views on official videos across platforms             |
| **Likes**          | Total likes on official videos across platforms             |
| **Comments**       | Total comments on official videos                           |
| **Licensed**       | Indicates if the track is licensed                          |
| **Official Video** | Indicates if the track has an official video               |
| **Stream**         | Total streams of the track across various platforms         |
| **Energy_Liveness** | Ratio of energy to liveness                                 |
| **Most Played On** | Platform where the track is most played                    |

This dataset offers great potential for performing in-depth analysis on track popularity, artist performance, and user behavior on Spotify.

---

## Project Steps

### 1. Data Preparation

The dataset was structured in a denormalized form. To ensure efficient querying, we performed normalization to split the data into logical tables, eliminating redundancies and improving data integrity.

---

### 2. SQL Queries

The project queries are divided into three difficulty levels:

- **Easy Queries**: Simple retrievals, basic filtering, and counting operations.
- **Medium Queries**: Aggregations, grouping by specific attributes, and conditional logic.
- **Advanced Queries**: Complex use of window functions, CTEs, and optimization techniques for handling large datasets.

---

### 3. Advanced SQL Techniques

This project explored the use of advanced SQL techniques including:

- **Window Functions**: To calculate running totals and rank tracks based on views.
- **Common Table Expressions (CTEs)**: To simplify complex subqueries and improve readability.
- **Partitioning and Filtering**: For more efficient analysis of large datasets.

---

## Example Queries

Here are a few sample SQL queries from the project:

```sql
-- Find Tracks Streamed More on Spotify than YouTube
WITH stream_count AS (
  SELECT 
    track,
    SUM(CASE WHEN most_played_on = 'Spotify' THEN stream ELSE 0 END) AS spotify_stream,
    SUM(CASE WHEN most_played_on = 'Youtube' THEN stream ELSE 0 END) AS youtube_stream
  FROM spotify
  GROUP BY track
)
SELECT track 
FROM stream_count
WHERE spotify_stream > youtube_stream;
```

```sql
-- Calculate the cumulative sum of likes for tracks ordered by views
SELECT 
    track,
    views,
    likes,
    SUM(likes) OVER (ORDER BY views ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_likes
FROM spotify;
```

```sql
-- Find the top 3 most-viewed tracks for each artist using window functions
WITH rankings AS (
  SELECT Artist, Track, SUM(Views) AS total_views, 
    DENSE_RANK() OVER (PARTITION BY Artist ORDER BY SUM(Views) DESC) AS rank_views 
  FROM spotify
  GROUP BY 1, 2
  ORDER BY 1, 3 DESC
)
SELECT Artist, Track, total_views 
FROM rankings
WHERE rank_views <= 3;
```

```sql
-- Find the top 5 tracks with the highest energy values
SELECT Track, SUM(Energy) AS energy_values 
FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

```sql
-- Get the total number of comments for tracks where licensed = TRUE
SELECT Track, SUM(Comments) AS total_comments 
FROM spotify
WHERE Licensed = 'TRUE'
GROUP BY 1
ORDER BY 2 DESC;
```

```sql
-- Average Danceability of Tracks by Album
SELECT Track, Album, AVG(Danceability) 
FROM spotify
GROUP BY Track, Album
ORDER BY AVG(Danceability) DESC;
```

## Key Findings
During the analysis of the Spotify dataset, several key insights were uncovered:

1. **Track Popularity**: Over 50 tracks exceeded 1 billion streams, highlighting the growing dominance of popular artists on streaming platforms.
2. **Artist Contribution**: A few artists have significantly more tracks in the Spotify library, with some surpassing 200 tracks.
3. **User Engagement**: Tracks with official music videos tend to accumulate more views and likes, emphasizing the importance of video content in user engagement.
4. **Energy and Liveness**: Certain tracks have high energy-to-liveness ratios, making them more suitable for live performances.
5. **Cumulative Likes**: Through the use of window functions, it was observed that the cumulative number of likes tends to grow proportionally with the number of views for popular tracks.

## Conclusion
The analysis provided valuable insights into how track features like energy, liveness, and user engagement metrics impact the success of tracks on Spotify. Through the use of SQL optimization techniques, complex queries were executed efficiently, helping to extract critical information about streaming behavior and track performance. These findings are useful for both artists and content creators looking to improve their reach on platforms like Spotify.
