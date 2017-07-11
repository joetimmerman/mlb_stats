import csv
import pymysql
import pymysql.cursors
import sys
import numpy as np
import pandas as pd
from scipy.stats.stats import pearsonr
import time
from itertools import groupby

mlbData = 'C:\\Users\\evan.marcey\\Documents\\GitHub\\mlb_stats\\data\\'
mlbSql = 'C:\\Users\\evan.marcey\\Documents\\GitHub\\mlb_stats\\sql\\'
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
	
def getSQL(query_file):
	st = time.time()
	connection,conn = openConnection()
	with open(query_file,'r') as qf:
		query = qf.read()
	print('Fetching SQL query for {fn}...'.format(fn=query_file))
	conn.execute(query)
	query_result = conn.fetchall()
	print('Query fetched.')
	et = time.time()
	print('Query ran in {ti} seconds.\n'.format(ti=round(et-st)))
	return(query_result)
	
pitchFile = 'pitch_game_atBat.sql'
abFile = 'some_atbats.sql'
playerFile = 'getPlayers.sql'

pitchArray = getSQL(mlbSql+pitchFile)
#atBatArray = getSQL(mlbSql+abFile)
#playerArray = getSQL(mlbSql+playerFile)

rSwing = []
rNoSwing = []
allAtBats = []
threeZeroArray = []

corList = [
	['FIP', [],[]],
	['WHIP', [],[]],
	['xFIP', [],[]],
	['SIERA', [],[]],
	['strikeout_rate', [],[]],
	['walk_rate', [],[]],
	['hr_to_fly_ball_rate', [],[]]
]

st = time.time()
print('Finding 3-0 counts...')
for i in range(4,len(pitchArray)):
	pitchArray[i]['is_three_zero_count'] = 0
	
	if pitchArray[i]['des'] == 'Ball' or pitchArray[i]['des'] == 'Called Strike':
		pitchArray[i]['swing'] = 1
	else:
		pitchArray[i]['swing'] = 0

	if pitchArray[i]['event'] == 'Walk' or pitchArray[i]['event'] == 'Single':
		pitchArray[i]['num_bases'] = 1
	elif pitchArray[i]['event'] == 'Double':
		pitchArray[i]['num_bases'] = 2
	elif pitchArray[i]['event'] == 'Triple':
		pitchArray[i]['num_bases'] = 3
	elif pitchArray[i]['event'] == 'Home Run':
		pitchArray[i]['num_bases'] = 4
	else:
		pitchArray[i]['num_bases'] = 0
		
	if pitchArray[i]['gameID'] == pitchArray[i-1]['gameID'] and\
	pitchArray[i]['atBatNum'] == pitchArray[i-1]['atBatNum'] and\
	pitchArray[i-1]['des'] == 'Ball':
		if pitchArray[i]['gameID'] == pitchArray[i-2]['gameID'] and\
		pitchArray[i]['atBatNum'] == pitchArray[i-2]['atBatNum'] and\
		pitchArray[i-2]['des'] == 'Ball':
			if pitchArray[i]['gameID'] == pitchArray[i-3]['gameID'] and\
			pitchArray[i]['atBatNum'] == pitchArray[i-3]['atBatNum'] and\
			pitchArray[i-3]['des'] == 'Ball':
				if not (pitchArray[i]['gameID'] == pitchArray[i-4]['gameID'] and \
				pitchArray[i]['atBatNum'] == pitchArray[i-4]['atBatNum']):
					
					pitchArray[i]['is_three_zero_count'] = 1
					threeZeroArray.append(pitchArray[i])
					if pitchArray[i]['swing'] == 1:
						rSwing.append(pitchArray[i]['num_bases'])
					else:
						rNoSwing.append(pitchArray[i]['num_bases'])
							
et = time.time()
print('3-0 counts found in {ti} seconds.\n'.format(ti=round(et-st)))

pitchDF = pd.DataFrame(data=[pitchArray[i].values() for i in range(4,len(pitchArray))],columns=pitchArray[5].keys())

print('Grouping by at bat...')
st = time.time()
atBatDF = pitchDF.groupby(['gameID','atBatNum','event','num_bases'])\
			['is_three_zero_count'].max()
			
for index, row in atBatDF.iteritems():
	allAtBats.append(index[3])

et = time.time()
print('At bats grouped in {ti} seconds.\n'.format(ti=round(et-st)))
	
st = time.time()
print('Grouping by pitchers...')
pitcherDF = pitchDF.groupby(['pitcher','record_year','p_throws','FIP','WHIP','xFIP','SIERA','strikeout_rate','walk_rate','hr_to_fly_ball_rate','outs']).\
			agg({'is_three_zero_count': ['sum','count']})

for index, row in pitcherDF.iterrows():
	three_zero_ratio = row.values[0]/row.values[1]
	if three_zero_ratio > 0 and index[10] > 50:
		for i in range(3,10):
			if index[i] > 0:
				corList[i-3][1].append(three_zero_ratio)
				corList[i-3][2].append(index[3])
				
et = time.time()
print('Pitchers grouped in {ti} seconds.\n'.format(ti=round(et-st)))
				
print('Expected bases on 3-0 count:')
print('If batter swings:\t\t{ev}'.format(ev=round(np.mean(rSwing),3)))
print('If batter does not swing:\t{ev}'.format(ev=round(np.mean(rNoSwing),3)))
print('For all 3-0 counts:\t\t{ev}'.format(ev=round(np.mean(rSwing+rNoSwing),3)))
print('For all at bats:\t\t{ev}'.format(ev=round(np.mean(allAtBats),3)))

print('\nVariance of expected bases on 3-0 count:')
print('If batter swings:\t\t{ev}'.format(ev=round(np.var(rSwing),3)))
print('If batter does not swing:\t{ev}'.format(ev=round(np.var(rNoSwing),3)))
print('For all 3-0 counts:\t\t{ev}'.format(ev=round(np.var(rSwing+rNoSwing),3)))
print('For all at bats:\t\t{ev}'.format(ev=round(np.var(allAtBats),3)))

print('\nStandard Deviation of expected bases on 3-0 count:')
print('If batter swings:\t\t{ev}'.format(ev=round(np.std(rSwing),3)))
print('If batter does not swing:\t{ev}'.format(ev=round(np.std(rNoSwing),3)))
print('For all 3-0 counts:\t\t{ev}'.format(ev=round(np.std(rSwing+rNoSwing),3)))
print('For all at bats:\t\t{ev}'.format(ev=round(np.std(allAtBats),3)))


print('\nPearson Correlation for core statistics:')
for cor in corList:
	cor.append(pearsonr(cor[1],cor[2]))
	print('{c1}:\t{c2}'.format(c1=cor[0],c2=cor[3]))
