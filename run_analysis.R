
## You should create one R script called run_analysis.R that does the following.

## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.

## 0. Install the packages and check working DIR:
library(data.table)
library(dplyr)
getwd()
##[1] "C:/Users/Owner/Documents"

## Getting all data needed:
## 1. Dowload the file:

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Dataset.zip")

## 2. Unzip the file:

unzip(zipfile="./Dataset.zip",exdir="./C3_data")

## 3. Check C3_data directory and see the file list:

path_to_data <- file.path("./C3_data","UCI HAR Dataset")
list_of_files <- list.files(path_to_data, recursive=TRUE)

## 4. Read the files:
## 4.a. Read activity files:

ActivityTest_File  <- read.table(file.path(path_to_data, "test" , "y_test.txt" ),header = FALSE)
ActivityTrain_File <- read.table(file.path(path_to_data, "train", "y_train.txt"),header = FALSE)

## 4.b. Read subject files:

SubjectTest_File  <- read.table(file.path(path_to_data, "test" , "subject_test.txt"),header = FALSE)
SubjectTrain_File <- read.table(file.path(path_to_data, "train", "subject_train.txt"),header = FALSE)

## 4.c. Read features files:

FeaturesTest_File  <- read.table(file.path(path_to_data, "test" , "X_test.txt" ),header = FALSE)
FeaturesTrain_File <- read.table(file.path(path_to_data, "train", "X_train.txt"),header = FALSE)
 

## I. Merges the training and the test sets to create one data set.
## Concatenate data by the rows:

data_Activity <- rbind(ActivityTrain_File, ActivityTest_File)
data_Subject <- rbind(SubjectTrain_File, SubjectTest_File)
data_Features <- rbind(FeaturesTrain_File, FeaturesTest_File)

## Set names:

names(data_Activity) <- c("activity")
names(data_Subject) <-c("subject")
Features_Names <- read.table(file.path(path_to_data, "features.txt"),head=FALSE)
names(data_Features) <- Features_Names$V2

## Merge columns:

Combine_1 <- cbind(data_Activity, data_Subject)
Combine_2 <- cbind(data_Features, Combine_1)

## II. Extracts only the measurements on the mean and standard deviation for each measurement.

## Extract the names from Features_Names related to mean and standard deviation:

sub_Features_Names <- Features_Names$V2[grep("mean\\(\\)|std\\(\\)", Features_Names$V2)]

## Make final names:

final_Names <- c(as.character(sub_Features_Names), "subject", "activity")

## Get data related to mean and standard deviation:

Combine_2 <- subset(Combine_2,select=final_Names)

## III. Uses descriptive activity names to name the activities in the data set.

## Read activity labels file:

activityLabels <- read.table(file.path(path_to_data, "activity_labels.txt"),header = FALSE)

## Change a type of activity variable from numeric to character to be able to assign the descriptive names:

Combine_2$activity <- as.character(Combine_2$activity)
for (i in 1:6){
Combine_2$activity[Combine_2$activity == i] <- as.character(activityLabels[i,2])
}

## Assign new names:

Combine_2$activity <- as.factor(Combine_2$activity)

## Use factor in subject variable:

Combine_2$subject <- as.factor(Combine_2$subject)

## IV. Appropriately labels the data set with descriptive activity names.

## Clean up the names by replacing:
## "^f" ==> "Frequency"
## "^t" ==> "Time"
## "Acc" ==> "Accelerometer"
## "BodyBody" ==> "Body"
## "Gyro" ==> "Gyroscope"
## "Mag" ==> "Magnitude"
## "-mean()" ==> "Mean"
## "-std()" ==> "Std"

names(Combine_2) <- gsub("^f", "Frequency", names(Combine_2))
names(Combine_2) <- gsub("^t", "Time", names(Combine_2))
names(Combine_2) <- gsub("Acc", "Accelerometer", names(Combine_2))
names(Combine_2) <- gsub("BodyBody", "Body", names(Combine_2))
names(Combine_2) <- gsub("Gyro", "Gyroscope", names(Combine_2))
names(Combine_2) <- gsub("Mag", "Magnitude", names(Combine_2))
names(Combine_2) <- gsub("-mean()", "Mean", names(Combine_2))
names(Combine_2) <- gsub("-std()", "Std", names(Combine_2))

## V. Creates a second, independent tidy data set with the average of each variable 
##    for each activity and each subject.

## Create final data set:
Final_Data <- aggregate(. ~subject + activity, Combine_2, mean)
Final_Data <- Final_Data[order(Final_Data$subject,Final_Data$activity),]

## Create a file Tidy_Data.txt:

write.table(Final_Data, file = "Tidy_Data.txt",row.name=FALSE)

