<link href="http://kevinburke.bitbucket.org/markdowncss/markdown.css" rel="stylesheet"></link>

Day 2
====

Review
------
Assignment review: make a dataset that derives from sample_data and lgas.csv, to create a list of facilities in the Southern zone of Nigeria, as well as the pop_2006 column per LGA. The end results should have 26 rows and 11 columns.
 * Can someone write out the steps necessary?
 * How do we do the subsetting?
 * How do we choose the column to merge by? If you chose `lga`, not `lga_id`, do you see any potential issues?
 * Notice that we wanted the output to only have 11 columns. Did you do the subset before or after merging? For anyone who did it later, what happened to the redundant columns?

Today
-----
 * Adding and removing columns
 * Creating new data.frames using R: `data.frame`
 * Aggregations in R
 * Some basic visualizations tools and techniques
 * Introduction to ggplot2

Adding and removing columns to a data.frame
----
First, lets play a guessing game. Yesterday we learned about the bracket notation in R, but we always have a comma inside the bracket? (Question: what does `sample_data[1,5]` give you?) What do you think happens when you do `sample_data[1]`?


```r
sample_data <- read.csv("sample_health_facilities.csv")
# What do you think sample_data[1] returns?
```


Recall that a data.frame is a "rectangular" object, some number of rows and some number of columns, where each column has the same type. Because each column has the same type, it makes sense to do statistics over columns more often than rows, many data.frame functions are "column-first". Lets learn how to add and remove columns from a `data.frame` object:

Note that sample_data data.frame has 50 rows. So we can construct a 50 row vector to insert as an additional column to the data.frame, and assign it to a column. Its as simple as that!

```r
sample_data$one_to_fifty <- 1:50
head(sample_data[8:11])  # show the head of the last 4 columns
```

```
##   num_lab_techs_fulltime management num_doctors_fulltime one_to_fifty
## 1                      1     public                    0            1
## 2                     NA     public                   NA            2
## 3                      1     public                    0            3
## 4                      0     public                    0            4
## 5                      0     public                    0            5
## 6                      1     public                    1            6
```


Sometimes, you need your dataset to have a constant value. For example, you may want to add a constant column called "country" to your dataset, or maybe it is "sector" (as in, health vs. education vs. water). R makes column creation very straightforward by repeating a value (in R language, this is known as "broadcasting"). When you need a whole column created with the same value, you can use this type of "broadcasting".

```r
sample_data$country <- "Nigeria"
head(sample_data[8:12])
```

```
##   num_lab_techs_fulltime management num_doctors_fulltime one_to_fifty
## 1                      1     public                    0            1
## 2                     NA     public                   NA            2
## 3                      1     public                    0            3
## 4                      0     public                    0            4
## 5                      0     public                    0            5
## 6                      1     public                    1            6
##   country
## 1 Nigeria
## 2 Nigeria
## 3 Nigeria
## 4 Nigeria
## 5 Nigeria
## 6 Nigeria
```


Creating a column from a single value. R allows the user to broadcast numerical values as well:

```r
sample_data$ONE <- 1
head(sample_data[8:13])
```

```
##   num_lab_techs_fulltime management num_doctors_fulltime one_to_fifty
## 1                      1     public                    0            1
## 2                     NA     public                   NA            2
## 3                      1     public                    0            3
## 4                      0     public                    0            4
## 5                      0     public                    0            5
## 6                      1     public                    1            6
##   country ONE
## 1 Nigeria   1
## 2 Nigeria   1
## 3 Nigeria   1
## 4 Nigeria   1
## 5 Nigeria   1
## 6 Nigeria   1
```

  
You can also create columns using other columns. Many functions in R are "vectorized", as in, they work on vectors the same as they work on single values (sometimes called scalars). See, for example, the add (+) function below:

```r
1 + 2
```

```
## [1] 3
```

```r
1:5 + 6:10
```

```
## [1]  7  9 11 13 15
```

```r
head(sample_data[, c("num_nurses_fulltime", "num_doctors_fulltime")])
```

```
##   num_nurses_fulltime num_doctors_fulltime
## 1                   0                    0
## 2                   2                   NA
## 3                   1                    0
## 4                   0                    0
## 5                   0                    0
## 6                   0                    1
```

