library(dplyr)
library(tidyverse)
library(readr)
library(readxl)

#Two types of data - season stats and tournament results. Working first on stats then tourney

#########
##STATS##
#########
#Four stat sets for each year: Offensive basic, offensive advanced, defensive basic and defensive advanced
#The goal with stats is to clean and combine those four categories for each team

#####OFFENSE#####

#Upload off basic
stats18_tmbasic_raw <- read_excel("stats_raw.xlsx", 
                                  sheet = "18TmBasic", skip = 1)
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
stats18_tmadv_raw <- read_excel("stats_raw.xlsx", 
                                sheet = "18TmAdv", skip = 1)
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

#####DEFENSE#####

#Now working on def stats, which are signified by "opp", or opponent
#Upload opp basic
stats18_oppbasic_raw <- read_excel("stats_raw.xlsx", 
                                   sheet = "18OppBasic", skip = 1)
stats18_oppbasic_raw

#Strip unnecessary columns and reassign
stats18_oppbasic <- stats18_oppbasic_raw %>% 
  select(School, 19:34)
stats18_oppbasic
#Should be one "School" column and 16 for basic defensive stats

#add opp adv
stats18_oppadv_raw <- read_excel("stats_raw.xlsx", 
                                 sheet = "18OppAdv", skip = 1)
stats18_oppadv_raw

# strip uneeded cols, reassign
stats18_oppadv <- stats18_oppadv_raw %>% 
  select(School, 18:30)
stats18_oppadv
#Should be one "School" column, plus 13 advanced defensive stats

#test for Schools match using intersect(). (Should be 351 again.)
intersect(stats18_oppbasic$School, stats18_oppadv$School)

#combine basic and adv defensive stats using left_join()
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

#####OFFENSE AND DEFENSE######

#Lastly, combine the off and def stats to get all four data sets in one
#test for Schools match
intersect(stats18_tm$School, stats18_opp$School)

#merge two sets by "School"
stats18_full <- left_join(stats18_tm, stats18_opp, by = "School")
stats18_full

#check structure (75 variables; 17 overall; 29 offensive; 29 defensive)
str(stats18_full)


###########
##TOURNEY##
###########
#The goal here is to take raw data and make a table that shows each team, 
#its result (W/L) in each round, and its total number of wins

#Upload 2018 tourney results
tourney_raw <- read_excel("tourney_raw.xlsx", 
                                     sheet = "2018")
tourney_raw

#Rename "seed" column to "seed_1"
tourney_raw <- tourney_raw %>% 
  rename("seed_1" = "seed")

#create table of winners (67 total games)
School_winners <- tourney_raw %>% 
  #create new column called "School", which has the team that won
  mutate(School = ifelse(score > score_2, team, team_2)) %>% 
  #create binary column called "result", which shows a 1 if team won
  mutate(result = 1) %>% 
  #create new column that grabs seed associated with winner
  mutate(seed = ifelse(score > score_2, seed_1, seed_2)) %>% 
  #remove all but following columns
  select(round, School, seed, result) %>% #added seed here
  #add a column that assigns number to games (to pair each game with loser in next table)
  mutate(game_num = row_number())
School_winners %>%  View()

#Create table of losers (same code as above, except "result" will be "0" and "seed_2" renamed)
School_losers <- tourney_raw %>% 
  mutate(School = ifelse(score > score_2, team_2, team)) %>% 
  mutate(result = 0) %>% 
  mutate(seed = ifelse(score > score_2, seed_2, seed_1)) %>% 
  select(round, School, seed, result) %>%
  mutate(game_num = row_number())
School_losers %>%  View()

#Merge those two tables; arrange by game number
School_both <- bind_rows(School_winners, School_losers) %>% 
  arrange(game_num)
School_both %>% View()

#It's now possible to easily show win totals for each school
#Create new table with that info (will you later to test win count of another table)
School_wins <- School_both %>% 
  group_by(School) %>% 
  summarise(wins = sum(result)) %>%
  arrange(-wins)
