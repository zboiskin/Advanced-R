# Creating a Plot
# MSBA 70210
# Week 4, Video 5

library(shiny)
library(tidyverse)

# Load the college dataset, as before
college <- read_csv('https://s3.amazonaws.com/itao-30230/college.csv')
college$state <- as.factor(college$state)
college$region <- as.factor(college$region)
college$highest_degree <- as.factor(college$highest_degree)
college$control <- as.factor(college$control)
college$gender <- as.factor(college$gender)
college$loan_default_rate <- as.numeric(college$loan_default_rate)
college <- college %>% filter(highest_degree != 'Nondegree')

# Client Function
ui <- fluidPage(
  titlePanel("Colleges By Degree Type"),
  plotOutput('analysis')
)

# Server Function
server <- function(input, output) {
  output$analysis <- renderPlot({
    ggplot(data=college) +
      geom_bar(mapping=aes(x=highest_degree, fill=control)) +
      theme(panel.background = element_blank())
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

