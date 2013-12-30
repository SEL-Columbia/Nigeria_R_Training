Before started
=======

we recommend watch the following video before reading this documenmt
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
## [1] "/home/zaiming/work/r/nigeria_r_training"
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

  2. to load libraries in R call __library()__ fucntion
  

```r
library(plyr)
```

  * libraries are additional packages to R that contain additional specialized functions 
  * plyr library is used for aggregating data, which will be explored in detail later


### reading data: read.csv
  * csv is the prefered data format in NMIS and in the data science space in general. although there are functions in R to read other data formats, we recommend that one converts to csv prior to loading.  

```r
sample_data <- read.csv("./sample_health_facilities.csv", na.strings = "NA", 
    stringsAsFactors = FALSE, skip = 0, nrows = -1)
```

### data types: 
  1. numerical
  2. integer
  3. boolean
  4. character
  5. factors
    * generic data type used as alternative to all of the above. we recommend __not__ using.  
  6. NA
    * an additional data type in R for __value NOT AVAILABLE__, which can be found in any of the data type above

data.frames
--------------

* a data.frame is made up of: __[rows, columns]__

```r
dim(sample_data)
```

```
## [1] 2000  104
```

```r
# dimensions function shows 2000 rows and 104 columns for sample_data
```


### getting names/headers of the data.frame

```r
names(sample_data)
```


```
##  [1] "uuid"                                
##  [2] "lga"                                 
##  [3] "state"                               
##  [4] "zone"                                
##  [5] "lga_id"                              
##  [6] "child_health_yellow_fever_immun_calc"
##  [7] "unique_lga"                          
##  [8] "facility_name"                       
##  [9] "condoms_yn"                          
## [10] "src"
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
##  [1] "Oyun"          "Argungu"       "Osogbo"        "Shomolu"      
##  [5] "Rano"          "Ijebu North"   "Ikono"         "Etung"        
##  [9] "Imeko Afon"    "Southern Ijaw"
```

```
##  [1] "Oyun"          "Argungu"       "Osogbo"        "Shomolu"      
##  [5] "Rano"          "Ijebu North"   "Ikono"         "Etung"        
##  [9] "Imeko Afon"    "Southern Ijaw"
```



### getting row content by calling the row number
 * a row in our data set is equavilent to one full survey i.e. one facility
 * note: index in R starts at 1 instead of 0

```r
sample_data[2, ]
```


```
##                                   uuid     lga state      zone lga_id
## 2 e379e03b-eecf-4342-b197-ee5817c4cf42 Argungu Kebbi Northwest     61
##   child_health_yellow_fever_immun_calc    unique_lga facility_name
## 2                                FALSE kebbi_argungu    dispensary
##   condoms_yn src
## 2      FALSE 661
```

### more slicing and dicing in R
* getting the element in 4th row and 5th column

```r
sample_data[4, 5]
```

```
## [1] 682
```


* getting the elements from 4th to 6th row and column 1 to column 5(inclusive)

```r
sample_data[4:6, 1:5]
```

```
##                                   uuid         lga state      zone lga_id
## 4 b65f44b5-40e2-4c80-9ba3-850bcf18f587     Shomolu Lagos Southwest    682
## 5 e1530640-abfb-4457-aeca-999981770d82        Rano  Kano Northwest    650
## 6 8a7793d6-fd22-4143-b795-5d126c7824e9 Ijebu North  Ogun Southwest    316
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
## [1] 2000  104
```


* getting the class of specific column

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
* works with both column and data.frame

```r
summary(sample_data$zone)
summary(sample_data)
```


```
##    Length     Class      Mode 
##      2000 character character
```

```
##      uuid                 lga                 state            
##  "Length:2000       " "Length:2000       " "Length:2000       "
##  "Class :character  " "Class :character  " "Class :character  "
##  "Mode  :character  " "Mode  :character  " "Mode  :character  "
##  NA                   NA                   NA                  
##  NA                   NA                   NA                  
##  NA                   NA                   NA                  
##  NA                   NA                   NA                  
##      zone                 lga_id      child_health_yellow_fever_immun_calc
##  "Length:2000       " "Min.   :  2  " "Mode :logical  "                   
##  "Class :character  " "1st Qu.:199  " "FALSE:501      "                   
##  "Mode  :character  " "Median :396  " "TRUE :1082     "                   
##  NA                   "Mean   :390  " "NA's :417      "                   
##  NA                   "3rd Qu.:577  " NA                                  
##  NA                   "Max.   :774  " NA                                  
##  NA                   NA              NA                                  
##   unique_lga          facility_name        condoms_yn       
##  "Length:2000       " "Length:2000       " "Mode :logical  "
##  "Class :character  " "Class :character  " "FALSE:830      "
##  "Mode  :character  " "Mode  :character  " "TRUE :549      "
##  NA                   NA                   "NA's :621      "
##  NA                   NA                   NA               
##  NA                   NA                   NA               
##  NA                   NA                   NA               
##      src             
##  "Length:2000       "
##  "Class :character  "
##  "Mode  :character  "
##  NA                  
##  NA                  
##  NA                  
##  NA
```



