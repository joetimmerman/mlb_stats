import json
import mlbStats
import urllib.request

connection,conn = mlbStats.openConnection()

#First get a list of all gamePKs

bad_urls = 0
good_urls = 0
query = 'SELECT game_pk from game'
conn.execute(query)
print('Finished execution')
game_pks = conn.fetchall()

base_url = 'http://statsapi.mlb.com/api/v1/game/%s/feed/color'

for game in game_pks:
	curr_url = base_url % game['game_pk']
	print(curr_url)
	try:
		with urllib.request.urlopen(curr_url) as url:
			print(curr_url)
			print(url.read().decode())
			#data = json.loads(url.read())
			good_urls += 1
	except Exception  as e:
		bad_urls += 1
		print(e)

print('good: '+ str(good_urls))
print('bad: '+ str(bad_urls))

