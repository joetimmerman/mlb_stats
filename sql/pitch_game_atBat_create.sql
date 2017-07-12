DROP VIEW IF EXISTS pitch_game_atBat;

CREATE VIEW pitch_game_atBat AS
(select 	g.gameID 					AS gameID,
			ab.event_num 				AS event_num,
			ab.inningNum 				AS inningNum,
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
            ifnull(apsy.outs,0) 				AS outs 
from 		pitch p 
join 		game g 
	on		p.gameID = g.gameID 
    and 	g.type = 'R'
join 		atBat ab 
	on		ab.gameID = p.gameID 
	and 	ab.atBatNum = p.atBatNum 
    and 	ab.event not like '%Interference%' 
    and 	ab.event not like '%Error%' 
    and 	ab.event not like '%Sac%' 
    and 	ab.event <> 'Hit By Pitch' 
    and 	ab.event <> 'Intent Walk' 
left join 	adv_pitching_stats_year apsy 
	on 		apsy.playerID = ab.pitcher
    and 	apsy.record_year = substr(ab.gameID,1,4)
left join	pitchTypeRef ptr
	on		ptr.pitchType = p.pitch_type
order by 	g.gameID,ab.atBatNum,p.pitchID);