* table of content of COLUMN

```r
table(sample_data$zone)
```

```
## 
## North-Central     Northeast     Northwest     Southeast   South-South 
##           500           253           398           220           245 
##     Southwest 
##           384
```


creating data frames
---------------------

### joining columns:
* R supports SQL-like join functionality with merge()



* inner join

```r
inner_join <- merge(data1, data2, by = "lga_id")
```


* outer join

```r
outer_join <- merge(data1, data2, by = "lga_id", all = TRUE)
```


* left outer join

```r
left_outer_join <- merge(data1, data2, by.x = "lga_id", by.y = "lga_id", all.x = TRUE)
```


* concatenate data.frames COLUMNwise with cbind()
* note that the order of rows in original data is unchanged

```r
cbind(data1, data3)
```


```
##                                    uuid lga_id
## 1  365527d0-79f5-4a8e-9137-de52db578660    640
## 2  e379e03b-eecf-4342-b197-ee5817c4cf42     61
## 3  50d376a7-6599-48ec-97f3-4b131ea601cf    625
## 4  b65f44b5-40e2-4c80-9ba3-850bcf18f587    682
## 5  e1530640-abfb-4457-aeca-999981770d82    650
## 6  8a7793d6-fd22-4143-b795-5d126c7824e9    316
## 7  2e167e67-56e7-49ba-b7ab-0c33ac3c3f06    331
## 8  12936a94-f3a4-43ff-8af4-e266686375d6    215
## 9  41a8f161-164d-46d8-b344-c3e67c38122d    348
## 10     3c3de9dcf32e9595596170469cda8de5    688
##    child_health_yellow_fever_immun_calc            unique_lga
## 1                                 FALSE            kwara_oyun
## 2                                 FALSE         kebbi_argungu
## 3                                    NA           osun_osogbo
## 4                                    NA         lagos_shomolu
## 5                                  TRUE             kano_rano
## 6                                  TRUE      ogun_ijebu_north
## 7                                  TRUE       akwa_ibom_ikono
## 8                                  TRUE     cross_river_etung
## 9                                 FALSE       ogun_imeko_afon
## 10                                 TRUE bayelsa_southern_ijaw
##                               facility_name condoms_yn src
## 1  Falokun Owode basic health center ikotun       TRUE 661
## 2                                dispensary      FALSE 661
## 3                    HONESTY MEDICAL CENTRE         NA 661
## 4                                 De-debajo         NA 661
## 5                     Kazaurawa health post      FALSE 661
## 6                        Mamu health centre       TRUE 661
## 7                  Ikot Idaha Health centre       TRUE 661
## 8                COMM. HEALTH CARE (CENTRE)       TRUE 661
## 9                          Maternity centre      FALSE 661
## 10              Comprehensive health centre         NA 113
##    inpatient_care_yn tb_treatment_yn medication_folic_acid
## 1              FALSE           FALSE                  TRUE
## 2              FALSE           FALSE                    NA
## 3               TRUE           FALSE                  TRUE
## 4               TRUE            TRUE                  TRUE
## 5              FALSE           FALSE                    NA
## 6               TRUE           FALSE                  TRUE
## 7               TRUE           FALSE                  TRUE
## 8               TRUE           FALSE                  TRUE
## 9              FALSE           FALSE                  TRUE
## 10              TRUE           FALSE                  TRUE
```



* concatenate data.frames ROWise with cbind()
* note that the order of columns in original data is unchanged

```r
rbind(data4, data5)
```


