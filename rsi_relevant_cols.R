library(tidyverse)
library(stringr)
rsi <- read_csv("rsi_full.csv")

rsi <- rsi %>%
         select(countyname,
           county_pct_rural, 
           cluster_pct_rural_avg, 
           not_adjacent_urban,
           lowed,
           lowemp,
           perpov,
           perchldpov
           ) %>%
           mutate(countyname = str_sub(countyname, end = -11))
    
  
