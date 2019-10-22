# **Topics**
#
# * R `ggplot2` package
# * Setup basic plots
# * Add and modify scales and legends
# * Manipulate plot labels
# * Change and create plot themes

# ## Setup
#
# ### Software & materials
#
# You should have R and RStudio installed --- if not:
#
# * Download and install R: <http://cran.r-project.org>
# * Download and install RStudio: <https://www.rstudio.com/products/rstudio/download/#download>
#
# Download materials:
#
# * Download class materials at <https://github.com/IQSS/dss-workshops-redux/raw/master/R/Rgraphics.zip>
# * Extract materials from the zipped directory `Rgraphics.zip` (Right-click => Extract All on Windows, double-click on Mac) and move them to your desktop!
#
# Start RStudio and create a new project:
#
# * On Windows click the start button and search for RStudio. On Mac
#     RStudio will be in your applications folder.
# * In Rstudio go to `File -> New Project`.
# * Choose `Existing Directory` and browse to the `Rgraphics` directory.
# * Choose `File -> Open File` and select the blank version of the `.Rmd` file.
#
# While R's built-in packages are powerful, in recent years there has
# been a big surge in well-designed *contributed packages* for R. 
# In particular, a collection of R packages called 
# [tidyverse](https://www.tidyverse.org/) have been 
# designed specifically for data science. All packages included in 
# `tidyverse` share an underlying design philosophy, grammar, and 
# data structures. We will use `tidyverse` packages throughout the 
# workshop, so let's install them now, together with the `scales` and
# `ggrepel` packages that provide additional functionality to `ggplot2`.

# install.packages("tidyverse")
library(tidyverse)

# install.packages("scales")
library(scales)

# install.packages("ggrepel") 
library(ggrepel)

# We can also install the `rmarkdown` package, which will allow us to
# combine our text and code into a formatted document at the end of 
# the workshop:

# install.packages("rmarkdown")
library(rmarkdown)

# ### Goals
#
# Class Structure and Organization:
#
# * Ask questions at any time. Really!
# * Collaboration is encouraged - please spend a minute introducing yourself to your neighbors!
#
# This is an intermediate R course:
#
# * Assumes working knowledge of R
# * Relatively fast-paced
# * Focus is on `ggplot2` graphics; other packages will not be covered

# ## Why `ggplot2`?
#
# `ggplot2` is a package within in the `tidyverse` suite of packages. Advantages of `ggplot2` include:
#
# * consistent underlying `grammar of graphics` (Wilkinson, 2005)
# * plot specification at a high level of abstraction
# * very flexible
# * theme system for polishing plot appearance
# * mature and complete graphics system
# * many users, active mailing list
#
# That said, there are some things you cannot (or should not) do with `ggplot2`:
#
# * 3-dimensional graphics (see the `rgl` package)
# * Graph-theory type graphs (nodes/edges layout; see the `igraph` package)
# * Interactive graphics (see the `ggvis` package)
#
# ### What is the Grammar Of Graphics?
#
# The basic idea: independently specify plot building blocks and combine them to create just 
# about any kind of graphical display you want. Building blocks of a graph include the
# following (**bold denotes essential elements**):
#
# * **data**
# * **aesthetic mapping**
# * **geometric object**
# * statistical transformations
# * scales
# * coordinate system
# * position adjustments
# * faceting
# * themes

# ### `ggplot2` VS base graphics
#
# Compared to base graphics, `ggplot2`
#
# * is more verbose for simple / canned graphics
# * is less verbose for complex / custom graphics
# * does not have methods (data should always be in a `data.frame`)
# * uses a different system for adding plot elements
# * has sensible defaults for generating legends

