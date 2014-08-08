shinyUI(fluidPage(
  titlePanel("Formant Estimates"),
  
  sidebarLayout(
    sidebarPanel(
      helpText('Select a vowel, and see what formant estimates we would have gotten for different
               LPC parameter settings. "FAVE" shows the formant estimates provided by 
               FAVE-extract.'),
      
      selectInput("vowel", 
                  label = "Choose a vowel to display",
                  choices = c("*hr", "ae", "aeh", "ah", "ahr", "aw", "ay", "ay0", 
                              "e", "ey", "eyF", "eyr", "i", "iw", "iy", "iyF", "iyr", "o", 
                              "oh", "ow", "owF", "owr", "oy", "Tuw", "u", "uh", "uw", "uwr"),
                  selected = "ae"),
        selectInput("formants", 
                  label = "Choose number of formants",
                  choices = c("3","4","5","6","FAVE"),
                  selected = "FAVE")
    ),
    
    mainPanel(
      plotOutput("vowelPlot")
    )
  )
))