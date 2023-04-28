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
data <- dbGetQuery(con, "SELECT * FROM cla_tntlab.datascience_8960_table;")
write_csv(data, "../data/week13.csv")
week13_tbl <- read_csv("../data/week13.csv")
