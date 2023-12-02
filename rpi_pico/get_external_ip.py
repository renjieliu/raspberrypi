import network
import socket
from time import sleep
import urequests


def connect(ssid, pwd):
    #Connect to WLAN
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)
    wlan.connect(ssid, pwd)
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
pwd = 'xxxxxxxx'

ip = connect(ssid, pwd)
public_ip = get_public_ip()

if public_ip:
    print("Public IP:", public_ip)
else:
    print("Failed to get public IP")




    







