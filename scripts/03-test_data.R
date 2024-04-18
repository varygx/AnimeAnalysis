#### Preamble ####
# Purpose: Tests cleaned data to ensure robustness
# Author: Allen Uy
# Date: 12 April 2024
# Contact: allen.uy@mail.utoronto.ca
# License: MIT
# Pre-requisites: 02-data_cleaning was run and cleaned data is saved in
# appropriate location


#### Workspace setup ####
library("tidyverse")
library("testthat")
library("arrow")

clean_anime <- read_parquet(here::here("data/analysis_data/clean_anime.parquet"))

#### Test data ####

test_that("variables are expected type", {
  expect_type(clean_anime$id, "integer")
  expect_type(clean_anime$title, "character")
  expect_type(clean_anime$rank, "integer")
  expect_type(clean_anime$start_date, "Date") # When saving as parquet date type isn't preserved
  expect_type(clean_anime$studio, "character")
  expect_type(clean_anime$mean, "double")
  expect_type(clean_anime$popularity, "integer")
  expect_type(clean_anime$num_list_users, "integer")
  expect_type(clean_anime$num_scoring_users, "integer")
  expect_type(clean_anime$action, "integer")
})

test_that("values are unique", {
  expect_equal(length(unique(clean_anime$id)), nrow(clean_anime), label = "Length of 'id' column matches the number of rows")
  expect_equal(length(unique(clean_anime$rank)), nrow(clean_anime), label = "Length of 'rank' column matches the number of rows")
  expect_equal(length(unique(clean_anime$popularity)), nrow(clean_anime), label = "Length of 'popularity' column matches the number of rows")
})

test_that("variables do not have null values", {
  expect_false(anyNA(clean_anime$id), label = "No null values in 'id' column")
  expect_false(anyNA(clean_anime$title), label = "No null values in 'title' column")
  expect_false(anyNA(clean_anime$rank), label = "No null values in 'rank' column")
  expect_false(anyNA(clean_anime$start_date), label = "No null values in 'start_date' column") # Some are null
  expect_false(anyNA(clean_anime$studio), label = "No null values in 'studio' column")
  expect_false(anyNA(clean_anime$mean), label = "No null values in 'mean' column")
  expect_false(anyNA(clean_anime$popularity), label = "No null values in 'popularity' column")
  expect_false(anyNA(clean_anime$num_list_users), label = "No null values in 'num_list_users' column")
  expect_false(anyNA(clean_anime$num_scoring_users), label = "No null values in 'num_scoring_users' column")
  expect_false(anyNA(clean_anime$action), label = "No null values in 'action' column")
})

test_that("genre is binary", {
  expect_true(all(clean_anime$action %in% c(0, 1)), label = "All values in 'action' genre column are binary")
})
