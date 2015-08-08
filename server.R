
library(jsonlite)
library(shiny)
library(leaflet)
library(curl)

shinyServer(function(input, output) {
  
  #取得台北市消防局的資料，整理成Data.frame格式。來源：https://tpe-doit.github.io/eoc_119/ghpage/
  url<-"https://tcgbusfs.blob.core.windows.net/blobfs/GetDisasterSummary.json"
  getdf<-fromJSON(url) 
  df<-(getdf[1][[1]][[3]][[2]][[1]][[2]])
  df<-as.data.frame(df,stringsAsFactors = F)
  
  #只擷取部分資料顯示。
  df2<-rbind(df[df$CaseComplete=="false",c(3,9,7,8,10,11)],df[df$CaseComplete=="true",c(3,9,7,8,10,11)])
  
  df2$Wgs84X<-as.numeric(df2$Wgs84X)
  df2$Wgs84Y<-as.numeric(df2$Wgs84Y)
  
  #輸出左側說明。
  output$times<-renderText({paste("update",as.character(df2[1,1]),", source：https://tpe-doit.github.io/eoc_119/ghpage/")})
  
  #輸出leaflet地圖。
  output$map<-renderLeaflet({
    maps<-leaflet() %>%
      addTiles() %>% 
      addMarkers(lng=df2[df2$CaseComplete=="false",5],lat=df2[df2$CaseComplete=="false",6],popup=paste("detail:",df2$CaseDescription,"已處理：",df2$CaseComplete)) %>%
      addCircleMarkers(lng=df2[df2$CaseComplete=="true",5],lat=df2[df2$CaseComplete=="true",6],popup=paste("detail:",df2$CaseDescription,"已處理：",df2$CaseComplete)) %>%
      setView(lng=121.544038,lat=25.051828,zoom=15)
  })
  
  #輸出表格。
  output$table<-renderDataTable(df2[,c(1:4)]) 
  
})
