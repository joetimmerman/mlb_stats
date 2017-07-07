SELECT	f1.playerID,
		f1.record_month,
		ROUND((13*f1.home_runs + 3*(f1.hit_by_pitch+f1.walks) - 2*f1.strikeouts)/(f1.outs/3) + cf.cFip,3) fip,
        ROUND((f1.walks+f1.hits)/(f1.outs/3),3) whip,
        ROUND((f1.hits-f1.home_runs)/(f1.outs+f1.hits+f1.sac-f1.strikeouts-f1.home_runs),3) babip,
        ROUND(((13*f1.fly_balls*(cf.home_runs/cf.fly_balls)) + 3*(f1.walks+f1.hit_by_pitch) - 2*f1.strikeouts)/(f1.outs/3) + cf.cFip,3) xFip,
        f1.strikeouts/(f1.out_atBats+f1.hits+f1.walks+f1.hit_by_pitch+f1.sac) strikeout_rate,
        f1.walks/(f1.out_atBats+f1.hits+f1.walks+f1.hit_by_pitch+f1.sac) walk_rate,
        f1.home_runs/f1.fly_balls*100 hr_to_fly_ball_rate,
        f1.games_played,
        f1.outs+f1.hits at_bats,
        f1.home_runs,
        f1.hits,
        f1.walks,
        f1.hit_by_pitch,
        f1.strikeouts,
        f1.outs,
        f1.sac,
        f1.fly_balls,
        f1.ground_balls,
        f1.pop_ups,
        ROUND(6.145 - 
			16.986*(f1.strikeouts/(f1.hits+f1.out_atBats+f1.walks+f1.hit_by_pitch+f1.sac)) +
            11.434*(f1.walks/(f1.hits+f1.out_atBats+f1.walks+f1.hit_by_pitch+f1.sac)) -
            1.858*((f1.ground_balls-f1.fly_balls-f1.pop_ups)/(f1.hits+f1.out_atBats+f1.walks+f1.hit_by_pitch+f1.sac)) +
            7.653*POW((f1.strikeouts/(f1.hits+f1.out_atBats+f1.walks+f1.hit_by_pitch+f1.sac)),2) -
            ABS(6.664*POW(((f1.ground_balls-f1.fly_balls-f1.pop_ups)/(f1.hits+f1.out_atBats+f1.walks+f1.hit_by_pitch+f1.sac)),2)) +
            10.130*(f1.strikeouts/(f1.hits+f1.out_atBats+f1.walks+f1.hit_by_pitch+f1.sac))*((f1.ground_balls-f1.fly_balls-f1.pop_ups)/(f1.hits+f1.out_atBats+f1.walks+f1.hit_by_pitch+f1.sac)) -
            5.195*(f1.walks/(f1.hits+f1.out_atBats+f1.walks+f1.hit_by_pitch+f1.sac))*((f1.ground_balls-f1.fly_balls-f1.pop_ups)/(f1.hits+f1.out_atBats+f1.walks+f1.hit_by_pitch+f1.sac)),3)
		SIERA,
        ROUND(cf.cFip,3) cFip
FROM	(SELECT	pg.playerID,
				substring(g.gameID,1,7) record_month,
                count(distinct g.gameID) games_played,
				SUM(CASE 
						WHEN ab.event = 'Home Run' 
							THEN 1 
						ELSE 0 
					END) home_runs,
				SUM(CASE
						WHEN ab.event = 'Walk'
							THEN 1
						ELSE 0
					END) walks,
				SUM(CASE
						WHEN ab.event = 'Hit By Pitch'
							THEN 1
						ELSE 0
					END) hit_by_pitch,
				SUM(CASE
						WHEN ab.event IN ('Strikeout','Strikeout - DP')
							THEN 1
						ELSE 0
					END) strikeouts,
				SUM(CASE
						WHEN UPPER(ab.event) LIKE '%FLY%'
							THEN 1
						ELSE 0
					END) fly_balls,
				SUM(CASE
						WHEN 	UPPER(ab.event) LIKE '%OUT%' 
							OR UPPER(ab.event) LIKE '%SAC%'
							THEN 1
						WHEN	UPPER(ab.event) LIKE '%DOUBLE PLAY%' 
							OR UPPER(ab.event) LIKE '%DP%'
							THEN 2
						WHEN	UPPER(ab.event) LIKE '%TRIPLE PLAY%' 
							THEN 3
						ELSE 0
					END) outs,
				SUM(CASE WHEN	UPPER(ab.event) LIKE '%OUT%'
							OR	UPPER(ab.event) LIKE '%SAC%'
                            OR	UPPER(ab.event) LIKE '%DOUBLE PLAY%'
                            OR 	UPPER(ab.event) LIKE '%DP%'
                            OR	UPPER(ab.event) LIKE '%TRIPLE PLAY%' 
							THEN 1
						ELSE 0
					END) out_atbats,
				SUM(CASE
						WHEN ab.event IN ('Single','Double','Triple','Home Run')
							THEN 1
						ELSE 0
					END) hits,
				SUM(CASE
						WHEN upper(ab.event) LIKE '%SAC%'
							THEN 1
						ELSE 0
					END) sac,
				SUM(CASE
						WHEN upper(ab.event) LIKE '%GROUND%'
							THEN 1
						ELSE 0
					END) ground_balls,
				SUM(CASE
						WHEN upper(ab.event) LIKE '%POP%'
							THEN 1
						ELSE 0
					END) pop_ups
		FROM	game g
		JOIN	player_game pg
			ON	pg.gameID = g.gameID 
			AND g.type = 'R' 
			AND	pg.game_position = 'P'
		JOIN	atBat ab
			ON	ab.gameID = g.gameID
			AND	ab.pitcher = pg.playerID
		GROUP BY pg.playerID, substring(g.gameID,1,7)) f1
JOIN	(SELECT	substring(g.gameID,1,7) record_month,
				sum(pb.so) 				strikeouts,
				sum(pb.hr) 				home_runs,
				sum(pb.er) 				earned_runs,
				sum(pb.out)				outs,
				sum(pb.bb)				walks,
				hbp.hit_by_pitch		hit_by_pitch,
                hbp.fly_balls,
				(sum(pb.er)/(sum(pb.out)/3)*9) -
					(13*sum(pb.hr) + 3*(sum(pb.bb)+hbp.hit_by_pitch) - 2*sum(pb.so))/(sum(pb.out)/3) cFip
		FROM 	game g
		JOIN	pitcher_box pb
			ON	g.type = 'R'
			AND	g.gameID = pb.game_ID
		JOIN	(SELECT	substring(g.gameID,1,7) record_month,
						SUM(CASE 
								WHEN ab.event = 'Hit By Pitch' 
									THEN 1 
								ELSE 0
							END) hit_by_pitch,
						SUM(CASE
								WHEN UPPER(ab.event) LIKE '%FLY%'
									THEN 1
								ELSE 0
							END) fly_balls
				FROM	game g
				JOIN	atBat ab
					ON	ab.gameID = g.gameID
					AND	g.type = 'R'
				GROUP BY substring(g.gameID,1,7)) hbp
			ON	hbp.record_month = substring(g.gameID,1,7)
		GROUP BY substring(g.gameID,1,7)) cf
	ON	cf.record_month = f1.record_month;
