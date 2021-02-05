library(ggplot2)
library(gridExtra)
library(cowplot)
library(png)
#'  -------------------------------------------------------------------------   @Parameters
species_names<-c("diplodus",
                 "mullus",
                 "palinurus",
                 "serranus")


#'  -------------------------------------------------------------------------   @InitExportDevice

data_names <-list.files(pattern="*.txt",recursive = FALSE)
the_data <- lapply(data_names,read.table)
names(the_data) <- species_names

### Create an histogram
dip <- ggplot(the_data[["diplodus"]],aes(x=V3))+
  geom_histogram(binwidth=5, fill="magenta")+
theme_classic()+
  labs(y="")+
  labs(x="")

mul <- ggplot(the_data[["mullus"]],aes(x=V3))+
  geom_histogram(binwidth=5, fill="chartreuse")+
  theme_classic()+
  labs(y="")+
  labs(x="")

pal <- ggplot(the_data[["palinurus"]],aes(x=V3))+
  geom_histogram(binwidth=5, fill="brown2")+
  theme_classic()+
  labs(y="")+
  labs(x="")
  
ser <- ggplot(the_data[["serranus"]],aes(x=V3))+
  geom_histogram(binwidth=5, fill="cyan")+
  theme_classic()+
  labs(y="")+
  labs(x="")
  
pdf("FigS1.pdf")
grid.arrange(dip,mul,pal,ser, name="auto",
                         left = textGrob("Number of pairwise comparisons", rot = 90, vjust = 1),
                        bottom = textGrob("In-water geographic distances"))
dev.off()
