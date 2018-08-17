library(tidyverse)
library(nycflights13)
nycflights13::flights
filter(flights, month==1, day==1)
jan1 <- filter(flights, month==1, day==1)
(dec25 <- filter(flights, month==12, day==25))
