#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(survey) 
library(readr)
library(tidyverse)

#Preparación de la base
ensanut <- read_csv("~/Downloads/ENSANUT_1 (1).csv")

ensanut <- ensanut %>%
  mutate(id = paste0(VIV_SEL,"_",NUMREN))

ensanut <- ensanut %>%
  mutate(Diabetes = ifelse(P3_1 == 1, 1, 0))

ensanut <- ensanut %>%
  mutate(Infarto = ifelse(P5_1 == 1, 1, 0))

ensanut <- ensanut %>%
  mutate(P5_4 = as.numeric(P5_4))

diseño <- svydesign(id = ~id, strata = ~EST_DIS, weights = ~F_20MAS,
                       PSU = ~UPM, data = ensanut, nest = TRUE)

options(survey.lonely.psu="adjust")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  
    output$distPlot <- renderPlot({

        # draw the histogram with the specified number of bins
      if (input$seleccionador == 1){
        
         svyhist(~P3_2, diseño, main = "Edad de diagnóstico", 
                 xlab = "Edad al ser diagnosticado con diabetes", breaks = 50, col = 'red', border = 'white')
        
      } else {
        
        svyhist(~P5_4, diseño, main = "Edad de diagnóstico", 
               xlab = "Edad del primer infarto", breaks = 50, col = 'deepskyblue', border = 'white')
      }

    })
    
    output$textp <- renderText({
      
      # draw the histogram with the specified number of bins
      if (input$seleccionador == 1){
        
        prop   <- svymean(~Diabetes, diseño)
        ciprop <- confint(prop) %>% round(4)
        paste0("Proporción de gente con diabetes es ", round(prop,4), "% [", ciprop[1],",", ciprop[2],"]")  
        
      } else {
        
        prop   <- svymean(~Infarto, diseño)
        ciprop <- confint(prop) %>% round(4)
        paste0("Proporción de gente con infarto es ", round(prop,4), "% [", ciprop[1],",", ciprop[2],"]")  
      }
      
    })

})
