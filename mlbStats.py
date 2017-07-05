#import statements
from lxml import etree,html
import requests
import time
import json
import pymysql
import pymysql.cursors
import csv
import os
import datetime
import warnings

warnings.filterwarnings("ignore", category = pymysql.Warning)

passFile = 'C:\\Users\\evan.marcey\\Documents\\GitHub\\mlb_stats\\pass.csv'

aws_username = ''
aws_password = ''

with open(passFile,'r') as pf:
	pfr = csv.reader(pf)
	for row in pfr:
		if row[0] == 'username':
			aws_username = row[1]
		elif row[0] == 'pass':
			aws_password = row[1]

#create connection to AWS MySQL server
connection = pymysql.connect(host='baseball.cfelhfqsawiy.us-east-1.rds.amazonaws.com',
                             port=3306,
                             user=aws_username,
                             db='mlb_data_test',
                             password=aws_password,
                             charset='utf8mb4',
                             cursorclass=pymysql.cursors.DictCursor)
conn = connection.cursor()

errorDir = 'C:\\Users\\evan.marcey\\Documents\\mlbStats\\error_logs\\'
archiveDir = 'C:\\Users\\evan.marcey\\Documents\\mlbStats\\error_logs\\error_archive\\'

#output arrays that are written to file/db
errorURLs = []
badAtBats = []
allGames = []
allStadiums = []
allActions = []
allTeams = []
allPlayers = []
allCoaches = []
allUmpires = []
allAtBats = []
allPitches = []
allRunners = []
allPos = []
allLights = []
fuckedPitches = []
otherAtBats = []
allPitchers = []
allBatters = []
allBoxScore = []
allLineScore = []
allLineScoreInning = []
oBoxScore = []
oLineScore = []
oLineScoreInning = []
oPitcher = []
oBatters = []

#list of tables with their fields
#could probably do this easier by selecting all fields from the db
allTables = [
    'game',
    'teamGame',
    'stadiumGame',
    'runner',
    'playerGame',
    'pitch',
    'pickoff',
    'gameDayLight',
    'umpireGame',
    'coachGame',
    'atBat',
    'boxscore',
    'linescore',
    'linescore_inning',
    'pitcher_box',
    'batter_box',
    'action'
]

#iterate through mlb.com file directory
#call innings, players, game, stadium
#input: top level parent directory url
#output: 
def iterURL(URL): 
    #call parent directory
    pResponse = requests.get(URL)
    ptree = html.fromstring(pResponse.content)

    try:
        #iterate through xml list
        for child in ptree.getchildren()[1].getchildren()[1].iterchildren():
            childText = child.getchildren()[0].text.strip()
            
            #if the year subdirectory is found, call iterURL with year in URL
            if childText.find('year') != -1 and childText.find('old') == -1:
                print(childText)
                nextURL = URL + childText
                #print(nextURL)
                iterURL(nextURL)
            
            #if the year/month subdirectory is found, call iterURL with month in URL
            elif childText.find('month') != -1 and childText.find('old') == -1:
                nextURL = URL + childText
                print('\t' + childText)
                #print(nextURL)
                iterURL(nextURL)
         
            #if the year/month/day subdirectory is found, call iterURL with day in URL
            elif childText.find('day') != -1                and childText.find('old') == -1                and childText.find('gameday_Syn') == -1                and childText.find('_00') == -1:
                nextURL = URL + childText
                print('\t\t' + childText)
                #print(nextURL)
                iterURL(nextURL)
                        
            #if the year/month/day/game subdirectory is found, call iterURL with game in URL
            elif childText.find('gid_') != -1 and childText.find('gameday_Syn') == -1:
                print('\t\t\t' + childText)
                nextURL = URL + childText
                iterURL(nextURL)
                
                        #if the year/month/day/game/inning info subdirectory is found
            #call iterURL with inning in URL
            elif childText.find('inning/') != -1:                
                nextURL = URL + '/inning/inning_all.xml'
                atBats, pitches, runners, pos = parseInnings(nextURL)
            
            elif childText.find('boxscore.xml') != -1:
                nextURL = URL + '/boxscore.xml'
                boxScore, lineScore, lineScoreInning, pitchers, batters = parseBox(nextURL)
            
            #if the year/month/day/game/game info subdirectory is found
            #call iterURL with game info in URL
            elif childText.find('game.xml') != -1:
                nextURL = URL + '/game.xml'
                gameData, teams, stadium = parseGame(nextURL)
               

               
            #if the year/month/day/game/players info subdirectory is found
            #call iterURL with players in URL
            elif childText.find('players') != -1:
                nextURL = URL + '/players.xml'
                players,coaches,umpires = parsePlayers(nextURL)
              
    except:
        #some weird shit is happening with gameday_Syn and I don't want to deal with it
        if URL.find('gameday_Syn') == -1:
            errorURLs.append([URL])
            print(URL)
        
