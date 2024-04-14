#### Preamble ####
# Purpose: Models 
# Author: Allen Uy
# Date: 13 April 2024
# Contact: allen.uy@mail.utoronto.ca
# License: MIT
# Pre-requisites: 02-data_cleaning is run and analysis data is placed in
# appropriate location


#### Workspace setup ####
library("tidyverse")
library("rstanarm")
library("modelsummary")

#### Read data ####
clean_anime <- read_parquet("data/analysis_data/clean_anime.parquet")

### Model data ####
model <-
  stan_glm(
    formula = mean ~ fraction + days_since_start + num_list_users,
    data = clean_anime,
    family = gaussian(),
    prior = normal(location = c(1,0,0), scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 7, scale = 2.5, autoscale = TRUE),
    prior_aux = exponential(rate = 1, autoscale = TRUE),
    seed = 42
  )

summary(model)

coef(model)

prior_summary(model)


#### Save model ####
saveRDS(
  model,
  file = "models/model.rds"
)


