
#=============================================================
#
# 2014 Social Netowork Analysis in R Workshop	
# by Alex Leavitt and Josh Clark
# brought to you by the Annenberg Networks Network
# and the Annenberg School for Communication & Journalism
#
#=============================================================

# R software used in this course:
# R: http://cran.cnr.berkeley.edu 
# RStudio: http://www.rstudio.org

# Some helpful resources:
# Google: http://google.com
# StackOveflow: http://stackoverflow.com

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#===============================================
#  Set your working directory
#===============================================

# The working directory is the place where R will look for, load, and save files, 
# unless otherwise instructed. Note that the directory path is Unix-style (instead of PC),
# and it uses slash (/) rather than backslash (\). 

# Check the current working directory
getwd() 

# But wait, how do you even run this??
# First, you can copy and paste the line into the Console.
# Second, you can just highlight the line (or lines) and click Run (top-right) 
# or press Command-Return (Mac).  

# Set the working directory
#setwd("C:/Users/<yourusername>/Desktop/SNAinRWorkshop") #PC
#setwd("/Users/<yourusername>/Desktop/SNAinRWorkshop") #Mac

# In RStudio you can also change the working directory from 
# Tools -> Global Options [General]


#===============================================
# Comments
#===============================================

# As you might have noticed, comments in R are marked with a "#"
# In RStudio, you can comment/uncomment blocks of text by 
# putting your cursor on one light or highlighting multiple lines and
# using Ctrl+Shift+C (Windows) or Shift-Command-C (Mac).
#
# dflk
# sdflkj
# #

#===============================================
# Do you need help?
#===============================================

# You can find out more about specific functions: help() or ?.
# If you don't remember the exact name of the function you're looking for,
# use double question mark (??).

# Help on function called data.frame
?data.frame

# Use ?? if you're not quite sure about the name of the function
??"factor"

# You can get help on built in datasets too
?Cars93  # A description of the dataset. This won't work, until we load the data, below.
# But you should see your first error. Let's talk about it!

# Finally, you can submit to fate...
????"oh god what am I doing"



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



#===============================================#
# Installing R packages
#===============================================#

# Some of the functions you will need in R come in packages:
# topic-specific libraries that you can download from the R 
# project website. If you know the name of the package you need, 
# you can install it from the command line using install.package()

# install.packages("sna")
# install.packages("network")
# install.packages("igraph")
# install.packages("statnet")
 

#===============================================
# Loading an installed R package
#===============================================

# Before you can use a package, you need to load it using library(). 
# Packages can be detached using detach(package:).

library("MASS")

detach("package:MASS")

library("MASS")

#===============================================
# Loading built-in datasets
#===============================================

# Many packages include sample datasets.
# You can see a list of those using data()

data()        # list datasets
data(Cars93)  # load this built-on dataset (from package MASS)
Cars93        # take a look at the data
head(Cars93)  # look at the first 6 rows of the data. VERY helpful for 
              # understanding the basic structure of larger files.
summary(Cars93)

# And getting help, from above:
?Cars93  # A description of the dataset.


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#===============================================
# Simple calculations
#===============================================

2 + 2

2^2+2*2

2^(2+2)*2

sqrt(abs(-4))


#===============================================
# Assigning and comparing values
#===============================================


# You can assign a value to an object using assign() or "<-".  
# You could also use the equal sign "=". Since there are specific 
# cases were <- and = lead to different outcomes, it's a good idea 
# to stick with "<-" for assignment. You can remove objects with rm().

x       <-        3         # Assignment
x              # R evaluates the expression and prints the result

y <- 4         # Assignment
y + 5          # Evaluation, note that y remains 4

z <- x + 17*y  # Assignment
z              # Evaluation

rm(z)          # Remove z, this deletes the object.
z              # Try to evaluate z... and fail.


# You can check equality with "==" and inequality with "!=".  
# Traditional comparison operators like less than (<) 
# and less than or equal (<=), etc. will also work.

2==2  

2!=2

x <= y 


#===============================================
#  Small things that will go wrong
#===============================================


# Look out for the following things when using R:
#
#  - R doesn't care about spacing - you can write "a+b", "a + b" or "a    +    b".
#    However it is CASE SENSITIVE. If you get your capitalization wrong, things won't work.

