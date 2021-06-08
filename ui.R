library(DT)
library(shinydashboard)


shinyUI(dashboardPage(skin = "red",
   dashboardHeader(title = "Netflix Movies & TV Shows EDA"),
   dashboardSidebar(
     sidebarUserPanel("Netflix Content Analysis",
                      img("https://www.google.com/imgres?imgurl=https%3A%2F%2Fget.pxhere.com%2Fphoto%2Fproduct-text-orange-font-technology-electronic-device-room-houseplant-brand-plant-electronic-instrument-logo-1617297.jpg&imgrefurl=https%3A%2F%2Fpxhere.com%2Fen%2Fphoto%2F1617297&tbnid=proW3RI8SADrWM&vet=12ahUKEwjRueOM_IPxAhXJV98KHXUkA8EQMygCegQIARBD..i&docid=mkqQjRt0Lt0-bM&w=5133&h=3422&q=netflix%20free%20stock%20images&hl=en&ved=2ahUKEwjRueOM_IPxAhXJV98KHXUkA8EQMygCegQIARBD")),
     sidebarMenu(
       menuItem("Background", tabName = "background", icon = icon("laptop")),
       menuItem("Overivew of Content", tabName = "overview", icon = icon("chart-line")),
       menuItem("Based on Country", tabName = "country", icon = icon("chart-bar")),
       menuItem("Based on Duration", tabName = "duration", icon = icon("chart-bar")),
       menuItem("Rating/Cast Recurrence", tabName = "rating", icon = icon("chart-bar")),
       menuItem("Final Remarks", tabName = "remark", icon = icon("key"))
     )
   ),
   dashboardBody(
     tabItems(
       tabItem(tabName = "background",
               fluidPage(
               h2("At a Glance"),
               fluidRow(
                 infoBoxOutput("totalcontent"),
                 infoBoxOutput("totalmovie"),
                 infoBoxOutput("totaltv")
               ),
               fluidRow(
                 box(width = 6, background = "red",
                   h2("Are You Still Watching?"),
                   hr(),
                   h4("For my shiny project, I decided to analyze a data set of Netflix Movie and TV Show Titles from late 2000s to present day. With 12 columns, stacked with 7,787 rows of data, I was able to extract a sizable amount of valuable information portrayed in this shiny app. With this information, I was able to analyze and create visual representation of common trends that have taken place over the course of the lifespan of Netflix.  This analysis covers title count, genre, duration, ratings, casting recurrence and more."),
                   hr(),
                   h2("Why Netflix?"),
                   h4("Netflix is one of the biggest video streaming services on the planet. In 2019, they announced that they signed on 135 million paid customers worldwide. With its start as a DVD rental platform, Netflix has risen to make a huge name for itself. A huge factor to their success is the underlying use of Big Data. By gathering information from practically every customer interaction (age, gender, location, taste in media, etc.), they’re able to get front row seats of the minds of their viewers and infer what they might like to watch next before they even finish a movie or show."),
                   hr(),
                   
                   
                 ),
                  imageOutput("picture")
                    # img(src = "./netflix_pic1.png", width = 600, height = 500
                 )
          )
          ),
       tabItem(tabName = "overview",
               fluidPage(
               h2("Title Count"),
               fluidRow(
                 box(width = 6, background = "black",
                   h4("We can see a huge gap here between TV Shows and Movies on Netflix."),
                   hr(),
                   plotOutput("titlecount")),
               br(),
                 box(width = 6, background = "red",
                   h4("There's a fall off of Movies in the years following 2016."),
                   hr(),
                   plotOutput("timeseries")),
               br(),
               box(width = 6, background = "red",
                   h4("Cummulatively we can see that movie titles have dominated, but can TV shows take over?"),
                   hr(),
                   plotOutput("cummtimeseries")),
               br(),
               box(width = 6, background = "black",
                   plotlyOutput("contentpermonth")),
               hr(),
               box(width = 6, background = "red",
                   plotlyOutput("releasebymonth")),
               br(),
               box(width = 6, background = "black",
               h4("We can see here that Movie Titles dominate over TV Show Titles, and that makes sense here. When Netflix first began as a streaming service, they focused mainly on movie distribution. It wasn’t until after 2015 that you see a real spike in TV Shows (In 2013, Netflix released its first Netflix Original Series with House of Cards. On another note, February saw the least amount of title additions, where as October saw the most."),
               br()
               ))
               
               )
     ),
     tabItem(tabName = "country",
             fluidPage(
                h2("Country Based Analysis"),
                fluidRow(
                   box(width = 6, background = "red",
                       plotOutput("titlecountbycountry")),
                   hr(),
                   box(width = 6, background = "black",
                      plotOutput("genredist")),
                   hr(),
                   h4("Insert observations here.")
                       )
                   )
                   
                ),
     tabItem(tabName = "duration",
             fluidPage(
                h2("Duration Based Analysis"),
                fluidRow(
                   box(width = 6,
                      plotlyOutput("durationboxplot")),
                   br(),
                   box(width = 6,
                       plotlyOutput("durationchange")),
                   br(),
                   h4('Insert observation here.')
                   )
                )
             ),
     tabItem(tabName = "rating",
             fluidPage(
                h2("Rating & Cast Recurrence"),
                fluidRow(
                   box(width = 6,
                       plotOutput("rating")),
                   br(),
                   box(width = 6,
                       plotlyOutput("castrecurrence")),
                   br(),
                   h4("Insert observations here.")
                   )
                )
             ),
     tabItem(tabName = "remark",
             fluidPage(
                h2("Final Comments"),
                fluidRow(
                   box(width = 4,
                       h3("Title WordCloud"),
                       br(),
                       plotOutput("titlecloud")),
                   br(),
                   box(width = 6,
                       h3("Conclusions"),
                       hr(),
                       h2("Write conclusion here."))
                )
             ))
             ))
             ))
     