# ## Geometric objects & aesthetics
#
# ### Aesthetic mapping
#
# In ggplot land *aesthetic* means "something you can see". Examples include:
#
# * position (i.e., on the x and y axes)
# * color ("outside" color)
# * fill ("inside" color)
# * shape (of points)
# * linetype
# * size
#
# Each type of geom accepts only a subset of all aesthetics; refer to the geom help pages to see what mappings each geom accepts.
# Aesthetic mappings are set with the `aes()` function.
#
# ### Geometric objects (`geom`)
#
# Geometric objects are the actual marks we put on a plot. Examples include:
#
# * points (`geom_point()`, for scatter plots, dot plots, etc.)
# * lines (`geom_line()`, for time series, trend lines, etc.)
# * boxplot (`geom_boxplot()`, for boxplots!)
#
# A plot **must have at least one geom**; there is no upper limit. You can add a geom to a plot using the `+` operator.
#
# Each `geom_` has a particular set of aesthetic mappings associated with it. Some examples are provided below, 
# with required aesthetics in **bold** and optional aesthetics in plain text:
#
# | `geom_`          | Usage             | Aesthetics                                                                      |
# |:-----------------|:------------------|:-----------------------------------------------------------------------------------------|
# | `geom_point()`   | Scatter plot      |**`x`**,**`y`**,`alpha`,`color`,`fill`,`group`,`shape`,`size`,`stroke`                    |
# | `geom_line()`    | Line plot         |**`x`**,**`y`**,`alpha`,`color`,`linetype`,`size`                                         |
# | `geom_bar()`     | Bar chart         |**`x`**,**`y`**,`alpha`,`color`,`fill`,`group`,`linetype`,`size`                          |
# | `geom_boxplot()` | Boxplot           |**`x`**,**`lower`**,**`upper`**,**`middle`**,**`ymin`**,**`ymax`**,`alpha`,`color`,`fill` |
# | `geom_density()` | Density plot      |**`x`**,**`y`**,`alpha`,`color`,`fill`,`group`,`linetype`,`size`,`weight`                 |
# | `geom_smooth()`  | Conditional means |**`x`**,**`y`**,`alpha`,`color`,`fill`,`group`,`linetype`,`size`,`weight`                 |
# | `geom_label()`   | Text              |**`x`**,**`y`**,**`label`**,`alpha`,`angle`,`color`,`family`,`fontface`,`size`            |
#
# You can get a list of all available geometric objects and their associated aesthetics at <https://ggplot2.tidyverse.org/reference/>
#
# or simply type `geom_<tab>` in any good R IDE (such as Rstudio or ESS) to see a list of functions starting with `geom_`.

# #### Points (scatterplot)
#
# Now that we know about geometric objects and aesthetic mapping, we can make a `ggplot()`. `geom_point()` requires mappings for x and y, all others are optional.
#
# **Example data: housing prices**
#
# Let's look at housing prices.

housing <- read_csv("dataSets/landdata-states.csv")
head(housing[1:5])

# create a subset for 1st quarter 2001
hp2001Q1 <- filter(housing, Date == 2001.25)

# **Step 1:** create a blank canvas by specifying data:

ggplot(data = hp2001Q1)

# **Step 2:** specify aesthetic mappings (how you want to map variables to visual aspects):

# here we map "Land_Value" and "Structure_Cost" to the x- and y-axes.
ggplot(data = hp2001Q1, mapping = aes(x = Land_Value, y = Structure_Cost))

# **Step 3:** add new layers of geometric objects that will show up on the plot. 

# here we use geom_point() to add a layer with points (dot) elements as the geometric shapes to represent the data.
ggplot(data = hp2001Q1, mapping = aes(x = Land_Value, y = Structure_Cost)) +
  geom_point()


# #### Lines (prediction line)
#
# A plot constructed with `ggplot()` can have more than one geom. In that case the mappings established in the `ggplot()` call are plot defaults that can be added to or overridden. Our plot could use a regression line:

hp2001Q1$pred_SC <- lm(Structure_Cost ~ log(Land_Value), data = hp2001Q1) %>%
  predict()

p1 <- ggplot(hp2001Q1, aes(x = log(Land_Value), y = Structure_Cost))

p1 + geom_point(aes(color = Home_Value)) +
  geom_line(aes(y = pred_SC))


# #### Smoothers
#
# Not all geometric objects are simple shapes; the smooth geom includes a line and a ribbon.

p1 +
  geom_point(aes(color = Home_Value)) +
  geom_smooth()


# #### Text (label points)
#
# Each geom accepts a particular set of mappings; for example `geom_text()` accepts a `labels` mapping.

p1 + 
  geom_text(aes(label=State), size = 3)


p1 + 
  geom_point() + 
  geom_text_repel(aes(label=State), size = 3)


# ### Aesthetic mapping VS assignment
#
# Note that variables are mapped to aesthetics with the `aes()` function, while fixed aesthetics are set outside the `aes()` call. 
# This sometimes leads to confusion, as in this example:

p1 +
  geom_point(aes(size = 2),# incorrect! 2 is not a variable
             color="red") # this is fine -- all points red


# ### Mapping variables to other aesthetics
#
# Other aesthetics are mapped in the same way as x and y in the previous example.

