library(tidyverse)
library(rtweet)
library(lubridate)


# Create a Twitter API token
# You'll need to replace the consumer_key, consumer_secret,
# access_token, and access_secret with the information provided to you.

create_token(
  app='RateCalc',
  consumer_key='9Sm96Bvu3k01YpJsU8GPQuMNB',
  consumer_secret='hUw97THOvZV9UbMhnyij016nKtxlDdjddMKCtUDqQAAOlUphHW',
  access_token='14045492-ziVbWIY0fDmrrCudY9Msrc0TSnQPwcm96WQ83coaa',
  access_secret='z33WItt4HcYPwN3F4O3uNfPFT3KQRDWsE7iv3lrlcFkZF'
)

# Use rtweet to pull @BarackObama's tweets
obama_tweets <- get_timeline('BarackObama',n=3200)
glimpse(obama_tweets)

# What time were they created?
obama_tweets$created_at

# Convert to Eastern time
obama_tweets <- obama_tweets %>%
  mutate(hour=hour(with_tz(created_at, tz="America/New_York")))

# Determine the percent of tweets created during each hour of the day
obama_hours <- obama_tweets %>%
  group_by(hour) %>%
  summarize(n=n()) %>% 
  mutate(freq=n/sum(n))

# Plot the results
ggplot() +
  geom_col(data=obama_hours, mapping=aes(x=hour, y=freq), fill='blue', alpha=0.6)

