#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Rely on the 'WorldPhones' dataset in the datasets
# package (which generally comes preloaded).
library(datasets)

library(tidyverse)

gravier_data <- read_csv("gravier_data.csv")
gravier_data <- gravier_data %>% 
    select(-outcome)

# Use a fluid Bootstrap layout
ui <- fluidPage(    
    
    # Give the page a title
    titlePanel("Gene expression analysis"),
    
    # Generate a row with a sidebar
    sidebarLayout(      
        
        # Define the sidebar with one input
        sidebarPanel(
            selectInput("gene1", "Gene 1:", 
                        choices=colnames(gravier_data)),
            selectInput("gene2", "Gene 2:", 
                        choices=colnames(gravier_data)),
            hr(),
            helpText("Data from Gravier database")
        ),
        
        # Create a spot for the barplot
        mainPanel(
            plotOutput("scatterplot")  
        )
        
    )
)


# Rely on the 'Gene expression data' in the datasets
# Gravier data is loaded from the file.

# Define a server for the Shiny app
server <- function(input, output) {
    output$scatterplot <- renderPlot({
        p = ggplot(data = read.csv("gravier_data.csv")) +
            aes_string(x = input$"gene1", y = input$"gene2") +
            geom_point()
        plot(p)
    })
}



# Run the application 
shinyApp(ui = ui, server = server)
