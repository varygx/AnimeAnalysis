#### Preamble ####
# Purpose: Cleans the data obtained by the MAL API for easier processing
# and saves to parquet
# Author: Allen Uy
# Date: 12 April 2024
# Contact: allen.uy@mail.utoronto.ca
# License: MIT
# Pre-requisites: 01-download_data is run and file is saved in appropriate location

#### Workspace setup ####
library("tidyverse")
library("arrow")
library("janitor")


#### Clean data ####
raw_data <- readRDS("data/raw_data/anime_rankings.rds")

cleaned_data <- raw_data |> clean_names()

# Extract all genres and convert to booleans
all_genres <- unique(unlist(cleaned_data$genres))

for (genre in all_genres) {
  cleaned_data[[genre]] <- 0
}

for (i in seq_len(nrow(cleaned_data))) {
  for (genre in cleaned_data$genres[[i]]) {
    cleaned_data[i, genre] <- 1
  }
}

cleaned_data <- cleaned_data |> select(-genres) |>
  clean_names()

#### Save data ####
write_parquet(x = cleaned_data, "data/analysis_data/clean_anime.parquet")
