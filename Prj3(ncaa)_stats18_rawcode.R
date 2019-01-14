#upload 2018 basic offensive stats
library(dplyr)
library(tidyverse)
library(readr)
library(readxl)
stats18_tmbasic_raw <- read_csv("stats18_tmbasic_raw.csv", 
                                skip = 1)
View(stats18_tmbasic_raw)

#get rid of "X17" (all NAs) column (reassign by dropping _raw)
stats18_tmbasic <- stats18_tmbasic_raw %>% 
  select(-X17)
stats18_tmbasic
#originally got rid of "rk", but later decided to change to year

#Change "rk" to "Year" (b/c I'll be adding other data later). Took several attempts.
stats18_tmbasic <- stats18_tmbasic %>% 
  rename(Year = Rk) %>% 
  mutate(Year = str_replace(Year, "(.*)", "2018"))
stats18_tmbasic

#rename first rows (to make more readable)
stats18_tmbasic <- stats18_tmbasic %>% 
  rename(Rating = SRS, Conf_W = W_1, Conf_L = L_1, Hm_W = W_2, Hm_L = L_2, Aw_W = W_3, Aw_L = L_3)
stats18_tmbasic

######
#found a way to read excel sheets and choose the columns that I actually want. 
#Only thing I'm concerned about is ensuring that data add up
#going to reload and try to include school name
stats18_tmadv_raw <- read_excel("stats18_tmadv_raw.xls", 
                                  skip = 1)
View(stats18_tmadv_raw)

#now need to merge advanced off stats with basic off stats and ensure that names add up
#start by stripping unnecessary cols (new assignment)
stats18_tmadv <- stats18_tmadv_raw %>% 
  select(School, 18:30)
stats18_tmadv

#test to make sure schools are matched 
#(Total should be 351. If one data set has an additional school, I'd see 352 count in View.) 
#(If a school is missing from one data set, then I'd see 350 when looking at intersect)
intersect(stats18_tmbasic$School, stats18_tmadv$School)
#The answer was 351, so the school names match

#Now I'm going to join the two data sets by "School" (assign as stats18_tm, aka total offensive stats)
stats18_tm <- left_join(stats18_tmbasic, stats18_tmadv, by = "School")
View(stats18_tm)
#Check structure. Has 351 obs and 46 variables
str(stats18_tm)

########
#Now working on defensive data, which is indicated by "opp"
#First, going to upload opp basic ...
stats18_oppbasic_raw <- read_excel("stats18_oppbasic_raw.xls", 
                                   skip = 1)
View(stats18_oppbasic_raw)

#... and strip unnecessary cols
stats18_oppbasic <- stats18_oppbasic_raw %>% 
  select(School, 19:34)
stats18_oppbasic

#add opp adv
stats18_oppadv_raw <- read_excel("stats18_oppadv_raw.xls", 
                                 skip = 1)
View(stats18_oppadv_raw)

# strip unneccesary cols
stats18_oppadv <- stats18_oppadv_raw %>% 
  select(School, 18:30)
stats18_oppadv

#test for Schools match, then merge two opp data sets by "School"
intersect(stats18_oppbasic$School, stats18_oppadv$School)
stats18_opp <- left_join(stats18_oppbasic, stats18_oppadv, by = "School")
View(stats18_opp)
#Check structure of both 
#(TM: 46 variables - 1 School; 16 overall, such as year and games played; 29 statistical)
#(OPP: 30 variables - 1 School; 29 statistical)
str(stats18_tm)
str(stats18_opp)

######
#I have both offensive and defensive data, but many columns (FGA, 3P%, etc) repeat. Need a way to add "opp_" to opp data

