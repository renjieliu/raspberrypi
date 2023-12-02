import network
import socket
from time import sleep
from picozero import pico_temp_sensor, pico_led
import machine
import urequests

ssid = 'wifi_ssid'
password = 'xxxxxxxxxxxxx'

def connect():
    #Connect to WLAN
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)
    wlan.connect(ssid, password)
    while wlan.isconnected() == False:
        print('Waiting for connection...')
        sleep(1)
    ip = wlan.ifconfig()[0]
    print(f'Connected on {ip}')
    return ip



def open_socket(ip):
    # Open a socket
    address = (ip, 2040)
    connection = socket.socket()
    connection.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    connection.bind(address)
    connection.listen(1)
    print(connection)
    return connection


def webpage(temperature, state):
    #Template HTML
    html = f"""
            <!DOCTYPE html>
            <html>
            <form action="./lighton">
            <input type="submit" value="Light on" />
            </form>
            <form action="./lightoff">
            <input type="submit" value="Light off" />
            </form>
            <p>LED is {state}</p>
            <p>Temperature is {temperature}</p>
            </body>
            </html>
            """
    return html

def serve(connection):
    #Start a web server
    state = 'OFF'
    pico_led.off()
    temperature = 0
    while True:
        client = connection.accept()[0]
        print('client -', client)
        request = client.recv(1024)
        request = str(request)
        try:
            request = request.split()[1]
        except IndexError:
            pass
        if request == '/lighton?':
            pico_led.on()
            state = 'ON'
        elif request =='/lightoff?':
            pico_led.off()
            state = 'OFF'
        temperature = pico_temp_sensor.temp
        html = webpage(temperature, state)
        client.send('HTTP/1.1 200 OK\n') 
        client.send('Content-Type: text/html\n')
        client.send('Connection: close\n\n')
        client.sendall(html.encode('utf-8'))
        client.close()


def get_public_ip():
    try:
        response = urequests.get('http://httpbin.org/ip')
        ip = response.json()['origin']
        response.close()
        return ip
    except Exception as e:
        print("Error:", e)
        return None
        


ip = connect()
public_ip = get_public_ip()
if public_ip:
    print("Public IP:", public_ip)
    #connection = open_socket(ip)
    #serve(connection)
else:
    print("Failed to get public IP")




    