#parse the inning_all.xml file
#input: game/inning/inning_all.xml url
#output: innings array
def parseInnings(inningsURL):    
    gameID = inningsURL[inningsURL.find('year_'):].                replace('year_','').                replace('month_','').                replace('day_','').                replace('/inning/inning_all.xml','')
    atBats = []
    pitches = []
    runners = []
    pos = []
    inningNum = 0
    mastEventNum = 1
    try:
        tree = etree.parse(inningsURL)
        root = tree.getroot()  
        #iterate through innings
        for inning in root.iter('inning'):
            tatBats, tpitches, trunners, tpos, mastEventNum = parseInning(mastEventNum, gameID, inning)
            atBats = atBats + tatBats
            pitches = pitches + tpitches
            runners = runners + trunners
            pos = pos + tpos
    except:
        xURL = inningsURL.replace('/inning_all.xml','')
        xResponse = requests.get(xURL)
        xtree = html.fromstring(xResponse.content)
        for item in xtree.getchildren()[1].getchildren()[1].iterchildren():
            childText = item.getchildren()[0].text.strip()
            if childText.find('inning_') != -1:
                try:
                    x = int(childText[len('inning_'):len(childText)-4])
                    yURL = xURL + '/' + childText
                    print(yURL)
                    tree = etree.parse(yURL)
                    root = tree.getroot()  
                    #iterate through innings
                    for inning in root.iter('inning'):
                        tatBats, tpitches, trunners, tpos, mastEventNum = parseInning(mastEventNum, gameID, inning)
                        atBats = atBats + tatBats
                        pitches = pitches + tpitches
                        runners = runners + trunners
                        pos = pos + tpos
                except:
                    pass
    return atBats, pitches, runners, pos

