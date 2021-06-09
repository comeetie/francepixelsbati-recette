library(dbplyr)
library(DBI)
library(RPostgres)
library(sf)
library(dplyr)
library(readr)
st_drivers() %>% 
  filter(grepl("Post", name))

con <- dbConnect(
  RPostgres::Postgres(),
  host = "localhost",
  dbname = "bdtopo_bati",
  port = 5432,
  user = "comeetie",
  password = "haPPiOOon"
)

dirs = list.dirs("data",recursive = FALSE)
for (d in dirs[-c(1,2)]){
  dsplit = strsplit(d,"_")
  dep = dsplit[[1]][6]
  print(dep)
  path = paste0(d,"/BDTOPO/1_DONNEES_LIVRAISON_2021-04-00014/BDT_3-0_GPKG_LAMB93_",dep,"-ED2021-03-15/bati_carreaux.csv")
  data = read_csv(path)
  st_write(data, dsn = con, layer = "grid", append = TRUE)
}
