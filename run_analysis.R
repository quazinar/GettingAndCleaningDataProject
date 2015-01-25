## This script is designed to take the raw accelerometer data
## from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## and create a tidy data set as per the project instructions.
## Project instructions can be found in the README.md file
## in the same directory as this script.

## Note that the downloaded file is unzipped prior to processing,
## as detailed in the README.md file.

## The output is in the narrow format. Commenting out the reshaping code
## at the end will cause the output to be in the wide format.

## Inputs: none
## Outputs: tidyData - a tidy data set (in the narrow format)

run_analysis <- function(){
    
    library(data.table)
    
    #### Part 1 ####
    ## Read in all the data and combine it into one data set.
    
    ## read.table() is used because fread generates an error, probably due to
    ## an encoding problem in the data. The data frame is converted to a 
    ## data table afterward.
    subject_train <- fread('./train/subject_train.txt')
    X_train <- read.table('./train/X_train.txt')
    y_train <- fread('./train/y_train.txt')
    X_train<-data.table(X_train)
    
    subject_test <- fread('./test/subject_test.txt')
    X_test <- read.table('./test/X_test.txt')
    y_test <- fread('./test/y_test.txt')
    X_test<-data.table(X_test)
    
    ## Combine the subject, X, and y data into one data frame
    train_combined <- cbind(subject_train,X_train,y_train);
    test_combined <- cbind(subject_test,X_test,y_test);
    
    ## Merge the train and test data
    data <- rbind(train_combined,test_combined)
    
    #### Part 2 ####
    ## Extract only the mean and std measurements
    
    ## Get the names of the features and create a vector of column names
    feature_names <- fread('./features.txt')
    col_names<-c('subject',as.character(feature_names[,V2]),'activityNumber')
    col_names<-make.names(col_names,unique=T)
    
    ## Apply the column names to the merged data table
    setnames(data,col_names)
    #colnames(data)<-col_names #slower because it makes a copy
    
    ## Subset the columns whose names have "mean" and "std" in them.
    ## We choose to be case insensitive for this.
    ## We must also keep the subject and activity_number columns. This could
    ## be done by adding them back after subsetting, but, to prevent 
    ## rewriting the table, we include these explicitly in the regex.
    ## Note the use of with=F to make this behave like a data frame would.
    subdata<-data[,grep("^subject$|^activityNumber$|*mean*|*std*",names(data),ignore.case=T),with=F]
    
    # Below subsetting would work, but subset() should only be used for interactive work (convenience function)
    # subdata<-subset(data,select=grep("*mean*|*std*",names(data),ignore.case=T))
    
    #### Part 3 ####
    ## Put in activity names as labels (instead of just numbers)
    
    ## Replace the current activities column (numeric) with actual
    ## names of activities (char) using the activities_labels file
    activities<- fread('./activity_labels.txt')
    setnames(activities,c('activityNumber','activity'))
    
    ## Merge the data to get the nice labels in.
    labeled_data<-merge(activities,subdata,by='activityNumber') # Note that, if we used setkeys(), we could do this using the [ operator instead of merge().
    
    ## We  end up with the activity numbers still in the data table. Let's
    ## drop this column, since it's duplicating information.
    labeled_data<-labeled_data[,activityNumber:=NULL] # Preferred way to remove column is by setting to NULL
    
    #### Part 4 ####
    ## Give the features better labels (i.e., improve the column names).
    
    ## Get the column names of the data (need to do this becauses the column
    ## order has changed from earlier in the code).
    col_names<-names(labeled_data)
    
    ## Fix the various things that are wrong about the column names (random
    ## dots, camelCase names, expand abbreviations, etc.)
    
    ## Expand t and f to time and freq.
    col_names<-sub('^t','time',col_names)
    col_names<-sub('\\.t','.time',col_names) # Doing this in two lines for simplicity
    col_names<-sub('^f','freq',col_names)
    
    ## Convert every letter after a period into its upper case version.
    ## '\\.(\\w?)' will grab the pattern of a period followed by an alphanumeric.
    ## '\\U\\1' is a reference to the previously matched element in parentheses
    ## (in this case, the alphanumeric), and it capitalizes whatever character
    ## that was. Because of the ? used in the matching (indicating zero or one 
    ## instance of an alphanumeric), this will also remove all the periods.
    col_names<-gsub('\\.(\\w?)', '\\U\\1', col_names, perl=T)
    
    ## And lastly, let's get rid of the repeated 'Body' text in some of the names.
    col_names<-sub('BodyBody','Body',col_names)
    
    ## Apply the new names to the data table
    setnames(labeled_data,col_names)
    
    #### Part 5 ####
    ## Create a new tidy data set with the average of each variable grouped by 
    ## each activity and subject.
    
    ## Get a raw summary of the data
    tidyData <- labeled_data[,lapply(.SD,mean),by=c('activity','subject')]
    
    ## Separate the grouping columns from the measurement columns
    col_names <- names(tidyData)
    groupingCols <- c('subject','activity')
    measurementCols <- col_names[-which(groupingCols %in% col_names)]
    
    ## Reshape the data (choosing long and skinny) to make it tidy.
    library(reshape2)
    tidyData <- melt(tidyData,id=groupingCols,measure.vars=measurementCols)
    
    ## Output the tidy data set
    tidyData
}