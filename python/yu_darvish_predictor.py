#import statements
from tabulate import tabulate
import numpy as np
import pandas as pd
import time
import math
from sklearn.tree import DecisionTreeClassifier
from sklearn import ensemble, svm, preprocessing
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.externals import joblib

mlbPkl = 'C:\\Users\\evan.marcey\\Documents\\GitHub\\mlb_stats\\pkl\\'

#assign model type, cross-validate 10 runs, train set
#input: model - model abbreviation, xArray - feature array, yArray - predictor array
#output: clf - model built, modelScores - array of 10 cross-validation scores
def runModel(model,xArray,yArray,num_trials=200,test_size=0.1):
	modelScores = []
	#create model based on input
	if model == 'dtc':
		clf = DecisionTreeClassifier(
									max_depth=40,
									min_samples_split=10,
									min_samples_leaf=5
									)
	elif model == 'rfc':
		clf = ensemble.RandomForestClassifier(
											n_estimators=800,									
											max_depth=60,
											min_samples_split=10,
											min_samples_leaf=5,
											)
	elif model == 'bc':
		clf = ensemble.BaggingClassifier(
										base_estimator=DecisionTreeClassifier(),
										n_estimators=1000,
										max_samples=1.0,
										max_features=1.0
										)
	elif model == 'abc':
		clf = ensemble.AdaBoostClassifier(
										n_estimators=800									
											)
	elif model == 'etc':
		clf = ensemble.ExtraTreesClassifier()
	elif model == 'gbc':
		clf = ensemble.GradientBoostingClassifier()
	elif model == 'svm':
		clf = svm.SVC(
					  kernel='rbf',
					  cache_size=1000,
					  C=8,
					  gamma=0.0275
					 )
	else:
		clf = DecisionTreeClassifier()
	
	#iterate model 10 times and return score
	for i in range(0,num_trials):												
		x_train, x_test, y_train, y_test = train_test_split(
															xArray,
															yArray,
															test_size=0.2
															)
		clf.fit(x_train,y_train)
		modelScores.append(clf.score(x_test, y_test))	
		
	#fit model on full data set
	clf.fit(xArray,yArray)
	
	#return model and array of scores
	return(clf,modelScores)
	
#create variable importance matrix
#input: clf - model, featureList - array of features
#output: tabulate table of feature importances
def varImportanceMatrix(clf, featureList):
	tabImportance = []
	at_bat_counts = []
	prev_pitches = []
	prev_pitches_2 = []
	#iterate through features
	for i in range(0,clf.n_features_):
		tempImportance = [featureList[i], clf.feature_importances_[i]]
		#push at_bat_count, prev_pitch, prev_pitch_2 features to arrays
		if featureList[i].startswith('at_bat_count'):
			at_bat_counts.append(tempImportance[1])
		elif featureList[i].startswith('prev_pitch_2'):
			if tempImportance[1] > 0:
				prev_pitches_2.append(tempImportance[1])
		elif featureList[i].startswith('prev_pitch'):
			if tempImportance[1] > 0:
				prev_pitches.append(tempImportance[1])
		#otherwise, add to main array
		else:
			tabImportance.append(tempImportance)
	#average at_bat_count, prev_pitch, prev_pitch_2
	tabImportance.append(['at_bat_count',np.mean(at_bat_counts)])
	tabImportance.append(['prev_pitch',np.mean(prev_pitches)])
	tabImportance.append(['prev_pitch_2',np.mean(prev_pitches_2)])
	
	#sort by most important to least
	tabImportance = sorted(tabImportance, key=lambda x:x[1], reverse=True)
	
	return(tabulate(tabImportance,headers=['Variable','Importance']))

startTime = time.time() 

#set file locations
mlbData = 'C:\\Users\\evan.marcey\\Documents\\GitHub\\mlb_stats\\data\\'
mlbSql = 'C:\\Users\\evan.marcey\\Documents\\GitHub\\mlb_stats\\sql\\'
mlbPkl = 'C:\\Users\\evan.marcey\\Documents\\GitHub\\mlb_stats\\pkl\\'

#set pitcher to model
#Yu Darvish - 506433
#Adam Wainwright - 425794
#Vance Worley - 474699
#Bartolo Colon - 112526
pitcherID = 506433

