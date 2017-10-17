library(shiny)
library(shinydashboard)
library(leaflet)
library(plotly)

dados <-
  read.csv("dataframe_enem.csv",
           header = TRUE,
           stringsAsFactors = FALSE,
           dec = ","
  )

#criação de supsets
dadosM <-
  subset(dados, dados$dependÊncia_administrativa == "Municipal")
dadosE <-
  subset(dados, dados$dependÊncia_administrativa == "Estadual")
dadosF <-
  subset(dados, dados$dependÊncia_administrativa == "Federal")
dadosP <-
  subset(dados, dados$dependÊncia_administrativa == "Privada")
#nv <- (dados$mÉdia_lc - 430.17) / (615.85 - 430.17)

popupM <- paste0(
  dadosM$nome_da_entidade,
  "<br>Quantidade de Participantes: ",
  dadosM$nÚmero_de_participantes_no_enem,
  "<br>Nota Média em Mat: ",
  dadosM$mÉdia_mat,
  "<br>Nota Média Port: ",
  dadosM$mÉdia_lc,
  "<br>Nota Média Ciencias Humanas: ",
  dadosM$mÉdia_ch,
  "<br>Nota Média Ciencias da Natureza: ",
  dadosM$mÉdia_cn,
  "<br>Nota Média Redação: ",
  dadosM$mÉdia_redaÇÂo
)

popupE <- paste0(
  dadosE$nome_da_entidade,
  "<br>Quantidade de Participantes: ",
  dadosE$nÚmero_de_participantes_no_enem,
  "<br>Nota Média em Mat: ",
  dadosE$mÉdia_mat,
  "<br>Nota Média Port: ",
  dadosE$mÉdia_lc,
  "<br>Nota Média Ciencias Humanas: ",
  dadosE$mÉdia_ch,
  "<br>Nota Média Ciencias da Natureza: ",
  dadosE$mÉdia_cn,
  "<br>Nota Média Redação: ",
  dadosE$mÉdia_redaÇÂo
)

popupF <- paste0(
  dadosF$nome_da_entidade,
  "<br>Quantidade de Participantes: ",
  dadosF$nÚmero_de_participantes_no_enem,
  "<br>Nota Média em Mat: ",
  dadosF$mÉdia_mat,
  "<br>Nota Média Port: ",
  dadosF$mÉdia_lc,
  "<br>Nota Média Ciencias Humanas: ",
  dadosF$mÉdia_ch,
  "<br>Nota Média Ciencias da Natureza: ",
  dadosF$mÉdia_cn,
  "<br>Nota Média Redação: ",
  dadosF$mÉdia_redaÇÂo
)

popupP <- paste0(
  dadosP$nome_da_entidade,
  "<br>Quantidade de Participantes: ",
  dadosP$nÚmero_de_participantes_no_enem,
  "<br>Nota Média em Mat: ",
  dadosP$mÉdia_mat,
  "<br>Nota Média Port: ",
  dadosP$mÉdia_lc,
  "<br>Nota Média Ciencias Humanas: ",
  dadosP$mÉdia_ch,
  "<br>Nota Média Ciencias da Natureza: ",
  dadosP$mÉdia_cn,
  "<br>Nota Média Redação: ",
  dadosP$mÉdia_redaÇÂo
)

