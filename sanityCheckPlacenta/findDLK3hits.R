tbl <- read.table("DLX3.csv", sep=",", as.is=TRUE, header=TRUE)
tbl[order(tbl$betaLasso, decreasing=TRUE),]

#   betaLasso  lassoPValue pearsonCoeff    rfScore  betaRidge spearmanCoeff betaSqrtLasso bindingSites targetGene rank
# 0.539423412 6.450000e-33    0.6118515 21.8946208 0.21373974     0.6005285   0.573259356           49       DLX4    1
# 0.367632716 9.770000e-20    0.4890180 13.1001828 0.19528470     0.4840215   0.459398963           92       RHOV    2
# 0.270409027 1.040000e-09    0.3393568 26.3379335 0.23466844     0.3312912   0.271150425          115      FOXO6    1
# 0.134980298 6.910000e-28    0.5703543  2.0994431 0.05192070     0.5455528   0.148493198           31     TFAP2C    1
# 0.109896071 1.480000e-15    0.4345519  1.6148238 0.06792087     0.4010347   0.113111774           31     MAP2K3    2
# 0.109461568 1.920000e-29    0.5812360  2.1539974 0.05760245     0.5571936   0.118323613          394       TLE3    4

# choose FOX06

library(RPostgreSQL)
db <- dbConnect(PostgreSQL(), user= "trena", password="trena", dbname="gh411", host="khaleesi")
dbListTables(db) # [1] "elements"     "associations" "tfbs"         "tissues"
dbGetQuery(db, "select * from tissues limit 4")
dbGetQuery(db, "select * from elements limit 4")
dbGetQuery(db, "select * from associations limit 4")
dbGetQuery(db, "select * from tfbs limit 4")

dbGetQuery(db, "select count(*) from tissues where tissue='placenta'")   # 31992
dbGetQuery(db, "select count(*) from tissues where tissue='brain'")      # 626
# tbl.tissue <- dbGetQuery(db, "select * from tissues limit 1000000")      # 626

tbl.foxo6 <- dbGetQuery(db, "select * from associations where symbol='FOXO6'")
dim(tbl.foxo6)
head(tbl.foxo6)

ghid <- tbl.foxo6$ghid
length(ghid)


ghid.list <- sprintf("('%s')", paste(ghid, collapse="','"))


query <- sprintf("select * from tissues where ghid in %s and tissue in ('placenta', 'Placenta')", ghid.list)
tbl.tissues <- dbGetQuery(db, query)
dim(tbl.tissues)

tbl.foxo6.tissues <- subset(tbl.foxo6, ghid %in% tbl.tissues$ghid)
tbl.foxo6.tissues

foxo6.placenta.ghid <- tbl.foxo6.tissues$ghid

ghid.query.term <- sprintf("('%s')", paste(foxo6.placenta.ghid, collapse="','"))

query <- sprintf("select * from elements where ghid in %s", ghid.query.term)
tbl.elements <- dbGetQuery(db, query)
dim(tbl.elements)
tbl.elements

tbl.fox06.loc.tissues.scores <- merge(tbl.elements, tbl.foxo6.tissues, by="ghid")
subset(tbl.foxo6, ghid %in% tbl.tissues$ghid)

# tfbs seem not to be so helpful at present
query <- sprintf("select * from tfbs where ghid in %s", ghid.query.term)
dbGetQuery(db, query)

# some joinery notes

# example join:   select * from db.gene AS dbg, genePheno as g where dbg.gene_id=g.id
# example join:  select t.a,t.b from t,s where t.a=s.a and t.b between 50000 and 50020;

# 3) select * from motif_best as mb, tfs where mb.Motif_ID='M1903_1.02' and mb.TF_ID = tfs.TF_ID;
# select mb.Motif_ID, tfs.TF_ID, Species from motif_best as mb, tfs as tfs where mb.Motif_ID='M1903_1.02' and mb.TF_ID = tfs.TF_ID;
# select mb.Motif_ID, MSource_ID, tfs.TF_ID, tfs.TF_Name, Species from motif_best as mb, tfs as tfs, motifs where mb.Motif_ID='M1903_1.02' and mb.Motif_ID=motifs.Motif_ID and  mb.TF_ID = tfs.TF_ID;
#
# select mb.Motif_ID, tf.TF_Name, Species, PMID
# from   motif_best as mb, tfs as tf, motifs as mo, motif_sources as ms
# where  mb.Motif_ID='M1903_1.02' and mb.Motif_ID=mo.Motif_ID and mb.TF_ID = tf.TF_ID and mo.MSource_ID=ms.MSource_ID;
#

# our goal, in english:
#  -  given a gene and tissues of interest
#  -  return a

query <- paste0("select * from associations AS a, tissues AS t, elements as e ",
                "where a.symbol='FOXO6' ",
                "AND t.tissue in ('placenta','Placenta') ",
                "AND a.ghid=t.ghid ",
                "AND e.ghid=a.ghid")

tbl <- dbGetQuery(db, query)


select * from db.gene AS dbg, genePheno as g where dbg.gene_id=g.id
