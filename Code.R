# The data sets for the code have been attached. 
# The user is requested to please follow the instructions as given at some points in the code
# The user should also make sure to please download the data sets provided.
# Without data sets the code will not run

# The code analyses the value of air pollution levels measurements over time, based on weather information, which include humidity and temperature, along with 5 sensors

# Importing various libraries to carry out various functions
# It is possible that these libraries are not installed in certain systems.
# In such a case, these will not work.
# Along side all the libraries code, a code is also written, which needs to be uncommented in case these libraries are not available in your system.

# install.packages("fpp")
library(fpp)

# install.packages("TSA")
library(TSA)

# install.packages("tseries")
library(tseries)

# install.packages("ggplot2")
library(ggplot2)

# install.packages("forecast")
library(forecast)

# install.packages("lubridate")
library(lubridate)

# install.packages("vars")
library(vars)

# install.packages("tidyverse")
library(tidyverse)

# Few code lines written below import various files into the system. 
# The path mentioned in the lines are according to the system on which the code is orignally written.
# Please change the path as per your system

list.files(path = "D:/3-1/Foundations of data Science/Assignment 2/MVTS")
# The above line lists all the files present in the folder

train <- read.csv("D:/3-1/Foundations of data Science/Assignment 2/MVTS/train.csv", header = TRUE)
test <- read.csv("D:/3-1/Foundations of data Science/Assignment 2/MVTS/test.csv", header = TRUE)
# The above lines import the .csv files, which will be used in the program

fh <- 2247
# fh denotes the number of forecast steps

data <- train[, 2:12]
head(data)
str(data)

# Vector data stores all the data which are to be used during the calculations. 
# The columns of date and time are left since they are not used in any calculations. 
# head method prints the initial values of every column
# str method displays the internal structure of an R object
# In this case, it is displaying the internal structure of data

# The following lines are used to sort out and remove duplicate elements from the list.
# The sorting is used for every raw data used in the program

data$deg_C <- gsub(',', '.', data$deg_C)
data$deg_C <- as.numeric(data$deg_C)

data$relative_humidity <- gsub(',', '.', data$relative_humidity)
data$relative_humidity <- as.numeric(data$relative_humidity)

data$absolute_humidity <- gsub(',', '.', data$absolute_humidity)
data$absolute_humidity <- as.numeric(data$absolute_humidity)

data$sensor_1 <- gsub(',', '.', data$sensor_1)
data$sensor_1 <- as.numeric(data$sensor_1)

data$sensor_2 <- gsub(',', '.', data$sensor_2)
data$sensor_2 <- as.numeric(data$sensor_2)

data$sensor_3 <- gsub(',', '.', data$sensor_3)
data$sensor_3 <- as.numeric(data$sensor_3)

data$sensor_4 <- gsub(',', '.', data$sensor_4)
data$sensor_4 <- as.numeric(data$sensor_4)

data$sensor_5 <- gsub(',', '.', data$sensor_5)
data$sensor_5 <- as.numeric(data$sensor_5)

str(data)
# str is again used to note the internal structure of object data

data_var <- VAR(data, p = 1, type = "both", season = 12)
summary(data_var)

# VAR function is present in library vars
# It is used in implementing the Vector Auto Regression model on the data extracted
# Variable p denoted the lag order
# Variable type denotes the type of deterministic regressor.
# "both" is used as the deterministic regressor
# Variable season denotes the number of variable used 
# The data contains 12 columns, hence 12 is assigned to the variable season

# summary function gives a detailed overview of what the object contains

forecast <- predict(data_var, n.ahead = fh)$fcst

# predict function is present in library vars
# It is used in forecasting a VAR object. In this case, it is used to forecast the value of data_var
# Variable n.ahead is used in specifying the number of forecast steps, whihc have been initially specified.

f1 <- forecast$target_carbon_monoxide[, 1]
f2 <- forecast$target_benzene[, 1]
f3 <- forecast$target_nitrogen_oxides[, 1]

# f1, f2, and f3 stores the values of the forecasted values of target carbon monoxide, target benzene, and target notrogen oxides
# They are used so that they can be used easily to make a new file with the forecasted values

output <- read.csv("D:/3-1/Foundations of data Science/Assignment 2/MVTS/sample_submission.csv")

# A file named sample_submission.csv have been imported so as to preserve the pattern in which the data is being stored in the course of code

output["target_carbon_monoxide"] = f1
output["target_benzene"] = f2
output["target_nitrogen_oxides"] = f3

# The forecasted values are being updated in the folder sample_submission.csv, through a variable output

output[1, 2:4] <- train[7111, 10:12]
output
# The variable output is being printed on screen after storing the values of the output

write.csv(output, "D:/3-1/Foundations of data Science/Assignment 2/MVTS/submission.csv", row.names = FALSE)
# A seperate file is also being made to save the submissions.