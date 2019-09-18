#"R for Data Science" by Hadley Wickham & Garrett Grolemund
#Chapter 3: "Data Transformation with dplyr" -- EXERCISE PROBLEMS

library(tidyverse)
library(nycflights13)
nycflights13::flights

#Section 3-6:    grouped summaries with  SUMMARIZE()


# (Q1)  Brainstorm at least 5 different ways to assess the typical delay characteristics of a group of flights.
##      Consider the following scenarios:
##          -A flight is 15 minutes early 50% of the time, and 15 minutes late 50% of the time.
##          -A flight is always 10 minutes late.
##          -A flight is 30 minutes early 50% of the time, and 30 minutes late 50% of the time.
##          -99% of the time a flight is on time. 1% of the time it’s 2 hours late.
##      Which is more important: arrival delay or departure delay?


# (Q2)  Come up with another approach that will give you the same output as not_cancelled %>% count(dest) and not_cancelled %>% count(tailnum, wt = distance) (without using count()).

# (Q3)  Our definition of cancelled flights (is.na(dep_delay) | is.na(arr_delay) ) is slightly suboptimal. Why? Which is the most important column?
  
# (Q4)  Look at the number of cancelled flights per day. Is there a pattern? Is the proportion of cancelled flights related to the average delay?
  
# (Q5)  Which carrier has the worst delays? Challenge: can you disentangle the effects of bad airports vs. bad carriers? Why/why not? (Hint: think about flights %>% group_by(carrier, dest) %>% summarise(n()))

# (Q6)  What does the sort argument to count() do. When might you use it?