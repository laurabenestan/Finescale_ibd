### Download libraries
library(data.table)
library(adegenet)
library(ggplot2)
library(reshape)
library(adespatial)
library(ecodist)

### Download in-water geographic distances
geo <- read.table("../00-data/geo_diplodus.txt",header=TRUE)

### Download relatedness coefficients
gen <- read.table("../00-data/kinship_diplodus.txt",header=TRUE)
gen_df <- melt(gen)
colnames(gen_df) <- c("INDV1","INDV2","Ajk")

### Merge both datasets
geo_gen <- merge(geo, gen_df, by=c("INDV1","INDV2"))

### Perform Mantel test in ecodist
mA <- mantel(geo_gen$DIST~geo_gen$Ajk)

### Visualize the results by first creating a ggplot showing the relationship between slope and geographic distances.
ggplot(data=geo_gen, aes(x=DIST, y=Ajk)) + 
geom_point(size=2, pch=21, fill="magenta") + 
labs(title="Diplodus sargus", x = "In-water geographic distance (km)", y = "Kinship")+
geom_smooth(method="loess",color="black")+
theme_classic()
 
### Save the graph.
ggsave("Manteltest_mullus.pdf", width=15,height=10,units="cm")
