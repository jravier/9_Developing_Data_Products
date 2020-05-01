#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

terrain     <- volcano - min(volcano)

# Define server logic required to draw the maps
shinyServer(function(input, output) {
    #initial data
    waterL      <- reactive({input$waterL})
    
    # function to prepare and render the Plotly element
    output$waterPlot <- renderPlotly({
        bWaves      <- input$waves
        
        # intial values with no waves
        amplitude   <- 0
        water       <- matrix(waterL(), nrow = nrow(terrain), ncol =  ncol(terrain))
        waves       <- matrix(0, nrow = nrow(terrain), ncol =  ncol(terrain))
        
        # With waves, recalculate the water surface
        if(bWaves){
            waveAngle   <- input$wAngl / 360 * 2 * pi
            waveLength  <- input$wLength
            amplitude   <- input$wAmpl
            phase       <- input$Phase
            
            wcos = cos(waveAngle)
            wsin = sin(waveAngle)
            # * pmin.int(1+10/abs(waterL() - terrain),3)
            waves <- amplitude * 
                sin(((row(terrain) * wcos + col(terrain) * wsin) / 
                         waveLength + phase /360) * 2 * pi)
            water <- waterL() + waves
        }
        
        #Tune the color scale
        colorWater <- (waterL() - min(terrain))/(max(terrain) - min(terrain))
        colorDepth <- amplitude/(waterL() - min(terrain))
        colorAmp <- amplitude/(max(terrain) - min(terrain))
        colorArray <- array(c(c(0, colorWater-colorAmp,colorWater, colorWater+colorAmp, 1),
                              c("darkblue", "turquoise", "white", "green","red")), dim = c(5,2))
        waterArray <- array(c(c(0, 1-2*colorDepth, 1),
                              c("darkblue", "turquoise", "white")), dim = c(3,2))
        
        # Render the plotly elment with the 2 surfaces
        plot_ly(z=terrain, type = "surface", name = "Volcano",
                surfacecolor = ifelse(water <= terrain, terrain - waterL(), 
                                      ifelse(water - terrain > amplitude, 
                                             terrain - waterL(), 
                                             -amplitude)), 
                colorscale = colorArray, 
                colorbar = list(title="Elevation /\nDepth (m)")) %>%
            add_surface(z = water, name = "Sea",
                        surfacecolor = ifelse(water < terrain, 0, terrain - water), 
                        colorscale = waterArray,
                        opacity = 0.95, showscale = FALSE) %>%
            layout(title = "Water Level at the volcano",
                   scene = list(xaxis = list(title = "local x (m)"),
                                yaxis = list(title = "local y (m)"),
                                zaxis = list(title = "altitude (m)", range = c(0,130)))
            )
    })
    
    # Function to calculate the amount of water in the model
    output$volW <- renderText({
        formatC(sum(waterL() - ifelse(waterL() < terrain, waterL(), terrain)), 
                format = "d", big.mark = " ")
    })
    # Function to calculate the amount of land above water in the model
    output$volL <- renderText({
        formatC(sum(terrain - ifelse(waterL() > terrain, terrain, waterL())), 
                format = "d", big.mark = " ")
    })
    
})
