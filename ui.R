library("shiny")
library("ggplot2")
library("dplyr")

# import r file from same folder
source("analysis.R")
source("server.R")

# extract region name
neigh_name <- census_2010 %>% select(1)
# extract race types
race <- census_joined %>% select(2) %>% group_by(race_type) %>% summarise()

# User interface
ui <- navbarPage("Explore Seattle Census Data in 2000 and 2010",
                 navbarMenu("Explore Race Statistics",
                    tabPanel("Explore by Regions",
                             sidebarLayout(
                               sidebarPanel(
                                 selectInput(
                                   inputId = "selected_region", label = "Region", choices = neigh_name)
                               ),
                               mainPanel(
                                 tabsetPanel(type = "tabs",
                                             tabPanel("Race Distribution each Year",
                                                      br(),
                                                      textOutput("bar_chart_text"),       
                                                      br(),
                                                      textOutput("bar_chart_intro_2000"),
                                                      plotlyOutput("bar_chart_2000"),
                                                      br(),
                                                      textOutput("bar_chart_intro_2010"),
                                                      plotlyOutput("bar_chart_2010")),
                                             tabPanel("Race Percentage Change",
                                                      br(),
                                                      textOutput("change_text"),
                                                      br(),
                                                      plotOutput("change_plot")))
                               )
                             )
                    ),
                    tabPanel("Explore by Race",
                             sidebarLayout(
                               sidebarPanel(
                                 selectInput(
                                   inputId = "selected_race", label = "Race", choices = race)
                               ),
                               mainPanel(
                                    textOutput("race_text"),       
                                    br(),
                                    textOutput("race_intro_2000"),
                                    plotOutput("race_2000"),
                                    br(),
                                    textOutput("race_intro_2010"),
                                    plotOutput("race_2010"))
                             )
                    )
                 ),
                 tabPanel("Race and Housing",
                          sidebarLayout(
                            sidebarPanel(
                              selectInput(inputId = "house_race", label = "Race", choices = race)
                              ),
                            mainPanel(
                              br(),
                              textOutput("house_text"),
                              br(),
                              plotOutput("house_plot")
                            )
                          )
                    ),
                 tabPanel("Source and Reflection",
                    p('Source of Data:'),
                    uiOutput("source"),
                    br(),
                    textOutput("Q"),
                    textOutput("A"),
                    textOutput("Reflection")),
                 tabPanel("About",
                          p("Author: Kun Qian"),
                          p("Date: March 10, 2019"),
                          uiOutput("linkedin"))
                 
)

shinyApp(ui = ui, server = server, options = list(height = 1080))
