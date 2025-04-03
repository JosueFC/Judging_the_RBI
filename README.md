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

📌 __Insight__: Judge’s home run and hit totals reflect his impact during full seasons. Drops in 2020 and 2023 match shortened or injury-affected seasons.

![image](https://github.com/user-attachments/assets/61b85c7a-117c-4dc1-b855-b0db4a5eff2d)

A standalone chart for Judge’s SB totals (2017–2024).

📌 __Insight__: While base stealing isn’t a core part of his profile, Judge shows flashes of aggression in certain years.

![image](https://github.com/user-attachments/assets/d251f3bf-f4ca-4e81-a33b-76f6ccf912d3)

This line chart displays Aaron Judge’s annual Runs Batted In (RBI) totals compared to the league average for all MLB players from 2017 to 2024. The orange solid line represents Judge, while the blue dashed line represents the league average.

Interpretation:
Judge consistently exceeds the MLB average in run production.
2020 shows a sharp dip due to the shortened pandemic season.
2022 and 2024 mark peak seasons, with RBI totals far surpassing league norms.
The steep climbs following down years (e.g., from 2020 → 2021, and 2023 → 2024) highlight Judge’s bounce-back power and elite offensive impact.

📌 __Insight__: Aaron Judge is not just a slugger but a top-tier run producer, reliably driving in runs at a rate unmatched by the average MLB player.

![image](https://github.com/user-attachments/assets/668faa85-b29c-4d0b-8eff-e3530ccc024e)

A 2×2 grid comparing Aaron Judge’s:

Batting Average (BA)

Slugging Percentage (SLG)

On-Base Plus Slugging (OPS)

On-Base Percentage (OBP)

...against league averages.

📌 __Insight__: Judge consistently exceeds league benchmarks, particularly in SLG and OPS, confirming his elite power-hitter status.

![image](https://github.com/user-attachments/assets/56cf0bbc-5a24-436a-abc5-a5597e25e2c4)

This chart tracks RBI per game for Aaron Judge (solid orange line) against the MLB league average (dashed blue line) from 2017 to 2024. It adjusts for varying numbers of games played, providing a normalized view of Judge’s run production efficiency.

Interpretation:
Judge consistently drives in runs at a much higher rate than the league average across nearly all seasons.
Notable spikes occur in 2020, 2022, and 2024, underscoring his value even in shortened or injury-affected seasons.
While league-wide RBI/game remains relatively stable, Judge’s metric fluctuates with his health and team context but remains elite overall.

📌 __Insight__: This figure highlights Judge’s efficiency as a run producer — not just total output, but his ability to contribute consistently every time he takes the field.

![image](https://github.com/user-attachments/assets/d3eb040e-1fa5-430a-9eaf-e8d12932eedc)

This chart compares Judge’s total RBI per season to top hitters: Nolan Arenado, José Ramírez, Giancarlo Stanton, Freddie Freeman, Matt Olson, and the MLB average.

📌 __Insight__: Judge’s RBI totals are among the top across multiple seasons. His peaks match or surpass those of his elite peers, especially in 2022 and 2024.

![image](https://github.com/user-attachments/assets/a84fb6bb-032e-47dc-8ab0-d7a1acbab156)

This line chart tracks Aaron Judge’s RBI per game from 2017 to 2024 alongside the MLB average.

📌 __Insight__: Judge's run production efficiency (RBI/Game) remains well above average in most seasons, peaking during his historic 2024 season.

### 📊 Cluster Summary: Hitter Types
🧠 Understanding the PlayerTypes
Based on key offensive stats (HR, SB, BB, SO, BA, OBP, SLG, OPS), players were grouped into four distinct archetypes using K-means clustering and PCA visualization:

| Cluster | Archetype        | avg_HR | avg_SB | avg_BB | avg_SO | avg_BA | avg_OBP | avg_SLG | avg_OPS |
|:-------:|:------------------|--------:|--------:|--------:|--------:|--------:|---------:|---------:|---------:|
| 1       | Contact Hitters   | 8.10   | 3.59   | 22.0   | 54.2   | 0.268  | 0.334   | 0.434   | 0.768   |
| 2       | Power Stars       | 27.0   | 9.19   | 60.6   | 118.0  | 0.281  | 0.363   | 0.512   | 0.875   |
| 3       | Swingers          | 16.3   | 8.72   | 42.4   | 115.0  | 0.246  | 0.316   | 0.414   | 0.730   |
| 4       | Weak Bats         | 4.85   | 2.94   | 17.1   | 55.8   | 0.213  | 0.278   | 0.331   | 0.609   |

📈 Aaron Judge – Career Averages (2015–2024)

| Avg_HR | Avg_SB | Avg_BB | Avg_SO | Avg_BA | Avg_OBP | Avg_SLG | Avg_OPS |
|--------|--------|--------|--------|--------|---------|---------|---------|
| __35.0__   | 5.89   | __77.0__   | __134.3__  | 0.273  | __0.384__   | __0.571__   | __0.955__   |

📌 __Insight__: Aaron Judge’s offensive profile clearly aligns with the Power Stars cluster, exceeding the group’s average in nearly every category — especially HR, BB, and OPS.


![image](https://github.com/user-attachments/assets/7ea022f0-721f-4cbd-81c8-a3b3caef13d3)

This scatter plot visualizes the K-means clustering of MLB players based on their offensive metrics, projected into two dimensions using Principal Component Analysis (PCA). Each point represents a player-season, color-coded by their assigned hitter type:

🔴 Contact Hitters (Red): Players with high batting averages and low strikeouts, but limited power.

🟢 Power Stars (Green): High home run totals, strong slugging and OPS — elite offensive producers.

🔵 Swingers (Blue): Aggressive batters with decent power but lower consistency and higher strikeouts.

🟣 Weak Bats (Purple): Below-average performance across most offensive categories.

Interpretation:
The PCA axes capture key variance in offensive styles. Power Stars cluster clearly in the upper right quadrant, while Contact Hitters tend to group in the lower left. Swingers overlap partially with both but remain distinct. Weak Bats are isolated, highlighting their low-output profiles.

Takeaway:
This visualization highlights the diversity of offensive approaches in MLB and provides an interpretable framework for comparing player types at scale.
