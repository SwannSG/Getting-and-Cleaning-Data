<<<<<<< HEAD
Getting-and-Cleaning-Data
=========================

## run_analysis.R


# File Structure

1. ./
 1. *run_analysis.R* R program
 2. *README.md* Markdown document, application description
 3. *means_output_codebook.txt* Codebook for means_output.txt
 4. *means_output_codebook.txt* Codebook for means_output.txt
 5. *output_codebook.txt* Codebook for output.txt
 6. *output.txt* Each extracted feature per subject per activity
 7. *means_output.txt* Mean of extracted feature per subject per activity

2. ./data/UCI HAR Dataset
 1. *activity_labels.txt* Integer to activity name table*
 2. *features.txt* Codebook of features*

3. ./data/UCI HAR Dataset/test
 1. subject_test.txt Input source data, subjects*
 2. X_test.txt Input source data, value of each feature*
 3. y_test.txt Input source data, activities*

4. ./data/UCI HAR Dataset/train
 1. *subject_train.txt* Input source data, subjects*
 2. *X_train.txt Input* source data, value of each feature*
 3. *y_train.txt Input* source data, activities*

./ = working directory

*means the file is provided in the original Samsung source dataset

# Program Description

A feature to be extracted is automatically determined. It must contain '-mean', '-std', 'Mean' in the codebook
description in features.txt.

For test subjects we read subject_test.txt, X_test.txt, and y_test.txt. We merge data from these files into a single data frame called 'test'.  

For train subjects we read subject_train.txt, X_train.txt, and y_train.txt. We merge data from these files into a single data.table called 'train'.  

We merge 'test' and 'train' data.tables into a single data.table called 'output'. 

From the 'output' data.table we create 'means_output' data.table which contains the mean of each variable.

The 'output' table is ordered by subject + activity to 'ordered_output' data.table.

We replace 'activity' integer with 'activity' name in 'output_ordered' and 'means_output' data.frames, using the 'activities' lookup data.table.

We write 'output_ordered' out to a space delimited text file called 'output.txt'. The codebook for this file is 'output_codebook.txt'.

We write 'means_output' out to a space delimited text file called 'means_output.txt'. The codebook for this file is 'means_output_codebook.txt'.

Finally we self-document the codeboooks by creating 'output_codebook.txt', and 'means_output_codebook.txt'.  

# Codebooks

'output_codebook.txt': data values are measurements taken in realtime per feature.
'means_output_codebook.txt': data values represent the mean value for each feature. The mean is taken per feature per subject per activity. 

These documents should be read in conjunction with the Samsung documents README.txt, features_info.txt, and activity_labels_codebook.txt.
  
# Running run_analysis.R

Copy 'run_analysis.R' into a directory.
In the program edit the line `work_dir <- <working_directory>` (near line 32) and replace `<working_directory>`.

The program expects the Samsung data structure to be present relative to this `working_directory>`as per the above File Structure table.

>>>>>>> Course project - Getting and Cleaning Data
