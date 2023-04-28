# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(keyring)
library(tidyverse)
library(RMariaDB)

# Data Import and Cleaning
# Just as before, this line of code connects to the database to bring in the datasheet we want. And again, the certificate and password information were not pushed to Github.
con <- dbConnect(RMariaDB::MariaDB(), 
                 user = "pries153",
                 password = key_get("latis-mysql", "pries153"),
                 host = "mysql-prod5.oit.umn.edu",
                 port = 3306,
                 ssl.ca = "../mysql_hotel_umn_20220728_interm.cer")

# Analysis
# Display the total number of managers.
# With COUNT, we add up each row in the dataset to produce the total number of managers.
dbGetQuery(con, "SELECT COUNT(*)
           FROM cla_tntlab.datascience_8960_table;")

# Display the total number of unique managers (i.e., unique by id number).
# This is a very similar procedure, but this time we add DISTINCT to only include unique employee_id character values.
dbGetQuery(con, "SELECT COUNT(DISTINCT employee_id)
           FROM cla_tntlab.datascience_8960_table;")

# Display a summary of the number of managers split by location, but only include those who were not originally hired as managers.
# By COUNTing employee_id, we can see how many employees correspond to each city, after removing employees hired as managers.
dbGetQuery(con, "SELECT COUNT(employee_id), city
           FROM cla_tntlab.datascience_8960_table
           WHERE manager_hire = 'N'
           GROUP BY city;")

# Display the average and standard deviation of number of years of employment split by performance level (bottom, middle, and top).
# The numbers slightly differed between dplyr and SQL procedures, which may be due to rounding differences.
dbGetQuery(con, "SELECT performance_group, AVG(yrs_employed), STDDEV(yrs_employed)
           FROM cla_tntlab.datascience_8960_table
           GROUP BY performance_group;")

# Display the location and ID numbers of the top 3 managers from each location, in alphabetical order by location and then descending order of test score. If there are ties, include everyone reaching rank 3.
# I used this help page (https://learnsql.com/cookbook/how-to-select-the-first-row-in-each-group-by-group/) to structure this line of code. First we number our rows to later choose the top 3 managers per location. We then rank managers in terms of their location and test score. Then we choose the three variables we desire and ask SQL to report only three managers per managers per region with the highest test score. If ties occur, multiple managers are included.
dbGetQuery(con, "WITH added_row_number AS (
           SELECT *,
           DENSE_RANK() OVER(PARTITION BY city ORDER BY test_score DESC) AS ranking
           FROM cla_tntlab.datascience_8960_table)
           SELECT city, employee_id, test_score
           FROM added_row_number
           WHERE ranking <= 3;")