```
##                                    uuid           lga       state
## 1  365527d0-79f5-4a8e-9137-de52db578660          Oyun       Kwara
## 2  e379e03b-eecf-4342-b197-ee5817c4cf42       Argungu       Kebbi
## 3  50d376a7-6599-48ec-97f3-4b131ea601cf        Osogbo        Osun
## 4  b65f44b5-40e2-4c80-9ba3-850bcf18f587       Shomolu       Lagos
## 5  e1530640-abfb-4457-aeca-999981770d82          Rano        Kano
## 6  8a7793d6-fd22-4143-b795-5d126c7824e9   Ijebu North        Ogun
## 7  2e167e67-56e7-49ba-b7ab-0c33ac3c3f06         Ikono   Akwa Ibom
## 8  12936a94-f3a4-43ff-8af4-e266686375d6         Etung Cross River
## 9  41a8f161-164d-46d8-b344-c3e67c38122d    Imeko Afon        Ogun
## 10     3c3de9dcf32e9595596170469cda8de5 Southern Ijaw     Bayelsa
##             zone lga_id child_health_yellow_fever_immun_calc
## 1  North-Central    640                                FALSE
## 2      Northwest     61                                FALSE
## 3      Southwest    625                                   NA
## 4      Southwest    682                                   NA
## 5      Northwest    650                                 TRUE
## 6      Southwest    316                                 TRUE
## 7    South-South    331                                 TRUE
## 8    South-South    215                                 TRUE
## 9      Southwest    348                                FALSE
## 10   South-South    688                                 TRUE
##               unique_lga                            facility_name
## 1             kwara_oyun Falokun Owode basic health center ikotun
## 2          kebbi_argungu                               dispensary
## 3            osun_osogbo                   HONESTY MEDICAL CENTRE
## 4          lagos_shomolu                                De-debajo
## 5              kano_rano                    Kazaurawa health post
## 6       ogun_ijebu_north                       Mamu health centre
## 7        akwa_ibom_ikono                 Ikot Idaha Health centre
## 8      cross_river_etung               COMM. HEALTH CARE (CENTRE)
## 9        ogun_imeko_afon                         Maternity centre
## 10 bayelsa_southern_ijaw              Comprehensive health centre
##    condoms_yn src
## 1        TRUE 661
## 2       FALSE 661
## 3          NA 661
## 4          NA 661
## 5       FALSE 661
## 6        TRUE 661
## 7        TRUE 661
## 8        TRUE 661
## 9       FALSE 661
## 10         NA 113
```

* use with care: make sure your columns alligns before using, and here is an example of miss-use

```r
rbind(data1, data3)
```


```
## Error: numbers of columns of arguments do not match
```

* rbind.fill() a powerful rbind() realization in __plyr__ package
* with rbind you have to make every column in both data.frame exists and alligns(have the same index number), but with rbind.fill you don't have to worry about it
* rbind.fill() finds the corresponding column in data.frame2 and concatenate the data, and if there's no corresponding part is assigns __*NA*__

```r
rbind.fill(data1, data3)
```


```
##                                    uuid lga_id
## 1  365527d0-79f5-4a8e-9137-de52db578660    640
## 2  e379e03b-eecf-4342-b197-ee5817c4cf42     61
## 3  50d376a7-6599-48ec-97f3-4b131ea601cf    625
## 4  b65f44b5-40e2-4c80-9ba3-850bcf18f587    682
## 5  e1530640-abfb-4457-aeca-999981770d82    650
## 6  8a7793d6-fd22-4143-b795-5d126c7824e9    316
## 7  2e167e67-56e7-49ba-b7ab-0c33ac3c3f06    331
## 8  12936a94-f3a4-43ff-8af4-e266686375d6    215
## 9  41a8f161-164d-46d8-b344-c3e67c38122d    348
## 10     3c3de9dcf32e9595596170469cda8de5    688
##    child_health_yellow_fever_immun_calc            unique_lga
## 1                                 FALSE            kwara_oyun
## 2                                 FALSE         kebbi_argungu
## 3                                    NA           osun_osogbo
## 4                                    NA         lagos_shomolu
## 5                                  TRUE             kano_rano
## 6                                  TRUE      ogun_ijebu_north
## 7                                  TRUE       akwa_ibom_ikono
## 8                                  TRUE     cross_river_etung
## 9                                 FALSE       ogun_imeko_afon
## 10                                 TRUE bayelsa_southern_ijaw
##                               facility_name condoms_yn src
## 1  Falokun Owode basic health center ikotun       TRUE 661
## 2                                dispensary      FALSE 661
## 3                    HONESTY MEDICAL CENTRE         NA 661
## 4                                 De-debajo         NA 661
## 5                     Kazaurawa health post      FALSE 661
## 6                        Mamu health centre       TRUE 661
## 7                  Ikot Idaha Health centre       TRUE 661
## 8                COMM. HEALTH CARE (CENTRE)       TRUE 661
## 9                          Maternity centre      FALSE 661
## 10              Comprehensive health centre         NA 113
##    inpatient_care_yn tb_treatment_yn medication_folic_acid
## 1              FALSE           FALSE                  TRUE
## 2              FALSE           FALSE                    NA
## 3               TRUE           FALSE                  TRUE
## 4               TRUE            TRUE                  TRUE
## 5              FALSE           FALSE                    NA
## 6               TRUE           FALSE                  TRUE
## 7               TRUE           FALSE                  TRUE
## 8               TRUE           FALSE                  TRUE
## 9              FALSE           FALSE                  TRUE
## 10              TRUE           FALSE                  TRUE
```