p1 +
  geom_point(aes(color = Home_Value, shape = region))


# ## Exercise 0
#
# The data for the exercises is available in the `dataSets/EconomistData.csv` file. Read it in with

dat <- read_csv("dataSets/EconomistData.csv")

# Original sources for these data are <http://www.transparency.org/content/download/64476/1031428> <http://hdrstats.undp.org/en/indicators/display_cf_xls_indicator.cfm?indicator_id=103106&lang=en>
#
# These data consist of *Human Development Index* and *Corruption Perception Index* scores for several countries.
#
# 1.  Create a scatter plot with `CPI` on the x axis and `HDI` on the y axis.
# 2.  Color the points blue.
# 3.  Map the color of the the points to `Region`.
# 4.  Make the points bigger by setting size to 2
# 5.  Map the size of the points to `HDI_Rank`

# ## Statistical transformations
#
# ### Why transform data?
#
# Some plot types (such as scatterplots) do not require transformations; each point is plotted at x and y coordinates equal to the original value. Other plots, such as boxplots, histograms, prediction lines etc. require statistical transformations:
#
# * for a boxplot the y values must be transformed to the median and 1.5(IQR)
# * for a smoother the y values must be transformed into predicted values
#
# Each geom has a default statistic, but these can be changed. For example, the default statistic for `geom_histogram()` is `stat_bin()`:

args(geom_histogram)
args(stat_bin)

# Here is a list of geoms and their default statistics <https://ggplot2.tidyverse.org/reference/>

# ### Setting arguments
#
# Arguments to `stat_` functions can be passed through `geom_` functions. This can be slightly annoying because in order to change it you have to first determine which stat the geom uses, then determine the arguments to that stat.
#
# For example, here is the default histogram of Home.Value:

p2 <- ggplot(housing, aes(x = Home_Value))
p2 + geom_histogram()

# can change it by passing the `binwidth` argument to the `stat_bin()` function:

p2 + geom_histogram(stat = "bin", binwidth=4000)


# ### Changing the transformation
#
# Sometimes the default statistical transformation is not what you need. This is often the case with pre-summarized data:

housing_sum <- 
  housing %>%
  group_by(State) %>%
  summarize(Home_Value_Mean = mean(Home_Value)) %>%
  ungroup()

rbind(head(housing_sum), tail(housing_sum))

ggplot(housing_sum, aes(x=State, y=Home_Value_Mean)) + 
  geom_bar()

# What is the problem with the previous plot? Basically we take binned and summarized data and ask ggplot to bin and summarize it again (remember, `geom_bar()` defaults to `stat = stat_count`; obviously this will not work. We can fix it by telling `geom_bar()` to use a different statistical transformation function:

ggplot(housing_sum, aes(x=State, y=Home_Value_Mean)) + 
  geom_bar(stat="identity")


# ## Exercise 1
#
# 1.  Re-create a scatter plot with `CPI` on the x axis and `HDI` on the y axis (as you did in the previous exercise).
# 2.  Overlay a smoothing line on top of the scatter plot using `geom_smooth()`.
# 3.  Overlay a smoothing line on top of the scatter plot using `geom_smooth()`, but use a linear model for the predictions. Hint: see `?stat_smooth`.
# 4.  Overlay a smoothing line on top of the scatter plot using the default *loess* method for `geom_smooth()`, but make it less smooth. Hint: see `?loess`.
# 5.  BONUS: Overlay a smoothing line on top of the scatter plot using `geom_line()`. Hint: change the statistical transformation.
#

# ## Scales
#
# ### Controlling aesthetic mapping
#
# Aesthetic mapping (i.e., with `aes()`) only says that a variable should be mapped to an aesthetic. It doesn't say *how* that should happen. For example, when mapping a variable to *shape* with `aes(shape = x)` you don't say *what* shapes should be used. Similarly, `aes(color = z)` doesn't say *what* colors should be used. Describing what colors/shapes/sizes etc. to use is done by modifying the corresponding *scale*. In `ggplot2` scales include
#
# * position
# * color and fill
# * size
# * shape
# * line type
#
# Scales are modified with a series of functions using a `scale_<aesthetic>_<type>` naming scheme. Try typing `scale_<tab>` to see a list of scale modification functions.
#
# ### Common scale arguments
#
# The following arguments are common to most scales in `ggplot2`:
#
# * **name:** the first argument gives the axis or legend title
# * **limits:** the minimum and maximum of the scale
# * **breaks:** the points along the scale where labels should appear
# * **labels:** the labels that appear at each break
#
# Specific scale functions may have additional arguments; for example, the `scale_color_continuous()` function has arguments `low` and `high` for setting the colors at the low and high end of the scale.
#
# ### Scale modification examples
#
# Start by constructing a dotplot showing the distribution of home values by Date and State.

