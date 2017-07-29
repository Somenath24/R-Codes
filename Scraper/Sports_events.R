#install.packages("htmltab")
library(htmltab)
library(stringr)
library(xlsx)
library(dplyr)
########### Sports Event #######################
sports_event=function(url){
  sportsdf=htmltab::htmltab(url, which=1)
  colnames(sportsdf)[1]="Date"
  
  sportsdf$Date=iconv(sportsdf$Date,"latin1", "ASCII", sub="-")
  sportsdf$Date=gsub('-+','-',sportsdf$Date) 
  sportsdf$Date=gsub(' +',' ',sportsdf$Date) 
  
  
  dates=data.frame(stringr::str_split_fixed(sportsdf$Date, "-", 2))
  
  dates[,1]=as.character(dates[,1])
  dates[,2]=as.character(dates[,2])
  month=substr(dates[,1],1,3)
  dates[,2]=ifelse(nchar(dates[,2])>0 & nchar(dates[,2])<=2, 
                   paste(month,dates[,2]),dates[,2])
  
  dates[,2]=dplyr::if_else(nchar(dates[,2])==0 ,dates[,1],dates[,2])
  dates[,2]=as.Date(dates[,2],"%b %d")
  dates[,1]=as.Date(dates[,1],"%b %d")
  dates[,2]=dplyr::if_else(is.na(dates[,2]),dates[,1],dates[,2])
  colnames(dates)=c("From","To")
  sportsdf_back=sportsdf
  sportsdf=cbind(dates,sportsdf[,-1])
  sportsdfl=c()
  sportsdf=sportsdf[!is.na(sportsdf[,1]),]
  for(i in 1:nrow(sportsdf)){
    daterange=seq(sportsdf[i,1],sportsdf[i,2],by=1)
    sportstemp=sportsdf[i,3:5]
    temp=cbind(daterange,sportstemp)
    sportsdfl=rbind(sportsdfl,temp)
  }
  return(sportsdfl)
}
setwd("D:/External_data/Scraper/R/Sports_event/")
url="http://www.topendsports.com/events/calendar-2015.htm"
write.xlsx(sports_event("http://www.topendsports.com/events/calendar-2015.htm")
           ,"sports.xlsx",row.names = F,sheetName = "2015")

write.xlsx(sports_event("http://www.topendsports.com/events/calendar-2016.htm")
           ,"sports.xlsx",row.names = F,sheetName = "2016",append = T)
write.xlsx(sports_event("http://www.topendsports.com/events/calendar-2017.htm")
           ,"sports.xlsx",row.names = F,sheetName = "2017",append = T)
