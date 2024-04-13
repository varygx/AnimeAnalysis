# MyAnimeList Analysis

## Overview

This repo analyzes the top 10000 rated anime on MyAnimeList.

## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from the MyAnimeList API.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted models.
-   `other` contains sketches of a dataset and graph prior to obtaining the actual dataset to help plan the paper.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper.
-   `scripts` contains the R scripts used to simulate, download and clean data.

## Downloading the Data

The dataset for this paper was gathered on April 10, 2024. A `.env` file is required in the root folder with your own OAuth2.0 token. You should register a client ID here <https://myanimelist.net/apiconfig> and I recommend using Postman to generate the token using their callback URI <https://www.getpostman.com/oauth2/callback>.

## Statement on LLM usage

ChatGPT 3.5 was used for parts of code and as a conversation tool. The link to the conversation can be found [here](https://chat.openai.com/share/7f20ffa3-fc62-4a0e-b040-35d553953ad0).
