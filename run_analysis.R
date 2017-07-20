
## You should create one R script called run_analysis.R that does the following.

## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set 
      with the average of each variable for each activity and each subject.
## Getting all data needed:
## 1. Dowload the file:

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Dataset.zip")

## 2. Unzip the file:

unzip(zipfile="./Dataset.zip",exdir="./C3_data")

## 3. Check C3_data directory and see the file list:

path_to_data <- file.path("./C3_data","UCI HAR Dataset")
list_of_files <- list.files(path_to_data, recursive=TRUE)

list_of_files

## [1] "activity_labels.txt"                          "features.txt"                                
## [3] "features_info.txt"                            "README.txt"                                  
## [5] "test/Inertial Signals/body_acc_x_test.txt"    "test/Inertial Signals/body_acc_y_test.txt"   
## [7] "test/Inertial Signals/body_acc_z_test.txt"    "test/Inertial Signals/body_gyro_x_test.txt"  
## [9] "test/Inertial Signals/body_gyro_y_test.txt"   "test/Inertial Signals/body_gyro_z_test.txt"  
##[11] "test/Inertial Signals/total_acc_x_test.txt"   "test/Inertial Signals/total_acc_y_test.txt"  
##[13] "test/Inertial Signals/total_acc_z_test.txt"   "test/subject_test.txt"                       
##[15] "test/X_test.txt"                              "test/y_test.txt"                             
##[17] "train/Inertial Signals/body_acc_x_train.txt"  "train/Inertial Signals/body_acc_y_train.txt" 
##[19] "train/Inertial Signals/body_acc_z_train.txt"  "train/Inertial Signals/body_gyro_x_train.txt"
##[21] "train/Inertial Signals/body_gyro_y_train.txt" "train/Inertial Signals/body_gyro_z_train.txt"
##[23] "train/Inertial Signals/total_acc_x_train.txt" "train/Inertial Signals/total_acc_y_train.txt"
##[25] "train/Inertial Signals/total_acc_z_train.txt" "train/subject_train.txt"                     
##[27] "train/X_train.txt"                            "train/y_train.txt" 
 

## 2. Read the files:
## 2.a. Read activity files:

ActivityTest_File  <- read.table(file.path(path_to_data, "test" , "y_test.txt" ),header = FALSE)
ActivityTrain_File <- read.table(file.path(path_to_data, "train", "y_train.txt"),header = FALSE)

## 2.b. Read subject files:

SubjectTest_File  <- read.table(file.path(path_to_data, "test" , "subject_test.txt"),header = FALSE)
SubjectTrain_File <- read.table(file.path(path_to_data, "train", "subject_train.txt"),header = FALSE)

## 2.c. Read features files:

FeaturesTest_File  <- read.table(file.path(path_to_data, "test" , "X_test.txt" ),header = FALSE)
FeaturesTrain_File <- read.table(file.path(path_to_data, "train", "X_train.txt"),header = FALSE)
 

## 3. Check the structure:

str(ActivityTest_File)
##'data.frame':	2947 obs. of  1 variable:
## $ V1: int  5 5 5 5 5 5 5 5 5 5 ...

str(ActivityTrain_File)
##'data.frame':	7352 obs. of  1 variable:
## $ V1: int  5 5 5 5 5 5 5 5 5 5 ...

str(SubjectTest_File)
##'data.frame':	2947 obs. of  1 variable:
## $ V1: int  2 2 2 2 2 2 2 2 2 2 ...

str(SubjectTrain_File)
##'data.frame':	7352 obs. of  1 variable:
## $ V1: int  1 1 1 1 1 1 1 1 1 1 ...

str(FeaturesTest_File)
##'data.frame':	2947 obs. of  561 variables:
## $ V1  : num  0.257 0.286 0.275 0.27 0.275 ...
## $ V2  : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
## $ V3  : num  -0.0147 -0.1191 -0.1182 -0.1175 -0.1295 ...

str(FeaturesTrain_File)
##'data.frame':	7352 obs. of  561 variables:
## $ V1  : num  0.289 0.278 0.28 0.279 0.277 ...
## $ V2  : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
## $ V3  : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...

## I. Merges the training and the test sets to create one data set.
## 1.Concatenate data by the rows:

data_Activity <- rbind(ActivityTrain_File, ActivityTest_File)
data_Subject <- rbind(SubjectTrain_File, SubjectTest_File)
data_Features <- rbind(FeaturesTrain_File, FeaturesTest_File)

## 2. Set names:

names(data_Activity)<- c("activity")
names(data_Subject)<-c("subject")
Features_Names <- read.table(file.path(path_to_data, "features.txt"),head=FALSE)
names(data_Features)<- Features_Names$V2

## 3. Merge columns:

Combine_1 <- cbind(data_Activity, data_Subject)
Combine_2 <- cbind(data_Features, Combine_1)

## II. Extracts only the measurements on the mean and standard deviation for each measurement.

## Extract the names from Features_Names related to mean and standard deviation:

sub_Features_Names <-Features_Names$V2[grep("mean\\(\\)|std\\(\\)", Features_Names$V2)]

