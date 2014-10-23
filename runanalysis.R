runanalysis<-function(){
    setwd("~/IDA/Getting and Cleaning Data/UCI HAR Dataset")
    library(dplyr)
    library(tidyr)
    features<-read.table("features.txt")
    activity<-read.table("activity_labels.txt")
    y_train<-read.table("train/y_train.txt")
    x_train<-read.table("train/x_train.txt")
    sub_train<-read.table("train/subject_train.txt")
    y_test<-read.table("test/y_test.txt")
    x_test<-read.table("test/x_test.txt")
    sub_test<-read.table("test/subject_test.txt")
    
    feature<-as.character(paste(features[,2],1:561))
    Readings<-rbind(x_train,x_test)
    colnames(Readings)<-as.character(feature) ##Uses descriptive activity names to name the activities in the data set
        
    y<-rbind(y_train,y_test)
    Activity<-data.frame("Activity"=y[,1])
    Activity[Activity==1]<-"Walking"
    Activity[Activity==2]<-"Walking Upstairs"
    Activity[Activity==3]<-"Walking Downstairs"
    Activity[Activity==4]<-"Sitting"
    Activity[Activity==5]<-"Standing"
    Activity[Activity==6]<-"Laying"
    
    subject<-data.frame("Subject"=rbind(sub_train,sub_test))
    colnames(subject)<-"Subjects"
    finala<-select(Readings,contains("mean()"))
    finalb<-select(Readings,contains("std()"))
    finalc<-cbind(finala,finalb) ##Extracts only the measurements on the mean and standard deviation for each measurement.
    final<-cbind(subject,Activity,finala,finalb) ##Merges the training and the test sets to create one data set.
    finald<-final%>% group_by(Subjects,Activity) %>% summarise_each(funs(mean))
    print(finald)
    write.table(finald,file="tidy.txt",row.name=FALSE)
}
runanalysis()
