library(DT)
library(shiny)
library(tidyverse)
library(dplyr)
library(lubridate)
library(naniar)
library(plotly)
library(reshape2)
library(ggrepel)
library(tokenizers)
library(wordcloud)

shinyServer(function(input, output){
  
  # Background Tab
  
  output$totalcontent <- renderInfoBox({
    totalcontent = length(df$show_id)
    totalcontentstate = infoBox("Total # of Content", totalcontent, icon = icon("video"), color = "red")
  })
  
  output$totalmovie <- renderInfoBox({
    totalmovie = length(df$type[df$type == "Movie"])
    totalmoviestate = infoBox("Total # of Movies", totalmovie, icon = icon("film"), color = "red")
  })
  
  output$totaltv <- renderInfoBox({
    totaltv = length(df$type[df$type == "TV Show"])
    totaltvstate = infoBox("Total # of TV Shows", totaltv, icon = icon("tv"), color = "red")
  })

  output$picture <- renderImage({
    img2 = "./netflix_pic1.png"
    list(src = img2, width = 600, height = 500)
  })
  
  # Overview Tab
  
  # Title Count Bar Graph
  output$titlecount <- renderPlot({
    df %>%
      ggplot(aes(type, fill=type)) +
      geom_bar() +
      scale_fill_brewer(palette = 'Pastel1') +
      coord_flip() +
      ggtitle("Title Count") +
    geom_text(stat = 'count', aes(label = ..count..), hjust= 1.5)
  })
  
  # Time Series scatter plot
  output$timeseries <- renderPlot({
    df %>%
      filter(release_year < '2021' & release_year > '2000') %>%
      group_by(release_year, type) %>%
      count() %>%
      ggplot(aes(x = release_year, y = n, fill = type)) +
      geom_line(aes(color = type)) +
      ggtitle("Titles Added Time Series")
  })
  
  # Cummulative Time Series scatter plot
  output$cummtimeseries <- renderPlot({
    df %>%
      group_by(release_year, type) %>%
      summarise(count = n()) %>% 
      ungroup() %>%
      group_by(type) %>%
      mutate(cummul_count = cumsum(count)) %>%
      ggplot(aes(x = release_year, y = cummul_count, color = type)) +
      geom_line(size = 2) +
      ggtitle('Cummulative Time Series')
  })
  
  
  # Category Tab
  
  # Content per Month Plotly graph
  output$contentpermonth <- renderPlotly({
    df %>%
      filter(release_year < '2021' & release_year > '2008') %>%
      group_by(month_added = floor_date(date_added, "month"), type) %>%
      summarise(added_today = n())
    wd <- reshape(data = data.frame(df_by_date), idvar = "month_added",
                  v.names = "added_today",
                  timevar = "type",
                  direction = "wide")
    names(wd)[2] <- "added_today_movie"
    names(wd)[3] <- "added_today_tv_show"
    wd$added_today_movie[is.na(wd$added_today_movie)] <- 0
    wd$added_today_tv_show[is.na(wd$added_today_tv_show)] <- 0
    wd <- na.omit(wd)
    
    Count_Per_Month <- plot_ly(wd, x = wd$month_added, y = ~added_today_movie,
                               type = 'bar', name = 'Movie',
                               marker= list(color = '#bd3939'))
    Count_Per_Month <- Count_Per_Month %>%
      add_trace(y = ~added_today_tv_show,
                name = 'TV Show',
                marker = list(color = '#399ba3'))
    Count_Per_Month <- Count_Per_Month %>% 
      layout(xaxis = list(categoryorder = "array",
                          categoryarray = wd$month_added, title = "Date"),
             yaxis = list(title = "Count"), barmode = "stack",
             title = "Amount of Content Added Per Month")
  })
  
  
  # Releases per Month
  output$releasebymonth <- renderPlotly({
    df %>% 
      mutate(month = format(as.Date(date_added), '%B')) %>%
      mutate(month = factor(month,
                            levels = c("January", "February", "March",
                                       "April", "May", "June", "July",
                                       "August", "September", "October",
                                       "November", "December", NA))) %>%
      group_by(month, type) %>%
      summarise(count = n()) %>%
      plot_ly(x = ~month,
              y = ~count,
              color = ~type,
              type = 'bar')
  })
  
  
  # Title Count by Country bar graph
  output$titlecountbycountry <- renderPlot({
    df %>% #prepare data
      separate_rows(country, sep = ", ") %>%
      mutate(country = fct_infreq(country)) %>%
      group_by(type) %>%
      ggplot(aes(country, fill = type)) +
      geom_histogram(stat = 'count') +
      coord_cartesian(xlim = c(1, 10))
    
    top_countries <- df %>% #consider top 10
      separate_rows(country, sep =", ") %>%
      group_by(country) %>%
      summarise(countt = n()) %>%
      remove_missing() %>%
      arrange(desc(countt))
    
    tc <- as.vector(top_countries$country[1:15])
    
    df %>%
      separate_rows(country, sep = ", ") %>%
      filter(country %in% tc) %>%
      mutate(country = factor(country, levels = tc)) %>%
      group_by(country, type) %>%
      summarise(count = n()) %>%
      ggplot(aes(x = country, y = count, fill = type)) +
      geom_bar(stat = 'identity') +
      coord_flip() +
      ggtitle("Title Count by Country")
  })
  
  # Genre Distribution graph
  output$genredist <- renderPlot({
    df$listed_in <- trimws(df$listed_in, which = c("left")) #prepare data
    
    df_genre <- df %>% 
      mutate(listed_in = strsplit(as.character(listed_in), ",")) %>% 
      unnest(listed_in) %>%
      group_by(listed_in) %>%
      add_tally() %>%
      select(listed_in,n,type) %>%
      unique() 
    
    df_genre_top <- df_genre[order(-df_genre$n),]
    
    
    df_genre_top <- df_genre_top[1:30,]
    
    ggplot(df_genre_top, aes(x=reorder(listed_in,n),y=n, fill=type)) +
      geom_col() + coord_flip()+
      theme(axis.title.x = element_blank(),
            axis.title.y = element_blank()) +
      labs(title="Global genres distribution")
  })
  
  # Duration Box Plot
  output$durationboxplot <- renderPlotly({
    movies_by_duration_country <- na.omit(df[df$type == "Movie", ]
                                          [, c("country", "duration")])
    s1 <- strsplit(movies_by_duration_country$country, split = ", ")
    movies_by_duration_country_full <- data.frame(duration = rep(movies_by_duration_country$duration,
                                                                 sapply(s1, length)), country = unlist(s1))
    movies_by_duration_country_full$duration <- as.numeric(gsub("min", "", movies_by_duration_country_full$duration))
    
    movies_by_duration_country_full_subset <- movies_by_duration_country_full[movies_by_duration_country_full$country %in% c("United States", "India", "United Kingdom",
                                                                                                                             "Canada", "France", "Japan", "Spain", 
                                                                                                                             "South Korea", "Mexico", "Australia", "Taiwan"), ]
    
    Duration_Box_Plot <- plot_ly(movies_by_duration_country_full_subset,
                                 y = ~duration, color = ~country, type = "box")
    Duration_Box_Plot <- Duration_Box_Plot %>% layout(xax9s = list(title = "Country"),
                                                      yaxis = list(title = "Duration(in min)"),
                                                      title = "Box-Plots Of Movie Duration In Top 11 Countries")
    
  })
  
  # Duration Change Scatter Plot
  output$durationchange <- renderPlotly({
    df %>%
      filter(type == "Movie" & release_year <= "2020" & release_year >= "2000") %>%
      mutate(movie_duration = substr(duration, 1, nchar(as.character(duration))-4)) %>%
      mutate(movie_duration = as.integer(movie_duration)) %>%
      group_by(release_year) %>%
      summarise(avg_run = mean(movie_duration)) %>%
      ungroup() %>%
      plot_ly(x = ~release_year,
              y = ~avg_run,
              mode = 'scatter',
              mode = 'lines + markers')
    Duration_Change_Plot <- Duration_Change_Plot %>% layout(title = 'Duration Change Over Time')
  })
  
  # Content by Rating
  output$rating <- renderPlot({ 
    df$rating <- case_when( #group similar ratings
      df$rating == "TV-14" ~ "PG-13",
      df$rating == "TV-MA" ~ "R",
      df$rating == "TV-PG" ~ "PG",
      df$rating == "TV-G" ~ "G",
      TRUE ~ as.character(df$rating)
    )
    df %>% 
      ggplot(aes(x = rating, fill = type)) +
      geom_bar() + 
      ggtitle('Content By Rating')
  })
  
  # Cast Recurrence 
  output$castrecurrence <- renderPlotly({
    df %>% 
      separate_rows(cast, sep = ', ') %>%
      group_by(cast) %>%
      count(sort = TRUE)
    top_a <- top_actors$cast[2:16]
    top_a
    
    Top_Cast <- df %>%
      separate_rows(cast, sep = ', ') %>%
      filter(cast %in% top_a) %>%
      mutate(cast = factor(cast, levels = top_a)) %>%
      group_by(cast, type) %>%
      count(sort = TRUE) %>%
      plot_ly(x = ~n, y = ~cast, type = 'bar',
              orientation = 'h', color = ~type,
              text = ~n, textposition = 'outside')
    
    Top_Cast <- Top_Cast %>% layout(title = 'Cast Recurrence')
  })
  
  # Title Cloud
  output$titlecloud <- renderPlot({
    title_vector <- paste(df[,3], collapse = " ")
    title_words <- tokenize_words(title_vector)
    title_table <- table(unlist(title_words))
    frequ = cbind.data.frame(words = names(title_table),
                             countt = as.integer(title_table))
    wc <- frequ %>%
      filter(nchar(as.character(words)) > 3) %>%
      arrange(desc(countt))
    cloud <- wordcloud(words = wc$words, freq = wc$countt, rot.per = 0.40, min.freq = 1,
                       max.words = 200, random.order = F, colors = brewer.pal(8, "Set1"))
  })
  
  
  
# end of shinyServer
})