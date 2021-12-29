# Hello, World!
# MSBA 70210
# Week 4, Video 3

library(shiny)

# The client/user interface function asks the user to enter a name, which is passed
# to the server function.  It then receives the greeting from the server and provides
# it as text output.
ui <- fluidPage(
  titlePanel("Hello, world!"),
  textInput('name', "Enter Your Name"), 
  textOutput('greeting')
)

# The server function takes the name provided as input and creates a greeting
# of the form "Hello, name!" and returns it as output.
server <- function(input, output) {
   output$greeting <- renderText(paste0("Hello, ", input$name, "!"))
}

# Run the web application 
shinyApp(ui = ui, server = server)

