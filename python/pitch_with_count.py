#import statements
#basic python modules
import csv
import os
import warnings
import sys
import time
#modules used to read/write from db
import pymysql
import pymysql.cursors
import mlbStats

#warnings.filterwarnings("ignore", category = UserWarning)

mlbData = 'C:\\Users\\evan.marcey\\Documents\\GitHub\\mlb_stats\\data\\'
mlbSql = 'C:\\Users\\evan.marcey\\Documents\\GitHub\\mlb_stats\\sql\\'

pitchFile = mlbSql + "all_pitches.sql"
pitchArray = mlbStats.getSQL(pitchFile)
cc=0
tableName = 'pitch_with_count'
oArray = []

kDes = [
	'Foul Bunt',
	'Swinging Strike'
	'Swinging Strike (Blocked)',
	'Foul Bunt',
	'Missed Bunt',
	'Foul Tip'
]

print('Iterating pitches...')
for i in range(0,len(pitchArray)):

	if i == 0:
		pitchArray[i]['prev_pitch'] = 'NA'
		pitchArray[i]['prev_pitch_2'] = 'NA'
		pitchArray[i]['prev_pitch_speed'] = 0
		pitchArray[i]['prev_pitch_2_speed'] = 0
		pitchArray[i]['prev_pitch_spin_rate'] = 0
		pitchArray[i]['prev_pitch_2_spin_rate'] = 0
		pitchArray[i]['strikes'] = 0
		pitchArray[i]['balls'] = 0
		pitchArray[i]['abOuts'] = 0
		pitchArray[i]['atBatLength'] = 0
	#if pitch is from same atBat, prior pitch
	elif pitchArray[i]['gameID'] == pitchArray[i-1]['gameID'] and\
		pitchArray[i]['atBatNum'] == pitchArray[i-1]['atBatNum']:
			
		pitchArray[i]['atBatLength'] = pitchArray[i-1]['atBatLength']+1
		pitchArray[i]['abOuts'] = pitchArray[i-1]['abOuts']
		pitchArray[i]['prev_pitch'] = pitchArray[i-1]['pitch_type']
		pitchArray[i]['prev_pitch_2'] = pitchArray[i-1]['prev_pitch']
		pitchArray[i]['prev_pitch_speed'] = pitchArray[i-1]['start_speed']
		pitchArray[i]['prev_pitch_2_speed'] = pitchArray[i-1]['prev_pitch_speed']
		pitchArray[i]['prev_pitch_spin_rate'] = pitchArray[i-1]['spin_rate']
		pitchArray[i]['prev_pitch_2_spin_rate'] = pitchArray[i-1]['prev_pitch_spin_rate']
		
		if pitchArray[i-1]['type'] == 'B':
			pitchArray[i]['balls'] = pitchArray[i-1]['balls']+1
			pitchArray[i]['strikes'] = pitchArray[i-1]['strikes']
		elif pitchArray[i-1]['type'] == 'S':
			pitchArray[i]['balls'] = pitchArray[i-1]['balls']
			if pitchArray[i-1]['strikes'] < 2:
				pitchArray[i]['strikes'] = pitchArray[i-1]['strikes']+1
			else:
				pitchArray[i]['strikes'] = pitchArray[i-1]['strikes']
				
		else:
			pitchArray[i]['strikes'] = 0
			pitchArray[i]['balls'] = 0
					
	#if pitch is from same half inning, but next at bat
	elif pitchArray[i]['gameID'] == pitchArray[i-1]['gameID'] and\
		pitchArray[i]['atBatNum'] == pitchArray[i-1]['atBatNum']+1 and\
		pitchArray[i]['inningNum'] == pitchArray[i-1]['inningNum'] and\
		pitchArray[i]['topBottom'] == pitchArray[i-1]['topBottom']:
			pitchArray[i]['abOuts'] = pitchArray[i-1]['outs']
			pitchArray[i]['atBatLength'] = 0
			pitchArray[i]['strikes'] = 0
			pitchArray[i]['balls'] = 0
			
			pitchArray[i]['prev_pitch'] = 'NA'
			pitchArray[i]['prev_pitch_2'] = 'NA'
			pitchArray[i]['prev_pitch_speed'] = 0
			pitchArray[i]['prev_pitch_2_speed'] = 0
			pitchArray[i]['prev_pitch_spin_rate'] = 0
			pitchArray[i]['prev_pitch_2_spin_rate'] = 0
	
	else:
		pitchArray[i]['prev_pitch'] = 'NA'
		pitchArray[i]['prev_pitch_2'] = 'NA'
		pitchArray[i]['strikes'] = 0
		pitchArray[i]['balls'] = 0
		pitchArray[i]['abOuts'] = 0
		pitchArray[i]['atBatLength'] = 0
		pitchArray[i]['prev_pitch_speed'] = 0
		pitchArray[i]['prev_pitch_2_speed'] = 0
		pitchArray[i]['prev_pitch_spin_rate'] = 0
		pitchArray[i]['prev_pitch_2_spin_rate'] = 0
	
	oArray.append(pitchArray[i])
	
	cc+=1
	if cc%500000==0:
		print('\t{ct}\tof {cx} pitches iterated.'.format(ct=cc,cx=len(pitchArray)))

print('All pitches iterated.')

print('Writing records to file...')

tableFields = mlbStats.getColumns(tableName)
mlbStats.writeOut(mlbData + tableName + '.csv',[x.values() for x in oArray],oArray[5].keys())
print('Records written to file.\n')

print('Prepping array...')
vArray = mlbStats.prepArrayFull('pitch_with_count',oArray)
print('Array prepped.\n')
print('Writing records to table...')
i = 0
errArray = []
tArray = []
print(len(vArray))
print(vArray[0])

for i in range(0,len(vArray)):
	tArray.append(vArray[i])
	i+=1
	if i%1000==0:
		mlbStats.insertRecords(tableName,tArray,tableFields)

		tArray = []
	if i%100000==0:
		print('\t{ct}\tof {cx} pitches iterated.'.format(ct=(i),cx=len(pitchArray)))

mlbStats.writeOut(mlbData+'errArray.csv',errArray,oArray[5].keys())
print('{ea} of {pa} records written to error file.'.format(ea=len(errArray),pa=len(pitchArray)))

print('Process complete.')
