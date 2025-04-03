#Load required packages
library(dplyr)
library(tidyr)
library(ggplot2)
library(readr)
library(plotly)
library(lubridate)
library(forecast)
library(gridExtra)
library(ggrepel)

# Load data
file_path <- "C:/Users/Josue/Downloads/cleaned_batting_stats.csv"
batting_data <- read_csv(file_path)

# Calculate league averages (per-player averages)
league_avg <- batting_data %>%
  group_by(Year, Lg) %>%
  summarize(
    Avg_BA = mean(BA, na.rm = TRUE),
    Avg_SLG = mean(SLG, na.rm = TRUE),
    Avg_OPS = mean(OPS, na.rm = TRUE),
    Avg_OBP = mean(OBP, na.rm = TRUE),
    Avg_RBI = mean(RBI, na.rm = TRUE),
    Avg_G = mean(G, na.rm = TRUE)
  ) %>%
  mutate(Avg_RBI_Per_Game = Avg_RBI / Avg_G)

  # Filter data for Aaron Judge and calculate his RBI per game
player_name <- "Aaron Judge"
player_data <- batting_data %>%
  filter(Player == player_name) %>%
  mutate(RBI_Per_Game = RBI / G) %>%
  left_join(league_avg, by = c("Year", "Lg"))

# Function to create customized plots without repeated legends
create_plot <- function(data, player_stat, league_stat, title, y_label, show_legend = FALSE) {
  plot <- ggplot(data, aes(x = Year)) +
    geom_line(aes_string(y = player_stat, color = '"Aaron Judge"'), size = 1.5) +
    geom_line(aes_string(y = league_stat, color = '"MLB Average"'), size = 1, linetype = "dashed") +
    labs(title = title, y = y_label, x = "Year") +
    scale_color_manual(values = c("Aaron Judge" = "#D55E00", "MLB Average" = "#0072B2")) +
    theme_minimal() +
    coord_cartesian(ylim = c(min(data[[player_stat]], data[[league_stat]], na.rm = TRUE) - 0.05,
                             max(data[[player_stat]], data[[league_stat]], na.rm = TRUE) + 0.05))
  
  # Only show legend for the first plot
  if (!show_legend) {
    plot <- plot + theme(legend.position = "none")
  }
  
  return(plot)
}

# Create individual stat plots
p1 <- create_plot(player_data, "BA", "Avg_BA", "Batting Average (BA)", "BA", show_legend = TRUE)
p2 <- create_plot(player_data, "SLG", "Avg_SLG", "Slugging Percentage (SLG)", "SLG")
p3 <- create_plot(player_data, "OPS", "Avg_OPS", "On-Base Plus Slugging (OPS)", "OPS")
p4 <- create_plot(player_data, "OBP", "Avg_OBP", "On-Base Percentage (OBP)", "OBP")

# Combine into grid with single legend
grid.arrange(p1, p2, p3, p4, ncol = 2, nrow = 2, top = "Aaron Judge vs MLB Average: Offensive Performance")

# RBI (Clutch) Analysis
ggplot(player_data, aes(x = Year)) +
  geom_line(aes(y = RBI, color = "Aaron Judge"), size = 1.5) +
  geom_line(aes(y = Avg_RBI, color = "MLB Average"), size = 1.5, linetype = "dashed") +
  labs(title = "Aaron Judge's RBI vs MLB Average", y = "RBI", x = "Year") +
  scale_color_manual(values = c("Aaron Judge" = "#D55E00", "MLB Average" = "#0072B2")) +
  theme_minimal()

# RBI Per Game Normalized Comparison
ggplot(player_data, aes(x = Year)) +
  geom_line(aes(y = RBI_Per_Game, color = "Aaron Judge"), size = 1.5) +
  geom_line(aes(y = Avg_RBI_Per_Game, color = "MLB Average"), size = 1.5, linetype = "dashed") +
  labs(title = "Aaron Judge's RBI Per Game vs MLB Average", y = "RBI Per Game", x = "Year") +
  scale_color_manual(values = c("Aaron Judge" = "#D55E00", "MLB Average" = "#0072B2")) +
  theme_minimal()

