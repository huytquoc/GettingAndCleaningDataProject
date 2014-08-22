## Purpose:  run_analysis.R does the following:

## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Load data.
X_test <- read.table(".\\UCI HAR Dataset\\test\\X_test.txt")
y_test <- read.table(".\\UCI HAR Dataset\\test\\y_test.txt")
subject_test <- read.table(".\\UCI HAR Dataset\\test\\subject_test.txt")

X_train <- read.table(".\\UCI HAR Dataset\\train\\X_train.txt")
y_train <- read.table(".\\UCI HAR Dataset\\train\\y_train.txt")
subject_train <- read.table(".\\UCI HAR Dataset\\train\\subject_train.txt")

activity_labels <- read.table(".\\UCI HAR Dataset\\activity_labels.txt")[,2]
features <- read.table(".\\UCI HAR Dataset\\features.txt")[,2]


# Use descriptive activity names to name the activities in the data set
names(X_test) = features
names(X_train) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
extract_features <- grepl("mean|std", features)
X_test = X_test[,extract_features]
X_train = X_train[,extract_features]

# Set common column names for datasets
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Form datasets
test_data <- cbind(as.data.table(subject_test), y_test, X_test)
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Merge the training and the test sets to create one data set
merge_data = rbind(test_data, train_data)


# Appropriately label the data set with descriptive variable names.
id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(merge_data), id_labels)
final_data  = melt(merge_data, id = id_labels, measure.vars = data_labels)

# Create a second, independent tidy data set with the average of each variable for each activity and each subject
tidy_data   = dcast(final_data, subject + Activity_Label ~ variable, mean)

# Write tidy dataset to file
write.table(tidy_data, file = ".\\tidy_data.txt")