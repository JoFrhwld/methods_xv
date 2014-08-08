library(plyr)
library(dplyr)
library(ggplot2)

data <- readRDS("data/candidates.rds")
data_means <- data %>%
                group_by(formants, plt_vclass) %>%
                summarise(F1 = mean(F1),
                          F2= mean(F2))
fave_means <- data %>%
                filter(nFormants == formants) %>%
                group_by(plt_vclass)%>%
                summarise(F1=mean(F1),
                          F2=mean(F2))%>%
                mutate(formants = "fave")

shinyServer(function(input, output) {
  
  fave <- data %>% filter(nFormants == formants)
  
  
  
  p <- ggplot(fave, aes(F2, F1)) + 
    stat_density2d(geom = "polygon") + 
    scale_x_reverse()+
    scale_y_reverse()+
    theme_bw()
  

  

  output$vowelPlot <- renderPlot({
    
    data_to_plot <- data_means %>%ungroup()%>%
                        filter(plt_vclass %in% input$vowel)
    fave_to_plot <- fave_means %>%ungroup()%>%
      filter(plt_vclass %in% input$vowel)
    
    p + geom_text(data = data_to_plot, aes(label=plt_vclass, color=as.factor(formants)))+
        geom_text(data = fave_to_plot, aes(label = plt_vclass), color = "red")+
        geom_point(data = fave_to_plot, shape = 1, size = 10, color = "red")+
        scale_color_brewer("formants", palette = "Dark2")
    })
  
  
  
}
)