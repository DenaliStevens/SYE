
library(shiny)
library(tidyverse)
tuesdata <- tidytuesdayR::tt_load('2022-03-29')
tuesdata <- tidytuesdayR::tt_load(2022, week = 13)
CollegiateSports <- tuesdata$sports

# Define UI for application that creates a data table
ui <- fluidPage(
  
  # Application title
  titlePanel("Collegiate Sports Data"),
  
  # Create a new Row in the UI for selectInputs
  fluidRow(
    column(4,
           selectizeInput("year",
                          "Year: ",
                          c("All",
                            unique(as.character(CollegiateSports$year))))
    ),
    column(4,
           selectizeInput("institution_name",
                          "University: ",
                          c("All",
                            unique(as.character(CollegiateSports$institution_name))))
    ),
    column(4,
           selectizeInput("sports",
                          "Sport: ",
                          c("All",
                            unique(as.character(CollegiateSports$sports))))
          
    )
    
  ),
  # Create a new row for the table.
  DT::dataTableOutput("table")
  
)


server <- function(input, output) {
  
  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- CollegiateSports
    if (input$year != "All") {
      data <- data[data$year == input$year,]
    }
    if (input$institution_name != "All") {
      data <- data[data$institution_name == input$institution_name,]
    }
    if (input$sports != "All") {
      data <- data[data$sports == input$sports,]
    }
    data
  }))
  
}
# Run the application 
shinyApp(ui = ui, server = server)


