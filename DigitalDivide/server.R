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
library(plotly)


#Read in the main data file
digital <- read_csv("combineddata.csv")



shinyServer(function(input, output, session) {
  # EDA functions
  
  
  
  
  
  # Create the main plot
  # Function to create main plot  
  
      #Create Scatter Plot
  output$edaPlot <- renderPlotly({
    click_data <- event_data(event = "plotly_click", source = "select")
    digital$key <- row.names(digital)
    if (!is.null(click_data)) {
      highlight <- digital[digital$key %in% click_data$key,]
      print(click_data$key)
    }
    if (input$class){
      if (!is.null(click_data)) {
        p <-  ggplot(data = filter(digital, URBAN_RURAL == "Rural") , aes(x=!!rlang::sym(input$xvar), y=!!rlang::sym(input$yvar), size = Population, color = Population, text = paste("County:", County), key = key )) + 
          geom_point(alpha=0.7) + 
          scale_size( name="Population") +
          geom_point(data = highlight, aes(x=!!rlang::sym(input$xvar), y=!!rlang::sym(input$yvar)), color = "green")
      } else {
          p <-  ggplot(data = filter(digital, URBAN_RURAL == "Rural") , aes(x=!!rlang::sym(input$xvar), y=!!rlang::sym(input$yvar), size = Population, color = Population, text = paste("County:", County), key = key )) + 
          geom_point(alpha=0.7) + 
          scale_size( name="Population")
      }
    } else {
       if (!is.null(click_data)) {
    p <- ggplot(data = digital, aes(x=!!rlang::sym(input$xvar), y=!!rlang::sym(input$yvar), size = Population, color = URBAN_RURAL, text = paste("County:", County),key = key  )) +
      geom_point(alpha=0.7) +
      scale_size( name="Population") +
         geom_point(data = highlight, aes(x=!!rlang::sym(input$xvar), y=!!rlang::sym(input$yvar)), color = "green")
      } else {
         p <- ggplot(data = digital, aes(x=!!rlang::sym(input$xvar), y=!!rlang::sym(input$yvar), size = Population, color = URBAN_RURAL, text = paste("County:", County),key = key)) + 
      geom_point(alpha=0.7) + 
      scale_size( name="Population")
      }
    }
    ggplotly(p, source = "select")
  })
  
  output$table <- renderDataTable(digital,
                                  options = list(
                                    pageLength = 5))
 
  
  
                                                   

   #This ends the main plot Functions
  
  

  # End the Server side
})
