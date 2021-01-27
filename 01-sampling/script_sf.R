### Download libraries
library("ggplot2")
library("sf")
library("rnaturalearth")
library("rnaturalearthdata")
library("rgdal")
library("cowplot")
library("ggspatial")
library("magick")
library("ggpubr")
library("gridExtra")
library("maps")
library("mapdata")
library("dplyr")

# Download the map for the Mediterranean Sea
wH <- map_data("worldHires",  xlim=c(-8,37), ylim=c(29.5,47)) # subset polygons surrounding med sea

# Simple map of Mediterranean sea with ggplot
ggplot() +
  geom_polygon(data = wH, aes(x=long, y = lat, group = group), fill = "gray80", color = NA) +
  coord_fixed(xlim=c(-8,37), ylim=c(29.5,46.5), ratio = 1.3) +
  theme(panel.background = element_rect(fill = "white", colour = "black"),
        axis.title = element_blank())

### Save the map
ggsave("Mediterranean_sea.pdf", width = 10, height = 10)

### Download a map using sf package
world <- ne_countries(scale = "medium", returnclass = "sf")
class(world)
europe <- subset(world, continent == "Europe"| continent == "Africa")

# Import geographic coordinates file
data<-read.table("geographic_coordinates_1299ind_all.txt",header=TRUE, dec=".",sep="\t",na.strings="NA",strip.white=T)
summary(data) 

# Add species information
data$POP <- substr(data$IND,1,3)
unique(data$POP)
data$SPECIES <- ifelse(data$POP =="Mul"| data$POP =="mul","Mullus surmuletus", ifelse(data$POP=="dip","Diplodus sargus", ifelse(data$POP=="ser","Serranus cabrilla","Palinurus elephas")))

### Count the number of samples per latitude and longitude points
sites_number <- data %>% group_by(LAT,LON,SPECIES) %>%
  tally()
sites_number

# Create three subsets for each species
diplodus <- subset(sites_number, sites_number$SPECIES=="Diplodus sargus")
mullus <- subset(sites_number, sites_number$SPECIES=="Mullus surmuletus")
serranus <- subset(sites_number, sites_number$SPECIES=="Serranus cabrilla")
palinurus <- subset(sites_number, sites_number$SPECIES=="Palinurus elephas")

