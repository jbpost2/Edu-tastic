#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  navbarPage(
    # Application title
    title = "Digital Divide",
    
  
    
    #EDA Panel
    tabPanel("Data Exploration",
             # Sidebar with a slider input for number of bins 
             sidebarLayout(
               sidebarPanel(
                 
                 #Choose x variable for data exploration
                 selectInput("xvar",
                             "Select X variable",
                             c("Enrollment Rate" = "rate",
                               "% no internet access" = "Percent_No_Int__Access",
                               "% Poverty"= "Percent_Poverty",
                               "% Limited English"="Percent_Lim__English",
                               "% No Computer Devices" = "Percent_No_Comp__Devices"
                               )),
                 
                 #Choose y variable for exploration
                 selectInput("yvar",
                             "Select Y variable",
                             c("Enrollment Rate" = "rate",
                               "% no internet access" = "Percent_No_Int__Access",
                               "% Poverty"= "Percent_Poverty",
                               "% Limited English"="Percent_Lim__English",
                               "% No Computer Devices" = "Percent_No_Comp__Devices")),
                 
                 
                 
               ), #This ends sidebarPanel
               
               
               mainPanel(
                 
                 plotOutput("edaPlot"),
                 dataTableOutput('table')
                 
                 
                 
               )# This ends mainPanel 
             ) # This ends Data Exploration tab
    ),
    
    
  ) #This ends navbarPage
))#This ends ShinyUI Fluidpage
