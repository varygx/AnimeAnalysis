#### Preamble ####
# Purpose: Simulates a dataset of anime based on sketches prior to obtaining data.
# Author: Allen Uy
# Date: 10 April 2024
# Contact: allen.uy@mail.utoronto.ca
# License: MIT
# Pre-requisites: None


#### Workspace setup ####
library(tidyverse)
set.seed(42)


#### Simulate data ####
num_obs <- 1000
start_date <- as.Date("2000-01-01")
end_date <- as.Date("2024-04-10")
num_days <- end_date - start_date
random_dates <- start_date + sample(num_days, num_obs, replace = TRUE)

possible_genres <- c("Action", "Adventure", "Comedy", "Drama", "Fantasy", "Horror", "Romance", "Sci-Fi", "Thriller")
random_genres <- lapply(1:num_obs, function(x) sample(possible_genres, sample(1:3, 1), replace = FALSE))

data <- tibble(
  title = 1:num_obs,
  date = random_dates,
  score = rnorm(num_obs, mean = 5),
  rank = rank(-score),
  genre = random_genres,
  members = round(runif(num_obs, 100, 1000000)),
  popularity = rank(-members),
  fraction = pmin(pmax(rnorm(num_obs, mean=0.39, sd=0.1), 0), 1)
)

score_distribution_plot <- ggplot(data, aes(x = score)) +
  geom_histogram(binwidth = 0.5, fill = "skyblue", color = "black") +
  labs(title = "Distribution of Scores",
       x = "Score",
       y = "Frequency") +
  theme_minimal()

score_distribution_plot

rank_popularity_plot <- ggplot(data, aes(x = rank, y = popularity)) +
  geom_point(size = 3, color = "darkorange") +
  scale_x_reverse() +
  scale_y_reverse() +
  labs(title = "Rank vs. Popularity",
       x = "Rank",
       y = "Popularity") +
  theme_minimal()

rank_popularity_plot

fraction_distribution_plot <- data |> ggplot(aes(x=fraction)) +
  geom_histogram(binwidth = 0.01, color="darkblue", fill="lightblue") +
  labs(x = "Fraction of Scoring Users to List Users", y = "Frequency") +
  theme_minimal()

fraction_distribution_plot


