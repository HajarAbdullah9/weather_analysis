#Data Wrangling with dplyr.ipynb

# Check if you need to install the `tidyverse` library
require("tidyverse")
library(tidyverse)



bike_sharing_df <- read_csv("raw_seoul_bike_sharing.csv")

summary(bike_sharing_df)
dim(bike_sharing_df)
#TASK: Detect and handle missing values


# Drop rows with `RENTED_BIKE_COUNT` column == NA
bike_sharing_df <- bike_sharing_df %>% drop_na(RENTED_BIKE_COUNT)

# Print the dataset dimension again after those rows are dropped
dim(bike_sharing_df)

bike_sharing_df %>% filter(is.na(TEMPERATURE))
# Calculate the summer average temperature
#summeravg <- mean(bike_sharing_df$TEMPERATURE, na.rm = TRUE)
summeravg <- subset(bike_sharing_df, 
                    SEASONS == "Summer")
summeravg <- mean(summeravg$TEMPERATURE, na.rm = TRUE)
summeravg

# Impute missing values for TEMPERATURE column with summer average temperature
bike_sharing_df <- bike_sharing_df %>% replace_na(list(TEMPERATURE = summeravg))


# Print the summary of the dataset again to make sure no missing values in all columns
summary(bike_sharing_df)


# Save the dataset as `seoul_bike_sharing.csv`
write.csv(bike_sharing_df, "seoul_bike_sharing.csv")

#TASK: Create indicator (dummy) variables for categorical variables


# Using mutate() function to convert HOUR column into character type
bike_sharing_df <- bike_sharing_df %>% mutate(HOUR = as.character(HOUR))
glimpse(bike_sharing_df$HOUR)

# Convert SEASONS, HOLIDAY, FUNCTIONING_DAY, and HOUR columns into indicator columns.
df1 <- bike_sharing_df

df1 <- bike_sharing_df %>% mutate(dummy = 1) %>% 
spread(key = c(SEASONS), value = dummy, fill = 0)

df2 <- df1 %>% mutate(dummy = 1) %>% 
spread(key = c(HOLIDAY), value = dummy, fill = 0)

df3 <- df2 %>% mutate(dummy = 1) %>% 
spread(key = c(HOUR), value = dummy, fill = 0)


# Print the dataset summary again to make sure the indicator columns are created properly
summary(df3)


# Save the dataset as `seoul_bike_sharing_converted.csv`
write_csv(df3, "seoul_bike_sharing_converted.csv")

#TASK: Normalize data


# Use the `mutate()` function to apply min-max normalization on columns 
# `RENTED_BIKE_COUNT`, `TEMPERATURE`, `HUMIDITY`, `WIND_SPEED`, `VISIBILITY`, `DEW_POINT_TEMPERATURE`, `SOLAR_RADIATION`, `RAINFALL`, `SNOWFALL`

normalize <- function(x, na.rm = TRUE) {
    return((x-min(x)) / (max(x)-min(x)))
}

n1 <- normalize(df3
TEMPERATURE)
n3 <- normalize(df3
WIND_SPEED)
n5 <- normalize(df3
DEW_POINT_TEMPERATURE)
n7 <- normalize(df3
RAINFALL)
n9 <- normalize(df3$SNOWFALL)


df4 <- df3 %>% mutate(RENTED_BIKE_COUNT = n1) %>% 
mutate(TEMPERATURE = n2) %>% 
mutate(HUMIDITY = n3) %>% 
mutate(WIND_SPEED = n4) %>% 
mutate(VISIBILITY = n5) %>% 
mutate(DEW_POINT_TEMPERATURE = n6) %>% 
mutate(SOLAR_RADIATION = n7) %>% 
mutate(RAINFALL = n8) %>% 
mutate(SNOWFALL = n9)

head(df4)


# Print the summary of the dataset again to make sure the numeric columns range between 0 and 1
summary(df4)



# Save the dataset as `seoul_bike_sharing_converted_normalized.csv`
write_csv(df4, "seoul_bike_sharing_converted_normalized.csv")

#Standardize the column names again for the new datasets


# Dataset list
dataset_list <- c('seoul_bike_sharing.csv', 'seoul_bike_sharing_converted.csv', 'seoul_bike_sharing_converted_normalized.csv')

for (dataset_name in dataset_list){
    # Read dataset
    dataset <- read_csv(dataset_name)
    # Standardized its columns:
    # Convert all columns names to uppercase
    names(dataset) <- toupper(names(dataset))
    # Replace any white space separators by underscore, using str_replace_all function
    names(dataset) <- str_replace_all(names(dataset), " ", "_")
    # Save the dataset back
    write.csv(dataset, dataset_name, row.names=FALSE)
}

