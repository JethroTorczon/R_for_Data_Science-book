#"R for Data Science" by Hadley Wickham & Garrett Grolemund
#Chapter 3: "Data Transformation with dplyr" -- EXERCISE PROBLEMS

library(tidyverse)
library(nycflights13)
nycflights13::flights

#Section 3-4:  SELECT(columns)


# (Q1)  Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights
select(flights, dep_time, dep_delay, arr_time, arr_delay)
select(flights, dep_time:arr_delay, -(sched_dep_time), -(sched_arr_time))

# (Q2)  What happens if you include the name of a variable multiple times in a select() call?
select(flights, origin, dest, origin, distance, origin)  #included "origin" three times; output only prints it once

# (Q3)  What does the one_of() function do?
#       Why might it be helpful in conjunction with this vector?
#             vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, one_of())    ##   ?????????????   ***come back to this one***

# (Q4)  Does the result of running the following code surprise you?
                select(flights, contains("TIME"))
#       How do the select helpers deal with case by default? How can you change that default?
# ANSWER: the given code outputs every column that includes lowercase "time" in the variable name