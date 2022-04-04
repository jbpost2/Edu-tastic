library(tidyverse)

internet <- read.csv("NC_Broadband_Indices.csv")
internet1 <- internet %>% filter(YEAR == "2019" ) %>% select(NAME_LOCAS,Percent_Ages_18_34, Percent_No_Int__Access, Percent_Poverty, Percent_Lim__English, Percent_No_Comp__Devices  )

enrollment <- read.csv("overallunc.csv")
enrollment2 <- enrollment %>% filter(X == "Student Headcount") %>% select("County", "Fall.2019")


combined <- inner_join(enrollment2, internet1, by = setNames('NAME_LOCAS', 'County')) 
                       
combined$Fall.2019 = as.character(combined$Fall.2019)
combined$Fall.2019 = as.numeric(combined$Fall.2019)

ggplot(combined, aes(x=combined$Percent_No_Int__Access, y=Fall.2019)) + geom_point()
combined$Fall.2019

