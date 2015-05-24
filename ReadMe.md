# Getting and Cleaning Data
## Course Project

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. 
You will be required to submit: 

*  a tidy data set as described below, 
*  link to a Github repository with your script for performing the analysis, and 
*  a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
 

You should create one R script called ```run_analysis.R``` that does the following: 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Repository details
This README file explains the details about the files included in this repository and how they are connected.
The included files:

* run_analysis.R
* CodeBook.md
* tidy_data.txt

### run_analysis.R script
This script transforms raw data into a tidy data set where each variable measured is in one column and each different observation of that variable is in a different row.
Raw data file can be downloaded here: <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

* The script installs all the packages it depends on; *data.table* and *plyr*
* Downloads raw data from the above mentioned URL and unzips it.
* Loads all the test and train data sets into corresponding data frames.
* Selects only the features regarding the mean and standard deviation.
* Replaces activity id's (1-6) with descriptive names.
* Merges all the test and train data sets. Then merges the resulting activity, subject, and measurement data sets into one data frame with 10299 rows and 68 columns. 
* Transforms the measurement variables names into a more readable form and assigns the appropriate descriptive names to all the variables in a data frame.
* Aggregates the merged data set into a smaller one with 180 rows and 68 columns.
* The aggregated data set is the final tidy data set with the average of each variable for each activity and each subject.

To run the script, you will need to download it to your working directory and enter the ```source("run_analysis.R")``` command in R. The tidy data set will be saved in your working directory as a ```tidy_data.txt``` text file.

### CodeBook.md details

The CodeBook describes the experiment and the gathered data in more details. In addition, there is an overwiev of the calculated variables and the raw data files used in our analysis. All the transformations performed in *run_analysis.R* script are explained step by step through examples. 

### tidy_data.txt file
This file is generated after running *run_analysis.R* script on raw data. It contains 180 observations for 68 variables (activity, subject and 66 measurement variables). Each measurement variable contains the average of each variable for each activity and each subject. All the variables have appropriate descriptive names. To load it into R from your working directory, you can use ```read.table("tidy_data.txt", header=TRUE)``` R command.

