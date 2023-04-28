# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(keyring)
library(tidyverse)
library(RMariaDB)

# Data Import and Cleaning
con <- dbConnect(RMariaDB::MariaDB(), 
                 user = "pries153",
                 password = key_get("latis-mysql", "pries153"),
                 host = "mysql-prod5.oit.umn.edu",
                 port = 3306,
                 ssl.ca = "../mysql_hotel_umn_20220728_interm.cer")

# Analysis
# Display the total number of managers.
dbGetQuery(con, "SELECT COUNT(*)
           FROM cla_tntlab.datascience_8960_table;")

# Display the total number of unique managers (i.e., unique by id number).
dbGetQuery(con, "SELECT COUNT(DISTINCT employee_id)
           FROM cla_tntlab.datascience_8960_table;")

# Display a summary of the number of managers split by location, but only include those who were not originally hired as managers.


# Display the average and standard deviation of number of years of employment split by performance level (bottom, middle, and top).


# Display the location and ID numbers of the top 3 managers from each location, in alphabetical order by location and then descending order of test score. If there are ties, include everyone reaching rank 3.