def parseInning(mastEventNum, gameID, inning):  
    atBats = []
    pitches = []
    runners = []
    pos = []
    for item in inning.items():
        if item[0] == 'num':
            inningNum = int(item[1])
    #iterate through top and bottom halves
    for half in inning.iterchildren():
        topBottom = half.tag

        #iterate through each at bat
        for atbat in half.iterchildren():
            if atbat.tag == 'action':
                tempAction = {}
                tempAction['gameID'] = gameID
                tempAction['inningNum'] = inningNum
                tempAction['topBottom'] = topBottom
                
                for item in atbat.items():
                    tempAction[item[0]] = item[1]
                try:
                    if tempAction['event_num'] == None:
                        tempAction['event_num'] = mastEventNum
                        mastEventNum+=1
                except:
                    tempAction['event_num'] = mastEventNum
                    mastEventNum+=1
                
                allActions.append(prepArray('action',tempAction))

            elif atbat.tag == 'atbat':
                #get atbat details
                tempAtBat = [gameID,
                             inningNum,
                             topBottom                                 
                            ]

                for i in range(0,26):
                    tempAtBat.append(None)

                #iterate through the attributes of each atBat
                for item in atbat.items():                                                         
                    if item[0] == 'num':
                        tempAtBat[3] = item[1]   
                    elif item[0] == 'b':
                        tempAtBat[4] = item[1]   
                    elif item[0] == 's':
                        tempAtBat[5] = item[1]   
                    elif item[0] == 'o':
                        tempAtBat[6] = item[1]   
                    elif item[0] == 'start_tfs':
                        tempAtBat[7] = item[1]   
                    elif item[0] == 'start_tfs_zulu':
                        tempAtBat[8] = item[1].                                            replace('Z','').                                            replace('T',' ')   
                    elif item[0] == 'batter':
                        tempAtBat[9] = item[1]   
                    elif item[0] == 'stand':
                        tempAtBat[10] = item[1]   
                    elif item[0] == 'b_height':
                        tempAtBat[11] = item[1]   
                    elif item[0] == 'pitcher':
                        tempAtBat[12] = item[1] 
                    elif item[0] == 'p_throws':
                        tempAtBat[13] = item[1] 
                    elif item[0] == 'des':
                        tempAtBat[14] = item[1] 
                    elif item[0] == 'des_es':
                        tempAtBat[15] = item[1] 
                    elif item[0] == 'event_num':
                        tempAtBat[16] = item[1] 
                    elif item[0] == 'event':
                        tempAtBat[17] = item[1] 
                    elif item[0] == 'event_es':
                        tempAtBat[18] = item[1] 
                    elif item[0] == 'home_team_runs':
                        tempAtBat[19] = item[1] 
                    elif item[0] == 'away_team_runs':
                        tempAtBat[20] = item[1] 
                    elif item[0] == 'score':
                        tempAtBat[21] = item[1] 
                    elif item[0] == 'play_guid':
                        tempAtBat[22] = item[1]                             
                    elif item[0] == 'event2':
                        tempAtBat[23] = item[1]                             
                    elif item[0] == 'event2_es':
                        tempAtBat[24] = item[1] 
                    elif item[0] == 'event3':
                        tempAtBat[25] = item[1]                             
                    elif item[0] == 'event3_es':
                        tempAtBat[26] = item[1] 
                    elif item[0] == 'event4':
                        tempAtBat[27] = item[1]                             
                    elif item[0] == 'event4_es':
                        tempAtBat[28] = item[1]                             

                if tempAtBat[16] == None:
                    tempAtBat[16] = mastEventNum
                    mastEventNum += 1

                if len(atbat.items()) > 26:
                    badAtBats.append(tempAtBat)
                else:
                    allAtBats.append(tempAtBat)
                    atBats.append(tempAtBat)                                            
                    #iterate through each event
                    for event in atbat.iterchildren():                        
                        #add pitch
                        if event.tag == 'pitch':
                            tempPitch = [gameID,
                                         tempAtBat[3]                                                                      
                                        ]
                            for i in range(0,42):
                                tempPitch.append(None)

                        #pitch data is pretty variable
                        #so it ended up being easiest to just spell it out explicitly
                            for item in event.items():
                                if item[0] == 'des':
                                    tempPitch[2] = item[1]
                                elif item[0] == 'des_es':
                                    tempPitch[3] = item[1]
                                elif item[0] == 'id':
                                    tempPitch[4] = item[1]
                                elif item[0] == 'type':
                                    tempPitch[5] = item[1]
                                elif item[0] == 'tfs':
                                    tempPitch[6] = item[1]
                                elif item[0] == 'tfs_zulu':
                                    tempPitch[7] = item[1].                                                        replace('Z','').                                                        replace('T',' ')
                                elif item[0] == 'x':
                                    tempPitch[8] = item[1]
                                elif item[0] == 'y':
                                    tempPitch[9] = item[1]
                                elif item[0] == 'event_num':
                                    tempPitch[10] = item[1]
                                elif item[0] == 'sv_id':
                                    tempPitch[11] = item[1]
                                elif item[0] == 'play_guid':
                                    tempPitch[12] = item[1]
                                elif item[0] == 'start_speed':
                                    tempPitch[13] = item[1]
                                elif item[0] == 'end_speed':
                                    tempPitch[14] = item[1]
                                elif item[0] == 'sz_top':
                                    tempPitch[15] = item[1]
                                elif item[0] == 'sz_bot':
                                    tempPitch[16] = item[1]
                                elif item[0] == 'pfx_x':
                                    tempPitch[17] = item[1]
                                elif item[0] == 'pfx_z':
                                    tempPitch[18] = item[1]
                                elif item[0] == 'px':
                                    tempPitch[19] = item[1]
                                elif item[0] == 'pz':
                                    tempPitch[20] = item[1]
                                elif item[0] == 'x0':
                                    tempPitch[21] = item[1]
                                elif item[0] == 'y0':
                                    tempPitch[22] = item[1]
                                elif item[0] == 'z0':
                                    tempPitch[23] = item[1]
                                elif item[0] == 'vx0':
                                    tempPitch[24] = item[1]
                                elif item[0] == 'vy0':
                                    tempPitch[25] = item[1]
                                elif item[0] == 'vz0':
                                    tempPitch[26] = item[1]
                                elif item[0] == 'ax':
                                    tempPitch[27] = item[1]
                                elif item[0] == 'ay':
                                    tempPitch[28] = item[1]
                                elif item[0] == 'az':
                                    tempPitch[29] = item[1]
                                elif item[0] == 'break_y':
                                    tempPitch[30] = item[1]
                                elif item[0] == 'break_angle':
                                    tempPitch[31] = item[1]
                                elif item[0] == 'break_length':
                                    tempPitch[32] = item[1]
                                elif item[0] == 'pitch_type':
                                    tempPitch[33] = item[1]
                                elif item[0] == 'type_confidence':
                                    tempPitch[34] = item[1]
                                elif item[0] == 'zone':
                                    tempPitch[35] = item[1]
                                elif item[0] == 'nasty':
                                    tempPitch[36] = item[1]
                                elif item[0] == 'spin_dir':
                                    tempPitch[37] = item[1]
                                elif item[0] == 'spin_rate':
                                    tempPitch[38] = item[1]
                                elif item[0] == 'cc':
                                    tempPitch[39] = item[1]
                                elif item[0] == 'mt':
                                    tempPitch[40] = item[1]
                                elif item[0] == 'on_1b':
                                    tempPitch[41] = item[1]
                                elif item[0] == 'on_2b':
                                    tempPitch[42] = item[1]
                                elif item[0] == 'on_3b':
                                    tempPitch[43] = item[1]

                            if tempPitch[10] == None:
                                tempPitch[10] = mastEventNum
                                mastEventNum += 1                                    

                            pitches.append(tempPitch)
                            #but if it still ends up weird, store it in a separate array
                            if len(event.items()) > 44:
                                fuckedPitches.append(tempPitch)
                            else:
                                allPitches.append(tempPitch)

                        #add runner
                        elif event.tag == 'runner':
                            tempRunner = [gameID,
                                         tempAtBat[3]                                                                         
                                         ]
                            score = None
                            rbi = None
                            earned = None
                            event_num = None

                            #iterate runner event attributes
                            for item in event.items():
                                if item[0] == 'score':
                                    score = 1
                                elif item[0] == 'rbi':
                                    rbi = 1
                                elif item[0] == 'earned':
                                    earned = 1
                                elif item[0] == 'event_num':
                                    event_num = item[1]
                                elif item[0].find('zulu') > -1:
                                    tempRunner.append(item[1].                                                      replace('Z','').                                                      replace('T',' '))                                        
                                else:
                                    tempRunner.append(item[1])

                            if event_num == None:
                                event_num = mastEventNum
                                mastEventNum += 1

                            tempRunner.append(event_num)
                            tempRunner.append(score)
                            tempRunner.append(rbi)
                            tempRunner.append(earned)                            
                            runners.append(tempRunner)
                            allRunners.append(tempRunner)

                        #add pick off
                        elif event.tag == 'po':
                            tempPO = [gameID,
                                      tempAtBat[3]                                                                         
                                     ]

                            playGUID = None
                            catcher = None
                            des_es = None
                            event_num = None
                            #iterate pick off event attributes
                            for item in event.items():
                                if item[0] == 'event_num':
                                    event_num = item[1]
                                elif item[0] == 'play_guid':
                                    playGUID = item[1]
                                elif item[0].find('zulu') > -1:
                                    tempPO.append(item[1].                                                  replace('Z','').                                                  replace('T',' '))     
                                elif item[0] == 'catcher':
                                    catcher = 1
                                elif item[0] == 'des_es':
                                    des_es = item[1]
                                else:
                                    tempPO.append(item[1])

                            if event_num == None:
                                event_num = mastEventNum
                                mastEventNum += 1

                            tempPO.insert(3,des_es)
                            tempPO.insert(4,event_num)
                            tempPO.append(playGUID)
                            tempPO.append(catcher)
                            pos.append(tempPO)

                            allPos.append(tempPO)
                        else:
                            print(event.tag)                            

    return atBats, pitches, runners, pos, mastEventNum
                        
