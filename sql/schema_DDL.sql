-- MySQL dump 10.13  Distrib 5.7.9, for Win64 (x86_64)
--
-- Host: baseball.cfelhfqsawiy.us-east-1.rds.amazonaws.com    Database: mlb_data_test
-- ------------------------------------------------------
-- Server version	5.6.27-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `action`
--

DROP TABLE IF EXISTS `action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action` (
  `gameID` varchar(255) NOT NULL,
  `inningNum` int(11) DEFAULT NULL,
  `topBottom` varchar(10) DEFAULT NULL,
  `event_num` int(11) NOT NULL,
  `b` int(11) DEFAULT NULL,
  `s` int(11) DEFAULT NULL,
  `o` int(11) DEFAULT NULL,
  `event` varchar(45) DEFAULT NULL,
  `event_es` varchar(45) DEFAULT NULL,
  `des` varchar(255) DEFAULT NULL,
  `des_es` varchar(255) DEFAULT NULL,
  `tfs_zulu` varchar(45) DEFAULT NULL,
  `play_guid` varchar(255) DEFAULT NULL,
  `pitch` int(11) DEFAULT NULL,
  `home_team_runs` int(11) DEFAULT NULL,
  `away_team_runs` int(11) DEFAULT NULL,
  `tfs` int(11) DEFAULT NULL,
  `player` int(11) DEFAULT NULL,
  PRIMARY KEY (`gameID`,`event_num`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `adv_batting_stats_month`
--

DROP TABLE IF EXISTS `adv_batting_stats_month`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adv_batting_stats_month` (
  `playerID` int(11) NOT NULL,
  `record_month` varchar(10) NOT NULL,
  `pa` int(11) DEFAULT NULL,
  `home_runs` int(11) DEFAULT NULL,
  `rbis` int(11) DEFAULT NULL,
  `hits` int(11) DEFAULT NULL,
  `walks` int(11) DEFAULT NULL,
  `fly_balls` int(11) DEFAULT NULL,
  `pop_outs` int(11) DEFAULT NULL,
  `ground_balls` int(11) DEFAULT NULL,
  `sb` int(11) DEFAULT NULL,
  `cs` int(11) DEFAULT NULL,
  `stolen_base_success_rate` double(5,3) DEFAULT NULL,
  `batting_average` double(5,3) DEFAULT NULL,
  `OBP` double(5,3) DEFAULT NULL,
  `SLG` double(5,3) DEFAULT NULL,
  `OPS` double(5,3) DEFAULT NULL,
  `ISO` double(5,3) DEFAULT NULL,
  `BABIP` double(5,3) DEFAULT NULL,
  `bb_rate` double(5,3) DEFAULT NULL,
  `so_rate` double(5,3) DEFAULT NULL,
  `wRAA` float DEFAULT NULL,
  `wRC` float DEFAULT NULL,
  PRIMARY KEY (`playerID`,`record_month`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `adv_batting_stats_year`
--

DROP TABLE IF EXISTS `adv_batting_stats_year`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adv_batting_stats_year` (
  `playerID` int(11) NOT NULL,
  `record_year` varchar(4) NOT NULL,
  `pa` int(11) DEFAULT NULL,
  `home_runs` int(11) DEFAULT NULL,
  `rbis` int(11) DEFAULT NULL,
  `hits` int(11) DEFAULT NULL,
  `walks` int(11) DEFAULT NULL,
  `fly_balls` int(11) DEFAULT NULL,
  `pop_outs` int(11) DEFAULT NULL,
  `ground_balls` int(11) DEFAULT NULL,
  `sb` int(11) DEFAULT NULL,
  `cs` int(11) DEFAULT NULL,
  `stolen_base_success_rate` double(5,3) DEFAULT NULL,
  `batting_average` double(5,3) DEFAULT NULL,
  `OBP` double(5,3) DEFAULT NULL,
  `SLG` double(5,3) DEFAULT NULL,
  `OPS` double(5,3) DEFAULT NULL,
  `ISO` double(5,3) DEFAULT NULL,
  `BABIP` double(5,3) DEFAULT NULL,
  `bb_rate` double(5,3) DEFAULT NULL,
  `so_rate` double(5,3) DEFAULT NULL,
  `wRAA` float DEFAULT NULL,
  `wRC` float DEFAULT NULL,
  `swing_rate` float DEFAULT NULL,
  `pitches_per_at_bat` float DEFAULT NULL,
  `foul_rate` float DEFAULT NULL,
  `at_bats` int(11) DEFAULT NULL,
  `so` int(11) DEFAULT NULL,
  `hbp` int(11) DEFAULT NULL,
  `sac` int(11) DEFAULT NULL,
  PRIMARY KEY (`playerID`,`record_year`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `adv_pitching_stats_month`
--

DROP TABLE IF EXISTS `adv_pitching_stats_month`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adv_pitching_stats_month` (
  `playerID` int(11) NOT NULL,
  `record_month` varchar(10) NOT NULL,
  `FIP` float DEFAULT NULL,
  `WHIP` float DEFAULT NULL,
  `xFIP` float DEFAULT NULL,
  `strikeout_rate` double(5,3) DEFAULT NULL,
  `walk_rate` double(5,3) DEFAULT NULL,
  `hr_to_fly_ball_rate` double(5,3) DEFAULT NULL,
  `games_played` int(11) DEFAULT NULL,
  `at_bats` int(11) DEFAULT NULL,
  `home_runs` int(11) DEFAULT NULL,
  `hits` int(11) DEFAULT NULL,
  `walks` int(11) DEFAULT NULL,
  `hit_by_pitch` int(11) DEFAULT NULL,
  `strikeouts` int(11) DEFAULT NULL,
  `outs` int(11) DEFAULT NULL,
  `sac` int(11) DEFAULT NULL,
  `fly_balls` int(11) DEFAULT NULL,
  `ground_balls` int(11) DEFAULT NULL,
  `pop_ups` int(11) DEFAULT NULL,
  `SIERA` float DEFAULT NULL,
  `cFIP` float DEFAULT NULL,
  PRIMARY KEY (`playerID`,`record_month`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `adv_pitching_stats_year`
--

DROP TABLE IF EXISTS `adv_pitching_stats_year`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adv_pitching_stats_year` (
  `playerID` int(11) NOT NULL,
  `record_year` varchar(4) NOT NULL,
  `FIP` double(10,5) DEFAULT NULL,
  `WHIP` double(10,5) DEFAULT NULL,
  `xFIP` double(10,5) DEFAULT NULL,
  `strikeout_rate` double(5,3) DEFAULT NULL,
  `walk_rate` double(5,3) DEFAULT NULL,
  `hr_to_fly_ball_rate` double(6,3) DEFAULT NULL,
  `games_played` int(11) DEFAULT NULL,
  `at_bats` int(11) DEFAULT NULL,
  `home_runs` int(11) DEFAULT NULL,
  `hits` int(11) DEFAULT NULL,
  `walks` int(11) DEFAULT NULL,
  `hit_by_pitch` int(11) DEFAULT NULL,
  `strikeouts` int(11) DEFAULT NULL,
  `outs` int(11) DEFAULT NULL,
  `sac` int(11) DEFAULT NULL,
  `fly_balls` int(11) DEFAULT NULL,
  `ground_balls` int(11) DEFAULT NULL,
  `pop_ups` int(11) DEFAULT NULL,
  `SIERA` float DEFAULT NULL,
  `cFIP` float DEFAULT NULL,
  PRIMARY KEY (`playerID`,`record_year`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `atBat`
--

DROP TABLE IF EXISTS `atBat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `atBat` (
  `gameID` varchar(256) NOT NULL,
  `inningNum` tinyint(3) DEFAULT NULL,
  `topBottom` varchar(6) DEFAULT NULL,
  `atBatNum` int(11) NOT NULL,
  `balls` tinyint(2) DEFAULT NULL,
  `strikes` tinyint(2) DEFAULT NULL,
  `outs` tinyint(2) DEFAULT NULL,
  `start_tfs` varchar(8) DEFAULT NULL,
  `start_tfs_zulu` datetime DEFAULT NULL,
  `batter` int(11) DEFAULT NULL,
  `stand` varchar(2) DEFAULT NULL,
  `b_height` varchar(10) DEFAULT NULL,
  `pitcher` int(11) DEFAULT NULL,
  `p_throws` varchar(2) DEFAULT NULL,
  `des` varchar(256) DEFAULT NULL,
  `des_es` varchar(256) DEFAULT NULL,
  `event_num` int(11) NOT NULL,
  `event` varchar(25) DEFAULT NULL,
  `event_es` varchar(25) DEFAULT NULL,
  `home_team_runs` tinyint(3) DEFAULT NULL,
  `away_team_runs` tinyint(3) DEFAULT NULL,
  `score` varchar(10) DEFAULT NULL,
  `play_guid` varchar(256) DEFAULT NULL,
  `event2` varchar(50) DEFAULT NULL,
  `event2_es` varchar(50) DEFAULT NULL,
  `event3` varchar(50) DEFAULT NULL,
  `event3_es` varchar(50) DEFAULT NULL,
  `event4` varchar(50) DEFAULT NULL,
  `event4_es` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`gameID`,`atBatNum`,`event_num`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `batter_box`
--

DROP TABLE IF EXISTS `batter_box`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `batter_box` (
  `game_id` varchar(255) NOT NULL,
  `home_away` varchar(10) DEFAULT NULL,
  `id` int(11) NOT NULL,
  `order` int(11) DEFAULT NULL,
  `name` varchar(45) DEFAULT NULL,
  `name_display_first_last` varchar(75) DEFAULT NULL,
  `pos` varchar(5) DEFAULT NULL,
  `bo` int(11) DEFAULT NULL,
  `ab` int(11) DEFAULT NULL,
  `po` int(11) DEFAULT NULL,
  `r` int(11) DEFAULT NULL,
  `a` int(11) DEFAULT NULL,
  `bb` int(11) DEFAULT NULL,
  `sac` int(11) DEFAULT NULL,
  `t` int(11) DEFAULT NULL,
  `sf` int(11) DEFAULT NULL,
  `h` int(11) DEFAULT NULL,
  `e` int(11) DEFAULT NULL,
  `d` int(11) DEFAULT NULL,
  `hbp` int(11) DEFAULT NULL,
  `so` int(11) DEFAULT NULL,
  `hr` int(11) DEFAULT NULL,
  `rbi` int(11) DEFAULT NULL,
  `lob` int(11) DEFAULT NULL,
  `fld` float DEFAULT NULL,
  `sb` int(11) DEFAULT NULL,
  `cs` int(11) DEFAULT NULL,
  `s_hr` int(11) DEFAULT NULL,
  `s_rbi` int(11) DEFAULT NULL,
  `s_h` int(11) DEFAULT NULL,
  `s_bb` int(11) DEFAULT NULL,
  `s_r` int(11) DEFAULT NULL,
  `s_so` int(11) DEFAULT NULL,
  `avg` decimal(6,3) DEFAULT NULL,
  `obp` decimal(6,3) DEFAULT NULL,
  `slg` decimal(6,3) DEFAULT NULL,
  `ops` decimal(6,3) DEFAULT NULL,
  `go` int(11) DEFAULT NULL,
  `ao` int(11) DEFAULT NULL,
  `gidp` int(11) DEFAULT NULL,
  PRIMARY KEY (`game_id`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `batting_by_pitch`
--

DROP TABLE IF EXISTS `batting_by_pitch`;
/*!50001 DROP VIEW IF EXISTS `batting_by_pitch`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `batting_by_pitch` AS SELECT 
 1 AS `batter`,
 1 AS `record_year`,
 1 AS `pitch_type`,
 1 AS `pitches_seen`,
 1 AS `swing_rate`,
 1 AS `pitches_per_at_bat`,
 1 AS `foul_rate`,
 1 AS `hits_over_pitches_seen`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `boxscore`
--

DROP TABLE IF EXISTS `boxscore`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boxscore` (
  `home_id` int(11) NOT NULL,
  `away_id` int(11) DEFAULT NULL,
  `game_pk` int(11) DEFAULT NULL,
  `home_loss` int(11) DEFAULT NULL,
  `away_loss` int(11) DEFAULT NULL,
  `venue_id` int(11) DEFAULT NULL,
  `home_team_code` varchar(10) DEFAULT NULL,
  `away_team_code` varchar(10) DEFAULT NULL,
  `date` varchar(45) DEFAULT NULL,
  `away_fname` varchar(45) DEFAULT NULL,
  `away_sname` varchar(45) DEFAULT NULL,
  `home_fname` varchar(45) DEFAULT NULL,
  `home_sname` varchar(45) DEFAULT NULL,
  `venue_name` varchar(45) DEFAULT NULL,
  `away_wins` int(11) DEFAULT NULL,
  `home_wins` int(11) DEFAULT NULL,
  `game_id` varchar(255) NOT NULL,
  `home_sport_code` varchar(10) DEFAULT NULL,
  `status_ind` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`game_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `catcher_stats_month`
--

DROP TABLE IF EXISTS `catcher_stats_month`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catcher_stats_month` (
  `catcher_id` int(11) NOT NULL,
  `record_month` varchar(11) NOT NULL,
  `num_pitches` int(11) DEFAULT NULL,
  `strikes_out_of_zone` int(11) DEFAULT NULL,
  `strikes_in_zone` int(11) DEFAULT NULL,
  `balls_out_of_zone` int(11) DEFAULT NULL,
  `balls_in_zone` int(11) DEFAULT NULL,
  `net_strikes_gained_per_pitch` float DEFAULT NULL,
  `strike_rate_out_of_zone` float DEFAULT NULL,
  `ball_rate_in_zone` float DEFAULT NULL,
  `knuckle_rate` float DEFAULT NULL,
  `fastball_rate` float DEFAULT NULL,
  `breaking_ball_rate` float DEFAULT NULL,
  `changeup_rate` float DEFAULT NULL,
  `wp_count` int(11) DEFAULT NULL,
  `pb_count` int(11) DEFAULT NULL,
  `stolen_bases` int(11) DEFAULT NULL,
  `caught_stealing` int(11) DEFAULT NULL,
  `wp_per_game` float DEFAULT NULL,
  `pb_per_game` float DEFAULT NULL,
  `caught_stealing_over_attempts` float DEFAULT NULL,
  PRIMARY KEY (`catcher_id`,`record_month`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `catcher_stats_year`
--

DROP TABLE IF EXISTS `catcher_stats_year`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catcher_stats_year` (
  `catcher_id` int(11) NOT NULL,
  `record_year` int(11) NOT NULL,
  `num_pitches` int(11) DEFAULT NULL,
  `strikes_out_of_zone` int(11) DEFAULT NULL,
  `strikes_in_zone` int(11) DEFAULT NULL,
  `balls_out_of_zone` int(11) DEFAULT NULL,
  `balls_in_zone` int(11) DEFAULT NULL,
  `net_strikes_gained_per_pitch` float DEFAULT NULL,
  `strike_rate_out_of_zone` float DEFAULT NULL,
  `ball_rate_in_zone` float DEFAULT NULL,
  `knuckle_rate` float DEFAULT NULL,
  `fastball_rate` float DEFAULT NULL,
  `breaking_ball_rate` float DEFAULT NULL,
  `changeup_rate` float DEFAULT NULL,
  `wp_count` int(11) DEFAULT NULL,
  `pb_count` int(11) DEFAULT NULL,
  `stolen_bases` int(11) DEFAULT NULL,
  `caught_stealing` int(11) DEFAULT NULL,
  `wp_per_game` float DEFAULT NULL,
  `pb_per_game` float DEFAULT NULL,
  `caught_stealing_over_attempts` float DEFAULT NULL,
  PRIMARY KEY (`catcher_id`,`record_year`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `coach_game`
--

DROP TABLE IF EXISTS `coach_game`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `coach_game` (
  `gameID` varchar(256) NOT NULL,
  `teamType` varchar(4) DEFAULT NULL,
  `teamID` varchar(5) DEFAULT NULL,
  `teamName` varchar(75) DEFAULT NULL,
  `position` varchar(50) DEFAULT NULL,
  `first` varchar(25) DEFAULT NULL,
  `last` varchar(25) DEFAULT NULL,
  `coachID` int(11) NOT NULL,
  `num` tinyint(3) DEFAULT NULL,
  PRIMARY KEY (`gameID`,`coachID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `game`
--

DROP TABLE IF EXISTS `game`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game` (
  `gameID` varchar(256) NOT NULL,
  `gameDate` varchar(10) DEFAULT NULL,
  `type` varchar(1) DEFAULT NULL,
  `local_gamE_time` varchar(10) DEFAULT NULL,
  `game_pk` int(11) DEFAULT NULL,
  `game_time_et` varchar(12) DEFAULT NULL,
  `gameday_sw` varchar(1) DEFAULT NULL,
  `home_team_id` int(11) DEFAULT NULL,
  `away_team_id` int(11) DEFAULT NULL,
  `stadiumID` int(11) DEFAULT NULL,
  PRIMARY KEY (`gameID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gameDayLight`
--

DROP TABLE IF EXISTS `gameDayLight`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gameDayLight` (
  `gameID` varchar(256) NOT NULL,
  `stadiumID` int(11) DEFAULT NULL,
  `time` varchar(10) NOT NULL,
  `Altitude` decimal(8,4) DEFAULT NULL,
  `Azimuth` decimal(8,4) DEFAULT NULL,
  `lightDateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`gameID`,`time`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `leagues`
--

DROP TABLE IF EXISTS `leagues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `leagues` (
  `leagueID` int(11) NOT NULL,
  `league` varchar(5) DEFAULT NULL,
  `leagueFull` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`leagueID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `leverage`
--

DROP TABLE IF EXISTS `leverage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `leverage` (
  `inning` int(11) NOT NULL,
  `topBottom` varchar(10) NOT NULL,
  `bases` varchar(10) NOT NULL,
  `outs` varchar(5) NOT NULL,
  `hd_4` decimal(6,3) DEFAULT NULL,
  `hd_3` decimal(6,3) DEFAULT NULL,
  `hd_2` decimal(6,3) DEFAULT NULL,
  `hd_1` decimal(6,3) DEFAULT NULL,
  `hd_00` decimal(6,3) DEFAULT NULL,
  `hu_1` decimal(6,3) DEFAULT NULL,
  `hu_2` decimal(6,3) DEFAULT NULL,
  `hu_3` decimal(6,3) DEFAULT NULL,
  `hu_4` decimal(6,3) DEFAULT NULL,
  `on_1b` tinyint(1) DEFAULT NULL,
  `on_2b` tinyint(1) DEFAULT NULL,
  `on_3b` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`inning`,`topBottom`,`bases`,`outs`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `linescore`
--

DROP TABLE IF EXISTS `linescore`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `linescore` (
  `game_id` varchar(255) NOT NULL,
  `away_team_runs` int(11) DEFAULT NULL,
  `home_team_runs` int(11) DEFAULT NULL,
  `away_team_hits` int(11) DEFAULT NULL,
  `home_team_hits` int(11) DEFAULT NULL,
  `away_team_errors` int(11) DEFAULT NULL,
  `home_team_errors` int(11) DEFAULT NULL,
  `note` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`game_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `linescore_inning`
--

DROP TABLE IF EXISTS `linescore_inning`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `linescore_inning` (
  `game_id` varchar(255) NOT NULL,
  `inning` int(11) NOT NULL,
  `home` int(11) DEFAULT NULL,
  `away` int(11) DEFAULT NULL,
  PRIMARY KEY (`game_id`,`inning`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `park_factors`
--

DROP TABLE IF EXISTS `park_factors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `park_factors` (
  `rk` int(11) NOT NULL,
  `park_name` varchar(100) DEFAULT NULL,
  `runs` decimal(8,4) DEFAULT NULL,
  `hr` decimal(8,4) DEFAULT NULL,
  `h` decimal(8,4) DEFAULT NULL,
  `2b` decimal(8,4) DEFAULT NULL,
  `3b` decimal(8,4) DEFAULT NULL,
  `bb` decimal(8,4) DEFAULT NULL,
  PRIMARY KEY (`rk`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pickoff`
--

DROP TABLE IF EXISTS `pickoff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pickoff` (
  `gameID` varchar(256) NOT NULL,
  `atBatNum` int(11) DEFAULT NULL,
  `des` varchar(75) DEFAULT NULL,
  `des_es` varchar(75) DEFAULT NULL,
  `event_num` int(11) NOT NULL,
  `play_guid` varchar(75) DEFAULT NULL,
  `catcher` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`gameID`,`event_num`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pitch`
--

DROP TABLE IF EXISTS `pitch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pitch` (
  `gameID` varchar(256) NOT NULL,
  `atBatNum` int(11) DEFAULT NULL,
  `des` varchar(256) DEFAULT NULL,
  `des_es` varchar(256) DEFAULT NULL,
  `pitchID` int(11) DEFAULT NULL,
  `type` varchar(2) DEFAULT NULL,
  `tfs` varchar(10) DEFAULT NULL,
  `tfs_zulu` datetime DEFAULT NULL,
  `x` float DEFAULT NULL,
  `y` float DEFAULT NULL,
  `event_num` int(11) NOT NULL,
  `sv_id` varchar(20) DEFAULT NULL,
  `play_guid` varchar(256) DEFAULT NULL,
  `start_speed` decimal(8,4) DEFAULT NULL,
  `end_speed` decimal(8,4) DEFAULT NULL,
  `sz_top` decimal(8,4) DEFAULT NULL,
  `sz_bot` decimal(8,4) DEFAULT NULL,
  `pfx_x` decimal(8,4) DEFAULT NULL,
  `pfx_z` decimal(8,4) DEFAULT NULL,
  `px` decimal(8,4) DEFAULT NULL,
  `pz` decimal(8,4) DEFAULT NULL,
  `x0` decimal(8,4) DEFAULT NULL,
  `y0` decimal(8,4) DEFAULT NULL,
  `z0` decimal(8,4) DEFAULT NULL,
  `vx0` decimal(8,4) DEFAULT NULL,
  `vy0` decimal(8,4) DEFAULT NULL,
  `vz0` decimal(8,4) DEFAULT NULL,
  `ax` decimal(8,4) DEFAULT NULL,
  `ay` decimal(8,4) DEFAULT NULL,
  `az` decimal(8,4) DEFAULT NULL,
  `break_y` decimal(8,4) DEFAULT NULL,
  `break_angle` decimal(8,4) DEFAULT NULL,
  `break_length` decimal(8,4) DEFAULT NULL,
  `pitch_type` varchar(5) DEFAULT NULL,
  `type_confidence` decimal(8,4) DEFAULT NULL,
  `zone` tinyint(3) DEFAULT NULL,
  `nasty` tinyint(3) DEFAULT NULL,
  `spin_dir` decimal(8,4) DEFAULT NULL,
  `spin_rate` decimal(8,4) DEFAULT NULL,
  `cc` varchar(20) DEFAULT NULL,
  `mt` varchar(20) DEFAULT NULL,
  `on_1b` int(11) DEFAULT NULL,
  `on_2b` int(11) DEFAULT NULL,
  `on_3b` int(11) DEFAULT NULL,
  PRIMARY KEY (`gameID`,`event_num`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pitchTypeRef`
--

DROP TABLE IF EXISTS `pitchTypeRef`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pitchTypeRef` (
  `pitchType` varchar(5) NOT NULL,
  `pitchDesc` varchar(100) DEFAULT NULL,
  `pitchGroup` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`pitchType`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pitch_frequency_year`
--

DROP TABLE IF EXISTS `pitch_frequency_year`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pitch_frequency_year` (
  `playerID` int(11) NOT NULL,
  `record_year` varchar(4) NOT NULL,
  `total_pitches` int(11) DEFAULT NULL,
  `curveball_freq` float DEFAULT NULL,
  `changeup_freq` float DEFAULT NULL,
  `eephus_freq` float DEFAULT NULL,
  `cutter_freq` float DEFAULT NULL,
  `four_seam_freq` float DEFAULT NULL,
  `forkball_freq` float DEFAULT NULL,
  `splitter_freq` float DEFAULT NULL,
  `two_seam_freq` float DEFAULT NULL,
  `knuckle_curve_freq` float DEFAULT NULL,
  `knuckleball_freq` float DEFAULT NULL,
  `screwball_freq` float DEFAULT NULL,
  `sinker_freq` float DEFAULT NULL,
  `slider_freq` float DEFAULT NULL,
  PRIMARY KEY (`playerID`,`record_year`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `pitch_game_atBat`
--

DROP TABLE IF EXISTS `pitch_game_atBat`;
/*!50001 DROP VIEW IF EXISTS `pitch_game_atBat`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `pitch_game_atBat` AS SELECT 
 1 AS `gameID`,
 1 AS `event_num`,
 1 AS `inningNum`,
 1 AS `atBatNum`,
 1 AS `pitchID`,
 1 AS `event`,
 1 AS `pitch_type`,
 1 AS `pitch_desc`,
 1 AS `pitch_group`,
 1 AS `pitch_speed`,
 1 AS `spin_rate`,
 1 AS `pfx_x`,
 1 AS `pfx_z`,
 1 AS `pfx_movement`,
 1 AS `des`,
 1 AS `pitcher`,
 1 AS `p_throws`,
 1 AS `record_year`,
 1 AS `FIP`,
 1 AS `WHIP`,
 1 AS `xFIP`,
 1 AS `SIERA`,
 1 AS `strikeout_rate`,
 1 AS `walk_rate`,
 1 AS `hr_to_fly_ball_rate`,
 1 AS `outs`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `pitch_pred`
--

DROP TABLE IF EXISTS `pitch_pred`;
/*!50001 DROP VIEW IF EXISTS `pitch_pred`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `pitch_pred` AS SELECT 
 1 AS `gameID`,
 1 AS `event_num`,
 1 AS `inningNum`,
 1 AS `run_differential`,
 1 AS `topBottom`,
 1 AS `atBat_outs`,
 1 AS `atBatNum`,
 1 AS `pitchID`,
 1 AS `event`,
 1 AS `pitch_type`,
 1 AS `pitch_desc`,
 1 AS `pitch_group`,
 1 AS `pitch_speed`,
 1 AS `spin_rate`,
 1 AS `pfx_x`,
 1 AS `pfx_z`,
 1 AS `pfx_movement`,
 1 AS `des`,
 1 AS `pitch_result`,
 1 AS `pitcher`,
 1 AS `p_throws`,
 1 AS `record_year`,
 1 AS `FIP`,
 1 AS `WHIP`,
 1 AS `xFIP`,
 1 AS `SIERA`,
 1 AS `strikeout_rate`,
 1 AS `walk_rate`,
 1 AS `hr_to_fly_ball_rate`,
 1 AS `outs`,
 1 AS `curveball_freq`,
 1 AS `changeup_freq`,
 1 AS `eephus_freq`,
 1 AS `cutter_freq`,
 1 AS `four_seam_freq`,
 1 AS `forkball_freq`,
 1 AS `splitter_freq`,
 1 AS `two_seam_freq`,
 1 AS `knuckle_curve_freq`,
 1 AS `knuckleball_freq`,
 1 AS `screwball_freq`,
 1 AS `sinker_freq`,
 1 AS `slider_freq`,
 1 AS `pa`,
 1 AS `batting_average`,
 1 AS `babip`,
 1 AS `slg`,
 1 AS `obp`,
 1 AS `ops`,
 1 AS `bb_rate`,
 1 AS `so_rate`,
 1 AS `stolen_base_success_rate`,
 1 AS `swing_rate`,
 1 AS `pitches_per_at_bat`,
 1 AS `foul_rate`,
 1 AS `on_1b`,
 1 AS `on_2b`,
 1 AS `on_3b`,
 1 AS `rl_pitcher`,
 1 AS `rl_batter`,
 1 AS `batter`,
 1 AS `strike_rate_out_of_zone`,
 1 AS `ball_rate_in_zone`,
 1 AS `net_strikes_gained_per_pitch`,
 1 AS `knuckle_rate`,
 1 AS `fastball_rate`,
 1 AS `breaking_ball_rate`,
 1 AS `changeup_rate`,
 1 AS `wp_per_game`,
 1 AS `pb_per_game`,
 1 AS `caught_stealing_over_attempts`,
 1 AS `type_confidence`,
 1 AS `abOuts`,
 1 AS `strikes`,
 1 AS `balls`,
 1 AS `atBatLength`,
 1 AS `prev_pitch`,
 1 AS `prev_pitch_2`,
 1 AS `prev_pitch_speed`,
 1 AS `prev_pitch_2_speed`,
 1 AS `prev_pitch_spin_rate`,
 1 AS `prev_pitch_2_spin_rate`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `pitch_type_location`
--

DROP TABLE IF EXISTS `pitch_type_location`;
/*!50001 DROP VIEW IF EXISTS `pitch_type_location`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `pitch_type_location` AS SELECT 
 1 AS `pitcher`,
 1 AS `pitch_type`,
 1 AS `pitch_desc`,
 1 AS `pitch_group`,
 1 AS `x0`,
 1 AS `z0`,
 1 AS `height_in`,
 1 AS `adj_x0`,
 1 AS `adj_z0`,
 1 AS `adj_distance`,
 1 AS `num_pitches`,
 1 AS `spin_rate`,
 1 AS `start_speed`,
 1 AS `spin_dir`,
 1 AS `pfx_x`,
 1 AS `pfx_z`,
 1 AS `first_name`,
 1 AS `last_name`,
 1 AS `depth_of_stride`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pitch_with_count`
--

DROP TABLE IF EXISTS `pitch_with_count`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pitch_with_count` (
  `gameID` varchar(256) NOT NULL,
  `atBatNum` int(11) DEFAULT NULL,
  `des` varchar(256) DEFAULT NULL,
  `des_es` varchar(256) DEFAULT NULL,
  `pitchID` int(11) DEFAULT NULL,
  `type` varchar(2) DEFAULT NULL,
  `tfs` varchar(10) DEFAULT NULL,
  `tfs_zulu` datetime DEFAULT NULL,
  `x` float DEFAULT NULL,
  `y` float DEFAULT NULL,
  `event_num` int(11) NOT NULL,
  `sv_id` varchar(20) DEFAULT NULL,
  `play_guid` varchar(256) DEFAULT NULL,
  `start_speed` decimal(8,4) DEFAULT NULL,
  `end_speed` decimal(8,4) DEFAULT NULL,
  `sz_top` decimal(8,4) DEFAULT NULL,
  `sz_bot` decimal(8,4) DEFAULT NULL,
  `pfx_x` decimal(8,4) DEFAULT NULL,
  `pfx_z` decimal(8,4) DEFAULT NULL,
  `px` decimal(8,4) DEFAULT NULL,
  `pz` decimal(8,4) DEFAULT NULL,
  `x0` decimal(8,4) DEFAULT NULL,
  `y0` decimal(8,4) DEFAULT NULL,
  `z0` decimal(8,4) DEFAULT NULL,
  `vx0` decimal(8,4) DEFAULT NULL,
  `vy0` decimal(8,4) DEFAULT NULL,
  `vz0` decimal(8,4) DEFAULT NULL,
  `ax` decimal(8,4) DEFAULT NULL,
  `ay` decimal(8,4) DEFAULT NULL,
  `az` decimal(8,4) DEFAULT NULL,
  `break_y` decimal(8,4) DEFAULT NULL,
  `break_angle` decimal(8,4) DEFAULT NULL,
  `break_length` decimal(8,4) DEFAULT NULL,
  `pitch_type` varchar(5) DEFAULT NULL,
  `type_confidence` decimal(8,4) DEFAULT NULL,
  `zone` tinyint(3) DEFAULT NULL,
  `nasty` tinyint(3) DEFAULT NULL,
  `spin_dir` decimal(8,4) DEFAULT NULL,
  `spin_rate` decimal(8,4) DEFAULT NULL,
  `cc` varchar(20) DEFAULT NULL,
  `mt` varchar(20) DEFAULT NULL,
  `on_1b` int(11) DEFAULT NULL,
  `on_2b` int(11) DEFAULT NULL,
  `on_3b` int(11) DEFAULT NULL,
  `strikes` int(11) DEFAULT NULL,
  `balls` int(11) DEFAULT NULL,
  `atBatLength` int(11) DEFAULT NULL,
  `abOuts` int(11) DEFAULT NULL,
  `prev_pitch` varchar(5) DEFAULT NULL,
  `prev_pitch_2` varchar(5) DEFAULT NULL,
  `inningNum` int(11) DEFAULT NULL,
  `topBottom` varchar(45) DEFAULT NULL,
  `outs` int(11) DEFAULT NULL,
  `prev_pitch_speed` float DEFAULT NULL,
  `prev_pitch_2_speed` float DEFAULT NULL,
  `prev_pitch_spin_rate` float DEFAULT NULL,
  `prev_pitch_2_spin_rate` float DEFAULT NULL,
  PRIMARY KEY (`gameID`,`event_num`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pitcher_box`
--

DROP TABLE IF EXISTS `pitcher_box`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pitcher_box` (
  `game_id` varchar(255) NOT NULL,
  `home_away` varchar(10) DEFAULT NULL,
  `id` int(11) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `name_display_first_last` varchar(45) DEFAULT NULL,
  `pos` varchar(5) DEFAULT NULL,
  `out` int(11) DEFAULT NULL,
  `bf` int(11) DEFAULT NULL,
  `er` int(11) DEFAULT NULL,
  `r` int(11) DEFAULT NULL,
  `h` int(11) DEFAULT NULL,
  `so` int(11) DEFAULT NULL,
  `hr` int(11) DEFAULT NULL,
  `bb` int(11) DEFAULT NULL,
  `np` int(11) DEFAULT NULL,
  `st` int(11) DEFAULT NULL,
  `w` int(11) DEFAULT NULL,
  `l` int(11) DEFAULT NULL,
  `sv` int(11) DEFAULT NULL,
  `bs` int(11) DEFAULT NULL,
  `hld` int(11) DEFAULT NULL,
  `s_ip` decimal(8,2) DEFAULT NULL,
  `s_h` int(11) DEFAULT NULL,
  `s_r` int(11) DEFAULT NULL,
  `sum_err` int(11) DEFAULT NULL,
  `sum_bb` int(11) DEFAULT NULL,
  `s_so` int(11) DEFAULT NULL,
  `game_score` int(11) DEFAULT NULL,
  `era` decimal(6,3) DEFAULT NULL,
  `win` varchar(5) DEFAULT NULL,
  `loss` varchar(5) DEFAULT NULL,
  `note` varchar(45) DEFAULT NULL,
  `order` int(11) DEFAULT NULL,
  PRIMARY KEY (`game_id`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player`
--

DROP TABLE IF EXISTS `player`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player` (
  `playerID` int(11) NOT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `rl_throws` varchar(2) DEFAULT NULL,
  `rl_bats` varchar(2) DEFAULT NULL,
  `position` varchar(5) DEFAULT NULL,
  `height` varchar(45) DEFAULT NULL,
  `height_in` int(11) DEFAULT NULL,
  `weight` varchar(45) DEFAULT NULL,
  `birthDate` varchar(45) DEFAULT NULL,
  `birthPlace` varchar(45) DEFAULT NULL,
  `birth_city` varchar(45) DEFAULT NULL,
  `birth_state_or_country` varchar(45) DEFAULT NULL,
  `draft_year` int(11) DEFAULT NULL,
  `draft_team` varchar(45) DEFAULT NULL,
  `draft_round` varchar(45) DEFAULT NULL,
  `drafted_from` varchar(45) DEFAULT NULL,
  `high_school` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`playerID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_game`
--

DROP TABLE IF EXISTS `player_game`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_game` (
  `gameID` varchar(256) NOT NULL,
  `teamType` varchar(4) NOT NULL,
  `playerID` int(11) NOT NULL,
  `first` varchar(25) DEFAULT NULL,
  `last` varchar(25) DEFAULT NULL,
  `num` tinyint(3) DEFAULT NULL,
  `boxname` varchar(25) DEFAULT NULL,
  `rl` varchar(2) DEFAULT NULL,
  `bats` varchar(2) DEFAULT NULL,
  `position` varchar(2) DEFAULT NULL,
  `current_position` varchar(2) DEFAULT NULL,
  `status` varchar(2) DEFAULT NULL,
  `team_abbrev` varchar(5) DEFAULT NULL,
  `teamID` int(11) DEFAULT NULL,
  `parent_team_abbrev` varchar(5) DEFAULT NULL,
  `parent_team_id` int(11) DEFAULT NULL,
  `bat_order` tinyint(2) DEFAULT NULL,
  `game_position` varchar(2) DEFAULT NULL,
  `avg` decimal(7,4) DEFAULT NULL,
  `hr` tinyint(3) DEFAULT NULL,
  `rbi` tinyint(3) DEFAULT NULL,
  `wins` tinyint(3) DEFAULT NULL,
  `losses` tinyint(3) DEFAULT NULL,
  `era` decimal(7,4) DEFAULT NULL,
  PRIMARY KEY (`gameID`,`playerID`,`teamType`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `player_stats_game`
--

DROP TABLE IF EXISTS `player_stats_game`;
/*!50001 DROP VIEW IF EXISTS `player_stats_game`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `player_stats_game` AS SELECT 
 1 AS `playerID`,
 1 AS `gameID`,
 1 AS `pa`,
 1 AS `home_runs`,
 1 AS `rbis`,
 1 AS `singles`,
 1 AS `doubles`,
 1 AS `triples`,
 1 AS `bb`,
 1 AS `hbp`,
 1 AS `ibb`,
 1 AS `so`,
 1 AS `sac`,
 1 AS `fly_balls`,
 1 AS `pop_outs`,
 1 AS `ground_balls`,
 1 AS `err`,
 1 AS `interference`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `pred_pitcher`
--

DROP TABLE IF EXISTS `pred_pitcher`;
/*!50001 DROP VIEW IF EXISTS `pred_pitcher`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `pred_pitcher` AS SELECT 
 1 AS `game_id`,
 1 AS `home_away`,
 1 AS `player_id`,
 1 AS `team`,
 1 AS `pitching_order`,
 1 AS `start_relief`,
 1 AS `name`,
 1 AS `name_display_first_last`,
 1 AS `pos`,
 1 AS `out`,
 1 AS `bf`,
 1 AS `er`,
 1 AS `r`,
 1 AS `h`,
 1 AS `so`,
 1 AS `hr`,
 1 AS `bb`,
 1 AS `np`,
 1 AS `st`,
 1 AS `w`,
 1 AS `l`,
 1 AS `sv`,
 1 AS `bs`,
 1 AS `hld`,
 1 AS `s_ip`,
 1 AS `s_h`,
 1 AS `s_r`,
 1 AS `sum_err`,
 1 AS `sum_bb`,
 1 AS `s_so`,
 1 AS `game_score`,
 1 AS `era`,
 1 AS `win`,
 1 AS `loss`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ref_elias_to_lehman`
--

DROP TABLE IF EXISTS `ref_elias_to_lehman`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ref_elias_to_lehman` (
  `eliasid` int(11) NOT NULL,
  `first` varchar(45) DEFAULT NULL,
  `last` varchar(45) DEFAULT NULL,
  `lehmanid` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`eliasid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `runner`
--

DROP TABLE IF EXISTS `runner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `runner` (
  `gameID` varchar(256) NOT NULL,
  `atBatNum` int(11) DEFAULT NULL,
  `playerID` int(11) NOT NULL,
  `start` varchar(5) NOT NULL,
  `end` varchar(5) DEFAULT NULL,
  `event` varchar(50) DEFAULT NULL,
  `event_num` int(11) NOT NULL,
  `score` tinyint(1) DEFAULT NULL,
  `rbi` tinyint(1) DEFAULT NULL,
  `earned` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`gameID`,`event_num`,`playerID`,`start`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stadium_game`
--

DROP TABLE IF EXISTS `stadium_game`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stadium_game` (
  `gameID` varchar(256) NOT NULL,
  `stadiumID` int(11) NOT NULL,
  `name` varchar(75) DEFAULT NULL,
  `venue_w_chan_loc` varchar(15) DEFAULT NULL,
  `location` varchar(75) DEFAULT NULL,
  `sun_beginCivilTwilight` varchar(15) DEFAULT NULL,
  `sunSet` varchar(15) DEFAULT NULL,
  `sun_upperTransit` varchar(15) DEFAULT NULL,
  `sunRise` varchar(15) DEFAULT NULL,
  `sun_endCivilTwilight` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`gameID`,`stadiumID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `team`
--

DROP TABLE IF EXISTS `team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `team` (
  `team_code` varchar(5) DEFAULT NULL,
  `file_code` varchar(5) DEFAULT NULL,
  `abbrev` varchar(5) DEFAULT NULL,
  `teamID` int(11) NOT NULL,
  `name` varchar(25) DEFAULT NULL,
  `name_full` varchar(100) DEFAULT NULL,
  `name_brief` varchar(25) DEFAULT NULL,
  `division_id` int(11) DEFAULT NULL,
  `league_id` int(11) DEFAULT NULL,
  `league` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`teamID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `team_game`
--

DROP TABLE IF EXISTS `team_game`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `team_game` (
  `gameID` varchar(256) NOT NULL,
  `type` varchar(4) DEFAULT NULL,
  `code` varchar(5) DEFAULT NULL,
  `file_code` varchar(5) DEFAULT NULL,
  `abbrev` varchar(5) DEFAULT NULL,
  `teamID` int(11) NOT NULL,
  `name` varchar(25) DEFAULT NULL,
  `name_full` varchar(100) DEFAULT NULL,
  `name_brief` varchar(25) DEFAULT NULL,
  `wins` tinyint(3) DEFAULT NULL,
  `losses` tinyint(3) DEFAULT NULL,
  `division_id` int(11) DEFAULT NULL,
  `league_id` int(11) DEFAULT NULL,
  `league` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`gameID`,`teamID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `umpire_game`
--

DROP TABLE IF EXISTS `umpire_game`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `umpire_game` (
  `gameID` varchar(256) NOT NULL,
  `position` varchar(10) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `umpID` int(11) NOT NULL,
  `first` varchar(25) DEFAULT NULL,
  `last` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`gameID`,`umpID`,`position`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Final view structure for view `batting_by_pitch`
--

/*!50001 DROP VIEW IF EXISTS `batting_by_pitch`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`admin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `batting_by_pitch` AS (select `ab`.`batter` AS `batter`,substr(`ab`.`gameID`,1,4) AS `record_year`,`p`.`pitch_type` AS `pitch_type`,count(1) AS `pitches_seen`,round((sum((case when ((`p`.`des` = 'Swinging Strike') or (lcase(`p`.`des`) like '%foul%') or (lcase(`p`.`des`) like '%in%play%')) then 1 else 0 end)) / count(1)),3) AS `swing_rate`,round((count(1) / count(distinct `ab`.`gameID`,`ab`.`atBatNum`)),3) AS `pitches_per_at_bat`,round((sum((case when (lcase(`p`.`des`) like '%foul%') then 1 else 0 end)) / sum((case when (lcase(`p`.`des`) like '%in%play%') then 1 else 0 end))),3) AS `foul_rate`,(sum((case when (`p`.`des` like '%in%play%no%out') then 1 else 0 end)) / count(1)) AS `hits_over_pitches_seen` from ((`atBat` `ab` join `game` `g` on(((`g`.`gameID` = `ab`.`gameID`) and (`g`.`type` = 'R')))) join `pitch` `p` on(((`p`.`gameID` = `ab`.`gameID`) and (`p`.`atBatNum` = `ab`.`atBatNum`) and (not((`ab`.`event` like '%Error%'))) and (not((`ab`.`event` like '%Interference%')))))) group by `ab`.`batter`,substr(`ab`.`gameID`,1,4),`p`.`pitch_type`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `pitch_game_atBat`
--

/*!50001 DROP VIEW IF EXISTS `pitch_game_atBat`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`emarcey`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `pitch_game_atBat` AS (select `g`.`gameID` AS `gameID`,`ab`.`event_num` AS `event_num`,`ab`.`inningNum` AS `inningNum`,`ab`.`atBatNum` AS `atBatNum`,`p`.`pitchID` AS `pitchID`,`ab`.`event` AS `event`,ifnull(`p`.`pitch_type`,'UN') AS `pitch_type`,ifnull(`ptr`.`pitchDesc`,'UN') AS `pitch_desc`,ifnull(`ptr`.`pitchGroup`,'UN') AS `pitch_group`,ifnull(`p`.`start_speed`,0) AS `pitch_speed`,ifnull(`p`.`spin_rate`,0) AS `spin_rate`,ifnull(`p`.`pfx_x`,0) AS `pfx_x`,ifnull(`p`.`pfx_z`,0) AS `pfx_z`,ifnull(sqrt((pow(`p`.`pfx_x`,2) + pow(`p`.`pfx_z`,2))),0) AS `pfx_movement`,`p`.`des` AS `des`,`ab`.`pitcher` AS `pitcher`,`ab`.`p_throws` AS `p_throws`,ifnull(`apsy`.`record_year`,0) AS `record_year`,ifnull(`apsy`.`FIP`,0) AS `FIP`,ifnull(`apsy`.`WHIP`,0) AS `WHIP`,ifnull(`apsy`.`xFIP`,0) AS `xFIP`,ifnull(`apsy`.`SIERA`,0) AS `SIERA`,ifnull(`apsy`.`strikeout_rate`,0) AS `strikeout_rate`,ifnull(`apsy`.`walk_rate`,0) AS `walk_rate`,ifnull(`apsy`.`hr_to_fly_ball_rate`,0) AS `hr_to_fly_ball_rate`,ifnull(`apsy`.`outs`,0) AS `outs` from ((((`pitch` `p` join `game` `g` on(((`p`.`gameID` = `g`.`gameID`) and (`g`.`type` = 'R')))) join `atBat` `ab` on(((`ab`.`gameID` = `p`.`gameID`) and (`ab`.`atBatNum` = `p`.`atBatNum`) and (not((`ab`.`event` like '%Interference%'))) and (not((`ab`.`event` like '%Error%'))) and (not((`ab`.`event` like '%Sac%'))) and (`ab`.`event` <> 'Hit By Pitch') and (`ab`.`event` <> 'Intent Walk')))) left join `adv_pitching_stats_year` `apsy` on(((`apsy`.`playerID` = `ab`.`pitcher`) and (`apsy`.`record_year` = substr(`ab`.`gameID`,1,4))))) left join `pitchTypeRef` `ptr` on((`ptr`.`pitchType` = `p`.`pitch_type`))) order by `g`.`gameID`,`ab`.`atBatNum`,`p`.`pitchID`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `pitch_pred`
--

/*!50001 DROP VIEW IF EXISTS `pitch_pred`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`admin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `pitch_pred` AS (select `g`.`gameID` AS `gameID`,`ab`.`event_num` AS `event_num`,`ab`.`inningNum` AS `inningNum`,(case when (`ab`.`topBottom` = 'Top') then (`ab`.`home_team_runs` - `ab`.`away_team_runs`) else (`ab`.`away_team_runs` - `ab`.`home_team_runs`) end) AS `run_differential`,`ab`.`topBottom` AS `topBottom`,`ab`.`outs` AS `atBat_outs`,`ab`.`atBatNum` AS `atBatNum`,`p`.`pitchID` AS `pitchID`,`ab`.`event` AS `event`,ifnull(`p`.`pitch_type`,'UN') AS `pitch_type`,ifnull(`ptr`.`pitchDesc`,'UN') AS `pitch_desc`,ifnull(`ptr`.`pitchGroup`,'UN') AS `pitch_group`,ifnull(`p`.`start_speed`,0) AS `pitch_speed`,ifnull(`p`.`spin_rate`,0) AS `spin_rate`,ifnull(`p`.`pfx_x`,0) AS `pfx_x`,ifnull(`p`.`pfx_z`,0) AS `pfx_z`,ifnull(sqrt((pow(`p`.`pfx_x`,2) + pow(`p`.`pfx_z`,2))),0) AS `pfx_movement`,`p`.`des` AS `des`,`p`.`type` AS `pitch_result`,`ab`.`pitcher` AS `pitcher`,`ab`.`p_throws` AS `p_throws`,ifnull(`apsy`.`record_year`,0) AS `record_year`,ifnull(`apsy`.`FIP`,0) AS `FIP`,ifnull(`apsy`.`WHIP`,0) AS `WHIP`,ifnull(`apsy`.`xFIP`,0) AS `xFIP`,ifnull(`apsy`.`SIERA`,0) AS `SIERA`,ifnull(`apsy`.`strikeout_rate`,0) AS `strikeout_rate`,ifnull(`apsy`.`walk_rate`,0) AS `walk_rate`,ifnull(`apsy`.`hr_to_fly_ball_rate`,0) AS `hr_to_fly_ball_rate`,ifnull(`apsy`.`outs`,0) AS `outs`,`pfy`.`curveball_freq` AS `curveball_freq`,`pfy`.`changeup_freq` AS `changeup_freq`,`pfy`.`eephus_freq` AS `eephus_freq`,`pfy`.`cutter_freq` AS `cutter_freq`,`pfy`.`four_seam_freq` AS `four_seam_freq`,`pfy`.`forkball_freq` AS `forkball_freq`,`pfy`.`splitter_freq` AS `splitter_freq`,`pfy`.`two_seam_freq` AS `two_seam_freq`,`pfy`.`knuckle_curve_freq` AS `knuckle_curve_freq`,`pfy`.`knuckleball_freq` AS `knuckleball_freq`,`pfy`.`screwball_freq` AS `screwball_freq`,`pfy`.`sinker_freq` AS `sinker_freq`,`pfy`.`slider_freq` AS `slider_freq`,`absy`.`pa` AS `pa`,`absy`.`batting_average` AS `batting_average`,`absy`.`BABIP` AS `babip`,`absy`.`SLG` AS `slg`,`absy`.`OBP` AS `obp`,`absy`.`OPS` AS `ops`,`absy`.`bb_rate` AS `bb_rate`,`absy`.`so_rate` AS `so_rate`,`absy`.`stolen_base_success_rate` AS `stolen_base_success_rate`,`absy`.`swing_rate` AS `swing_rate`,`absy`.`pitches_per_at_bat` AS `pitches_per_at_bat`,`absy`.`foul_rate` AS `foul_rate`,(case when (`p`.`on_1b` > 0) then 1 else 0 end) AS `on_1b`,(case when (`p`.`on_2b` > 0) then 1 else 0 end) AS `on_2b`,(case when (`p`.`on_3b` > 0) then 1 else 0 end) AS `on_3b`,`ab`.`p_throws` AS `rl_pitcher`,`ab`.`stand` AS `rl_batter`,`ab`.`batter` AS `batter`,`cs`.`strike_rate_out_of_zone` AS `strike_rate_out_of_zone`,`cs`.`ball_rate_in_zone` AS `ball_rate_in_zone`,`cs`.`net_strikes_gained_per_pitch` AS `net_strikes_gained_per_pitch`,`cs`.`knuckle_rate` AS `knuckle_rate`,`cs`.`fastball_rate` AS `fastball_rate`,`cs`.`breaking_ball_rate` AS `breaking_ball_rate`,`cs`.`changeup_rate` AS `changeup_rate`,`cs`.`wp_per_game` AS `wp_per_game`,`cs`.`pb_per_game` AS `pb_per_game`,`cs`.`caught_stealing_over_attempts` AS `caught_stealing_over_attempts`,`p`.`type_confidence` AS `type_confidence`,`p`.`abOuts` AS `abOuts`,`p`.`strikes` AS `strikes`,`p`.`balls` AS `balls`,`p`.`atBatLength` AS `atBatLength`,`p`.`prev_pitch` AS `prev_pitch`,`p`.`prev_pitch_2` AS `prev_pitch_2`,`p`.`prev_pitch_speed` AS `prev_pitch_speed`,`p`.`prev_pitch_2_speed` AS `prev_pitch_2_speed`,`p`.`prev_pitch_spin_rate` AS `prev_pitch_spin_rate`,`p`.`prev_pitch_2_spin_rate` AS `prev_pitch_2_spin_rate` from ((((((((`pitch_with_count` `p` join `game` `g` on(((`p`.`gameID` = `g`.`gameID`) and (`g`.`type` = 'R')))) join `atBat` `ab` on(((`ab`.`gameID` = `p`.`gameID`) and (`ab`.`atBatNum` = `p`.`atBatNum`)))) join `adv_pitching_stats_year` `apsy` on(((`apsy`.`playerID` = `ab`.`pitcher`) and (`apsy`.`record_year` = substr(`ab`.`gameID`,1,4))))) join `pitchTypeRef` `ptr` on((`ptr`.`pitchType` = `p`.`pitch_type`))) join `pitch_frequency_year` `pfy` on(((`pfy`.`playerID` = `ab`.`pitcher`) and (`pfy`.`record_year` = substr(`ab`.`gameID`,1,4))))) join `adv_batting_stats_year` `absy` on(((`absy`.`playerID` = `ab`.`batter`) and (`absy`.`record_year` = substr(`ab`.`gameID`,1,4))))) join `player_game` `pg` on(((`pg`.`gameID` = `g`.`gameID`) and (((`ab`.`topBottom` = 'top') and (`pg`.`teamType` = 'home')) or ((`ab`.`topBottom` = 'bottom') and (`pg`.`teamType` = 'away'))) and (`pg`.`game_position` = 'C')))) join `catcher_stats_year` `cs` on(((`pg`.`playerID` = `cs`.`catcher_id`) and (substr(`ab`.`gameID`,1,4) = `cs`.`record_year`)))) order by `g`.`gameID`,`ab`.`atBatNum`,`p`.`pitchID`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `pitch_type_location`
--

/*!50001 DROP VIEW IF EXISTS `pitch_type_location`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`admin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `pitch_type_location` AS (select `ab`.`pitcher` AS `pitcher`,`p`.`pitch_type` AS `pitch_type`,`ptr`.`pitchDesc` AS `pitch_desc`,`ptr`.`pitchGroup` AS `pitch_group`,abs(`p`.`x0`) AS `x0`,avg(`p`.`z0`) AS `z0`,`pl`.`height_in` AS `height_in`,(avg(abs((`p`.`x0` * 12))) / ((`pl`.`height_in` / 2) - 3)) AS `adj_x0`,avg((((`p`.`z0` * 12) - ((abs((`p`.`z0` * 12)) - sqrt((pow(((`pl`.`height_in` / 2) - 3),2) - pow((`p`.`x0` * 12),2)))) + 8)) / ((`pl`.`height_in` / 2) - 3))) AS `adj_z0`,sqrt((pow((avg(abs(`p`.`x0`)) / (`pl`.`height_in` / 2)),2) + pow((avg(`p`.`z0`) / (`pl`.`height_in` / 2)),2))) AS `adj_distance`,count(1) AS `num_pitches`,avg(`p`.`spin_rate`) AS `spin_rate`,avg(`p`.`start_speed`) AS `start_speed`,avg(abs((180 - `p`.`spin_dir`))) AS `spin_dir`,avg(abs(`p`.`pfx_x`)) AS `pfx_x`,avg(`p`.`pfx_z`) AS `pfx_z`,`pl`.`first_name` AS `first_name`,`pl`.`last_name` AS `last_name`,avg((`pl`.`height_in` - ((abs((`p`.`z0` * 12)) - sqrt((pow(((`pl`.`height_in` / 2) - 3),2) - pow((`p`.`x0` * 12),2)))) + 8))) AS `depth_of_stride` from ((((`atBat` `ab` join `game` `g` on(((`g`.`type` = 'R') and (`g`.`gameID` = `ab`.`gameID`)))) join `pitch` `p` on(((`p`.`gameID` = `ab`.`gameID`) and (`p`.`atBatNum` = `ab`.`atBatNum`) and (`p`.`pfx_x` is not null) and (`p`.`pfx_x` > 0) and (`p`.`type_confidence` >= 0.75)))) join `player` `pl` on(((`pl`.`height` is not null) and (`pl`.`playerID` = `ab`.`pitcher`)))) join `pitchTypeRef` `ptr` on((`ptr`.`pitchType` = `p`.`pitch_type`))) group by `ab`.`pitcher`,`p`.`pitch_type`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `player_stats_game`
--

/*!50001 DROP VIEW IF EXISTS `player_stats_game`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`admin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `player_stats_game` AS (select `pg`.`playerID` AS `playerID`,`g`.`gameID` AS `gameID`,count(`ab`.`atBatNum`) AS `pa`,sum((case when (`ab`.`event` = 'Home Run') then 1 else 0 end)) AS `home_runs`,round((sum(`pg`.`rbi`) / count(distinct `pg`.`gameID`)),0) AS `rbis`,sum((case when (`ab`.`event` = 'Single') then 1 else 0 end)) AS `singles`,sum((case when (`ab`.`event` = 'Double') then 1 else 0 end)) AS `doubles`,sum((case when (`ab`.`event` = 'Triple') then 1 else 0 end)) AS `triples`,sum((case when (`ab`.`event` = 'Walk') then 1 else 0 end)) AS `bb`,sum((case when (`ab`.`event` = 'Intent Walk') then 1 else 0 end)) AS `hbp`,sum((case when (`ab`.`event` = 'Hit By Pitch') then 1 else 0 end)) AS `ibb`,sum((case when (`ab`.`event` like '%Strikeout%') then 1 else 0 end)) AS `so`,sum((case when (ucase(`ab`.`event`) like '%SAC%') then 1 else 0 end)) AS `sac`,sum((case when (ucase(`ab`.`event`) like '%FLY%') then 1 else 0 end)) AS `fly_balls`,sum((case when (ucase(`ab`.`event`) like '%POP%') then 1 else 0 end)) AS `pop_outs`,sum((case when (ucase(`ab`.`event`) like '%GROUND%') then 1 else 0 end)) AS `ground_balls`,sum((case when (ucase(`ab`.`event`) like '%ERROR%') then 1 else 0 end)) AS `err`,sum((case when (ucase(`ab`.`event`) like '%INTERFERENCE%') then 1 else 0 end)) AS `interference` from ((`game` `g` join `player_game` `pg` on(((`g`.`gameID` = `pg`.`gameID`) and (`g`.`type` = 'R')))) join `atBat` `ab` on(((`g`.`gameID` = `ab`.`gameID`) and (`pg`.`playerID` = `ab`.`batter`)))) group by `pg`.`playerID`,`g`.`gameID`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `pred_pitcher`
--

/*!50001 DROP VIEW IF EXISTS `pred_pitcher`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`admin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `pred_pitcher` AS (select `pbx`.`game_id` AS `game_id`,`pbx`.`home_away` AS `home_away`,`pbx`.`id` AS `player_id`,(case `pbx`.`home_away` when 'home' then `g`.`home_team_id` when 'away' then `g`.`away_team_id` else 'error' end) AS `team`,`pbx`.`order` AS `pitching_order`,(case `pbx`.`order` when 1 then 'SP' else 'RP' end) AS `start_relief`,`pbx`.`name` AS `name`,`pbx`.`name_display_first_last` AS `name_display_first_last`,`pbx`.`pos` AS `pos`,`pbx`.`out` AS `out`,`pbx`.`bf` AS `bf`,`pbx`.`er` AS `er`,`pbx`.`r` AS `r`,`pbx`.`h` AS `h`,`pbx`.`so` AS `so`,`pbx`.`hr` AS `hr`,`pbx`.`bb` AS `bb`,`pbx`.`np` AS `np`,`pbx`.`st` AS `st`,`pbx`.`w` AS `w`,`pbx`.`l` AS `l`,`pbx`.`sv` AS `sv`,`pbx`.`bs` AS `bs`,`pbx`.`hld` AS `hld`,`pbx`.`s_ip` AS `s_ip`,`pbx`.`s_h` AS `s_h`,`pbx`.`s_r` AS `s_r`,`pbx`.`sum_err` AS `sum_err`,`pbx`.`sum_bb` AS `sum_bb`,`pbx`.`s_so` AS `s_so`,`pbx`.`game_score` AS `game_score`,`pbx`.`era` AS `era`,`pbx`.`win` AS `win`,`pbx`.`loss` AS `loss` from (`pitcher_box` `pbx` join `game` `g` on((`g`.`gameID` = `pbx`.`game_id`))) where (`g`.`type` = 'R')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-08-29 16:19:52
