library(tidyverse)

# Read in the internet data and select only relevant columns
internet <- read.csv("NC_Broadband_Indices.csv")
internet1 <- internet %>% 
  filter(YEAR == "2018" ) %>% 
  mutate(County = NAME_LOCAS) %>%
  select(County,
         Percent_Ages_18_34, 
         Percent_No_Int__Access, 
         Percent_Poverty, 
         Percent_Lim__English, 
         Percent_No_Comp__Devices, 
         Availability,
         Adoption,
         Percent_Pop__No_Prov_,
         Percent_Hhlds__Children,
         Percent_Pop__25_3,
         Percent_Pop__100_20
  )

# Read in the population data by county and join it with the merged data set
popdata <- read.csv("popdata2.csv")
combined2 <- inner_join(internet1, popdata, by = setNames('AreaName', 'County')) 

# Read in the county type data
classification <- read.csv("urbanruralclass.csv")

# Add a classification column to the combined data
combined3 <- inner_join(combined2, classification, by = setNames("COUNTYNAME", "County"))

# Read in RSI data in order to add has_college variable
rsi <- read_csv("rsi_full.csv")
rsi <- rsi %>%
  filter(state == "North Carolina") %>%
  select(countyname
  )%>%
  mutate(countyname = str_sub(countyname, end = -12)) %>%
  mutate(has_college = 1)

rsi <- unique(rsi)

combined4 <- left_join(combined3, rsi, by = setNames("countyname", "County"))

combined4 <- combined4 %>%
  mutate(has_college = if_else(is.na(has_college), 0,1))

# Read in the educational data by county
edu_data <- read.csv("schooldata.csv")
edu_data <- edu_data %>%
  mutate(County = (gsub(" County","",Name))) %>%
  select(
    -Name,
    -Geographic.Type
  )

full_data <- inner_join(edu_data, combined4, by = setNames("County", "County"))

write_csv(full_data,"full_data.csv")

