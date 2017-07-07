SELECT 	tg.code 	team_code,
		tg.file_code,
        tg.abbrev,
        tg.teamID,
        tg.name,
        tg.name_full,
        tg.name_brief,
        tg.division_id,
        tg.league_id,
        tg.league
FROM	team_game tg
GROUP BY	tg.teamID;
