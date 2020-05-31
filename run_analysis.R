## 1 download data

if(!file.exists('./data')) {
        dir.create('./data/')
        zipurl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
        download.file(zipurl, destfile='./data/rawdata.zip', method="curl")
        unzip('./data/rawdata.zip', exdir = './data', unzip = 'internal') 
}

## 2 read data Merges the training and the test sets to create one data set

#read data description
var_names <- read.table('./data/UCI HAR Dataset/features.txt')

# read activity label
activity_labels <- read.table('./data/UCI HAR Dataset/activity_labels.txt',col.names = c("activityId" ,"activityType"))

# read test data
test_x <- read.table('./data/UCI HAR Dataset/test/X_test.txt',col.names = var_names[,2])
test_y <- read.table('./data/UCI HAR Dataset/test/y_test.txt',col.names = "activityId")
test_sub<- read.table('./data/UCI HAR Dataset/test/subject_test.txt',col.names = "subjectId")

# read train data
train_x <- read.table('./data/UCI HAR Dataset/train/X_train.txt',col.names = var_names[,2])
train_y <- read.table('./data/UCI HAR Dataset/train/y_train.txt',col.names = "activityId")
train_sub <- read.table('./data/UCI HAR Dataset/train/subject_train.txt',col.names = "subjectId")

## 3 Merges the training and the test sets to create one data set

merged_x <- rbind(train_x ,test_x)
merged_y <- rbind(train_y , test_y)
merged_sub <- rbind(train_sub ,test_sub )

merged_data <- cbind(merged_x,merged_y ,merged_sub)

#4 Extracts only the measurements on the mean and standard deviation for each measurement

#  get feature names from data set 
col_names <- colnames(merged_data)

# extract only names that contains means and standard deviation

col_names1 <- (grepl("activityId" , col_names) | grepl("subjectId" ,col_names) |grepl("mean.." ,col_names)
               |grepl("std.." ,col_names))

#  get all the rows with variables that contains only mean and standard deviation
mean_and_std_data <- merged_data[, col_names1 == TRUE]


## 4 Uses descriptive activity names to name the activities in the data set

mean_and_std_activity_data <- merge(mean_and_std_data ,activity_labels ,by ="activityId" , all.x = TRUE)

##5-Appropriately labels the data set with descriptive variable names.

#already done

##6-From the data set in step 4, creates a second,independent tidy data set with the average of each variable for each activity and each subject.

mean_data <- mean_and_std_activity_data %>%
        group_by(activityType ,subjectId)%>%
        summarise_each(funs =mean)

#export tidydata set
write.table(mean_data , "./tidy_data.txt" ,sep = "\t" ,row.names = FALSE)





