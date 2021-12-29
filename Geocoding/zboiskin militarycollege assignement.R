# College/Air Force Base Pairing Tool
# Zac Boiskin
#
# Our objective is to take the 100 largest colleges in the U.S. and match them
# up to their nearest Air Force base.

library(tidyverse)
library(ggmap)
library(rvest)
library(geosphere)

register_google('AIzaSyDS57onA4Az4VXE8gK1v-gU1fN25K47ZMU')

# Load in the college dataset and extract the largest 100 schools
college <- read_csv('https://chapple-datasets.s3.amazonaws.com/college.csv')

college <- college %>%
  top_n(100, undergrads) %>%
  arrange(desc(undergrads)) %>%
  select(name, city, state, undergrads, lon, lat)

# This website has a listing of Air Force base names:
# https://www.military.com/base-guide/browse-by-service/air-force
# bases <- bases %>%
  mutate(lat=geocode(base_name)$lat, lon=geocode(base_name)$lon)
# Scrape the names from the site, extracting only the domestic bases.

url <- 'https://www.military.com/base-guide/browse-by-service/air-force'

base_names <- read_html(url) %>%
  html_nodes('.bullet-section-summary:nth-child(1) a') %>%
  html_text()

# Create a tibble with placeholders for latitude and longitude
bases <- tibble(base_name=base_names, lat=NA, lon=NA) %>%
  mutate(lat=as.numeric(lat), lon=as.numeric(lon))

# Geocode the base names


# Next we need to do a cross-join of the tables.
base_school_pairs <- merge(bases, college, by=NULL)

#testing distances
distGeo(c(-86.4,32.4), c(-81.4,28.5))/1609.34

# Create a distance function
point_distance <- Vectorize(function(start_lon, start_lat, finish_lon, finish_lat)
{
  require(geosphere)
  start <- c(start_lon, start_lat)
  finish <- c(finish_lon, finish_lat)
  distance <- distGeo(start, finish)
  # Convert from meters to miles
  distance <- distance/1609.34
  return(distance)
})

#function test
point_distance(-86.4, 32.4, -81.4, 28.5)

# Calculate the distances
base_school_pairs <- base_school_pairs %>%
  mutate(distance=point_distance(lon.x, lat.x, lon.y, lat.y))

# Do a little cleanup
base_school_pairs <- base_school_pairs %>%
  select(school_name=name, base_name, distance)
  
# Find the closest school to each base
base_school_pairs <- base_school_pairs %>%
  group_by(school_name) %>%
  filter(distance==min(distance)) %>%
  arrange(distance)

View(base_school_pairs)

# Why are there 101 rows?
# Are there duplicate schools?

base_school_pairs %>% 
  group_by(school_name) %>% 
  summarize(n=n()) %>% 
  arrange(desc(n))

base_school_pairs %>%
  filter(school_name=='Virginia Commonwealth University')