#load pitch_pred from file
pitchPredFile = mlbData + 'pitch_pred.csv'
print('Loading pitches')
pitchPredDF = pd.read_csv(pitchPredFile,
						sep=',',
						header=0
						)
endTime = time.time()
print('Pitches loaded in {vs} seconds.\n'.format(vs=round(endTime-startTime,0)))

start_time = time.time()
print('Filtering and formatting.')

#set balls and strikes as the count
pitchPredDF['at_bat_count'] = pitchPredDF['balls'].astype(str) + '-' + pitchPredDF['strikes'].astype(str)
#set rl_batter to bool with R -> TRUE; L -> FALSE
pitchPredDF['rl_batter'] = pitchPredDF['rl_batter'] == 'R'
#replace null pitches with 'NA' values
#needed for pitches w/o prior value (i.e. prev_pitch on a 0-0 count)
pitchPredDF['prev_pitch'] = pitchPredDF['prev_pitch'].fillna('NA',axis=0)
pitchPredDF['prev_pitch_2'] = pitchPredDF['prev_pitch_2'].fillna('NA',axis=0)
#filter down to selected pitcher and remove bad records
pitchPredDF.query('pitcher==@pitcherID & type_confidence >= 1.25 & inningNum < 10 & balls < 4 & pitch_type != "EP" & pitch_type != "FA" & pitch_type != "FO" &  pitch_type != "PO" & pa > 50', inplace=True)
pitchPredDF.query('prev_pitch != "EP" & prev_pitch != "FA" & prev_pitch != "FO" &  prev_pitch != "PO"', inplace=True)
pitchPredDF.query('prev_pitch_2 != "EP" & prev_pitch_2 != "FA" & prev_pitch_2 != "FO" &  prev_pitch_2 != "PO"', inplace=True)

pitchPredDF = pitchPredDF.loc[:,[
							'pitch_type',
							'pitch_group',
							'rl_batter',
							'atBat_outs',
							'prev_pitch',
							'prev_pitch_2',
							'on_1b',
							'on_2b',
							'on_3b',
							'inningNum',
							'run_differential',
							'at_bat_count',
							'batting_average',
							'slg',
							'obp',
							'babip',
							'bb_rate',
							'so_rate',
							'pitches_per_at_bat'
							]]

pitchPredDF.dropna(axis=0,how='any',inplace=True)

#set pitch_group to test
pitchPredDF['pitch_group'] = pitchPredDF['pitch_type'] == 'FF'

print(len(pitchPredDF))
print(pitchPredDF['prev_pitch'].unique())
#create binary fields for at_bat_count, prev_pitch and prev_pitch_2
for abc in pitchPredDF['at_bat_count'].unique():
	if int(abc[:len(abc)-2]) < 4:
		pitchPredDF['at_bat_count_is_' + abc] = pitchPredDF['at_bat_count'] == abc
		
for abc in pitchPredDF['prev_pitch'].unique():
	pitchPredDF['prev_pitch_is_' + abc] = pitchPredDF['prev_pitch'] == abc
		
for abc in pitchPredDF['prev_pitch_2'].unique():
	pitchPredDF['prev_pitch_2_is_' + abc] = pitchPredDF['prev_pitch_2'] == abc
pitchPredDF.drop(['at_bat_count','prev_pitch','prev_pitch_2'], axis=1, inplace=True)

endTime = time.time()
print('Pitches filtered and formatted in {vs} seconds.\n'.format(vs=round(endTime-startTime,0)))
#run models	
print(pitchPredDF['pitch_type'].value_counts(normalize=True))
print(pitchPredDF['pitch_group'].value_counts(normalize=True))


print('Pitch Type SVM')

clfPitchTypeSVM, pitchTypeSVMModelScores = runModel('svm',
													pitchPredDF.iloc[:,2:],
													pitchPredDF['pitch_group'])
print(np.mean(pitchTypeSVMModelScores))
print(clfPitchTypeSVM.score(pitchPredDF.iloc[:,2:],pitchPredDF['pitch_group']))
joblib.dump(clfPitchTypeSVM,mlbPkl+'yu_svm.pkl')
