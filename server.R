library(leaflet)
library(shiny)
library(plotly)

dados2 <-
  read.csv(
    "dataframe_enem2.csv",
    header = TRUE,
    stringsAsFactors = FALSE,
    dec = ","
  )

dados <-
  read.csv(
    "dataframe_enem.csv",
    header = TRUE,
    stringsAsFactors = FALSE,
    dec = ","
  )

shinyServer(function(input, output) {
  output$dados_enem<-renderDataTable(dados2,options = list(pageLength=5,searching = TRUE,autoWidth = TRUE, scrollX = TRUE))

  output$plot1<-renderPlotly({
      p <- plot_ly(dados2, y=dados2[,input$disc], color =dados2[,input$var], type = "box")
      x <- list(
        title = input$var
      )
      y <- list(
        title = input$disc
      )
      p %>% layout(xaxis = x, yaxis = y)
      
    })
  
  output$correla <- renderPrint({
    cor(dados2[,input$disc1],dados2[,input$var2])
  })
 output$plot2<-renderPlotly({
   fit <- lm(dados2[,input$disc1] ~  dados2[,input$var2], data = dados2)
   p <- plot_ly(dados2, y=dados2[,input$disc1], x = dados2[,input$var2],color = dados2[,input$var1], type = "scatter",mode="markers")%>%
     add_trace(data = dados2, x =dados2[,input$var2] , y = fitted(fit), mode = "lines")
   x <- list(
     title = input$var2
   )
   y <- list(
     title = input$disc1
   )
   p %>% layout(xaxis = x, yaxis = y)})
 
    })
