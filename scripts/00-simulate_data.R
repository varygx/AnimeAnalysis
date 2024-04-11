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
num_obs <- 100
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
  rank = rank(-score, ties.method = "min"),
  genre = random_genres,
  popularity = round(runif(num_obs, 100, 1000000))
)


