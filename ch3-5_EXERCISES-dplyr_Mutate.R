#"R for Data Science" by Hadley Wickham & Garrett Grolemund
#Chapter 3: "Data Transformation with dplyr" -- EXERCISE PROBLEMS

library(tidyverse)
library(nycflights13)
nycflights13::flights

#Section 3-5:    add new variables with  MUTATE()


# (Q1)  Currently dep_time and sched_dep_time are convenient to look at, but hard to compute with because they're...
##        ...not really continuous numbers. Convert them to a more convenient representation of number of minutes since midnight.

# (Q2)  Compare air_time with arr_time - dep_time. What do you expect to see? What do you see? What do you need to do to fix it?
  
# (Q3)  Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers to be related?
  
# (Q4)  Find the 10 most delayed flights using a ranking function. How do you want to handle ties? Carefully read the documentation for min_rank().

# (Q5)  What does 1:3 + 1:10 return? Why?
  
# (Q6)  What trigonometric functions does R provide?
