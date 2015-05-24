# Getting and Cleaning Data

## CodeBook

This code book describes the variables, the data, and any transformations or work that was performed to clean up the data for the Getting and Cleaning Data Course Project.

### Data Set Information

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

For each record in the dataset it is provided: 

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables.
- Its activity label. 
- An identifier of the subject who carried out the experiment.

### The raw data

Original data set can be downloaded from: 
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

**UCI HAR Dataset** folder contains all the input data files:

- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features; all the measurement variables.
- 'activity_labels.txt': Links the activity code (1-6) with the corresponding descriptive activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Activity labels for training data set.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Activity labels for test data set.
- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. (The same definition for test data set.)

**Note:** Features are normalized and bounded within [-1,1]. Each feature vector is a row on the text file. All the files in *Inertial Signals* folders will not be used in this analysis.

Further information on the data set can be found here: <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>


### Transformation details
Prior to any transformations, packages ```data.table``` and ```plyr``` are installed. 
Input data files are downloaded into the working directory.
All input files are imported into data frames as follows:

|Input file           |Data frames        |Dimensions          |
|---------------------|:-----------------:|-------------------:|
|features.txt         |FeaturesNames      |561 rows, 2 cols    |
|activity_labels.txt  |ActivityLabels     |6 rows, 2 cols      |
|y_test.txt           |ActivityTestNo     |2947 rows, 1 col    |
|y_train.txt          |ActivityTrainNo    |7352 rows, 1 col    |
|subject_test.txt     |TestSubjectNo      |2947 rows, 1 col    |
|subject_train.txt    |TrainSubjectNo     |7352 rows, 1 col    |
|X_test.txt           |TestData           |2947 rows, 561 cols |
|X_train.txt          |TrainData          |7352 rows, 561 cols |

```grep``` function was used to search for occurences of `mean()` and `std()` in *FeaturesNames* so the measurements on the mean and standard deviation could be extracted into the final data set. The resulting selection of 66 variable names was saved into *SelectedFeatures* data frame.

```R
SelectedRows <- grep("-mean\\(\\)|-std\\(\\)", FeaturesNames[ ,2])
SelectedFeatures <- FeaturesNames[SelectedRows, ]

dim(SelectedFeatures)
[1] 66  2

head(SelectedFeatures)
  V1                V2
1  1 tBodyAcc-mean()-X
2  2 tBodyAcc-mean()-Y
3  3 tBodyAcc-mean()-Z
4  4  tBodyAcc-std()-X
5  5  tBodyAcc-std()-Y
6  6  tBodyAcc-std()-Z
```

```rbind``` function was used to concatenate *test* and *train* data sets by rows and the concatenated data sets were named *ActivityNo*, *SubjectNo*, *DataValues*. Descriptive activity names were used to name activities in the data set:
```R
ActivityNo[ ,1] <- ActivityLabels[ActivityNo[ ,1], 2]

dim(ActivityNo); dim(SubjectNo); dim(DataValues)
[1] 10299     1
[1] 10299     1
[1] 10299   561

head(ActivityNo)
  ActivityLabel
1      STANDING
2      STANDING
3      STANDING
4      STANDING
5      STANDING
6      STANDING
```

Descriptive variable names were set for the concatenated data sets:
```R
names(ActivityNo) <- c("ActivityLabel")
names(SubjectNo) <- c("SubjectNumber")
names(DataValues) <- FeaturesNames$V2
```
```cbind``` function was used to combine the activity data, subject data, and the data regarding the measurements on the mean and standard deviation. The resulting data frame *FinalData* has 10299 rows and 68 columns.
```R
FinalData <- cbind(ActivityNo, SubjectNo, DataValues[ ,SelectedFeatures$V1])

dim(FinalData)
[1] 10299    68

head(names(FinalData))
[1] "ActivityLabel"     "SubjectNumber"     "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y"
[5] "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" 
```

```gsub``` function was used to update variable names and improve their readability:
```R
names(FinalData) <- gsub("-", "", names(FinalData))
names(FinalData) <- gsub("mean\\(\\)", "Mean", names(FinalData))
names(FinalData) <- gsub("std\\(\\)", "Std", names(FinalData))
names(FinalData) <- gsub("^t", "Time", names(FinalData))
names(FinalData) <- gsub("^f", "Frequency", names(FinalData))
names(FinalData) <- gsub("Acc", "Accelerometer", names(FinalData))
names(FinalData) <- gsub("Gyro", "Gyroscope", names(FinalData))
names(FinalData) <- gsub("BodyBody", "Body", names(FinalData))
names(FinalData) <- gsub("Mag", "Magnitude", names(FinalData))
```
For instance, variable name ```"tBodyAcc-mean()-X"``` was transformed into ```"TimeBodyAccelerometerMeanX"```. 
```R
head(names(FinalData))
[1] "ActivityLabel"              "SubjectNumber"              "TimeBodyAccelerometerMeanX"
[4] "TimeBodyAccelerometerMeanY" "TimeBodyAccelerometerMeanZ" "TimeBodyAccelerometerStdX" 
```

### Tidy data
*FinalData* was transformed one last time using the ```aggregate``` function from **plyr** package. *TidyData* contains average value of each measurement variable for every combination of ```ActivityLabel``` and ```SubjectNumber```. The tidy data frame has 180 rows and 68 columns.
```R
TidyData <- aggregate(. ~ActivityLabel + SubjectNumber, FinalData, mean)

dim(TidyData)
[1] 180  68

head(TidyData)
       ActivityLabel SubjectNumber TimeBodyAccelerometerMeanX TimeBodyAccelerometerMeanY...
1             LAYING             1                  0.2215982               -0.040513953...
2            SITTING             1                  0.2612376               -0.001308288...
3           STANDING             1                  0.2789176               -0.016137590...
4            WALKING             1                  0.2773308               -0.017383819...
5 WALKING_DOWNSTAIRS             1                  0.2891883               -0.009918505...
6   WALKING_UPSTAIRS             1                  0.2554617               -0.023953149...
```
The resulting data frame was written into ```tidy_data.txt``` file. This is a space-delimited text file, with the header line containing variable names.
```R
write.table(TidyData, file="tidy_data.txt", row.names=FALSE)
```

