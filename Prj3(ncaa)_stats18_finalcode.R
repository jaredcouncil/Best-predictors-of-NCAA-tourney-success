library(dplyr)
library(tidyverse)
library(readr)
library(readxl)

#There are for stat sets for each year: Offensive basic, offensive advanced, defensive basic and defensive advanced

#########
#OFFENSE#
#########

#Upload off basic
stats18_tmbasic_raw <- read_excel("stats18_tmbasic_raw.xls", 
                                  skip = 1)
stats18_tmbasic_raw

#Column 17 is all NAs. Delete that column and reassign data set to "stats18_tmbasic"
stats18_tmbasic <- stats18_tmbasic_raw %>% 
  select(-X__1)
stats18_tmbasic

#Change column "rk" to "Year". (Later, we'll have one data set with different years.)
stats18_tmbasic <- stats18_tmbasic %>% 
  rename(Year = Rk) %>% 
  mutate(Year = str_replace(Year, "(.*)", "2018"))
stats18_tmbasic

#Rename columns 7-14 to make more definitive (SportsReference rating, conference wins/losses, home wins/losses, away wins/losses)
stats18_tmbasic <- stats18_tmbasic %>% 
  rename(Rating = SRS, Conf_W = W__1, Conf_L = L__1, Hm_W = W__2, Hm_L = L__2, Aw_W = W__3, Aw_L = L__3)
stats18_tmbasic
#There should be 33 variables, including 17 for overall/performance (name, wins/losses, points, minutes)
#and 16 for basic offensive stats (feild goals, assits, rebounds)

#Off basic is complete. Now we need to upload and clean Off adv, then merge the two
stats18_tmadv_raw <- read_excel("stats18_tmadv_raw.xls", 
                                skip = 1)
stats18_tmadv_raw

#The first seventeen columns are redundant with off basic. Strip all but "School" column. 
stats18_tmadv <- stats18_tmadv_raw %>% 
  select(School, 18:30)
stats18_tmadv
#There should be "School" column, plus 13 advanced offensive stats

#test to make sure schools for basic and adv match by using intersect().
intersect(stats18_tmbasic$School, stats18_tmadv$School)
#Total should be 351

#Now I'm going to left_join() the two data sets by "School".
#Reassign as stats18_tm, which implies total offensive stats
stats18_tm <- left_join(stats18_tmbasic, stats18_tmadv, by = "School")
stats18_tm
#should be 46 variables (16 overall, 16 off basic, 13 off adv)

#Check structure
str(stats18_tm)
#Has 351 obs and 46 variables


#########
#DEFENSE#
#########

#Now working on def stats, which are signified by "opp", or opponent
#Upload opp basic
stats18_oppbasic_raw <- read_excel("stats18_oppbasic_raw.xls", 
                                   skip = 1)
stats18_oppbasic_raw

#Strip unnecessary columns and reassign
stats18_oppbasic <- stats18_oppbasic_raw %>% 
  select(School, 19:34)
stats18_oppbasic
#Should be one "School" column and 16 for basic defensive stats

#add opp adv
stats18_oppadv_raw <- read_excel("stats18_oppadv_raw.xls", 
                                 skip = 1)
stats18_oppadv_raw

# strip uneeded cols, reassign
stats18_oppadv <- stats18_oppadv_raw %>% 
  select(School, 18:30)
stats18_oppadv
#Should be one "School" column, plus 13 advanced defensive stats

#test for Schools match using intersect(). (Should be 351 again.)
intersect(stats18_oppbasic$School, stats18_oppadv$School)

#left_join basic and adv defensive stats
stats18_opp <- left_join(stats18_oppbasic, stats18_oppadv, by = "School")
stats18_opp

#Check structure of both 
str(stats18_tm)
#(TM: 46 variables - 17 overall; 29 statistical)
str(stats18_opp)
#(OPP: 30 variables - 1 overall; 29 statistical)

#As you can tell, many columns in the off and def data sets repeat (FGA, 3P%, etc). 
#So rename def columns by adding "Opp" in front of each.
stats18_opp <- stats18_opp %>% 
  rename(OppFG = FG, OppFGA = FGA, "OppFG%" = "FG%", Opp3P = "3P", Opp3PA = "3PA", 
         "Opp3P%" = "3P%", OppFT = FT, OppFTA = FTA, "OppFT%" = `FT%`, OppORB = ORB, 
         OppTRB = TRB, OppAST = AST, OppSTL = STL, OppBLK = BLK, OppTOV = TOV, OppPF = PF, 
         OppPace = Pace, OppORtg = ORtg, OppFTr = FTr, Opp3PAr = `3PAr`, "OppTS%" = `TS%`, 
         "OppTRB%" = `TRB%`, "OppAST%" = `AST%`, "OppSTL%" = `STL%`, "OppBLK%" = `BLK%`, 
         "OppeFG%" = `eFG%`, "OppTOV%" = `TOV%`, "OppORB%" = `ORB%`, "OppFT/FGA" = `FT/FGA`)
stats18_opp


##########
#COMBINED#
##########

#Lastly, combine the off and def stats to get all four data sets in one
#test for Schools match
intersect(stats18_tm$School, stats18_opp$School)

#merge two sets by "School"
stats18_full <- left_join(stats18_tm, stats18_opp, by = "School")
stats18_full

#check structure (75 variables; 17 overall; 29 offensive; 29 defensive)
str(stats18_full)


##############
#If you want to view all fulls
View(stats14_full)
View(stats15_full)
View(stats16_full)
View(stats17_full)
View(stats18_full)