p4 <- ggplot(housing, aes(x = State, y = Home_Price_Index)) + 
    geom_point(aes(color = Date), alpha = 0.5, size = 1.5,
               position = position_jitter(width = 0.25, height = 0)))


# Now modify the breaks for the color scales

p4 + 
  scale_color_continuous(name="",
                         breaks = c(1976, 1994, 2013),
                         labels = c("'76", "'94", "'13"))

# Next change the low and high values to blue and red:

p4 +
  scale_color_continuous(name="",
                         breaks = c(1976, 1994, 2013),
                         labels = c("'76", "'94", "'13"),
                         low = "blue", high = "red")

# Now mute the colors:

p4 +
  scale_color_continuous(name="",
                         breaks = c(1976, 1994, 2013),
                         labels = c("'76", "'94", "'13"),
                         low = muted("blue"), high = muted("red"))



# ### Using different color scales
#
# `ggplot2` has a wide variety of color scales; here is an example using `scale_color_gradient2()` to interpolate between three different colors.

p4 +
  scale_color_gradient2(name="",
                        breaks = c(1976, 1994, 2013),
                        labels = c("'76", "'94", "'13"),
                        low = muted("blue"),
                        high = muted("red"),
                        mid = "gray60",
                        midpoint = 1994)


# ### Available scales
#
# * Partial combination matrix of available scales
#
# | `scale_`          | Types        |  Examples                   |
# |:------------------|:-------------|:----------------------------|
# | `scale_color_`    | `identity`   | `scale_fill_continuous()`   |
# | `scale_fill_`     | `manual`     | `scale_color_discrete()`    |
# | `scale_size_`     | `continuous` | `scale_size_manual()`       |
# |                   | `discrete`   | `scale_size_discrete()`     |
# |                   |              |                             |
# | `scale_shape_`    | `discrete`   | `scale_shape_discrete()`    |
# | `scale_linetype_` | `identity`   | `scale_shape_manual()`      |
# |                   | `manual`     | `scale_linetype_discrete()` |
# |                   |              |                             |
# | `scale_x_`        | `continuous` | `scale_x_continuous()`      |
# | `scale_y_`        | `discrete`   | `scale_y_discrete()`        |
# |                   | `reverse`    | `scale_x_log()`             |
# |                   | `log`        | `scale_y_reverse()`         |
# |                   | `date`       | `scale_x_date()`            |
# |                   | `datetime`   | `scale_y_datetime()`        |
#
# Note that in RStudio you can type `scale_` followed by `tab` to get the whole list of available scales. 
# For a complete list of available scales see <https://ggplot2.tidyverse.org/reference/>

# ## Exercise 2
#
# 1.  Create a scatter plot with `CPI` on the x axis and `HDI` on the y axis. Color the points to indicate `Region`.
# 2.  Modify the x, y, and color scales so that they have more easily-understood names (e.g., spell out "Human development Index" instead of "HDI"). Hint: see `?scale_x_discrete`.
# 3.  Modify the color scale to use specific values of your choosing. Hint: see `?scale_color_manual`.

# ## Faceting
#
# ### What is faceting?
#
# * Faceting is `ggplot2` parlance for **small multiples**
# * The idea is to create separate graphs for subsets of data
# * `ggplot2` offers two functions for creating small multiples:
#     1.  `facet_wrap()`: define subsets as the levels of a single grouping variable
#     2.  `facet_grid()`: define subsets as the crossing of two grouping variables
# * Facilitates comparison among plots, not just of geoms within a plot
#
# ### What is the trend in housing prices in each state?
#
# * Start by using a technique we already know; map State to color:

p5 <- ggplot(housing, aes(x = Date, y = Home_Value))
p5 + geom_line(aes(color = State))  

# There are two problems here; there are too many states to distinguish each one by color, and the lines obscure one another.
#
# ### Faceting to the rescue
#
# We can remedy the deficiencies of the previous plot by faceting by state rather than mapping state to color.

(p5 <- p5 + geom_line() +
   facet_wrap(~ State, ncol = 10))


