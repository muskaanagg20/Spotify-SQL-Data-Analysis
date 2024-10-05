-- Retrieve the names of all tracks that have more than 1 billion streams.

select distinct Track from spotify
where Stream > 1000000000;

-- List all albums along with their respective artists.

select distinct Album, Artist from spotify;

-- Get the total number of comments for tracks where licensed = TRUE.

select Track, sum(Comments) as total_comments from spotify
where Licensed='TRUE'
group by 1
order by 2 desc;

-- Find all tracks that belong to the album type single.

select distinct Track from spotify
where Album_type = 'single';

-- Count the total number of tracks by each artist.

select artist, count(*) as total_tracks from spotify
group by 1
order by 2 desc;

-- Calculate the average danceability of tracks in each album.

select Track, Album, avg(Danceability) from spotify
group by 2, 1
order by 3 desc;

-- Find the top 5 tracks with the highest energy values.

select Track, sum(Energy) as energy_values from spotify
group by 1
order by 2 desc
limit 5;

-- List all tracks along with their views and likes where official_video = TRUE.

select Track,sum(Views) as total_views,sum(Likes) as total_likes from spotify
where official_video = 'TRUE'
group by 1;

-- For each album, calculate the total views of all associated tracks.

select Album,Track,sum(Views) as total_views from spotify
group by 1,2
order by 3 desc;

-- Retrieve the track names that have been streamed on Spotify more than YouTube.

with stream_count as(
select 
	track,
    sum(case when most_playedon = 'Spotify' then Stream else 0 end) as spotify_stream,
    sum(case when most_playedon = 'Youtube' then Stream else 0 end) as youtube_stream
from spotify
group by 1)

select * from stream_count
where spotify_stream > youtube_stream;

-- Find the top 3 most-viewed tracks for each artist using window functions.

with rankings as(
select Artist, Track, sum(Views) as total_views, dense_rank() over(partition by Artist order by sum(Views) desc) as rank_views from spotify
group by 1, 2
order by 1, 3 desc)

select Artist, Track, total_views from rankings
where rank_views <= 3;

-- Write a query to find tracks where the liveness score is above the average.

select Track FROM spotify
where Liveness > (select avg(Liveness) from spotify);

-- Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

with energy as(
select album, max(Energy) as highest_value, min(Energy) as lowest_value from spotify
group by 1)

select album, round(highest_value - lowest_value,2) as diff_energy from energy
order by 2 desc;

-- Find tracks where the energy-to-liveness ratio is greater than 1.2.

with ratio as (
select Track, Energy / Liveness as  energy_liveness_ratio from spotify)

select * from ratio 
where energy_liveness_ratio > 1.2
order by energy_liveness_ratio;

-- Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

SELECT 
    track,
    views,
    likes,
    SUM(likes) OVER (ORDER BY views ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_likes
FROM spotify;
