#' --------------------------------------------------------------------------   @Header
#'
#' @title Finescale Isolation by Distance
#'
#' @description
#' This R script...
#'
#' @author   Laura Benestan, \email{lmbenestan@gmail.com}
#'
#' @date 2019/02/03
#'
#' --------------------------------------------------------------------------   @VVVVVV

#'-------------------------------------------------------------------------   @library
require(ggplot2)
require(grid)
require(gridExtra)
require(reshape2)

 #'-------------------------------------------------------------------------   @code
### Download in-water geographic distances
geo <- read.table("../00-data/geo_diplodus.txt",header=TRUE)

### Download relatedness coefficients
gen <- read.table("../00-data/kinship_diplodus.txt",header=TRUE)
gen_df <- melt(gen)
colnames(gen_df) <- c("INDV1","INDV2","Ajk")

### Merge both datasets
geo_gen <- merge(geo, gen_df, by=c("INDV1","INDV2"))

### Check the number of pairwise observations in the minimum interval of 5km
min <- nrow(subset(geo_gen, geo_gen$DIST <5))

### Run the function
Slope_SES <- Slope.boot.SES(geo_gen, window = c(seq(5,920,by=5)),min = min,repnull = 100,repboot = 100,core = 4)

### Save the results in a dataframe
Slope_SES_results <- data.frame(aaply(laply(Slope_SES, as.matrix), c(2, 3), mean),aaply(laply(Slope_SES, as.matrix), c(2, 3), sd)[,c(2,4)])
colnames(Slope_SES_results)[c(5,6)]<- c("slope_sd","SES_sd")

### Save the results in a file
write.table(Slope_pinksy_final_results, "results_ses_no_family_serranus.txt", quote=FALSE, row.names=FALSE)

### Save the results in a Rdata
save.image("SES_no_family_serranus.Rdata")