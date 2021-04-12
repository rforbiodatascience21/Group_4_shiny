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

load(file = "/cloud/project/gravier_app/data/gravier.RData")
gravier_data <- LoadToEnvironment <- function(RData, env=new.env()) {
    load(RData, env)
    return(env)
}

gravier_data <- mutate(as_tibble(pluck(gravier, "x")),
                       outcome = pluck(gravier, "y"))

gravier_data <- gravier_data %>% 
    select(outcome, everything())

gravier_data <- gravier_data %>% 
    mutate(outcome = case_when(outcome == "good" ~ 0,
                               outcome == "poor" ~ 1))


# Use a fluid Bootstrap layout
ui <- fluidPage(    
    
    # Give the page a title
    titlePanel("Gene expression analysis"),
    
    # Generate a row with a sidebar
    sidebarLayout(      
        
        # Define the sidebar with one input
        sidebarPanel(
            selectInput("gene", "Gene:", 
                        choices=colnames(gene)),
            hr(),
            helpText("Data from Gravier database")
        ),
        
        # Create a spot for the barplot
        mainPanel(
            plotOutput("phonePlot")  
        )
        
    )
)


# Rely on the 'Gene expression data' in the datasets
# Gravier data is loaded from the file.

# Define a server for the Shiny app
server <- function(input, output) {
    
    # Fill in the spot we created for a plot
    output$phonePlot <- renderPlot({
        
        # Render a barplot
        barplot(WorldPhones[,input$region]*1000, 
                main=input$region,
                ylab="Number of Telephones",
                xlab="Year")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
