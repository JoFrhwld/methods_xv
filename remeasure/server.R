library(plyr)
library(dplyr)
library(ggplot2)

data <- readRDS("data/candidates.rds")
data %>%
  mutate(log_B1 = log(B1),
         log_B2 = log(B2))->data
covs <- readRDS("data/covs.rds")
means <- readRDS("data/means.rds")

speaker_2dim <- readRDS("data/speaker_2dim.rds")

ellipse_df <- function(means, covs){
  angles <- seq(0, 2*pi, length.out=200)
  RR <- chol(covs)
  ellipse <- as.data.frame(sweep(1 * cbind(cos(angles), sin(angles)) %*% RR, 2, means, "+"))
  colnames(ellipse) <- c("F1","F2")
  return(ellipse)
}




shinyServer(function(input, output) {
  
  fave <- data %>% filter(nFormants == formants)
  
  p <- ggplot(fave, aes(F2, F1)) + 
    stat_density2d(geom = "polygon") + 
    scale_x_reverse()+
    scale_y_reverse()+
    theme_bw()

  
  output$vowelPlot <- renderPlot({
    
    speaker_means <- (speaker_2dim %>% filter(plt_vclass == input$vowel))$means[[1]][1,]
    speaker_covs <- (speaker_2dim %>%filter(plt_vclass == input$vowel))$cov[[1]]
    speaker_ellipse <- ellipse_df(speaker_means, speaker_covs)
    speaker_ellipse$distribution <- "speaker"
    
    anae_means1 <- means %>% filter(plt_vclass == input$vowel)
    anae_means <- c(anae_means1$F1, anae_means1$F2)
    anae_covs <- (covs%>%filter(plt_vclass == input$vowel))$cov[[1]]
    anae_ellipse <- ellipse_df(anae_means, anae_covs)
    anae_ellipse$distribution <- "anae"
    
    
    all_ellipse <- rbind.fill(anae_ellipse, speaker_ellipse)
    
    p + ggtitle(input$vowel)+
      geom_path(data = all_ellipse, aes(color = distribution)) +
      scale_color_brewer("distribution", palette = "Dark2")
  })
  
  
  
}
)