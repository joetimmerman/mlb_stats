from tkinter import *
from tkinter import ttk
import mlbStats
import pymysql
import pymysql.cursors
import pandas as pd
from sklearn.externals import joblib
import numpy as np
import warnings

mlbPkl = 'C:\\Users\\evan.marcey\\Documents\\GitHub\\mlb_stats\\pkl\\'
warnings.filterwarnings("ignore", category = DeprecationWarning)

class main_menu(Frame):
	
	def __init__(self,master=None):
		
		Frame.__init__(self,master)
		master.title("Predict Kershaw's pitches!")
		pFrame = Frame(master)
		
		root.minsize(905,550)
		root.maxsize(905,550)
		pFrame.grid(row=1,column=0)
		pFrame.grid_rowconfigure(0)
		num_bat_features = 9
		result_row = num_bat_features+4
		
		#this section pulls the batters from the db
		connection, conn = mlbStats.openConnection()
		conn.execute("SELECT * FROM (Select pl.playerID, pl.first_name, pl.last_name, pl.position, pl.rl_bats, ab.record_year, ab.batting_average, ab.OBP, ab.SLG, ab.OPS, ab.bb_rate, ab.so_rate, ab.pitches_per_at_bat, ab.BABIP FROM player pl JOIN adv_batting_stats_year ab ON pl.playerID = ab.playerID ORDER BY pl.playerID, ab.record_year DESC) a1 GROUP BY playerID;")
		players = pd.DataFrame(conn.fetchall())
		players['full_name'] = players['first_name'] + ' ' + players['last_name']
		players.sort_values(by=['last_name','first_name'],inplace=True)
		playerNames = pd.Series.tolist(players['full_name'])
		connection.close()
		
		#This section puts together the listbox with batters along with scrollbar and search bar
		scrollbar = Scrollbar(pFrame, orient=VERTICAL)
		search_var = StringVar()
		search_var.trace("w", lambda name, index, mode: update_list())
		
		playerList = Listbox(pFrame,
							selectmode=SINGLE,
							yscrollcommand=scrollbar.set
							)
		playerEntry = Entry(pFrame, textvariable=search_var)
		scrollbar.config(command=playerList.yview)
		
		def update_list(*args):
			search_term = search_var.get()
			playerList.delete(0,END)
			for pn in playerNames:
				if search_term.lower() in pn.lower():
					playerList.insert(END, pn)
		
		
		Label(pFrame,
			  text="Choose a batter:",
			  justify=LEFT,
			  relief=RIDGE,
			  borderwidth=2,
			  font=(None,12)).grid(row=0,
								  column=0,
								  columnspan=2,
								  sticky=N+S+W+E)
		
		playerList.grid(row=2,
						column=0,
						rowspan=num_bat_features-1,
						ipadx=20,
						ipady=50,
						sticky=N+S+W)
		
		playerEntry.grid(row=1,
						 column=0,
						 columnspan=2,
						 sticky=N+S+W+E)
		
		scrollbar.grid(row=2,
					   column=1,
					   rowspan=num_bat_features-1,
					   sticky=N+S+W)
		
		update_list()
		
		#This section constructs the selected batter stats and populates the data when selected
		Label(pFrame,
			  text="Batter stats:",
			  justify=LEFT,
			  relief=RIDGE,
			  borderwidth=2,
			  font=(None,12)).grid(row=0,
								  column=2,
								  columnspan=2,
								  sticky=N+S+W+E)
											
		Label(pFrame,text="Bats (L/R):",justify=LEFT).grid(row=1,
														   column=2,
														   sticky=N+S+W+E)
		
		bhVar = StringVar()
		bhText = Entry(pFrame,textvariable=bhVar).grid(row=1,
					column=3,
					sticky=N+S+W+E)
		
		Label(pFrame,text="Batting Average:",justify=LEFT).grid(row=2,
																column=2,
																sticky=N+S+W+E)
		
		baVar = DoubleVar()
		baText = Entry(pFrame,textvariable=baVar).grid(row=2,
													   column=3,
													   sticky=N+S+W+E)
		
		Label(pFrame,text="OBP:",justify=LEFT).grid(row=3,
													column=2,
													sticky=N+S+W+E)
		
		obpVar = DoubleVar()
		obpText = Entry(pFrame,textvariable=obpVar).grid(row=3,
														 column=3,
														 sticky=N+S+W+E)
		
		Label(pFrame,text="SLG:",justify=LEFT).grid(row=4,
													column=2,
													sticky=N+S+W+E)
										   
		slgVar = DoubleVar()
		slgText = Entry(pFrame,textvariable=slgVar).grid(row=4,
														 column=3,
														 sticky=N+S+W+E)
										   
		Label(pFrame,text="OPS:",justify=LEFT).grid(row=5,
													column=2,
													sticky=N+S+W+E)
										   
		opsVar = DoubleVar()
		opsText = Entry(pFrame,textvariable=opsVar).grid(row=5,
														 column=3,
														 sticky=N+S+W+E)
		
		Label(pFrame,text="Walk Rate:",justify=LEFT).grid(row=6,
														  column=2,
														  sticky=N+S+W+E)
										   
		bbVar = DoubleVar()
		bbText = Entry(pFrame,textvariable=bbVar).grid(row=6,
													   column=3,
													   sticky=N+S+W+E)
										   
		Label(pFrame,text="Strikeout rate:",justify=LEFT).grid(row=7,
															   column=2,
															   sticky=N+S+W+E)
							
		soVar = DoubleVar()
		soText = Entry(pFrame,textvariable=soVar).grid(row=7,
													   column=3,
													   sticky=N+S+W+E)
													   
		Label(pFrame,text="BABIP:",justify=LEFT).grid(row=8,
													  column=2,
													  sticky=N+S+W+E)
							
		babipVar = DoubleVar()
		babipText = Entry(pFrame,textvariable=babipVar).grid(row=8,
													   column=3,
													   sticky=N+S+W+E)
													   
		Label(pFrame,text="Avg. Pitches per at bat:",justify=LEFT).grid(row=9,
																		column=2,
																		sticky=N+S+W+E)
									
		appapVar= DoubleVar()
		appapText = Entry(pFrame,textvariable=appapVar).grid(row=9,
															  column=3,
															  sticky=N+S+W+E)
		
		#This section performs the select update on the batter and populates the stat fields
		def selectBatter():
			playerName = playerList.get(ACTIVE)
			vPlayers = players.copy()
			vPlayers.query('full_name == @playerName',inplace=True)
			
			bhVar.set(pd.Series.tolist(vPlayers['rl_bats'])[0])
			baVar.set(pd.Series.tolist(vPlayers['batting_average'])[0])
			obpVar.set(pd.Series.tolist(vPlayers['OBP'])[0])											   
			slgVar.set(pd.Series.tolist(vPlayers['SLG'])[0])												 
			opsVar.set(pd.Series.tolist(vPlayers['OPS'])[0])
			bbVar.set(pd.Series.tolist(vPlayers['bb_rate'])[0])
			soVar.set(pd.Series.tolist(vPlayers['so_rate'])[0])
			babipVar.set(pd.Series.tolist(vPlayers['BABIP'])[0])
			appapVar.set(pd.Series.tolist(vPlayers['pitches_per_at_bat'])[0])
			
		plSelect = Button(pFrame,
						  text="Select Highlighted Batter",
						  justify=LEFT,
						  relief=RAISED,
						  borderwidth=5,
						  command=selectBatter).grid(row=num_bat_features+1,
													 column=0,
													 sticky=N+S+W+E)
													 
		#This section creates the frame for choosing the game situation
		Label(pFrame,
			  text='Game Situation:',
			  justify=LEFT,
			  relief=RIDGE,
			  borderwidth=2,
			  font=(None,12)).grid(row=0,
								  column=4,
								  columnspan=2,
								  sticky=N+S+W+E)
							   
		Label(pFrame,text='Inning:',justify=LEFT).grid(row=1,
													   column=4,
													   sticky=N+S+W+E)
		
		inText = Spinbox(pFrame,from_=0,to=9)
		inText.grid(row=1,column=5,sticky=N+S+W+E)
		
		Label(pFrame,text='Outs:',justify=LEFT).grid(row=2,
													 column=4,
													 sticky=N+S+W+E)
		outText = Spinbox(pFrame,from_=0,to=2)
		outText.grid(row=2,column=5,sticky=N+S+W+E)
		
		Label(pFrame,text='Pitcher Team Runs:',justify=LEFT).grid(row=3,
																  column=4,
																  sticky=N+S+W+E)
		prText = Spinbox(pFrame,from_=0,to=25)
		prText.grid(row=3,column=5,sticky=N+S+W+E)
									 
		Label(pFrame,text='Batter Team Runs:',justify=LEFT).grid(row=4,
																 column=4,
																 sticky=N+S+W+E)
		brText = Spinbox(pFrame,from_=0,to=25)
		brText.grid(row=4,column=5,sticky=N+S+W+E)
									 
		Label(pFrame,text='Runner on 1st:',justify=LEFT).grid(row=5,
															  column=4,
															  sticky=N+S+W+E)
		on1Var = IntVar()
		on1Button = Checkbutton(pFrame, variable=on1Var).grid(row=5,
															  column=5,
															  sticky=N+S+W+E)
															  
		Label(pFrame,text='Runner on 2nd:',justify=LEFT).grid(row=6,
															  column=4,
															  sticky=N+S+W+E)
		
		on2Var = IntVar()
		on2Button = Checkbutton(pFrame, variable=on2Var).grid(row=6,
															  column=5,
															  sticky=N+S+W+E)
															  
		Label(pFrame,text='Runner on 3rd:',justify=LEFT).grid(row=7,
															  column=4,
															  sticky=N+S+W+E)
		
		on3Var = IntVar()
		on3Button = Checkbutton(pFrame, variable=on3Var).grid(row=7,
															  column=5,
															  sticky=N+S+W+E)
		
		#This section allows the user to frame the at bat
		Label(pFrame,
			  text='At Bat:',
			  justify=LEFT,
			  relief=RIDGE,
			  borderwidth=2,
			  font=(None,12)).grid(row=0,
								  column=6,
								  columnspan=2,
								  sticky=N+S+W+E)
											
		Label(pFrame,text='Balls:',justify=LEFT).grid(row=1,
													 column=6,
													 sticky=N+S+W+E)		
		ballText = Spinbox(pFrame,from_=0,to=3)
		ballText.grid(row=1,column=7,sticky=N+S+W+E)
									  
		Label(pFrame,text='Strikes:',justify=LEFT).grid(row=2,
													   column=6,
													   sticky=N+S+W+E)		
		strikeText = Spinbox(pFrame,from_=0,to=2)
		strikeText.grid(row=2,column=7,sticky=N+S+W+E)
									  
		pitchChoices = {'NA','CH','CU','FT','FF','SL'}
		prevVar = StringVar()
		prevVar2 = StringVar()
		prevVar.set('NA')
		prevVar2.set('NA')
		
		Label(pFrame, text='Previous Pitch:').grid(row=3,
												  column=6,
												  sticky=N+S+W+E)
		
		Label(pFrame, text='Previous Pitch 2:').grid(row=4,
												  column=6,
												  sticky=N+S+W+E)
												  
		prevMenu = OptionMenu(pFrame,
							  prevVar,
							  *pitchChoices).grid(row=3,
												  column=7,
												  sticky=N+S+W+E)
							  
		prevMenu2 = OptionMenu(pFrame,
							  prevVar2,
							  *pitchChoices).grid(row=4,
												  column=7,
												  sticky=N+S+W+E)
												  
		#This section builds the result framework for will/won't throw four seam and expected pitch
		Label(pFrame,text='').grid(row=result_row-1,
								  column=0,
								  columnspan=8,
								  sticky=N+S+W+E)
		Label(pFrame, 
			  text = 'Results',
			  justify=LEFT,
			  relief=RIDGE,
			  borderwidth=5,
			  font=(None,14)).grid(row=result_row,
								  column=0,
								  columnspan=8,
								  sticky=N+S+W+E)
		
		Label(pFrame, 
			  text = 'Kershaw throws a Four-Seam:',
			  justify=LEFT,
			  relief=RIDGE,
			  borderwidth=2,
			  font=(None,12)).grid(row=result_row+1,
								  column=0,
								  columnspan=3,
								  sticky=N+S+W+E)
		
		Label(pFrame,
			  text='Result:',
			  justify=LEFT).grid(row=result_row+2,
								 column=0,
								 columnspan=2,
								 sticky=N+S+W+E)
		
		ffResultVar = StringVar()
		ffResultText = Entry(pFrame,textvariable=ffResultVar)
		ffResultText.grid(row=result_row+2,
						  column=2,
						  sticky=N+S+W+E)
		
		ffTrueVar = DoubleVar()
		Label(pFrame,
			  text='Probability of Four-Seam:',
			  justify=LEFT).grid(row=result_row+3,
								 column=0,
								 columnspan=2,
								 sticky=N+S+W+E)
			  
		ffTrueText = Entry(pFrame,textvariable=ffTrueVar)
		ffTrueText.grid(row=result_row+3,column=2,sticky=N+S+W+E)
		
		ffFalseVar = DoubleVar()
		Label(pFrame,
			  text='Probability of Other:',
			  justify=LEFT).grid(row=result_row+4,
								 column=0,
								 columnspan=2,
								 sticky=N+S+W+E)
			  
		ffFalseText = Entry(pFrame,textvariable=ffFalseVar)
		ffFalseText.grid(row=result_row+4,column=2,sticky=N+S+W+E)
		
		Label(pFrame,
			  text='Expected Pitch:',
			  justify=LEFT,
			  relief=RIDGE,
			  borderwidth=2,
			  font=(None,12)).grid(row=result_row+1,
								  column=4,
								  columnspan=4,
								  sticky=N+S+W+E)
	
		Label(pFrame,
			  text='Result:').grid(row=result_row+2,
									 column=4,
									 sticky=N+S+W+E)
		epVar = StringVar()
		epText = Entry(pFrame,textvariable=epVar)
		epText.grid(row=result_row+2,
					column=5,
					sticky=N+S+W+E)
					
		Label(pFrame,
			  text='Four-Seam:').grid(row=result_row+3,
									 column=4,
									 sticky=N+S+W+E)
									 
		fsVar = DoubleVar()
		fsText = Entry(pFrame,textvariable=fsVar)
		fsText.grid(row=result_row+3,
					column=5,
					sticky=N+S+W+E)
									 
		Label(pFrame,
			  text='Two-Seam:').grid(row=result_row+4,
									column=4,
									sticky=N+S+W+E)
									
		tsVar = DoubleVar()
		tsText = Entry(pFrame,textvariable=tsVar)
		tsText.grid(row=result_row+4,
					column=5,
					sticky=N+S+W+E)
									 
		Label(pFrame,
			  text='Slider:').grid(row=result_row+2,
								  column=6,
								  sticky=N+S+W+E)
								  
		slVar = DoubleVar()
		slText = Entry(pFrame,textvariable=slVar)
		slText.grid(row=result_row+2,
					column=7,
					sticky=N+S+W+E)
								  
		Label(pFrame,
			  text='Changeup:').grid(row=result_row+3,
									column=6,
									sticky=N+S+W+E)
									
		chVar = DoubleVar()
		chText = Entry(pFrame,textvariable=chVar)
		chText.grid(row=result_row+3,
					column=7,
					sticky=N+S+W+E)
									
		Label(pFrame,
			  text='Curveball:').grid(row=result_row+4,
									 column=6,
								     sticky=N+S+W+E)
									 
		cuVar = DoubleVar()
		cuText = Entry(pFrame,textvariable=cuVar)
		cuText.grid(row=result_row+4,
					column=7,
					sticky=N+S+W+E)
		
		def predict(*args):
			predArray = []
			predArray.append(bhVar.get() == 'R')
			predArray.append(int(outText.get()))
			predArray.append(on1Var.get())
			predArray.append(on2Var.get())
			predArray.append(on3Var.get())
			predArray.append(int(inText.get()))
			predArray.append(int(prText.get()) - int(brText.get()))
			at_bat_count = '{ba}-{st}'.format(ba=ballText.get(),st=strikeText.get())
			predArray.append(float(baVar.get()))
			predArray.append(float(slgVar.get()))
			#predArray.append(float(opsVar.get()))
			predArray.append(float(obpVar.get()))
			predArray.append(float(babipVar.get()))
			predArray.append(float(bbVar.get()))
			predArray.append(float(soVar.get()))
			predArray.append(float(appapVar.get()))

			atBatCounts = ['0-0','0-1','0-2','1-0','1-1','1-2','2-0','2-1','2-2','3-0','3-1','3-2']
			for abc in atBatCounts:
				predArray.append(at_bat_count == abc)
				
			for pc in pitchChoices:
				predArray.append(prevVar.get() == pc)
				predArray.append(prevVar2.get() == pc)

			#pull is four seam pkl
			pgclf = joblib.load(mlbPkl+'kershaw_group_svm.pkl')
			#predict probabilities
			pprob = pgclf.predict_proba(predArray)
			#set prob true/false
			ffFalseVar.set(round(pprob[0][np.where(pgclf.classes_==False)][0],3))
			ffTrueVar.set(round(pprob[0][np.where(pgclf.classes_==True)][0],3))
			#predict literal value
			pgclasses = pgclf.classes_.tolist()
			#return result
			if pgclasses[np.argmax(pprob[0])] == True:
				ffResultVar.set('Four-Seam')
			else:
				ffResultVar.set('Other')
			
			#pull pitch type pkl
			ptclf = joblib.load(mlbPkl+'kershaw_type_svm.pkl')
			ptprob = ptclf.predict_proba(predArray)
			#predict probabilities
			ptclasses = ptclf.classes_.tolist()
			#assign probabilities to each pitch type
			fsVar.set(round(ptprob[0][ptclasses.index('FF')],3))
			tsVar.set(round(ptprob[0][ptclasses.index('FT')],3))
			slVar.set(round(ptprob[0][ptclasses.index('SL')],3))
			chVar.set(round(ptprob[0][ptclasses.index('CH')],3))
			cuVar.set(round(ptprob[0][ptclasses.index('CU')],3))
			
			#predict literal value
			epVar.set(ptclasses[np.argmax(ptprob[0])])
		
		predButton = Button(pFrame,
							text='Predict!',
							relief=RAISED,
							borderwidth=5,
							font=(None,14),
							command=predict).grid(row=num_bat_features+2,
												  column=0,
												  columnspan=8,
												  sticky=N+S+W+E)
		
root = Tk()
mm = main_menu(master=root)
mm.mainloop()
