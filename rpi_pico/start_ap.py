import network

ap_ssid = 'RLAP-Pico'
password = 'xxxxxxxx'

ap = network.WLAN(network.AP_IF)
ap.config(essid=ap_ssid, password=password)

try:
    ap.active(True)
    print(f'AP: {ap_ssid} started...')
except Exception as e:
    print("Error: ", e)

