library(RPostgreSQL)
db <- dbConnect(PostgreSQL(), user= "trena", password="trena", dbname="gh411", host="khaleesi")
dbListTables(db) # [1] "experiments" "peaks"
dbGetQuery(db, "select * from tissues limit 4")
dbGetQuery(db, "select * from elements limit 4")
dbGetQuery(db, "select * from associations limit 4")
dbGetQuery(db, "select * from tfbs limit 4")

dbGetQuery(db, "select count(*) from tissues where tissue='placenta'")   # 31992
dbGetQuery(db, "select count(*) from tissues where tissue='brain'")      # 626
tbl.tissue <- dbGetQuery(db, "select * from tissues limit 1000000")      # 626
