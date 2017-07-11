#import statements
#may need cleaning up
import csv
import pymysql
import pymysql.cursors
import sys
import numpy as np
import pandas as pd
from scipy.stats.stats import pearsonr
import time
from tabulate import tabulate
from scipy.stats import anderson,kstest
from matplotlib import pyplot
import mlbStats

#file directories and password location
mlbData = 'C:\\Users\\evan.marcey\\Documents\\GitHub\\mlb_stats\\data\\'
mlbSql = 'C:\\Users\\evan.marcey\\Documents\\GitHub\\mlb_stats\\sql\\'

	
#get data from pitch_game_atBat view
pitchFile = 'pitch_game_atBat.sql'
pitchArray = mlbStats.getSQL(mlbSql+pitchFile)

rSwing = []
rNoSwing = []
zSwing = 0
zNoSwing = 0
allAtBats = []
zAtBats = 0
threeZeroArray = []

#list of correlation objects
corList = [
	['FIP', [],[]],
	['WHIP', [],[]],
	['xFIP', [],[]],
	['SIERA', [],[]],
	['strikeout_rate', [],[]],
	['walk_rate', [],[]],
	['hr_to_fly_ball_rate', [],[]]
]

#first, iterate through the returned query to locate all 3-0 counts
#additionally, determine if batter swung on pitch & num_bases for that atBat
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
						if pitchArray[i]['num_bases'] == 0:
							zSwing+=1
					else:
						rNoSwing.append(pitchArray[i]['num_bases'])
						if pitchArray[i]['num_bases'] == 0:
							zSwing+=1
							
et = time.time()
print('3-0 counts found in {ti} seconds.\n'.format(ti=round(et-st)))

#create dataFrame from pitches
pitchDF = pd.DataFrame(data=[pitchArray[i].values() for i in range(4,len(pitchArray))],columns=pitchArray[5].keys())

#create grouped data frame by at bat so that we can get the overall expected number of bases
print('Grouping by at bat...')
st = time.time()
atBatDF = pitchDF.groupby(['gameID','atBatNum','event','num_bases'])\
			['is_three_zero_count'].max()
for index, row in atBatDF.iteritems():
	allAtBats.append(index[3])
et = time.time()
print('At bats grouped in {ti} seconds.\n'.format(ti=round(et-st)))
	
#created grouped data frame by pitcher so that we can get pitcher-specific statistics
print('Grouping by pitchers...')
st = time.time()
pitcherDF = pitchDF.groupby(['pitcher','record_year','p_throws','FIP','WHIP','xFIP','SIERA','strikeout_rate','walk_rate','hr_to_fly_ball_rate','outs']).\
			agg({'is_three_zero_count': ['sum','count']})

three_zero_rl = [
	['all',[]],
	['R',[]],
	['L',[]]
]

#then iterate through those pitcher groups to find the frequency with which they throw 3-0 counts
#only include pitchers with at least 50 outs in the season
#assign each set of cor variables and three_zero_ratio to the corList if values exist		
for index, row in pitcherDF.iterrows():
	three_zero_ratio = row.values[0]/row.values[1]
	
	if three_zero_ratio > 0 and index[10] > 50:
		three_zero_rl[0][1].append(three_zero_ratio)
		if index[2] == 'R':
			three_zero_rl[1][1].append(three_zero_ratio)
		elif index[2] == 'L':
			three_zero_rl[2][1].append(three_zero_ratio)
			
		for i in range(3,10):
			if index[i] > 0:
				corList[i-3][1].append(three_zero_ratio)
				corList[i-3][2].append(index[i])
				
et = time.time()
print('Pitchers grouped in {ti} seconds.\n'.format(ti=round(et-st)))

#use tabulate module to print table of 3-0 count expected bases results
print('Stats for Expected Bases:')
ebHeaders = ['Swings','Expected Bases','Variance','Standard Deviation']
ebRows = [
	[
		'Overall',
		round(np.mean(allAtBats),3),
		round(np.var(allAtBats),3),
		round(np.std(allAtBats),3)
	],
	[
		'All 3-0 Counts',
		round(np.mean(rSwing+rNoSwing),3),
		round(np.var(rSwing+rNoSwing),3),
		round(np.std(rSwing+rNoSwing),3)
	],
	[
		'Batter Swings',
		round(np.mean(rSwing),3),
		round(np.var(rSwing),3),
		round(np.std(rSwing),3)
	],
	[
		'Batter Does Not Swing',
		round(np.mean(rNoSwing),3),
		round(np.var(rNoSwing),3),
		round(np.std(rNoSwing),3)
	]
]
print(tabulate(ebRows,headers=ebHeaders))

print('\nConfidence Swinging and Not Swinging have different Expected Bases:')
print('Z-Score:\t{mw}'.format(mw=round(mlbStats.mannWhitney(rSwing,rNoSwing),2)))

#Then calculate pearson correlation for each of the corList variables against three_zero_ratio
print('\nPearson Correlation for core pitching metrics:')
pearsonRows = []
pearsonHeaders = ['Metric','PearsonR-Squared','P-Value']

for cor in corList:
	tempPearson = pearsonr(cor[1],cor[2])
	cor.append(tempPearson[0])
	cor.append(tempPearson[1])
	tempRow = [cor[0],cor[3],cor[4]]
	pearsonRows.append(tempRow)

print(tabulate(pearsonRows,headers=pearsonHeaders))

#Additionally, calculate the difference between the Left- and Right-handed pitchers and frequency of 3-0 counts
tzRows = []
tzKSRows = []
tzHeaders = ['Handedness','Mean','Variance','Standard Deviation']

for tz in three_zero_rl:
	tz.append(np.mean(tz[1]))
	tz.append(np.var(tz[1]))
	tz.append(np.std(tz[1]))
	tz.append(len(tz[1]))
	tempRow = [tz[0],tz[2],tz[3],tz[4]]
	tzRows.append(tempRow)
print('\n3-0 Frequency by L-R Handedness:')
print(tabulate(tzRows,headers=tzHeaders))

print('\nConfidence Left- and Right-handed pitchers have different 3-0 frequencies:')
print('Z-Score:\t{mw}'.format(mw=round(mlbStats.mannWhitney(three_zero_rl[1][1],three_zero_rl[2][1]),2)))
