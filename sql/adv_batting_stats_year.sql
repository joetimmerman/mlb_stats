SELECT	ab1.playerID,
		ab1.record_year,
        ab1.pa,
        ab1.home_runs,
        bbx1.runs,
        ab1.rbis,
        ab1.home_runs + ab1.singles + ab1.doubles + ab1.triples hits,
        ab1.bb + ab1.ibb walks,
		ab1.pa-ab1.bb-ab1.ibb-ab1.sac-ab1.hbp-ab1.interference at_bats,
		ab1.so,
        ab1.fly_balls,
        ab1.pop_outs,
        ab1.ground_balls,
		ab1.hbp,
		ab1.sac,
        sb1.sb,
        sb1.cs,
        ROUND(sb1.sb/(sb1.sb/sb1.cs),3) stolen_base_success_rate,
        ROUND((ab1.home_runs+ab1.singles+ab1.doubles+ab1.triples)/(ab1.pa-ab1.bb-ab1.ibb-ab1.sac-ab1.hbp-ab1.interference),3) batting_average,
        ROUND((ab1.home_runs+ab1.singles+ab1.doubles+ab1.triples+ab1.ibb+ab1.bb+ab1.hbp)/ab1.pa,3) OBP,
        ROUND((4*ab1.home_runs+ab1.singles+2*ab1.doubles+3*ab1.triples)/(ab1.pa-ab1.bb-ab1.ibb-ab1.sac-ab1.hbp-ab1.interference),3) SLG,
        ROUND((4*ab1.home_runs+ab1.singles+2*ab1.doubles+3*ab1.triples)/(ab1.pa-ab1.bb-ab1.ibb-ab1.sac-ab1.hbp-ab1.interference) +
			(ab1.home_runs+ab1.singles+ab1.doubles+ab1.triples+ab1.ibb+ab1.bb+ab1.hbp)/ab1.pa,3) OPS,
		ROUND((4*ab1.home_runs+ab1.singles+2*ab1.doubles+3*ab1.triples)/(ab1.pa-ab1.bb-ab1.ibb-ab1.sac-ab1.hbp-ab1.interference) -
			(ab1.home_runs+ab1.singles+ab1.doubles+ab1.triples)/(ab1.pa-ab1.bb-ab1.ibb-ab1.sac-ab1.hbp-ab1.interference),3) ISO,
		ROUND((ab1.singles+ab1.doubles+ab1.triples)/(ab1.pa-ab1.bb-ab1.ibb-ab1.hbp-ab1.interference-ab1.so-ab1.home_runs),3) BABIP,        
        ROUND(ab1.bb/ab1.pa,2) bb_rate,
        ROUND(ab1.so/ab1.pa,2) so_rate,
        sr.swing_rate,
        sr.pitches_per_at_bat,
        sr.foul_rate
FROM	(SELECT pg.playerID,
				substr(g.gameID,1,4) record_year,
				COUNT(ab.atBatNum) pa,
				SUM(CASE 
						WHEN ab.event = 'Home Run' 
							THEN 1 
						ELSE 0
					END) home_runs,
				ROUND(SUM(pg.rbi)/COUNT(distinct pg.gameID),0) rbis,
				SUM(CASE
						WHEN ab.event = 'Single'
							THEN 1
						ELSE 0
					END) singles,
				SUM(CASE
						WHEN ab.event = 'Double'
							THEN 1
						ELSE 0
					END) doubles,
				SUM(CASE
						WHEN ab.event = 'Triple'
							THEN 1
						ELSE 0
					END) triples,
				SUM(CASE
						WHEN ab.event = 'Walk'
							THEN 1
						ELSE 0
					END) bb,
				SUM(CASE
						WHEN ab.event = 'Hit By Pitch'
							THEN 1
						ELSE 0
					END) hbp,
				SUM(CASE
						WHEN ab.event = 'Intent Walk'
							THEN 1
						ELSE 0
					END) ibb,
				SUM(CASE
						WHEN ab.event like '%Strikeout%'
							THEN 1
						ELSE 0
					END) so,
				SUM(CASE
						WHEN UPPER(ab.event) like '%SAC%'
							THEN 1
						ELSE 0
					END) sac,
				SUM(CASE
						WHEN UPPER(ab.event) like '%FLY%'
							THEN 1
						ELSE 0
					END) fly_balls,
				SUM(CASE
						WHEN UPPER(ab.event) like '%POP%'
							THEN 1
						ELSE 0
					END) pop_outs,
				SUM(CASE
						WHEN UPPER(ab.event) like '%GROUND%'
							THEN 1
						ELSE 0
					END) ground_balls,
				SUM(CASE
						WHEN UPPER(ab.event) like '%ERROR%'
							THEN 1
						ELSE 0
					END) err,
				SUM(CASE
						WHEN UPPER(ab.event) like '%INTERFERENCE%'
							THEN 1
						ELSE 0
					END) interference
		FROM	game g
		JOIN	player_game pg
			ON	g.gameID = pg.gameID
			AND g.type = 'R'
		JOIN	atBat ab
			ON	g.gameID = ab.gameID
			AND	pg.playerID = ab.batter
		GROUP BY 	pg.playerID,
					substring(g.gameID,1,4)) ab1
JOIN	(SELECT	r.playerID,
				substring(g.gameID,1,4) record_year,
				SUM(CASE 
						WHEN r.event like 'Stolen Base%'
							THEN 1
						ELSE 0
					END) sb,
				SUM(CASE
						WHEN 	r.event like 'Caught Stealing%'
							OR	r.event like 'Picked off%'
							THEN 1
						ELSE 0
					END) cs
		FROM	game g
		JOIN	runner r
			ON	g.gameID = r.gameID
			AND	g.type = 'R'
		GROUP BY	r.playerID,
					substring(g.gameID,1,4)) sb1
	ON	ab1.playerID = sb1.playerID
    AND	ab1.record_year = sb1.record_year
JOIN 	(SELECT	bbx.id playerID,
				substring(g.gameID,1,4) record_year,
				SUM(r)	runs
		FROM	game g
		JOIN	batter_box bbx
			ON	g.gameID = bbx.game_id
			AND	g.type = 'R'
		GROUP BY	bbx.id,
					substring(g.gameID,1,4)) bbx1
	ON	bbx1.playerID = sb1.playerID
    AND	bbx1.record_year = sb1.record_year
JOIN	(SELECT	ab.batter,
				substr(ab.gameID,1,4) record_year,
				ROUND(SUM(CASE 
						WHEN p.des = 'Swinging Strike' OR lower(p.des) like '%foul%' OR lower(p.des) like '%in%play%'
							THEN 1 
						ELSE 0
					END)/count(1),3) swing_rate,
				round(count(1)/count(distinct ab.gameID, ab.atBatNum),3) pitches_per_at_bat,
                ROUND(SUM(CASE
							WHEN lower(p.des) like '%foul%'
								THEN 1
							ELSE 0
						END)/
                        SUM(CASE
							WHEN loweR(p.des) like '%in%play%'
								THEN 1
							ELSE 0
						END),3) foul_rate
		FROM 	atBat ab
		JOIN	game g
			ON	g.gameID = ab.gameID
			AND	g.type = 'R'
		JOIN	pitch p
			ON	p.gameID = ab.gameID
			AND	p.atBatNum = ab.atBatNum
		group by 	ab.batter,
					substr(ab.gameID,1,4)) sr
	ON	sr.record_year = ab1.record_year
    AND	sr.batter = ab1.playerID;
