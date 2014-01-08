Before started
=======

we recommend watch the following video before reading this document
* [Video tutorial for R from Google Developer](http://www.youtube.com/watch?v=iffR3fWv4xw&list=PLOU2XLYxmsIK9qQfztXeybpHvru-TrqAP)

basic R
========================================================

getting started
----
### interface of Rstudio

![alt text][R_studio]

[R_studio]: https://lh3.googleusercontent.com/-fFe1VlFiVzA/TWvS0Cuvc3I/AAAAAAAALmk/RfFLB0h5dUM/s1600/rstudio-windows.png

### set working directory 

```r
# getting the current working directory
getwd()
```

```
## [1] "/Users/salahchafik/Code/Nigeria_R_Training"
```




```r
### setting 'my working directory' as '~/work/r/nigeria_r_training/'
setwd("~/work/r/nigeria_r_training/")
```


### libraries
 * install packages
 * to install packges in R, call __install.packages()__ with quoted package name: 

```r
install.packages("plyr")
```

 * to load libraries in R call __library()__ fucntion
  

```r
library(plyr)
```

  * libraries are additional packages to R that contain additional specialized functions 
  * plyr library is used for aggregating data, which will be explored in detail later

* be sure that the package you are trying to load is installed on your computer

```r
library(eaf)
```

```
## Error: there is no package called 'eaf'
```



### reading data: read.csv
  * csv is the prefered data format in NMIS and in the data science space in general. although there are functions in R to read other data formats, we recommend that one converts to csv prior to loading.  

```r
sample_data <- read.csv("./sample_health_facilities.csv", na.strings = "NA", 
    stringsAsFactors = FALSE)
```

  *stringsAsFactors will be explained later, but for now we recommend always using it
  
### data types: 
  1. numerical
  2. integer
  3. boolean
  4. character
  5. factors
    * generic data type used as alternative to all of the above. we recommend __not__ using. 
    * specifically, there are typically challenges with factor => integer/numeric conversions
    * for additional information on working with factors in your data: [More information on Factors](http://www.statmethods.net/input/datatypes.html)

  6. NA
    * an additional data type in R for value __NOT AVAILABLE__, which can be found in any of the data type above

data.frames
--------------

* a data.frame is made up of: __[rows, columns]__

```r
dim(sample_data)
```

```
## [1] 50 10
```

```r
# dimensions function shows 2000 rows and 104 columns for sample_data
```


### getting names/headers of the data.frame

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



### getting value/column from a data.frame
* a column in our data set is equavilent to a question in the survey
 1. using "$" operator
 2. calling column by it's name directly
 3. note: using head() to show only the first nth elements

```r
sample_data$lga

sample_data[, "lga"]
```



```
##  [1] "Barkin-Ladi" "Anaocha"     "Batsari"     "Orlu"        "Guma"       
##  [6] "Ayamelum"    "Gamawa"      "Kosofe"      "Bekwara"     "Gurara"
```

```
##  [1] "Barkin-Ladi" "Anaocha"     "Batsari"     "Orlu"        "Guma"       
##  [6] "Ayamelum"    "Gamawa"      "Kosofe"      "Bekwara"     "Gurara"
```

* We generally prefer the first strategy, but sometimes we'll need to use the second strategy. Note that spellings have to be exact, and when using the $ notation, you can use tab completion. Try writing sample_data$l and hitting tab, for example. 

### getting row content by calling the row number
 * a row in our data set is equavilent to one full survey i.e. one facility
 * note: index in R starts at 1 instead of 0

```r
sample_data[2, ]
```


```
##       lga lga_id   state      zone c_section_yn num_nurses_fulltime
## 2 Anaocha     49 Anambra Southeast        FALSE                   2
##                                           gps num_lab_techs_fulltime
## 2 6.07903635 7.00366347 276.1000061035156 5.0                     NA
##   management num_doctors_fulltime
## 2     public                   NA
```

### more slicing and dicing in R
* getting the element in 4th row and 5th column

```r
sample_data[4, 5]
```

```
## [1] FALSE
```


* getting the elements from 4th to 6th row and column 1 to column 5(inclusive)

```r
sample_data[4:6, 1:5]
```

```
##        lga lga_id   state          zone c_section_yn
## 4     Orlu    611     Imo     Southeast        FALSE
## 5     Guma    258   Benue North-Central        FALSE
## 6 Ayamelum     76 Anambra     Southeast        FALSE
```


### exploring the data frame with some useful functions
* getting the structure

```r
str(sample_data)
```


* getting the dimension of data.frame

```r
dim(sample_data)
```

```
## [1] 50 10
```


* getting the class of specific column

  * note: class is the type of things in R. In python, this is equivalent to calling type(obj). In javascript, you would use typeof


```r
class(sample_data$lga)
```

```
## [1] "character"
```

```r

class(sample_data[, 1])
```

```
## [1] "character"
```

```r

class(sample_data[, "lga"])
```

```
## [1] "character"
```


* getting the summary/descriptive statistics 

  * __table()__ should be used for character and string variables
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


creating data frames
---------------------

### joining columns:
* R supports SQL-like join functionality with merge()
  *first we'll prepare the data for a merge




```r
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


* inner join

```r
inner_join <- merge(data1, data2, by = "state")
```


* outer join

```r
outer_join <- merge(data1, data2, by = "state", all = TRUE)
```


* left outer join

```r
left_outer_join <- merge(data1, data2, by.x = "lga_id", by.y = "lga_id", all.x = TRUE)
```

```
## Error: 'by' must specify a uniquely valid column
```


* concatenate data.frames COLUMNwise with cbind()
* note that the order of rows in original data is unchanged

```r
cbind(data1, data2)
```


```
## Error: arguments imply differing number of rows: 50, 21
```



* concatenate data.frames ROWise with cbind()
* note that the order of columns in original data is unchanged

```r
data4 <- sample_data[1:5, ]
data5 <- sample_data[6:10, ]
```



```r
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

* use with care: make sure your columns alligns before using, and here is an example of misuse

```r
rbind(data1, data2)
```


```
## Error: numbers of columns of arguments do not match
```

* rbind.fill() is a powerful rbind() realization in __plyr__ package
* with rbind you have to make every column in both data.frames exist and allign(have the same index number), but with rbind.fill you need not be concerned. 
* rbind.fill() finds the corresponding column in data.frame2 and concatenate the data, and if there's no corresponding part it assigns __*NA*__

```r
rbind.fill(data1, data2)
```


```
## Error: undefined columns selected
```


### creating derivative data frames via subset:
* getting a subset of original data with a handy functions saves a lot of typing


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


data cleaning:
----

### type conversion
* type conversion can be forced by __as.\*()__ function
* common __\*__ types you'd encounter are: 
  1. numeric
  2. integer
  3. character
  4. logical
* sometimes you'll encounter __factor__ variables, we recommend using __as.character()__ function to convert it into character type before proceeding 

* here's some examples

```r
my_numbers <- c("1", "2", "3", "4", "5")
my_numbers
```

```
## [1] "1" "2" "3" "4" "5"
```

```r
as.numeric(my_numbers)
```

```
## [1] 1 2 3 4 5
```


creating and deleting columns
--------------
* column creation: simple examples
  * R makes column creation very straightforward by repeating a value which is known as "broadcasting"

```r
sample_data$simple <- "who wants some egusi?"
# a summary of the newly created simple column:
```



```
## [1] "who wants some egusi?" "who wants some egusi?" "who wants some egusi?"
## [4] "who wants some egusi?" "who wants some egusi?" "who wants some egusi?"
```


* creating a column from a vector 

```r
sample_data$simple <- 1:50
# a summary of the newly defined simple column:
```



```
## [1] 1 2 3 4 5 6
```



```r
sample_data$simple <- 1963
# a summary of the newly defined simple column
```



```
## [1] 1963 1963 1963 1963 1963 1963
```




```
  
* column creation: using already existing columns

```r
# a look at the lga column
head(sample_data$lga_id)
```

```
## [1]  91  49  96 611 258  76
```

```r
# creating a new column, by pasting '9ja:' to the values of the lga column
sample_data$lga_id_national <- paste("9ja:", sample_data$lga_id, sep = "")
# a look at the the new lga_id_national column
head(sample_data$lga_id_national)
```

```
## [1] "9ja:91"  "9ja:49"  "9ja:96"  "9ja:611" "9ja:258" "9ja:76"
```


* column creation: boolean columns

```r
sample_data$public <- sample_data$management == "public"
table(sample_data$public)
```

```
## 
## TRUE 
##   33
```

```r

sample_data$public_2_docs <- sample_data$management == "public" & sample_data$num_doctors_fulltime == 
    2
table(sample_data$public_2_docs)
```

```
## 
## FALSE 
##    44
```


* column creation: sum of multiple numerical columns 

```r
sample_data$num_nurselabtechs_fulltime <- rowSums(cbind(sample_data$num_nurses_fulltime, 
    sample_data$num_lab_techs_fulltime, na.rm = T))
```

  

```r
# now we can view all three variables: the new num_nurselabtechs_fulltime
# variable, and the two used to create it
head(subset(sample_data, select = c("num_nurses_fulltime", "num_lab_techs_fulltime", 
    "num_nurselabtechs_fulltime")), 5)
```

```
##   num_nurses_fulltime num_lab_techs_fulltime num_nurselabtechs_fulltime
## 1                   0                      1                          2
## 2                   2                     NA                         NA
## 3                   1                      1                          3
## 4                   0                      0                          1
## 5                   0                      0                          1
```


* removing columns

```r
sample_data$num_nurselabtechs_fulltime <- NULL
# testing to make sure it no longer exists
summary(sample_data$num_nurselabtechs_fulltime)
```

```
## Length  Class   Mode 
##      0   NULL   NULL
```

 
* renaming		

```r
# quote the current variable name, and set it equal the quoted desired name
sample_data <- rename(sample_data, c(gps = "global_positioning_system"))
```




data cleaning
--------------
### string manipulations
* we're going to cover regex suite comes with base R, string_r packages have similar implementations.
* we're not going to cover regex/ regular expression in this tuorial.
* getting position of matched pattern with grep()

```r
my_strings = c("Hello", "World", "Foo")
grep(pattern = "l", x = my_strings, ignore.case = FALSE)
```

```
## [1] 1 2
```

```r
# when value argument is set to true, grep() returns the actual strings
# matchs the patterns
grep(pattern = "l", x = my_strings, ignore.case = FALSE, value = T)
```

```
## [1] "Hello" "World"
```

* find pattern in strings and replace with sub()
* gsub() means global sub, which replace all the occurance of matching pattern, while sub() only works on the first appearance.

```r
my_strings
```

```
## [1] "Hello" "World" "Foo"
```

```r
sub(pattern = "o", replacement = "X", x = my_strings)
```

```
## [1] "HellX" "WXrld" "FXo"
```

```r
gsub(pattern = "o", replacement = "X", x = my_strings)
```

```
## [1] "HellX" "WXrld" "FXX"
```

* change to upper/lower case with toupper()/ tolower()

```r
my_strings
```

```
## [1] "Hello" "World" "Foo"
```

```r
toupper(my_strings)
```

```
## [1] "HELLO" "WORLD" "FOO"
```

```r
tolower(my_strings)
```

```
## [1] "hello" "world" "foo"
```

* concatenate strings with paste():

```r
paste("hello", "world", "foo", sep = ",")
```

```
## [1] "hello,world,foo"
```

* if you're trying to concate every element in a vector/ list, use __collapse__ argument in paste()

```r
paste(my_strings, sep = ",")
```

```
## [1] "Hello" "World" "Foo"
```

```r
paste(my_strings, collapse = ",")
```

```
## [1] "Hello,World,Foo"
```


### writing out data
* R can output multiple different output format, but we're going to cover csv and RDS format
* writing csv file with write.csv()
 * if you find output row.names everytime annoying, set row.names argument to FALSE in write.csv()

```r
write.csv(sample_data, "./my_output.csv", row.names = FALSE)
```

* we recommend output your data as RDS file, if you're only going to reuse it in R.
* use saveRDS() to save object in workspace to your harddrive
  * no row.names argument needs to be used, since we're saving the R object into a binary file

```r
saveRDS(sample_data, "./my_output.RDS")
```

* use readRDS() function to load saved RDS file

```r
readRDS("./my_output.RDS")
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
##    num_nurses_fulltime                      global_positioning_system
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


Aggregations in R:
----
* there are many functions that can do aggregation for you, but we are only going to cover __ddply()__ in __plyr__ package

* creating simple aggregated summary:
* note: 
  1. __(group) by__ variable must have at least one input
  2. you __must__ specify what type of aggregation you want to perform, choose one from: summarize, transform
* [the link to the package dodument](http://cran.r-project.org/web/packages/plyr/plyr.pdf)

```r
library(plyr)
my_summary <- ddply(sample_data, .(state, lga), summarise, counts = length(lga_id), 
    total_num_nurse = sum(num_nurses_fulltime, na.rm = T), avg_c_section = mean(c_section_yn == 
        T, na.rm = T))
head(my_summary)
```

```
##     state           lga counts total_num_nurse avg_c_section
## 1    Abia Umuahia North      1               0             1
## 2 Adamawa      Shelleng      1               2             0
## 3 Anambra       Anaocha      1               2             0
## 4 Anambra      Ayamelum      1               0             0
## 5 Anambra      Ekwusigo      1               0             1
## 6 Anambra        Ihiala      1               2             1
```

* look at the output and compare the difference, the only change here is replacing summarize with transform

```r
my_summary <- ddply(sample_data, .(state, lga), transform, counts = length(lga_id), 
    total_num_nurse = sum(num_nurses_fulltime, na.rm = T), avg_c_section = mean(c_section_yn == 
        T, na.rm = T))
head(my_summary)
```

```
##             lga lga_id   state      zone c_section_yn num_nurses_fulltime
## 1 Umuahia North    728    Abia Southeast         TRUE                  NA
## 2      Shelleng    676 Adamawa Northeast        FALSE                   2
## 3       Anaocha     49 Anambra Southeast        FALSE                   2
## 4      Ayamelum     76 Anambra Southeast        FALSE                   0
## 5      Ekwusigo    191 Anambra Southeast         TRUE                   0
## 6        Ihiala    312 Anambra Southeast         TRUE                   2
##                        global_positioning_system num_lab_techs_fulltime
## 1     5.5224549 7.49361609 175.1999969482422 5.0                     41
## 2 9.884562492370605 12.023136019706726 219.0 4.0                     NA
## 3    6.07903635 7.00366347 276.1000061035156 5.0                     NA
## 4   6.481826305389404 6.938955187797546 78.0 6.0                      1
## 5                5.95802932 6.84972263 148.0 5.0                      0
## 6   5.88475837 6.89508114 110.30000305175781 5.0                      0
##   management num_doctors_fulltime simple lga_id_national public
## 1     public                  308   1963         9ja:728   TRUE
## 2     public                    1   1963         9ja:676   TRUE
## 3     public                   NA   1963          9ja:49   TRUE
## 4     public                    1   1963          9ja:76   TRUE
## 5       <NA>                    1   1963         9ja:191     NA
## 6       <NA>                    1   1963         9ja:312     NA
##   public_2_docs counts total_num_nurse avg_c_section
## 1         FALSE      1               0             1
## 2         FALSE      1               2             0
## 3            NA      1               2             0
## 4         FALSE      1               0             0
## 5         FALSE      1               0             1
## 6         FALSE      1               2             1
```


Advanced R
========================================================

creation of more complex columns(indicators) with __ifelse()__:
-------------------------------------

install packages from outside of cran
-------------------------------------
* in order to install packages on github we need some extra work
* this tutorial will use the example of formhub.R
* first step: install and load __devtools__ package from cran

```r
install.packages("devtools")
```

```
## Error: trying to use CRAN without setting a mirror
```

```r
library(devtools)
```

* second step: use __install_github("repo_name", "user_name")__ function to install packages on github

```r
install_github("formhub.R", username = "SEL-Columbia")
```

```
## Installing github repo(s) formhub.R/master from SEL-Columbia
## Downloading formhub.R.zip from https://github.com/SEL-Columbia/formhub.R/archive/master.zip
## Installing package from /var/folders/zz/lshv3_rj5kq_9bc4m9pp33tc0000gn/T//RtmpqA4mP0/formhub.R.zip
## Installing formhub
## '/Library/Frameworks/R.framework/Resources/bin/R' --vanilla CMD INSTALL  \
##   '/private/var/folders/zz/lshv3_rj5kq_9bc4m9pp33tc0000gn/T/RtmpqA4mP0/formhub.R-master'  \
##   --library='/Library/Frameworks/R.framework/Versions/3.0/Resources/library'  \
##   --with-keep.source --install-tests
```

```r
library(formhub)
```

```
## Loading required package: RJSONIO
## Loading required package: stringr
## Loading required package: RCurl
## Loading required package: bitops
## Loading required package: lubridate
## 
## Attaching package: 'lubridate'
## 
## The following object is masked from 'package:plyr':
## 
##     here
## 
## Loading required package: doBy
## Loading required package: multcomp
## Loading required package: mvtnorm
## Loading required package: survival
## Loading required package: splines
## Loading required package: MASS
## Loading required package: sp
```


map functions: apply()
-----------------------
* instead of using for loops, we encourage using map. The apply/sapply is the implementation of map in R
* Here's the simply example for using apply to loop through every column and see the class of the column
  * note: __MARGIN = 2__ specifies doing column-wise process

```r
apply(sample_data, MARGIN = 2, FUN = class)
```


```
##                       lga                    lga_id 
##               "character"               "character" 
##                     state                      zone 
##               "character"               "character" 
##              c_section_yn       num_nurses_fulltime 
##               "character"               "character" 
## global_positioning_system    num_lab_techs_fulltime 
##               "character"               "character" 
##                management      num_doctors_fulltime 
##               "character"               "character"
```


* you can also define your own function in apply()
* the following code returns sum of __NAs__ in each row
  * note: when you're define your own function in apply use semi-colon as the line marker.
  * note: __MARGIN = 1__ specifies doing row-wise process

```r
apply(sample_data, MARGIN = 1, function(x) {
    na_idx <- is.na(x)
    length(which(na_idx))
})
```


```
##  [1] 0 3 0 0 0 0 0 2 0 0
```


improvements:
-----------------
* load your own functions into workspace with source()

```r
source("./my_source_functions.R")
my_sum(1, 2)
```

```
## [1] 3
```


* optimize ddply with idata.frame()
 * idata.frame optimizes the computation speed but at the cost of a slight more complicated code