#parse the game.xml file
#input: URL for game/game.xml
#output: game, teams, stadium arrays
def parseGame(gameURL):
    gameData = []
    teams = []
    stadium = []
    tree = etree.parse(gameURL)
    
    root = tree.getroot()

    
    gameID = gameURL[gameURL.find('year_'):].                replace('year_','').                replace('month_','').                replace('day_','').                replace('/game.xml','')
    gameData.append(gameID)
    gameData.append(gameID[:10])
    
    for game in root.iter('game'):
        #add game metadata
        for item in game.items():
            if item[0] == 'game_pk':
                gameData.append(int(item[1]))
            elif item[0].find('zulu') > -1:
                gameData.append(item[1].replace('Z','').replace('T',' '))             
            else:
                gameData.append(item[1])
            
        for child in game.iterchildren():
            if child.tag == 'team':
                tempTeam = []
                tempTeam.append(gameID)
                #add game id to team record
                
                #add items to team records
                for item in child.items():    
                    
                    teamInts = ['w','l','division_id','league_id']
                    #add team data to game                                        
                    tiBool = 0
                    for ti in teamInts:
                        if ti == item[0]:
                            tiBool = 1
                    
                    if item[0] == 'id':
                        gameData.append(int(item[1]))
                        tempTeam.append(int(item[1]))
                    elif tiBool == 1:
                        try:
                            tempTeam.append(int(item[1]))
                        except:
                            tempTeam.append(None)
                    elif item[0].find('zulu') > -1:
                        tempTeam.append(item[1].                                        replace('Z','').                                        replace('T',' '))   
                    else:
                        tempTeam.append(item[1])
                    
                teams.append(tempTeam)
                allTeams.append(tempTeam)
                
            elif child.tag == 'stadium':                
                #add items to stadium record
                stadium.append(gameID)
                for item in child.items():                                                                         
                    #add stadium id to game                    
                    if item[0] == 'id':
                        gameData.append(int(item[1]))
                        stadium.append(int(item[1]))
                    elif item[0].find('zulu') > -1:
                        stadium.append(item[1].                                       replace('Z','').                                       replace('T',' '))                         
                    else:
                        stadium.append(item[1])  
    
    '''
    #api I was using went down
    
    rise, tempLights = getSunlight(stadium)
    '''
    rise = []
    tempLights = []
    for i in range(0,5):
        rise.append('N/A')        
        tempLights.append('N/A')
    #add sun rise/set data to stadiumGame 
    for ri in rise:
        stadium.append(ri)
    
    for tl in tempLights:
        allLights.append(tl)
          
    
    allStadiums.append(stadium)
    allGames.append(gameData)
    if len(allGames)%100 == 0:
        print('%s games processed so far...' % len(allGames))
    return gameData, teams, stadium 
    
