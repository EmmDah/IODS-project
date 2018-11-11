#Emma Dahlstrom
#November 11, 2018
#Cleaning up data for analysis

#read din data
data <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", header=T, sep="\t")

#check dimensions of data
  dim(data)
  #data has 183 rows and 60 columns
  str(data)
  #59 of the column variables are integers, 1 is a factor. variables in column 1-56 seem to be encoded
  #from 1 to 5. the last 4 variables are age, attitude, points and gender.
  
#Create an analysis dataset with the variables gender, age, attitude, deep, stra, surf and points.
  library(dplyr)
  
  # questions related to deep, surface and strategic learning
  deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
  surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
  strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
  
  # select the columns related to deep learning and create column 'deep' by averaging
  deep_columns <- select(data, one_of(deep_questions))
  data$deep <- rowMeans(deep_columns)
  
  # select the columns related to surface learning and create column 'surf' by averaging
  surface_columns <- select(data, one_of(surface_questions))
  data$surf <- rowMeans(surface_columns)
  
  # select the columns related to strategic learning and create column 'stra' by averaging
  strategic_columns <- select(data, one_of(strategic_questions))
  data$stra <- rowMeans(strategic_columns)
  
  #scale attitude variable
  data$attitude <- data$Attitude / 10
  
  # choose a handful of columns to keep
  keep_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")
  
  # select the 'keep_columns' to create a new dataset
  learning2018 <- select(data, one_of(keep_columns))
  
  # see the stucture of the new dataset
  str(learning2018)
  
  # print out the column names of the data
  colnames(learning2018)
  
  # change the name of the second column
  colnames(learning2018)[2] <- "age"
  
  # change the name of "Points" to "points"
  colnames(learning2018)[7] <- "points"
  # print out the new column names of the data
  colnames(learning2018)
  
  # select rows where points is greater than zero
  learning2018 <- filter(learning2018, points > 0)
  
  #check dimensions
  dim(learning2018)
  #has 7 columns, 166 observations.  
  
  write.table(learning2018, "~/GitHub/IODS-project/data/learning2018.txt", sep="\t", quote=F, row.names = F)
  learning2018 <- read.table("~/GitHub/IODS-project/data/learning2018.txt", header=T, sep="\t")
  dim(learning2018)  
  str(learning2018)
  head(learning2018)
