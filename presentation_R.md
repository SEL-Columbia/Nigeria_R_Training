<link href="http://kevinburke.bitbucket.org/markdowncss/markdown.css" rel="stylesheet"></link>

Extra material
=======

We recommend that at some point soon following this tutorial, you watch the following [video tutorial for R from Google Developer](http://www.youtube.com/watch?v=iffR3fWv4xw&list=PLOU2XLYxmsIK9qQfztXeybpHvru-TrqAP).

Basic R
========================================================

Getting started
----
### Interface of Rstudio

![alt text][R_studio]

[R_studio]: https://lh3.googleusercontent.com/-fFe1VlFiVzA/TWvS0Cuvc3I/AAAAAAAALmk/RfFLB0h5dUM/s1600/rstudio-windows.png

Items:
* Console
* Script
* Environment (will make sense later)
* Help, Plots

### Working directory 

R has a notion of a "working directory". This is the directory that R can load files directly from.


```r
# getting the current working directory
getwd()
```

```
## [1] "/Users/prabhaspokharel/Code/Nigeria_R_Training"
```


```
### setting "my working directory" as "~/work/r/nigeria_r_training/"
setwd("~/work/r/nigeria_r_training/")
```

### Getting help!

Before we get any further, lets see how to get help. You can go to the "Help" tab in R-studio (right-hand-side bottom), or if you know the function to get help on, just use a question mark followed by the function name.
```
?getwd
```

Use two question marks to search for functions if you don't know the name:
```
??workingdirectory
```

### Reading data: read.csv

.csv is the prefered data format in NMIS and in the data science space in general. Although there are functions in R to read other data formats, we recommend that one converts to csv prior to loading. Our motivations for using csv formats are similar to [this article's](http://dataprotocols.org/simple-data-format/#why-csv).


```r
sample_data <- read.csv("sample_health_facilities.csv", stringsAsFactors = FALSE)
```


This command calls read.csv on a filename, with an extra named argument, `stringsAsFactors`. The result is then assigned to sample_data. This command is equivalent to running `sample_data = read.csv(sample_health_facilities.csv, stringsAsFactors=FALSE)`, but the preferred syntax for assignment in R is `<-` (ie, `<` followed by `-`.)

### The sample dataset

The dataset is a subset of our health dataset. We're providing you with a small piece of it, so that we can begin to understand things with small datasets, and eventually move on to the bigger datasets that we handle in the NMIS system. 

Have a look at the [dataset here](https://github.com/SEL-Columbia/Nigeria_R_Training/blob/master/sample_health_facilities.csv), or open it in your favorite spreadsheet program (Excel, OpenOffice). We can also click on the name `sample_data` in the Environment panel on the top-left in R-studio, and we'll see the data rendered the way many other programs do.

Each row is a health clinic, either has a c-section or not, has a number of full-time nurses, has a number of lab techs, a management type, and so on. In our actual datasets, there are hundreds of columns like this.


data.frame
--------------
CSVs represent tabular data, which R is excellent at handling. Turns out that the data we have for NMIS is also tabular data, so we will be working with `data.frame`s in R most of the time.

A data.frame is made up of rows and columns. Lets get the "dimensions" of the data.frame:


```r
dim(sample_data)
```

```
## [1] 50 10
```


This shows that that `sample_data` has 50 rows and 10 columns. The functions `nrow` and `ncol` can give you these values individually:


```r
nrow(sample_data)
```

```
## [1] 50
```

```r
ncol(sample_data)
```

```
## [1] 10
```


### Displaying the data.frame

After loading the data.frame, we often want to know what columns are in it (columns usually have names). To check the column names of a dataset, we can use the `colnames` function, or more simply, the `names` function:


```r
names(sample_data)
```

```
##  [1] "lga"                    "lga_id"                
##  [3] "state"                  "zone"                  
##  [5] "c_section_yn"           "num_nurses_fulltime"   
##  [7] "gps"                    "num_lab_techs_fulltime"
##  [9] "management"             "num_doctors_fulltime"
```


But that just shows us the "headers" of our dataset, not the values. What happens if you just type sample_data into the console? 

Often, seeing the whole dataset is too much. But it is easy to "take a peek" at your dataset by using `head` (which UNIX users may have heard of already):


```r
head(sample_data)
```

```
##           lga lga_id   state          zone c_section_yn
## 1 Barkin-Ladi     91 Plateau North-Central        FALSE
## 2     Anaocha     49 Anambra     Southeast        FALSE
## 3     Batsari     96 Katsina     Northwest        FALSE
## 4        Orlu    611     Imo     Southeast        FALSE
## 5        Guma    258   Benue North-Central        FALSE
## 6    Ayamelum     76 Anambra     Southeast        FALSE
##   num_nurses_fulltime                                           gps
## 1                   0   9.57723376 8.98908176 1285.699951171875 5.0
## 2                   2   6.07903635 7.00366347 276.1000061035156 5.0
## 3                   1  12.91273864 7.31050997 472.3999938964844 5.0
## 4                   0 5.768364071846008 7.061988115310669 241.0 4.0
## 5                   0  7.71806025 8.74342196 147.89999389648438 5.0
## 6                   0  6.481826305389404 6.938955187797546 78.0 6.0
##   num_lab_techs_fulltime management num_doctors_fulltime
## 1                      1     public                    0
## 2                     NA     public                   NA
## 3                      1     public                    0
## 4                      0     public                    0
## 5                      0     public                    0
## 6                      1     public                    1
```



Questions:
 * How many rows of data did we get out?
 * Did you count to get your answer? If you did, how could you get your answer from R?
 * How many columns of data did we get out? How would you check in R?
 * Could you change the number of rows that head outputs? How would you find out?
 * Can you create a new data.frame, called `small_sample`, which is just the first 10 rows of `sample_data`?

### Columns in a data.frame
A column in our data frame is equivalent to either a column in the survey, or a column that we created as a calculation. 
 1. using "$" operator and the column's name (eg. dataframe$col_name)
 2. using the [,] method, or bracket method (eg. dataframe[,'column_name'])

Examples below. Note! We are using small_sample, which is just the first ten rows of sample_data

```r
small_sample <- head(sample_data, 10)
small_sample$lga
```

```
##  [1] "Barkin-Ladi" "Anaocha"     "Batsari"     "Orlu"        "Guma"       
##  [6] "Ayamelum"    "Gamawa"      "Kosofe"      "Bekwara"     "Gurara"
```

```r

small_sample[, "lga"]
```

```
##  [1] "Barkin-Ladi" "Anaocha"     "Batsari"     "Orlu"        "Guma"       
##  [6] "Ayamelum"    "Gamawa"      "Kosofe"      "Bekwara"     "Gurara"
```


We generally prefer the first strategy, but sometimes we'll need to use the second strategy, particularly when working with mulitple columns. Before we go there, though, lets talk about data types in R. Type

```r
str(sample_data)
```

```
## 'data.frame':	50 obs. of  10 variables:
##  $ lga                   : chr  "Barkin-Ladi" "Anaocha" "Batsari" "Orlu" ...
##  $ lga_id                : int  91 49 96 611 258 76 232 441 101 261 ...
##  $ state                 : chr  "Plateau" "Anambra" "Katsina" "Imo" ...
##  $ zone                  : chr  "North-Central" "Southeast" "Northwest" "Southeast" ...
##  $ c_section_yn          : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
##  $ num_nurses_fulltime   : int  0 2 1 0 0 0 0 1 3 0 ...
##  $ gps                   : chr  "9.57723376 8.98908176 1285.699951171875 5.0" "6.07903635 7.00366347 276.1000061035156 5.0" "12.91273864 7.31050997 472.3999938964844 5.0" "5.768364071846008 7.061988115310669 241.0 4.0" ...
##  $ num_lab_techs_fulltime: int  1 NA 1 0 0 1 0 0 2 0 ...
##  $ management            : chr  "public" "public" "public" "public" ...
##  $ num_doctors_fulltime  : int  0 NA 0 0 0 1 0 1 0 0 ...
```

Can anyone guess what this output means?

### Data types in R

Each value is R has a data type, like most languages. Lets see some obvious values first:

```r
class(1)
```

```
## [1] "numeric"
```

```r
class(TRUE)
```

```
## [1] "logical"
```

```r
class("Suya")
```

```
## [1] "character"
```


In R, each column has a single type. Example:

```r
class(sample_data$lga)
```

```
## [1] "character"
```

```r
class(sample_data$num_nurses_fulltime)
```

```
## [1] "integer"
```


The core types in R are:
  1. numerical
  2. integer
  3. boolean
  4. character
  5. factors
    * Generic data type used as alternative to all of the above. We recommend __not__ using excecpt in advanced uses. 
    * Specifically, there are typically challenges with factor => integer/numeric conversions. We'll talk about this later.
    * For additional information on working with factors in your data: [More information on Factors](http://www.statmethods.net/input/datatypes.html)

A note: `NA` or __Not Available__ is a internal value in R, and can be of any type. For example, look at the `num_doctors_fulltime` column:


```r
small_sample$num_doctors_fulltime
```

```
##  [1]  0 NA  0  0  0  1  0  1  0  0
```

```r
class(small_sample$num_doctors_fulltime)
```

```
## [1] "integer"
```


This is incredibly helpful for dealing with survey data. In survey data, NA means 'missing value'. This can happen for many reasons. For example, an enumerator can simply have skipped the question. Or the question may have been skipped because of skip logic (more on that later).

### Rows of a data frame

We have looked at data frame columns so far. Lets look at a row in our dataset. A row in our data set is equavilent to one full survey i.e. one facility (though in this case it is a subset of all the data at the facilty).

NOTE: Indexing starts at 1 in R, not 0. There is no 0th item. 


```r
small_sample[1, ]  # the first row
```

```
##           lga lga_id   state          zone c_section_yn
## 1 Barkin-Ladi     91 Plateau North-Central        FALSE
##   num_nurses_fulltime                                         gps
## 1                   0 9.57723376 8.98908176 1285.699951171875 5.0
##   num_lab_techs_fulltime management num_doctors_fulltime
## 1                      1     public                    0
```

```r
small_sample[5, ]  # the fifth row
```

```
##    lga lga_id state          zone c_section_yn num_nurses_fulltime
## 5 Guma    258 Benue North-Central        FALSE                   0
##                                            gps num_lab_techs_fulltime
## 5 7.71806025 8.74342196 147.89999389648438 5.0                      0
##   management num_doctors_fulltime
## 5     public                    0
```

```r
small_sample[100, ]  # the 100th row, which doesn't exist
```

```
##     lga lga_id state zone c_section_yn num_nurses_fulltime  gps
## NA <NA>     NA  <NA> <NA>           NA                  NA <NA>
##    num_lab_techs_fulltime management num_doctors_fulltime
## NA                     NA       <NA>                   NA
```


Question: what do you think `class(small_sample[1,])` is?

### More slicing and dicing
If you remember, we used the [,] operator before. For a `data.frame`, the [,] operator selects one or more rows or columns. The syntax is `data.frame[row, col]`, though row and col can be many things.

The simplest example; lets get the 4th row and 5th column:

```r
sample_data[4, 5]
```

```
## [1] FALSE
```


In R (like in python), the `:` operator is an operator for making a list of numbers.

```r
1:5
```

```
## [1] 1 2 3 4 5
```

```r
sample_data[4:6, 1:5]
```

```
##        lga lga_id   state          zone c_section_yn
## 4     Orlu    611     Imo     Southeast        FALSE
## 5     Guma    258   Benue North-Central        FALSE
## 6 Ayamelum     76 Anambra     Southeast        FALSE
```


Note that the selectors for our [,] operator don't need to be integers. What do the following do?

```
sample_data[4:6, 'lga']
sample_data[4:6, c('lga', 'zone')]
```

We haven't seen `c` before. What does `c` do?

### Summary statistics

R is also called the "the R project for stastical computing. The power of R is in data analysis and statistics, which is why we are working with it. Lets start exploring some of R's very basic statistic functionalities.

The first set of functions will just give you a simple `summary` of the values in a certain column. There are two useful functions for this:
  * __table()__ should be used for character (string) variables
  * __summary()__ should be used for numerical or boolean variables
  

```r
table(sample_data$zone)
```

```
## 
## North-Central     Northeast     Northwest   South-South     Southeast 
##             7             5            12             9             8 
##     Southwest 
##             9
```

  


```r
summary(sample_data$num_nurses_fulltime)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    0.00    0.00    0.00    1.02    1.00    8.00       3
```

```r
summary(sample_data$c_section_yn)
```

```
##    Mode   FALSE    TRUE    NA's 
## logical      39      10       1
```


Note that `table` can also be used for numeric and categorical variables. 


```r
table(sample_data$num_nurses_fulltime)
```

```
## 
##  0  1  2  3  5  6  7  8 
## 30  6  5  2  1  1  1  1
```

```r
table(sample_data$c_section_yn)
```

```
## 
## FALSE  TRUE 
##    39    10
```


Questions:
 * What is different between table and summary for numerical variables?
 * What is different between table and summary for boolean ('logical') variables?

#### Sums, Mean, Standard Deviation

Calculating the sum is easy, but it does require some care:

```r
sum(sample_data$num_nurses_fulltime)
```

```
## [1] NA
```

```r
sum(sample_data$num_nurses_fulltime, na.rm = TRUE)
```

```
## [1] 48
```

There are many numerical functions that return `NA` unless `na.rm` is passed as true, if there are any NAs in  your data (and in NMIS data, there always are):


```r
mean(sample_data$num_nurses_fulltime, na.rm = T)
```

```
## [1] 1.021
```


What do you think the function for calculating standard deviation is? How would you find out?

Libraries
---------
R is a programming languages, so it allows you to write "modules" or "libraries" that can be distributed to others. These are called packages in R. To install packges in R, use `install.packages` with quoted package name: 
```
install.packages("plyr")
```   

To load the library (similar to `import` in other languages), you use the `library` function:


```r
library(plyr)
```

  
R packages (or libraries) contain additional specialized functions for different purposes. `plyr` is one of our favorites, and contains very useful functions for aggregating data that we will explore soon. Be sure that the package you are trying to load is installed on your computer.

```r
library(eaf)
```

```
## Error: there is no package called 'eaf'
```


Question: what should you do if you see this error?

Creating new data frames from old data frames
---------------------

### Subset
Getting a subset of original data with a handy functions saves a lot of typing


```r
subset(sample_data, lga_id < 500, select = c("lga_id", "lga", "state"))
```

```
##    lga_id             lga       state
## 1      91     Barkin-Ladi     Plateau
## 2      49         Anaocha     Anambra
## 3      96         Batsari     Katsina
## 5     258            Guma       Benue
## 6      76        Ayamelum     Anambra
## 7     232          Gamawa      Bauchi
## 8     441          Kosofe       Lagos
## 9     101         Bekwara Cross River
## 10    261          Gurara       Niger
## 11    359        Ise/Orun       Ekiti
## 15    218      Ezinihitte         Imo
## 17    312          Ihiala     Anambra
## 18    152           Daura     Katsina
## 21    488         Maradun     Zamfara
## 22    396    kaduna South      Kaduna
## 24    452          Kusada     Katsina
## 25     43          Aliero       Kebbi
## 27    191        Ekwusigo     Anambra
## 29    161           Donga      Taraba
## 31    324       Ika South       Delta
## 32    183     Ehime-Mbano         Imo
## 33    142          Damban      Bauchi
## 36    466             Lau      Taraba
## 37    473          Madobi        Kano
## 38    349          Ingawa     Katsina
## 39    223         Faskari     Katsina
## 42    487            Mani     Katsina
## 44    316     Ijebu North        Ogun
## 46     67 Atakunmosa West        Osun
## 47     79          Babura      Jigawa
## 49    304        Ifelodun        Osun
```



### Joining columns:
R supports SQL-like join functionality with `merge`. First lets prepare some data to merge:

```r
data1 <- subset(sample_data, select = -c(zone, gps))
head(data1)
```

```
##           lga lga_id   state c_section_yn num_nurses_fulltime
## 1 Barkin-Ladi     91 Plateau        FALSE                   0
## 2     Anaocha     49 Anambra        FALSE                   2
## 3     Batsari     96 Katsina        FALSE                   1
## 4        Orlu    611     Imo        FALSE                   0
## 5        Guma    258   Benue        FALSE                   0
## 6    Ayamelum     76 Anambra        FALSE                   0
##   num_lab_techs_fulltime management num_doctors_fulltime
## 1                      1     public                    0
## 2                     NA     public                   NA
## 3                      1     public                    0
## 4                      0     public                    0
## 5                      0     public                    0
## 6                      1     public                    1
```

```r
data2 <- unique(subset(sample_data, select = c(state, zone), subset = zone != 
    "Southeast"))
head(data2)
```

```
##         state          zone
## 1     Plateau North-Central
## 3     Katsina     Northwest
## 5       Benue North-Central
## 7      Bauchi     Northeast
## 8       Lagos     Southwest
## 9 Cross River   South-South
```


Inner join:

```r
inner_join <- merge(data1, data2, by = "state")
```


Outer join:

```r
outer_join <- merge(data1, data2, by = "state", all = TRUE)
```


Left outer join:

```r
left_outer_join <- merge(data1, data2, by.x = "state", by.y = "state", all.x = TRUE)
```

Question: what is the between these three data frames?

We can also concatenate two data.frames together, either column-wise (ie, side-by-side) or row-wise (ie, top-and-bottom). Note that the number of rows have to be same in order to combine side-by-side:


```r
cbind(data1, data2)
```

```
## Error: arguments imply differing number of rows: 50, 21
```

```r
cbind(head(data1), head(data2))
```

```
##           lga lga_id   state c_section_yn num_nurses_fulltime
## 1 Barkin-Ladi     91 Plateau        FALSE                   0
## 2     Anaocha     49 Anambra        FALSE                   2
## 3     Batsari     96 Katsina        FALSE                   1
## 4        Orlu    611     Imo        FALSE                   0
## 5        Guma    258   Benue        FALSE                   0
## 6    Ayamelum     76 Anambra        FALSE                   0
##   num_lab_techs_fulltime management num_doctors_fulltime       state
## 1                      1     public                    0     Plateau
## 2                     NA     public                   NA     Katsina
## 3                      1     public                    0       Benue
## 4                      0     public                    0      Bauchi
## 5                      0     public                    0       Lagos
## 6                      1     public                    1 Cross River
##            zone
## 1 North-Central
## 2     Northwest
## 3 North-Central
## 4     Northeast
## 5     Southwest
## 6   South-South
```

Question: Can you break down what the last statement did, one by one?

Row-wise concatenation happens with `rbind`. Again, you need the same rows in both data sets:

```r
data4 <- sample_data[1:5, ]
data5 <- sample_data[6:10, ]
rbind(data4, data5)
```

```
##            lga lga_id       state          zone c_section_yn
## 1  Barkin-Ladi     91     Plateau North-Central        FALSE
## 2      Anaocha     49     Anambra     Southeast        FALSE
## 3      Batsari     96     Katsina     Northwest        FALSE
## 4         Orlu    611         Imo     Southeast        FALSE
## 5         Guma    258       Benue North-Central        FALSE
## 6     Ayamelum     76     Anambra     Southeast        FALSE
## 7       Gamawa    232      Bauchi     Northeast        FALSE
## 8       Kosofe    441       Lagos     Southwest         TRUE
## 9      Bekwara    101 Cross River   South-South        FALSE
## 10      Gurara    261       Niger North-Central        FALSE
##    num_nurses_fulltime                                            gps
## 1                    0    9.57723376 8.98908176 1285.699951171875 5.0
## 2                    2    6.07903635 7.00366347 276.1000061035156 5.0
## 3                    1   12.91273864 7.31050997 472.3999938964844 5.0
## 4                    0  5.768364071846008 7.061988115310669 241.0 4.0
## 5                    0   7.71806025 8.74342196 147.89999389648438 5.0
## 6                    0   6.481826305389404 6.938955187797546 78.0 6.0
## 7                    0  12.27000784 10.52387339 382.6000061035156 5.0
## 8                    1    6.60113991 3.41806628 35.29999923706055 5.0
## 9                    3 6.6513848304748535 8.869051337242126 151.0 4.0
## 10                   0    9.38993463 7.07370386 531.2000122070313 5.0
##    num_lab_techs_fulltime management num_doctors_fulltime
## 1                       1     public                    0
## 2                      NA     public                   NA
## 3                       1     public                    0
## 4                       0     public                    0
## 5                       0     public                    0
## 6                       1     public                    1
## 7                       0     public                    0
## 8                       0       <NA>                    1
## 9                       2     public                    0
## 10                      0     public                    0
```


Use this function with care. If your columns don't align, you'll have a problem:

```r
rbind(data1, data2)
```

```
## Error: numbers of columns of arguments do not match
```


There is a powerful replacement of `rbind` in the __plyr__ package, called `rbind.fill`. With `rbind` you have to make every column in both data.frames exist and allign (ie, have the same index number), but with `rbind.fill` you need not be concerned. `rbind.fill` finds the corresponding column in data.frame2 and concatenates the data, and if there's no corresponding part it assigns __*NA*__. Do be careful though, you might accidentally concatenate the wrong data frames, and instead of complaining, `rbind.fill` will just fill your dataset with NAs.


```r
head(rbind.fill(data1, data2))
```

```
##           lga lga_id   state c_section_yn num_nurses_fulltime
## 1 Barkin-Ladi     91 Plateau        FALSE                   0
## 2     Anaocha     49 Anambra        FALSE                   2
## 3     Batsari     96 Katsina        FALSE                   1
## 4        Orlu    611     Imo        FALSE                   0
## 5        Guma    258   Benue        FALSE                   0
## 6    Ayamelum     76 Anambra        FALSE                   0
##   num_lab_techs_fulltime management num_doctors_fulltime zone
## 1                      1     public                    0 <NA>
## 2                     NA     public                   NA <NA>
## 3                      1     public                    0 <NA>
## 4                      0     public                    0 <NA>
## 5                      0     public                    0 <NA>
## 6                      1     public                    1 <NA>
```


Assignment:
==========
Until tomorrow, please do the following activity:
 * Go to this link (http://bit.ly/1fj3sjD) and download the file into the working directory.
 * Produce a new dataset, which has the following properties:
   * Only those facilities in sample_data that are in the Southern zones of Nigeria should be included.
   * You should incorporate the pop_2006 column from the lgas.csv file into your new dataset. (Hint: your id column is `lga_id`).
   * In the end, you should have a dataset that has only the facilities in the southern zone, and one extra column. ie, You should  have a dataset with 26 rows and 11 columns.
