library(dplyr)
library(plyr)

features <- read.table('features.txt')

TEdataX <- read.table('test/X_test.txt', 
                      col.names = features$V2)
TEdataY <- read.table('test/y_test.txt', 
                      col.names = 'Labels')
TEsub <- read.table('test/subject_test.txt', 
                    col.names = 'Subjects')
Test <- cbind(TEsub, TEdataY, TEdataX)


TRdataX <- read.table('train/X_train.txt',
                      col.names = features$V2)
TRdataY <- read.table('train/y_train.txt', 
                      col.names = 'Labels')
TRsub <- read.table('train/subject_train.txt', 
                    col.names = 'Subjects')
Train <- cbind(TRsub, TRdataY, TRdataX)


MerTable <- arrange(rbind(Train, Test), Subjects)


activity_names <- read.table('activity_labels.txt')
MerTable$Labels <- factor(MerTable$Labels, 
                          levels = activity_names$V1,
                          labels = activity_names$V2)

stdCol <- grep("std", colnames(MerTable))
meanCol <- grep("mean", colnames(MerTable))
allCol <- c(1,2,stdCol, meanCol)

TidData <- MerTable[, allCol]

TidData2 <- ddply(TidData, 
                  .(Subjects, Labels), 
                  .fun=function(x)
                          { colMeans(x[,-c(1:2)]) })