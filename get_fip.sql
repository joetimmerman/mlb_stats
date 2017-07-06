SELECT	f1.playerID,
		f1.record_year,
        (13*f1.home_runs + 3*(f1.hit_by_pitch+f1.walks) - 2*f1.strikeouts)/(f1.outs/3) fip
FROM	(SELECT	pg.playerID,
				substring(g.gameID,1,4) record_year,
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
						WHEN 	UPPER(ab.event) LIKE '%OUT%' 
								OR UPPER(ab.event) LIKE '%DOUBLE PLAY%' 
								OR UPPER(ab.event) LIKE '%TRIPLE PLAY%' 
								OR UPPER(ab.event) LIKE '%DP%'
							THEN 1
						ELSE 0
					END) outs
		FROM	game g
		JOIN	player_game pg
			ON	pg.gameID = g.gameID 
			AND g.type = 'R' 
			AND	pg.game_position = 'P'
		JOIN	atBat ab
			ON	ab.gameID = g.gameID
			AND	ab.pitcher = pg.playerID
		GROUP BY pg.playerID, substring(g.gameID,1,4)) f1;