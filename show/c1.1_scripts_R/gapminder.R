#!/usr/bin/Rscript

library(ggplot2)
library(reshape)
library(googleVis)

countries = read.csv('data/WDI_GDF_Country.csv', strip.white = TRUE)
worldData = read.csv('data/WDI_GDF_Data.csv', strip.white = TRUE)

worldData2 = worldData[which(
  worldData$Series.Code %in% c(
    'NY.GDP.MKTP.KD',
    'SE.XPD.TOTL.GD.ZS',
    'SP.DYN.LE00.IN',
    'SP.POP.TOTL'
  )
), c('Series.Code',
     'Series.Name',
     'Country.Name',
     'Country.Code',
     'X2008')]
worldData2 = merge(worldData2, countries[, c('Country.Code', 'Region')], by =
                     'Country.Code')
worldData2 = worldData2[which(worldData2$Region != 'Aggregates'), ]
worldData2$Series.Name = as.factor(as.character(worldData2$Series.Name))
worldData2$Region = as.factor(as.character(worldData2$Region))
worldData3 = cast(worldData2, Country.Name + Region ~ Series.Name, mean, value =
                    'X2008')
names(worldData3) = c('Country',
                      'Region',
                      'GDP',
                      'Life.Expectancy',
                      'Population',
                      'Education')

worldData3$GDP.log = log(worldData3$GDP)
worldData3$GDP = worldData3$GDP / 1000000000 #Billions
worldData3$Population = worldData3$Population / 1000000 #Millions

p = ggplot(worldData3, aes(x = GDP, y = Life.Expectancy, label = Country))
p + geom_point(aes(size = Population, colour = Region),
               stat = 'identity',
               alpha = .6) + geom_text(hjust = -.2,
                                       vjust = .5,
                                       size = 2) + scale_size_continuous('Population (Millions)', limit = c(1, 20)) + xlab('Gross Domestic Product (billions)') + ylab('Life Expectancy at birth (years)')

p = ggplot(worldData3, aes(x = GDP.log, y = Life.Expectancy, label = Country))
p + geom_point(aes(size = Population, colour = Region),
               stat = 'identity',
               alpha = .6) + geom_text(hjust = -.2,
                                       vjust = .5,
                                       size = 2) + scale_size_continuous('Population (Millions)', limit = c(1, 20)) + xlab('Gross Domestic Product (log scale)') + ylab('Life Expectancy at birth (years)')

worldData4 = worldData3[which(worldData3$GDP < 2000), ]
p = ggplot(worldData4, aes(x = GDP, y = Life.Expectancy, label = Country))
p + geom_point(aes(size = Population, colour = Region),
               stat = 'identity',
               alpha = .6) + geom_text(hjust = -.2,
                                       vjust = .5,
                                       size = 2) + scale_size_continuous('Population (Millions)', limit = c(1, 20)) + xlab('Gross Domestic Product (billions)') + ylab('Life Expectancy at birth (years)')

gworldData = worldData[which(worldData$Series.Code %in% c('NY.GDP.MKTP.KD', 'SP.DYN.LE00.IN', 'SP.POP.TOTL')), c(
  'Series.Code',
  'Series.Name',
  'Country.Name',
  'Country.Code',
  'X2000',
  'X2001',
  'X2002',
  'X2003',
  'X2004',
  'X2005',
  'X2006',
  'X2007',
  'X2008'
)]
gworldData = merge(gworldData, countries[, c('Country.Code', 'Region')], by =
                     'Country.Code')
gworldData = gworldData[which(gworldData$Region != 'Aggregates'), ]
gworldData$Series.Name = as.factor(as.character(gworldData$Series.Name))
gworldData$Region = as.factor(as.character(gworldData$Region))
gworldData = melt(
  gworldData,
  id = c(
    'Country.Code',
    'Series.Code',
    'Series.Name',
    'Country.Name',
    'Region'
  )
)
gworldData = cast(gworldData,
                  Country.Name + Region + variable ~ Series.Name,
                  mean,
                  value = 'value')
names(gworldData) = c('Country',
                      'Region',
                      'Year',
                      'GDP',
                      'Life.Expectancy',
                      'Population')
gworldData$GDP = gworldData$GDP / 1000000000 #Billions
gworldData$Population = gworldData$Population / 1000000 #Millions
gworldData$Year = as.integer(substr(gworldData$Year, 2, 5))
head(gworldData)
m = gvisMotionChart(gworldData, idvar = 'Country', timevar = 'Year')
cat(m$html$chart)
plot(m)
