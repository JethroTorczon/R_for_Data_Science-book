library(tidyverse)  #>the first step is always to load tidyverse and any other packages that will be used
library(nycflights13)  #>next, load the relevant dataset
nycflights13::flights  #>loads "flights" data frame from dataset of all flights that departed from New York City in 2013

##___________________________________________________________________________________________
#  FIVE Key "dplyr" Functions:
#    1.  filter()     -  pick observations by their values
#    2.  arrange()    -  reorder the rows
#    3.  select()     -  pick variables by their names
#    4.  mutate()     -  create new variables with functions of existing variables
#    5.  summarize()  -  collapse many values down to a single summary
##___________________________________________________________________________________________

filter(flights, month==1, day==1)  #>selects all flights on January 1st
jan1 <- filter(flights, month==1, day==1)  #>saves the sub-data frame of all flights on January 1st to the variable "jan1"
(dec25 <- filter(flights, month==12, day==25))
#>the previous line saves all flights from December 25th to the variable "dec25" AND automatically prints them

sqrt(2) ^ 2 == 2    #>exemplifies how floating-point numbers make "==" an unreliable test for equality
near(sqrt(2) ^ 2, 2)   #>instead of relying on "==", near(a,b) often makes more sense

filter(flights, month==11 | month==12)  #>finds all flights that departed in November *OR* in December
filter(flights, month== 11 | 12)
#>if you don't type the variable again after "or" it finds all months that equal 11 or 12
#that evaluates to TRUE and (in a numeric context like this) becomes one, so it finds all flights in January

nov_dec <- filter(flights, month %in% c(11,12)) 
#> "x %in% y" selects every row where x (the variable "month" in this case) is one of the values in y (c(11,12))

filter(flights, !(arr_delay > 120 | dep_delay > 120))  #every flight that was NOT delayed by 2+ hours on arrival/departure
#De Morgan's law:  !(x & y) is the same as (!x | !y), and !(x | y) is the same as (!x & !y)
filter(flights, arr_delay <= 120, dep_delay <= 120)

NA > 5  #NAs (missing values, aka "not availables") can make comparisons tricky
10 == NA  #almost any operation involving an unknown value will also be unknown
NA == NA  #if x <- NA and a different variable y <- NA too, then asking if x==y is unknown; thus NA==NA is also unknown
is.na(x)  #determines if the variable  x  is missing a value

##___________________________________________________________________________________________

arrange(flights, year)  #arrange() works similarly to filter() except that instead of selecting rows, it changes their order
arrange(flights, year, month, day)
#each additional column name after the first will be used to break ties in the values of preceding columns
arrange(flights, desc(arr_delay))  #use  desc() to rearrange by the specified column in descending order

##___________________________________________________________________________________________

#select() allows you to focus only on the specified columns, zooming in on a subset and ignoring all other variables
select(flights, year, month, day)
select(flights, year:day)  #selects all columns (inclusive) between year and day
select(flights, -(year:day))  #selects all 16 columns *except* those 3 from year to day inclusive

select(flights, starts_with("A"))  #starts_with() helper function within select()
select(flights, ends_with("A"))  #ends_with() helper function within select()
select(flights, contains("A"))  #contains() helper function within select()
select(flights, matches("(.)\\1"))
#matches() helper function within select(); come back to this after Chapter 11--regular expressions
select(flights, num_range("A", 1:3)) #num_range() helper function within select()

rename(flights, tail_num = tailnum)
#a varient of select() that renames specified columns but still keeps all variables not explicitly mentioned
rename(flights, Hour = hour)  #in this example, "hour" was the original column name, which is now changed to "Hour"
select(flights, dest, air_time, everything())
#the everything() helper allows you to rearrange the remaining columns to come after dest and air_time

##___________________________________________________________________________________________

flights_sml <- select(flights, year:day, ends_with("delay"), distance, air_time)
mutate(flights_sml, gain = arr_delay - dep_delay, speed = distance/air_time * 60)
#mutate() adds columns that are functions of existing columns
mutate(flights_sml,  gain = arr_delay - dep_delay,  hours = air_time/60,  gain_per_hour = gain/hours)
#you can refer to columns that you've just created
transmute(flights_sml,  gain = arr_delay - dep_delay,  hours = air_time/60,  gain_per_hour = gain/hours)
#to only keep the new variables, use transmute()

#arithmetic operators: +, -, *, /, ^
#when one parameter is shorter than the other, it will automatically be extended to the same length
#modular arithmetic allows you to break integers into pieces
#modular arithmetic:   % / % (integer division)   and   %% (remainder),  where  x == y * (x  % / %  y) + (x %% y)
#log(), log2(), log10()
#logarithms are incredibly useful for dealing with data that ranges across multiple orders of magnitude
#lead() and lag()  allow you to refer to leading or lagging values, which helps to compute running differences
#lead() and lag() are most useful in conjunction w/ group_by()
#Cumulative and rolling sums, products, mins, and maxes:  cumsum(), cumprod(), cummin(), and cummax()
#dplyr also includes cummean() for cumulative means
#logical comparisons:  <, <=, >, >=, !=

