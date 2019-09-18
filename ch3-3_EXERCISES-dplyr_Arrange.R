#"R for Data Science" by Hadley Wickham & Garrett Grolemund
#Chapter 3: "Data Transformation with dplyr" -- EXERCISE PROBLEMS

library(tidyverse)
library(nycflights13)
nycflights13::flights

#Section 3-3:  ARRANGE(rows)


# (Q1)  How could you use arrange() to sort all missing values to the start?   [hint: use is.na()]
arrange(flights, is.na(flight), flight)  ##  ***NOTE*** incorrect code; come back to this one

# (Q2)  Sort flights to find the most delayed flights. Find the flights that left earliest.
arrange(flights, desc(dep_delay))  #most delayed
arrange(flights, dep_delay)   #left the earliest ahead of schedule (aka least delayed)

# (Q3)  Sort flights to find the fastest flights.
arrange(flights, air_time)

# (Q4)  Which flights travelled the longest? Which travelled the shortest?
arrange(flights, desc(distance))  #longest distance
arrange(flights, distance)   #shortest distance
