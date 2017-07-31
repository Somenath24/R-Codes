#add/change the key 
key=""

### Loop from here with different source and destination ###
source="500084"
dest="700123"
url=paste("https://maps.googleapis.com/maps/api/distancematrix/json?origins=",source,"&destinations=",dest,"&mode=driving&language=en-EN&sensor=false&key=",
          key,sep="")

df=rjson::fromJSON(file=url)
if(df$rows[[1]]$elements[[1]]$status=="OK"){
  print(df$rows[[1]]$elements[[1]]$distance$text)
}else{
  print("error")
}

#######################
