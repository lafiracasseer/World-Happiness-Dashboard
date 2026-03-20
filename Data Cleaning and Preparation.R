#install packages
install.packages("writexl")

#Loading necessary packages
library(dplyr)      
library(tidyr)      
library(ggplot2)    
library(readxl)
library(writexl)

#Loading the data set
happiness <- read_excel("WHR25_Data_Figure_2.1v3.xlsx")

#Reading the data set
str(happiness)
head(happiness)

#Removing 2011-2018 data since they are blank values
happiness <- happiness %>% filter(Year >= 2019)

#Removing unnecessary columns
happiness <- happiness %>%
  select(-Rank, -`Lower whisker`, -`Upper whisker`, -`Dystopia + residual`)

#Handling blank values
colSums(is.na(happiness))
happiness <- happiness %>%
  mutate(across(where(is.numeric), ~ ifelse(is.na(.), mean(., na.rm = TRUE), .)))


#Removing duplicates
sum(duplicated(happiness))
happiness <- happiness %>% distinct()


#Renaming column names
happiness <- happiness %>%
  rename(
    `Country` = `Country name`,
    `Happiness Score` = `Life evaluation (3-year average)`,
    `GDP Per Capita` = `Explained by: Log GDP per capita`,
    `Social Support` = `Explained by: Social support`,
    `Healthy Life Expectancy` = `Explained by: Healthy life expectancy`,
    `Freedom To Make Life Choices` = `Explained by: Freedom to make life choices`,
    `Generosity` = `Explained by: Generosity`,
    `Perception Of Corruption` = `Explained by: Perceptions of corruption`
  )


#Reorder Country first, Year second
happiness <- happiness %>%
  select(Country, Year, everything())


#Keeping only 10 specific countries
happiness <- happiness %>%
  filter(`Country` %in% c("United Kingdom", "Mexico", "South Africa", "India", "Germany",
                          "Finland","United Arab Emirates", "Switzerland", "United States",
                          "New Zealand"))



#Cleaned data set
write_xlsx(happiness, "Cleaned_happiness_dataset.xlsx")