```r
sample_data$skilled_birth_attendants <- sample_data$num_nurses_fulltime + sample_data$num_doctors_fulltime
head(sample_data[, c("num_nurses_fulltime", "num_doctors_fulltime", "skilled_birth_attendants")])
```

```
##   num_nurses_fulltime num_doctors_fulltime skilled_birth_attendants
## 1                   0                    0                        0
## 2                   2                   NA                       NA
## 3                   1                    0                        1
## 4                   0                    0                        0
## 5                   0                    0                        0
## 6                   0                    1                        1
```

Notice the NA issue. Depending on what that NA means, we may want to zero it out when doing this addition, or leave it as NA. We will get to this topic later on.

Often, we want to create boolean columns in our dataset, for many reasons. We can do this with any function that creates a boolean vector:

```r
sample_data$public <- sample_data$management == "public"
head(sample_data[, c("management", "public")])
```

```
##   management public
## 1     public   TRUE
## 2     public   TRUE
## 3     public   TRUE
## 4     public   TRUE
## 5     public   TRUE
## 6     public   TRUE
```

```r

sample_data$is_public_facility_with_doctor <- sample_data$management == "public" & 
    sample_data$num_doctors_fulltime > 0
head(sample_data[, c("is_public_facility_with_doctor", "management", "num_doctors_fulltime")])
```

```
##   is_public_facility_with_doctor management num_doctors_fulltime
## 1                          FALSE     public                    0
## 2                             NA     public                   NA
## 3                          FALSE     public                    0
## 4                          FALSE     public                    0
## 5                          FALSE     public                    0
## 6                           TRUE     public                    1
```


CAUTION: When you use boolean operators, be sure to use `&` and `|`, not `&&` and `||` . `&&` and `||` are NOT vectorized:

```r
c(FALSE, TRUE) & c(TRUE, TRUE)
```

```
## [1] FALSE  TRUE
```

```r
c(TRUE, FALSE) && c(TRUE, TRUE)
```

```
## [1] TRUE
```


You can also "create" a new column by renaming an old one (rename is a function in the plyr library):

```r
require(plyr)
```

```
## Loading required package: plyr
```

```r
# for the second argument: quote the current variable name, and set it equal
# the quoted desired name
sample_data <- rename(sample_data, c(gps = "global_positioning_system"))
names(sample_data)
```

```
##  [1] "lga"                            "lga_id"                        
##  [3] "state"                          "zone"                          
##  [5] "c_section_yn"                   "num_nurses_fulltime"           
##  [7] "global_positioning_system"      "num_lab_techs_fulltime"        
##  [9] "management"                     "num_doctors_fulltime"          
## [11] "one_to_fifty"                   "country"                       
## [13] "ONE"                            "skilled_birth_attendants"      
## [15] "public"                         "is_public_facility_with_doctor"
```


One way to removing column is to set the column to NULL. 

```r
sample_data$is_public_facility_with_doctor <- NULL
```


Questions: 
 * How would you check to make sure that the column no longer exists?
 * What is another way that we learned in Day 1 that also allows for column deletion?

#### Exercise:
 * Create a new column in sample_data that goes from ten down to 1. Call it `descending_row_name`.
 * Create a new column, called `even_and_no_doctor`, which is TRUE if `descending_row_name` is odd, and there is a doctor in that facility.
 * Hint: Type in `10:1 %% 2` into the R console. What do you get? %% is the "mod" operator, it outputs the remainder when you divide a number by another. Example, `5 %% 2` is 1, `4 %% 2` is 0
 * You can check your answer; there should be 31 FALSE and 19 TRUE values.
 
One final note regarding column creation; be careful about broadcasting. R will broadcast things that you may not expect it to. For example, what do you think will happen if you type in `sample_data$one_two <- c(1:2)`. What happened?

Creating new data.frames using R: `data.frame` function
----
So far, we have created dataframes by reading in csv files. You can also create your data frame using R code. Example:

```r
data.frame(a = c(1, 2, 3), b = c(10, 20, 30))
```

```
##   a  b
## 1 1 10
## 2 2 20
## 3 3 30
```

What is a? What is b? What did we do?

