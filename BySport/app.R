CollegiateSports <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-03-29/sports.csv')
library(tidyverse)

# filter so its only Division 1 sports 
div1 <- CollegiateSports |> filter(grepl('NCAA Division I', classification_name)) |> filter(classification_code <= 3)


#str detect
# check that after I, its not another I, or exactly one I

# figured out that classifications for all D1 sports are either 1, 2, or 3
div1_smaller <- div1 |> select(1,3,7,8,20:28)

# selected only the columns that I'm interested in. 

div1_rev_expend <- div1_smaller |> select(1:4, 9, 12, 13)

selected_sport <- sport_smaller |> filter(sports == chose_sport) |>
  filter(!is.na(total_rev_menwomen), !is.na(total_exp_menwomen))

sports <- div1 |> pull(sports) |> unique()

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Give the page a title
  titlePanel("Revenue and Expenditure for D1 Sports 2015 - 2019, By Sport"),
  
  # Generate a row with a sidebar
  sidebarLayout(      
    
    # Define the sidebar
    sidebarPanel(
      selectInput("sport", "Sport:",
                  choices = (sports)),
      hr()
    ),
    
    # Create a spot for the boxplot
    mainPanel(
      plotOutput("plot1")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  selectedData <- reactive({
  
    selected_sport <- div1_rev_expend |> filter(sports == input$sport) |>
      filter(!is.na(total_rev_menwomen), !is.na(total_exp_menwomen)) |>
      group_by(institution_name, year, classification_name, sports) |>
      summarise(total_rev = sum(total_rev_menwomen), total_exp = sum(total_exp_menwomen)) |>
      pivot_longer(cols = c(total_rev, total_exp),
                   names_to = "Type", values_to = "Dollars")
  })
  
  # Fill in the spot we created for a plot
  output$plot1 <- renderPlot({
    
    # Render a boxplot
    ggplot(data = selectedData(), aes(x = factor(year), y = Dollars, fill = Type)) +
      geom_boxplot() +
      scale_y_continuous("Dollars",
                         breaks = scales::breaks_extended(8),
                         labels = scales::label_dollar()) +
      scale_fill_brewer(palette = "Set1") +
      labs(title = str_glue("Total Revenue and Expenditure for\nDivision 1 {input$sport}, 2015-2019"),
           x = "Year")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