## Make final names:

final_Names <- c(as.character(sub_Features_Names), "subject", "activity")

## Get data related to mean and standard deviation:

Combine_2 <- subset(Combine_2,select=final_Names)

## Check outcome:
str(Combine_2)
##'data.frame':	10299 obs. of  68 variables:
## $ tBodyAcc-mean()-X          : num  0.289 0.278 0.28 0.279 0.277 ...

## III. Uses descriptive activity names to name the activities in the data set.

## Read activity labels file
activityLabels <- read.table(file.path(path_to_data, "activity_labels.txt"),header = FALSE)

## Change a type of activity variable from numeric to character to be able to assign the descriptive names:
Combine_2$activity <- as.character(Combine_2$activity)
for (i in 1:6){
Combine_2$activity[Combine_2$activity == i] <- as.character(activityLabels[i,2])
}

## Assign new names:
Combine_2$activity <- as.factor(Combine_2$activity)

## Check the result:
head(Combine_2$activity,2)

##[1] STANDING STANDING
##Levels: LAYING SITTING STANDING WALKING WALKING_DOWNSTAIRS WALKING_UPSTAIRS


## IV. Appropriately labels the data set with descriptive activity names.

## See current names:

names(Combine_2)
## [1] "tBodyAcc-mean()-X"           "tBodyAcc-mean()-Y"           "tBodyAcc-mean()-Z"          
## [4] "tBodyAcc-std()-X"            "tBodyAcc-std()-Y"            "tBodyAcc-std()-Z"           
## [7] "tGravityAcc-mean()-X"        "tGravityAcc-mean()-Y"        "tGravityAcc-mean()-Z"       
##[10] "tGravityAcc-std()-X"         "tGravityAcc-std()-Y"         "tGravityAcc-std()-Z"        
##[13] "tBodyAccJerk-mean()-X"       "tBodyAccJerk-mean()-Y"       "tBodyAccJerk-mean()-Z"      
##[16] "tBodyAccJerk-std()-X"        "tBodyAccJerk-std()-Y"        "tBodyAccJerk-std()-Z"       
##[19] "tBodyGyro-mean()-X"          "tBodyGyro-mean()-Y"          "tBodyGyro-mean()-Z"         
##[22] "tBodyGyro-std()-X"           "tBodyGyro-std()-Y"           "tBodyGyro-std()-Z"          
##[25] "tBodyGyroJerk-mean()-X"      "tBodyGyroJerk-mean()-Y"      "tBodyGyroJerk-mean()-Z"     
##[28] "tBodyGyroJerk-std()-X"       "tBodyGyroJerk-std()-Y"       "tBodyGyroJerk-std()-Z"      
##[31] "tBodyAccMag-mean()"          "tBodyAccMag-std()"           "tGravityAccMag-mean()"      
##[34] "tGravityAccMag-std()"        "tBodyAccJerkMag-mean()"      "tBodyAccJerkMag-std()"      
##[37] "tBodyGyroMag-mean()"         "tBodyGyroMag-std()"          "tBodyGyroJerkMag-mean()"    
##[40] "tBodyGyroJerkMag-std()"      "fBodyAcc-mean()-X"           "fBodyAcc-mean()-Y"          
##[43] "fBodyAcc-mean()-Z"           "fBodyAcc-std()-X"            "fBodyAcc-std()-Y"           
##[46] "fBodyAcc-std()-Z"            "fBodyAccJerk-mean()-X"       "fBodyAccJerk-mean()-Y"      
##[49] "fBodyAccJerk-mean()-Z"       "fBodyAccJerk-std()-X"        "fBodyAccJerk-std()-Y"       
##[52] "fBodyAccJerk-std()-Z"        "fBodyGyro-mean()-X"          "fBodyGyro-mean()-Y"         
##[55] "fBodyGyro-mean()-Z"          "fBodyGyro-std()-X"           "fBodyGyro-std()-Y"          
##[58] "fBodyGyro-std()-Z"           "fBodyAccMag-mean()"          "fBodyAccMag-std()"          
##[61] "fBodyBodyAccJerkMag-mean()"  "fBodyBodyAccJerkMag-std()"   "fBodyBodyGyroMag-mean()"    
##[64] "fBodyBodyGyroMag-std()"      "fBodyBodyGyroJerkMag-mean()" "fBodyBodyGyroJerkMag-std()" 
##[67] "subject"                     "activity"           

## Clean up the names by replacing:
## "^f" ==> "Frequency"
## "^t" ==> "Time"
## "Acc" ==> "Accelerometer"
## "BodyBody" ==> "Body"
## "Gyro" ==> "Gyroscope"
## "Mag" ==> "Magnitude"
## "-mean()" ==> "Mean"
## "-std()" ==> "Std"

names(Combine_2)<-gsub("^f", "Frequency", names(Combine_2))
names(Combine_2)<-gsub("^t", "Time", names(Combine_2))
names(Combine_2)<-gsub("Acc", "Accelerometer", names(Combine_2))
names(Combine_2)<-gsub("BodyBody", "Body", names(Combine_2))
names(Combine_2)<-gsub("Gyro", "Gyroscope", names(Combine_2))
names(Combine_2)<-gsub("Mag", "Magnitude", names(Combine_2))
names(Combine_2)<-gsub("-mean()", "Mean", names(Combine_2))
names(Combine_2)<-gsub("-std()", "Std", names(Combine_2))

