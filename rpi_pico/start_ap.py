import network

ap_ssid = 'RLAP-Pico'
password = '12345678.'

ap = network.WLAN(network.AP_IF)
ap.config(essid=ap_ssid, password=password)

try:
    ap.active(True)
    print(f'AP: {ap_ssid} started...')
except Exception as e:
    print("Error: ", e)