#parse the players.xml file
#input: game/players.xml url
#output: players array
def parsePlayers(playersURL):
    players = []
    coaches = []
    umpires = []
    
    tree = etree.parse(playersURL)
    root = tree.getroot()
    gameID = playersURL[playersURL.find('year_'):].                 replace('year_','').                 replace('month_','').                 replace('day_','').                 replace('/players.xml','')
    
    #iterate game
    for game in root.iter('game'):
        #set game metadata
        gameVenue = ''
        gameDate = ''
        for item in game.items():
            if item[0] == 'venue':
                gameVenue = item[1]
            elif item[0] == 'date':
                gameDate = item[1]
        
        #iterate through teams/umpires
        for team in game.iterchildren():            
            if team.tag == 'team':
                #set team metadata
                teamType = ''
                teamID = ''
                teamName = ''
            
                for item in team.items():
                    if item[0] == 'type':
                        teamType = item[1]
                    elif item[0] == 'id':
                        teamID = item[1]
                    elif item[0] == 'name':
                        teamName = item[1]            
                
                #iterate through players
                for player in team.iterchildren():                                        
                    if player.tag == 'player':
                        tempPlayer = [gameID,
                                      teamType
                                     ]                    
                        
                        wins = 0
                        losses = 0
                        era = None
                        gamePosition = None
                        currentPosition = None
                        batOrder = None
                        bats = ''
                        team_abbrev = None
                        team_id = None
                        parent_team_abbrev = None
                        parent_team_id = None
                        
                        #sets player fields that should be added as int
                        playerint = ['id','num','hr','rbi']
                        #iterate player attributes
                        for item in player.items():
                            plBool = 0
                            
                            for pl in playerint:
                                if pl == item[0]:
                                    plBool = 1
                            if item[0] == 'avg':
                                tempPlayer.append(float(item[1]))
                            elif item[0] == 'wins':
                                wins = int(item[1])
                            elif item[0] == 'bats':
                                bats = item[1]
                            elif item[0] == 'team_abbrev':
                                team_abbrev = item[1]
                            elif item[0] == 'team_id':
                                team_id = item[1]
                            elif item[0] == 'parent_team_abbrev':
                                parent_team_abbrev = item[1]
                            elif item[0] == 'parent_team_id':
                                parent_team_id = item[1]
                            elif item[0] == 'current_position':
                                currentPosition = item[1]
                            elif item[0] == 'game_position':
                                gamePosition = item[1]
                            elif item[0] == 'losses':
                                losses = int(item[1])
                            elif item[0] == 'bat_order':
                                batOrder = item[1]
                            elif item[0] == 'era':
                                if item[1].find('-') > -1:
                                    era = -1
                                else:
                                    era = item[1]                                    
                            elif item[0].find('zulu') > -1:
                                tempPlayer.append(item[1].                                                  replace('Z','').                                                  replace('T',' '))                                   
                            elif plBool == 1:
                                try:
                                    tempPlayer.append(int(item[1]))
                                except:
                                    tempPlayer.append(None)
                            else:
                                tempPlayer.append(item[1])
                        
                        if team_abbrev == None:
                            team_abbrev = teamID
                        tempPlayer.insert(8,bats)
                        tempPlayer.insert(10,currentPosition)
                        tempPlayer.insert(12,team_abbrev)
                        tempPlayer.insert(13,team_id)
                        tempPlayer.insert(14,parent_team_abbrev)
                        tempPlayer.insert(15,parent_team_id)
                        tempPlayer.insert(16,batOrder)
                        tempPlayer.insert(17,gamePosition)
                        tempPlayer.append(wins)
                        tempPlayer.append(losses)
                        tempPlayer.append(era)
                        if (len(tempPlayer[3])) > 1:
                            players.append(tempPlayer)
                            allPlayers.append(tempPlayer)
                
                    #iterate coaches
                    elif player.tag == 'coach':
                        tempCoach = [gameID,
                                     teamType,
                                     teamID,
                                     teamName
                                     ]
                        #iterate coach attributes
                        for item in player.items():
                            if item[0] == 'id' or item[0] == 'num':
                                try:
                                    tempCoach.append(int(item[1]))
                                except:
                                    tempCoach.append(None)
                            elif item[0].find('zulu') > -1:
                                tempPlayer.append(item[1].                                                  replace('Z','').                                                  replace('T',' '))  
                            else:
                                tempCoach.append(item[1])
                
                        coaches.append(tempCoach)
                        allCoaches.append(tempCoach)
                        
            #iterate umpires
            elif team.tag == 'umpires':
                for ump in team.iterchildren():
                    tempUmp = [gameID,
                              ] 
                    #iterate umpire attributes
                    first = ''
                    last = ''
                    for item in ump.items():
                        
                        if item[0] == 'id':
                            tempUmp.append(int(item[1]))
                        elif item[0] == 'first':
                            first = item[1]
                        elif item[0] == 'last':
                            last = item[1]
                        elif item[0].find('zulu') > -1:
                            tempPlayer.append(item[1].                                              replace('Z','').                                              replace('T',' '))  
                        else:
                            tempUmp.append(item[1])
                                            
                    if first == '' and last == '':
                        umpName = tempUmp[2].split(' ')
                        for i in range(0, len(umpName)):
                            if i == (len(umpName)-1):
                                last = umpName[i]
                            else:
                                first+= umpName[i]
                                first+= ' '
                        first.strip()
                        
                    tempUmp.append(first)
                    tempUmp.append(last)
                    umpires.append(tempUmp)
                    allUmpires.append(tempUmp)                        

    return(players,coaches,umpires)

#uses stadium info to call other methods that get sunlight data
#input stadium array
#output array of sunrise/set info, array of sun location in 5 minute intervals
def getSunlight(stadium):    
    ldate = stadium[0][5:7] + '/' + stadium[0][8:10] + '/' + stadium[0][:4]
    try:
        rise = getSunRiseSet(stadium,ldate)   
    except:
        print('Unable to find sunrise/set for: ' + stadium[4].strip())
        rise = []
    try:
        lights = getSunTimes(stadium,ldate)    
    except:
        print('Unable to find lights by time of day for: ' + stadium[4].strip())
        lights = []
    for ls in lights:
        ls.insert(0,stadium[1])
        ls.insert(0,stadium[0])
        
    return rise, lights

