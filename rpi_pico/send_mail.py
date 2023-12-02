# uMail (MicroMail) for MicroPython
# Copyright (c) 2018 Shawwwn <shawwwn1@gmai.com>
# https://github.com/shawwwn/uMail/tree/master
# License: MIT
import usocket

import network
import socket
from time import sleep
from picozero import pico_temp_sensor, pico_led
import machine
import urequests




DEFAULT_TIMEOUT = 10 # sec
LOCAL_DOMAIN = '127.0.0.1'
CMD_EHLO = 'EHLO'
CMD_STARTTLS = 'STARTTLS'
CMD_AUTH = 'AUTH'
CMD_MAIL = 'MAIL'
AUTH_PLAIN = 'PLAIN'
AUTH_LOGIN = 'LOGIN'

class SMTP:
    def cmd(self, cmd_str):
        sock = self._sock;
        sock.write('%s\r\n' % cmd_str)
        resp = []
        next = True
        while next:
            code = sock.read(3)
            next = sock.read(1) == b'-'
            resp.append(sock.readline().strip().decode())
        return int(code), resp

    def __init__(self, host, port, ssl=False, username=None, password=None):
        import ussl
        self.username = username
        addr = usocket.getaddrinfo(host, port)[0][-1]
        sock = usocket.socket(usocket.AF_INET, usocket.SOCK_STREAM)
        sock.settimeout(DEFAULT_TIMEOUT)
        sock.connect(addr)
        if ssl:
            sock = ussl.wrap_socket(sock)
        code = int(sock.read(3))
        sock.readline()
        assert code==220, 'cant connect to server %d, %s' % (code, resp)
        self._sock = sock

        code, resp = self.cmd(CMD_EHLO + ' ' + LOCAL_DOMAIN)
        assert code==250, '%d' % code
        if not ssl and CMD_STARTTLS in resp:
            code, resp = self.cmd(CMD_STARTTLS)
            assert code==220, 'start tls failed %d, %s' % (code, resp)
            self._sock = ussl.wrap_socket(sock)

        if username and password:
            self.login(username, password)

    def login(self, username, password):
        self.username = username
        code, resp = self.cmd(CMD_EHLO + ' ' + LOCAL_DOMAIN)
        assert code==250, '%d, %s' % (code, resp)

        auths = None
        for feature in resp:
            if feature[:4].upper() == CMD_AUTH:
                auths = feature[4:].strip('=').upper().split()
        assert auths!=None, "no auth method"

        from ubinascii import b2a_base64 as b64
        if AUTH_PLAIN in auths:
            cren = b64("\0%s\0%s" % (username, password))[:-1].decode()
            code, resp = self.cmd('%s %s %s' % (CMD_AUTH, AUTH_PLAIN, cren))
        elif AUTH_LOGIN in auths:
            code, resp = self.cmd("%s %s %s" % (CMD_AUTH, AUTH_LOGIN, b64(username)[:-1].decode()))
            assert code==334, 'wrong username %d, %s' % (code, resp)
            code, resp = self.cmd(b64(password)[:-1].decode())
        else:
            raise Exception("auth(%s) not supported " % ', '.join(auths))

        assert code==235 or code==503, 'auth error %d, %s' % (code, resp)
        return code, resp

    def to(self, addrs, mail_from=None):
        mail_from = self.username if mail_from==None else mail_from
        code, resp = self.cmd(CMD_EHLO + ' ' + LOCAL_DOMAIN)
        assert code==250, '%d' % code
        code, resp = self.cmd('MAIL FROM: <%s>' % mail_from)
        assert code==250, 'sender refused %d, %s' % (code, resp)

        if isinstance(addrs, str):
            addrs = [addrs]
        count = 0
        for addr in addrs:
            code, resp = self.cmd('RCPT TO: <%s>' % addr)
            if code!=250 and code!=251:
                print('%s refused, %s' % (addr, resp))
                count += 1
        assert count!=len(addrs), 'recipient refused, %d, %s' % (code, resp)

        code, resp = self.cmd('DATA')
        assert code==354, 'data refused, %d, %s' % (code, resp)
        return code, resp


    def write(self, content):
        self._sock.write(content)

    def send(self, content=''):
        if content:
            self.write(content)
        self._sock.write('\r\n.\r\n') # the five letter sequence marked for ending
        line = self._sock.readline()
        return (int(line[:3]), line[4:].strip().decode())

    def quit(self):
        self.cmd("QUIT")
        self._sock.close()
        



######################################################################### 
#########################################################################



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
ssid_pwd = 'xxxxxxxx'

ip = connect(ssid, ssid_pwd)
public_ip = get_public_ip()



if public_ip:
    print("Public IP:", public_ip)
    # def __init__(self, host, port, ssl=False, username=None, password=None):
    smtp = SMTP('smtp.gmail.com', 465, ssl=True) #, username='', password='')
    
    login = 'xxxx@gmail.com'
    password = 'xxxxxxxxxxxxxx'
    smtp.login(login, password)
    
    mailTo = 'xxxx@gmail.com'
    subject = 'This is a Test mail from Rpi Pico'
    content = 'Line1..\n Line2..'
    
    smtp.to(mailTo)

    smtp.write(f"Subject: {subject}\n") # add line break after the first line - to make the first line as Subject.
    smtp.write(f"{content}\n")
    
    smtp.send()
    smtp.quit()        

else:
    print("Failed to get public IP")     
        




