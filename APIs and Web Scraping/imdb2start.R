library(tidyverse)
library(rvest)

# Friday the 13th movie data
id <- c('tt0080761', 'tt0082418', 'tt0083972', 'tt0087298', 'tt0089173', 'tt0091080', 'tt0095179', 'tt0097388')
part <- c('I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII')
rating <- c(0,0,0,0,0,0,0,0)

# Create a tibble
movies <- tibble(id, part, rating)

