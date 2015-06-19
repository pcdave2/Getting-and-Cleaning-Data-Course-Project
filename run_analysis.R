packages <- c("data.table", "reshape2")
sapply(packages, require, character.only=TRUE, quietly=TRUE)
activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("./UCI HAR Dataset/features.txt")[,2]
extractfeatures <- grepl("mean|std", features)
Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(Xtest) <- features
Xtest <- Xtest[,extractfeatures]
ytest[,2] <- activitylabels[ytest[,1]]
names(ytest) <- c("Activity_ID", "Activity_Label")
names(subjecttest) <- "subject"
testdata <- cbind(as.data.table(subjecttest), ytest, Xtest)
Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(Xtrain) <- features
Xtrain = Xtrain[,extractfeatures]
ytrain[,2] <- activitylabels[ytrain[,1]]
names(ytrain) <- c("Activity_ID", "Activity_Label")
names(subjecttrain) <- "subject"
traindata <- cbind(as.data.table(subjecttrain), ytrain, Xtrain)
combineddata <- rbind(testdata, traindata)
idlabels <- c("subject", "Activity_ID", "Activity_Label")
datalabels <- setdiff(colnames(combineddata), idlabels)
meltdata <- melt(combineddata, id = idlabels, measure.vars = datalabels)
tidydata <- dcast(meltdata, subject + Activity_Label ~ variable, mean)
write.table(tidydata, file = "./tidydata.txt")
