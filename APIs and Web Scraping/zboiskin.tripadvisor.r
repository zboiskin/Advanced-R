library(tidyverse)
library(rvest)
library(scales)

# Attraction Information
url <- c('https://www.tripadvisor.com/Attraction_Review-g187791-d192274-Reviews-Basilica_di_Santa_Maria_Maggiore-Rome_Lazio.html',
         'https://www.tripadvisor.com/Attraction_Review-g187791-d197714-Reviews-Pantheon-Rome_Lazio.html',
         'https://www.tripadvisor.com/Attraction_Review-g187791-d192285-Reviews-Colosseum-Rome_Lazio.html',
         'https://www.tripadvisor.com/Attraction_Review-g187791-d2154770-Reviews-Roman_Forum-Rome_Lazio.html',
         'https://www.tripadvisor.com/Attraction_Review-g187791-d190996-Reviews-Palatine_Hill-Rome_Lazio.html'
         )

name <- c('Basilica di Santa Maria',
          'Pantheon',
          'Colosseum',
          'Roman Forum',
          'Palantine Hill'
          )

reviews <- c(0,0,0,0,0)

# Create a tibble
attractions <- tibble(name, url, reviews)

getReviewCount <- function(url)
{
  selector <- '.attractions-attraction-review-header-attraction-review-header__dotted_link--3p26D'
  
  page <- read_html(url)
  
  reviews <- page %>%
    html_nodes(selector) %>%
    html_text()
  
  reviews <- as.numeric(str_replace(str_split(reviews[1], ' ')[[1]][1], ',', ''))
  
  return(reviews)
}

getReviewCountVector <- Vectorize(getReviewCount)

attractions <- attractions %>%
  mutate(reviews=getReviewCountVector(url))

attractions %>% 
  ggplot() +
  geom_col(mapping=aes(x=name, y=reviews))
