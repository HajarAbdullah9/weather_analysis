#Data Collection with OpenWeather API.ipynb

#OpenWeather APIs Calls

# Check if need to install rvest` library
require("httr")

library(httr)


  current_weather_url <- 'https://api.openweathermap.org/data/2.5/weather'
  # need to be replaced by your real API key
  your_api_key <- "0999031957056343b00afa47c6adec5a"
  # Input `q` is the city name
  # Input `appid` is your API KEY, 
  # Input `units` are preferred units such as Metric or Imperial
  query <- list(q = 'Washington, D.C.', appid = your_api_key, units="metric")
  response <- GET(current_weather_url, query=query)
  
  http_type(response)
  json_result <- content(response, as="parsed")
  class(json_result)
  length(json_result$weather)
  json_result
  # Create some empty vectors to hold data temporarily
  weather <- c()
  visibility <- c()
  temp <- c()
  temp_min <- c()
  temp_max <- c()
  pressure <- c()
  humidity <- c()
  wind_speed <- c()
  wind_deg <- c()
  
  
  
  # $weather is also a list with one element, its $main element indicates the weather status such as clear or rain
  weather <- c(weather, json_result$weather[[1]]$main)
  #json_result2$weather[[1]]$main,json_result3$weather[[1]]$main,jason_result4$weather[[1]]$main)
  # Get Visibility
  visibility <- c(visibility, json_result$visibility)
  #json_result2$visibility, json_result3$visibility, jason_result4$visibility)
  # Get current temperature 
  temp <- c(temp, json_result$main$temp) 
  #json_result3$main$temp, jason_result4$main$temp)
  # Get min temperature 
  temp_min <- c(temp_min, json_result$main$temp_min)
  #json_result2$main$temp_min, json_result3$main$temp_min, jason_result4$main$temp_min)
  # Get max temperature 
  temp_max <- c(temp_max, json_result$main$temp_max)
                #json_result2$main$temp_max, json_result3$main$temp_max, jason_result4$main$temp_max)
  # Get pressure
  pressure <- c(pressure, json_result$main$pressure)
  #json_result2$main$pressure, json_result3$main$pressure, jason_result4$main$pressure)
  # Get humidity
  humidity <- c(humidity, json_result$main$humidity)
  #json_result2$main$humidity, json_result3$main$humidity, jason_result4$main$humidity)
  # Get wind speed
  wind_speed <- c(wind_speed, json_result$wind$speed)
  #json_result2$wind$speed, json_result3$wind$speed, jason_result4$wind$speed)
  # Get wind direction
  wind_deg <- c(wind_deg, json_result$wind$deg)
  #json_result2$wind$deg,  json_result3$wind$deg,  jason_result4$wind$deg)
  # Combine all vectors
  weather_data_frame <- data.frame(weather=weather, 
                                   visibility=visibility, 
                                   temp=temp, 
                                   temp_min=temp_min, 
                                   temp_max=temp_max, 
                                   pressure=pressure, 
                                   humidity=humidity, 
                                   wind_speed=wind_speed, 
                                   wind_deg=wind_deg)
  # Check the generated data frame
  print(weather_data_frame)
  
  # Create some empty vectors to hold data temporarily
  # City name column
  city <- c()
  # Weather column, rainy or cloudy, etc
  weather <- c()
  # Sky visibility column
  visibility <- c()
  # Current temperature column
  temp <- c()
  # Max temperature column
  temp_min <- c()
  # Min temperature column
  temp_max <- c()
  # Pressure column
  pressure <- c()
  # Humidity column
  humidity <- c()
  # Wind speed column
  wind_speed <- c()
  # Wind direction column
  wind_deg <- c()
  # Forecast timestamp
  
  forecast_datetime <- c()
  # Season column
  # Note that for season, you can hard code a season value from levels Spring, Summer, Autumn, and Winter based on your current month.
  season <- c()
  #----
  cities = c ('Seoul',"Washington, D.C.", "Paris", "Suzhou")
  
  get_weather_forcasting<- function(city_name){
    df<-data.frame()
    for (city_name in city_name){
      forecast_url <- 'https://api.openweathermap.org/data/2.5/forecast'
      forecast_quer <- list(q = city_name, appid = '0999031957056343b00afa47c6adec5a', units= 'metric')
      response<- GET(forecast_url,query= forecast_quer)
      jsonresult<- content(response, as='parsed', )
      results<-jsonresult$list
      
    
      for(result in results){
        city <- c(city, city_name)
        weather <- c(weather, results$weather[[1]]$main)
        visibility <- c(visibility,results$visibility)
        temp <- c(temp,results$main$temp)
        temp_min <- c(temp_min,results$main$temp_min)
        temp_max <- c(temp_max,results$main$temp_max)
        pressure <- c(pressure,results$main$pressure)
        humidity <- c(humidity,results$main$humidity)
        wind_speed <- c(wind_speed,results$wind$speed)
        wind_deg <- c(wind_deg,results$wind$deg)
        forecast_datetime <- c(forecast_datetime, result$dt_txt)
        season <- c(season, "Spring")
       
      }
          df <- c(
                                       city=city,
                                       weather=weather, 
                                       visibility=visibility, 
                                       temp=temp, 
                                       temp_min=temp_min, 
                                       temp_max=temp_max, 
                                       pressure=pressure, 
                                       humidity=humidity, 
                                       wind_speed=wind_speed, 
                                       wind_deg=wind_deg,
                                       forecast_datetime= forecast_datetime,
                                       season= season)
    }
    
    return(df)
    
    }
  df
  cities = c ('Seoul',"Washington, D.C.", "Paris", "Suzhou")
  get_weather_forcasting(cities)
  cities_weather_df<-get_weather_forcasting(cities)
  forecasting_csv<- write.csv(cities_weather_df,'cities_weather_df',row.names = FALSE)
  
