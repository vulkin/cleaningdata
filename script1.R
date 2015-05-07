##reading subject ids for test data
subject_test<-read.table("./data/test/subject_test.txt")

##reading test data
testset<-read.table("./data/test/x_test.txt")

##reading acitivty ids for test data
activity<-read.table("./data/test/y_test.txt")

##reading feature names
features<-read.table("./data/features.txt",colClasses="character")

##replacing column names of test data with feature names
for(i in 1:561){
  names(testset)[i]<-features[i,2]
}

##combining test data columns
test<-cbind(subject_test,activity,testset)


##reading subject ids for train data
subject_train<-read.table("./data/train/subject_train.txt")

##reading training data
trainset<-read.table("./data/train/x_train.txt")

##replacing training data column names with feature names
for(i in 1:561){
  names(trainset)[i]<-features[i,2]
}

##reading activity ids for training data
activitytrain<-read.table("./data/train/y_train.txt")

## combining training data columns
train<-cbind(subject_train,activitytrain,trainset)

## combining test and training data set
data<-rbind(test,train)

library(dplyr)
## converting to tbl
initial<-tbl_df(data)

##making all the column names valid and unique
validnames<-make.names(names=names(initial),unique=TRUE,allow_= TRUE)
names(initial)<-validnames
names(initial)[1]<- "subjectid"
names(initial)[2]<- "activityid"

##extracting the columns with "mean" or "std" in their names
step2<-select(initial,subjectid,activityid,contains("mean"),contains("std"))

## grouping data acc to subject and acitivity ids
step3<-group_by(step2,subjectid,activityid)

## sorting data acc to subject ids followed by acitivty ids
step3<-arrange(step3,subjectid,activityid)

## converting acitvity id into factor and replacing labesl with actual acitvity labels
step3$activityid<-as.factor(step3$activityid)
library(plyr)
step3$activityid<-revalue(step3$activityid,c("1"="WALKING","2"="WALKING_UPSTAIRS","3"="WALKING_DOWNSTAIRS","4"="SITTING","5"="STANDING","6"="LAYING"))

## again grouping acc to subject and acivity ids
grouped<-group_by(step3,subjectid,activityid)

## summarising each measurement column acc to grouped columns(ie acc to each subject and acitvity)
step5<-summarise_each(grouped,funs(mean)
