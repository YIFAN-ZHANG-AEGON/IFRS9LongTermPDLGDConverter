## input files in folder 'inputWorkingDirectory': 
#### instrumentReference.csv
#### idealized default rate.csv
#### long run LGD.csv

## output file in folder 'outputWorkingDirectory':
#### instrumentReferenceXXXXXXXX.csv

## the following actions are done:
#### the reasonable and supportable PD term and long term PD will be filled.
####  the reasonable and supportable LGD term and long term LGD will be filled. The 2 terms will be consistent with that of PD.
#### A new file named 'instrumentReferenceXXXX' will be generated.

## function inputs:
#### inputWorkingDirectory: the working directory, and the two input files are expected in the same folder as well.
#### outputWorkingDirectory: the output working directory.
#### idealizedDefaultRateFileName: the name of the idealized default rate file.
#### instrumentReferenceFileName: the name of the original instrument reference file.
#### supportableTerm: the value of expected 'pdReasonableAndSupportableTerm'.
#### longRunTerm: the value of expected 'longRunPDTerm'.

## function output:
#### a csv file named 'instrumentReferenceXXXX.csv' will be generated in the 'inputWorkingDirectory'：
###### the columns 'pdReasonableAndSupportableTerm', 'longRunPDTerm', 'longRunForwardPD'are modified
###### the columns 'lgdReasonableAndSupportableTerm', 'longRunLGDTerm', 'longRunLGD'are modified
#### the function will return a string 'successful'.

## below is an example:

## indicate the location of the function file 'SupportableTermAndLongRunPDFunction.R'
workingDirectory <-"C:/Temp/UATScript/LongTermPDLGDConverter/"
setwd(workingDirectory)
source("SupportableTermAndLongRunPDLGDFunction.R")
View(convertSupportTermAndLongRunPDLGD)

## grant input of the function 'convertSupportTermAndLongRunPD'
inputWorkingDirectory <- workingDirectory
outputWorkingDirectory <- "C:/Temp/UATScript/temp/"
idealizedDefaultRateFileName <- "idealized default rate.csv"
longRunLGDFileName <- "long run LGD.csv"
instrumentReferenceFileName <- "instrumentReference.csv"
supportableTerm <-5
longRunTerm <- 6

successfulRun<-convertSupportTermAndLongRunPDLGD(inputWorkingDirectory,outputWorkingDirectory,idealizedDefaultRateFileName,longRunLGDFileName,instrumentReferenceFileName,
                                         supportableTerm,longRunTerm)
