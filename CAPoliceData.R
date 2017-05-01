library(stringr) #required for str_sub() function

#read data - salary
CAsalaries <- read.csv("./data/CA_Police_Salaries.csv", header=TRUE)
head(CAsalaries)

#ignore firefighter data
CAsalaries <- CAsalaries[,c(1,2,3,4,8)]

#remove rows with no data
CAsalaries <- CAsalaries[CAsalaries$Police.Officer!="",]

#remove SF BART, SF Sheriff, South San Francisco,
#Mammoth Lakes(no killings there):
CAsalaries <- CAsalaries[CAsalaries$Agency!="San Francisco Bay Area Rapid Transit District" 
           & CAsalaries$Agency!="South San Francisco"
           & CAsalaries$Agency!="San Francisco Sheriff",]

#remove "Sheriff" from agencies
CAsalaries$Agency <- sub(" Sheriff","",CAsalaries$Agency)

#read data - police violence
violence <- read.csv("./data/MPVDatasetDownload.csv", header=TRUE)

CAviolence <- violence[violence$Location.of.death..state.=="CA",]

#convert factors to strings
CAviolence <- data.frame(lapply(CAviolence, as.character), 
                         stringsAsFactors=FALSE)

#tabulate data
CAsalaries <- cbind(CAsalaries, rep(0,dim(CAsalaries)[1]))
names(CAsalaries)[dim(CAsalaries)[2]] <- "Killings"
#add number of police killings in each Locality.Pay.Area
for(i in 1:(dim(CAsalaries)[1])){
  loc <- as.character(CAsalaries$Agency[i])
  #leave 0 for LPAs with no violence entries
  if (length(table(CAviolence$Location.of.death..city.==loc))>1){
    CAsalaries$Killings[i] <- 
      table(CAviolence$Location.of.death..city.==loc)[2]
  }
}

#format salary data
CAsalaries$Police.Officer <- as.character(CAsalaries$Police.Officer)
CAsalaries$Police.Officer <- as.numeric(str_sub(CAsalaries$Police.Officer,2,-2))

x11()
plot(CAsalaries$Police.Officer,CAsalaries$Killings,
     main="California Police Killings by City",
     xlab="Avg Police Officer Salary, 2015 (in thousands)",
     ylab="# People Killed by Police, 2013-2017")

#average income - first choice is city
CAincomecity <- 
  read.csv("./data/ACS_15_1YR_B19301/ACS_15_1YR_B19301_with_ann.csv", 
                     skip=1, header=TRUE, stringsAsFactors=FALSE)
#second choice is county
CAincomecounties <- 
  read.csv("./data/ACS_15_1YR_B19301_Counties/ACS_15_1YR_B19301_with_ann.csv", 
                             skip=1, header=TRUE, stringsAsFactors=FALSE)
#add to CAsalaries df
ignorelist <- vector()
CAsalaries <- cbind(CAsalaries, rep(0,dim(CAsalaries)[1]))
names(CAsalaries)[dim(CAsalaries)[2]] <- "AvgIncome"
for(i in 1:(dim(CAsalaries)[1])){
  city <- as.character(CAsalaries$Agency[i])
  linematch <- grep(paste("^",city," ","(city|town|CDP)", sep=""),
                    CAincomecity$Geography)
  if (length(linematch)==1){
    CAsalaries$AvgIncome[i] <- CAincomecity[linematch,4]
  } else if (length(linematch)==0){
      #use county average
    county <- as.character(CAsalaries$County[i])
    linematch <- grep(paste(county,"+",sep=""),
                      CAincomecounties$Geography)
    if (length(linematch)==1){
      CAsalaries$AvgIncome[i] <- CAincomecounties[linematch,4]
    } else if (length(linematch)==0){
      #add to ignorelist - for now. come up with better solu later
      ignorelist <- c(ignorelist, i)
    } else break
  } else break
}

#shorten dataframe, removing ignorelist
CAsalaries <- CAsalaries[-ignorelist,]

#add nominal difference from avg income
CAsalaries$IncomeDiff <- 
  CAsalaries$Police.Officer - CAsalaries$AvgIncome/1000

plot(CAsalaries$IncomeDiff,CAsalaries$Killings,
     main="California Police Killings by City",
     xlab="Avg Police Officer Salary - Avg Income, 2015 (in thousands)",
     ylab="# People Killed by Police, 2013-2017")

#% difference from avg income
CAsalaries$PctDiff <-
  (1000*CAsalaries$Police.Officer - CAsalaries$AvgIncome) / CAsalaries$AvgIncome

plot(CAsalaries$PctDiff,CAsalaries$Killings,
     main="California Police Killings by City",
     xlab="Avg Police Officer Salary: % Diff. from Avg Income, 2015",
     ylab="# People Killed by Police, 2013-2017")

plot(CAsalaries$PctDiff,CAsalaries$Killings,
     main="California Police Killings by City",
     xlab="Avg Police Officer Salary: % Diff. from Avg Income, 2015",
     ylab="# People Killed by Police, 2013-2017",
     xaxt="n")
axis(1, at=0:7, labels=paste(100*(0:7),"%"))

#add population - look at police killings per 100,000 residents
CApopulation <- 
  read.csv("./data/ACS_15_Population/ACS_15_5YR_DP05_with_ann.csv", 
           skip=1, header=TRUE, stringsAsFactors=FALSE)
CApopulation <- CApopulation[,1:5]
names(CApopulation)[4:5] <- c("Pop","Error")

#add to CAsalaries df
ignorelist <- vector()
CAsalaries <- cbind(CAsalaries, rep(0,dim(CAsalaries)[1]))
names(CAsalaries)[dim(CAsalaries)[2]] <- "Population"
for(i in 1:(dim(CAsalaries)[1])){
  city <- as.character(CAsalaries$Agency[i])
  linematch <- grep(paste("^",city," ","(city|town|CDP)", sep=""),
                    CApopulation$Geography)
  if (length(linematch)==1){
    CAsalaries$Population[i] <- CApopulation[linematch,4]
  } else if (length(linematch)>1){
    CAsalaries$Population[i] <- sum(CApopulation[linematch,4])
  } else if (city=="Ventura") {
    CAsalaries$Population[i] <- 108899 #hard code Ventura
  } else if (length(linematch)==0){
    #add to ignorelist
    ignorelist <- c(ignorelist, i)
  } else break
}

#shorten dataframe, removing ignorelist
CAsalaries <- CAsalaries[-ignorelist,]

#add police killings per 100,000 residents
CAsalaries$KillRate <- 100000*CAsalaries$Killings/CAsalaries$Population

subdata <- CAsalaries[CAsalaries$KillRate<20,]

plot(subdata$PctDiff,subdata$KillRate,
     main="California Police Killings by City",
     xlab="Avg Police Officer Salary: % Diff. from Avg Income, 2015",
     ylab="# People Killed by Police per 100,000 residents, 2013-2017",
     xaxt="n")
axis(1, at=0:7, labels=paste(100*(0:7),"%"))