# Prepare long-format data
judge_ts <- batting_data %>%
  filter(Player == "Aaron Judge", Year >= 2017) %>%
  select(Year, H, HR, `2B`, `3B`, SB) %>%
  pivot_longer(cols = -Year, names_to = "Stat", values_to = "Value")

# Create individual plots for H, HR, 2B, 3B
plot_stat <- function(stat_name, stat_color) {
  ggplot(filter(judge_ts, Stat == stat_name), aes(x = Year, y = Value)) +
    geom_line(color = stat_color, size = 1.2) +
    geom_point(color = stat_color, size = 2) +
    labs(title = stat_name, x = "Year", y = "Count") +
    theme_minimal()
}

p_hit <- plot_stat("H", "#E69F00")
p_hr  <- plot_stat("HR", "#D55E00")
p_2b  <- plot_stat("2B", "#0072B2")
p_3b  <- plot_stat("3B", "#009E73")

# Arrange hitting stats together
grid.arrange(p_hit, p_hr, p_2b, p_3b, ncol = 2, top = "Aaron Judge: Hitting Numbers Over Time")

# Plot for SB (stolen bases)
ggplot(filter(judge_ts, Stat == "SB"), aes(x = Year, y = Value)) +
  geom_line(color = "#CC79A7", size = 1.2) +
  geom_point(color = "#CC79A7", size = 2) +
  labs(title = "Aaron Judge: Stolen Bases Over Time", x = "Year", y = "SB") +
  theme_minimal()

# Identify players with consistently high RBIs since 2017
high_rbi_players <- batting_data %>%
  filter(Year >= 2017 & Year <= 2024 & !is.na(RBI)) %>%
  group_by(Player) %>%
  summarize(
    Seasons = n(),
    Avg_RBI = mean(RBI, na.rm = TRUE)
  ) %>%
  filter(Seasons >= 3) %>%
  arrange(desc(Avg_RBI))

head(high_rbi_players, 10)

# Define the players to compare using original dataset names
players_to_plot <- c("Aaron Judge", "Nolan Arenado", "JosÃ© RamÃ­rez#", 
                     "Giancarlo Stanton", "Freddie Freeman*", "Matt Olson")

# Prepare player RBI data
player_rbi <- batting_data %>%
  filter(Year >= 2017, Year <= 2024, Player %in% players_to_plot) %>%
  group_by(Player, Year) %>%
  summarize(RBI = sum(RBI, na.rm = TRUE), .groups = "drop")

# Prepare league average RBI
league_avg_rbi <- batting_data %>%
  filter(Year >= 2017, Year <= 2024) %>%
  group_by(Year) %>%
  summarize(RBI = mean(RBI, na.rm = TRUE)) %>%
  mutate(Player = "MLB Average")

# Combine datasets
rbi_combined <- bind_rows(player_rbi, league_avg_rbi)

# ✅ Clean player names
rbi_combined$Player <- rbi_combined$Player %>%
  recode(
    "JosÃ© RamÃ­rez#" = "José Ramírez",
    "Freddie Freeman*" = "Freddie Freeman",
    "Matt Olson" = "Matt Olson"  # no special char, just reinforcing
  )

