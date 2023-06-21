#Web scrape a Global Bike-Sharing Systems Wiki Page


# Check if need to install rvest` library
require("rvest")

library(rvest)
url <- "https://en.wikipedia.org/wiki/List_of_bicycle-sharing_systems"
# Get the root HTML node by calling the `read_html()` method with URL
root_node <- read_html(url)
root_node

table_nodes <- html_nodes(root_node, "table")
table_nodes

# Convert the bike-sharing system table into a dataframe
df <- html_table(table_nodes[[3]], fill = TRUE)
head(df)

# Summarize the dataframe
summary(df)

# Export the dataframe into a csv file
write.csv(df, "raw_bike_sharing_systems.csv")

# For Watson Studio
wd <- getwd()
file_path <- paste(wd, sep="", "/raw_bike_sharing_systems.csv")
print(file_path)
file.exists(file_path)
