#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Análisis de ENSANUT"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
          selectInput("seleccionador", h3("Años desde el diagnóstico de:"), 
                      choices = list("Diabetes" = 1, "Cardiovascular" = 2), selected = 1)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot"),
            wellPanel(
              textOutput("textp")
            )
        )
    )
))