hello <- 4

goodbye <- 3

hello - goodbye
# See the error?


#  - As you work with multiple packages, keep in mind that some of them will contain 
#    functions that have the same name. So while you may be trying to use function blah 
#    from package X, what you may actually be using is the blah from package Y. 
#    Detach Y or call the function as X::blah rather than just blah.




#===============================================
# Null Values
#===============================================

# NA
# In R, missing or undefined data has the special value NA
# You can check whether values are missing with is.na()
# If you use NA in an operation (e.g. 5+NA), the result 
# will generally also be NA

cat <- NA
dog <- TRUE
is.na(cat)
is.na(dog)

# NULL
# NULL represents an empty object - e.g. a null/empty list
# You can check whether values are NULL with is.null()

# NaN
# NaN or Not a Number is assigned when the result of an operation
# can not be reasonably defined - for instance 0/0

0/0
is.nan(0/0)




#===============================================
# Reviewing What You've Done
#===============================================

# The data you load, variables you create, etc. are stored in a commong workspace

ls()      # get a list of the objects you have created in the current R session.
search()  # get a list of all currently attached packages.


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#===============================================
# Vectors (and a quick note about Types)
#===============================================


# You can create a vector object by combining elements with c()

v1 <- c(1, 7, 11, 22)       # Vector of integers (numeric)
v1
v2 <- c("hello","world")    # Vector of strings (character)
v2
v3 <- c(TRUE, TRUE, FALSE)  # Vector of booleans (logical)
v3                          # Same as c(T, T, F), so you can abbreviate.

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++
# SIDENOTE: Factors & Changing Types
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Factors are used for categorical data.

eye.col.v <- c("brown", "green", "brown", "blue", "blue", "blue") #vector
eye.col.f <- factor(c("brown", "green", "brown", "blue", "blue", "blue")) #factor

eye.col.ff <- factor(eye.col.v)

# R finds the different levels of the factor - e.g. all distinct values. The data is stored
# internally as integers - each number corresponding to a factor level.

levels(eye.col.f)  # The levels (distinct values) of the factor (categorical variable)

as.numeric(eye.col.f)  # The factor as numeric values: 1 is  blue, 2 is brown, 3 is green
as.numeric(eye.col.v)  # The character vector, however, can not be coerced to numeric

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++


# Vectors can only contain elements of a single type. If you 
# try to make R combine types, it will coerce your elements
# into the least restrictive type. 

v4 <- c(v1,v2,v3,"boo") 	#All elements magically turn into strings
v4

# Other ways to create vectors:

v <- 1:7         # same as c(1,2,3,4,5,6,7)  

v <- rep(0, 77)  # repeat zero 77 times: v is a vector of 77 zeroes
length(v)        # check the length of the vector

v <- rep(1:3, times=2) # Repeat 1,2,3 twice  

v <- rep(1:10, each=2) # Repeat each element twice  

v <- seq(10,20,2) # sequence: numbers between 10 and 20, in jumps of 2  


#===============================================
# Vectors & Operations
#===============================================

# NOTE that the operations listed in this section can also be applied 
# to the rows or columns of matrices, arrays and data frames.

# Element-wise operations

v1 <- 1:5         # 1,2,3,4,5. This assignment erases the old value of v1.
v2 <- rep(1,5)    # Aka. "Repeat 1, and do it 5 times." You get: 1,1,1,1,1. 

v1 + v2      # Element-wise addition
v1 + 1       # Add 1 to each element
v1 * 2       # Multiply each element by 2
v1 + c(1,7)  # This doesn't work: (1,7) is a vector of different length

# Logical operations

v1 > 2       # Each element is compared to 2, returns logical vector (TRUE or FALSE for each element)
v1==v2       # Are corresponding elements equivalent? Returns logical vector.
v1!=v2       # Are corresponding elements *not* equivalent? Same as !(v1==v2). Returns logical vector.

(v1>2) | (v2>0)  # | is the boolean OR, returns a vector.
(v1>2) & (v2>0)  # & is the boolean AND, returns a vector.

(v1>2) || (v2>0)  # || is the boolean OR - returns a single value
(v1>2) && (v2>0)  # && is the boolean AND - ditto

