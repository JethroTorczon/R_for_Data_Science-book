##  ggplot2 - a "layered grammer of graphics" approach to data visualization
##___________________________________________________________________________________________
library(tidyverse)
ggplot2::mpg
##___________________________________________________________________________________________
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))
##___________________________________________________________________________________________

# mapping a third variable to an AESTHETIC

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))


ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class))


ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))


ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))


ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

# common ERROR:
ggplot(data = mpg)
+ geom_point(mapping = aes(x = displ, y = hwy))
### the "+" MUST come at the END of the FIRST line (not the start of the second)!!!

##___________________________________________________________________________________________

# FACETS
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)

##___________________________________________________________________________________________

# GEOMETRIC OBJECTS (known as "GEOMS" in ggplot2 syntax)

# scatterplot geom: "_point"
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

# smooth fitted line geom: "_smooth"
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))


ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
    show.legend = FALSE
  )


ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
    geom_smooth(mapping = aes(x = displ, y = hwy))
