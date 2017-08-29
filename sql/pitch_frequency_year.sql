SELECT	ab.pitcher playerID,
		substring(g.gameID,1,4) record_year,
        COUNT(1) total_pitches,
        SUM(CASE
				WHEN p.pitch_type = 'CU'
					THEN 1
				ELSE 0
			END)/COUNT(1) curveball_freq,
		SUM(CASE
				WHEN p.pitch_type = 'CH'
					THEN 1
				ELSE 0
			END)/COUNT(1) changeup_freq,
		SUM(CASE
				WHEN p.pitch_type = 'EP'
					THEN 1
				ELSE 0
			END)/COUNT(1) eephus_freq,
		SUM(CASE
				WHEN p.pitch_type = 'FC'
					THEN 1
				ELSE 0
			END)/COUNT(1) cutter_freq,
		SUM(CASE
				WHEN p.pitch_type = 'FF'
					THEN 1
				ELSE 0
			END)/COUNT(1) four_seam_freq,
        SUM(CASE
				WHEN p.pitch_type = 'FO'
					THEN 1
				ELSE 0
			END)/COUNT(1) forkball_freq,   
		SUM(CASE
				WHEN p.pitch_type = 'FS'
					THEN 1
				ELSE 0
			END)/COUNT(1) splitter_freq,
		SUM(CASE
				WHEN p.pitch_type = 'FT'
					THEN 1
				ELSE 0
			END)/COUNT(1) two_seam_freq,
		SUM(CASE
				WHEN p.pitch_type = 'KC'
					THEN 1
				ELSE 0
			END)/COUNT(1) knuckle_curve_freq,
		SUM(CASE
				WHEN p.pitch_type = 'KN'
					THEN 1
				ELSE 0
			END)/COUNT(1) knuckleball_freq,
		SUM(CASE
				WHEN p.pitch_type = 'SC'
					THEN 1
				ELSE 0
			END)/COUNT(1) screwball_freq,
		SUM(CASE
				WHEN p.pitch_type = 'SI'
					THEN 1
				ELSE 0
			END)/COUNT(1) sinker_freq,
		SUM(CASE
				WHEN p.pitch_type = 'SL'
					THEN 1
				ELSE 0
			END)/COUNT(1) slider_freq
FROM	pitch p
JOIN	game g
	ON	g.gameID = p.gameID
	AND	g.type = 'R'
JOIN	atBat ab
	ON	ab.gameID = p.gameID
    AND	ab.atBatNum = p.atBatNum
	AND	ab.event not like '%Interference%' 
    AND ab.event not like '%Error%' 
    AND	ab.event not like '%Sac%' 
    AND	ab.event <> 'Hit By Pitch' 
    AND	ab.event <> 'Intent Walk'
JOIN	pitchTypeRef ptr
	ON	ptr.pitchType = p.pitch_type
    AND ptr.pitchType != 'FA'
GROUP BY	ab.pitcher,
			substring(g.gameID,1,4)
