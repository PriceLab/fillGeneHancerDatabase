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

all.tissues <- dbGetQuery(db, "select distinct tissue from tissues")$tissue
length(all.tissues)  # 310


query <- paste0("select * from associations AS a, tissues AS t, elements as e ",
                "where a.symbol='FOXO6' ",
                "AND t.tissue in ('placenta','Placenta') ",
                "AND a.ghid=t.ghid ",
                "AND e.ghid=a.ghid")

query <- paste0("select a.symbol as gene, ",
                "e.chr as chrom, ",
                "e.element_start as start, ",
                "e.element_end as end, ",
                "a.eqtl_score as eqtl, ",
                "a.chic_score as HiC, ",
                "a.erna_score as erna, ",
                "a.expression_score as coexpression, ",
                "a.distance_score as distanceScore, ",
                "a.tss_proximity as tssProximity, ",
                "a.combined_score as combinedScore, ",
                "a.is_elite as elite, ",
                "t.source as source, ",
                "t.tissue as tissue, ",
                "e.type as type, ",
                "a.ghid as ghid ",
                "from associations AS a, ",
                "tissues AS t, elements as e ",
                "where a.symbol='FOXO6' ",
                "AND t.tissue in ('placenta','Placenta') ",
                "AND a.ghid=t.ghid ",
                "AND e.ghid=a.ghid")

system.time(tbl <- dbGetQuery(db, query))
tbl$sig <- with(tbl, sprintf("%s:%d-%d", chrom, start, end))
which(duplicated(tbl$sig))
tbl <- tbl[-which(duplicated(tbl$sig)),]
subset(tbl, !(is.nan(eqtl) & is.nan(hic)))

#--------------------------------------------------------------------------------
#  21 regions.  alison asserts that DLX3 regulates FOXO6.
#  it is a weak test, only for plausibility: do we find an unusual number of
#  binding sites for DLX3 in these regions?
#--------------------------------------------------------------------------------
library(MotifDb)
library(trena)
pwm <- as.list(query(MotifDb, c("DLX3", "sapiens", "hocomoco")))
mm <- MotifMatcher("hg38", pfms=as.list(query(MotifDb, c("DLX3", "sapiens", "hocomoco"))))
tbl.dlx3 <- findMatchesByChromosomalRegion(mm, tbl[, c("chrom", "start", "end")], 85)

tbl.full.region <- data.frame(chrom="chr1", start=40908542, end=41437415, stringsAsFactors=FALSE)

tbl.dlx3.all <- findMatchesByChromosomalRegion(mm, tbl.full.region, 85)

#--------------------------------------------------------------------------------
#
#--------------------------------------------------------------------------------
library(igvR)
igv <- igvR()
setGenome(igv, "hg38")
showGenomicRegion(igv, "FOXO6")

shoulder <- 1000
full.region <- with(tbl, sprintf("%s:%d-%d", chrom[1], min(start)-shoulder, max(end)+shoulder))
showGenomicRegion(igv, full.region)
track <- DataFrameQuantitativeTrack("GH", tbl[, c("chrom", "start", "end", "combinedscore")], autoscale=FALSE, min=0, max=50)
displayTrack(igv, track)


track <- DataFrameQuantitativeTrack("DLX3", tbl.dlx3[, c("chrom", "motifStart", "motifEnd", "motifRelativeScore")],
                                    color="darkGreen", autoscale=TRUE)
displayTrack(igv, track)

track <- DataFrameQuantitativeTrack("DLX3-all", tbl.dlx3.all[, c("chrom", "motifStart", "motifEnd", "motifRelativeScore")],
                                    color="darkRed", autoscale=TRUE)
displayTrack(igv, track)

