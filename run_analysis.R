url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
files <- "UCI HAR Dataset.zip"
if(!file.exists("files"))
{download.file(url, files, mode = 'wb')}

dataset <- "UCI HAR Dataset"
if(!file.exists("dataset"))
{unzip(files)}

library(dplyr)

##testfiles
sub_test <-read.table(file.path(dataset, "test", "subject_test.txt"))
act_test <- read.table(file.path(dataset, "test", "y_test.txt"))
val_test <- read.table(file.path(dataset, "test", "X_test.txt"))

##trainfiles
sub_train <-read.table(file.path(dataset, "train", "subject_train.txt"))
act_train <- read.table(file.path(dataset, "train", "y_train.txt"))
val_train <- read.table(file.path(dataset, "train", "X_train.txt"))

feat_names <- read.table(file.path(dataset, "features.txt"))
act_labels <- read.table(file.path(dataset, "activity_labels.txt"))

##merging
sub_merge <- rbind(sub_test, sub_train)
act_merge <- rbind(act_test, act_train)
val_merge <- rbind(val_test, val_train)

names(sub_merge) <-c("subject")
names(act_merge) <- c("activity")
names(val_merge) <- feat_names$V2

all_data <- cbind(val_merge, act_merge, sub_merge)

col_MeanSTD <- grep(".*Mean.*|.*Std.*", names(all_data), ignore.case = TRUE)
get_columns <- c(col_MeanSTD, 562, 563)

get_data <- all_data[, get_columns]

get_data$activity <- factor(get_data$activity, labels=c("Walking",
                                                        "Walking Upstairs", 
                                                        "Walking Downstairs", 
                                                        "Sitting", 
                                                        "Standing", 
                                                        "Laying"))

library(reshape2)

melted <- melt(get_data, id=c("subject","activity"))
tidy <- dcast(melted, subject+activity ~ variable, mean)


write.table(tidy, "tidy.txt", row.names = FALSE,  quote = FALSE)