As always, you can also use existing data; in the example below, the column a will be "broadcasted", and the column b will be derived based on pre-existing data.

```r
data.frame(a = "Nigeria", b = head(sample_data)$num_doctors_fulltime * 5)
```

```
##         a  b
## 1 Nigeria  0
## 2 Nigeria NA
## 3 Nigeria  0
## 4 Nigeria  0
## 5 Nigeria  0
## 6 Nigeria  5
```


CAUTION: the stringsAsFactors parameter we saw supplied to read.csv is also available for data.frames, and the default is TRUE. It is a good idea to use stringsAsFactors when using the data.frame, especially if you are creating any non-numeric entries.


```r
example <- data.frame(a = "Nigeria", b = head(sample_data)$num_doctors_fulltime * 
    5)
str(example)
```

```
## 'data.frame':	6 obs. of  2 variables:
##  $ a: Factor w/ 1 level "Nigeria": 1 1 1 1 1 1
##  $ b: num  0 NA 0 0 0 5
```

```r
example <- data.frame(a = "Nigeria", b = head(sample_data)$num_doctors_fulltime * 
    5, stringsAsFactors = FALSE)
str(example)
```

```
## 'data.frame':	6 obs. of  2 variables:
##  $ a: chr  "Nigeria" "Nigeria" "Nigeria" "Nigeria" ...
##  $ b: num  0 NA 0 0 0 5
```

Note that the column `a` is a Factor column in the first example, but character in the second.

Aggregations in R:
----

There are many functions that can do aggregations for you in R; we will cover `ddply()` from the `plyr` package in this tutorial. This is also the function that we have found most useful when writing aggregate indicators for NMIS.
# * creating simple aggregated summary:

#   * note: 
# 1. __(group) by__ variable must have at least one input
# 2. you __must__ specify what type of aggregation you want to perform, choose one from: summarize, transform
# * [the link to the package dodument](http://cran.r-project.org/web/packages/plyr/plyr.pdf)
sample_data <- read.csv("./sample_health_facilities.csv")

library(plyr)
my_summary <- ddply(sample_data, .(state, lga), summarise, 
                    counts = length(lga_id),
                    total_num_nurse = sum(num_nurses_fulltime, na.rm=T),
                    avg_c_section = mean(c_section_yn == T,na.rm=T))
head(my_summary)


# ddply could take by variable in string format which is very handy when you want to use it in a function
my_summary <- ddply(sample_data, c("state", "lga"), summarise, 
                    counts = length(lga_id),
                    total_num_nurse = sum(num_nurses_fulltime, na.rm=T),
                    avg_c_section = mean(c_section_yn == T,na.rm=T))
head(my_summary)

# * look at the output and compare the difference, the only change here is replacing summarize with transform

my_summary <- ddply(sample_data, .(state, lga), transform, 
                    counts = length(lga_id),
                    total_num_nurse = sum(num_nurses_fulltime, na.rm=T),
                    avg_c_section = mean(c_section_yn == T,na.rm=T))
head(my_summary)

# define your own function in ddply
# the syntax is pretty much the same as defining functions in R, except 
# it is CRITICAL to add data.frame() function so that it returns a data.frame
# for each small chunk of data splitted by ddply()

my_summary <- ddply(sample_data, .(state), function(df){
                                            data.frame(
                                              unique_lga_number = nrow(df),
                                              avg_c_section = mean(df$c_section_yn == T,na.rm=T),
                                              avg_c_section_true = length(which(df$c_section_yn))
                                            )
                                            })

# idata.frame
# If you have HUGE amount of data for ddply to aggregate and you find it annoying to wait a long time before seeing the result
# idata.frame is the solution to this, but it comes with the cost of slightly complicated code.

count(sample_data$c_section_yn == T)

