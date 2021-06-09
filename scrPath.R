

dirs = list.dirs("data",recursive = FALSE)
for (d in dirs[-1]){
  dsplit = strsplit(d,"_")
  dep = dsplit[[1]][6]
  path=paste0("../bdtopo",substring(d,2),"/BDTOPO/1_DONNEES_LIVRAISON_2021-04-00014/BDT_3-0_GPKG_LAMB93_",dep,"-ED2021-03-15/bati_poly.geojson ")
  cat(path)
}
