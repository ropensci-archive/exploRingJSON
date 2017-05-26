## app.R ##
library(shiny)
library(shinydashboard)
library(listviewer)
library(jsonlite)
library(httr)
library(dplyr)

summary.doc <- function(jsondata){
  # number of documents
  R <- nrow(jsondata)
  # number of 1st degree keys
  J <- ncol(jsondata)
  
  dummy_json <- matrix(NA,R,J)
  docs.class <- rep(NA, J)
  docs.size <- rep(NA, J)
  for (j in 1:J){
    docs.class[j] <- class(jsondata[,j])
    docs.size[j] <- length(jsondata[,j])
    for (i in 1:R){
      # maybe add dim to this? 
      # matrix -> something other than length below ?
      dummy_json[i,j] <- sum(is.na(jsondata[i,j]))/length(jsondata[i,j])
    }
  }
  
  docs.per.key <- R - colSums(dummy_json)
  
  # add type of each key, total depth
  tibble(Key = colnames(jsondata) , Doc.count = docs.per.key, 
         Class = docs.class, Obj.len = docs.size)
  
  # vector to pass to summary.key
  # invisible(jsondata)
}

ui <- dashboardPage(skin = "blue",
  dashboardHeader(title = "JSON Explorer"),
  dashboardSidebar(
    menuItem("Load JSON Data", tabName = "getdata", icon = icon("upload")),
    #fileInput('jsondata', 'Upload JSON fomatted file',
    #          accept=c('application/json', 
    #                   'application/javascript',
    #                   '.json')),
    #textInput('jsonurl', "Or, paste URL of API query", value = "", width = NULL, placeholder = NULL),
    #submitButton(text = "Submit Query", icon = NULL, width = NULL),
    menuItem("listviewer", tabName = "listviewer", icon = icon("list-alt")),
    menuItem("High-Level Summary", tabName = "level1", icon = icon("magic"))
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
      tabItem(tabName = "level1",
              tableOutput("table1"))
      )
  )
)

server <- function(input, output, session) {
  
  filedata <- reactive({
    if (!is.null(input$jsondata)){
      infile <- input$jsondata
      file <- read_json(infile$datapath)
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
  output$table1 <- renderDataTable({
    fromJSON(filedata()) %>% summary.doc()  
  })
    

  
}

shinyApp(ui, server)