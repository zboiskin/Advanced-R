# Including a Table
# MSBA 70210
# Week 4, Video 7

library(shiny)
library(tidyverse)
library(DT)

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
  selectInput("region", "Region", choices=c("West", "South", "Northeast", "Midwest")),
  sliderInput("sat", "SAT Range", min=400, max=1600, value=c(400,1600)),
  plotOutput('analysis'),
#  tableOutput('table')
  DTOutput('table')
)

# Server Function
server <- function(input, output) {
  output$analysis <- renderPlot({
    ggplot(data=filter(college, region==input$region 
                       & sat_avg >= input$sat[1] & sat_avg <= input$sat[2])) +
      geom_bar(mapping=aes(x=highest_degree, fill=control)) +
      ylim(0,400) +
      theme(panel.background = element_blank())
  })

# This code rendered the table with the Shiny renderTable function  
#  output$table <- renderTable(filter(college, region==input$region 
#                                     & sat_avg >= input$sat[1] & sat_avg <= input$sat[2]) %>%
#                                select(name, city, state, sat_avg) %>%
#                                arrange(desc(sat_avg)))

# Here we use DT for table rendering instead  
  output$table <- renderDT(filter(college, region==input$region 
                                     & sat_avg >= input$sat[1] & sat_avg <= input$sat[2]) %>%
                                select(name, city, state, sat_avg) %>%
                                arrange(desc(sat_avg)))
  
}

# Run the application 
shinyApp(ui = ui, server = server)

