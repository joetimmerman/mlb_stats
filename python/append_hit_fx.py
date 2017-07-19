import json
import mlbStats
import urllib.request
import time
from multiprocessing.dummy import Pool as ThreadPool

connection,conn = mlbStats.openConnection()

#First get a list of all gamePKs

start_time = time.time()
bad_urls = 0
full_data_urls = 0
no_data_urls = 0
query = 'SELECT game_pk from game'
conn.execute(query)
print('Finished execution')
game_pks = conn.fetchall()

base_url = 'http://statsapi.mlb.com/api/v1/game/%s/feed/color'
urls = []
for game in game_pks:
	urls.append(base_url % game['game_pk'])

def testURL(curr_url):
	try:
		with urllib.request.urlopen(curr_url) as url:
			print(curr_url)
			page = url.read().decode()
			#data = json.loads(url.read())
			if len(page) > 1000:
				pass
				#full_data_urls += 1
			else:
				pass
				#no_data_urls += 1
			return(page)
	except Exception  as e:
		pass
		#bad_urls += 1
		#print(e)

pool = ThreadPool(4)
results = pool.map(testURL, urls)
pool.close()
pool.join()

print(len(results))

for result in results:
	try:
		if result and len(result) > 1000:
			full_data_urls += 1
		else:
			no_data_urls += 1
	except Exception as e:
		print(str(e))




print('full: '+ str(full_data_urls))
print('full: '+ str(no_data_urls))
#print('bad: '+ str(bad_urls))

elapsed_time = time.time() - start_time
print(str(elapsed_time))