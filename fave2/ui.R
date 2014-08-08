shinyUI(fluidPage(
  titlePanel("FAVE-extract: Step 2"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Choose a vowel class, and see how different LPC parameter settings
               for a given token compare to the speaker's distribution for that vowel class.
               The value circled in black has the shortest Mahalanobis distance to the ANAE distribution.
               The value circled in red has the shortes Mahalanobis distance to the speaker's own distribution."),
      selectInput("vowel", 
                  label = "Choose a vowel to display",
                  choices = c("*hr", "ae", "aeh", "ah", "ahr", "aw", "ay", "ay0", 
                              "e", "ey", "eyF", "eyr", "i", "iw", "iy", "iyF", "iyr", "o", 
                              "oh", "ow", "owF", "owr", "oy", "Tuw", "u", "uh", "uw", "uwr"),
                  selected = "ae"),
      selectInput("tokens",
                  label = "Which tokens to display",
                  choices = c("all", "changed"),
                  selected = "all"),
      uiOutput("ui")
    ),
    
    mainPanel(
      plotOutput("vowelPlot")
    )
  )
))