SELECT	pg1.playerID,
		pg1.first_name,
        pg1.last_name,
        pg1.rl_throws,
        pg1.rl_bats,
        pg1.position
FROM	(SELECT pg.playerID,
				pg.first		first_name,
				pg.last			last_name,
				pg.rl			rl_throws,
				pg.bats			rl_bats,
				pg.position,
				count(1)		position_count
		FROM	player_game pg
		GROUP BY	pg.playerID,
					pg.position
		ORDER BY	pg.playerID,
					count(1) desc) pg1
GROUP BY	pg1.playerID;
