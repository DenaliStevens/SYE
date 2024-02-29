
library(shiny)
library(tidyverse)
tuesdata <- tidytuesdayR::tt_load('2022-03-29')
tuesdata <- tidytuesdayR::tt_load(2022, week = 13)
CollegiateSports <- tuesdata$sports

# filter so its only Division 1 sports 
div1 <- CollegiateSports |> filter(grepl('NCAA Division I', classification_name)) |> filter(classification_code <= 3)
#str detect
# check that after I, its not another I, or exactly one I

# figured out that classifications for all D1 sports are either 1, 2, or 3
div1_smaller <- div1 |> select(1,3,7,8,20:28)

# selected only the columns that I'm interested in. 

div1_rev_expend <- div1_smaller |> select(1:4, 9, 12, 13)

university_names <- div1_rev_expend |> pull(institution_name)



# Define UI for application that draws histrgram for different schools 
ui <- fluidPage(

  # Give the page a title
  titlePanel("Revenue and Expenditure for D1 Sports 2015 - 2019"),
  
  # Generate a row with a sidebar
  sidebarLayout(      
    
    # Define the sidebar with one input
    sidebarPanel(
      selectInput("institution_name", "University:",
                  choices = c(university_names)),
      hr(),
    ),
    
    # Create a spot for the barplot
    mainPanel(
      plotOutput("revExpendPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  # Fill in the spot we created for a plot
  output$revExpendPlot <- renderPlot({
    
    # Render a barplot
    ggplot(data = school_select_rev_expend, aes(x = year, y = Dollars, fill = Type)) +
      geom_col(position = "dodge") +
      scale_y_continuous("Dollars",
                         breaks = scales::breaks_extended(8),
                         labels = scales::label_dollar()) +
      labs(title = str_glue("Total Revenue and Expenditure for Sports\nat {school_name}")) +
      theme_minimal() +
      scale_fill_viridis_d()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
