#### Preamble ####
# Purpose: Cleans the data obtained by the MAL API for easier processing
# and saves to parquet
# Author: Allen Uy
# Date: 12 April 2024
# Contact: allen.uy@mail.utoronto.ca
# License: MIT
# Pre-requisites: 01a-download_data is run and raw data is saved in
# appropriate location
# Update ref_date as needed

#### Workspace setup ####
library("tidyverse")
library("arrow")
library("janitor")

ref_date <- as.Date("2024-04-12")


#### Clean data ####
raw_data <- readRDS("data/raw_data/anime_rankings.rds")

cleaned_data <- raw_data |> clean_names()

# Extract all genres and convert to booleans
all_genres <- unique(unlist(cleaned_data$genres))

for (genre in all_genres) {
  cleaned_data[[genre]] <- as.integer(0)
}

for (i in seq_len(nrow(cleaned_data))) {
  for (genre in cleaned_data$genres[[i]]) {
    cleaned_data[i, genre] <- as.integer(1)
  }
}

cleaned_data$id <- as.integer(cleaned_data$id)
cleaned_data$rank <- as.integer(cleaned_data$rank)
cleaned_data$popularity <- as.integer(cleaned_data$popularity)
cleaned_data$start_date <- as.Date(cleaned_data$start_date)
cleaned_data$num_scoring_users <- as.integer(cleaned_data$num_scoring_users)
cleaned_data$num_list_users <- as.integer(cleaned_data$num_list_users)

cleaned_data <- cleaned_data |>
  mutate(days_since_start = as.integer(ref_date - start_date))

cleaned_data <- cleaned_data |>
  mutate(fraction = num_scoring_users / num_list_users)

cleaned_data <- cleaned_data |>
  select(-genres) |>
  clean_names()

# Select only the first 10000 rows based on rank
cleaned_data <- cleaned_data %>%
  slice(1:10000)

#### Save data ####
write_parquet(x = cleaned_data, "data/analysis_data/clean_anime.parquet")
