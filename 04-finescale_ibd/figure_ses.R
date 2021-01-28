rm(list=ls())
#' --------------------------------------------------------------------------   @Header
#'
#' @title Figure 2 - Panel of Slope with information about SES values for each species
#'
#' @description
#' This R script...
#'
#' @author   Nicolas LOISEAU, \email{nicolas.loiseau1@@gmail.com}
#'
#' @date 2019/02/03
#'
#' --------------------------------------------------------------------------   @VVVVVV

#'  -------------------------------------------------------------------------   @library
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

data_names<-list.files(pattern="*.RData",recursive = FALSE)
lapply(data_names,load,.GlobalEnv)
slope<-list(Slope_diplo_kinship,Slope_mullus_kinship,
            Slope_lobster_kinship,Slope_serranus_kinship_nord)

data_pic<-list.files(pattern="../00-data/*.png",recursive = FALSE)
pic<-lapply(data_pic,readPNG)
names(pic) <- species_names
#'  -------------------------------------------------------------------------   @formatdata
prep.data <-  function(data){ 
  new_data <- data.frame(windows = data[[1]][1],
             slope_m = apply(do.call(cbind,lapply(data,function(x) x[,2])),1,mean),
             slope_sd = apply(do.call(cbind,lapply(data,function(x) x[,2])),1,sd),
             ses_m = apply(do.call(cbind,lapply(data,function(x) x[,4])),1,mean),
             ses_sd = apply(do.call(cbind,lapply(data,function(x) x[,4])),1,sd),
             signif= rep(NA,length(data[[1]][1])))
  
  for(i in 1:nrow(new_data)){
    if (abs(new_data$ses_m[i])<1.96) new_data$signif[i] <- "nf"
    if (abs(new_data$ses_m[i])>1.96) new_data$signif[i] <- "signif"
  }
  
  return(new_data)
}

data_graph<-lapply(slope,prep.data) 
names(data_graph) <- species_names

#'  -------------------------------------------------------------------------   @DrawFigure
#'  SAVE in 10 per 12
#--- Diplodus graph
        #--- Plot of slope
        plot_diplodus_slope <- ggplot(data_graph[["diplodus"]], aes(x=windows, y=slope_m)) +
          scale_y_continuous(labels=seq(-0.0005,0.0001,0.0001),limits=c(-0.0005,0.0001),
                             breaks = seq(-0.0005,0.0001,0.0001))+
          scale_shape_manual(values=c(16,21))+
          scale_size_manual(values=c(1.2,3))+
          scale_color_manual(values = c("nf" = "#EE00EE32","signif" = "magenta2"))+
          scale_fill_manual( values = c("nf" = "#EE00EE32","signif" = "grey50"))+
          ylab("Slope")+
          xlab(" ")+
          xlim(0,900)+
          geom_errorbar(aes(ymax= slope_m + slope_sd, ymin = slope_m - slope_sd,color=signif,size=signif),size=0.5)+
          geom_point(aes(color=signif,shape=signif,fill=signif,size=signif))+
          theme_bw()+theme(legend.position = "none",
                           panel.grid.major = element_blank(), panel.grid.minor = element_blank())  
          plot_diplodus_slope <- ggdraw(plot_diplodus_slope)+draw_image(pic$diplodus,x=0.38,y=0.001,vjust=0.3,scale=0.2)
          
          
        
        #--- Plot of SES    
        plot_diplodus_ses <- ggplot(data_graph[["diplodus"]], aes(x=windows, y=ses_m)) +
          scale_shape_manual(values=c(16,21))+
          scale_size_manual(values=c(1.2,3))+
          scale_color_manual(values = c("nf" = "#EE00EE32","signif" = "magenta2"))+
          scale_fill_manual( values = c("nf" = "#EE00EE32","signif" = "grey50"))+
          ylab("SES")+
          xlab(" ")+
          xlim(0,900)+
          ylim(-6,3)+
          geom_errorbar(aes(ymax= ses_m + ses_sd, ymin = ses_m - ses_sd,color=signif,size=signif),size=0.5)+
          geom_hline(yintercept=0,  color = "black")+ 
          geom_hline(yintercept=1.96,linetype="dashed", color = "black")+
          geom_hline(yintercept=-1.96, linetype="dashed", color = "black")+
          geom_point(aes(color=signif,shape=signif,fill=signif,size=signif))+
          theme_bw()+theme(legend.position = "none",
                           panel.grid.major = element_blank(), panel.grid.minor = element_blank())
        plot_diplodus_ses <- ggdraw(plot_diplodus_ses)+draw_image(pic$diplodus,x=0.38,y=0.001,vjust=0.3,scale=0.2)
        
       
          
