---
title: "Best Predictors of NCAA Tournament Success"
author: "Jared Council"
date: "February 18, 2019"
output: 
  html_document: 
    keep_md: yes
---


**Problem**

Every year, 68 men's college basketball teams are have a chance to become National Champion. But NCAA basketball coaches have few insights into the team-level stats that correlate most with Tournament wins. As a result, they're game-planning for individual teams, as opposed to honing skills and attributes that could position them for deep runs in the Tournament. NCAA coaches could use insights into the team stats that matter the most in the tournament.     


**Client and value prop**

The client is the coach of an NCAA men's basketball team. They care about this problem because they want to make a run deep in the NCAA Tournament. Based on this analysis, they'll be able to see which team stats are most indicative of post-season success and hone those skills. They'll also be able to see which stats correlate most with losses, in order to avoid them.

**Data sets**

I plan to use data that the NCAA has made widely available on Kaggle here <https://www.kaggle.com/ncaa/ncaa-basketball>. It will cover every team in the nation and include statistics such as points per game, offensive efficiency, passes per game, steals, and turnovers. I'll acquire this data by downloading files from Kaggle or wherever else the NCAA has made that info available. I may also use data from Basketball Reference <https://www.sports-reference.com/cbb/>

**Approach**

Generally speaking, my methodology will consist of the following:

-   Compile a list of all the teams that made the NCAA Tournament over the past five years and show how many games they won during a tournament in each year (the most a team can win is six).

-   For each team in each year, compile regular-season statistics for maybe 10-15 different areas (such as offensive efficiency, steals, rebounds). I'll do two things with each stat---determine ranking (2nd) and absolute numbers (78 points per game).

-   For each statistic that year, I plan to overlay rankings with wins (and absolute stats with wins) in scatter chart to determine which stats have the strongest correlation with wins. When done, I expect to be able to answer things like: Where did the Tourney winner rank in that stat? What about the teams that won five games? Four games? How many outliers where there (e.g. teams that ranked poorly but performed very well and vice versa)?

-   Since that'll just be for one year, I'll overlay data for previous years for each stat. So one stat will have, potentially, 640 plots in the scatter chart (wins vs. ranking). The same will be true for absolute numbers, which I only plan to look at secondarily.

-   I'll repeat the process with every stat and determine (maybe with a quotient or a correlation score) which three stats are the most correlated with wins?

**Deliverables**

-   Slide deck that walks the user through the analysis

-   Pareto charts ranking of the most impactful stats by magnitude (stats that correlate most with wins and those that correlate most with losses)

-   Underlying code