#ranking functions include min_rank() as well as row_number(), dense_rank(), percent_rank(), cume_dist() and ntile()
y <- c(1,2,2,NA,3,4)  #initiates an example list to demonstrate ranking functions
min_rank(y)  #min_rank() assigns the lowest rank to the lowest values, thus listing each value in ascending order
min_rank(desc(y))  #include desc() around the parameter within min_rank() to list in descending order

##___________________________________________________________________________________________

#summarize() collapses data frame to a single row; na.rm removes missing values pre-computation
summarize(flights, delay = mean(dep_delay, na.rm = TRUE))
#summarize() isn't very useful unless paired with group_by()

##___________________________________________________________________________________________

#pairing summarize() with group_by() changes the unit of analysis from the complete dataset to individual groups
#then, when you use the  dplyr  verbs on a grouped data frame, they will automatically be applied "by group"
by_day <- group_by(flights, year, month, day)  #group_by() and summarize() together are called grouped summaries
summarize(by_day, delay = mean(dep_delay, na.rm = TRUE))
#grouped summaries are one of the most commonly used tools when working with dplyr
##___________________________________________________________________________________________
#before proceeding with grouped summaries, Ch. 3 introduces a powerful new idea: the Pipe
#example (withOUT using the Pipe) to explore relationship between the distance and average delay for each location
by_dest <- group_by(flights, dest)
delay <- summarize(by_dest, count = n(), dist = mean(distance, na.rm = TRUE), delay = mean(arr_delay, na.rm = TRUE))
delay <- filter(delay, count > 20, dest != "HNL")
#there are 3 STEPS to prepare this data:
# 1. GROUP flights BY destination
# 2. SUMMARIZE to compute distance, average delay, and number of flights
# 3. FILTER to remove noisy points and outliers like Honolulu, which is almost twice as far away as the next closest airport

#the code for that previous way of doing the problem is slightly frustrating to write
#it's frustrating because each intermediate data frame requires a name, even though we don't care about it
#there's another way to tackle the same problem by using the Pipe:
delays <- flights %>% group_by(dest
                              ) %>% summarize(count = n(), dist = mean(distance, na.rm = TRUE),
                                                   delay = mean(arr_delay, na.rm = TRUE)
                                             ) %>% filter(count > 20, dest != "HNL")
#the Pipe version is easier to read because it focuses on the transformations, not on what's being transformed
#you can read it as a series of imperative statements: group, then summarize, then filter
#a good way to pronounce   % > %   when reading code is "then"
#behind the scenes,  x %>% f(y)  turns into f(x,y)...   x %>% f(y) %>% g(z)  turns into g(f(x,y), z), and so on

#using the Pipe is a key criterium for belonging to the tidyverse
#  the ONLY tidyverse package that's incompatible with the Pipe is ggplot2, which was written before the Pipe was discovered
#don't forget to set the  na.rm = TRUE  argument, or else you'll get a lot of missing values
#output will be missing values for each NA from the input IF you forget to set that  na.rm = TRUE  argument
flights %>% group_by(year, month, day) %>% summarize(mean = mean(dep_delay, na.rm = TRUE))
#since missing values represent cancelled flights, we could also do this problem by first removing the cancelled flights
not_cancelled <- flights %>% filter(!is.na(dep_delay), !is.na(arr_delay))
#the previous line saves this dataset as "not_cancelled" for reuse in next few examples
not_cancelled %>% group_by(year,month,day) %>% summarize(mean = mean(dep_delay))
#Step 3 (filter) has already been done in Line 110, so Line 112 does Steps 1 (group_by) & 2 (summarize)

#when doing aggregation, it's always smart to include either a count(n()), or a count of nonmissing values (sum(!is.na(x)))
#Counts help prevent drawing conclusions from aggregation that is based on very small amounts of data
#example: identify which planes (by their tail numbers) have the highest average delays:
delays <- not_cancelled %>% group_by(tailnum) %>% summarize(delay = mean(arr_delay))
ggplot(data = delays, mapping = aes(x = delay)) + geom_freqpoly(binwidth = 10)
#some planes have an avg. delay of 5 hrs (300 minutes!), but the story is actually a little more nuanced
#a scatterplot of average delay vs number of flights provides more insight
delays <- not_cancelled %>% group_by(tailnum) %>% summarize(delay = mean(arr_delay, na.rm = TRUE), n = n())
ggplot(data = delays, mapping = aes(x = n, y = delay)) + geom_point(alpha = 1/10)
#unsurprisingly, there's much greater variation in avg. delay when there are fewer flights
#whenever plotting a mean (or other summary) vs. group size, variation will decrease as the sample size increases
#filtering out groups with fewest observations shows more of the pattern and less of the smallest groups' extreme variation
delays %>% filter(n > 25) %>% ggplot(mapping = aes(x = n, y = delay)) + geom_point(alpha = 1/10)

