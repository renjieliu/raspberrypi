import datetime
import time

while True:
	f = open('./running.txt', 'a')

	f.write(str(datetime.datetime.now())+'\n')
	print('OK')	
	time.sleep(5)
	
	f.close()