# ## Themes
#
# ### What are themes?
#
# The `ggplot2` theme system handles non-data plot elements such as:
#
# * Axis labels
# * Plot background
# * Facet label background
# * Legend appearance
#
# Built-in themes include:
#
# * `theme_gray()` (default)
# * `theme_bw()`
# * `theme_classic()`

p5 + theme_linedraw()

p5 + theme_light()
# You can see a list of available built-in themes here <https://ggplot2.tidyverse.org/reference/>

# ### Overriding theme defaults
#
# Specific theme elements can be overridden using `theme()`. For example:

p5 + theme_minimal() +
  theme(text = element_text(color = "turquoise"))  

# All theme options are documented in `?theme`. We can also see the
# existing default values using:

theme_get()

# ### Creating & saving new themes
#
# You can create new themes, as in the following example:

theme_new <- theme_bw() +
  theme(plot.background = element_rect(size = 1, color = "blue", fill = "black"),
        text=element_text(size = 12, family = "Serif", color = "ivory"),
        axis.text.y = element_text(colour = "purple"),
        axis.text.x = element_text(colour = "red"),
        panel.background = element_rect(fill = "pink"),
        strip.background = element_rect(fill = muted("orange")))

p5 + theme_new

# ## Saving plots
#
# We can save a plot to either a vector (e.g., pdf, eps, ps, svg) 
# or raster (e.g., jpg, png, tiff, bmp, wmf) graphics file using
# the `ggsave()` function:

ggsave(p5, file = "myplot.pdf", device = "pdf", height = 6, width = 6, units = "in")


# ## The #1 FAQ
#
# ### Map aesthetic to different columns
#
# The most frequently asked question goes something like this: *I have two variables in my data.frame, and I'd like to plot them as separate points, with different color depending on which variable it is. How do I do that?*
#
# **Wrong**

housing_byyear <- 
  housing %>%
  group_by(Date) %>%
  summarize(Home_Value_Mean = mean(Home_Value),
            Land_Value_Mean = mean(Land_Value)) %>%
  ungroup()

ggplot(housing_byyear, aes(x=Date)) +
  geom_line(aes(y=Home_Value_Mean), color="red") +
  geom_line(aes(y=Land_Value_Mean), color="blue")

# **Right**

home_land_byyear <- gather(housing_byyear,
                           value = "value",
                           key = "type",
                           Home_Value_Mean, Land_Value_Mean)

ggplot(home_land_byyear, aes(x=Date, y=value, color=type)) +
  geom_line()


# ## Exercise 3
#
# For this exercise, we're going to use the built-in `midwest` dataset:

data("midwest", package = "ggplot2")
head(midwest)

# 1.  Create a scatter plot with `area` on the x axis and the log of `poptotal` on the y axis. 
# 2.  Within the `geom_point()` call, map color to `state`, map size to the log of `popdensity`, and fix transparency (`alpha`) to 0.3.
# 3.  Add a smoother and turn off plotting the confidence interval. Hint: see the `se` argument to `geom_smooth()`.
# 4.  Facet the plot by `state`.
# 5.  BONUS: Change the default theme to `theme_bw()` and modify it so that the axis text and facet label background are blue. Hint: `axis_text` and `strip_background`.
#

# ## Exercise solutions
#
# ### Ex 0: prototype
#
# 1.  Create a scatter plot with CPI on the x axis and HDI on the y axis.

ggplot(dat, aes(x = CPI, y = HDI)) +
  geom_point()

# 2.  Color the points in the previous plot blue.

ggplot(dat, aes(x = CPI, y = HDI)) +
  geom_point(color = "blue")

# 3.  Color the points in the previous plot according to *Region*.

ggplot(dat, aes(x = CPI, y = HDI)) +
  geom_point(aes(color = Region))

# 4.  Make the points bigger by setting size to 2

ggplot(dat, aes(x = CPI, y = HDI)) +
  geom_point(aes(color = Region), size = 2)

# 5.  Map the size of the points to HDI.Rank

ggplot(dat, aes(x = CPI, y = HDI)) +
geom_point(aes(color = Region, size =  HDI_Rank))

# ### Ex 1: prototype
#
# 1.  Re-create a scatter plot with CPI on the x axis and HDI on the y axis (as you did in the previous exercise).

ggplot(dat, aes(x = CPI, y = HDI)) +
  geom_point()

# 2.  Overlay a smoothing line on top of the scatter plot using `geom_smooth`

ggplot(dat, aes(x = CPI, y = HDI)) +
  geom_point() +
  geom_smooth()

