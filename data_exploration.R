

eppo_con <- dbConnect(SQLite(), dbname = "C:/Users/dafl/Desktop/EPPO DB/EPPO_DB.db")

con <- dbConnect(SQLite(), dbname = db_file)

eppo_data <- tbl(eppo_con, "EPPO") %>% collect()

eppo_tax <- tbl(eppo_con, "EPPO_GBIF_TAX") %>% collect()

dbDisconnect(con)


as_tibble(eppo_data)

as_tibble(eppo_tax)


eppo_tax <- rename(eppo_tax, fullname = original_sciname)


data <- left_join(eppo_data, eppo_tax, by="fullname", relationship = "many-to-many")


ABSICO <- data %>% filter(eppocode=="ABSICO")
