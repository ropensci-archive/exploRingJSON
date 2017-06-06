## app.R ##
source("plot_json_graph.R")
library(shiny)
library(shinydashboard)
library(listviewer)
library(jsonlite)
library(httr)
library(dplyr)
library(tidyjson)
library(JSOmetaN)

ui <- dashboardPage(skin = "blue",
  dashboardHeader(title = "exploRing JSON"),
  dashboardSidebar(
    menuItem("Load JSON Data", tabName = "getdata", icon = icon("upload")),
    #fileInput('jsondata', 'Upload JSON fomatted file',
    #          accept=c('application/json',
    #                   'application/javascript',
    #                   '.json')),
    #textInput('jsonurl', "Or, paste URL of API query", value = "", width = NULL, placeholder = NULL),
    #submitButton(text = "Submit Query", icon = NULL, width = NULL),
    menuItem("listviewer", tabName = "listviewer", icon = icon("list-alt")),
    #menuItem("High-Level Summary", tabName = "level1", icon = icon("magic")),
    menuItem("Visualization", tabName = "plot", icon = icon("pie-chart"))
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "getdata",
              fileInput('jsondata', 'Upload JSON fomatted file',
                       accept=c('application/json',
                                'application/javascript',
                                '.json')),
              textInput('jsonurl', "Or, paste URL of API query", value = "", width = NULL, placeholder = NULL),
              submitButton(text = "Submit Query", icon = NULL, width = NULL)
              ),
      tabItem(tabName = "listviewer",
              jsoneditOutput( "jsed" )
      ),
      tabItem(tabName = "plot",
              plotOutput("jsonviz"))
      #tabItem(tabName = "level1",
      #        tableOutput("text1"))
      )
  )
)

server <- function(input, output, session) {

  filedata <- reactive({
    if (!is.null(input$jsondata)){
      infile <- input$jsondata
      file <- jsonlite::fromJSON(infile$datapath, simplifyDataFrame = T)
    } else if (!is.null(input$jsonurl)) {
      jsonurl <- input$jsonurl
      file <- content(GET(jsonurl))
    }

    if (is.null(file)) {
      # User has not uploaded a file yet
      return(NULL)
    }
    file
  })

  output$jsed <- renderJsonedit({
    jsonedit(
      filedata(),
      "change" = htmlwidgets::JS('function(){
                                  console.log( event.currentTarget.parentNode.editor.get() )
  }')
    )
  })
  # output$text1 <- renderText({
  #   filedata() %>% fetch
  # })

  output$jsonviz <- renderPlot({
    filedata() %>% toJSON %>% as.character %>% plot_json_graph(show.labels = FALSE, vertex.size = 2)
  })



}

shinyApp(ui, server)
