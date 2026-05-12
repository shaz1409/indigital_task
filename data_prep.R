# Bloomroot MMM - data prep
library(dplyr)
library(readr)
library(lubridate)

df <- read_csv("data/marketing_weekly.csv") %>%
  mutate(
    week = as.Date(week),
    promo_active = as.integer(promo_flag == "Y")
  ) %>%
  select(-promo_flag) %>%
  arrange(week)

# Sanity checks
stopifnot(!any(is.na(df$revenue)))
stopifnot(all(as.numeric(diff(df$week)) == 7))

write_csv(df, "data/marketing_weekly_clean.csv")
