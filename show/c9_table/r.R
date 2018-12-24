#!/usr/bin/Rscript

library(readr)
library(dplyr)

countries <- read_tsv("country.txt")
countries %>% 
  filter(Country=="France") %>% 
  select(Population) %>%
  pull()