# Create a world map and save it in png
png("Europe_map.png")
map_world <- ggplot(data = europe) +
  geom_sf() +
  xlab(" ") + ylab(" ")+
  theme_bw()+theme(legend.position = "none",
                   panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  coord_fixed(xlim = c(-6, 35), ylim = c(30, 70), expand = FALSE, ratio = 1.3)+
  geom_rect(xmin = -1, xmax = 10, ymin = 35, ymax = 44, 
            fill = NA, colour = "black", size = 0.5)
map_world
dev.off()

### Globe map
png("Globe.png")
globe_world <-ggplot(data = world) +
  geom_sf() +
  coord_sf(crs = "+proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs ")+
  theme_bw()+
  theme(legend.position = "none",
         panel.grid.minor = element_blank())

globe_world 
dev.off()

### Import the image
img0 <- magick::image_transparent(
  magick::image_read("World_map.png"),
  color = "white"
)

# Create a map for Mediteranean Sea with marine reserves
pdf("Map_med.pdf", width=7, height = 7)
map_all <- ggplot(data = world) +
  geom_sf() +
  xlab("Longitude") + ylab("Latitude") +
  coord_sf(xlim = c(-6, 8), ylim = c(35, 45), expand = FALSE)+
  theme_bw()+theme(legend.position = "none",
                   panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
geom_polygon(aes(x=long, y=lat, group=group, fill=group), fill="blue", size=.2,color="blue", data=MPA_notake, alpha=0.5)+
annotation_scale(location = "br", width_hint = 0.5)+
geom_text(aes(x=Longitude+1.5, y=Latitude, label=NAME), data=mpa_info_text[-5,], colour="blue", size=2)
map_all
dev.off()

### Merge the global map with the mediteranean one
pdf("Top_panel.pdf", width=10, height=7)
plot_grid(map_world, map_all, nrow = 1, rel_widths = c(1.5, 2.5))
dev.off()

### Add the world map on the right corner
map_med <- ggdraw(map_all) + draw_image(img0, x = 0.35, y = 1.15, hjust = 1, vjust = 1, width = 0.20, height = 0.5)
map_med
dev.off()

# Create a ggmap for each species
x_title="Longitude"
y_title="Latitude"

## Diplodus sargus
### Image
img1 <- magick::image_transparent(
  magick::image_read("Diplodus.png"),
  color = "white"
)

### Map
graph1 <- ggplot() +
  geom_polygon(data = wH, aes(x=long, y = lat, group = group), fill = "gray80", color = NA) +
  coord_fixed(xlim = c(-6, 8), ylim = c(35, 45), ratio=1.2)+
  theme(panel.background = element_rect(fill = "white", colour = "black"),
        axis.title = element_blank())+
  geom_point(aes(x = LON, y = LAT,size=n), data=diplodus, fill="magenta2",shape = 21, alpha = 0.5)+
  xlab("") + ylab("Latitude") +
  theme_bw()+theme(legend.position = "bottom",
  panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  labs(y=y_title)+  
  theme(axis.text.x=element_text(colour="black"))+
  theme(axis.text.y=element_text(colour="black"))
graph1

### Merge map and image
g1 <- ggdraw(graph1)+draw_image(img1, x = 0.95, y = 0.58, hjust = 1, vjust = 1, width = 0.25, height = 0.6)
g1

## Mullus surmuletus
### Map
graph2 <- ggplot() +
  geom_polygon(data = wH, aes(x=long, y = lat, group = group), fill = "gray80", color = NA) +
  coord_fixed(xlim = c(-6, 8), ylim = c(35, 45), ratio=1.2)+
  theme(panel.background = element_rect(fill = "white", colour = "black"),
        axis.title = element_blank())+
  geom_point(aes(x = LON, y = LAT, size=n), data=mullus, fill="darkgoldenrod1",shape = 21, alpha = 0.5)+
  labs(y="")+  
  labs(x="")+
  theme_bw()+theme(legend.position = "bottom",
                   panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  labs(x=x_title)+  
  theme(axis.text.x=element_text(colour="black"))+
  theme(axis.text.y=element_text(colour="black"))
graph2

### Image
img2 <- magick::image_transparent(
  magick::image_read("Mullus.png"),
  color = "white"
)
### Merge map and image
g2 <- ggdraw(graph2)+draw_image(img2, x = 0.97, y = 0.57, hjust = 1, vjust = 1, width = 0.25, height = 0.6)
g2

## Palinurus elephas
### Map
graph3 <- ggplot() +
  geom_polygon(data = wH, aes(x=long, y = lat, group = group), fill = "gray80", color = NA) +
  coord_fixed(xlim = c(-6, 8), ylim = c(35, 45), ratio=1.2)+
  theme(panel.background = element_rect(fill = "white", colour = "black"),
        axis.title = element_blank())+
  geom_point(aes(x = LON, y = LAT, size=n), data=palinurus, fill="brown2",shape = 21, alpha=0.5)+
  labs(y="")+  
  labs(x="")+
  theme_bw()+theme(legend.position = "bottom",
                   panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  labs(y=y_title)+  
  theme(axis.text.x=element_text(colour="black"))+
  theme(axis.text.y=element_text(colour="black"))
graph3

### Image
img3 <- magick::image_transparent(
  magick::image_read("Palinurus.png"),
  color = "white"
)
### Merge map and image
g3 <- ggdraw(graph3)+draw_image(img3, x = 0.97, y = 0.48, hjust = 1, vjust = 1, width = 0.21, height = 0.4)
g3

## Serranus cabrilla
### Image
serranus_fig<- system.file("extdata", "Serranus.png", package = "cowplot")
img <- magick::image_transparent(
    magick::image_read("Serranus.png"),
  color = "white"
)

### Map
graph4 <- ggplot() +
  geom_polygon(data = wH, aes(x=long, y = lat, group = group), fill = "gray80", color = NA) +
  coord_fixed(xlim = c(-6, 8), ylim = c(35, 45), ratio=1.2)+
  theme(panel.background = element_rect(fill = "white", colour = "black"),
        axis.title = element_blank())+
  geom_point(aes(x = LON, y = LAT,size=n), data=serranus, fill="cyan3",shape = 21, alpha=0.5)+
  labs(y="")+  
  labs(x="")+
  theme_bw()+theme(legend.position = "bottom",
                   panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  labs(x=x_title)+  
  theme(axis.text.x=element_text(colour="black"))+
  theme(axis.text.y=element_text(colour="black"))

### Merge map and image
g4 <- ggdraw(graph4)+draw_image(img, x = 0.97, y = 0.57, hjust = 1, vjust = 1, width = 0.25, height = 0.6)

### Merge all plots
pdf("Map_test_legend.pdf")
map_4_species <- gridExtra::grid.arrange(g1, g2, g3, g4, ncol=2, nrow=2)
dev.off()

################# dbMEM maps
dbmem <- read.table("Dbmem11_palinurus.txt",header=TRUE)
sites <- read.table("population_map_palinurus_243ind_mpa.txt")

graph4 <- ggplot() +
  geom_polygon(data = wH, aes(x=long, y = lat, group = group), fill = "gray80", color = NA) +
  coord_fixed(xlim = c(-6, 8), ylim = c(35, 45), ratio=1.2)+
  theme(panel.background = element_rect(fill = "white", colour = "black"),
        axis.title = element_blank())+
  geom_point(aes(x = LON, y = LAT), data=serranus, fill="cyan3",shape = 21, size=1.5)+
  labs(y="")+  
  labs(x="")+
  theme_bw()+theme(legend.position = "none",
                   panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  labs(x=x_title)+  
  theme(axis.text.x=element_text(colour="black"))+
  theme(axis.text.y=element_text(colour="black"))
