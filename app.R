#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#




## leases2merge <- read_csv(here("data/leases2merge-2021-09.csv"))
library(readr)
fakeowners <- read_csv("fakeowners.csv")

library(rsconnect)


# rsconnect::deployApp('E:/shiny/shiny-Tallgrass/app.R')

library(shiny)


library(ggplot2)  # for the diamonds dataset

ui <- fluidPage(
  title = "Examples of DataTables",
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        'input.dataset === "fakeowners"',
        checkboxGroupInput("show_vars", "Columns in fakes to show:",
                           names(fakeowners), selected = names(fakeowners))
      ),
      conditionalPanel(
        'input.dataset === "mtcars"',
        helpText("Click the column header to sort a column.")
      ),
      conditionalPanel(
        'input.dataset === "iris"',
        helpText("Display 5 records by default.")
      )
    ),
    mainPanel(
      tabsetPanel(
        id = 'dataset',
        tabPanel("fakeowners", DT::dataTableOutput("mytable1")),
        tabPanel("mtcars", DT::dataTableOutput("mytable2")),
        tabPanel("iris", DT::dataTableOutput("mytable3"))
      )
    )
  )
)



server <- function(input, output) {
  
  # choose columns to display
  leases2 = fakeowners[sample(nrow(fakeowners), 26), ]
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(leases2[, input$show_vars, drop = FALSE])
  })
  
  # sorted columns are colored now because CSS are attached to them
  output$mytable2 <- DT::renderDataTable({
    DT::datatable(mtcars, options = list(orderClasses = TRUE))
  })
  
  # customize the length drop-down menu; display 5 rows per page by default
  output$mytable3 <- DT::renderDataTable({
    DT::datatable(iris, options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
  })
  
}

shinyApp(ui, server)
