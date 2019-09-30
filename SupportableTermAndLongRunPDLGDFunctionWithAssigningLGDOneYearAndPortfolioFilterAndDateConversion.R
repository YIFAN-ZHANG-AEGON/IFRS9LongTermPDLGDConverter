######################################################################################################################################
# This code will assign the logn run forward PD values for securities and loans using the public firm converter
######################################################################################################################################
library(lubridate)
library(readr)
library(magrittr)
library(data.table)
library(dplyr)
library(gridExtra)

convertSupportTermAndLongRunPDLGD<-function(inputWorkingDirectory,outputWorkingDirectory,idealizedDefaultRateFileName,longRunLGDFileName,updatedLGDFileName,instrumentReferenceFileName,portfolioFilter,supportableTerm,longRunTerm)
{
  setwd(inputWorkingDirectory)  # chagne the working directory to folder where idealized default rate file is saved
  require(data.table)
  
  ## Import the instrumentReference template without the mean reversion fields for PD
  input_data=read.csv(instrumentReferenceFileName,stringsAsFactors = F) # this file should be saved in above folder
  
  ## Idealized Default Rate Table
  def_rate=read.csv(idealizedDefaultRateFileName,stringsAsFactors = F) # this file should be saved in above folder
  colnames(def_rate)=c("rating",1:30)
  
  ## add mean reversion fields to instrumentReference. Skip this step if thse fields are already in the template
  input_data$pdReasonableAndSupportableTerm=supportableTerm ## update this to reflect client's inputs
  if (longRunTerm ==""){
    input_data$longRunPDTerm=NA
  }
  else{
    input_data$longRunPDTerm=longRunTerm
  }
  
  ## convert date format
  input_data$asOfDate=as.Date(mdy(input_data$asOfDate),"%Y-%m-%d")
  input_data$maturityDate=as.Date(mdy(input_data$maturityDate),"%Y-%m-%d")
  input_data$originationDate=as.Date(mdy(input_data$originationDate),"%Y-%m-%d")
  input_data$ytm=(input_data$maturityDate-input_data$asOfDate)/365.25  # calculate the remaining maturity in years using maturity date and as of date
  head(input_data$ytm)
  
  if (longRunTerm !=""){
    ## Calculate the long run forward PD
    for (i in 1:nrow(input_data)){
      input_data$matbucket[i]=min(30,max(longRunTerm+1,round(input_data$ytm[i],0)))
      if( input_data$longTermRatingForPD[i] %in% c("C","Ca","D")){
        input_data$longRunAnnualizedForwardPD[i]=1} 
      else{
          cpd1=def_rate[which(def_rate$rating==input_data$longTermRatingForPD[i]),which(colnames(def_rate)==longRunTerm)]
          cpd2=def_rate[which(def_rate$rating==input_data$longTermRatingForPD[i]),which(colnames(def_rate)==input_data$matbucket[i])]
          input_data$longRunAnnualizedForwardPD[i]=1-((1-cpd2)/(1-cpd1))^(1/(input_data$matbucket[i]-longRunTerm))
        }
    }
    
    ## remove calculated fields from input file
    ind1=grep("matbucket",colnames(input_data),ignore.case = T)
    input_data=input_data[,-ind1]
    ind2=grep("ytm",colnames(input_data),ignore.case = T)
    input_data=input_data[,-ind2]
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
  
  ## export the updated file
  readr::write_csv(input_data,tf <- tempfile(pattern="instrumentReference",tmpdir = outputWorkingDirectory,fileext = ".csv"), na="") # saves file in same folder as the input file
  return("successful")
}