#sometimes it's useful to combine aggregation with logical subsetting (which will be learned on pg. 304 in "Ch. 16: Vectors")
not_cancelled %>% group_by(year,month,day) %>% summarize(avg_delay1 = mean(arr_delay),
                                                         avg_delay2 = mean(arr_delay[arr_delay > 0]))

#means, counts, and sums go a long way, but R provides many other useful summary functions as well
#median(x) is a useful alternative to mean(x)
#the universally accepted measure of spread is sd(x), the standard deviation (aka mean squared deviation)
#interquartile range IQR() and median absolute deviation mad(x) are robust equivalents that may be more useful for outliers
not_cancelled %>% group_by(dest) %>% summarize(distance_sd = sd(distance)) %>% arrange(desc(distance_sd))

#measures of rank include min(x), max(x), and quantile(x, 0.25)
not_cancelled %>% group_by(year,month,day) %>% summarize(first = min(dep_time), last = max(dep_time))
#quantiles are a generalization of the median
#for example, quantile(x, 0.25) finds a value such that x > 25% of the values and less than the remaining 75%

#measures of position include first(x), last(x), nth(x, 2)
not_cancelled %>% group_by(year,month,day) %>% summarize(first_dep = first(dep_time), last_dep = last(dep_time))
#each works similarly to x[1], x[2], and x[length(x)], except they allow default values for positions that don't exist
#these 3 functions are complementary to filtering on ranks; they give all variables, with each observation in a separate row
not_cancelled %>% group_by(year,month,day) %>% mutate(r = min_rank(desc(dep_time))) %>% filter(r %in% range(r))

# n() is a count that takes no arguments and returns the size of the current group
#to count the number of non-missing values, use  sum(!is.na(x))
#to count the number of distinct(unique) values, use n_distinct(x):
#which destinations have the most carriers?
not_cancelled %>% group_by(dest) %>% summarize(carriers = n_distinct(carrier)) %>% arrange(desc(carriers))
not_cancelled %>% count(dest)  #counts are so useful that  dplyr  provides a simple helper if all you want is a count
not_cancelled %>% count(tailnum, wt = distance)
#option: you can provide a weight variable to "count" (sum) the total number of miles a plane flew by using  "wt = "

#when used with numeric functions, TRUE is converted to 1  and  FALSE is converted to 0
#this makes the counts and proportions of logical values  sum(x > 10)  and  mean(y == 0)  very useful
#sum(x) gives the number of TRUEs in x, and mean(x) gives the proportion
not_cancelled %>% group_by(year,month,day) %>% summarize(n_early = sum(dep_time < 500))  #how many flights left before 5am?
#what proportion of flights were delayed by more than an hour?
not_cancelled %>% group_by(year,month,day) %>% summarize(hour_perc = mean(arr_delay > 60))

#when you group_by multiple variables, each summary peels off one level of the grouping
#  ^that makes it easy to progressively roll up a dataset
daily <- group_by(flights,year,month,day)
(per_day <- summarize(daily, flights = n()))
#remember, typing  (parentheses) around the whole assignment expression will output the relevant data
(per_month <- summarize(per_day, flights = sum(flights)))
#uses per_day  within summarize() to assign the new variable per_month
(per_year <- summarize(per_month, flights = sum(flights)))  #uses  per_month  to help assign  per_year
#CAUTION: progressively rolling up summaries is OK for sums & counts, but you *need* to think about weighting means & variances
#it isn't possible to roll up summaries for rank-based stats (like the median)
#the sum of groupwise sums is the overall sum, BUT the median of groupwise medians is NOT the overall median

#to remove grouping, and to return to operations on ungrouped data, use  ungroup()
daily %>% ungroup() %>% summarize(flights = n())  #all flights are no longer grouped by date

#grouping is most useful in conjunction with summarize()
#however, convenient operations can also be done with  mutate()  and  filter()
flights_sml %>% group_by(year,month,day) %>% filter(rank(desc(arr_delay)) < 10)
# ^the above line produces this message:  "Error in eval(lhs, parent, parent) : object 'flights_sml' not found"
popular_dests <- flights %>% group_by(dest) %>% filter(n() > 365)
#remember to initiate the variable with  "<- flights %>% group_by(...)"
popular_dests  #remember, this is how to print the data frame after it was initiated in the previous line
#standardize to compute  per-group  metrics
popular_dests %>% filter(arr_delay > 0) %>% mutate(prop_delay = arr_delay / sum(arr_delay)
                                                  ) %>% select(year:day, dest, arr_delay, prop_delay)
#a grouped filter is a grouped mutate followed by an ungrouped filter
#the author generally avoids grouped filters except for "quick-and-dirty manipulations"
#functions that work most naturally in grouped mutates and filters are known as window functions
#(contrast of window functions vs. the "summary functions" used for summaries)
vignette("window-functions")  #you can learn more about useful "window functions" in this corresponding vignette
