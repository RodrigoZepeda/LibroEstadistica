library(survey) #install.packages("survey")
library(readr)
library(tidyverse)
ensanut <- read_csv("~/Downloads/ENSANUT_1 (1).csv")

#Obtengo un identificador por persona pegando el número de casa + el de persona
#sólo pasa en ENSANUT
ensanut <- ensanut %>%
  mutate(id = paste0(VIV_SEL,"_",NUMREN))

ensanut <- ensanut %>%
  mutate(Diabetes = ifelse(P3_1 == 1, 1, 0))

diseño <- svydesign(id = ~id, strata = ~EST_DIS, weights = ~F_20MAS,
                    PSU = ~UPM, data = ensanut, nest = TRUE)

svymean(~Diabetes, diseño)
svymean(~Diabetes, diseño) %>% confint()
svyquantile(~Diabetes, diseño, 0.75) 

ensanut <- ensanut %>%
  mutate(Infarto = ifelse(P5_1 == 1, 1, 0))

#Actualizo el diseño
diseño <- svydesign(id = ~id, strata = ~EST_DIS, weights = ~F_20MAS,
                    PSU = ~UPM, data = ensanut, nest = TRUE)

svymean(~Infarto, diseño)
svymean(~Infarto, diseño) %>% confint()

#Un histograma mal hecho de a qué edad tuvo el primer infarto
ensanut$P5_4 <- as.numeric(ensanut$P5_4)

#Como 999 es no sabe y 888 es no responde entonces los cambio a NA
ensanut <- ensanut %>% 
  mutate(P5_4 = if_else(P5_4 == 888 | P5_4 == 999, as.numeric(NA), P5_4))

#ESTE HABLA DE LA MUESTRA NO DE LA POP MEXICANA
ggplot(ensanut) +
  geom_histogram(aes(x = P5_4), bins = 30)

diseño <- svydesign(id = ~id, strata = ~EST_DIS, weights = ~F_20MAS,
                    PSU = ~UPM, data = ensanut, nest = TRUE)

svyhist(~P5_4, diseño, bins = 30, 
        main = "Años cuando infarto") #ESTE SÍ VA A HABLAR DE LA POP MEXICANA







