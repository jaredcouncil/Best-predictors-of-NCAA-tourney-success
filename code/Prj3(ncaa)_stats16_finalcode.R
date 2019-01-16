library(dplyr)
library(tidyverse)
library(readr)
library(readxl)

#There are for stat sets for each year: Offensive basic, offensive advanced, defensive basic and defensive advanced

#########
#OFFENSE#
#########

#Upload off basic
stats16_tmbasic_raw <- read_excel("stats16_tmbasic_raw.xls", 
                                  skip = 1)
stats16_tmbasic_raw

#Column 17 is all NAs. Delete that column and reassign data set to "stats16_tmbasic"
stats16_tmbasic <- stats16_tmbasic_raw %>% 
  select(-X__1)
stats16_tmbasic

#Change column "rk" to "Year". (Later, we'll have one data set with different years.)
stats16_tmbasic <- stats16_tmbasic %>% 
  rename(Year = Rk) %>% 
  mutate(Year = str_replace(Year, "(.*)", "2016"))
stats16_tmbasic

#Rename columns 7-14 to make more definitive (SportsReference rating, conference wins/losses, home wins/losses, away wins/losses)
stats16_tmbasic <- stats16_tmbasic %>% 
  rename(Rating = SRS, Conf_W = W__1, Conf_L = L__1, Hm_W = W__2, Hm_L = L__2, Aw_W = W__3, Aw_L = L__3)
stats16_tmbasic
#There should be 33 variables, including 17 for overall/performance (name, wins/losses, points, minutes)
#and 16 for basic offensive stats (feild goals, assits, rebounds)

#Off basic is complete. Now we need to upload and clean Off adv, then merge the two
stats16_tmadv_raw <- read_excel("stats16_tmadv_raw.xls", 
                                skip = 1)
stats16_tmadv_raw

#The first seventeen columns are redundant with off basic. Strip all but "School" column. 
stats16_tmadv <- stats16_tmadv_raw %>% 
  select(School, 18:30)
stats16_tmadv
#There should be "School" column, plus 13 advanced offensive stats

#test to make sure schools for basic and adv match by using intersect().
intersect(stats16_tmbasic$School, stats16_tmadv$School)
#Total should be 351

#Now I'm going to left_join() the two data sets by "School".
#Reassign as stats16_tm, which implies total offensive stats
stats16_tm <- left_join(stats16_tmbasic, stats16_tmadv, by = "School")
stats16_tm
#should be 46 variables (16 overall, 16 off basic, 13 off adv)

#Check structure
str(stats16_tm)
#Has 351 obs and 46 variables


#########
#DEFENSE#
#########

#Now working on def stats, which are signified by "opp", or opponent
#Upload opp basic
stats16_oppbasic_raw <- read_excel("stats16_oppbasic_raw.xls", 
                                   skip = 1)
stats16_oppbasic_raw

#Strip unnecessary columns and reassign
stats16_oppbasic <- stats16_oppbasic_raw %>% 
  select(School, 19:34)
stats16_oppbasic
#Should be one "School" column and 16 for basic defensive stats

#add opp adv
stats16_oppadv_raw <- read_excel("stats16_oppadv_raw.xls", 
                                 skip = 1)
stats16_oppadv_raw

# strip uneeded cols, reassign
stats16_oppadv <- stats16_oppadv_raw %>% 
  select(School, 18:30)
stats16_oppadv
#Should be one "School" column, plus 13 advanced defensive stats

#test for Schools match using intersect(). (Should be 351 again.)
intersect(stats16_oppbasic$School, stats16_oppadv$School)

#left_join basic and adv defensive stats
stats16_opp <- left_join(stats16_oppbasic, stats16_oppadv, by = "School")
stats16_opp

#Check structure of both 
str(stats16_tm)
#(TM: 46 variables - 17 overall; 29 statistical)
str(stats16_opp)
#(OPP: 30 variables - 1 overall; 29 statistical)

#As you can tell, many columns in the off and def data sets repeat (FGA, 3P%, etc). 
#So rename def columns by adding "Opp" in front of each.
stats16_opp <- stats16_opp %>% 
  rename(OppFG = FG, OppFGA = FGA, "OppFG%" = "FG%", Opp3P = "3P", Opp3PA = "3PA", 
         "Opp3P%" = "3P%", OppFT = FT, OppFTA = FTA, "OppFT%" = `FT%`, OppORB = ORB, 
         OppTRB = TRB, OppAST = AST, OppSTL = STL, OppBLK = BLK, OppTOV = TOV, OppPF = PF, 
         OppPace = Pace, OppORtg = ORtg, OppFTr = FTr, Opp3PAr = `3PAr`, "OppTS%" = `TS%`, 
         "OppTRB%" = `TRB%`, "OppAST%" = `AST%`, "OppSTL%" = `STL%`, "OppBLK%" = `BLK%`, 
         "OppeFG%" = `eFG%`, "OppTOV%" = `TOV%`, "OppORB%" = `ORB%`, "OppFT/FGA" = `FT/FGA`)
stats16_opp


##########
#COMBINED#
##########

#Lastly, combine the off and def stats to get all four data sets in one
#test for Schools match
intersect(stats16_tm$School, stats16_opp$School)

#merge two sets by "School"
stats16_full <- left_join(stats16_tm, stats16_opp, by = "School")
stats16_full

#check structure (75 variables; 17 overall; 29 offensive; 29 defensive)
str(stats16_full)
