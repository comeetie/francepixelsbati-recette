library(sf)
library(dplyr)
library(readr)
codes_murs = read_delim("codes_murs.csv",delim=";")

dirs = list.dirs("data",recursive = FALSE)
for (d in dirs[-1]){
  dsplit = strsplit(d,"_")
  dep = dsplit[[1]][6]
  print(dep)
  path=paste0(d,"/BDTOPO/1_DONNEES_LIVRAISON_2021-04-00014/BDT_3-0_GPKG_LAMB93_",dep,"-ED2021-03-15/")
  
  data = read_sf(paste0(path,"BDT_3-0_GPKG_LAMB93_",dep,"-ED2021-03-15.gpkg"),"batiment")
  
  data.date = data %>% 
    filter(!construction_legere,etat_de_l_objet=="En service") %>%
    mutate(datecrea = as.numeric(substr(date_d_apparition,1,4))) %>% 
    select(datecrea,materiaux_des_murs,materiaux_de_la_toiture,nombre_d_etages,usage_1,usage_2)
  
  
  write_sf(data.date %>% st_transform(4326) ,paste0(path,"bati_poly.geojson"),delete_layer = TRUE)
  
  data.date.point = data.date %>% st_centroid()
  
  write_sf(data.date.point  %>% st_transform(4326) ,paste0(path,"bati_ponctuel.geojson"),delete_layer = TRUE)
  
  
  # code toiture
  # http://piece-jointe-carto.developpement-durable.gouv.fr/NAT004/DTerNP/html3/annexes/desc_pb40_pevprincipale_dmatto.html
  codes_tuiles= c("1","01","10")
  codes_ardoises =c("2","02","20","22")
  # code mur
  # http://piece-jointe-carto.developpement-durable.gouv.fr/NAT004/DTerNP/html3/annexes/desc_pb40_pevprincipale_dmatgm.html
  codes_murs = read_delim("codes_murs.csv",delim=";")
  codes_pierres  = codes_murs %>% filter(nature=="PIERRE") %>% pull(code)
  codes_meulieres  = codes_murs %>% filter(nature=="MEULIERE") %>% pull(code)
  codes_betons  = codes_murs %>% filter(nature=="BETON") %>% pull(code)
  codes_briques  = codes_murs %>% filter(nature=="BRIQUES") %>% pull(code)
  codes_bois  = codes_murs %>% filter(nature=="BOIS") %>% pull(code)
  codes_agglo  = codes_murs %>% filter(nature=="AGGLOMERE") %>% pull(code)
  
  
  data.car = data.date.point %>%
    mutate(x=st_coordinates(geom)[,1],y=st_coordinates(geom)[,2],cid=paste(floor(x/200),ceiling(y/200),sep="_"),i=floor(x/200),j=ceiling(y/200)) %>%
    st_drop_geometry() %>% 
    group_by(cid) %>% 
    summarize(s_datecrea = sum(datecrea,na.rm=TRUE),
              n_datecrea = sum(!is.na(datecrea)),
              s_etage=sum(nombre_d_etages,na.rm=TRUE),
              n_etage = sum(!is.na(nombre_d_etages)),
              n_tuiles = sum(if_else(!is.na(materiaux_de_la_toiture) & materiaux_de_la_toiture %in% codes_tuiles, 1,0)),
              n_ardoises = sum(if_else(!is.na(materiaux_de_la_toiture) & materiaux_de_la_toiture %in% codes_ardoises, 1,0)),
              n_toits = sum(!is.na(materiaux_de_la_toiture)&materiaux_de_la_toiture!=0),
              n_pierres = sum(if_else(!is.na(materiaux_des_murs) & materiaux_des_murs %in% codes_pierres, 1,0)),
              n_meulieres = sum(if_else(!is.na(materiaux_des_murs) & materiaux_des_murs %in% codes_meulieres, 1,0)),
              n_betons= sum(if_else(!is.na(materiaux_des_murs) & materiaux_des_murs %in% codes_betons, 1,0)),
              n_briques= sum(if_else(!is.na(materiaux_des_murs) & materiaux_des_murs %in% codes_briques, 1,0)),
              n_bois= sum(if_else(!is.na(materiaux_des_murs) & materiaux_des_murs %in% codes_bois, 1,0)),
              n_agglo= sum(if_else(!is.na(materiaux_des_murs) & materiaux_des_murs %in% codes_agglo, 1,0)),
              n_murs = sum(!is.na(materiaux_des_murs)&materiaux_des_murs!=0),
              n_indus1 = sum(usage_1=="Industriel",na.rm = TRUE),
              n_indif1 = sum(usage_1=="Indifférencié",na.rm = TRUE),
              n_agr1 = sum(usage_1=="Agricole",na.rm = TRUE),
              n_res1 = sum(usage_1=="Résidentiel",na.rm = TRUE),
              n_ann1 = sum(usage_1=="Annexe",na.rm = TRUE),
              n_com1 = sum(usage_1=="Commercial et services",na.rm = TRUE),
              n_rel1 = sum(usage_1=="Religieux",na.rm = TRUE),
              n_sport1 = sum(usage_1=="Sportif"),
              n_usage1 = sum(!is.na(usage_1)),
              n_indus2 = sum(usage_2=="Industriel",na.rm = TRUE),
              n_indif2 = sum(usage_2=="Indifférencié",na.rm = TRUE),
              n_agr2 = sum(usage_2=="Agricole",na.rm = TRUE),
              n_res2 = sum(usage_2=="Résidentiel",na.rm = TRUE),
              n_ann2 = sum(usage_2=="Annexe",na.rm = TRUE),
              n_com2 = sum(usage_2=="Commercial et services",na.rm = TRUE),
              n_rel2 = sum(usage_2=="Religieux",na.rm = TRUE),
              n_sport2 = sum(usage_1=="Sportif"),
              n_usage2 = sum(!is.na(usage_2)),
              n=n()) 
  
  write_csv(data.car,paste0(path,"bati_carreaux.csv"),append = FALSE)
  
  
}
