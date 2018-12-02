


#Read the "Human development" and "Gender inequality" datas into R. 
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

#names of human developement
names(hd)
#names of gender inequlity
names(gii)
# look at the structure of human and gender inequality
str(hd)
str(gii)

# print out summaries of the human developemnt
summary(hd)
# print out summaries of the gender inequality
summary(gii)

#Look at the meta files and rename the variables with (shorter) descriptive names. (1 point)
colnames(hd) <- c("HDI_rank", "Country", "HDI", "Life_expectancy", "Exp_education", "Mean_education",
                  "GNI_per_Capita","GNI_minus_HDI_rank" )

colnames(gii) <- c("GII_rank", "Country", "GII_index", "MMR", "ABR", 
                   "PR", "SE_females", "SE_males",
                   "LFPR_females", "LFPR_males")

##Abbreviations used:
#Maternal mortality ratio (MMR), Adolescent birth rate (ABR)
#Share of parliamentary seats held by each sex (PR)
#Population with at least some secondary education (SE)
# Labour force participation rate (LFPR):


#Mutate the "Gender inequality" data and create two new variables. 

#First: ratio of Female and Male populations with secondary education 
?mutate()
gii <- mutate(gii, SE_ratio_FM = SE_females/SE_males)
#Second:  ratio of labour force participation (LFPR) of females and males in each country
gii <- mutate(gii, LFPR_ratio_FM = LFPR_females/LFPR_males)

#check data
head(gii)

#Join together dataset, Country is id
human <- inner_join(hd, gii, by = "Country")
head(human)
dim(human);str(human)

#'data.frame':	195 obs. of  19 variables:looks good!
. 
#save data
write.table(human, "~/GitHub/IODS-project/data/human_2018.txt", quote=F, sep="\t", row.names=F)

#Exercise 5

#read in data:

human <- read.delim("~/GitHub/IODS-project/data/human_2018.txt")
str(human)
head(human)

#rename according file in datacamp exercise


?rename()

library(stringr)

human <- rename(human,
                GNI = GNI_per_Capita,
                Life.Exp = Life_expectancy,
                Edu.Exp = Exp_education,
                Edu.Mean =Mean_education,
                GII.Rank=GII_rank,
                GII=GII_index,
                Mat.Mor =MMR,
                Ado.Birth=ABR, 
                Parli.F=PR,
                Edu2.F=SE_females,
                Edu2.M=SE_males,
                Labo.F=LFPR_females,
                Labo.M=LFPR_males,
                Edu2.FM=SE_ratio_FM, 
                Labo.FM=LFPR_ratio_FM)
                
head(human)
#GNI colum values are not okay, look at its structure
str(human$GNI)
  #Factor w/ 194 levels "1,096","1,123",..: 166 135 156 139 140 137 127 154 134 117

# remove the commas from GNI and print out a numeric version of it
library(tidyr);library(stringr)
human$GNI <- str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric 
?mutate()
head(human);str(human$GNI)
#looks good!

#select a subset of the variables in human and drop the others from the dataset
keep <-  c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp",
           "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

human <- select(human, one_of(keep))

# print out a completeness indicator of the 'human' data
complete.cases(human)

# print out the data along with a completeness indicator as the last column
data.frame(human[-1], comp = complete.cases(human))

# filter out all rows with NA values
#human_ <- filter(human, complete.cases(human))
human_ <- human[complete.cases(human), ]


# look at the last 10 observations
tail(human_, 10)

# last indice we want to keep
last <- nrow(human_) - 7

# choose everything until the last 7 observations
human_ <- human_[1:last, ]

# add countries as rownames
rownames(human_) <- human_$Country

#remove country column
human_ <- select(human_, -Country)

str(human_);head(human_)

complete.cases(human_)
write.table(human_, "~/GitHub/IODS-project/data/human_new_2018.txt", quote=F, sep="\t", row.names=T)
