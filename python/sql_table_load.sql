import csv
import pymysql
import sys
import mlbStats
import sys

sqlDir = 'C:\\Users\\evan.marcey\\Documents\\GitHub\\mlb_stats\\sql\\'
passFile = 'C:\\Users\\evan.marcey\\Documents\\mlb_stats\\pass.csv'

sqlFiles = [
	'adv_pitching_stats_year.sql',
	'adv_pitching_stats_month.sql',
	'adv_batting_stats_year.sql',
	'adv_batting_stats_month.sql',
	'players.sql'
]

aws_username = ''
aws_password = ''


with open(passFile,'r') as pf:
	pfr = csv.reader(pf)
	for row in pfr:
		if row[0] == 'username':
			aws_username = row[1]
		elif row[0] == 'pass':
			aws_password = row[1]
			
try:
	print('Opening connection...')
	connection = pymysql.connect(host='baseball.cfelhfqsawiy.us-east-1.rds.amazonaws.com',
								port=3306,
								user=aws_username,
								db='mlb_data_test',
								password=aws_password,
								charset='utf8mb4',
								cursorclass=pymysql.cursors.DictCursor)
	conn = connection.cursor()
	print('Connected.\n')
		
	for sqlFile in sqlFiles:
		try:
			print('Processing {tn}'.format(tn=sqlFile))
			print('\tReading {tn}...'.format(tn=sqlFile))
			tableName = sqlFile.replace('.sql','')
		
			with open(sqlDir+sqlFile,'r') as sqlf:
				readSQL = sqlf.read()
				conn.execute(readSQL)
				queryResult = conn.fetchall()
			
			print('\tPreparing {tn}...'.format(tn=sqlFile))
			preppedQuery = []
			for record in queryResult:
				preppedQuery.append(mlbStats.prepArray(tableName, record))
			
			print('\tTruncating {tn}...'.format(tn=sqlFile))
			deleteScript = 'TRUNCATE TABLE {tn}'.format(tn=tableName)
			conn.execute(deleteScript)
			connection.commit()
			
			print(len(preppedQuery))
			print(tableName)
			print(mlbStats.getColumns(tableName))
			
			print('\tInserting records into {tn}...'.format(tn=sqlFile))
			mlbStats.insertRecords(tableName,preppedQuery,mlbStats.getColumns(tableName))
			
			conn.execute('SELECT COUNT(1) FROM {tn}'.format(tn=tableName))
			print(conn.fetchall())
			print('{tn} Complete.\n'.format(tn=sqlFile))
		except FileNotFoundError as err:
			print(sqlFile + ' Not Found In ' + sqlDir + '.')
		except:
			print('Unhandled file error:')
			print(sys.exc_info())
			
	connection.close()

except pymysql.err.OperationalError as err:
	print('Unable to connect to server.')
except:
	print('Unhandled connection error:')
	print(sys.exc_info())
