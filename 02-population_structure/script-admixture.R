### Download libraries
library(reshape2)
library(plyr)
library(stringr)
library(ggplot2)
library(forcats)

species_names<-c("diplodus",
                 "mullus",
                 "palinurus",
                 "serranus")


#'  -------------------------------------------------------------------------   @InitExportDevice
### Download all outputs from Admixture
species_names<-c("diplodus",
                 "mullus",
                 "palinurus",
                 "serranus")
data_names<-list.files(pattern="*.2.Q")
the_data <- lapply(data_names,read.table)
names(the_data) <- species_names

### Add one column with the individuals names and the population they belong to
id_names<-list.files(pattern="*.txt")
the_id <- lapply(id_names,read.table)
id_admixture <- Map(cbind, the_data, the_id)

### Change columns names
colnames <- c("K1","K2","IND")
names_admixture <-lapply(id_admixture, setNames, colnames)
admixture_melt <- melt(names_admixture)
colnames(admixture_melt) <- c("IND","K","ANCESTRY","SPECIES")

### Add latitude and longitude names
geo <- read.table("geographic_coordinates_1299ind_all.txt", header=TRUE)
geo_admixture_melt <- merge(geo, admixture_melt, by=c("IND"))

### Make a ggplot graph with ADMIXTURE results for each species
x_title="Individuals"
y_title="Ancestry"
geo_admixture_melt %>%
mutate(name = fct_reorder(IND, desc(LAT))) %>%
ggplot(aes(x=IND,y=ANCESTRY, fill=K))+
  geom_bar(stat="identity")+
  scale_fill_manual(values=c("blue","red"), name= "K", labels=c("K1","K2"))+
  facet_grid(SPECIES ~ .)+
  labs(y=y_title)+
  labs(x=x_title)+
  theme_classic()+
  theme(axis.text.x=element_blank())

### Save the graph
ggsave("admixture_all_species.pdf",width=20,height=5,dpi=600)
dev.off()