School_wins %>% View()

#Create a table with binary columns showing each team's result for each round
School_rounds <- School_both %>% 
  select(-game_num) %>% 
  spread(round, result, fill = 0) #if want to keep NAs, remove "fill = 0"
School_rounds %>% View()

#rename round columns
School_rounds <- School_rounds %>% 
  rename(Fir_4 = 3, Rnd_64 = 4, Rnd_32 = 5, Swt_16 = 6, Eli_8 = 7, Fin_4 = 8, Champ = 9)
School_rounds

#tally the wins in a new column (struggled here, so following is makeshift method)
School_tally <- School_rounds %>% 
  select(-School, -seed) %>% #removed School, seed columns so I could tally up others
  mutate(wins = apply(., 1, sum)) %>% #created a new column with the sums, called "wins"
  select(wins) #only selected new column (to bind with rounds column later)
School_tally

#Combine the game results table with total wins table
tourney18_final <- bind_cols(School_rounds, School_tally)
tourney18_final

#############################
#Test for win count accuracy: created new wins table and compared with wins table created earlier
School_wins2 <- tourney18_final %>% 
  select(School, wins) %>% 
  arrange(-wins)

intersect(School_wins, School_wins2)
#Should be, and is, 68 teams

#####################
##STATS AND TOURNEY##
#####################

#In season stats data, teams that made tournament have the string "NCAA" behind their names. 
#Filter those teams and remove the "NCAA" string
stats18_final <- stats18_full %>% 
  filter(grepl(".*NCAA", School)) %>%
  mutate(School = str_remove_all(School, ".NCAA"))
stats18_final %>% View()

#Compare team names (stats final vs. tourney final) using intersect() and setdiff()
intersect(stats18_final$School, tourney18_final$School)
#only 46 matches

#What's in stats set but not tourney
setdiff(stats18_final$School, tourney18_final$School)
#22 schools 

#What's in tourney set but not stats
setdiff(tourney18_final$School, stats18_final$School)

#Decided to keep SportsRefence nomenclature for teams
#So rename tourney data to match stats data
tourney18_final <- tourney18_final %>% 
  mutate(School = str_replace_all(School, c("Arizona St" = "Arizona State", 
                                            "Cal St Fullerton" = "Cal State Fullerton",
                                            "Florida St" = "Florida State",
                                            "Georgia St" = "Georgia State", "Kansas St" = "Kansas State",
                                            "LIU-Brooklyn" = "Long Island University",
                                            "Loyola Chicago" = "Loyola (IL)", "Miami" = "Miami (FL)", 
                                            "Michigan St" = "Michigan State", "Murray St" = "Murray State", 
                                            "NC State" = "North Carolina State", "New Mexico St" = "New Mexico State", 
                                            "Ohio St" = "Ohio State", "San Diego St" = "San Diego State", 
                                            "South Dakota St" = "South Dakota State", "St Bonaventure" = "St. Bonaventure", 
                                            "Stephen F Austin" = "Stephen F. Austin", "TCU" = "Texas Christian", 
                                            "UMBC" = "Maryland-Baltimore County", "UNC Greensboro" = "North Carolina-Greensboro",
                                            "Wichita St" = "Wichita State", "Wright St" = "Wright State")))
tourney18_final

#There are 68 teams in the NCAA Tournament. (Eight play in play-in round to determine the final 64 teams)
#Test to make sure all 68 names match
intersect(stats18_final$School, tourney_final$School)

#Combine stats final with tourney final
NCAA18_full <- left_join(stats18_final, tourney18_final, by = "School")
NCAA18_full

#Check structure (84 variables; 17 overall; 29 offensive; 29 defensive; 9 tourney results)
str(NCAA18_full)

#Export as CSV file
write.csv(NCAA18_full, "NCAA_full18_clean.csv")
