
library(shiny)
library(leaflet)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("台北市政府消防局 EOC 資料：災情地圖"),
  
  sidebarLayout(
    
    # Sidebar with a slider input
    sidebarPanel(
      textOutput("times")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      leafletOutput("map"),
      dataTableOutput(outputId="table")
    )
  )
))
