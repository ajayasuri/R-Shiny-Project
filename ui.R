library(DT)
library(shinydashboard)


shinyUI(dashboardPage(skin = "red",
   dashboardHeader(title = "Netflix Movies & TV Shows EDA"),
   dashboardSidebar(
     sidebarUserPanel("Netflix Content Analysis",
                      img(src = "netflix_pic2.png", height = 30, width = 150)),
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
                   box(width = 6, background = "black",
                   h4("Without a doubt, US has the most content available on Netflix, whether it be movie or tv show. In regard to movies, India came in 2nd with and in television, UK is prevalent. Is interesting to note that, although US has the most amount of content, International movies and TV shows seem to be the dominant genre. For one thing, India’s primary movie industry, Bollywood, has a huge presence on Netflix. In fact, when we get to Cast Recurrence, we’ll see a notable trend as a result of this observation."),
                   br()
                       )
                   ))
                   
                ),
     tabItem(tabName = "duration",
             fluidPage(
                h2("Duration Based Analysis"),
                fluidRow(
                   box(width = 6, background = "black",
                      plotlyOutput("durationboxplot")),
                   br(),
                   box(width = 6, background = "red",
                       plotlyOutput("durationchange")),
                   br(),
                   box(width = 6, background = "red",
                   h4("It’s no surprise here that India has a higher duration average with their content primarily focused on movies and the culture of Bollywood movies ranging in the 2 to 3 hour mark. Likewise, a good portion of countries rank higher than US, in terms of duration. Interestingly enough, we can also see that the duration time has decreased over the years from a whopping 118 minutes down to 90.")
                   )
                ))
             ),
     tabItem(tabName = "rating",
             fluidPage(
                h2("Rating & Cast Recurrence"),
                fluidRow(
                   box(width = 6, background = "red",
                       plotOutput("rating")),
                   br(),
                   box(width = 6,background = "black",
                       plotlyOutput("castrecurrence")),
                   br(),
                   box(width = 6, background = "black",
                   h4("It surprised me to see that R rated titles dominated the platform as much as it did, considering the platform is open to all ages. Netflix does have parental control features that allow adults to keep children away from such content. This could be how Netflix was able to use big data to work around this.")
                   )
                ))
             ),
     tabItem(tabName = "remark",
             fluidPage(
                h2("Final Comments"),
                fluidRow(
                   box(width = 4, background = "red",
                       h3("Title WordCloud"),
                       br(),
                       plotOutput("titlecloud")),
                   br(),
                   box(width = 6, background = "black",
                       h3("Conclusions"),
                       hr(),
                       h4("There is numerous ways we can see how big data analysis plays a role in the way Netflix programs its user experience. By continuing to collect this data from users Netflix can continue to find success as it grows bigger each year. Netflix is a worldwide business. Knowing what to add to whichever region of the globe is crucial in the way Netflix continues to grow its user base.  With the continued updating of this data set, we can see the rising and falling trends that happen every so often as well as in what region and by doing so we can witness the awe that is the success of Netflix."))
                )
             ))
             ))
             ))
     