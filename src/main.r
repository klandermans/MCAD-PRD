library(jsonlite)
library(duckdb)
library(duckplyr)

# Laad JSON zonder nested objects
mcad_data <- fromJSON("data/data.json", flatten = TRUE)

# Maak een incidententable van de titel, methode, jaar en positie
incidents_table <- mcad_data %>%
  select(referenceNumber, title, method, year, position.lat, position.lng)

# Maak een slachtoffertable van de identiteit, land, type en gebied
victims_table <- mcad_data %>%
  select(referenceNumber, identity, viccountry, type, area)

# Save tables naar DuckDB
con <- dbConnect(duckdb(), dbdir = "data/mcad.duckdb")
dbWriteTable(con, "incidents", incidents_table)
dbWriteTable(con, "victims", victims_table)
dbDisconnect(con)

# Lees tables uit DuckDB
con <- dbConnect(duckdb(), dbdir = "data/mcad.duckdb")
incidents_table <- dbReadTable(con, "incidents")
victims_table <- dbReadTable(con, "victims")
dbDisconnect(con)

# Print tables
print(incidents_table)
print(victims_table)

# Join tables op basis van referenceNumber
joined_table <- left_join(incidents_table, victims_table, by = "referenceNumber")

# Filter de joined table op rows ouder dan 2020
filtered_table <- joined_table %>%
  filter(year > 2020)

# Aggregeer de joined table voor incidenten per jaar
aggregated_table <- joined_table %>%
  group_by(year) %>%
  summarise(count = n())

# Sla tables op in DuckDB
con <- dbConnect(duckdb(), dbdir = "data/mcad.duckdb")
dbWriteTable(con, "joined", joined_table)
dbWriteTable(con, "filtered", filtered_table)
dbWriteTable(con, "aggregated", aggregated_table)
dbDisconnect(con)

# Print tables
print(joined_table)
print(filtered_table)
print(aggregated_table)


