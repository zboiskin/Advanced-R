library(tidyverse)
library(jsonlite)

# Construct the Per Diem API call
url <- 'https://inventory.data.gov/api/action/datastore_search?resource_id=8ea44bc4-22ba-4386-b84c-1494ab28964b&limit=300000'
filter_prefix <- '&filters={%22FiscalYear%22:%22'
fiscal_year <- '2019'
zip_prefix <- '%22,%22Zip%22:%22'
zip <- '60604'
filter_suffix <- '%22}'

# Request Chicago data from 2019
request <- paste0(url, filter_prefix, fiscal_year, zip_prefix, zip, filter_suffix)
fromJSON(request)
perdiem <- fromJSON(request)
perdiem <- perdiem$result$records

# Request New York City data from 2019
zip <- '10001'
request <- paste0(url, filter_prefix, fiscal_year, zip_prefix, zip, filter_suffix)
perdiem <- fromJSON(request)
perdiem <- perdiem$result$records

# Request all cities from 2019
request <- paste0(url, filter_prefix, fiscal_year, filter_suffix)
perdiem <- fromJSON(request)
perdiem <- perdiem$result$records

# Convert December to numeric
perdiem <- perdiem %>% mutate(Dec=as.numeric(Dec))

# Average perdiem rate for December
mean(perdiem$Dec)
