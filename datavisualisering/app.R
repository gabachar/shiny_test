library(shiny)
library(shinythemes)
library(tidyverse)
library(readxl)

passat <- read_excel("passat.xlsx")

# UI
ui <- fluidPage(

    
    titlePanel("Datavisualisering", title = div(img(height = 100, width = 100, src = "Analytics.png"))),
    theme = shinytheme("superhero"),  
  
    headerPanel("Her er min header!"),
    
   
    sidebarLayout(
        sidebarPanel("", 
                     selectInput("xaxis", label = "Vælg x-akse", choices = names(passat), selected = "km_per_liter", TRUE, multiple = FALSE),
                     selectInput("yaxis", label = "Vælg y-akse", choices = names(passat), multiple = FALSE),
                     selectInput("data_input", label = "Vælg datasæt", choices = c("mtcars", "faithful", "iris"))),


        mainPanel("",
                  tabsetPanel(id = "tabs",
                            tabPanel("Plot", plotOutput("plot")),
                            tabPanel("Tabel", tableOutput("tabel"))))
    )
)

# Server
server <- function(input, output, session) {
    output$plot1 <- renderPlot({
        ggplot(passat, aes_string(x = as.name(input$xaxis), y = as.name(input$yaxis))) +
            geom_point()
    })

    getdata <- reactive ({
        
        get(input$data_input, "package:datasets")
    })
    
    output$tabel <- renderTable({head(getdata())})
}



# Run the application 
shinyApp(ui = ui, server = server)
