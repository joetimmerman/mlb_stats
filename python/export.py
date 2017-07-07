import csv
import pymysql
import pymysql.cursors
import sys

mlbData = 'C:\\Users\\evan.marcey\\Documents\\GitHub\\mlb_stats\\data\\'
passFile = 'C:\\Users\\evan.marcey\\Documents\\mlb_stats\\pass.csv'

aws_username = ''
aws_password = ''

with open(passFile,'r') as pf:
	pfr = csv.reader(pf)
	for row in pfr:
		if row[0] == 'username':
			aws_username = row[1]
		elif row[0] == 'pass':
			aws_password = row[1]
	
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
	'player'
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
		connection = pymysql.connect(host='baseball.cfelhfqsawiy.us-east-1.rds.amazonaws.com',
									 port=3306,
									 user=aws_username,
									 db='mlb_data_test',
									 password=aws_password,
									 charset='utf8mb4',
									 cursorclass=pymysql.cursors.DictCursor)
		conn = connection.cursor()
		
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
