
# Check whether you need to install the `tidyverse` library
require("tidyverse")
library(tidyverse)

# Download raw_bike_sharing_systems.csv
url <- "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/raw_bike_sharing_systems.csv"
download.file(url, destfile = "raw_bike_sharing_systems.csv")

# Download raw_cities_weather_forecast.csv
url <- "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/raw_cities_weather_forecast.csv"
download.file(url, destfile = "raw_cities_weather_forecast.csv")

# Download raw_worldcities.csv
url <- "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/raw_worldcities.csv"
download.file(url, destfile = "raw_worldcities.csv")

# Download raw_seoul_bike_sharing.csv
url <- "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/raw_seoul_bike_sharing.csv"
download.file(url, destfile = "raw_seoul_bike_sharing.csv")

dataset_list <- c('raw_bike_sharing_systems.csv', 'raw_seoul_bike_sharing.csv', 'raw_cities_weather_forecast.csv', 'raw_worldcities.csv')
for (dataset_name in dataset_list){
    # Read dataset
    dataset <- read_csv(dataset_name)
    # Standardized its columns:
    
    # Convert all column names to uppercase
    names(dataset) <- toupper(names(dataset))
    # Replace any white space separators by underscores, using the str_replace_all function
    names(dataset) <- str_replace_all(names(dataset), " ", "_")
    
    # Save the dataset 
    write.csv(dataset, dataset_name, row.names=FALSE)
}

for (dataset_name in dataset_list){
    # Print a summary for each data set to check whether the column names were correctly converted
    dataset <- read_csv(dataset_name)
    print(summary(dataset))
}


# First load the dataset
bike_sharing_df <- read_csv("raw_bike_sharing_systems.csv")


# Print its head
head(bike_sharing_df)

# Select the four columns
sub_bike_sharing_df <- bike_sharing_df %>% select(COUNTRY, CITY, SYSTEM, BICYCLES)
sub_bike_sharing_df %>% 
    summarize_all(class) %>%
    gather(variable, class)
 
# grepl searches a string for non-digital characters, and returns TRUE or FALSE
# if it finds any non-digital characters, then the bicyle column is not purely numeric
find_character <- function(strings) grepl("[^0-9]", strings)


sub_bike_sharing_df %>% 
    select(BICYCLES) %>% 
    filter(find_character(BICYCLES)) %>%
    slice(0:10)
    

# Define a 'reference link' character class, 
# `[A-z0-9]` means at least one character 
# `\[` and `\]` means the character is wrapped by [], such as for [12] or [abc]
ref_pattern <- "\[[A-z0-9]+\]"
find_reference_pattern <- function(strings) grepl(ref_pattern, strings)


# Check whether the COUNTRY column has any reference links
sub_bike_sharing_df %>% 
    select(COUNTRY) %>% 
    filter(find_reference_pattern(COUNTRY)) %>%
    slice(0:10)
    
  
# Check whether the CITY column has any reference links
sub_bike_sharing_df %>% 
    select(CITY) %>% 
    filter(find_reference_pattern(CITY)) %>%
    slice(0:10)
    

# Check whether the System column has any reference links
sub_bike_sharing_df %>% 
    select(SYSTEM) %>% 
    filter(find_reference_pattern(SYSTEM)) %>%
    slice(0:10)
     
     
#TASK: Remove undesired reference links using regular expressions


# remove reference link
remove_ref <- function(strings) {
    ref_pattern <- "\[[A-z0-9]+\]"
    # Replace all matched substrings with a white space using str_replace_all()
    # result <- 
    str_replace_all(string = strings, 
                              pattern = ref_pattern, 
                              replacement = "")
    # Trim the result if you want
    #str_trim((string = strings), side = "both")
    
    #return(result)
    
}

result %>% 
    select(CITY, SYSTEM, BICYCLES) %>% 
    filter(find_reference_pattern(CITY) | find_reference_pattern(SYSTEM) | find_reference_pattern(BICYCLES))
    
#TASK: Extract the numeric value using regular expressions


# Extract the first number
extract_num <- function(columns){
    # Define a digital pattern
    digital_pattern <- "[0-9]+"
    # Find the first match using str_extract
    str_extract(columns, digital_pattern)
    # Convert the result to numeric using the as.numeric() function
    as.numeric(columns)
}
# Use the mutate() function on the BICYCLES column
result2 <- result %>% mutate(BICYCLES=extract_num(BICYCLES))
result2
     


summary(result2$BICYCLES)


# Write dataset to `bike_sharing_systems.csv`
write.csv(result2, "bike_sharing_systems.csv")