# Standard mathematical operations can be used with numerical vectors:

sum(v1)      # The sum of all elements
mean(v1)     # The average of all elements
sd(v1)       # The standard deviation
cor(v1,v1*5) # Correlation between v1 and v1*5

# Vector elements

v1[3]             # third element of v1
v1[2:4]           # elements 2, 3, 4 of v1
v1[c(1,3)]        # elements 1 and 3 - note that your indexes are a vector
v1[c(T,T,F,F,F)]  # elements 1 and 2 - only the ones that are TRUE
v1[v1>3]          # v1>3 is a logical vector TRUE for elements >3

# Note that all comparisons return logical vectors that can be assigned to an object:
LogVec <- v1 > 3  # Logical vector, same length as v1, TRUE (or T) where v1 elements > 3
v1[LogVec]        # Returns only those elements from v1 that are > 3

# To add more elements to a vector, simply assign them values.
# Elements 5 to 10 are assigned values 5,6,7,8,9,10:
v1[6:10] <- 6:10

# We can also directly assign the vector a length:
length(v1) <- 15 # the last 5 elements are added as missing data: NA

# You can also create a special type of multiple vectors, which we know as a matrix!
matrix1 <- matrix(1:25,5,5)
matrix1

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#===============================================
# Data Frames
#===============================================

# The data frame is a special kind of list used for datasets.
# Think of rows as cases, columns as variables. Each column is a vector or factor.

head(Cars93)    # Let's take another look at the cars93 dataset
class(Cars93)   # What is the data format? Look, it's a data frame!

# Creating our own dataframe:

people.df <- data.frame(ID=c(1, 2, 3, 4),FirstName=c("John","Jim","Jane","Jill"), Female=c(F,F,T,T), Age=c(22,33,44,55))
people.df
people.df$Id   # This is the second column of people.df. Notice that R thinks this is a categorical variable
# and so it's treating it like a factor, not a character vector.

# Let's get rid of the factor by telling R to treat FirstName as vector:
people.df$FirstName <- as.vector(people.df$FirstName)
people.df
people.df$FirstName

# Alternatively, you can tell R you don't like factors from the start using stringsAsFactors=FALSE:
people2.df <- data.frame(FirstName=c("John","Jim","Jane","Jill"),stringsAsFactors=FALSE)
people2.df$FirstName   # Success: not a factor.


# Access elements of the data frame
people.df[1,]   # First row, all columns
people.df[,1]   # First column, all rows
people.df$Age   # Age column, all rows
people.df[1:2,3:4] # Rows 1 and 2, columns 3 and 4 - the gender and age of John & Jim
people.df[c(1,3),] # Rows 1 and 3, all columns

people.df$Age <- c(15,25,35,45, 30) # Change the Age column to this vector

# Let's find the age of Jill.

people.df[4,4]

# What if we don't know exactly which row is Jill?
# Find all rows for which FirstName == Jill. For those rows, select column 4 (Age):

people.df[people.df$FirstName=="Jill",4] 

# Find the names of everyone over the age of 30 in the data

people.df[people.df$Age>30,2]

# Find the average age of all females in the data:

mean ( people.df[people.df$Female==TRUE,4] )


# Operations on datasets work just like those for vectors.

people.df$Age * 10            # Age multiplied by 10 (Evaluation, Age does not change)
people.df$ID <- people.df$ID * 10  # Replace ID with ID*10 (Assignment, ID does change)
people.df$ID > 20             # A boolean vector, TRUE for cases with ID > 20

# Add a new column/variable to the data frame
people.df$Human <- c(TRUE, TRUE, TRUE, TRUE)
people.df[,6]   <- 1:4

# Add a new case/row to the data frame
people.df[5,2] <- "Pete" # Note that we just set the name for this case.
# All other values are missing: NA

# We can also turn matrix objects into data frames:
m1 <- matrix(1:100,10,10)
m1
d1 <- as.data.frame(m1) 
d1

class(m1); class(d1) 

# m1 is a matrix, it can contain only one kind of elements.
# If we replace one element with a string, all other elements
# of the matrix will turn into strings.

m1[1,1] <- "Boo!" 

# The same is not true of a data frame, which can store 
# different types of objects.

d1[1,1] <- "Boo!"







