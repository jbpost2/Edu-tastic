library(tidyverse)

# Read in the internet data and select only relevant columns
internet <- read.csv("NC_Broadband_Indices.csv")
internet1 <- internet %>% filter(YEAR == "2019" ) %>% select(NAME_LOCAS,Percent_Ages_18_34, Percent_No_Int__Access, Percent_Poverty, Percent_Lim__English, Percent_No_Comp__Devices  )

# Read in the UNC Enrollment data
enrollment <- read.csv("overallunc.csv")
enrollment2 <- enrollment %>% filter(X == "Student Headcount") %>% select("County", "Fall.2019")

#Join the two data frames by county name
combined <- inner_join(enrollment2, internet1, by = setNames('NAME_LOCAS', 'County')) 
                       
# Enrollment numbers were not numbers so convert them
combined$Fall.2019 = as.character(combined$Fall.2019)
combined$Fall.2019 = as.numeric(combined$Fall.2019)

# Read in the population data by county and join it with the merged data set
popdata <- read.csv("popdata2.csv")
combined2 <- inner_join(combined, popdata, by = setNames('AreaName', 'County')) 

# Read in the county type date
classification <- read.csv("urban")
# Create a new variable for the percent of county residents enrolled in 4 year institutions
rate_of_admit <- combined2$Fall.2019/combined2$Population
combined2$rate <- rate_of_admit

# Plot the % of internet available vs the rate of enrollment
ggplot(combined2, aes(x=combined$Percent_No_Int__Access, y=rate, size = Population )) + 
  geom_point(alpha=0.7) + 
  scale_size(range = c(.1, 24), name="Population (M)")



