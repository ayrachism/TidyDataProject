# TidyDataProject
This project is the final assessment metric of Data Science Specialization's course "Getting and Cleaning Data".

## Goal
The purpose of this project is to apply all the concepts learnt in the course to create a tidy usable data from raw data. It will demonstrate a candidate's ability to source data and clean it for further analysis. 

## Source
Original [dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) was recovered from the accelerometers from the Samsung Galaxy S smartphone to be used in development of wearable technology. However the required [dataset] (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) is much smaller.

## How to run the code

The repository contains an R script `run_analysis.R` that does the following : 
-   Merges the training and the test sets to create one data set
-   Extracts only the measurements on the mean and standard deviation for each measurement
-   Uses descriptive activity names to name the activities in the data set
-   Appropriately labels the data set with descriptive variable names
-   Ccreates an independent tidy data set with the average of each variable for each activity and each subject

Note: `dplyr` and `reshape2` packages required

## Final Tidy Dataset

A .txt file is submitted as the final dataset. It can be read using `read.table()` command.

## Additional notes

A [codebook](https://github.com/ayrachism/TidyData/blob/master/CodeBook.md) (`CodeBook.md`) is available and give a brief description of the tidy data set columns.
