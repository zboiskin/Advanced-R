# Advanced R
#
# Connect to Chicago Crime database
#
# You should run this code using RStudio in AWS Workspaces.

library(tidyverse)
library(dbplyr)
library(odbc)

# Connect to the database
connectionString <- 'Driver={SQL Server Native Client 11.0}; Server=mcobsql.business.nd.edu; Uid=BANstudent;Pwd=SQL%database!Mendoza; Database=ChicagoCrime;'
sqlserver <- dbConnect(odbc::odbc(), .connection_string=connectionString)

# Retrieve the data by sending a SQL command
query <- "SELECT wards.ward, wards.percentIncomeUnder25K , COUNT(*) as homicides
FROM crimes
INNER JOIN IUCR
ON crimes.IUCR = IUCR.IUCR
INNER JOIN wards
ON crimes.ward = wards.ward
WHERE IUCR.category='Homicide'
GROUP BY wards.ward,  wards.percentIncomeUnder25K"

homicides <- dbGetQuery(sqlserver, query)
summary(homicides)

# Retrieve the same data using dbplyr
# Begin by creating table references
# This is a flat database, so you don't need to use the in_schema function

crimes <- tbl(sqlserver, 'crimes')
IUCR <- tbl(sqlserver, 'IUCR')
wards <- tbl(sqlserver, 'wards')

str(crimes)
show_query(crimes)

# Build the dataset with dplyr verbs
homicides_by_ward <- crimes %>%
  inner_join(wards, by='ward') %>%
  inner_join(IUCR, by='IUCR') %>%
  filter(category=='Homicide') %>%
  group_by(ward, percentIncomeUnder25K) %>%
  summarize(homicides=n())

show_query(homicides_by_ward)

# Retrieve the data using that query
homicides <- homicides_by_ward %>% collect()

# Plot a regression line
homicides %>% 
  ggplot(mapping=aes(x=percentIncomeUnder25K, y=homicides)) +
  geom_point() +
  geom_smooth(method="lm")
