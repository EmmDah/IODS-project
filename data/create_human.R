


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


