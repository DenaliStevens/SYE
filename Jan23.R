# Create a random order of student for presentations
roster <- tibble("Sam", "Matt", "Kasey", "Denali", "Sierra", "Brianna", "Lupi", "Callie")
library(tidyverse)

roster2 = data.frame(name =c ('Sam', 'Matt', 'Kasey', 'Denali', 'Sierra', 'Brianna', 'Lupi', 'Callie'))

roster2[sample(1:nrow(roster2)),]
