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
dbGetQuery(con, "SELECT COUNT(employee_id), city
           FROM cla_tntlab.datascience_8960_table
           WHERE manager_hire = 'N'
           GROUP BY city;")

# Display the average and standard deviation of number of years of employment split by performance level (bottom, middle, and top).
# The numbers slightly differed between procedures, which may be due to rounding differences.
dbGetQuery(con, "SELECT performance_group, AVG(yrs_employed), STDDEV(yrs_employed)
           FROM cla_tntlab.datascience_8960_table
           GROUP BY performance_group;")

# Display the location and ID numbers of the top 3 managers from each location, in alphabetical order by location and then descending order of test score. If there are ties, include everyone reaching rank 3.
dbGetQuery(con, "SELECT city, employee_id, test_score
           FROM cla_tntlab.datascience_8960_table
           ORDER BY city DESC, test_score DESC")
