## function 'convertSupportTermAndLongRunPDLGD': given the following files in folder 'inputWorkingDirectory', the reasonable and supportable PD term and long term PD will be filled, the date format will be corrected to yyyy-mm-dd. A new file named 'instrumentReferenceXXXX' will be generated.
#### instrumentReference.csv
#### idealized default rate.csv

## function inputs:
#### inputWorkingDirectory: the working directory, and the two input files are expected in the same folder as well.
#### outputWorkingDirectory: the output.
#### idealizedDefaultRateFileName: the name of the idealized default rate file.
#### instrumentReferenceFileName: the name of the original instrument reference file.
#### portfolioFilter: if applicable, the output will only contain the selected portfolio; if set to "" then th filter will not be applied.
#### supportableTerm: the value of expected 'pdReasonableAndSupportableTerm'.
#### longRunTerm: the value of expected 'longRunPDTerm'.

## function output:
#### a csv file named 'instrumentReferenceXXXX.csv' will be generated with the modified 'pdReasonableAndSupportableTerm', 'longRunPDTerm', 'longRunPD' is saved in the 'inputWorkingDirectory'.
#### the function will return a string 'successful'.

## below is an example:


## indicate the location of the function file 'SupportableTermAndLongRunPDFunction.R'
workingDirectory <-"C:/Temp/UATScript/IFRS9LongTermPDLGDConverter/"
setwd(workingDirectory)
source("SupportableTermAndLongRunPDLGDFunction.R")

## grant input of the function 'convertSupportTermAndLongRunPD'
inputWorkingDirectory <- workingDirectory
outputWorkingDirectory <- "C:/Temp/UATScript/temp/"
idealizedDefaultRateFileName <- "idealized default rate.csv"
instrumentReferenceFileName <- "instrumentReference.csv"
portfolioFilter <- ""
supportableTerm <-3
longRunTerm <- ""

successfulRun<-convertSupportTermAndLongRunPDLGD(inputWorkingDirectory,outputWorkingDirectory,idealizedDefaultRateFileName,instrumentReferenceFileName,portfolioFilter,
                                         supportableTerm,longRunTerm)
