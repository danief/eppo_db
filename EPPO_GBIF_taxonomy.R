# EPPO DB - GBIF Taxonomic 
library(tidyverse)
library(DBI)
library(RSQLite)

# script to get gbif taxonomic ids for EPPO species in the EPPO database

eppo_con <- dbConnect(SQLite(), dbname = "C:/Users/dafl/Desktop/EPPO DB/EPPO_DB.db")

con <- dbConnect(SQLite(), dbname = db_file)

db_data <- tbl(eppo_con, "EPPO") %>% 
  collect()
  
db_data <-db_data %>% 
  filter(codelang=="la") %>%
select(fullname) %>%
  distinct()

db_data <- db_data %>% filter(!fullname=="null") %>% na.omit() 

db_data$fullname <- str_replace_all(db_data$fullname, "[[:punct:]]", "")

eppo_tax <- db_data$fullname %>%  
  taxize::get_gbifid_(method="backbone") %>% # match names to the GBIF backbone to get taxonkeys
  purrr::imap(~ .x %>% mutate(original_sciname = .y)) %>% # add original name back into data.frame
  bind_rows() 


as_tibble(eppo_tax)

# -----------------------------------------------------------------------------------------------------------------------------------------------

# write to db 
db_file <- "C:/Users/dafl/Desktop/EPPO DB/EPPO_DB.db"

con <- dbConnect(SQLite(), dbname = db_file)

dbWriteTable(con, "EPPO_GBIF_TAX", eppo_tax, append = TRUE)

# END --------------------------------------------------------------------------------------------------------------------------------------------