# Plot RBI over time
ggplot(rbi_combined, aes(x = Year, y = RBI, color = Player)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  labs(title = "RBI Comparison: Aaron Judge vs MLB Average and Star Peers (2017–2024)",
       y = "RBI", x = "Year") +
  scale_color_manual(values = c("Aaron Judge" = "#D55E00",
                                "MLB Average" = "#0072B2",
                                "Nolan Arenado" = "#009E73",
                                "José Ramírez" = "#CC79A7",
                                "Giancarlo Stanton" = "#F0E442",
                                "Freddie Freeman" = "#56B4E9",
                                "Matt Olson" = "#999999")) +
  theme_minimal() +
  theme(legend.position = "bottom")

#RBI per game
player_rbi <- batting_data %>%
  filter(Year >= 2017, Year <= 2024, Player %in% players_to_plot, !is.na(RBI), !is.na(G)) %>%
  mutate(RBI_per_game = RBI / G) %>%
  group_by(Player, Year) %>%
  summarize(RBI = mean(RBI_per_game, na.rm = TRUE), .groups = "drop")

#Update League Average to RBI/Game
league_avg_rbi <- batting_data %>%
  filter(Year >= 2017, Year <= 2024, !is.na(RBI), !is.na(G)) %>%
  mutate(RBI_per_game = RBI / G) %>%
  group_by(Year) %>%
  summarize(RBI = mean(RBI_per_game, na.rm = TRUE)) %>%
  mutate(Player = "MLB Average")

#Recode Clean Names (unchanged from before)
rbi_combined <- bind_rows(player_rbi, league_avg_rbi)

rbi_combined$Player <- rbi_combined$Player %>%
  recode(
    "JosÃ© RamÃ­rez#" = "José Ramírez",
    "Freddie Freeman*" = "Freddie Freeman",
    "Matt Olson" = "Matt Olson")
    
#Update the Plot Title and Y-axis Label
ggplot(rbi_combined, aes(x = Year, y = RBI, color = Player)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  labs(title = "RBI per Game: Aaron Judge vs MLB Average and Star Peers (2017–2024)",
       y = "RBI per Game", x = "Year") +
  scale_color_manual(values = c("Aaron Judge" = "#D55E00",
                                "MLB Average" = "#0072B2",
                                "Nolan Arenado" = "#009E73",
                                "José Ramírez" = "#CC79A7",
                                "Giancarlo Stanton" = "#F0E442",
                                "Freddie Freeman" = "#56B4E9",
                                "Matt Olson" = "#999999")) +
  theme_minimal() +
  theme(legend.position = "bottom")

# ---------------------- Player Type Clustering ----------------------

# Filter for players with enough PA and select key metrics
clustering_data <- batting_data %>%
  filter(PA > 100) %>%
  select(Player, Year, Age, PA, HR, SB, BB, SO, BA, OBP, SLG, OPS, rOBA, WAR)

# Keep a copy of ID columns
player_ids <- clustering_data %>% select(Player, Year)

# Select only numeric columns for clustering
cluster_metrics <- clustering_data %>%
  select(HR, SB, BB, SO, BA, OBP, SLG, OPS, rOBA, WAR)

# Scale data
scaled_metrics <- scale(cluster_metrics)

# Determine number of clusters visually (optional)
# library(factoextra)
# fviz_nbclust(scaled_metrics, kmeans, method = "wss")

# Run k-means clustering
set.seed(123)
k <- 4  # you can adjust this based on elbow method
kmeans_result <- kmeans(scaled_metrics, centers = k)

# Add cluster label to data
player_clusters <- cbind(player_ids, cluster_metrics)
player_clusters$Cluster <- as.factor(kmeans_result$cluster)

# Add descriptive labels
player_clusters$Type <- dplyr::recode(player_clusters$Cluster,
                                           "1" = "Contact Hitters",
                                           "2" = "Power Stars",
                                           "3" = "Swingers",
                                           "4" = "Weak Bats")

# View cluster summaries
cluster_summary <- player_clusters %>%
  group_by(Cluster, Type) %>%
  summarise(across(HR:WAR, mean, .names = "avg_{.col}"), Count = n(), .groups = "drop")

print(cluster_summary)

# PCA for visualization
pca <- prcomp(scaled_metrics)
pca_df <- as.data.frame(pca$x)

# Add cluster + type labels to PCA data
pca_df$Cluster <- player_clusters$Cluster
pca_df$Type <- player_clusters$Type

# Calculate cluster centroids
centroids <- pca_df %>%
  group_by(Type) %>%
  summarize(PC1 = mean(PC1), PC2 = mean(PC2), .groups = "drop")

# Plot with labeled clusters
ggplot(pca_df, aes(x = PC1, y = PC2, color = Type)) +
  geom_point(alpha = 0.7, size = 2.5) +
  geom_text_repel(data = centroids, aes(label = Type),
                  size = 4, color = "black", fontface = "bold", show.legend = FALSE) +
  labs(title = "Hitter Types (K-means Clustering)", x = "PC1", y = "PC2", color = "Type") +
  theme_minimal() +
  theme(legend.position = "right")

# Save for Tableau
write_csv(player_clusters, "C:/Users/Josue/Downloads/batting_clusters_labeled.csv")