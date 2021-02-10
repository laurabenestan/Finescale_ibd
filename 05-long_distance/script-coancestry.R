### Download libraries
library(vcfR)
library(related)
library(coorplot)
library(GGally)
library(dplyr)

### Download genomic data
vcf = read.vcfR('13101snps_468ind.recode.vcf')

geno = extract.gt(vcf)
rownames(geno) <- rep(seq(1,13101,1))
G_relate = matrix(NA, nrow = ncol(geno), ncol = nrow(geno)*2)
abob = t(substr(geno, start = 1, stop = 1))
bbob = t(substr(geno, start = 3, stop = 3))
odd = seq(1, ncol(G_relate), by = 2)
G_relate[, odd] = abob
G_relate[, odd + 1] = bbob
rownames(G_relate) = rownames(abob)
colnames(G_relate) = rep(colnames(abob), each = 2)
class(G_relate) = "numeric"
G_relate = data.frame(Individual = rownames(G_relate), G_relate)
G_relate$Individual = as.character(G_relate$Individual)
G_relate[, 2:ncol(G_relate)] = G_relate[, 2:ncol(G_relate)] + 1 #to avoid 0s in data

### Check if good format
t(geno[1:5,1:5])
G_relate[1:5,1:10]

### Change missing values to 0
G_relate[is.na(G_relate)] <- 0

### Compute relatedness indices
relat_fullDat = coancestry(G_relate, lynchli=1, lynchrd=1, quellergt=1, ritland=1, wang=1)
write.table(relat_fullDat$relatedness, "relatedness_serranus.txt", quote=FALSE, row.names = FALSE)

### Compare kinship and other relatedness values
related <- read.table("relatedness_serranus.txt",header=TRUE, stringsAsFactors = FALSE,dec=".")
kinship <- read.table("kinship_serran_all_df.txt", header=TRUE)
related_kinship <- merge(kinship,related, by=c("INDV1","INDV2"))
sapply(related_kinship, mode)
related_kinship[, 3:8] <- sapply(related_kinship[, 3:8], as.numeric)
matrix_cor <- cor(na.omit(related_kinship[,3:8]))
matrix_cor
