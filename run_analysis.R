# Course Project Getting and Cleaning Data

#Reading the data into Rstudio and library setup

library(dplyr)
activity_labels <- read.table("C:/Users/Enrique Velasco/Desktop/Coursera/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt",
                              quote="\"", comment.char="", col.names = c("code", "activity"))
features <- read.table("C:/Users/Enrique Velasco/Desktop/Coursera/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt", 
                       quote="\"", comment.char="", col.names = c("n", "features"))
subject_test <- read.table("C:/Users/Enrique Velasco/Desktop/Coursera/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", 
                           quote="\"", comment.char="", col.names = "subject")
subject_train <- read.table("C:/Users/Enrique Velasco/Desktop/Coursera/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", 
                            quote="\"", comment.char="", col.names = "subject")
y_test <- read.table("C:/Users/Enrique Velasco/Desktop/Coursera/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", 
                     quote="\"", comment.char="", col.names = "code")
X_test <- read.table("C:/Users/Enrique Velasco/Desktop/Coursera/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", 
                     quote="\"", comment.char="", col.names = features$features)
X_train <- read.table("C:/Users/Enrique Velasco/Desktop/Coursera/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", 
                      quote="\"", comment.char="", col.names = features$features)
y_train <- read.table("C:/Users/Enrique Velasco/Desktop/Coursera/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", 
                      quote="\"", comment.char="", col.names = "code")

# Merging the data sets

test <- cbind(y_test, X_test)
train <- cbind(y_train, X_train)
subjects <- rbind(subject_test, subject_train)
test_train <- rbind(test, train)
mergeddf <- cbind(subjects, test_train)

# selecting only the computed means and std

tidydf <- mergeddf %>% select(subject, code, contains("mean"), contains("std"))

# giving descriptive activity, and variable names 
# for the data set

tidydf$code <- activity_labels[tidydf$code, 2]
names(tidydf)[2] <- "activities"
names(tidydf) <- gsub("tBody", "TimeBody", names(tidydf))
names(tidydf) <- gsub("Acc", "Accelerometer", names(tidydf))
names(tidydf) <- gsub("-mean()", "Mean", names(tidydf))
names(tidydf) <- gsub("-std()", "STD", names(tidydf))
names(tidydf) <- gsub("^t", "Time", names(tidydf))
names(tidydf) <- gsub("Gyro", "Gyroscope", names(tidydf))
names(tidydf) <- gsub("Mag", "Magnitude", names(tidydf))
names(tidydf) <- gsub("^f", "Frequency", names(tidydf))
names(tidydf) <- gsub("-meanFreq()", "MeanFrequency", names(tidydf))
names(tidydf) <- gsub("BodyBody", "Body", names(tidydf))
names(tidydf) <- gsub("gravity", "Gravity", names(tidydf))
names(tidydf) <- gsub("angle", "Angle", names(tidydf))

# second tidydf with the means of every variable for each activity and 
# subject

tidydf2 <- tidydf %>% group_by(subject, activities) %>% 
           summarise_all(funs(mean))
tidydf2$activities <- as.factor(tidydf2$activities)
