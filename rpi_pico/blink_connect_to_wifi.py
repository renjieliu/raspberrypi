from machine import Pin, Timer
import time
import network
import socket
import urequests

# timer.init(freq=1, mode=Timer.PERIODIC, callback=led_on_off )




def led_blink(interval = 0.05):
    led = Pin("LED", Pin.OUT)
    led.on()  # a method instead of setting the value
    time.sleep(interval)
    led.off() # turn it off again.
    time.sleep(interval)


def connect(ssid, pwd):
    #Connect to WLAN
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)
    #wlan.disconnect() # start a clean connection 
    wlan.connect(ssid, pwd)
    led_blink(0.08)
    while wlan.isconnected() == False:
        led_blink(0.08) # 0.08s interval
        print('Waiting for connection...')
        time.sleep(1)
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



ssid = 'C9RBL'
pwd = 'F02220B87C59FDE2'

led = Pin("LED", Pin.OUT)
ip = connect(ssid, pwd)

public_ip = get_public_ip()

if public_ip:
    print("Public IP:", public_ip)
    led.on() # set the final state as on
else:
    led.off() # set the LED off if failed to get public address
    print("Failed to get public IP")

   








