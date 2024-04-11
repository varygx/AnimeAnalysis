#### Preamble ####
# Purpose: Downloads and saves the data using the MyAnimeList API
# Author: Allen Uy
# Date: 10 April 2024
# Contact: allen.uy@mail.utoronto.ca
# License: MIT
# Pre-requisites: .env is placed in working directory with bearer token
# refer to README for more details


#### Workspace setup ####
library("httr2")
library("tidyverse")
library("dotenv")

Sys.unsetenv("BEARER_TOKEN")
load_dot_env()
BEARER_TOKEN <- Sys.getenv("BEARER_TOKEN")

#### Obtain top ranked anime from MyAnimeList ####
num_anime = 500
total_anime = 10000
fields="id,title,rank,start_date,mean,popularity,num_list_users,num_scoring_users,studios,genres"

all_anime <- tibble(id=numeric(),
                    title=character(),
                    rank=numeric(),
                    start_date=character(),
                    studio=character(),
                    mean=numeric(),
                    popularity=numeric(),
                    num_list_users=numeric(),
                    num_scoring_users=numeric(),
                    genres=list())

for (n in 0:(total_anime/num_anime - 1)) {
  req = request("https://api.myanimelist.net/v2/anime/ranking") |> 
    req_url_query(ranking_type="all", limit=num_anime, offset=0+n*500, fields=fields) |>
    req_auth_bearer_token(BEARER_TOKEN)
  
  resp <- req_perform(req)
  
  anime_json <- resp_body_json(resp)
  
  
  for (i in 1:num_anime) {
    anime <- anime_json$data[[i]]$node
    
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
    
    all_anime <- all_anime |> add_row(id=id,
                                      title=title,
                                      rank=rank,
                                      start_date=start_date,
                                      mean=mean,
                                      popularity=popularity,
                                      num_list_users=num_list_users,
                                      num_scoring_users=num_scoring_users,
                                      studio=studio,
                                      genres=list(genres))
    
    # paste("Progress", i + n * 500, "/", total_anime)
  }
 
}
#### Save data ####

write_csv(all_anime, "data/raw_data/anime_rankings.csv")

         