#gets the sunrise and set data for each game day and location
#input: stadium array, ldate (date of game in format MM/DD/YYYY)
#output: array of time for begin civil twilight, sunrise, peak, sunset, end civil twilight
def getSunRiseSet(stadium,ldate):
    riseURL = 'http://api.usno.navy.mil/rstt/oneday?date=' + ldate +    '&loc=' + stadium[4].                strip().                replace(' ','%20').                replace('Ft.','Fort').                replace('Flushing','Queens').                replace('Viera','Melbourne')
    riseSet = ['','','','','']

    re = requests.get(riseURL)
    
    test = json.loads(re.text)
    try:
        for t in test['sundata']:
            if t['phen'] == 'BC':
                riseSet[4] = t['time'].strip(' DT')
            elif t['phen'] == 'R':
                riseSet[3] = t['time'].strip(' DT')
            elif t['phen'] == 'U':
                riseSet[2] = t['time'].strip(' DT')
            elif t['phen'] == 'S':
                riseSet[1] = t['time'].strip(' DT')
            else:
                riseSet[0] = t['time'].strip(' DT')
    except:
        print('Unable to find sunrise/set for: ' + stadium[4].strip())
    return(riseSet)
        
#gets the sun location for a game in 5 minute intervals
#input: stadium array, ldate (date of game in format MM/DD/YYYY)
#output: array of time/location information   
def getSunTimes(stadium,ldate):    
    lightTimes = []    
    sunURL = 'http://aa.usno.navy.mil/cgi-bin/aa_altazw.pl?form=1&body=10&year=' +                stadium[0][:4] +                '&month=' + stadium[0][5:7] +                '&day=' + stadium[0][8:10] +                '&intv_mag=5&state=' + stadium[4].                                                split(',')[1].                                                strip().                                                replace(' ','%20') +                '&place=' + stadium[4].split(',')[0].                                                    strip().                                                    replace(' ','%20').                                                    replace('Ft.','Fort').                                                    replace('Flushing','Brooklyn')
                
    re = requests.get(sunURL)
    rTree = html.fromstring(re.content) 
    #begin iterating through response from Navy site
    for rt in rTree.iterchildren():
        if rt.tag == 'body':
            for bt in rt.iterchildren():
                if bt.tag == 'pre':
                    yn = 0
                    #this loop finds the bottom level elements
                    for line in bt.text.split('\n'):
                        #first date will have '0X:XX'
                        if line[:1] == '0':
                            yn = 1
                        #there are a few blank lines after the times. Don't need those
                        elif line[:1] == ' ':
                            yn = 0                            
                        if yn == 1:
                            l = line.split()
                            #sometimes the blank lines get picked up anyway
                            if len(l) == 3:                                
                                #sets datetime value
                                ldt = ldate[6:]+ '-' +                                         ldate[:2] + '-' +                                         ldate[3:5] + ' ' +                                         l[0].strip() + ':00'                                
                                #l[0] is the time
                                #l[1] is the height of the sun from the horizon 
                                    #(<0 means it's dark, 90 is noon)
                                #l[2] is the direction of the sun from due North
                                lightTimes.append([l[0].strip(),
                                                   l[1].strip(),
                                                   l[2].strip(),
                                                   ldt
                                                  ])

    return lightTimes
 
#either inserts records into db, or writes to file for each table
#input: dbFile (either 'db' to write to database, or something else to write to file)
#output: none
def loopInserts(dbFile):
    loopTables = [[allTables[0],allGames],
                  [allTables[9],allCoaches],
                  [allTables[10],allAtBats],
                  #[allTables[7],allLights],
                  [allTables[6],allPos],
                  [allTables[3],allRunners],
                  [allTables[4],allPlayers],
                  [allTables[5],allPitches],
                  [allTables[2],allStadiums],
                  [allTables[1],allTeams],
                  [allTables[8],allUmpires],
                  [allTables[11],allBoxScore],
                  [allTables[12],allLineScore],
                  [allTables[13],allLineScoreInning],
                  [allTables[14],allPitchers],
                  [allTables[15],allBatters],
                  [allTables[16],allActions]
                 ]
    
    i = 0
    for lt in loopTables:
        print(str(i) + '\t' + lt[0])
        i+=1
        if len(lt[1]) > 0:
            #get table fields
            tableFields = getColumns(lt[0])
            if dbFile == 'db':
                insertRecords(lt[0],lt[1],tableFields)
            else:
                writeOut(lt[0],lt[1],tableFields)
                filePath = 'C:\\Users\\evan.marcey\\Documents\\mlbStats\\' + lt[0] + '.csv'
                wExs = "LOAD DATA LOCAL INFILE '%s' INTO TABLE %s" % (filePath, lt[0])
                conn.execute(wExs)
        else:
            print('\tNo records found.')
    connection.commit()
    
#gets all columns from a given table
#input: tableName (string name of table)
#output: tableFields (array of fields for tableName)
def getColumns(tableName):
    conn.execute("SHOW COLUMNS FROM {tn}".format(tn=tableName))
    tableFields = []
    for row in conn.fetchall():
        tableFields.append(row['Field'])
    return tableFields

