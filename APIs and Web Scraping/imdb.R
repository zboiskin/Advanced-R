library(tidyverse)
library(rvest)

# Load the Friday the 13th IMDB Page
url <- 'https://www.imdb.com/title/tt0080761/'
selector <- 'strong span'
page <- read_html(url)

# Parse out the rating
page %>%
  html_nodes(selector) %>%
  html_text()
