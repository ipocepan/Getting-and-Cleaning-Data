## First step will be to install all the necessary packages and to load the libraries
## For reading large data sets we will use data.table package
## For aggregating merged data set into tidy data set we will use plyr package
#install.packages("data.table")
library(data.table)
#install.packages("plyr")
library(plyr)

## Next step is to download a zip file from given URL and unzip it
dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("Dataset.zip")) {
  download.file(dataUrl, destfile = "Dataset.zip", method = "curl")
}
unzip("Dataset.zip")

## All the data files are in UCI HAR Dataset folder
## Load all the features and extract only those regarding the mean and standard deviation
FeaturesNames <- read.table("./UCI HAR Dataset/features.txt", header=FALSE)
SelectedRows <- grep("-mean\\(\\)|-std\\(\\)", FeaturesNames[ ,2])
SelectedFeatures <- FeaturesNames[SelectedRows, ]

## Load activity labels
ActivityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE)

## Load the activity data for each row of train and test data sets
ActivityTestNo <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE)
ActivityTrainNo <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE)

## Load the subject data for each row of train and test data sets
TestSubjectNo<- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)
TrainSubjectNo <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)

## Load the measured values for all the features
TestData <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE)
TrainData <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE)

## Next step is to concatenate test and train data by rows
## Concatenate activity data and replace numeric codes with descriptive activity names
ActivityNo <- rbind(ActivityTestNo, ActivityTrainNo)
ActivityNo[ ,1] <- ActivityLabels[ActivityNo[ ,1], 2]
## Concatenate subject data and measurements data
SubjectNo <- rbind(TestSubjectNo, TrainSubjectNo)
DataValues <- rbind(TestData, TrainData)

## Set the column names for all data sets
names(ActivityNo) <- c("ActivityLabel")
names(SubjectNo) <- c("SubjectNumber")
names(DataValues) <- FeaturesNames$V2

## Concatenate previous data sets to create one final data set
## The features in this data set are the ones regarding mean and standard deviation
FinalData <- cbind(ActivityNo, SubjectNo, DataValues[ ,SelectedFeatures$V1])

## Label the data set with descriptive variable names
names(FinalData) <- gsub("-", "", names(FinalData))
names(FinalData) <- gsub("mean\\(\\)", "Mean", names(FinalData))
names(FinalData) <- gsub("std\\(\\)", "Std", names(FinalData))
names(FinalData) <- gsub("^t", "Time", names(FinalData))
names(FinalData) <- gsub("^f", "Frequency", names(FinalData))
names(FinalData) <- gsub("Acc", "Accelerometer", names(FinalData))
names(FinalData) <- gsub("Gyro", "Gyroscope", names(FinalData))
names(FinalData) <- gsub("BodyBody", "Body", names(FinalData))
names(FinalData) <- gsub("Mag", "Magnitude", names(FinalData))

## Create a tidy data set with the average of each variable for each activity and each subject.
TidyData <- aggregate(. ~ActivityLabel + SubjectNumber, FinalData, mean)
write.table(TidyData, file="tidy_data.txt", row.names=FALSE)
