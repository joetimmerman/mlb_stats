import csv
import pymysql
import pymysql.cursors
import sys
import mlbStats

mlbData = 'C:\\Users\\evan.marcey\\Documents\\GitHub\\mlb_stats\\data\\'
	
tables = [
	'game',
	'umpire_game',
	'pitch',
	'pickoff',
	'atBat',
	'coach_game',
	'player_game',
	'stadium_game',
	'runner',
	'action',
	'boxscore',
	'batter_box',
	'pitcher_box',
	'linescore',
	'linescore_inning',
	'leverage',
	'park_factors',
	'team_game',
	'adv_batting_stats_month',
	'adv_batting_stats_year',
	'adv_pitching_stats_month',
	'adv_pitching_stats_year',
	'player',
	'team'
]

def fetchAndWrite(table, conn):
	print('Starting: ' + table)
	table_get = 'SELECT * FROM {tn};'.format(tn=table)
	try:
		conn.execute(table_get);
		data = conn.fetchall();	
		outFile = mlbData + table + '.csv'
			
		with open(outFile,'w') as write_out:
			out_writer = csv.writer(write_out,
										lineterminator='\n',
										quotechar='"'
									   )
			out_writer.writerow(data[0].keys())
			
			for record in data:
				out_writer.writerow(record.values())
		
		print('Finished: ' + table)
	except pymysql.err.ProgrammingError as err:
		print(table + ' does not exist')
	except pymysql.err.OperationalError as err:
		print('Unable to connect to server')
	except:
		print('Unhandled table error.')
		
def export():
	try:
		connection,conn = mlbStats.openConnection()
		
		if len(sys.argv) == 1:
			for table in tables:
				fetchAndWrite(table, conn)
		else:
			fetchAndWrite(sys.argv[1], conn)		

	except pymysql.err.OperationalError as err:
		print('Unable to connect to server.')
	except:
		print('Unhandled connection error.')
		
export()