### creating derivative data frames via subset:
* getting a subset of original data with handy functions saves a lot of typing
* campare the two outputs

```r
subset(sample_data, lga_id < 600, select = c("lga_id", "lga", "state"))

sample_data[sample_data$lga_id < 600, c("lga_id", "lga", "state")]
```



```
##    lga_id               lga       state
## 2      61           Argungu       Kebbi
## 6     316       Ijebu North        Ogun
## 7     331             Ikono   Akwa Ibom
## 8     215             Etung Cross River
## 9     348        Imeko Afon        Ogun
## 11    589              Okpe       Delta
## 12    450              Kura        Kano
## 15    389          Jos East     Plateau
## 16    453             Kwali         FCT
## 17    364 Isiala Ngwa South        Abia
```

```
##    lga_id               lga       state
## 2      61           Argungu       Kebbi
## 6     316       Ijebu North        Ogun
## 7     331             Ikono   Akwa Ibom
## 8     215             Etung Cross River
## 9     348        Imeko Afon        Ogun
## 11    589              Okpe       Delta
## 12    450              Kura        Kano
## 15    389          Jos East     Plateau
## 16    453             Kwali         FCT
## 17    364 Isiala Ngwa South        Abia
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
my_numbers = c("1", "2", "3", "4", "5")
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

```r
sample_data$simple <- "who wants some egusi?"
# a summary of the newly created simple column
head(sample_data$simple)
```

```
## [1] "who wants some egusi?" "who wants some egusi?" "who wants some egusi?"
## [4] "who wants some egusi?" "who wants some egusi?" "who wants some egusi?"
```

```r

sample_data$simple <- 1963
# a summary of the newly defined simple column
head(sample_data$simple)
```

```
## [1] 1963 1963 1963 1963 1963 1963
```

  
* column creation: using already existing columns

```r
# a look at the lga column
head(sample_data$lga_id)
```

```
## [1] 640  61 625 682 650 316
```

```r
# creating a new column, by pasting '9ja:' to the values of the lga column
sample_data$lga_id_national <- paste("9ja:", sample_data$lga_id, sep = "")
# a look at the the new lga_id_national column
head(sample_data$lga_id_national)
```

```
## [1] "9ja:640" "9ja:61"  "9ja:625" "9ja:682" "9ja:650" "9ja:316"
```


* column creation: boolean columns

```r
sample_data$public <- sample_data$management == "public"
table(sample_data$public)
```

```
## 
## FALSE  TRUE 
##    49  1493
```

```r

sample_data$public_2_docs <- sample_data$management == "public" & sample_data$num_doctors_fulltime == 
    2
