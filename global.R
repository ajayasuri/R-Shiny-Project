library(tidyverse)
library(dplyr)
library(shinydashboard)
library(DT)
library(shiny)
library(lubridate)
library(naniar)
library(plotly)
library(reshape2)
library(ggrepel)
library(tokenizers)
library(wordcloud)

df <- read.csv('netflix_titles.csv', header = TRUE)
df <- data.frame(df)

# Clean data for analysis

df$date_added <- as.Date(df$date_added, format = "%B %d, %Y")


df$director[df$director == ""] <- NA
df$cast[df$cast == ""] <- NA
df$country[df$country == ""] <- NA
df$rating[df$rating == ""] <- NA