## After:

 names(Combine_2)
## [1] "TimeBodyAccelerometerMean()-X"                 "TimeBodyAccelerometerMean()-Y"                
## [3] "TimeBodyAccelerometerMean()-Z"                 "TimeBodyAccelerometerStd()-X"                 
## [5] "TimeBodyAccelerometerStd()-Y"                  "TimeBodyAccelerometerStd()-Z"                 
## [7] "TimeGravityAccelerometerMean()-X"              "TimeGravityAccelerometerMean()-Y"             
## [9] "TimeGravityAccelerometerMean()-Z"              "TimeGravityAccelerometerStd()-X"              
##[11] "TimeGravityAccelerometerStd()-Y"               "TimeGravityAccelerometerStd()-Z"              
##[13] "TimeBodyAccelerometerJerkMean()-X"             "TimeBodyAccelerometerJerkMean()-Y"            
##[15] "TimeBodyAccelerometerJerkMean()-Z"             "TimeBodyAccelerometerJerkStd()-X"             
##[17] "TimeBodyAccelerometerJerkStd()-Y"              "TimeBodyAccelerometerJerkStd()-Z"             
##[19] "TimeBodyGyroscopeMean()-X"                     "TimeBodyGyroscopeMean()-Y"                    
##[21] "TimeBodyGyroscopeMean()-Z"                     "TimeBodyGyroscopeStd()-X"                     
##[23] "TimeBodyGyroscopeStd()-Y"                      "TimeBodyGyroscopeStd()-Z"                     
##[25] "TimeBodyGyroscopeJerkMean()-X"                 "TimeBodyGyroscopeJerkMean()-Y"                
##[27] "TimeBodyGyroscopeJerkMean()-Z"                 "TimeBodyGyroscopeJerkStd()-X"                 
##[29] "TimeBodyGyroscopeJerkStd()-Y"                  "TimeBodyGyroscopeJerkStd()-Z"                 
##[31] "TimeBodyAccelerometerMagnitudeMean()"          "TimeBodyAccelerometerMagnitudeStd()"          
##[33] "TimeGravityAccelerometerMagnitudeMean()"       "TimeGravityAccelerometerMagnitudeStd()"       
##[35] "TimeBodyAccelerometerJerkMagnitudeMean()"      "TimeBodyAccelerometerJerkMagnitudeStd()"      
##[37] "TimeBodyGyroscopeMagnitudeMean()"              "TimeBodyGyroscopeMagnitudeStd()"              
##[39] "TimeBodyGyroscopeJerkMagnitudeMean()"          "TimeBodyGyroscopeJerkMagnitudeStd()"          
##[41] "FrequencyBodyAccelerometerMean()-X"            "FrequencyBodyAccelerometerMean()-Y"           
##[43] "FrequencyBodyAccelerometerMean()-Z"            "FrequencyBodyAccelerometerStd()-X"            
##[45] "FrequencyBodyAccelerometerStd()-Y"             "FrequencyBodyAccelerometerStd()-Z"            
##[47] "FrequencyBodyAccelerometerJerkMean()-X"        "FrequencyBodyAccelerometerJerkMean()-Y"       
##[49] "FrequencyBodyAccelerometerJerkMean()-Z"        "FrequencyBodyAccelerometerJerkStd()-X"        
##[51] "FrequencyBodyAccelerometerJerkStd()-Y"         "FrequencyBodyAccelerometerJerkStd()-Z"        
##[53] "FrequencyBodyGyroscopeMean()-X"                "FrequencyBodyGyroscopeMean()-Y"               
##[55] "FrequencyBodyGyroscopeMean()-Z"                "FrequencyBodyGyroscopeStd()-X"                
##[57] "FrequencyBodyGyroscopeStd()-Y"                 "FrequencyBodyGyroscopeStd()-Z"                
##[59] "FrequencyBodyAccelerometerMagnitudeMean()"     "FrequencyBodyAccelerometerMagnitudeStd()"     
##[61] "FrequencyBodyAccelerometerJerkMagnitudeMean()" "FrequencyBodyAccelerometerJerkMagnitudeStd()" 
##[63] "FrequencyBodyGyroscopeMagnitudeMean()"         "FrequencyBodyGyroscopeMagnitudeStd()"         
##[65] "FrequencyBodyGyroscopeJerkMagnitudeMean()"     "FrequencyBodyGyroscopeJerkMagnitudeStd()"     
##[67] "subject"                                       "activity"

## V. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Create final data set:
Final_Data <- aggregate(. ~subject + activity, Combine_2, mean)

## Order by subject and activity:
Final_Data <- Final_Data[order(Final_Data$subject,Final_Data$activity),]

## Create a file Tidy_Data_Set.txt
write.table(Final_Data, file = "Tidy_Data_Set.txt",row.name=FALSE)

