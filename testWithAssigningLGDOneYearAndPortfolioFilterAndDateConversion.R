## function 'convertSupportTermAndLongRunPDLGD': given the following files in folder 'inputWorkingDirectory': 
#### instrumentReference.csv
#### idealized default rate.csv
#### instrumeneReferenceQIAUpdatedLGD

## the following actions are done:
#### the reasonable and supportable PD term and long term PD will be filled.
#### the one-year lgd will be replaced given the QIA file.
#### the date format will be corrected to yyyy-mm-dd.
#### the the reasonable and supportable LGD term and long term LGD will be filled. The 2 terms will be consistent with that of PD.
#### A new file named 'instrumentReferenceXXXX' will be generated.

## function inputs:
#### inputWorkingDirectory: the working directory, and the two input files are expected in the same folder as well.
#### outputWorkingDirectory: the output.
#### idealizedDefaultRateFileName: the name of the idealized default rate file.
#### updatedLGDFileName: the file contains updated 'lgdOneYear'.
#### instrumentReferenceFileName: the name of the original instrument reference file.
#### portfolioFilter: if applicable, the output will only contain the selected portfolio; if set to "" then th filter will not be applied.
#### supportableTerm: the value of expected 'pdReasonableAndSupportableTerm'.
#### longRunTerm: the value of expected 'longRunPDTerm'.

## function output:
#### a csv file named 'instrumentReferenceXXXX.csv' will be generated in the 'inputWorkingDirectory'：
###### the columns 'pdReasonableAndSupportableTerm', 'longRunPDTerm', 'longRunForwardPD'are modified
###### the columns 'lgdReasonableAndSupportableTerm', 'longRunLGDTerm', 'longRunLGD'are modified
###### the column 'lgdOneyear' is modified
###### the date columns are converted to yyyy-mm-dd
#### the function will return a string 'successful'.

## below is an example:

## indicate the location of the function file 'SupportableTermAndLongRunPDFunction.R'
workingDirectory <-"C:/Temp/UATScript/LongTermPDLGDConverter/"
setwd(workingDirectory)
View(convertSupportTermAndLongRunPDLGD)
source("SupportableTermAndLongRunPDLGDFunctionWithAssigningLGDOneYearAndPortfolioFilterAndDateConversion.R")

## grant input of the function 'convertSupportTermAndLongRunPD'
inputWorkingDirectory <- workingDirectory
outputWorkingDirectory <- "C:/Temp/UATScript/temp/"
idealizedDefaultRateFileName <- "idealized default rate.csv"
longRunLGDFileName <- "long run LGD.csv"
updatedLGDFileName <- "instrumentReferenceQIAUpdatedLGD.csv"
instrumentReferenceFileName <- "instrumentReference.csv"
portfolioFilter <- "TA_New_USA3"
supportableTerm <-5
longRunTerm <- 6

successfulRun<-convertSupportTermAndLongRunPDLGD(inputWorkingDirectory,outputWorkingDirectory,idealizedDefaultRateFileName,longRunLGDFileName,updatedLGDFileName,instrumentReferenceFileName,portfolioFilter,
                                         supportableTerm,longRunTerm)
