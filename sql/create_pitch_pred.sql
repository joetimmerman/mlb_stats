CREATE OR REPLACE VIEW pitch_pred AS
(select 	g.gameID 					AS gameID,
			ab.event_num 				AS event_num,
			ab.inningNum 				AS inningNum,
            CASE 
				WHEN ab.topBottom = 'Top' 
					THEN ab.home_team_runs-ab.away_team_runs
				ELSE ab.away_team_runs-ab.home_team_runs
			END run_differential,
            ab.topBottom				AS topBottom,
            ab.outs						AS atBat_outs,
            ab.atBatNum 				AS atBatNum,
            p.pitchID 					AS pitchID,
            ab.event 					AS event,
            ifnull(p.pitch_type,'UN') 	AS pitch_type,
            ifnull(ptr.pitchDesc,'UN')	AS pitch_desc,
            ifnull(ptr.pitchGroup,'UN')	AS pitch_group,
            ifnull(p.start_speed,0)		AS pitch_speed,
            ifnull(p.spin_rate,0)		AS spin_rate,
            ifnull(p.pfx_x,0)			AS pfx_x,
            ifnull(p.pfx_z,0)			AS pfx_z,
            ifnull(SQRT(POW(p.pfx_x,2)+POW(p.pfx_z,2)),0)			AS pfx_movement,
            p.des 						AS des,
            p.type						AS pitch_result,
            ab.pitcher 					AS pitcher,
            ab.p_throws 				AS p_throws,
            ifnull(apsy.record_year,0) 	AS record_year,
            ifnull(apsy.FIP,0) 			AS FIP,
            ifnull(apsy.WHIP,0) 		AS WHIP,
            ifnull(apsy.xFIP,0) 		AS xFIP,
            ifnull(apsy.SIERA,0) 		AS SIERA,
            ifnull(apsy.strikeout_rate,0) 		AS strikeout_rate,
            ifnull(apsy.walk_rate,0) 			AS walk_rate,
            ifnull(apsy.hr_to_fly_ball_rate,0) 	AS hr_to_fly_ball_rate,
            ifnull(apsy.outs,0) 				AS outs,
            pfy.curveball_freq,
            pfy.changeup_freq,
            pfy.eephus_freq,
            pfy.cutter_freq,
            pfy.four_seam_freq,
            pfy.forkball_freq,
            pfy.splitter_freq,
            pfy.two_seam_freq,
            pfy.knuckle_curve_freq,
            pfy.knuckleball_freq,
            pfy.screwball_freq,
            pfy.sinker_freq,
            pfy.slider_freq,
            absy.pa,
            absy.batting_average,
            absy.babip,
            absy.slg,
            absy.obp,
            absy.ops,
            absy.bb_rate,
            absy.so_rate,
            absy.stolen_base_success_rate,
            absy.swing_rate,
            absy.pitches_per_at_bat,
            absy.foul_rate,
            CASE 
				WHEN p.on_1b > 0
					THEN 1 
				ELSE 0
			END on_1b,
            CASE 
				WHEN p.on_2b > 0
					THEN 1 
				ELSE 0
			END on_2b,
            CASE 
				WHEN p.on_3b > 0
					THEN 1 
				ELSE 0
			END on_3b,
            ab.p_throws rl_pitcher ,
            ab.stand rl_batter,
			ab.batter,
            cs.strike_rate_out_of_zone,
            cs.ball_rate_in_zone,
            cs.net_strikes_gained_per_pitch,
            cs.knuckle_rate,
            cs.fastball_rate,
            cs.breaking_ball_rate,
            cs.changeup_rate,
            cs.wp_per_game,
            cs.pb_per_game,
            cs.caught_stealing_over_attempts,
            p.type_confidence,
			p.abOuts,
			p.strikes,
			p.balls,
			p.atBatLength,
			p.prev_pitch,
			p.prev_pitch_2,
            p.prev_pitch_speed,
            p.prev_pitch_2_speed,
            p.prev_pitch_spin_rate,
            p.prev_pitch_2_spin_rate
from 	pitch_with_count p 
join 	game g 
	on	p.gameID = g.gameID 
    and g.type = 'R'
join 	atBat ab 
	on	ab.gameID = p.gameID 
	and ab.atBatNum = p.atBatNum 
join 	adv_pitching_stats_year apsy 
	on 	apsy.playerID = ab.pitcher
    and apsy.record_year = substr(ab.gameID,1,4)
join	pitchTypeRef ptr
	on	ptr.pitchType = p.pitch_type
join	pitch_frequency_year pfy
	on	pfy.playerID = ab.pitcher
    and	pfy.record_year = substr(ab.gameID,1,4)
join	adv_batting_stats_year absy
	on	absy.playerID = ab.batter
    and	absy.record_year = substr(ab.gameID,1,4)
join	player_game pg
	ON	pg.gameID = g.gameID
	AND	(
		(ab.topBottom = 'top' AND pg.teamType = 'home') 
			OR (ab.topBottom='bottom' AND pg.teamType = 'away')
		)
    AND pg.game_position = 'C'
join	catcher_stats_year cs
	ON	pg.playerID = cs.catcher_id
    AND substr(ab.gameID,1,4) = cs.record_year
order by	g.gameID,ab.atBatNum,p.pitchID);