# 3.  Overlay a smoothing line on top of the scatter plot using `geom_smooth`, but use a linear model for the predictions. Hint: see `?stat_smooth`.

ggplot(dat, aes(x = CPI, y = HDI)) +
  geom_point() +
  geom_smooth(method = "lm")

# 4.  Overlay a loess (method = "loess") smoothling line on top of the scatter plot using `geom_line`. Hint: change the statistical transformation.

ggplot(dat, aes(x = CPI, y = HDI)) +
  geom_point() +
  geom_line(stat = "smooth", method = "loess")

# 4.  BONUS: Overlay a smoothing line on top of the scatter plot using the *loess* method, but make it less smooth. Hint: see `?loess`.

ggplot(dat, aes(x = CPI, y = HDI)) +
  geom_point() +
  geom_smooth(span = .4)

# ### Ex 2: prototype
#
# 1.  Create a scatter plot with CPI on the x axis and HDI on the y axis. Color the points to indicate region.

ggplot(dat, aes(x = CPI, y = HDI, color = Region)) +
  geom_point()

# 2.  Modify the x, y, and color scales so that they have more easily-understood names (e.g., spell out "Human development Index" instead of "HDI").

ggplot(dat, aes(x = CPI, y = HDI, color = Region)) +
geom_point() +
scale_x_continuous(name = "Corruption Perception Index") +
scale_y_continuous(name = "Human Development Index") +
scale_color_discrete(name = "Region of the world")

# 3.  Modify the color scale to use specific values of your choosing. Hint: see `?scale_color_manual`.

ggplot(dat, aes(x = CPI, y = HDI, color = Region)) +
geom_point() +
scale_x_continuous(name = "Corruption Perception Index") +
scale_y_continuous(name = "Human Development Index") +
  scale_color_manual(name = "Region of the world",
                     values = c("#24576D",
                                "#099DD7",
                                "#28AADC",
                                "#248E84",
                                "#F2583F",
                                "#96503F"))


# ### Ex 3: prototype
#
# 1.  Create a scatter plot with `area` on the x axis and the log of `poptotal` on the y axis. 

p6 <- ggplot(midwest, aes(x=area, y=log(poptotal))) 
p6 + geom_point() 

# 2.  Within the geom_point() call, map color to `state`, map size to the log of `popdensity`, and fix transparency (`alpha`) to 0.3.

p6 <- p6 + geom_point(aes(color=state, size=log(popdensity)), alpha = 0.3) 

# 3.  Add a smoother and turn off plotting the confidence interval. Hint: see the `se` argument to `geom_smooth()`.

p6 <- p6 + geom_smooth(method="loess", se=FALSE) 

# 4.  Facet the plot by `state`.

p6 <- p6 + facet_wrap(~ state)

# 5.  BONUS: Change the default theme to `theme_bw()` and modify it so that the axis text and facet label background are blue. Hint: `axis_text` and `strip_background`.

p6 <- p6 + theme_bw() +
    theme(axis_title = element_text(color = "blue"),
          strip_background = element_text(fill = "blue"))
#

# ## Wrap-up
#
# ### Feedback
#
# These workshops are a work in progress, please provide any feedback to: help@iq.harvard.edu
#
# ### Resources
#
# * IQSS 
#     + Workshops: <https://dss.iq.harvard.edu/workshop-materials>
#     + Data Science Services: <https://dss.iq.harvard.edu/>
#     + Research Computing Environment: <https://iqss.github.io/dss-rce/>
#
# * HBS
#     + Research Computing Services workshops: <https://training.rcs.hbs.org/workshops>
#     + Other HBS RCS resources: <https://training.rcs.hbs.org/workshop-materials>
#     + RCS consulting email: <mailto:research@hbs.edu>
#     
# * ggplot2
#     + Reference: <https://ggplot2.tidyverse.org/reference/>
#     + Cheatsheets: <https://rstudio.com/wp-content/uploads/2019/01/Cheatsheets_2019.pdf>
#     + Examples: <http://r-statistics.co/Top50-Ggplot2-Visualizations-MasterList-R-Code.html>
#     + Tutorial: <https://uc-r.github.io/ggplot_intro>
#     + Mailing list: <http://groups.google.com/group/ggplot2>
#     + Wiki: <https://github.com/hadley/ggplot2/wiki>
#     + Website: <http://had.co.nz/ggplot2/>
#     + StackOverflow: <http://stackoverflow.com/questions/tagged/ggplot>
#