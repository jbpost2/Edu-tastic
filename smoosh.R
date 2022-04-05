## libs and such
library(tidyverse)
library(caret)

## county classifications - source: put together by hand based on NCDHHS info
## this allows us to filter for rural-only
ctyClass <- read_csv("county_classification.csv")
rural <- ctyClass %>%
  filter(urban_rural == "Rural") %>%
  mutate(countyname = tolower(countyname)) %>%
  select(countyname)
  
## internet data - source: [URL HERE SO WE CAN CITE]
## quick summary of what this is and why we need it
internet <- read_csv("NC_Broadband_Indices.csv")
internet1 <- internet %>% 
  filter(YEAR == "2019" ) %>% ## only keeping 2019 data
  mutate(NAME_LOCAS = tolower(NAME_LOCAS)) %>%
  select(NAME_LOCAS,
         Percent_Ages_18_34, 
         Percent_No_Int__Access, 
         Percent_Poverty, 
         Percent_Lim__English, 
         Percent_No_Comp__Devices
         )

rural <- left_join(rural, internet1, by = setNames('NAME_LOCAS', 'countyname'))

## unc system enrollment data: [URL HERE SO WE CAN CITE]
## quick summary of what this is and why we need it
enrollment <- read_csv("overallunc.csv")
names(enrollment) <- make.names(names(enrollment),unique = TRUE)
enrollment2 <- enrollment %>% 
  filter(.[[5]] == "Student Headcount") %>% 
  mutate(County = tolower(County)) %>%
  mutate(Fall.2019 = as.numeric(str_remove(Fall.2019, "[,]"))) %>%
  select(County, Fall.2019)

rural <- left_join(rural, enrollment2, by = setNames('County', 'countyname')) 

## population data: [URL HERE SO WE CAN CITE]
## quick summary of what this is and why we need it
popdata <- read_csv("popdata2.csv")
popdata <- popdata %>%
  mutate(AreaName = tolower(AreaName))
rural <- left_join(rural, popdata, by = setNames('AreaName', 'countyname')) 

## rural county school data (county vars): [URL HERE SO WE CAN CITE]
## quick summary of what this is and why we need it
rsi <- read_csv("rsi_full.csv")
rsi <- rsi %>%
  filter(state == "North Carolina") %>%
  select(countyname,
         county_pct_rural, 
         cluster_pct_rural_avg, 
         not_adjacent_urban,
         lowed,
         lowemp,
         perpov,
         perchldpov
  )%>%
  mutate(countyname = str_sub(countyname, end = -12)) %>%
  mutate(countyname = tolower(countyname))

rsi <- unique(rsi)

rural <- left_join(rural, rsi, by = c('countyname'))

rural <- rural %>%
  mutate(has_college = if_else(is.na(county_pct_rural), 0, 1)) %>%
  mutate(enroll_rate = (as.numeric(Fall.2019)/as.numeric(Population)))

## temporarily writing this to csv since dataset is small and I can eyeball it
write_csv(rural,"rural.csv")

## TODO: figure out how we want to deal with NA values, if those cols should be thrown out
## TODO: potentially add additional data sources, like K-12 spending
## TODO: variable selection for model
## TODO: train and test model, extracting variable importance measures


