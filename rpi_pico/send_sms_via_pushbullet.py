import network
import urequests
import time


def connect(ssid, ssid_pwd):
    #Connect to WLAN
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)
    wlan.connect(ssid, ssid_pwd)
    while wlan.isconnected() == False:
        print('Waiting for connection...')
        sleep(1)
    ip = wlan.ifconfig()[0]
    print(f'Connected on {ip}')
    return ip



def get_public_ip():
    try:
        response = urequests.get('http://httpbin.org/ip')
        ip = response.json()['origin']
        response.close()
        return ip
    except Exception as e:
        print("Error:", e)
        return None

ssid = 'wifi_ssid'
ssid_pwd = 'xxxxxxx'

ip = connect(ssid, ssid_pwd)
public_ip = get_public_ip()

currentTime = ".".join([str(t) for t in time.localtime()[:-2]]) # take out the last 2 parts, weekday and yearday

if public_ip:
    print("public_ip: ", public_ip)
    url = 'https://api.pushbullet.com/v2/texts'
    
    post_headers = {'Access-Token': 'xxxxxxxxxxxxxx',
                   'Content-Type': 'application/json'
                   }
    
    post_data = '''
        {"data":
            {"addresses":["+1xxxxxxx"] , 
             "message":"This is a message from Rpi Pico, current time is {}" , 
             "target_device_iden":"xxxxxxxxxxxx"
            }
        }
        '''.replace('{}', currentTime)
        

    response = urequests.post(url, headers = post_headers, data=post_data)
    print(response.content)
    

else:
    print("Failed to get public IP")   







