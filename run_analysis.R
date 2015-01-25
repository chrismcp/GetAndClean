# set working directory
setwd("F:/Rwork/UCI HAR Dataset")

#load libraries
library(plyr)
library(dplyr)

# create tables for test files
sub_test <- read.table("test/subject_test.txt")
act_test <- read.table("test/y_test.txt")
data_test <- read.table("test/x_test.txt")

# create tables for training files
sub_train <- read.table("train/subject_train.txt")
act_train <- read.table("train/y_train.txt")
data_train <- read.table("train/x_train.txt")

# add column names
colnames(sub_test) <- "subject"
colnames(act_test) <- "activity"
colnames(sub_train) <- "subject"
colnames(act_train) <- "activity"
#  now do the big data using names from documentation
feat <- read.table("features.txt")
f <- feat[,2]
colnames(data_test) <- f
colnames(data_train) <- f

# combine everything
big_test <- cbind(sub_test, act_test, data_test)
big_train <- cbind(sub_train, act_train, data_train)
big_all <- rbind(big_test, big_train)

# change activity to character activity labels
act_label <- read.table("activity_labels.txt")
big_all[,"activity"] <- act_label[big_all[,"activity"],"V2"]

# chop it down to only the fields we want
y_mean <- big_all[,grepl("mean", colnames(big_all))]
y_Mean <- big_all[,grepl("Mean", colnames(big_all))]
y_std  <- big_all[,grepl("std", colnames(big_all))]
# and put it all together 
out1 <- cbind(big_all[,1:2], y_mean, y_Mean, y_std)

# sort it
out1 <- arrange(out1, subject, activity)

#sumerize it
out1 <- ddply(out1, .(subject,activity), numcolwise(mean))

#create the Final Output
write.table(out1, file="tidyFile.txt", row.name=FALSE)
