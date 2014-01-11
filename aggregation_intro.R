# Aggregations in R:

#   * there are many functions that can do aggregation for you, but we are only going to cover __ddply()__ in __plyr__ package

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