#delete data from one table using a where clause
#input: table name, where clause
#output: string verifying table has been deleted
def deleteOne(table,where):
    exs = "DELETE FROM {tn} WHERE {qn}".format(tn=table,qn=where)
    conn.execute(exs)    
    connection.commit()
    return(table + ' deleted.')

#easy method to delete all data from relevant tables
#input: none (uses allTables instantiated at the top)
#output: none
def deleteAll():
    for table in allTables:        
        deleted = deleteOne(table,'1=1')
        print(deleted)
        
#method to write 1 array to 1 table (uses connection instatiated above)
#input: table array with table name and field names; 
    #inArray - array of format matching table field names
#output: none
def insertRecords(tableName,inArray,tableFields):
    #creates execute statement
    #uses form VALUES (%s,%s,%s...) with #%s == #fields in row
    vVar = "%s"
    for i in range(0,len(inArray[0])-1):
        vVar+=",%s"       
    exs ="INSERT IGNORE INTO " + tableName +             " (" + ', '.join(tableFields) +             ") VALUES (" + vVar + ")"
    #execute statement
    try:
        conn.executemany(exs,inArray)    
    except:
        exs ="INSERT IGNORE INTO " + tableName +             " VALUES (" + vVar + ")"
        conn.executemany(exs,inArray)
    #commit is after loop bc I want to commit after there are no errors in the whole thing.

#method to write 1 array to 1 file
#input: table array with table name and field names;
    #inArray - array of format matching table field names
#output: none    
def writeOut(filePath,arrayName,tableFields):        
    #write records from in array
    with open(filePath, 'w') as of:
        ow = csv.writer(of,
                        lineterminator='\n',
                        quotechar='"'
                       )
        ow.writerow(tableFields)
        for ar in arrayName:
            ow.writerow(ar)

#pulls batAtBat records and URL errrors from file directory
#input: none
#output: distinct badAtBat URLs and distinct URLs from error URL 
def loadErrors():
    newErrorUrls = []
    newBadAtBats = []
    newBadPitches = []

    files = os.listdir(errorDir)

    for file in files:
        if file.find('urlErrors') != -1:
            with open(errorDir + file, 'r') as of:
                ow = csv.reader(of,
                                quotechar='"'
                               )
                for ar in ow:
                    if ar[0] != 'errors':
                        newErrorUrls.append(ar[0])

        elif file.find('badAtBat') != -1:
            with open(errorDir + file, 'r') as of:
                ow = csv.reader(of,
                                quotechar='"'
                               )
                for ar in ow:
                    if ar[0] != 'errors':
                        arUrl = 'http://gd2.mlb.com/components/game/mlb/year_' + ar[0][:5] +                                 'month_' + ar[0][5:8] +                                 'day_' + ar[0][8:10] + ar[0][10:]
                        newBadAtBats.append(arUrl)
        
        elif file.find('badPitches') != -1:
            with open(errorDir + file, 'r') as of:
                ow = csv.reader(of,
                                quotechar='"'
                               )
                for ar in ow:
                    if ar[0] != 'errors' and ar[0].find('2013') != -1:
                        arUrl = 'http://gd2.mlb.com/components/game/mlb/year_' + ar[0][:5] +                                 'month_' + ar[0][5:8] +                                 'day_' + ar[0][8:10] + ar[0][10:]
                        newBadPitches.append(arUrl)
        
        
        
    return getDistinct(newErrorUrls), getDistinct(newBadAtBats), getDistinct(newBadPitches)

#given an array, finds distinct values of that array
#input array
#output distinct array
def getDistinct(inArray):
    dist = []

    for nu in inArray:
        if len(dist) == 0:
            dist.append(nu)
        else:
            xx = 0
            for du in dist:
                if nu == du:
                    xx = 1
            if xx == 0:
                dist.append(nu)
            
    return dist

def selectRecords(tableName):
    ex2 = "SELECT * from {tn}".format(tn=tableName)
    conn.execute(ex2)
    return(conn.fetchall())

def runErrors():
    nErrors, nBadAtBats, nBadPitches = loadErrors()
    print(len(nErrors))
    for parentURL in nErrors:
        iterURL(parentURL)

    for parentURL in nBadAtBats:
        iterURL(parentURL)
        
