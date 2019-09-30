## input files in folder 'inputWorkingDirectory': 
#### instrumentReference.csv
#### idealized default rate.csv
#### long run LGD.csv

## output file in folder 'outputWorkingDirectory':
#### instrumentReferenceXXXXXXXX.csv

## the following actions are done:
#### the reasonable and supportable PD term and long term PD will be filled.
#### the reasonable and supportable LGD term and long term LGD will be filled. The 2 terms will be consistent with that of PD.
#### a new file named 'instrumentReferenceXXXX' will be generated.

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

library(lubridate)
library(readr)
library(magrittr)
library(data.table)
library(dplyr)
library(gridExtra)

convertSupportTermAndLongRunPDLGD<-function(inputWorkingDirectory,outputWorkingDirectory,privateForwardPDFileName,longRunLGDFileName,instrumentReferenceFileName,supportableTerm,longRunTerm)
{
  setwd(inputWorkingDirectory)  # chagne the working directory to folder where idealized default rate file is saved
  require(data.table)
  
  ## Import the instrumentReference template without the mean reversion fields for PD
  input_data=read.csv(instrumentReferenceFileName,stringsAsFactors = F) # this file should be saved in above folder
  # calculate the remaining maturity in years using maturity date and as of 
  input_data$asOfDate=as.Date(mdy(input_data$asOfDate),"%Y-%m-%d")
  input_data$maturityDate=as.Date(mdy(input_data$maturityDate),"%Y-%m-%d")
  input_data$originationDate=as.Date(mdy(input_data$originationDate),"%Y-%m-%d")
  input_data$ytm <- (input_data$maturityDate-input_data$asOfDate)/365.25  
  head(input_data$ytm)
  
  ## long run forward PD private
  private_forward_PD =read.csv(privateForwardPDFileName,stringsAsFactors = F) # this file should be saved in above folder
  
  ## add mean reversion fields to instrumentReference. Skip this step if thse fields are already in the template
  input_data$pdReasonableAndSupportableTerm=supportableTerm 
  if (longRunTerm ==""){
    input_data$longRunPDTerm=NA
  }
  else{
    input_data$longRunPDTerm=longRunTerm
  }

  if (longRunTerm !=""){
    ## Calculate the long run forward PD
    for (i in 1:nrow(input_data)){
      if (input_data$longTermRatingForPD[i]!=""){
        input_data$longRunAnnualizedForwardPD[i]=private_forward_PD[which(private_forward_PD$Rating==input_data$longTermRatingForPD[i]),2]
      }
      else if (input_data$internalRatingInitial[i]!="") {
        input_data$longRunAnnualizedForwardPD[i]=private_forward_PD[which(private_forward_PD$Rating==input_data$longTermRatingForPD[i]),2]
      }
      else{
        input_data$longRunAnnualizedForwardPD[i]=private_forward_PD[which(private_forward_PD$Rating=="B1"),2]
      }
    }
  }
  
  ## assign lgdReasonableAndSupportableTerm and longRunLGDTerm according to that of PD
  input_data$lgdReasonableAndSupportableTerm = input_data$pdReasonableAndSupportableTerm
  input_data$longRunLGDTerm = input_data$longRunPDTerm
  
  ## read long run LGD Table
  long_run_LGD=read.csv(longRunLGDFileName,stringsAsFactors = F) # this file should be saved in above folder

  ## apply the filter and assign the value
  for (i in 1:nrow(long_run_LGD)){
    ## find where asset class is 'REST' and industry is 'REST' and assign all the longRunLGD with that value
    if(long_run_LGD$assetSubClass1[i]=="REST" && long_run_LGD$primaryGcorrFactorNameSector[i]=="REST"){
      input_data$longRunLGD <- long_run_LGD[i,which(colnames(long_run_LGD)=="longRunLGD")]} 
    else{
       assetFilter <- input_data$assetSubClass1 == long_run_LGD[i,which(colnames(long_run_LGD)=="assetSubClass1")]
       industryFilter <- input_data$primaryGcorrFactorNameSector == long_run_LGD[i,which(colnames(long_run_LGD)=="primaryGcorrFactorNameSector")]
       assetAndIndustryFilter <- assetFilter & industryFilter
       input_data$longRunLGD[assetAndIndustryFilter] <- long_run_LGD[i,which(colnames(long_run_LGD)=="longRunLGD")]}
  }
  browser()
  ## export the updated file
  readr::write_csv(input_data,tf <- tempfile(pattern="instrumentReference",tmpdir = outputWorkingDirectory,fileext = ".csv"), na="") # saves file in same folder as the input file
  return("successful")
}
