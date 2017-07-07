import csv
import pymysql
import sys
import mlbStats
import sys

pymysql.pooling = False

sqlDir = 'C:\\Users\\evan.marcey\\Documents\\GitHub\\mlb_stats\\sql\\'
passFile = 'C:\\Users\\evan.marcey\\Documents\\mlb_stats\\pass.csv'

sqlFiles = [
	'adv_pitching_stats_year.sql',
	'adv_pitching_stats_month.sql',
	'adv_batting_stats_year.sql',
	'adv_batting_stats_month.sql',
	'players.sql'
]

def openConnection():
	aws_username = ''
	aws_password = ''
	connection = ''
	conn = ''
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
	except pymysql.err.OperationalError as err:
		print('Unable to connect to server.')
	except:
		print('Unhandled connection error:')
		print(sys.exc_info())
		
	return(connection,conn)
		
for sqlFile in sqlFiles:
	try:
		connection, conn = openConnection()
		
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
		deleteScript = 'DELETE FROM {tn} WHERE 1=1;'.format(tn=tableName)
		conn.execute(deleteScript)
		connection.commit()
		connection.close()
		
		connection,conn = openConnection()
			
		print('\tInserting records into {tn}...'.format(tn=sqlFile))
		mlbStats.insertRecords(tableName,preppedQuery,mlbStats.getColumns(tableName))
			
		conn.execute('SELECT COUNT(1) FROM {tn}'.format(tn=tableName))
		print('\t' + str(conn.fetchall()[0].values()) + ' records loaded.')
			
		connection.commit()
		connection.close()	
			
		print('{tn} Complete.\n'.format(tn=sqlFile))
	except FileNotFoundError as err:
		print(sqlFile + ' Not Found In ' + sqlDir + '.')
	except:
		print('Unhandled file error:')
		print(sys.exc_info())