Visualizations in R
-----
Okay, now we get to see one of the places where R really shines. The `ggplot2` library is one of the best data visualization libraries out there, when you want to create graphics based on data (the only thing it doesn't do is interactive graphics). It is based on Wilkinson's [grammar of graphics](http://www.amazon.com/Grammar-Graphics-Statistics-Computing/dp/0387245448) and written by [Hadley Wickam](http://had.co.nz), who also wrote `plyr` and several other extremely useful R libraries. In this tutorial, I will use borrow from [Josef Fruehwald's tutorial](http://www.ling.upenn.edu/~joseff/avml2012/#Section_1.1), and make it more relevant to Nigeria data.

 * Question: can anyone remember how to load the `ggplot2` library into their Rstudio environment.
 * What if you got an error (try the import command with ggplot3 instead of ggplot2). Does anyone remember the command for installing the library on your computer?

#### The grammar of graphics. 

ggplot2 is meant to be an implementation of the Grammar of Graphics, hence __gg__ plot. The basic notion is that there is a grammar to the composition of graphical components in statistical graphics. By direcly controlling that grammar, you can generate a large set of carefully constructed graphics from a relatively small set of operations.
 
In fact, when I look back over the span of visualization work I have done in the last year, it is mostly the same graphics I use over and over again: the bar plot, the scatterplot, and the boxplot, with different attribute being mapped to different parts of my graphic. The most important part, always, is thinking about what you want to say with a given graphic, and how different graphical mappings of elements of your data can help convey that message.

#### ggplot2 basics

There are a few basic concepts to wrap your mind around for using ggplot2. First, we construct plots out of layers. Every component of the graph, from the underlying data it's plotting, to the coordinate system it's plotted on, to the statistical summaries overlaid on top, to the axis labels, are layers in the plot. The consequence of this is that your use of ggplot2 will probably involve iterative addition of layer upon layer until you're pleased with the results.

Next, the graphical properties which encode the data you're presenting are the __aesthetics__ of the plot. These include things like

 * x position
 * y position
 * size of elements
 * shape of elements
 * color of elements

The actual graphical elements utilized in a plot are the __geometries__, like

 * points
 * lines
 * line segments
 * bars
 * text
 
Some of these geometries have their own specific aesthetic settings. For example,

 * points
   * point shape
 * text
   * text labels
 * lines
   * line weight (thickness)
   * line type (dotted, dashed, solid)

You'll also frequently want to plot statistics overlaid on top of, or instead of the raw data. Some of these include:

 * Binning (like in histograms)
 * Quartiles (like in boxplots)
 
The aesthetics, geometries and statistics constitute the most important layers of a plot, but for fine tuning a plot for publication, there are a number of other things you'll want to adjust. The most common one of these are the scales, which encompass things like

 * A logarithmic x or y axis
 * Customized color scales
 * Customized point shapes, or linetypes

And finally, there are the "theme" elements, which can be things like:
 
 * Axis labels, titles
 * Theme elements

#### The example
Lets begin with an example that we will re-construct over time. Download [this csv file](https://www.dropbox.com/s/t5d9qobwe00edox/All_774_LGA.csv), and read it into your R workspace. For the tutorial, it will be called `lga_data`. Lets spend a few minutes inspecting the file... what does it contain? Does anyone have a guess to how it was generated?




Here is the plot we will reconstruct over time:
![plot of chunk unnamed-chunk-14](figure/unnamed-chunk-14.png) 


##### The data layer

Every `ggplot2` plot has a data layer, which defines the data set to plot, and the basic mappings of data to aesthetic elements. The data layer created with the functions `ggplot()` and `aes()`, and looks like this

```
ggplot(data, aes(...))
```
The first argument to `ggplot()` is a data frame (it _must_ be a data frame), and its second argument is `aes()`. You're never going to use `aes()` in any other context except for inside of other ggplot2 functions, so it might be best not to think of `aes()` as its own function, but rather as a special way of defining data-to-aesthetic mappings.

I've decided that what I want to explore in this dataset is the number of doctors versus the number of nurses across the different Nigerian zones. Specifically, you'll note that I've chosen the x-axis to be number of nurses, and the y-axis to be the number of doctors. So here is where we begin:


```r
p <- ggplot(lga_data, aes(x = num_nurses, y = num_doctors))
```


Notice that I assigned the output of `ggplot` to a variable `p`. `ggplot` creates `ggplot` objects, which can be printed (just type `p` in the console), or saved to a file, and so on. Right now, actually, if you type p in the console, you won't get an output. Thats because our `ggplot` isn't fully constructed enough to be printed yet. 

#### The geometries layer
The next step, after defining the basic data-to-aesthetic mappings, is to add geometries to the data. We'll discuss geometries in more detail below, but for now, we'll add one of the simplest: points.

```r
p <- p + geom_point()
p
```

```
## Warning: Removed 13 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-16](figure/unnamed-chunk-16.png) 


There are a few things to take away from this step. First and foremost, the way you add new layers, of any kind, to a plot is with the + operator. And, as we'll see in a moment, there's no need to only add them one at a time. You can string together any number of layers to add to a plot, separated by +.

The next thing to notice is that all layers you add to a plot are, technically, functions. We didn't pass any arguments to `geom_point()`, so the resulting plot represents the default behavior: solid black circular points. If for no good reason at all we wanted to use a different point shape in the plot, we could specify it inside of `geom_point()`. (Note: in all the examples below, we'll use the full ggplot statement, so you can see all the elements of the plot right there. Whether you use intermediate objects (like `p` above) is up to you.)

```r
ggplot(lga_data, aes(x = num_nurses, y = num_doctors)) + geom_point(shape = "+")
```

```
## Warning: Removed 13 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-17](figure/unnamed-chunk-171.png) 

```r
ggplot(lga_data, aes(x = num_nurses, y = num_doctors)) + geom_point(color = "red")
```

```
## Warning: Removed 13 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-17](figure/unnamed-chunk-172.png) 


Speaking of defaults, the default of ggplot is to label the x and y axes with the column names from the data frame. I'll inject a bit of best practice advice here, and tell you to always change the axis names. It's nearly guaranteed that your data frame column names will make for very poor axis labels. We'll cover how to do that shortly.

Finally, note that we didn't need to tell geom_point() about the x and y axes. This may seem trivial, but it's a really important, and powerful aspect of ggplot2. When you add any layer at all to a plot, it will inherit the data-to-aesthetic mappings which were defined in the data layer. We'll discuss inheritance, and how to override, or define new data-to-aesthetic mappings within any geom.

#### The statistics layer

The final figure also includes a smoothing line, which is one of many possible statistical layers we can add to a plot.

```r
ggplot(lga_data, aes(x = num_nurses, y = num_doctors)) + geom_point() + geom_smooth(method = "lm")
```

```
## Warning: Removed 13 rows containing missing values (stat_smooth). Warning:
## Removed 13 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-18](figure/unnamed-chunk-18.png) 

                               
We'll skip over the detailed behavior of `stat_smooth()`, but in this plot, the `method='lm'` parameter tells geom_smooth to use a linear model, or a linear regression line (the blue line). The grey semi-transparent ribbon surrounding the line is the 95% confidence interval.

#### Labels

Next, lets change the labels. The x-axis label "num_nurses" is not as good as "Number of Nurses", nor is num_doctors as good as "Number of Doctors". Lets also add a title to the plot, "Number of Nurses vs. Doctors in Nigeria".

```r
ggplot(lga_data, aes(x = num_nurses, y = num_doctors)) + geom_point() + geom_smooth(method = "lm") + 
    labs(x = "Number of Nurses", y = "Number of Doctors", title = "Number of Nurses vs. Doctors in Nigeria")
```

```
## Warning: Removed 13 rows containing missing values (stat_smooth). Warning:
## Removed 13 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-19](figure/unnamed-chunk-19.png) 


#### Limits and scales
If you look at the original plot carefully, you will notice that the limits are very different to what you see right now. In fact, in the original plot, I have only looked at LGAs where the number of doctors and nurses is less than 75. These are the majority of LGAs, and allow us to see the relationship between the doctors and nurses much clearer. The functions for limiting your data (and dropping all the data outside of these limits) are called `xlim` and `ylim`.


```r
ggplot(lga_data, aes(x = num_nurses, y = num_doctors)) + geom_point() + geom_smooth(method = "lm") + 
    labs(x = "Number of Nurses", y = "Number of Doctors", title = "Number of Nurses vs. Doctors in Nigeria") + 
    xlim(0, 75) + ylim(0, 75)
```

```
## Warning: Removed 76 rows containing missing values (stat_smooth). Warning:
## Removed 76 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-20](figure/unnamed-chunk-20.png) 


#### More aesthetics
Remember the different attributes our figure had, in the first image? There was size and there was color. Lets start with color. The color related to the zone of the lga that we were plotting. How would you put that into the graphic? Hint: color is an "aesthetic"


```r
ggplot(lga_data, aes(x = num_nurses, y = num_doctors, color = zone)) + geom_point() + 
    geom_smooth(method = "lm") + labs(x = "Number of Nurses", y = "Number of Doctors", 
    title = "Number of Nurses vs. Doctors in Nigeria") + xlim(0, 75) + ylim(0, 
    75)
```

```
## Warning: Removed 17 rows containing missing values (stat_smooth). Warning:
## Removed 11 rows containing missing values (stat_smooth). Warning: Removed
## 4 rows containing missing values (stat_smooth). Warning: Removed 8 rows
## containing missing values (stat_smooth). Warning: Removed 9 rows
## containing missing values (stat_smooth). Warning: Removed 27 rows
## containing missing values (stat_smooth). Warning: Removed 76 rows
## containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-21](figure/unnamed-chunk-21.png) 


Interesting. Did you notice a side-effect of our addition of color as an aesthetic? All of a sudden, we have six lines, one for each zone, all on top of each other. Notice that the color aesthetic was added to the `ggplot` call. All of the `geom`s inherit the aesthetics that are inside the `ggplot` call. If we want the colors to vary for the points, but leave the line alone, we simply put the color aesthetic inside the `geom_point` function call.

```r
ggplot(lga_data, aes(x = num_nurses, y = num_doctors)) + geom_point(aes(color = zone)) + 
    geom_smooth(method = "lm") + labs(x = "Number of Nurses", y = "Number of Doctors", 
    title = "Number of Nurses vs. Doctors in Nigeria") + xlim(0, 75) + ylim(0, 
    75)
```

```
## Warning: Removed 76 rows containing missing values (stat_smooth). Warning:
## Removed 76 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-22](figure/unnamed-chunk-22.png) 


Certainly interesting, but in order to compare the zones to each other, we have to do something different here.

#### Faceting
In data visualization, there is an idea of [small multiples](https://en.wikipedia.org/wiki/Small_multiple), or in other words, having small but multiple graphics depicting almost the same thing, so that you can look at any individual group, or compare across groups. This idea is implemented in `ggplot` as faceting. There are two methods to allow faceting in `ggplot`; we'll explore the simpler `facet_wrap`. Note that facet functions have a peculiar syntax; the attribute, instead of being inside an `aes` function call, is followed by a tilde(`~`).

```r
ggplot(lga_data, aes(x = num_nurses, y = num_doctors, color = zone)) + geom_point() + 
    geom_smooth(method = "lm") + labs(x = "Number of Nurses", y = "Number of Doctors", 
    title = "Number of Nurses vs. Doctors across zones in Nigeria", color = "Zone") + 
    xlim(0, 75) + ylim(0, 75) + facet_wrap(~zone)
```

```
## Warning: Removed 17 rows containing missing values (stat_smooth). Warning:
## Removed 11 rows containing missing values (stat_smooth). Warning: Removed
## 4 rows containing missing values (stat_smooth). Warning: Removed 8 rows
## containing missing values (stat_smooth). Warning: Removed 9 rows
## containing missing values (stat_smooth). Warning: Removed 27 rows
## containing missing values (stat_smooth). Warning: Removed 17 rows
## containing missing values (geom_point). Warning: Removed 11 rows
## containing missing values (geom_point). Warning: Removed 4 rows containing
## missing values (geom_point). Warning: Removed 8 rows containing missing
## values (geom_point). Warning: Removed 9 rows containing missing values
## (geom_point). Warning: Removed 27 rows containing missing values
## (geom_point).
```

![plot of chunk unnamed-chunk-23](figure/unnamed-chunk-23.png) 

You'll notice that I put the color back into the global `ggplot` aesthetic; I don't care about lines on top of each other because now they are separated into their own chunks. I also added a color label, because the lowercase `zone` looks out of place with the rest of the graph, and modified the title a little bit.

#### Size
Finally, we have to change the size attribute, to correspond to the population of the LGA. How should we do this?


```r
ggplot(lga_data, aes(x = num_nurses, y = num_doctors, color = zone)) + geom_point(aes(size = pop_2006)) + 
    geom_smooth(method = "lm") + labs(x = "Number of Nurses", y = "Number of Doctors", 
    title = "Number of Nurses vs. Doctors across zones in Nigeria", color = "Zone", 
    size = "Population") + xlim(0, 75) + ylim(0, 75) + facet_wrap(~zone)
```

```
## Warning: Removed 17 rows containing missing values (stat_smooth). Warning:
## Removed 11 rows containing missing values (stat_smooth). Warning: Removed
## 4 rows containing missing values (stat_smooth). Warning: Removed 8 rows
## containing missing values (stat_smooth). Warning: Removed 9 rows
## containing missing values (stat_smooth). Warning: Removed 27 rows
## containing missing values (stat_smooth). Warning: Removed 17 rows
## containing missing values (geom_point). Warning: Removed 11 rows
## containing missing values (geom_point). Warning: Removed 4 rows containing
## missing values (geom_point). Warning: Removed 8 rows containing missing
## values (geom_point). Warning: Removed 9 rows containing missing values
## (geom_point). Warning: Removed 27 rows containing missing values
## (geom_point).
```

![plot of chunk unnamed-chunk-24](figure/unnamed-chunk-24.png) 



#### Interpreting the graph

Okay, we have gone plenty deep into learning about `ggplot` and constructing this graph for now. Lets zoom back out to the important bit. What does this graph say about nurses and doctors in Nigeria? What does it say about the different zones? Does it make the point that you think is interesting to make using this data?

### Different types of plots
We took a deep dive into ggplot with one kind of plot, the scatterplot. Scatterplots are useful when the primary thing you want to compare is two numeric values (here: doctors vs. nurses). We also looked at zone and population. But note that the _primary_ relationship that this graph helped us discovered was between two numeric variables. There are a few other kinds of plots that you should be aware of:

#### Histograms
We saw a [histogram](https://en.wikipedia.org/wiki/Histogram) in day one actually. A histogram helps us look at the distribution of a single numeric variable, and is similar to a bar chart. For example, suppose that we just want to look at the number of doctors in Nigeria, and think about how many doctors there are for a given LGA. A great way to do that is to use a histogram:

The geometry for a histogram is called `geom_histogram`, and in its most basic form, all a histogram needs is a variable mapped to the x-axis. Can anyone come up with the code to generate the following histogram?

```
## stat_bin: binwidth defaulted to range/30. Use 'binwidth = x' to adjust
## this.
```

![plot of chunk unnamed-chunk-25](figure/unnamed-chunk-25.png) 


##### Some useful things to do with histograms (and our datasets)
This histogram shows us an extremely left-skewed dataset. We could zoom in to look at the lower part of our data, but another option that `ggplot` also gives us are scale transformations, which allow you to transform the x-axis, for example by using a log10 scale.

```r
ggplot(lga_data, aes(x = num_doctors)) + geom_histogram() + scale_x_log10()
```

```
## stat_bin: binwidth defaulted to range/30. Use 'binwidth = x' to adjust
## this.
```

![plot of chunk unnamed-chunk-26](figure/unnamed-chunk-26.png) 

Notice the scale now. It is highly squished; the distance on the x-axis between 10 and 100 is the same as the distance bewtween 100 and 1000. Also notice that the labels aren't in log, they are in their original form; this is very convenient.

One thing that the Nigeria data is often amenable to is inter-zone comparisons. Lets say, we wanted to change our histogram to be colored by zone. Your first guess might be to use the `color` attribute:

```r
ggplot(lga_data, aes(x = num_doctors, color = zone)) + geom_histogram() + scale_x_log10()
```

```
## stat_bin: binwidth defaulted to range/30. Use 'binwidth = x' to adjust
## this.
```

![plot of chunk unnamed-chunk-27](figure/unnamed-chunk-27.png) 

But turns out that you want to change the `fill` for objects like histograms (and polygons, and boxplots), not the `color` (which is equivalent to the "stroke" of the shape, for graphic artists out there).

```r
ggplot(lga_data, aes(x = num_doctors, fill = zone)) + geom_histogram() + scale_x_log10()
```

```
## stat_bin: binwidth defaulted to range/30. Use 'binwidth = x' to adjust
## this.
```

![plot of chunk unnamed-chunk-28](figure/unnamed-chunk-28.png) 

This can be difficult to interpet, but is sometimes useful.

#### Boxplots
The kind of comparison we just did, comparing a numerical data value (number of doctors) across a categorical attribute (zone) is better done through a [boxplot](https://en.wikipedia.org/wiki/Box_plot). For a boxplot, the x-axis is usually a categorical variable, and the y-axis is a numerical variable.

The geometry is called `geom_boxplot`. Guesses on how to make the following?

```
## Warning: Removed 13 rows containing non-finite values (stat_boxplot).
```

![plot of chunk unnamed-chunk-29](figure/unnamed-chunk-29.png) 

Like with histograms, making the fill equal to the color is most pleasing. And if we wanted to, we could also log-transform the boxplots:

```r
ggplot(lga_data, aes(x = zone, y = num_doctors, fill = zone)) + geom_boxplot() + 
    scale_y_log10()
```

```
## Warning: Removed 96 rows containing non-finite values (stat_boxplot).
```

![plot of chunk unnamed-chunk-30](figure/unnamed-chunk-30.png) 


As always, be careful with log-transformations. It is hard to read numeric values off of log-transformed plots! Often, it is easier to often "zoom in" to the data. 


```r
ggplot(lga_data, aes(x = zone, y = num_doctors, fill = zone)) + geom_boxplot() + 
    ylim(0, 75)
```

```
## Warning: Removed 52 rows containing non-finite values (stat_boxplot).
```

![plot of chunk unnamed-chunk-31](figure/unnamed-chunk-31.png) 

Note that `xlim` and `ylim` should be used with care. They throw out data outside of our limits, which can be dangerous when calculating some summary statistics. The quartiles are not especially sensitive, when the data being thrown out is little. However, a safer alternative is the `coord_cartesian` function.


```r
ggplot(lga_data, aes(x = zone, y = num_doctors, fill = zone)) + geom_boxplot() + 
    coord_cartesian(ylim = c(0, 75))
```

```
## Warning: Removed 13 rows containing non-finite values (stat_boxplot).
```

![plot of chunk unnamed-chunk-32](figure/unnamed-chunk-32.png) 


#### Jitter plots
Boxplots can sometimes hide the data, by "boxing" the values up. Another way to look at data is to make a "jitterplot". Jitterplots are like a geom_point, but the points are randomly "jittered" from their precise position to show a better sense of the spread of the data:


```r
ggplot(lga_data, aes(x = zone, y = num_doctors)) + geom_jitter()
```

```
## Warning: Removed 13 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-33](figure/unnamed-chunk-331.png) 

```r
ggplot(lga_data, aes(x = zone, y = num_doctors)) + geom_jitter() + ylim(0, 100)
```

```
## Warning: Removed 96 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-33](figure/unnamed-chunk-332.png) 


### Exercises:
 * Make a plot to show the relationship between number of primary school students (`avg_num_students_primary`) and number of primary school teachers (`avg_num_tchrs_primary`) in the LGAs of Nigeria. Does this relationship depend on the zone you are in?
 * Make a plot to show the zonal differences in the pupil to teacher ratio in primary schools. You may want to find a suitable cut-off, and drop the values above that.
 * Use another visualization to do the same as the above (ie, look at pupil to toilet ratio in primary schools).
 * Plot just the average number of students in primary school in the LGAs of Nigeria.
 
### More ggplot resources
 * [ggplot2 website](http://ggplot2.org/) and R help (`??ggplot`, etc.) should be your first stop.
 * [The StackOverflow ggplot2 page](http://stackoverflow.com/tags/ggplot2/info) and [questions/answers on the site](http://stackoverflow.com/search?q=%5Br%5D+ggplot) are great resources.
 * [Josef Fruehwald's tutorial](http://www.ling.upenn.edu/~joseff/avml2012/#Section_1.1), which I have borrowed from heavily, is excellent. There are other tutorials on the web, if you google around.
 * If you are interested in data visualizaiton, follow data visualization blogs (google it; there are plenty).
 
