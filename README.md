# Judging the RBI
This project analyzes MLB batting performance from 2015 to 2024, with a special focus on Aaron Judge and his offensive impact compared to league trends and peers.
## 📥 Data Collection
Data was collected via web scraping from Baseball-Reference, resulting in an initial dataset of:
13,445 player-season records (2015–2024)
## 🧹 Data Cleaning
The dataset was processed with the following steps:
❌ Removed null values
🔁 Removed duplicate records
📉 Filtered out players with fewer than 100 at-bats per year
✅ Final dataset size: 4,502 cleaned entries

## 🎯 Project Goals
Visualize Aaron Judge’s hitting trends.
Compare Aaron Judge’s performance to league averages and top sluggers.
Visualize RBI trends, and efficiency (per game).

# Data Exploration
![image](https://github.com/user-attachments/assets/a5d149a8-a4fd-499b-b5d9-439c0a88363f)
A grid of four line charts tracking Judge’s:
Hits
Home Runs
Doubles
Triples

📌 Insight: Judge’s home run and hit totals reflect his impact during full seasons. Drops in 2020 and 2023 match shortened or injury-affected seasons.

![image](https://github.com/user-attachments/assets/61b85c7a-117c-4dc1-b855-b0db4a5eff2d)
A standalone chart for Judge’s SB totals (2017–2024).

📌 Insight: While base stealing isn’t a core part of his profile, Judge shows flashes of aggression in certain years.

![image](https://github.com/user-attachments/assets/d251f3bf-f4ca-4e81-a33b-76f6ccf912d3)
This line chart displays Aaron Judge’s annual Runs Batted In (RBI) totals compared to the league average for all MLB players from 2017 to 2024. The orange solid line represents Judge, while the blue dashed line represents the league average.

Interpretation:
Judge consistently exceeds the MLB average in run production.
2020 shows a sharp dip due to the shortened pandemic season.
2022 and 2024 mark peak seasons, with RBI totals far surpassing league norms.
The steep climbs following down years (e.g., from 2020 → 2021, and 2023 → 2024) highlight Judge’s bounce-back power and elite offensive impact.

📌Insight: Aaron Judge is not just a slugger but a top-tier run producer, reliably driving in runs at a rate unmatched by the average MLB player.

![image](https://github.com/user-attachments/assets/668faa85-b29c-4d0b-8eff-e3530ccc024e)
A 2×2 grid comparing Aaron Judge’s:

Batting Average (BA)
Slugging Percentage (SLG)
On-Base Plus Slugging (OPS)
On-Base Percentage (OBP)
...against league averages.

📌Insight: Judge consistently exceeds league benchmarks, particularly in SLG and OPS, confirming his elite power-hitter status.

![image](https://github.com/user-attachments/assets/56cf0bbc-5a24-436a-abc5-a5597e25e2c4)
This chart tracks RBI per game for Aaron Judge (solid orange line) against the MLB league average (dashed blue line) from 2017 to 2024. It adjusts for varying numbers of games played, providing a normalized view of Judge’s run production efficiency.

Interpretation:
Judge consistently drives in runs at a much higher rate than the league average across nearly all seasons.
Notable spikes occur in 2020, 2022, and 2024, underscoring his value even in shortened or injury-affected seasons.
While league-wide RBI/game remains relatively stable, Judge’s metric fluctuates with his health and team context but remains elite overall.

📌Insight: This figure highlights Judge’s efficiency as a run producer — not just total output, but his ability to contribute consistently every time he takes the field.
