library(dplyr)
library(magrittr)
options(dplyr.summarise.inform = FALSE)

load("assmntdata.rda")
slc.countries %<>% mutate(NAME=if_else(ISO2 %in% "MM","Myanmar",NAME))
asm.points$ocat <- factor(asm.points$overall_risk_category,levels=c("CO","CR","EN", "VU", "NT", "LC"))
slc.countries$n_asm <- cut(slc.countries$n_assessments,breaks=c(0, 1, 4, 10, Inf),labels=c("1","2-4","5-10",">10"))

rle.asms <- c("IUCN RLE v2.0","IUCN RLE v2.1","IUCN RLE v2.2")

## pal <- colorFactor(c("black","red", "orange", "darkgreen", "green",  "yellow"), domain = c("CO","CR","EN", "LC", "NT", "VU"))
