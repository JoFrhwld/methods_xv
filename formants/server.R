library(plyr)
library(dplyr)
library(ggplot2)

data <- readRDS("data/candidates.rds")

shinyServer(function(input, output) {
  
  fave <- data %>% filter(nFormants == formants)
  p <- ggplot(fave, aes(F2, F1)) + 
    stat_density2d(geom = "polygon") + 
    scale_x_reverse()+
    scale_y_reverse()+
    theme_bw()
  
  output$vowelPlot <- renderPlot({
    nformants <- as.numeric(input$formants)
    vowel <- input$vowel
    
    
    if(is.na(nformants)){
      to_plot <- fave%>%filter(plt_vclass == vowel)
    }else{
      to_plot <- data %>% filter(plt_vclass==vowel, formants ==nformants)
    }
    p + geom_point(data = to_plot, color = "red")
  })
  

  
}
)