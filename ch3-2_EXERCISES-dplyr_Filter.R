#"R for Data Science" by Hadley Wickham & Garrett Grolemund
#Chapter 3: "Data Transformation with dplyr" -- EXERCISE PROBLEMS

library(tidyverse)
library(nycflights13)
nycflights13::flights

#Section 3-2:  FILTER(rows)


# (Q1) Find all flights that:
#   1-a.  Had an arrival delay of two or more hours
filter(flights, arr_delay >= 120)
#   1-b.  Flew to Houston (IAH or HOU)
filter(flights, (dest == "IAH") | (dest == "HOU")) #double check total columns: filter(flights, dest == "HOU") + filter(flights, dest == "IAH")
#   1-c.  Were operated by United, American, or Delta
filter(flights, (carrier == "UA") | (carrier == "AA") | (carrier == "DL"))
#   1-d.  Departed in summer (July, August, and September)
filter(flights, month == 7 | month == 8 | month == 9)   #NOTE: parentheses are NOT required to separate "or" alternatives for the same variable (month)
#   1-e.  Arrived more than two hours late, but didn’t leave late
filter(flights, arr_delay >= 120 & dep_delay <= 0)  #setting dep_delay LESS THAN OR EQUAL TO zero includes all flights that departed ahead of schedule
#   1-f.  Were delayed by at least an hour, but made up over 30 minutes in flight
filter(flights, dep_delay >= 60 & arr_delay <= (dep_delay - 30))  #NOTE: arr_delay must be evaluated relative to each corresponding departure delay
#   1-g.  Departed between midnight and 6am (inclusive)
filter(flights, dep_time >= 0 & dep_time <= 360)


# (Q2) Another useful dplyr filtering helper is between(). What does it do?
##      Can you use  between()  to simplify the code needed to answer the previous challenges?
filter(flights, dep_time == between(0, 360))  #produces an error; does not use "between(x, min, max)" correctly
filter(flights, between(dep_time, 0, 360)) #correctly produces the same answer as determined for Question 1-g


# (Q3) How many flights have a missing dep_time? What other variables are missing? What might these rows represent?
filter(flights, is.na(dep_time))    #this code produces a 8,255 x 19 tibble, so 8,255 flights have a missing dep_time
                                  #the other missing variables:  dep_delay, arr_time, arr_delay, and air_time


# (Q4) Why is NA ^ 0 not missing? Why is NA | TRUE not missing? Why is FALSE & NA not missing?
##      Can you figure out the general rule? (NA * 0 is a tricky counterexample!)
NA ^ 0      #Console output is "1"  because anything raised to the 0th power equals 1
NA | TRUE      #Console output is "TRUE" because of the "or" operator
FALSE & NA      #Console output is "FALSE" because of the "and"
NA * 0      #Console output is "NA" 
0 * NA      #again, output is "NA"
