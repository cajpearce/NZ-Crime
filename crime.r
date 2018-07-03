library(tidyverse)
library(data.table)
setwd("E:/Dropbox/Documents/R/crime")


keepcrimes = 
  c(''
    # , 'Serious Assault Resulting in Injury'
    # , 'Abduction and Kidnapping'
    # , 'Theft (Except Motor Vehicles), N.E.C.'
    # , 'Common Assault'
    # , 'Illegal Use of a Motor Vehicle'
    # , 'Aggravated Sexual Assault'
    # , 'Theft of Motor Vehicle Parts or Contents'
    # , 'Non-Aggravated Sexual Assault'
    # , 'Illegal Use of Property (Except Motor Vehicles)'
    # , 'Theft From Retail Premises'
    # , 'Theft of a Motor Vehicle'
    # , 'Serious Assault Not Resulting in Injury'
    # , 'Theft From a Person (Excluding By Force)'
    # , 'Blackmail and Extortion'
    # , 'Aggravated Robbery'
    # , 'Non-Aggravated Robbery'
    , 'Unlawful Entry With Intent/Burglary, Break and Enter'
  )



crime = fread("ANZSOC_data.csv",drop=c("Table 1",
                                       "Anzsoc Subdivision",
                                       "Anzsoc Division",
                                       "Locn Type Division",
                                       "Weapon"),
              stringsAsFactors = TRUE,
              check.names = TRUE) %>% 
  filter(Territorial.Authority == "Auckland.",
         !grepl("9$",Area.Unit),
         Anzsoc.Group %in% keepcrimes) %>%
  select(-Territorial.Authority) %>%
  mutate(Year.Month = as.Date(paste(Year.Month,"01",sep=""),format="%Y%m%d"),
         Area.Unit = gsub("[.]$","",Area.Unit))


anzsoc = crime %>% group_by(Anzsoc.Group) %>%
  summarise(Records = sum(Number.of.Records))

crime2 = crime %>%
  group_by(Area.Unit,Meshblock, Anzsoc.Group) %>%
  summarise(Records = sum(Number.of.Records))


meshblocks = fread("meshblocks.csv",
                   stringsAsFactors = FALSE,
                   check.names = TRUE)


meshblocks$WKT = gsub(",.+$","",meshblocks$WKT)
meshblocks$WKT = gsub("^.+[(][(][(]","",meshblocks$WKT)
meshblocks$longitude = as.numeric(gsub(" .+$","",meshblocks$WKT))
meshblocks$latitude = as.numeric(gsub("^.+ ","",meshblocks$WKT))

meshblocks = meshblocks[,c(2,8,9)]

colnames(meshblocks)[1] = "Meshblock"


crime2 = crime2 %>%merge(meshblocks)

saveRDS(crime2, "crime.rds")

