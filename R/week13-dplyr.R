# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(keyring)
library(tidyverse)
library(RMariaDB)

# Data Import and Cleaning
# This line connects to the database we want (cla_tntlab) and then extracts the data table we want (datasceince_8960_table). It needs a certificate and password information that was not committed to github.
con <- dbConnect(RMariaDB::MariaDB(), 
                 user = "pries153",
                 password = key_get("latis-mysql", "pries153"),
                 host = "mysql-prod5.oit.umn.edu",
                 port = 3306,
                 ssl.ca = "../mysql_hotel_umn_20220728_interm.cer")
# This lines of code select the database we want and make it an R object. We make it an R object to then make it a csv file that is stored in the "data" folder. We then create a tibble based on that datafile for our future analyses.
data <- dbGetQuery(con, "SELECT * FROM cla_tntlab.datascience_8960_table;")
write_csv(data, "../data/week13.csv")
week13_tbl <- read_csv("../data/week13.csv")

# Analysis 
# Display the total number of managers.
# Because each manager constitutes a row in this dataset, we can calculate the number of managers by counting the number of rows.
nrow(week13_tbl)

# Display the total number of unique managers (i.e., unique by id number).
# The n_distinct function counts the number of unique entries in a column. It seems like each manager in this dataset is unique.
n_distinct(week13_tbl$employee_id)

# Display a summary of the number of managers split by location, but only include those who were not originally hired as managers.
# First we subset the data to only include managers not orignially hired as managers. Then we group our data by location to then count the number of subsetted managers in each location.
week13_tbl %>%
  filter(manager_hire == "N") %>%
  group_by(city) %>%
  count()

# Display the average and standard deviation of number of years of employment split by performance level (bottom, middle, and top).
# First we subset the data into three groups of performance. Then, in each group due to subsetting, we can calculate the mean and standard deviation of tenure.
week13_tbl %>%
  group_by(performance_group) %>%
  summarize(mean = mean(yrs_employed), sd = sd(yrs_employed))

# Display the location and ID numbers of the top 3 managers from each location, in alphabetical order by location and then descending order of test score. If there are ties, include everyone reaching rank 3.
# Order of operations is important here. First we group our data by location. Then we arrange each location and test score within each location. By doing so, we can organize our data in the desired format. We then select the only 3 relevant columns from the tibble. Then we display only the top 3 managers in each location. If ties exist, the "with_ties" argument includes them all.
week13_tbl %>%
  group_by(city) %>%
  arrange(city, desc(test_score)) %>%
  select(city, employee_id, test_score) %>%
  slice_max(order_by = test_score, n = 3, with_ties = TRUE)
