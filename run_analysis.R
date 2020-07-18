#####################################################################
### Merging the training and the test sets to create one data set ###
#####################################################################

## Downloading file from source and storing locally

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

temp <- tempfile()
download.file(url, temp)
dir.create("./data")
all_files <- unzip(temp,  list = TRUE, exdir = "./data") ## just contains names of all files contained in the zipped folder [list = TRUE]
unzip(temp, exdir = "./data") ## Data unzipped and stored in a folder called data [list = FALSE]
unlink(temp) # temporary file no longer required

## Read data into tables

X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

## Combining datasets
## cbind() used to combine all data of a test and train
## rbind() used to combine test and train data into one data frame

test <- cbind(subject_test, y_test, X_test)
train <- cbind(subject_train, y_train, X_train)
all <- rbind(test, train) # final dataset with all the data

#####################################################################
###### Extracts only the measurements on the mean and standard ######
################# deviation for each measurement ####################
#####################################################################

## Read features from file

features <- read.table("./data/UCI HAR Dataset/features.txt")

## Read the required features separately

meanstd <- grep("mean\\(\\)|std", features$V2, ignore.case = FALSE) # contains the index of all the features which have either mean or standard deviation measurement
meanstd_names <- grepl("mean\\(\\)|std", features$V2, ignore.case = FALSE) # logical vector if the feature contains either mean or standard deviation parameter

## Imp Note:-
# features$V2 used to check only the names of features. V1 has index number, not names
# in grep, use mean() to match string as other features like meanFreq have to be excluded
# since both () and \ have special meanings, hence use escape character '\\(' and '\\)'
# ignore.case = FALSE since angle based features contain gravityMean like expressions which have to be excluded

## Extract required data into a new table

extrac <- all[, c(1, 2, meanstd + 2)]

## Imp Note:-
# all[, y]: to extract all rows but particular columns
# c(1,2): to keep the data about test subject (identifier of subject) and activity in one place
# meanstd + 2: adding 2 because the initial two columns are reserved for test subject and activity


##############################################################################
########## Uses descriptive activity names to name the activities ############
############################  in the data set ################################
##############################################################################

## Extract activity data

activity <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
activity # column 1 has activity number and column 2 has activity name
table(extrac$V1.1) # gives summary for each activity

library(dplyr) # for accessing mutate function

actdata <- mutate(extrac, V1.1 = activity[extrac$V1.1,2]) # mutate function changes the activity column
table(actdata$V1.1) #gives summary for each activity by name

## Imp note:-
# V1.1 contains activity data
# activity[extrac$V1.1,2] gives name corresponding to a given activity number


##############################################################################
######### Appropriately labels the data set with descriptive variable ########
############################ names variable names ############################
##############################################################################

varnames <- c(c("testSubject", "activity"), features[meanstd, 2]) # The initial two columns are manually defined while the rest columns are named according to the information available in features.txt that contains variable names

descdata <- actdata %>% `colnames<-`(varnames) # using pipeline operator to change column names simulatneously

## Imp Note:-
# Using features[meanstd, 2] as second column of features contains desciptive variable names extracted earlier

##############################################################################
######### Create independent tidy data set with the average of each ##########
################# variable for each activity and each subject ################
##############################################################################

summary(descdata)

## Setting factor variables Test Subject and Activity for ease in later stages

corrdata <- mutate(descdata, testSubject = as.factor(testSubject))
corrdata <- mutate(corrdata, activity = as.factor(activity))

library(reshape2) # to access melt and dcast functions

melted <- melt(corrdata) # Using testSubject, activity as id variables by default
melted
tidyData <- dcast(melted, testSubject + activity ~ ..., mean) ## this gives mean data for each test subject according to their activity
head(tidyData, 20)

## Imp Note:-
# formula format taken from documentation
# ... used as rest of the variables have to be averaged

## Saving tidyData into a text file

write.table(tidyData, "./tidyDataset.txt", row.names = FALSE)

########### Tidy Data done!!!!!!! Yayyyyy!!!!!!! ########################
############# Bye! Bye! All the best, buddy :) ##########################

