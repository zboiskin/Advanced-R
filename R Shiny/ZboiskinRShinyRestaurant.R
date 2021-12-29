# Chicago Restaurant Inspection Analysis
# Zac Boiskin

library(shiny)
library(tidyverse)
library(lubridate)

# Load the dataset
inspections <- read_csv('https://chapple-datasets.s3.amazonaws.com/inspections2020.csv.gz')

# Clean the data
inspections <- inspections %>%
    mutate(Results=as.factor(Results)) %>%
    mutate(Date=mdy(`Inspection Date`)) %>%
    select(`DBA Name`, Address, City, Date, Results) %>%
    rename(Name=`DBA Name`)

# Group results into Pass/Fail.  Begin by dropping "non-inspections".
# Then we will make the business decision to convert "Pass w/ Conditions" to "Pass"
inspections <- inspections %>%
    filter(Results!='Business Not Located') %>%
    filter(Results!='No Entry') %>%
    filter(Results!='Not Ready') %>%
    filter(Results!='Out of Business') %>%
    mutate(Results=recode(Results, `Pass w/ Conditions`="Pass")) %>%
    mutate(Results=droplevels(Results)) 
 
# Clean up Chicago typos
badchicagos <- c('312CHICAGO', 'CCHICAGO', 'CHCHICAGO', 'CHICAGO.', 
                 'CHICAGOCHICAGO', 'CHICAGOHICAGO', 'CHICAGOI', 'CHCIAGO')
inspections <- inspections %>%
    mutate(City=ifelse(City %in% badchicagos, 'Chicago', City)) %>%
    mutate(City=str_to_title(City))

# Trim down to top 10 cities
keepers <- inspections %>%
    group_by(City) %>%
    summarize(n=n()) %>%
    top_n(10,n) 

inspections <- inspections %>%
    filter(!is.na(City)) %>%
    filter(City %in% keepers$City)

# Fix Niles
inspections <- inspections %>%
    mutate(City=ifelse(City=='Niles Niles', 'Niles', City))
    
# Define the user interface
ui <- fluidPage(

    # Application title
    titlePanel("Chicago Restaurant Inspections"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            checkboxGroupInput('cities','Choose Cities', unique(sort(inspections$City)), selected = 'Chicago')
        ),

        # Show a plot of the inspection results
        mainPanel(
           plotOutput("inspectionPlot")
        )
    )
)

# Define the server function
server <- function(input, output) {
    
    output$inspectionPlot <- renderPlot({
        inspections %>%
            filter(City %in% input$cities) %>%
            mutate(Year=as.factor(year(Date))) %>%
            ggplot() +
            geom_bar(mapping=aes(x=Year, fill=Results)) +
            theme(axis.text.x=element_text(angle=90))     
    })
}


# Run the application 
shinyApp(ui = ui, server = server)
