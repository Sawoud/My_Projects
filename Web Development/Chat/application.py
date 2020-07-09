import os

from flask import Flask,render_template,redirect,request,url_for,flash
from flask_socketio import SocketIO, emit
import requests

app = Flask(__name__)
app.config["SECRET_KEY"] = os.getenv("SECRET_KEY")
socketio = SocketIO(app)

name = ""
channels = []

class MSG:
    def __init__(self,text,username,time):
        self.username = username
        self.text = text
        self.time = time


class Channel:
    def __init__(self,name,msgs):
        self.name = name
        self.msgs = msgs



@app.route("/")
def name():
    return render_template("name.html")

@app.route("/index")
def index():
    return render_template("channel_creation.html")


@app.route("/channel_list.html")
def show():
    return render_template("channel_list.html",channels = channels)


@app.route("/channel_creation", methods = ['GET','POST'])
def channel_creation():
    global channels
    channel_name = request.form["CHANNEL NAME"]
    flag = 0
    for channel in channels:
        if channel_name == channel.name:
            flag = 1
            break
        else:
            continue
    if (flag == 1):
        return render_template('channel_list.html',channels=channels, info = "Channel Already Exists")
    else:
        m = MSG([],[],[])
        c = Channel(channel_name,m)
        channels.append(c)
        return render_template('channel_list.html',channels=channels, info = "Channel Created !")

@app.route("/test/<int:Channel_no>", methods = ['GET','POST'])
def test(Channel_no):
    return render_template("name.html", i = Channel_no)

@app.route("/chat/<int:Channel_no>", methods=['GET', 'POST'])
def chat(Channel_no):
    global channels
    c = channels[Channel_no]
    while (len(c.msgs.text) > 100):
        c.msgs.text.pop(0)
        c.msgs.username.pop(0)
        c.msgs.time.pop(0)
    return render_template("chat_room.html",i = Channel_no,channel = c)

def fix(i):
    global channels
    c = channels[i]
    while((c.msgs.username[-1] == c.msgs.username[-2]) and (c.msgs.text[-1] == c.msgs.text[-2]) and (c.msgs.time[-1] == c.msgs.time[-2]) ):
        c.msgs.text.pop(-1)
        c.msgs.username.pop(-1)
        c.msgs.time.pop(-1)


flag2 = 0
@app.route('/getinfo/<int:Channel_no>/<username>/<text>/<time>')
def getinfo(Channel_no,username,text,time):
    global channels
    global flag2
    c = channels[Channel_no]
    c.msgs.username.append(username)
    c.msgs.text.append(text)
    c.msgs.time.append(time)
    fix(Channel_no)
    print(c.msgs.username)
    print(c.msgs.text)
    print(c.msgs.time)





def messageReceived(methods=['GET', 'POST']): # these two functions are present for debugging
    print('message was received!!!')

@socketio.on('my event')
def handle_my_custom_event(json, methods=['GET', 'POST']):
    print('received my event: ' + str(json))
    socketio.emit('my response', json, callback=messageReceived)


if __name__ == "__main__":
    app.run(debug=True)
