# GettingAndCleaningDataProject
Repo for course project for Getting And Cleaning Data

All scripts for this analysis were created using version 3.1.2 of R and version 0.98.1091 of RStudio.

### Acquiring the Data
Data was downloaded from the following site: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The zip file was unzipped using the 7-zip software, although any method should work equally well. 

A full description of the data can be found at the site where the data originated:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones  

### Packages
This code requires the data.table and reshape2 packages to be installed. This can be found on the CRAN website or, if configured, installed via the command install.packages(package_name). Load it using the command library(package_name).

### Instructions to run
To run the run_analysis.R script, load the script, then set the working directory to be the UCI HAR Dataset directory. All paths to read data are written relative to this directory.

No inputs are required. The output is the tidy data set as a data table.

### Notes
Details of the raw data set, how it was prepared (in a high level overview), what the features are, etc., can be found in the features_info.txt and README.txt that accompany the raw data on download. The location for the download can be found in the Project Instructions of this README file.

Information about the variables in the data, choices made in creating the tidy data file, and other information regarding the analysis can be fonud in the CodeBook.md file.

### Tidy data file
The tidy data file uses the long skinny format, with the features listed in one column (called 'variable') and the data listed in a column called 'value'. The 'subject' and 'activity' columns label the data.

## Summary of script
The run_analysis.R script carries out the instructions, in order, from the course assignment (reproduced below). In summary:

1. It reads in the subject, X, and y data sets for both train and test, creates a single table for the train and test data separately (using cbind), combines the train and test data (using rbind). 

2. It then reads in the feature names, turns them into valid R column names, and applies those column names to the data set. These names are then used to extract all columns with the strings 'mean' or 'std' in their names.

3. The y data column is replaced with named activities from the activity_labels.txt file

4. The column names are cleaned up by replacing less obvious abbreviations with words, putting everything in camelCase for readability, and removing duplicate words where appropriate.

5. Finally, it creates and outputs a new tidy data set formed by summarizing the data by subject and activity.

The comments in the script outline the procedure in finer detail.

Project Instructions from the Course Project's Website
================

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

You should create one R script called run_analysis.R that does the following. 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Good luck!