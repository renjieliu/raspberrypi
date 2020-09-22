* git clone --recursive https://github.com/RedisTimeSeries/RedisTimeSeries.git
* cd RedisTimeSeries/
* sudo nano ./deps/readies/paella/platform.py
	1.change the shebang to use python3
	2.change the `elif dist == 'debian'` to `elif dist in ['debian','unknown']`
	3.for Rpi0, add 
		`elif self.arch == 'armv61':
					self.arch = 'arm32v6'`	
		after
		`elif self.arch == 'armv7l':
					self.arch = 'arm32v7'`
				
			
* sudo nano ./deps/readies/paella/setup.py
	1. change `else` part to be the same as debian, as for raspberry pi, the dist is "unknown"
				`else:#same as debian
                self.apt_install(packs, group=group, _try=_try)`
			after `arch`
			
            `elif self.dist == 'arch':
                self.pacman_install(packs, group=group, _try=_try)`
            

			
* sudo ./system-setup.py
* make build
* cp /path/to/redistimeseries.so /var/lib/redis/
* sudo nano /etc/redis/redis.conf 
	1. add `loadmodule /var/lib/redis/redistimeseries.so` to the appropriate location
* sudo service redis-server restart 

---
Test, see if below command can be executed
---
- redis-cli
- TS.CREATE temperature:3:11 RETENTION 60 LABELS sensor_id 2 area_id 32
- TS.ADD temperature:3:11 1548149181 30
- TS.ADD temperature:3:11 1548149191 42
- TS.RANGE temperature:3:11 1548149180 1548149210 AGGREGATION avg 5









