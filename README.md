# MyAnimeList Analysis

## Overview

This repo analyzes the top 10000 rated anime on MyAnimeList. We find that the ratio of users that rate an anime to the total number of users that have that anime on their list is a good indicator of user score. Using this we build a multiple linear regression model to predict the ratings of anime. To replicate the analysis run the scripts in order under the `scripts` directory. This involves simulating the data, downloading the data using the MyAnimeList API, cleaning the data, testing the data, and building a model. Please note that the dataset will be different compared to the one gathered on April 12, 2024 used in the paper.

## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from the MyAnimeList API.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted models.
-   `other` contains sketches for planning of the paper, a datasheet, and a transcript of LLM usage.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper.
-   `scripts` contains the R scripts used to simulate, download and clean data.

## Downloading the Data

The dataset for this paper was gathered on April 10, 2024. A `.env` file is required in the root folder with your own OAuth2.0 token. You should [register a client ID](https://myanimelist.net/apiconfig) and I recommend using Postman to generate the token using their callback URI <https://www.getpostman.com/oauth2/callback>. Here is more information about [dotenv](https://www.freecodecamp.org/news/how-to-use-node-environment-variables-with-a-dotenv-file-for-node-js-and-npm/), including what the format looks like, the article is about usage in Node but the file format is the same. Refer to the [MyAnimeList API Documentation](https://myanimelist.net/apiconfig/references/api/v2) if you want to examine other attributes not mentioned in this paper.

## Statement on LLM usage

ChatGPT 3.5 was used for parts of code and as a conversation tool. The link to the conversation can be found [here](https://chat.openai.com/share/7f20ffa3-fc62-4a0e-b040-35d553953ad0). A copy of the transcript can also be found at `other/llm/usage.txt`
