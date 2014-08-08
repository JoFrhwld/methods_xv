shinyUI(fluidPage(
  titlePanel("FAVE-extract: Remeasurement"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Choose a vowel class to see how the ANAE's distribution for that vowel
               class compares to the speaker's own distribution."),
      selectInput("vowel", 
                  label = "Choose a vowel to display",
                  choices = c("*hr", "ae", "aeh", "ah", "ahr", "aw", "ay", "ay0", 
                              "e", "ey", "eyF", "eyr", "i", "iw", "iy", "iyF", "iyr", "o", 
                              "oh", "ow", "owF", "owr", "oy", "Tuw", "u", "uh", "uw", "uwr"),
                  selected = "ae")),
    
    mainPanel(
      plotOutput("vowelPlot")
    )
)
))