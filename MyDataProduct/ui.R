#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Volcano at sea"),
    
    tabsetPanel(
        tabPanel("Documentation", 
                 h3("General Principle"),
                 p("This application (cf. 'Application' tab) uses Plotly to display 
                 a 3D Surface of the 'volcano' data set, 
                   together with another 3D surface showing water level, 
                   as if the volcano was a marine one."), 
                 
                 h3("Usage"),
                 h4("Basic use"),
                 tags$ul(
                     tags$li("Click on the 'Application' tab and WAIT for the surfaces 
                    to be rendered by the Plotly element on the right side of the page."),
                     tags$li("Use your mouse and the action buttons above the Plotly element 
                   to change the view of the surfaces.")
                 ),
                 p("Below the Plotly element, you will see the result of 
                   some calculations about volumes displayed in the models."),
                 
                 h4("Interaction"),
                 p("After each interaction, please WAIT for the plotly element to be rendered 
                   again by the server."),
                 tags$ul(
                     tags$li("You can change the water level using the slider on the left."),
                     tags$li("You can add waves to the water surface by checking the provided box.",
                             p("When checked, this box makes new sliders apparent, allowing you to control
                         the parameters of the waves:"),
                             tags$ul(
                                 tags$li("Direction from which the waves are coming."),
                                 tags$li("Amplitude and wave length."),
                                 tags$li("Phase of the wave: this allow you to see the waves at different positions.")
                             ))),
                 p("Please note that the waves are NOT taken into account when calculating the volumes.")
        ),
        tabPanel("Application", 
                 
                 # Sidebar with a slider input for Water level
                 sidebarLayout(
                     sidebarPanel(
                         sliderInput("waterL",
                                     "Water Level:",
                                     post = "m",
                                     min = 0,
                                     max = 100,
                                     value = 71),
                         # Checkbox input for adding waves to the water surface
                         checkboxInput("waves", "Show waves", FALSE),
                         # If wave is checked, display the wave parameters using slider inputs
                         conditionalPanel(condition = "input.waves",
                                          sliderInput("wAngl",
                                                      "Angle:",
                                                      post = "°",
                                                      min = -90,
                                                      max = 90,
                                                      step = 5,
                                                      value = 10),
                                          sliderInput("wAmpl",
                                                      "Amplitude:",
                                                      post = "m",
                                                      min = 1,
                                                      max = 10,
                                                      value = 3),
                                          sliderInput("wLength",
                                                      "Wave Length:",
                                                      post = "m",
                                                      min = 10,
                                                      max = 100,
                                                      step = 10,
                                                      value = 20),
                                          sliderInput("Phase",
                                                      "Phase:",
                                                      post = "°",
                                                      min = -180,
                                                      max = 180,
                                                      step = 45,
                                                      value = -180,
                                                      animate = list(interval = 1000))
                         ),
                         
                     ),
                     
                     # Show a Plotly Output with the 3D surfaces of both the volcano and the water
                     mainPanel(
                         plotlyOutput("waterPlot"),
                         
                         # additionaly show computed values
                         h3("Calculated values:"),
                         tags$li("Volume of water:",
                                 textOutput("volW", inline = TRUE), 
                                 "m", tags$sup("3")),
                         tags$li("Volume of emerged land:",
                                 textOutput("volL", inline = TRUE), 
                                 "m", tags$sup("3"))
                     )
                 ))
    )
))
