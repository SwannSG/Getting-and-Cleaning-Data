feature_variable <- function( string ) {
  # pass variable name from features.txt
  # return True if variable name contains '-mean', '-std', 'Mean'
  if ( length(grep('-mean', string, fixed=TRUE)) >= 1 ) {
    return (TRUE)
  }
  if ( length(grep('-std', string, fixed=TRUE)) >= 1 ) {
    return (TRUE)
  }
  if ( length(grep('Mean', string, fixed=TRUE)) >= 1 ) {
    return (TRUE)
  }
  return (FALSE)
}

features_we_want <- function( x ) {
  # pass features.txt as table
  # returns data.frame
  #   columns col_pos, var_name 
  f <- data.frame()
  for (i in 1:nrow( x )) {
    if ( feature_variable(x[i, 2]) ) {
      f <-rbind(f, x[i, ])
    }
  }
  names(f)[1] <- 'col_pos'
  names(f)[2] <- 'var_name'
  return (f)
}

#--directory structure ************************************************************
#-- set working directory here
work_dir <- '~/Courses/Coursera/3-Getting and Cleaning Data/Project/final'
setwd(work_dir)
#--we use the Samsung data structure
#---- expects features.txt, activity_labels.txt files 
desc_dir <- './data/UCI HAR Dataset'
#--location of test data
#----expects subject_test.txt, X_test.txt, y_test.txt files
test_dir <-'./data/UCI HAR Dataset/test'
#--location of train data
#----expects subject_train.txt, X_train.txt, y_train.txt files
train_dir <-'./data/UCI HAR Dataset/train'
#--end directory structure ********************************************************


# find Variables for extraction in features.txt************************************
#   mean, dev, Mean in variable name
filename <- 'features.txt'
features <- read.table(paste(desc_dir, filename, sep='/'), stringsAsFactors=FALSE)
# feature lookup (fl), column names: col_pos, var_name 
fl <- features_we_want(features) 
rm(features)
# end find Variables for extraction in features.txt********************************

# create activity lookup table ****************************************************
filename <- 'activity_labels.txt'
activities <- read.table(paste(desc_dir, filename, sep='/'), stringsAsFactors=FALSE)
names(activities)[1] <- 'code'
names(activities)[2] <- 'name'
# end create activity lookup table ************************************************

# create test frame****************************************************************
#--add subject column
filename <- 'subject_test.txt'
test <- read.table(paste(test_dir, filename, sep='/'), stringsAsFactors=FALSE)
names(test)[1] <- 'subject'
#--add group column
#----test group (1), train group (2)
test <- cbind(test, rep(1, nrow(test)))
names(test)[2] <- 'group'
#--add test column
filename <- 'y_test.txt'
x <- read.table(paste(test_dir, filename, sep='/'), stringsAsFactors=FALSE)
test <- cbind(test, x)
names(test)[3] <- 'activity'
#--add each feature variable
filename <- 'X_test.txt'
x <- read.table(paste(test_dir, filename, sep='/'), stringsAsFactors=FALSE)
for (i in 1:nrow(fl)) {
  col_pos <- fl[i, 1]
  var_name <- fl[i, 2]
  test <- cbind(test, x[, col_pos])
  names(test)[3 + i] <- var_name
}
rm(x)
# end create test frame************************************************************

# create train frame****************************************************************
#--add subject column
filename <- 'subject_train.txt'
train <- read.table(paste(train_dir, filename, sep='/'), stringsAsFactors=FALSE)
names(train)[1] <- 'subject'
#--add group column
#----test group (1), train group (2)
train <- cbind(train, rep(2, nrow(train)))
names(train)[2] <- 'group'
#--add test column
filename <- 'y_train.txt'
x <- read.table(paste(train_dir, filename, sep='/'), stringsAsFactors=FALSE)
train <- cbind(train, x)
names(train)[3] <- 'activity'
#--add each feature variable
filename <- 'X_train.txt'
x <- read.table(paste(train_dir, filename, sep='/'), stringsAsFactors=FALSE)
for (i in 1:nrow(fl)) {
  col_pos <- fl[i, 1]
  var_name <- fl[i, 2]
  train <- cbind(train, x[, col_pos])
  names(train)[3 + i] <- var_name
}
rm(x)
# end create train frame ***********************************************************

# create output frame **************************************************************
output <- data.frame()
output <- rbind(output, test)
output <- rbind(output, train)
rm(test)
rm(train)
# end create output frame *********************************************************


# create means_output *************************************************************
# create a second, independent tidy data with the average of
# each variable for each activity and each subject
means_output <- data.frame()
for (i in 1:30) {
  for (j in 1:nrow(activities)) {
    subset <- output[output$subject==i & output$activity==j, ]
    if ( nrow(subset) > 0 ) {
      means <- subset[1, c('subject', 'activity')]
      # select relevent feature columns
      var_subset <- subset[, 4:89]
      var_means <- colMeans(var_subset)
      means <- data.frame( c(means, var_means) )
      means_output <- rbind(means_output, means)
    }
  }
}
# name columns of means_output
for (i in 1:nrow(fl)) {
  names(means_output)[2 + i] <- fl[i,2] 
}
#--replace activity code with activity name in means_output******************
for (i in 1:nrow(means_output)) {
  activity_code <- means_output[i, 'activity']
  activity_name <- activities[activity_code, 'name']
  means_output[i, 'activity'] <- activity_name
}
#--sort means_output on subject, activity *********** *****************************
order <- order( means_output$subject, means_output$activity )
means_output <- means_output[ order, ]
# end create means_output *****************************************************

#--replace activity code (integer) with activity name in output *******************
for (i in 1:nrow(output)) {
  activity_code <- output[i, 'activity']
  activity_name <- activities[activity_code, 'name']
  output[i, 'activity'] <- activity_name
}
#**********************************************************************************

#--sort output on subject, activity to output_ordered *****************************
order <- order( output$subject, output$activity )
output_ordered <- output[ order, ]
# *********************************************************************************

#--export output, means_output ********************************************** 
# output to output.txt
filename <- 'output.txt'  
write.table(output_ordered, filename, sep=" ", row.names=FALSE, quote=FALSE)
# means_output to means_output.txt
filename <- 'means_output.txt'  
write.table(means_output, filename, sep=" ", row.names=FALSE, quote=FALSE)
#--end of export ************************************************************

#--update codebooks, auto document ******************************************
# filename <- 'output_codebook.txt'
# write.table(names(output_ordered), filename, sep=" ", row.names=FALSE,
#             col.names=FALSE, quote=FALSE)
# filename <- 'means_output_codebook.txt'
# write.table(names(means_output), filename, sep=" ", row.names=FALSE,
#             col.names=FALSE,quote=FALSE)
#--end of codebook update ***************************************************




