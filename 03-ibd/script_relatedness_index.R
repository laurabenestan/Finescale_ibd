## Download libraries
library(ecodist)
library(ggplot2)
library(tidyverse)
library(reshape)
library(rlist)
library(ggpubr)
library(grid)
library(stats)
library(data.table)
library(gridExtra)

### Download kinship and relatedness values
relatedness <- read.table("out_relatedness_serran_303Ind", header=TRUE)
genK <- read.table("geoGenK.txt", header=TRUE)
genE <- read.table("GenE.txt", header=TRUE)

### Merge dataframes
genK_genE <- merge(genK_genE, relatedness, by.x = c('INDV2','INDV1'), by.y = c('INDV1','INDV2'), all = F)

### Test the correlation of all indixes
cor.test(genK_genE$Kinship, genK_genE$RELATEDNESS_AJK)
cor.test(genK_genE$Kinship, genK_genE$Rousset_e)
cor.test(genK_genE$RELATEDNESS_AJK, genK_genE$Rousset_e)
