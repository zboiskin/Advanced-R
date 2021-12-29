library(tidyverse)
library(rvest)

# Friday the 13th movie data
id <- c('tt0080761', 'tt0082418', 'tt0083972', 'tt0087298', 'tt0089173', 'tt0091080', 'tt0095179', 'tt0097388')
part <- c('I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII')
rating <- c(0,0,0,0,0,0,0,0)

# Create a tibble
movies <- tibble(id, part, rating)

# IMDB scraping function
rankIMDB <- function(movie) {
  url <- paste0('https://www.imdb.com/title/', movie, '/')
  selector <- 'strong span'
  page <- read_html(url)
  
  rank <- page %>%
    html_nodes(selector) %>%
    html_text()
  
  return(rank)
}

# Test the scraping function
rankIMDB('tt0080761')
rankIMDB('tt0082418')

# Vectorize the function
rankIMDBvector <- Vectorize(rankIMDB)

# Apply the function to the entire tibble
movies <- movies %>%
  mutate(rating=rankIMDBvector(id))

# Plot the results
ggplot(data=movies) +
  geom_col(mapping=aes(x=part, y=rating)) 
