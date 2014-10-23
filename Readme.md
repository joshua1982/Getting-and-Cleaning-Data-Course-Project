##README
The following lists all the codes used and their function.  

runanalysis<-function(){
setwd("~/IDA/Getting and Cleaning Data/UCI HAR Dataset") 		## This sets the working directory
    library(dplyr)
    library(tidyr) 							## this loads the required libraries that will be used.
features<-read.delim("features.txt",head=FALSE,sep="") 			## this reads the features.txt file
activity<-read.delim("activity_labels.txt",head=FALSE,sep="")		## this reads the activity_labels.txt file
y_train<-read.delim("train/y_train.txt",head=FALSE,sep="") 		## this reads the y_train.txt file
x_train<-read.delim("train/x_train.txt",head=FALSE,sep="") 		## this reads the x_train.txt file
sub_train<-read.delim("train/subject_train.txt",head=FALSE,sep="") 	## this reads the subject_train.txt file
y_test<-read.delim("test/y_test.txt",head=FALSE,sep="")  		## this reads the y_test.txt file
x_test<-read.delim("test/x_test.txt",head=FALSE,sep="")  		## this reads the x_test.txt file
sub_test<-read.delim("test/subject_test.txt",head=FALSE,sep="") 	## this reads the subject_test.txt file
  
feature<-paste(features[,2],1:561)  					## this adds numbers 1:561 to the features list in features.txt to ensure uniqueness of the column names
Readings<-rbind(x_train,x_test) 					## this combines the x_train.txt and x_test.txt files
colnames(Readings)<-feature 						## this makes the feature vector the column name of Readings

y<-rbind(y_train,y_test) 						## this combines the y_train.txt and y_test.txt files
Activity<-data.frame("Activity"=y[,1]) 					## this series of commands creates the Activity labels for the 6 various activities and labels them by name according 									to their assigned code numbers. 
    Activity[Activity==1]<-"Walking"
    Activity[Activity==2]<-"Walking Upstairs"
    Activity[Activity==3]<-"Walking Downstairs"
    Activity[Activity==4]<-"Sitting"
    Activity[Activity==5]<-"Standing"
    Activity[Activity==6]<-"Laying"

    subject<-data.frame("Subject"=rbind(sub_train,sub_test)) 		## this combines the list of subjects from the subject_train.txt and subject_test.txt files
    colnames(subject)<-"Subjects" 					## this ensures that the data frame of all 30 subjects is titled "Subjects"
    finala<-select(Readings,contains("mean()")) 			## this extracts all columns that contain the word "mean()" in their titles.
    finalb<-select(Readings,contains("std()")) 				## this extracts all columns that contain the word "std()" in their titles.
    finalc<-cbind(finala,finalb) 					## Combines the data from finala and finalb (all columns that contain either "mean() or std()" in their titles
    final<-cbind(subject,Activity,finala,finalb) 			## Merges the training and the test sets to create one data set.
    finald<-final%>% group_by(Subjects,Activity) %>% summarise_each(funs(mean))  ## creates the tidy data set by grouping the data by Subjects and then by Activity and summarizing the values by subject and activity into their averages
    print(finald)							## prints the tidy data set
    write.table(finald,file="tidy.txt")					## writes the table to text
}
runanalysis()
