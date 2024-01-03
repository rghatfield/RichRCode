#PNWBBA Analysis
#Top Intro####
#Libraries used in this codesheet.
library("car")
library("rgl")
getwd()
library(tidyverse)
library(ggplot2)
library(plotly)
library(htmlwidgets)

#To create a 3D elevation plot across the PNW for each species.
#Import the csv file that has the L
ThreeDElePlotD <- read.csv("X:/My Drive/Bombus/BBAtlas/RProjects/BOMBUSS23/3DPlotData.csv")
View(ThreeDElePlotD)

ThreeDPlotD <- BBSurveys_wEle %>% 
  tidyr::pivot_longer(cols = occidentalis:vosnesenskii, names_to = 'species', values_to = "surveyDet")



#The code below loops through all species in the df$species column and saves an html file of each
bees <- unique(ThreeDElePlotD$species) #establishes the values for bees (all of the species that will be looped)
for (i in bees) {
  OneSp <- filter(ThreeDElePlotD, ThreeDElePlotD$species == i) #creates a filtered dataframe for each species "i"
  OneSp$surveyDet <- factor(OneSp$surveyDet, levels = c("sp.", i)) #establishes the plotting order for each such that "i" will be visible in the chart, and not whether it is before or after sp. in alpha
  fig1 <- plot_ly(OneSp, x=~Longitude, y=~Latitude, z=~Elevation, color = ~surveyDet, colors = c("grey", "red"), size = ~occRichness, opacity = .7,
                  marker = list(symbol = 'circle', sizemode = 'diameter'), sizes = c(5,50))
  fig <- fig1 %>% layout(scene = list(camera = list(eye = list(x = 0, y = -0.01, z = 2) #this changes the camera angle so that it has lat/long oriented appropriately, and elevation up.
  )))
  fig
  #make unique file name
  file_name <- paste("Elevation_", i, ".html", sep = "")
  htmlwidgets::saveWidget(fig, file_name)
}