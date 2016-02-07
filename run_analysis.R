library(plyr)

# If not available: download data into directory "coursera" as file "smartphone_data"

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileName <- "./coursera/smartphone_data.zip"

if(!file.exists("./coursera")){
        dir.create("./coursera")
        if(!file.exists(fileName)){
                download.file(fileUrl,destfile=fileName)
                unzip(zipfile=fileName, exdir="./coursera")
        }
}

# Reading data sets from unzipped files

x_test <- read.table("./coursera/UCI HAR Dataset/test/x_test.txt")
y_test <- read.table("./coursera/UCI HAR Dataset/test/y_test.txt")
sub_test <- read.table("./coursera/UCI HAR Dataset/test/subject_test.txt")

x_train <- read.table("./coursera/UCI HAR Dataset/train/x_train.txt")
y_train <- read.table("./coursera/UCI HAR Dataset/train/y_train.txt")
sub_train <- read.table("./coursera/UCI HAR Dataset/train/subject_train.txt")

# Merges the training and the test sets to create one data set.

x_merge <- rbind(x_test, x_train)
y_merge <- rbind(y_test, y_train)
sub_merge <- rbind(sub_test, sub_train)

names(sub_merge) <- c("subject")
names(y_merge) <- c("activity")
features_names <- read.table("./coursera/UCI HAR Dataset/features.txt")
names(x_merge) <- features_names$V2

data_merge <- cbind(sub_merge, y_merge)
final_data <- cbind(x_merge, data_merge)

# Extracts only the measurements on the mean and standard deviation for each measurement.

sub_features_names <- features_names$V2[grep("mean\\(\\)|std\\(\\)", features_names$V2)]
sub_final_data <- subset(final_data, select = c(as.character(sub_features_names), "subject", "activity" ))

# Uses descriptive activity names to name the activities in the data set

y_labels <- read.table("./coursera/UCI HAR Dataset/activity_labels.txt")

## Could not sort this task out!

# Appropriately labels the data set with descriptive variable names.

names(sub_final_data) <- gsub("^t", "Time", names(sub_final_data))
names(sub_final_data) <- gsub("^f", "Frequency", names(sub_final_data))
names(sub_final_data) <- gsub("Acc", "Accelerometer", names(sub_final_data))
names(sub_final_data) <- gsub("Gyro", "Gyroscope", names(sub_final_data))
names(sub_final_data) <- gsub("Mag", "Magnitude", names(sub_final_data))
names(sub_final_data) <- gsub("BodyBody", "Body", names(sub_final_data))


# Creates a second, independent tidy data set with the average of each variable for each activity and each subject

tidy_data <- aggregate(. ~subject + activity, sub_final_data, mean)
write.table(tidy_data, file = "./coursera/tidydata.txt")
