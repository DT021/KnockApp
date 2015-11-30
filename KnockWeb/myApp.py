from gevent import monkey
monkey.patch_all()

from flask import Flask, render_template, session, request
from flask.ext.socketio import SocketIO, emit, join_room, leave_room, \
    close_room, disconnect
import pymongo
from pymongo import MongoClient
import json
from bson import json_util
from bson.json_util import dumps

import time
from threading import Thread

# QR code
import pyqrcode
import base64
import io
import ast

from apns import APNs, Frame, Payload #https://github.com/djacobs/PyAPNs

app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'


# apns = APNs(use_sandbox=True, cert_file='Certificates/PushCert.pem', key_file='Certificates/PushKey.pem')

# # Send a notification
# token_hex = '93054f6a5dcc6c8590dd2425780462d3197185fa5247a71f62a72175f6b80a29'
# payload = Payload(alert="Hello World!", sound="default", badge=1)
# apns.gateway_server.send_notification(token_hex, payload)


socketio = SocketIO(app)

thread = None

tokens=[]

def background_thread():
    print 'background_thread'
    count = 0
    while True:
        with open("download.png", "rb") as image_file:
            encoded_string = base64.b64encode(image_file.read())
            socketio.emit('direction',
                      {'data': encoded_string, 'direction':'Turn Left'},
                      namespace='/socketiotest')
        count += 1
        time.sleep(2)

@app.route("/")
def index():

    global thread
    if thread is None:
        thread = Thread(target=background_thread)
        thread.start()
    return render_template("index.html")

@app.route("/device/")
def saveDeviceToken():
    try:
        global tokens
        token = request.args.get('token')
        token = json.dumps(token, default=json_util.default)
        token = ast.literal_eval(token)
        tokens.append(token)
        tokens = list(set(tokens))
        print tokens
    except Exception:
        print "exception occured"
    return "Device token saved."

@socketio.on('connect', namespace='/socketiotest')
def test_connect():
    pass

@socketio.on('jsonData', namespace='/socketiotest')
def getJsonData(message):
    try:
        message = json.dumps(message, default=json_util.default)
        message = ast.literal_eval(message)
        data = message.get('jsonData')
        print data
        global tokens
        # tokens.append('93054f6a5dcc6c8590dd2425780462d3197185fa5247a71f62a72175f6b80a29')
        apns = APNs(use_sandbox=True, cert_file='Certificates/PushCert.pem', key_file='Certificates/PushKey.pem')
        payload = Payload(alert="Hello World!", sound="default", badge=1)

        frame = Frame()
        identifier = 1
        expiry = time.time()+3600
        priority = 10

        for token in tokens:
            apns.gateway_server.send_notification(token, payload)
    except Exception:
        print "exception occured"

if __name__ == "__main__":
    # app.run(host='0.0.0.0',port=5000,debug=True)
    app.debug = True
    socketio.run(app, host='0.0.0.0',port=5000)
