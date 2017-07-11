# mlb_stats

## Description
MLB_Stats project uses the repository of gameday & Pitch F/X data hosted by MLB at:
http://gd2.mlb.com/components/game/mlb/

The data is written into a series of tables (see schema) on an AWS MySQL instance.

mlbStats.py contains the code for pulling, extracting and formatting the data from MLB.com

Analytics & Predictive Modeling scripts to follow.

### Additional Data Sources:
* Park Factors data from: http://www.espn.com/mlb/stats/parkfactor
* Leverage Scenario data from: http://www.insidethebook.com/li.shtml

## Data
Data folder stores extracts of primary tables from January 01, 2012 - July 06, 2017.

## SQL
This folder contains all SQL scripts.

### Schema_DDL.sql
As the name implies, this file contains the DDL for all the main tables for the database.

### Player.sql
This player loads the Player table, which has all distinct players.

### ADV Pitching Stats
The adv_pitching_stats queries select and calculate a series of pitching statistics and group by playerID and either month or year. The supported statistics include:
* FIP
* WHIP
* BABIP
* xFIP
* K rate
* BB rate
* HR/FB
* SIERA

As well as the fields required to calculate each of the statistics.

Note: The FIP measures include calculations for cFIP.

### ADV Batting Stats
The adv_batting_stats queries select and calculate a series of batting statistics and group by playerID and either month or year. The supported statistics include:
* batting average
* OBP
* SLG
* OPS
* ISO
* BABIP
* Walk Rate
* Strikeout Rate
* wOBA
* wRAA
* wRC
* Stolen Base Success Rate

## Python:
This folder contains all Python scripts.

### Export.py
Python script to export all or some of the tables. If passed without additional command line argument, it will run a full extract of the following tables:
* game
* umpire_game
* pitch
* pickoff
* atBat
* coach_game
* player_game
* stadium_game
* runner
* action
* boxscore
* batter_box
* pitcher_box
* linescore
* linescore_inning
* leverage
* park_factors
* team_game
* adv_batting_stats_month
* adv_batting_stats_year
* adv_pitching_stats_month
* adv_pitching_stats_year
* player
* team

Otherwise, passing a table name as an argument will extract that single table.

### mlbStats.py
This file holds all of the primary methods for the code and is used to run the loading process.

#### Method: iterURL
* method takes a gd2.mlb.com URL from any point in the hierarchy and iterates through all branches. 
* If a year URL is input, it will pull all games from that year,
* If a year-month URL is input, it will pull all games from that year and month
* Once you get down to the game level, it will iterate through the following pages:
	* all_innings      
	* boxscore      
	* game      
	* players      
* Note: progress updates get a little funky if you iterate at the game level    
      
#### Method: parseInnings & parseInning  
* tries to iterate through the all_innings URL. If that is not found, it iterates through the individual inning pages    
* This process pulls all of the atBats, actons (injury delay, substitution, etc.), pitches, runners and pickoffs in the game, loading them to their respective arrays.    
* More recent games (I think 2015-Current) have a built-in event_num, but the older games don't have one, so mastEventNum is used to create that ID
    
#### Method: parseGame  
* This method parses the game URL    
* This process loads the game, teams and stadium info to their respective arrays    
* There is a deprecated method I was using to get the sun position for the day of the game, but that API is no longer active
    
#### Method: parsePlayers 
* This method parses the players URL    
* This process loads the players, coaches and umpires to their respective arrays    
    
#### Method: parseBox 
* This method parses the boxscore URL    
* This process loads the boxscore, linescore, linescore by inning, and each pitcher's and batter's box score to their respective arrays

#### Method: loopInserts & InsertRecords 
* This method makes sure the arrays conform to the table structure and loads everything to the DB    
    
#### Method: runYesterday 
* This method runs all the games from the day before sysdate()    
    
#### Method: recentDays 
* This method runs all the games from the day after the most recent date in the game table up to the day before sysdate()    
    
#### Method: main 
* This method takes an array of URLs and passes each of them through IterURL    
    
#### Method: runErrors 
* For any errors in parsing the URLs or reading innings/pitches, these URLs are written out to error csvs.     
* This method grabs those error URLs and tries to reprocess them    
* This is because I've run across timeout issues when trying to run large iterations (i.e. a year's worth of data) and URLs will throw errors even though there isn't any issue on the code side.    
    
#### Notes:  
* This process takes a while. With a good connection, it should run a year of data in around 2-3 hours. 

### Other Load Methods:
These methods do not run as part of the main load process.

#### Method: getParkFactors
* This method pulls the park factor data from ESPN and updates the park_factors table ith new data.

#### Method: leverageParse
* This method pulls the leverage data from insidethebook and loads the leverage table.

### sql_data_load.py

This file loads the tables with the select statements created by the SQL scripts in the SQL folder.

###  analytics

As  the name implies, this folder contains all of the Python scripts used for analytics.

#### three_zero_counts.py

This script pulls all three_zero_counts from a view which joins: game, atBat, pitch, adv_pitching_stats_year, taking only atBats that do not results in sacrifices, interference, hit by pitch, intentional walks, or errors, then finds all at Bats that result in 3-0 counts, calculates the expected number of bases using:
	1*P(Single) + 1*P(Walk) + 2*P(Double) + 3*P(Triple) + 4*P(Home Run)
broken down by whether the batter swings at the 3-0 pitch or not.

It prints the expected values, variance and standard deviation for both of these cases, as well as for all 3-0 counts, and for all at bats.

It then calculates the Pearson correlation for % 3-0 counts for a pitcher against FIP, WHIP, xFIP, SIERA, k rate, bb rate, and hr to fly ball rate.