#--- mullus graph
          #--- Plot of slope
          plot_mullus_slope <- ggplot(data_graph[["mullus"]], aes(x=windows, y=slope_m)) +
            scale_y_continuous(labels=seq(-0.0005,0.0001,0.0001),limits=c(-0.0005,0.0001),
                               breaks = seq(-0.0005,0.0001,0.0001))+
            scale_shape_manual(values=c(16,21))+
            scale_size_manual(values=c(1.2,3))+
            scale_color_manual(values = c("nf" = "#FFB90F32","signif" = "darkgoldenrod1"))+
            scale_fill_manual( values = c("nf" = "#FFB90F32","signif" = "grey50"))+
            ylab(" ")+
            xlab(" ")+
            xlim(0,900)+
            geom_errorbar(aes(ymax= slope_m + slope_sd, ymin = slope_m - slope_sd,color=signif,size=signif),size=0.5)+
            geom_point(aes(color=signif,shape=signif,fill=signif,size=signif))+
            theme_bw()+theme(legend.position = "none",
                             panel.grid.major = element_blank(), panel.grid.minor = element_blank())    
          plot_mullus_slope <- ggdraw(plot_mullus_slope)+draw_image(pic$mullus,x=0.38,y=0.001,vjust=0.3,scale=0.2)
          
          
          #--- Plot of SES    
          plot_mullus_ses <- ggplot(data_graph[["mullus"]], aes(x=windows, y=ses_m)) +
            scale_shape_manual(values=c(16,21))+
            scale_size_manual(values=c(1.2,3))+
            scale_color_manual(values = c("nf" = "#FFB90F32","signif" = "darkgoldenrod1"))+
            scale_fill_manual( values = c("nf" = "#FFB90F32","signif" = "grey50"))+
            ylab(" ")+
            xlab(" ")+
            xlim(0,900)+
            ylim(-6,3)+
            geom_errorbar(aes(ymax= ses_m + ses_sd, ymin = ses_m - ses_sd,color=signif,size=signif),size=0.5)+
            geom_hline(yintercept=0,  color = "black")+ 
            geom_hline(yintercept=1.96,linetype="dashed", color = "black")+
            geom_hline(yintercept=-1.96, linetype="dashed", color = "black")+
            geom_point(aes(color=signif,shape=signif,fill=signif,size=signif))+
            theme_bw()+theme(legend.position = "none",
                             panel.grid.major = element_blank(), panel.grid.minor = element_blank())
          plot_mullus_ses <- ggdraw(plot_mullus_ses)+draw_image(pic$mullus,x=0.38,y=0.001,vjust=0.3,scale=0.2)
          

