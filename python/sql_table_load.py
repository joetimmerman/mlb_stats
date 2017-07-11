import csv
import pymysql
import sys
import mlbStats
import sys
import mlbStats

pymysql.pooling = False

sqlDir = 'C:\\Users\\evan.marcey\\Documents\\GitHub\\mlb_stats\\sql\\'

sqlFiles = [
	'adv_pitching_stats_year.sql',
	'adv_pitching_stats_month.sql',
	'adv_batting_stats_year.sql',
	'adv_batting_stats_month.sql',
	'player.sql',
	'team.sql'
]
	
for sqlFile in sqlFiles:
	try:
		connection, conn = mlbStats.openConnection()
		
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
