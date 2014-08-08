shinyUI(fluidPage(
  titlePanel("FAVE-extract: Results"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Choose a vowel class, and see how its means would
               have looked under different formant settings, compared
               to the FAVE result, which is circled in red."),
     
      checkboxGroupInput("vowel", 
                                     label = h3("Choose a vowel"), 
                                     choices = list("*hr", "ae", "aeh", "ah", "ahr", "aw", "ay", "ay0", 
                                                "e", "ey", "eyF", "eyr", "i", "iw", "iy", "iyF", "iyr", "o", 
                                                "oh", "ow", "owF", "owr", "oy", "Tuw", "u", "uh", "uw", "uwr"),
                                     selected = "ae")
    ),
    
    mainPanel(
      plotOutput("vowelPlot")
    )
  )
))