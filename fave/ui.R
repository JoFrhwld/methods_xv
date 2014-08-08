shinyUI(fluidPage(
  titlePanel("FAVE-extract: Step 1"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Choose a vowel class, and see how different LPC parameter settings
               for a given token compare to the ANAE distribution for that vowel class.
               The circled value was chosen as the winner on the basis of its
               Mahalanobis distance."),
      selectInput("vowel", 
                  label = "Choose a vowel to display",
                  choices = c("*hr", "ae", "aeh", "ah", "ahr", "aw", "ay", "ay0", 
                              "e", "ey", "eyF", "eyr", "i", "iw", "iy", "iyF", "iyr", "o", 
                              "oh", "ow", "owF", "owr", "oy", "Tuw", "u", "uh", "uw", "uwr"),
                  selected = "ae"),
      #sliderInput("id",label = "id",min = 1, max= 10,value=1,step =1)
      uiOutput("ui")
    ),
    
    mainPanel(
      plotOutput("vowelPlot")
    )
  )
))