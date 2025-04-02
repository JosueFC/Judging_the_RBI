--MLB Batting Data Cleaning and Exploratory Analysis (2017–2024): League Trends, Top Performers, and Player Insights
--Data cleaning
--Look for null values
SELECT *
FROM `side-projects-454319.exit_velocity.batting_stats`
WHERE Player IS NULL
   OR BA IS NULL
   OR OBP IS NULL
   OR SLG IS NULL
   OR OPS IS NULL
   OR POS IS NULL;

--Remove null values
CREATE OR REPLACE TABLE `side-projects-454319.exit_velocity.cleaned_batting_stats` AS
SELECT *
FROM `side-projects-454319.exit_velocity.batting_stats`
WHERE Player IS NOT NULL
  AND BA IS NOT NULL
  AND OBP IS NOT NULL
  AND SLG IS NOT NULL
  AND OPS IS NOT NULL
  AND Pos IS NOT NULL;

--Identify duplicates
SELECT Player, Year, Lg, COUNT(*) AS Count
FROM `side-projects-454319.exit_velocity.cleaned_batting_stats`
GROUP BY Player, Year, Lg
HAVING Count > 1
ORDER BY Count DESC;

--Remove duplicates
CREATE OR REPLACE TABLE `side-projects-454319.exit_velocity.cleaned_batting_stats` AS
SELECT *
FROM (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY Player, Year, Lg ORDER BY Player) AS RowNum
  FROM `side-projects-454319.exit_velocity.cleaned_batting_stats`
)
WHERE RowNum = 1;

--Verify the removal
SELECT Player, Year, Lg, COUNT(*) AS Count
FROM `side-projects-454319.exit_velocity.cleaned_batting_stats`
GROUP BY Player, Year, Lg
HAVING Count > 1;

--Remove players with low AB (at least 100 at bats)
CREATE OR REPLACE TABLE `side-projects-454319.exit_velocity.cleaned_batting_stats` AS
SELECT *
FROM `side-projects-454319.exit_velocity.cleaned_batting_stats`
WHERE AB >= 100;

--Data exploration

-- League-wide trends by year
SELECT Year,
       ROUND(AVG(BA), 3) AS Avg_BA,
       ROUND(AVG(OBP), 3) AS Avg_OBP,
       ROUND(AVG(SLG), 3) AS Avg_SLG,
       ROUND(AVG(OPS), 3) AS Avg_OPS,
       ROUND(AVG(RBI), 1) AS Avg_RBI
FROM `side-projects-454319.exit_velocity.cleaned_batting_stats`
GROUP BY Year
ORDER BY Year;

-- Players with the highest RBIs per year
SELECT Player, Year, RBI
FROM `side-projects-454319.exit_velocity.cleaned_batting_stats`
ORDER BY RBI DESC
LIMIT 10;

--Players with the highest OPS
SELECT Player, Year, Lg, Pos, OPS
FROM `side-projects-454319.exit_velocity.cleaned_batting_stats`
WHERE OPS IS NOT NULL
ORDER BY OPS DESC
LIMIT 10;

--Find the top performers by slugging percentage
SELECT Player, Year, Lg, Pos, SLG
FROM `side-projects-454319.exit_velocity.cleaned_batting_stats`
ORDER BY SLG DESC
LIMIT 10;

--Compare AL vs. NL Performers (Average OPS)
SELECT Year, Lg, ROUND(AVG(OPS), 3) AS Avg_OPS
FROM `side-projects-454319.exit_velocity.cleaned_batting_stats`
WHERE Lg != '2LG'
GROUP BY Year, Lg
ORDER BY Year, Lg;

-- Aaron Judge's offensive stats over time
SELECT Year, AB, BA, OBP, SLG, OPS, RBI
FROM `side-projects-454319.exit_velocity.cleaned_batting_stats`
WHERE Player = 'Aaron Judge'
ORDER BY Year;

-- Players with high average RBI and at least 3 seasons
SELECT Player, COUNT(*) AS Seasons, ROUND(AVG(RBI), 1) AS Avg_RBI
FROM `side-projects-454319.exit_velocity.cleaned_batting_stats`
WHERE Year >= 2017
GROUP BY Player
HAVING Seasons >= 3
ORDER BY Avg_RBI DESC
LIMIT 20;


