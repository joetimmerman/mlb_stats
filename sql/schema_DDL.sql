--create database schema
CREATE DATABASE `mlb_data_test` /*!40100 DEFAULT CHARACTER SET latin1 */;

--create action table
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

--create atBat table
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

--create batter_box table
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

--create boxscore table
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

--create coachGame table
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

--create game table
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

--create leverage table
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

--create linescore table
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

--create linescore_inning table
CREATE TABLE `linescore_inning` (
  `game_id` varchar(255) NOT NULL,
  `inning` int(11) NOT NULL,
  `home` int(11) DEFAULT NULL,
  `away` int(11) DEFAULT NULL,
  PRIMARY KEY (`game_id`,`inning`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--create park_factors table
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

--create pickoff table
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

--create pitch table
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

--create pitcher_box table
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

--create playerGame table
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

--create runner table
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

--create stadiumGame table
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
	
--create teamGame table
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

--create umpireGame table
CREATE TABLE `umpire_game` (
  `gameID` varchar(256) NOT NULL,
  `position` varchar(10) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `umpID` int(11) NOT NULL,
  `first` varchar(25) DEFAULT NULL,
  `last` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`gameID`,`umpID`,`position`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- create table with stats for adv batting metrics by month
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

-- create table with stats for adv batting metrics by year
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
  PRIMARY KEY (`playerID`,`record_year`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- create table with stats for adv pitching metrics by year
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

--create table of unique players
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

--create table of unique teams
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

-- reference table for pitch types with full name and group (Fastball, Cahngeup, Breaking Ball)
CREATE TABLE `pitchTypeRef` (
  `pitchType` varchar(5) NOT NULL,
  `pitchDesc` varchar(100) DEFAULT NULL,
  `pitchGroup` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`pitchType`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ref_elias_to_lehman bridges the two different kinds of playerIDs
-- you'll see both of these kinds of ids in different places
-- our playerID key is the eliasid, but other APIs and webpages often use lehmanid
CREATE TABLE `ref_elias_to_lehman` (
  `eliasid` int(11) NOT NULL,
  `first` varchar(45) DEFAULT NULL,
  `last` varchar(45) DEFAULT NULL,
  `lehmanid` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`eliasid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
