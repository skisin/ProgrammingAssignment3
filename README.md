# ProgrammingAssignment3
Getting and Cleaning Data
# Getting and Cleaning Data assignment
 +
  The Final Project for the Course "Getting and Cleaning Data" in DataScience Specialization Series.
  
  Link to the data required for this project:
  
  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
  
 -
 -You should create one R script called run_analysis.R that does the following.
 1) Download and extract the folder and set the current working directory in R to where the UCI CHAR Dataset is extracted.
 2) Merges the training and the test sets to create one data set.
 3) Extracts only the measurements on the mean and standard deviation for each measurement.
 4) Uses descriptive activity names to name the activities in the data set
 5) Appropriately labels the data set with descriptive variable names.
 6) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
 +Then copy paste the R script named run_analysis.R that does the following.
    
 +The Script run_analysis.R is as follows:
 -Install the packages and check working DIR
 -Download and unzip raw data
 -Read the files 
 -Merges the training and the test sets to create one data set by rows and columns: result is Combine_2
 -Extracts only the measurements on the mean and standard deviation for each measurement and stores it in Combine_2
 -Gets the list of activities and assigns meaningful names.
 -Cleans up the valiable names
 -Creates independent tidy data set with the average of each variable for each activity and each subject
 -Order it by subject and activity
 -Writes final file to "Tidy_Data.txt" 
