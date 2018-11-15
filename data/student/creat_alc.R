#Emma Dahlstrom
#13 November 2018 
#Data from UCI Machine Learning Repository, Student Performance Data (incl. Alcohol consumption)
#https://archive.ics.uci.edu/ml/datasets/Student+Performance

#_______________________________STEP3_____________________________________________________
#read Read both student-mat.csv and student-por.csv into R
d1=read.table("~/GitHub/IODS-project/data/student/student-mat.csv",sep=";",header=TRUE)
d2=read.table("~/GitHub/IODS-project/data/student/student-por.csv",sep=";",header=TRUE)
#check dimensions
dim(d1);dim(d2)
  # [1] 395  33 --> dimensions of d1, 395 obs. of  33 variables
  # [1] 649  33 --> dimensions of d2, 649 obs. of  33 variables
#check structure, looks ok!
str(d1)
str(d2)


#_______________________________STEP4_____________________________________________________
#Join the two data sets using the variables "school", "sex", "age", "address", "famsize", 
#"Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet" as (student) 
#identifiers. Keep only the students present in both data sets. Explore the structure and 
#dimensions of the joined data. 

library(dplyr)

#select variables to join by
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob",
             "Fjob","reason","nursery","internet")


#Joining data using variables in "join_by" object, Keep only the students present in both 
#data sets. 
  #Join using merge()
  #d3 <-merge(d1,d2,by=c(join_by))
  
  #Join using inner_join() in dplyr
  d3 <- inner_join(d1, d2, by = join_by)

#structure and dimensions of data
  dim(d3);str(d3) 
  #382 obs. of  53 variables, structure looks ok!
  
#_______________________________STEP5_____________________________________________________
  
  # print out the column names of 'd3'
  colnames(d3)
  
  # create a new data frame with only the joined columns
  alc <- select(d3, one_of(join_by))
  
  # columns that were not used for joining the data
  notjoined_columns <- colnames(d1)[!colnames(d1) %in% join_by]
  
  # print out the columns not used for joining
  notjoined_columns
  
  # for every column name not used for joining...
  for(column_name in notjoined_columns) {
    # select two columns from 'math_por' with the same original name
    two_columns <- select(d3, starts_with(column_name))
    # select the first column vector of those two columns
    first_column <- select(two_columns, 1)[[1]]
    
    # if that first column  vector is numeric...
    if(is.numeric(first_column)) {
      # take a rounded average of each row of the two columns and
      # add the resulting vector to the alc data frame
      alc[column_name] <- round(rowMeans(two_columns))
    } else { # else if it's not numeric...
      # add the first column vector to the alc data frame
      alc[column_name] <- first_column
    }
  }
  
  # glimpse at the new combined data
  glimpse(alc)
  
  
#____________________________STEP 6______________________________
  
  library(dplyr)
  
  # define a new column alc_use by combining weekday and weekend alcohol (average of them)
  alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
  
  # define a new logical column 'high_use' (==alc_use > 2)
  alc <- mutate(alc, high_use = alc_use > 2)
  
#__________________________STEP 7_______________________________
  
  glimpse(alc) #looks good!
  #Observations: 382
  #Variables: 35
  
  #save alc to data folder
  write.table(alc, "~/GitHub/IODS-project/data/alc2018.txt", 
              sep="\t", 
              quote=F, 
              row.names = F)
  
  
