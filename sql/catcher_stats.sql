CREATE OR REPLACE VIEW wp_pb AS
(SELECT	bbx.id catcher_id,
		substring(a.gameID,1,4) record_year,
		count(distinct a.gameID) num_games,
		SUM(CASE
				WHEN event = 'Wild Pitch'
					THEN 1
				ELSE 0
			END) wp_count,
		SUM(CASE
				WHEN event = 'Passed Ball'
					THEN 1
				ELSE 0
			END) pb_count,
		SUM(CASE
				WHEN lower(a.event) like '%stolen base%'
					THEN 1
				ELSE 0
			END) stolen_bases,
		SUM(CASE
				WHEN lower(a.event) like '%caught stealing%'
					THEN 1
				ELSE 0
			END) caught_stealing
FROM	action a
JOIN	game g
	ON	g.gameID = a.gameID
	AND g.type = 'R'
	AND	a.event_num < (SELECT 	IFNULL(min(a1.event_num),10000) event_num
						FROM	action a1
						WHERE	a1.event ='Defensive Sub'
							AND	a1.des like '%catcher%'
							AND a1.gameID = a.gameID)
JOIN	batter_box bbx
	ON	bbx.game_id = a.gameID
	AND bbx.pos = 'C'
GROUP BY	bbx.id,
			substring(a.gameID,1,4));
                    
CREATE OR REPLACE VIEW catcher_temp AS
(SELECT	bbx.id catcher_id,
				substring(ab.gameID,1,4) 	record_year,
				count(1) 					num_pitches,
				SUM(CASE 
						WHEN p.zone > 9 and p.des = 'Called Strike' 
							THEN 1 
						ELSE 0 
					END) 					strikes_out_of_zone,
				SUM(CASE 
						WHEN p.zone <= 9 and p.des = 'Called Strike' 
							THEN 1 
						ELSE 0 
					END) 					strikes_in_zone,
				SUM(CASE 
						WHEN p.zone > 9 and p.des = 'Ball' 
							THEN 1 
						ELSE 0 
					END) 					balls_out_of_zone,
				SUM(CASE 
						WHEN p.zone <= 9 and p.des = 'Ball' 
							THEN 1 
						ELSE 0 
					END) 					balls_in_zone,
				SUM(CASE
						WHEN pitchType in ('KC','KN')
							THEN 1
						ELSE 0
					END) knuckle_ct,
				SUM(CASE
						WHEN pitchGroup = 'Fastball'
							THEN 1
						ELSE 0
					END) fb_ct,
				SUM(CASE
						WHEN pitchGroup = 'Breaking Ball'
							THEN 1
						ELSE 0
					END) breaking_ct,
				SUM(CASE
						WHEN pitchGroup = 'Changeup'
							THEN 1
						ELSE 0
					END) changeup_ct
		FROM	game g
		JOIN	atBat ab
			ON	ab.gameID = g.gameID
			AND g.type = 'R'
			AND	ab.event not in ('Intent Walk','Automatic Walk')
			AND ab.event not like '%Interference%'
			AND ab.event not like '%Error%'
			AND	ab.event_num < (SELECT 	IFNULL(min(a.event_num),10000) event_num
								FROM	action a
								WHERE	a.event ='Defensive Sub'
									AND	a.des like '%catcher%'
									AND a.gameID = ab.gameID)
		JOIN	pitch p
			ON	p.gameID = ab.gameID
			AND	p.atBatNum = ab.atBatNum
		JOIN	pitchTypeRef ptr
			ON	ptr.pitchType = p.pitch_type
		JOIN	batter_box bbx
			ON	bbx.game_id = p.gameID
			AND bbx.pos = 'C'
			AND (bbx.home_away = 'home' AND ab.topBottom = 'top')
				OR (bbx.home_away = 'away' AND ab.topBottom = 'bottom')
		GROUP BY	bbx.id,
					substring(ab.gameID,1,4));

CREATE OR REPLACE VIEW catcher_stats AS
(SELECT	m1.catcher_id,
		m1.record_year,
        m1.num_pitches,
        m1.strikes_out_of_zone,
        m1.strikes_in_zone,
        m1.balls_out_of_zone,
        m1.balls_in_zone,
        round(m1.strikes_out_of_zone/(m1.strikes_out_of_zone+m1.balls_out_of_zone),3) strikes_rate_out_of_zone,
        round(m1.balls_in_zone/(m1.balls_in_zone+m1.strikes_out_of_zone),3) ball_rate_in_zone,
        round(m1.knuckle_ct/m1.num_pitches,3) knuckle_rate,
        round(m1.fb_ct/m1.num_pitches,3) fb_rate,
        round(m1.breaking_ct/m1.num_pitches,3) breaking_rate,
        round(m1.changeup_ct/m1.num_pitches,3) changeup_rate,
        wp_pb.wp_count,
        wp_pb.pb_count,
        wp_pb.stolen_bases,
        wp_pb.caught_stealing,
        round(wp_pb.wp_count/wp_pb.num_games,3) wp_per_game,
        round(wp_pb.pb_count/wp_pb.num_games,3) pb_per_game,
        round(wp_pb.stolen_bases/(wp_pb.stolen_bases+wp_pb.caught_stealing),3) cs_over_attempts
FROM	catcher_temp m1
JOIN	wp_pb
	ON	wp_pb.catcher_id = m1.catcher_id
    AND	wp_pb.record_year = m1.record_year
    AND wp_pb.num_games > 10);