ui <- dashboardPage(skin = "green",
  dashboardHeader(title = "Enem e Censo das Escolas de Santa Catarina",titleWidth = 500),
  dashboardSidebar(disable = TRUE),
  dashboardBody(tabBox(width = 12,side = "left",
                       tabPanel( "Mapa",
                    tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
                    leaflet(width = "100%",height = 900) %>%
                      addTiles(urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                               attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>') %>%
                      setView(-50.048123,-27.070822, zoom = 8) %>%
                      #Circulos mat
                      addCircles(
                        lng = dadosM$long,
                        lat = dadosM$lat,
                        radius = dadosM$nÚmero_de_participantes_no_enem,
                        color = "#ff0000",
                        group = "Municipal",
                        popup = popupM
                      ) %>%
                      addCircles(
                        lng = dadosE$long,
                        lat = dadosE$lat,
                        radius = dadosE$nÚmero_de_participantes_no_enem,
                        color = "#ff00ff",
                        group = "Estadual",
                        popup = popupE
                      ) %>%
                      addCircles(
                        lng = dadosF$long,
                        lat = dadosF$lat,
                        radius = dadosF$nÚmero_de_participantes_no_enem,
                        color = "#00ff00",
                        group = "Federal",
                        popup = popupF
                      ) %>%
                      addCircles(
                        lng = dadosP$long,
                        lat = dadosP$lat,
                        radius = dadosP$nÚmero_de_participantes_no_enem,
                        color = "#003399",
                        group = "Privada",
                        popup = popupP
                      ) %>%
                      #Marcadores
                      #        addMarkers(lng=dadosM$long, lat=dadosM$lat,group="Municipal",popup=popupM)%>%
                      #      addMarkers(lng=dadosE$long, lat=dadosE$lat,group="Estadual",popup=popupE)%>%
                      #    addMarkers(lng=dadosF$long, lat=dadosF$lat,group="Federal",popup=popupF)%>%
                      #  addMarkers(lng=dadosP$long, lat=dadosP$lat,group="Privada",popup=popupP)%>%
                      #Controladores
                      addLayersControl(
                        overlayGroups = c("Municipal", "Estadual", "Federal", "Privada"),
                        options = layersControlOptions(collapsed = FALSE),
                        position="topleft"
                      ) %>%
                      addLegend(
                        position = "topleft",
                        title = "Legenda",
                        colors = c("#ff0000", "#ff00ff", "#00ff00", "#003399"),
                        labels = c("Municip", "Estadual", "Federal", "Privada")
                      ),
                    
                    #-----------------------------------------Mapa-----------------------------------------------------
                 
                      absolutePanel(
                        id = "Alunos",
                        class = "panel panel-default",
                        fixed = TRUE,
                        top = 400,
                        right = 10,
                        width = 500,
                        height = 720,
                        draggable = TRUE,
                     # -------------------------------------Box-plot------------------   
                        tabBox(width = 12,tabPanel("Box-plot",
                          selectInput("disc","Escolha a disciplina",choices = c("Linguagem","Redacao","Matematica","Humanas","Natureza"),width = "100%"),
                          selectInput("var","Escolha a variável",choices = c("Dependencia_adm",
                                                                               "Localizacao",
                                                                               "porte_da_escola",
                                                                               "indicador_de_permanencia_na_escola",
                                                                               "indicador_nivel_socioeconomico",
                                                                               "faixa_indicador_de_formacao_docente"),width = "100%"),
                          plotlyOutput("plot1"),width ="100%"),
                       #-----------------------------------Dispersão-------------------
                          tabPanel("Dispersão",
                                selectInput("disc1","Escolha a disciplina",choices = c("Linguagem","Redacao","Matematica","Humanas","Natureza"),width = "100%"),
                                selectInput("var1","Escolha a variavel",choices = c("Dependencia_adm",
                                                                                   "Localizacao",
                                                                                   "porte_da_escola",
                                                                                   "indicador_de_permanencia_na_escola",
                                                                                   "indicador_nivel_socioeconomico",
                                                                                   "faixa_indicador_de_formacao_docente"),width = "100%"),
                                selectInput("var2","Escolha o eixo x",choices = c("Numero_de_alunos",
                                                                                  "numero_de_participantes_no_enem",
                                                                                  "taxa_de_participacao",
                                                                                  "indicador_de_formacao_docente",
                                                                                  "taxa_de_aprovacao","taxa_de_reprovacao"
                                                                                  ,"taxa_de_abandono"),width = "100%"),
                                verbatimTextOutput("correla"),
                                plotlyOutput("plot2"),width ="100%" )
                        
                               
                      ))
                    ),
                    tabPanel("Dados Enem",dataTableOutput("dados_enem"))
  )
  )
)