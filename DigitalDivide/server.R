#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)


#Read in the main data file
digital <- read_csv("combineddata.csv")



shinyServer(function(input, output, session) {
  # EDA functions
  
  
  
  
  
  # Create the main plot
  # Function to create main plot  
  
      #Create Scatter Plot
  output$edaPlot <- renderPlot({
    ggplot(data = digital, aes(x=!!rlang::sym(input$xvar), y=!!rlang::sym(input$yvar), size = Population, color = URBAN_RURAL )) + 
      geom_point(alpha=0.7) + 
      scale_size(range = c(.1, 24), name="Population")
  })

   #This ends the main plot Functions
  
  

  # End the Server side
})
