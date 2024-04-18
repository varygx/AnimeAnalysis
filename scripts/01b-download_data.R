#### Preamble ####
# Purpose: Downloads and saves the data using the MyAnimeList API
# Author: Allen Uy
# Date: 17 April 2024
# Contact: allen.uy@mail.utoronto.ca
# License: MIT
# Pre-requisites: .env is placed in working directory with bearer token
# refer to README for more details. 01a-download_data is run.
# Note: This file is not necessary to run. We did not end up exploring this in the paper


#### Workspace setup ####
library("httr2")
library("tidyverse")
library("dotenv")

Sys.unsetenv("BEARER_TOKEN")
load_dot_env()
BEARER_TOKEN <- Sys.getenv("BEARER_TOKEN")

#### Get extra details of top 200 ####
all_anime <- readRDS("data/raw_data/anime_rankings.rds")

fields="id,title,rank,start_date,mean,popularity,num_list_users,num_scoring_users,studios,genres,recommendations,related_anime,statistics"

extra_details <- tibble(id=numeric(),
                        title=character(),
                        rank=numeric(),
                        start_date=character(),
                        studio=character(),
                        mean=numeric(),
                        popularity=numeric(),
                        num_list_users=numeric(),
                        num_scoring_users=numeric(),
                        genres=list(),
                        recommended=list(),
                        related=list(),
                        num_watching=numeric(),
                        num_completed=numeric(),
                        num_on_hold=numeric(),
                        num_dropped=numeric(),
                        num_plan_to_watch=numeric())

for (i in 1:200) {
  
  id <- all_anime$id[i]
  
  req = request("https://api.myanimelist.net/v2/anime") |> 
    req_url_path_append(id) |>
    req_url_query(fields=fields) |>
    req_auth_bearer_token(BEARER_TOKEN)
  
  resp <- req_perform(req)
  
  anime <- resp_body_json(resp)
  
  id <- anime$id
  title <- anime$title
  rank <- anime$rank
  start_date <- anime$start_date
  mean <- anime$mean
  popularity <- anime$popularity
  num_list_users <- anime$num_list_users
  num_scoring_users <- anime$num_scoring_users
  if (length(anime$studios) > 0) {
    studio <- anime$studios[[1]]$name
  }
  
  genres <- list()
  for (j in 1:length(anime$genres)) {
    genre <- anime$genres[[j]]$name
    genres <- c(genres, list(genre))
  }
  
  recommended <- list()
  if (length(anime$recommendations) > 0) {
    for (j in 1:min(5, length(anime$recommendations))) {
      recommendation_id <- anime$recommendations[[j]]$node$id
      recommendation_title <- anime$recommendations[[j]]$node$title
      
      recommendation <- list(recommendation_id, recommendation_title)
      
      recommended <- c(recommended, list(recommendation))
    }
  }
  
  related <- list()
  if (length(anime$related_anime) > 0) {
    for (j in 1:length(anime$related_anime)) {
      rel_id <- anime$related_anime[[j]]$node$id
      rel_title <- anime$related_anime[[j]]$node$title
      rel_type <- anime$related_anime[[j]]$relation_type
      
      rel_details <- list(id = rel_id, title = rel_title, type = rel_type)
      
      related <- c(related, list(rel_details))
    }
  }
  
  num_watching = as.integer(anime$statistics$status$watching)
  num_completed = as.integer(anime$statistics$status$completed)
  num_on_hold = as.integer(anime$statistics$status$on_hold)
  num_dropped = as.integer(anime$statistics$status$dropped)
  num_plan_to_watch = as.integer(anime$statistics$status$plan_to_watch)
  
  extra_details <-  extra_details |> add_row(id=id,
                                             title=title,
                                             rank=rank,
                                             start_date=start_date,
                                             mean=mean,
                                             popularity=popularity,
                                             num_list_users=num_list_users,
                                             num_scoring_users=num_scoring_users,
                                             studio=studio,
                                             genres=list(genres),
                                             recommended=list(recommended),
                                             related=list(related),
                                             num_watching=num_watching,
                                             num_completed=num_completed,
                                             num_on_hold=num_on_hold,
                                             num_dropped=num_dropped,
                                             num_plan_to_watch=num_plan_to_watch)
  
  print(paste("Progress", i, "/", 200))
  Sys.sleep(0.4)
}

saveRDS(extra_details, "data/raw_data/top200.rds")