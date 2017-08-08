import csv
import pymysql
import pymysql.cursors
import sys
import mlbStats

mlbData = 'C:\\Users\\evan.marcey\\Documents\\GitHub\\mlb_stats\\data\\'

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
			conn.execute("SHOW TABLES;")
			tables = conn.fetchall()
			for table in tables:
				fetchAndWrite(table['Tables_in_mlb_data_test'], conn)
		else:
			
			fetchAndWrite(sys.argv[1], conn)		

	except pymysql.err.OperationalError as err:
		print('Unable to connect to server.')
	except:
		print('Unhandled connection error.')
		
export()