table(sample_data$public_2_docs)
```

```
## 
## FALSE  TRUE 
##  1803     9
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
## 1                   0                      0                          1
## 2                  NA                     NA                         NA
## 3                   0                      0                          1
## 4                   4                      0                          5
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
 * if you find output row.names everything annoying, set row.names argument to FALSE in write.csv()

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
##                                    uuid           lga       state
## 1  365527d0-79f5-4a8e-9137-de52db578660          Oyun       Kwara
## 2  e379e03b-eecf-4342-b197-ee5817c4cf42       Argungu       Kebbi
## 3  50d376a7-6599-48ec-97f3-4b131ea601cf        Osogbo        Osun
## 4  b65f44b5-40e2-4c80-9ba3-850bcf18f587       Shomolu       Lagos
## 5  e1530640-abfb-4457-aeca-999981770d82          Rano        Kano
## 6  8a7793d6-fd22-4143-b795-5d126c7824e9   Ijebu North        Ogun
## 7  2e167e67-56e7-49ba-b7ab-0c33ac3c3f06         Ikono   Akwa Ibom
## 8  12936a94-f3a4-43ff-8af4-e266686375d6         Etung Cross River
## 9  41a8f161-164d-46d8-b344-c3e67c38122d    Imeko Afon        Ogun
## 10     3c3de9dcf32e9595596170469cda8de5 Southern Ijaw     Bayelsa
##             zone lga_id child_health_yellow_fever_immun_calc
## 1  North-Central    640                                FALSE
## 2      Northwest     61                                FALSE
## 3      Southwest    625                                   NA
## 4      Southwest    682                                   NA
## 5      Northwest    650                                 TRUE
## 6      Southwest    316                                 TRUE
## 7    South-South    331                                 TRUE
## 8    South-South    215                                 TRUE
## 9      Southwest    348                                FALSE
## 10   South-South    688                                 TRUE
##               unique_lga                            facility_name
## 1             kwara_oyun Falokun Owode basic health center ikotun
## 2          kebbi_argungu                               dispensary
## 3            osun_osogbo                   HONESTY MEDICAL CENTRE
## 4          lagos_shomolu                                De-debajo
## 5              kano_rano                    Kazaurawa health post
## 6       ogun_ijebu_north                       Mamu health centre
## 7        akwa_ibom_ikono                 Ikot Idaha Health centre
## 8      cross_river_etung               COMM. HEALTH CARE (CENTRE)
## 9        ogun_imeko_afon                         Maternity centre
## 10 bayelsa_southern_ijaw              Comprehensive health centre
##    condoms_yn src
## 1        TRUE 661
## 2       FALSE 661
## 3          NA 661
## 4          NA 661
## 5       FALSE 661
## 6        TRUE 661
## 7        TRUE 661
## 8        TRUE 661
## 9       FALSE 661
## 10         NA 113
```


Aggregations in R:
----
* there are many functions that can do aggregation for you, but we are only going to cover __ddply()__ in __plyr__ package

* creating simple aggregated summary:
* note: 
  1. __(group) by__ variable must have at least one input
  2. you __must__ specify what type of aggregation you want to perform, choose one from: summarize, transform

```r
library(plyr)
my_summary <- ddply(sample_data, .(state, lga), summarise, counts = length(lga_id), 
    total_num_nurse = sum(num_nurses_fulltime, na.rm = T), avg_c_section = mean(c_section_yn == 
        T, na.rm = T))
head(my_summary)
```

```
##   state               lga counts total_num_nurse avg_c_section
## 1  Abia         Aba South      1               6             1
## 2  Abia         Arochukwu      2               0             0
## 3  Abia             Bende      4               0             0
## 4  Abia           Ikwuano      2               1             0
## 5  Abia Isiala Ngwa North      5               1             0
## 6  Abia Isiala Ngwa South      7               0             0
```

* look at the output and compare the difference, the only change here is replacing summarise with transform

```r
my_summary <- ddply(sample_data, .(state, lga), transform, counts = length(lga_id), 
    total_num_nurse = sum(num_nurses_fulltime, na.rm = T), avg_c_section = mean(c_section_yn == 
        T, na.rm = T))
dim(my_summary)
```

```
## [1] 2000  111
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
## Installing package into '/home/zaiming/R/x86_64-pc-linux-gnu-library/3.0'
## (as 'lib' is unspecified)
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
## Installing github repo formhub.R/master from SEL-Columbia
## Downloading formhub.R.zip from https://github.com/SEL-Columbia/formhub.R/archive/master.zip
## Installing package from /tmp/RtmpGrV4Jx/formhub.R.zip
## arguments 'minimized' and 'invisible' are for Windows only
## Installing formhub
## '/usr/lib/R/bin/R' --vanilla CMD INSTALL  \
##   '/tmp/RtmpGrV4Jx/devtools156744c94599/formhub.R-master'  \
##   --library='/home/zaiming/R/x86_64-pc-linux-gnu-library/3.0'  \
##   --install-tests
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
## Loading required package: survival
## Loading required package: splines
## Loading required package: MASS
## Loading required package: sp
```


map functions: apply()
-----------------------
* instead of using for loops, we encourage using map. The apply/sapply is the implementation of map in R
* Here's the simply example for using apply to loop through every column and see the class of the column

```r
apply(sample_data, MARGIN = 2, FUN = class)
```


```
##                                 uuid                                  lga 
##                          "character"                          "character" 
##                                state                                 zone 
##                          "character"                          "character" 
##                               lga_id child_health_yellow_fever_immun_calc 
##                          "character"                          "character" 
##                           unique_lga                        facility_name 
##                          "character"                          "character" 
##                           condoms_yn                                  src 
##                          "character"                          "character"
```


* you can also define your own function in apply()
* the following code returns sum of __NAs__ in each row
  * note: when you're define your own function in apply use semi-colon as the line marker

```r
apply(sample_data, MARGIN = 1, function(x) {
    na_idx <- is.na(x)
    length(which(na_idx))
})
```


```
##  [1] 13 22 55 64 20 10  8 11 14 24
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





