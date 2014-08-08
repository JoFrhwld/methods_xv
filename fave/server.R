library(plyr)
library(dplyr)
library(ggplot2)

data <- readRDS("data/candidates.rds")
data %>%
  mutate(log_B1 = log(B1),
         log_B2 = log(B2))->data
covs <- readRDS("data/covs.rds")
all_covs <- readRDS("data/all_covs.rds")
means <- readRDS("data/means.rds")
formant_grid <- expand.grid(F1=seq(236, 1072, length = 100), F2 = seq(626,3002, length = 100))

grid_dist <- function(grid, means, cov){
  grid%>%
      rowwise%>%
      mutate(dist = sqrt(mahalanobis(x = c(F1, F2),
                                            center = c(means[1,"F1"], means[1,"F2"]),
                                            cov = covs$cov[[1]]))) -> out
  return(out)
}

all_dist <- function(grid, means, cov){
  grid%>%
    filter(!is.na(F2))%>%
    rowwise()%>%
    mutate(dist = sqrt(mahalanobis(x = c(F1, F2, log_B1, log_B2),
                                   center = c(means[1,"F1"], means[1,"F2"],
                                              means[1,"log_B1"],means[1,"log_B2"]),
                                   cov = cov$cov[[1]]))) -> out
  return(out)
}




shinyServer(function(input, output) {
  
  fave <- data %>% filter(nFormants == formants)
  
  p <- ggplot(fave, aes(F2, F1)) + 
    stat_density2d(geom = "polygon") + 
    scale_x_reverse()+
    scale_y_reverse()+
    theme_bw()
  
  makeGrid <- reactive({
    this_means <- means %>% filter(plt_vclass == input$vowel)
    this_covs <- covs%>%filter(plt_vclass == input$vowel)
    this_grid <- grid_dist(formant_grid, this_means, this_covs)
    return(this_grid)
  })
  
  output$ui <- renderUI({
    this_vowel <- data %>%
                    ungroup()%>%
                    filter(plt_vclass == input$vowel)%>%
                    mutate(id = as.numeric(as.factor(id)))
    
    sliderInput("id",label = "id",min = 1, max= max(this_vowel$id),value=1,step =1)
  })
  
  output$vowelPlot <- renderPlot({
    if(is.null(input$id)){
      plot_id <- 1
    }else{
      plot_id <- input$id
    }
    to_plot <- data %>%ungroup()%>%
                    filter(plt_vclass == input$vowel)%>%
                    mutate(id = as.numeric(as.factor(id)))%>%
                    filter(id == plot_id)
    
    
    winner <- all_dist(to_plot, 
                       means%>%filter(plt_vclass == input$vowel), 
                       all_covs%>%filter(plt_vclass==input$vowel)) %>% 
              filter(dist == min(dist))
    
    p + ggtitle(paste(to_plot$plt_vclass[1], "winner:", winner$formants[[1]]))+
        geom_tile(data = makeGrid(), aes(fill = dist), alpha = 0.7) +
        geom_text(data = to_plot, aes(label=formants))+
        geom_point(data = winner, shape = 1, size = 10)+
        scale_fill_distiller(palette = "Spectral")
  })
  
  
  
}
)