# install.packages("renv")

renv::init()
options(Ncpus = 2)
renv::install(c("jsonlite", "duckdb", "duckplyr"))