#--- palinurus graph
                    
          #--- Plot of slope
          plot_palinurus_slope <- ggplot(data_graph[["palinurus"]], aes(x=windows, y=slope_m)) +
            scale_y_continuous(labels=seq(-0.0005,0.0001,0.0001),limits=c(-0.0005,0.0001),
                               breaks = seq(-0.0005,0.0001,0.0001))+
            scale_shape_manual(values=c(16,21))+
            scale_size_manual(values=c(1.2,3))+
            scale_color_manual(values = c("nf" = "#EE3B3B32","signif" = "brown2"))+
            scale_fill_manual( values = c("nf" = "#EE3B3B32","signif" = "grey50"))+
            ylab("Slope")+
            xlab("In-Water geographical distances (km)")+
            xlim(0,900)+
            geom_errorbar(aes(ymax= slope_m + slope_sd, ymin = slope_m - slope_sd,color=signif,size=signif),size=0.5)+
            geom_point(aes(color=signif,shape=signif,fill=signif,size=signif))+
            theme_bw()+theme(legend.position = "none",
                             panel.grid.major = element_blank(), panel.grid.minor = element_blank())    
          plot_palinurus_slope <- ggdraw(plot_palinurus_slope)+draw_image(pic$palinurus,x=0.38,y=0.001,vjust=0.3,scale=0.2)
          
          
          #--- Plot of SES    
          plot_palinurus_ses <- ggplot(data_graph[["palinurus"]], aes(x=windows, y=ses_m)) +
            scale_shape_manual(values=c(16,21))+
            scale_size_manual(values=c(1.2,3))+
            scale_color_manual(values = c("nf" = "#EE3B3B32","signif" = "brown2"))+
            scale_fill_manual( values = c("nf" = "#EE3B3B32","signif" = "grey50"))+
            ylab("SES")+
            xlab("In-Water geographical distances (km)")+
            xlim(0,900)+
            ylim(-6,3)+
            geom_errorbar(aes(ymax= ses_m + ses_sd, ymin = ses_m - ses_sd,color=signif,size=signif),size=0.5)+
            geom_hline(yintercept=0,  color = "black")+ 
            geom_hline(yintercept=1.96,linetype="dashed", color = "black")+
            geom_hline(yintercept=-1.96, linetype="dashed", color = "black")+
            geom_point(aes(color=signif,shape=signif,fill=signif,size=signif))+
            theme_bw()+theme(legend.position = "none",
                             panel.grid.major = element_blank(), panel.grid.minor = element_blank())
          plot_palinurus_ses <- ggdraw(plot_palinurus_ses)+draw_image(pic$palinurus,x=0.38,y=0.001,vjust=0.3,scale=0.2)
          
#--- serranus graph
          
          #--- Plot of slope
          plot_serranus_slope <- ggplot(data_graph[["serranus"]], aes(x=windows, y=slope_m)) +
            scale_y_continuous(labels=seq(-0.0005,0.0001,0.0001),limits=c(-0.0005,0.0001),
                               breaks = seq(-0.0005,0.0001,0.0001))+
            scale_shape_manual(values=c(16,21))+
            scale_size_manual(values=c(1.2,3))+
            scale_color_manual(values = c("nf" = "#00CDCD32","signif" = "cyan3"))+
            scale_fill_manual( values = c("nf" = "#00CDCD32","signif" = "grey50"))+
            ylab(" ")+
            xlab("In-Water geographical distances (km)")+
            xlim(0,900)+
            geom_errorbar(aes(ymax= slope_m + slope_sd, ymin = slope_m - slope_sd,color=signif,size=signif),size=0.5)+
            geom_point(aes(color=signif,shape=signif,fill=signif,size=signif))+
            theme_bw()+theme(legend.position = "none",
                             panel.grid.major = element_blank(), panel.grid.minor = element_blank())    
          plot_serranus_slope <- ggdraw(plot_serranus_slope)+draw_image(pic$serranus,x=0.38,y=0.001,vjust=0.3,scale=0.2)
          
            
          #--- Plot of SES    
          plot_serranus_ses <- ggplot(data_graph[["serranus"]], aes(x=windows, y=ses_m)) +
            scale_shape_manual(values=c(16,21))+
            scale_size_manual(values=c(1.2,3))+
            scale_color_manual(values = c("nf" = "#00CDCD32","signif" = "cyan3"))+
            scale_fill_manual( values = c("nf" = "#00CDCD32","signif" = "grey50"))+
            ylab(" ")+
            xlab("In-Water geographical distances (km)")+
            xlim(0,900)+
            ylim(-6,3)+
            geom_errorbar(aes(ymax= ses_m + ses_sd, ymin = ses_m - ses_sd,color=signif),size=0.5)+
            geom_hline(yintercept=0,  color = "black")+ 
            geom_hline(yintercept=1.96,linetype="dashed", color = "black")+
            geom_hline(yintercept=-1.96, linetype="dashed", color = "black")+
            geom_point(aes(color=signif,shape=signif,fill=signif,size=signif))+
            theme_bw()+theme(legend.position = "none",
                             panel.grid.major = element_blank(), panel.grid.minor = element_blank())
           plot_serranus_ses <- ggdraw(plot_serranus_ses)+draw_image(pic$serranus,x=0.38,y=0.001,vjust=0.3,scale=0.2)
          
          
grid.arrange(plot_diplodus_slope,plot_mullus_slope,plot_palinurus_slope,plot_serranus_slope)
grid.arrange(plot_diplodus_ses,plot_mullus_ses,plot_palinurus_ses,plot_serranus_ses)