def parseBox(boxUrl):
    gameID = boxUrl[boxUrl.find('year_'):].                replace('year_','').                replace('month_','').                replace('day_','').                replace('/boxscore.xml','')
    
    linescore = {}
    iLine = []
    boxGame = {}
    pitchers = []
    batters = []
    tree = etree.parse(boxUrl)
    root = tree.getroot()
    for item in root.items():
        boxGame[item[0]] = item[1]
    boxGame['game_id'] = gameID
    allBoxScore.append(prepArray('boxscore',boxGame))
    for r in root.iterchildren():
        if r.tag == 'linescore':            
            linescore['game_id'] = gameID
            for item in r.items():
                linescore[item[0]] = item[1]
            allLineScore.append(prepArray('linescore',linescore))
            for inningL in r.iterchildren():
                tempLine = {}
                tempLine['game_id'] = gameID
                for item in inningL.items():
                    tempLine[item[0]] = item[1]
                if tempLine['home'] == 'x':
                    tempLine['home'] = None
                if tempLine['away'] == 'x':
                    tempLine['away'] = None
                iLine.append(tempLine)
                allLineScoreInning.append(prepArray('linescore_inning',tempLine))
        elif r.tag == 'pitching':   
            home_away = r.items()[0][1]
            order = 1
            for pSide in r.iter('pitcher'):
                tempPitcher = {}
                tempPitcher['game_id'] = gameID
                tempPitcher['order'] = order
                tempPitcher['home_away'] = home_away
                order+=1
                for item in pSide.items():
                    tempPitcher[item[0]] = item[1]  
                if tempPitcher['era'].find('-') != -1:
                    tempPitcher['era'] = -1
                try:
                    tempPitcher['st'] = tempPitcher['s']
                except:
                    tempPitcher['st'] = None
                try:
                    tempPitcher['sum_bb'] = tempPitcher['s_bb']
                except:
                    tempPitcher['sum_bb'] = None
                try:
                    tempPitcher['sum_err'] = tempPitcher['s_er']
                except:
                    tempPitcher['sum_err'] = None
                pitchers.append(tempPitcher)
                allPitchers.append(prepArray('pitcher_box',tempPitcher))
                
        elif r.tag == 'batting':
            home_away = r.items()[0][1]
            order = 1
            for bSide in r.iter('batter'):
                tempBatter = {}
                tempBatter['game_id'] = gameID
                tempBatter['order'] = order
                tempBatter['home_away'] = home_away
                order+=1
                for item in bSide.items():
                    tempBatter[item[0]] = item[1]  
                batters.append(tempBatter)
                allBatters.append(prepArray('batter_box',tempBatter))
                      
    return boxGame, linescore, iLine, pitchers, batters
   
def runYesterday():
    yesterday = datetime.datetime.now()-datetime.timedelta(days=1)
    day = str(yesterday.day).zfill(2)
    year = yesterday.year
    month = str(yesterday.month).zfill(2)
    yUrl = ["http://gd2.mlb.com/components/game/mlb/year_%s/month_%s/day_%s/" % (year, month, day)]
    main(yUrl)

def recentDays():
    es = 'SELECT MAX(gameID) from game'
    conn.execute(es)
    stuff = conn.fetchall()[0]['MAX(gameID)']
    nyear = int(stuff[:4])
    nmonth = int(stuff[5:7])
    nday = int(stuff[8:10])
    ndt = datetime.datetime(nyear, nmonth, nday)+datetime.timedelta(days=1)
    yesterday = datetime.datetime.now()-datetime.timedelta(days=1)    
    yUrls = []

    while(ndt.date() <= yesterday.date()):
        day = str(ndt.day).zfill(2)
        year = ndt.year
        month = str(ndt.month).zfill(2)
        yUrl = "http://gd2.mlb.com/components/game/mlb/year_%s/month_%s/day_%s/" % (year, month, day)
        yUrls.append(yUrl)
        ndt = ndt+datetime.timedelta(days=1)

    main(yUrls)
    
def prepArray(tableName,inDict):
    
    columns = getColumns(tableName)
    tArray = []
    for i in range(0,len(columns)):
        tArray.append(None)
        
    for i in range(0,len(columns)):
        for record in inDict.keys():
            if record.strip() == columns[i].strip():
                tArray[i] = inDict[record]
        
    return(tArray)

def main(parentURLs):
    xTime = time.time()
    for url in parentURLs:
        iterURL(url)
    runTime = time.strftime("%Y%m%d_%H%M%S")
    
    print("There were %s URL errors found." % len(errorURLs))
    print("There were %s atBat errors found." % len(badAtBats))
    print("There were %s Pitch errors found." % len(fuckedPitches))
    print("See error logs for more details.")
    errorsFileName = 'C:\\Users\\evan.marcey\\Documents\\mlbStats\\error_logs\\urlErrors_' + str(runTime) +'.csv'
    writeOut(errorsFileName,errorURLs,['errors'])
    badAtBatsFileName = 'C:\\Users\\evan.marcey\\Documents\\mlbStats\\error_logs\\badAtBat_' + str(runTime) +'.csv'
    writeOut(badAtBatsFileName,badAtBats,['errors'])
    badPitchesFileName = 'C:\\Users\\evan.marcey\\Documents\\mlbStats\\error_logs\\badPitches_' + str(runTime) +'.csv'
    writeOut(badPitchesFileName,fuckedPitches,['errors'])
    
    yTime = time.time()
    print('%s seconds elapsed.' % round(yTime-xTime,0))
    xTime = yTime
    loopInserts('db')
    
    yTime = time.time()
    connection.close()

    print('%s seconds elapsed.' % round(yTime-xTime,0))
    
parentURLs = [
    'http://gd2.mlb.com/components/game/mlb/year_2017/month_01/',
    'http://gd2.mlb.com/components/game/mlb/year_2017/month_02/',
    'http://gd2.mlb.com/components/game/mlb/year_2017/month_03/',
    'http://gd2.mlb.com/components/game/mlb/year_2017/month_04/'
    ]
