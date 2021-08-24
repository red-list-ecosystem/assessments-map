library(dplyr)
library(magrittr)
options(dplyr.summarise.inform = FALSE)


load("spatialdata.rda")
asm.national %<>% mutate(NAME=if_else(ISO2 %in% "MM","Myanmar",NAME))

asm.national %<>%
  mutate(protocol=if_else(asm.national$IUCN==0,"Other","IUCN RLE (v2)"),
         colorgrp = if_else(asm.national$IUCN==0,1,
           ifelse(included_ecosystems %in% 'multiple biomes',3,2))) %>%
  mutate(colorgrp=factor(colorgrp,labels=c("Other", "IUCN RLE (v2) / single biome", "IUCN RLE (v2) / multiple biomes")))

load("tabledata.rda")
slc.countries <-  asm.list %>% distinct(iso2,country_name)
rle.asms <- c("IUCN RLE v2.0","IUCN RLE v2.1","IUCN RLE v2.2")

refs <- ref.list %>%
  transmute(ref_code,
    reference=sprintf("%s %s %s %s %s",
      if_else(is.na(author_list), '',
        if_else(nchar(author_list)<20,author_list, paste0(substr(author_list,0,17),'...'))),
      if_else(is.na(date),'',paste0("(",date,")")),
      if_else(is.na(title),'',paste0(title,'.')),
      if_else(is.na(container_title),'',paste0(container_title,'.')),
      if_else(is.na(doi),'',paste0('http://doi.org/',doi))))
