import os
import time

username = "xxxx"
password = "xxxx"
domain = "xxx.com"
checkInterval = 3600 #by default, check once every hour
ipProvider = "ifconfig.me" #this is the service provider to check IP

getIP_command = "curl " + ipProvider # this is to get the ip
prev = ""

while True:
	curr = os.popen(getIP_command).read() # get current ip
	if curr != prev: # in case the ip has changed
		postCommand = "curl -X POST https://"+ username + ":" + password + "@domains.google.com/nic/update?hostname=" + domain + "&myip=" + curr +  "; sleep 2; "
		os.system(postCommand) #update Google Domain ip.
		prev = curr
	time.sleep(checkInterval) 


