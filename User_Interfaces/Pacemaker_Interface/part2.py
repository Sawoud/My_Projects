#!/usr/bin/env python
from kivy.app import App #We need to import the bits of kivy we need as we need them as importing everything would slow the app down unnecessarily
from kivy.uix.widget import Widget #this is a thing that you want the App to display
from kivy.uix.label import Label #this will import the code for the label in which we want to display Hello World!
from kivy.uix.textinput import TextInput
from kivy.uix.gridlayout import GridLayout
from kivy.uix.button import Button
from functools import partial
from kivy.uix.screenmanager import ScreenManager, Screen
from kivy.uix.popup import Popup
from Checkmodule import *
import os.path
import serial, struct
import re
import threading
from kivy.uix.slider import Slider
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
import random
import sys
# still have to do the displaying numbers onto the screen
import time
from datetime import datetime
from dateutil.relativedelta import relativedelta

allparaog = {"mode":0,"Lower Rate Limit":0,"Upper Rate Limit":0,"Maximum Sensor Rate":0,"Fixed AV Delay":0,"Atrial Amplitude":0,"Atrial Pulse Width":0,"Ventricular Amplitude":0,"Ventricular Pulse Width":0,"Atrial Sensitivity":0,"VRP":0,"ARP":0,"PVARP":0,"Rate Smoothing":0,"Ventricular Sensitivity":0,"Activity Threshold":0,"Reaction Time":0,"Response Factor":0,"Recovery Time":0}
allpara = {"mode":0,"Lower Rate Limit":0,"Upper Rate Limit":0,"Maximum Sensor Rate":0,"Fixed AV Delay":0,"Atrial Amplitude":0,"Atrial Pulse Width":0,"Ventricular Amplitude":0,"Ventricular Pulse Width":0,"Atrial Sensitivity":0,"VRP":0,"ARP":0,"PVARP":0,"Rate Smoothing":0,"Ventricular Sensitivity":0,"Activity Threshold":0,"Reaction Time":0,"Response Factor":0,"Recovery Time":0}
allparaarray = ["mode","Lower Rate Limit","Upper Rate Limit","Maximum Sensor Rate","Fixed AV Delay","Atrial Amplitude","Atrial Pulse Width","Ventricular Amplitude","Ventricular Pulse Width","Atrial Sensitivity","VRP","ARP","PVARP","Rate Smoothing","Ventricular Sensitivity","Activity Threshold","Reaction Time","Response Factor","Recovery Time"]
connection = ""
name = ""
font_size = 20
a = [0]
b = [0]
b2 = [0]

user = ""
V = None
A = None
counter = 0
COM = 'COM4'
t1 = None
t4 = None

try:
    ser = serial.Serial()
    ser.baudrate = 115200
    ser.port = COM
    ser.open()
except:
    pass

def reMap(value, maxInput, minInput, maxOutput, minOutput):

	value = maxInput if value > maxInput else value
	value = minInput if value < minInput else value

	inputSpan = maxInput - minInput
	outputSpan = maxOutput - minOutput

	scaledThrust = float(value - minInput) / float(inputSpan)

	return minOutput + (scaledThrust * outputSpan)
A = None
def startthreadA(self):
    global t1
    global A
    A = 1
    if(t1 == None):
        t1 = threading.Thread(target = graph)
        t1.start()
    else:
        pass

def startthreadV(self):
    global t1
    global V
    V = 1
    if(t1 == None):
        t1 = threading.Thread(target = graph)
        t1.start()
    else:
        pass

def kill():
    global t1
    A = None
    V = None
    t1 = None


def live(temp):
    global a,b,b2,V,A,counter
    read_bytes = ser.readline()

    a.pop(0)
    a.append(a[-1]+(35/1000))
    if len(read_bytes) == 17:
        if (V == 1 and A == None):
            # print("V")
            v = struct.unpack('d',bytes(read_bytes[0:8]))[0]
            # v = random.randint(0, 10)+random.randint(0, 10)-random.randint(0, 15)
            b.insert(counter,v)
            b.pop(0)
            b2.insert(counter,0)
            b2.pop(0)
            plt.cla()
            plt.plot(a,b)
            # v = struct.unpack('d',bytes(read_bytes[0:8]))[0]
        elif(A==1 and V == None):
            # print("A")
            va = struct.unpack('d',bytes(read_bytes[8:16]))[0]
            # va = random.randint(0, 10)+random.randint(0, 10)-random.randint(0, 15)
            b.insert(counter,0)
            b.pop(0)
            b2.insert(counter,va)
            b2.pop(0)
            plt.cla()
            plt.plot(a, b2)
        elif(A==1 and V == 1):
            # print("AV")
            v = struct.unpack('d',bytes(read_bytes[0:8]))[0]
            va = struct.unpack('d',bytes(read_bytes[8:16]))[0]
            # v = random.randint(0, 10)+random.randint(0, 10)-random.randint(0, 15)
            # va = random.randint(0, 10)+random.randint(0, 10)-random.randint(0, 15)
            b.insert(counter,v)
            b.pop(0)
            b2.insert(counter,va)
            b2.pop(0)
            plt.cla()

            plt.plot(a, b)
            plt.plot(a, b2,color='red')
        #     v = struct.unpack('d',bytes(read_bytes[8:16]))[0]

    counter = counter + 1

    plt.ylim(0,1)


def graph():
    global a,b,counter
    global a,b,b2,V,A
    for i in range(0,100):
        a.append((a[-1]+(35/1000)))
        b.append(0)
        b2.append(0)
    ani = FuncAnimation(plt.gcf(),live,interval = 10)
    plt.tight_layout()
    plt.show()
    plt.close()
    a = [0]
    b = [0]
    b2 = [0]
    counter = 0
    V = None
    A = None
    kill()




def Connect(): # function that deermines if the pace maker is connected or not
    global connection,ser
    try:
        ser.close()

        ser.open()

        if ser.is_open:
            connection = "CONNECTED"
        else:
            connection = "NOT CONNECTED"

    except serial.serialutil.SerialException:
      connection = "NOT CONNECTED"




class MyGrid(GridLayout):

    def AddButtons(self,x): # this function determines what buttons have to be added
        if(x != 1):
            self.aoo = Button(text = "AOO")
            self.aoo.bind(on_press=self.AOO)
            self.add_widget(self.aoo)

        if(x != 2):
            self.voo = Button(text = "VOO")
            self.voo.bind(on_press=self.VOO)
            self.add_widget(self.voo)
        if(x != 3):
            self.aai = Button(text = "AAI")
            self.aai.bind(on_press=self.AAI)
            self.add_widget(self.aai)
        if(x !=4):
            self.vvi = Button(text = "VVI")
            self.vvi.bind(on_press=self.VVI)
            self.add_widget(self.vvi)
        if(x !=5):
            self.doo = Button(text = "DOO")
            self.doo.bind(on_press=self.DOO)
            self.add_widget(self.doo)
        if(x !=6):
            self.aoor = Button(text = "AOOR")
            self.aoor.bind(on_press=self.AOOR)
            self.add_widget(self.aoor)

        if(x !=7):
            self.voor = Button(text = "VOOR")
            self.voor.bind(on_press=self.VOOR)
            self.add_widget(self.voor)

        if(x !=8):
            self.aair = Button(text = "AAIR")
            self.aair.bind(on_press=self.AAIR)
            self.add_widget(self.aair)

        if(x !=9):
            self.vvir = Button(text = "VVIR")
            self.vvir.bind(on_press=self.VVIR)
            self.add_widget(self.vvir)

        if(x !=10):
            self.door = Button(text = "DOOR")
            self.door.bind(on_press=self.DOOR)
            self.add_widget(self.door)




    def filetodic(self,mode,select): # this function is invoked when the user presses any change button
        global user
        global allpara
        global allparaarray
        for i in allparaarray:
            allpara[i] = 0
        allpara["mode"] = select
        strg = user + '\\' + mode+'.txt' # the path for the required file
        f = open(strg, "r+")
        lines = f.readlines()
        i = 0
        line=""
        for line in lines: # this for loop finds where the requested parameter is located
            lineog = line
            pos = line.find("(")
            pos1 = line.find("\n")
            line = line[:pos] + line[pos1+1:]
            allpara[line] = lineog[pos+1:pos1-1]
            i = i + 1
            print(lineog[pos+1:pos1-1])
        print(allpara)
        f.close()



    def Popup(self,var,temp): # this function shows the values of the parameters of each mode
        strg = user + "\\" + var +'.txt'
        f = open(strg,"r")
        popup = Popup(title=var+" Parameters",
        content=Label(text=f.read()),
        size_hint=(None, None), size=(400, 400))
        popup.open()

    def error(self,var,temp):
        text2="                 ERROR\n"
        if var =="Lower Rate Limit":
            text2=text2+"""Valid input range is 30-175ppm\n30-50 ppm with 5 ppm steps\n50-90 ppm with 1 ppm steps\n90-175 ppm with 5 ppm steps\nDO NOT INCLUDE THE UNITS"""
        elif var =="Upper Rate Limit":
            text2=text2+"""Valid input range is 50-175ppm\n50-175 ppm with 5 ppm steps\nDO NOT INCLUDE THE UNITS"""
        elif var =="Atrial Amplitude":
            text2=text2+"""Valid inputs are "Off" or 0.5-3.2V\n 0.5-3.2V with 0.1V steps\nDO NOT INCLUDE THE UNITS"""
        elif var =="Atrial Pulse Width":
            text2=text2+"""The only valid input is 0.05ms\nDO NOT INCLUDE THE UNITS"""
        elif var =="Atrial Sensitivity":
            text2=text2+"""Valid input range is 0.25-0.75V\nm with 0.25V steps\nDO NOT INCLUDE THE UNITS"""
        elif var =="ARP":
            text2=text2+"""Valid input range is 150-500ms\n150-500 ms with 10ms steps\nDO NOT INCLUDE THE UNITS"""
        elif var =="VRP":
            text2=text2+"Valid input range is 150-500ms\n150-500 ms with 10ms steps\nDO NOT INCLUDE THE UNITS"
        elif var =="PVARP":
            text2=text2+"""Valid input range is 150-500ms\n150-500 ms with 10ms steps\nDO NOT INCLUDE THE UNITS"""
        elif var =="Rate Smoothing":
            text2=text2+"""Valid input range is 3-25% or 0 to turn off Rate smoothing\n3-25% with 3% steps\n 0 TURNS OFF\nDO NOT INCLUDE THE %"""
        elif var =="Maximum Sensor Rate":
            text2=text2+"""Valid input range is 50-175ppm\n50-175 ppm with 5 ppm steps\nDO NOT INCLUDE THE UNITS"""
        elif var =="Activity Threshold":
            text2=text2+"""Can only except the follow values 0-6:\n enter 0 for 'V-Low'\n enter 1 for' Low'\n enter 2 for 'Med-Low'\n enter 3 for 'Med'\n enter 4 for'Med-High'\n enter 5 for 'High'\n enter 6 for 'V-High'"""
        elif var =="Reaction Time":
            text2=text2+"Valid input range is 10-50sec\n10-50sec with 10sec steps\nDO NOT INCLUDE THE UNITS"
        elif var =="Response Factor":
            text2=text2+"Valid input range is 1-16\n1-16 with an integer step size of 1"
        elif var =="Recovery Time":
            text2=text2+"Valid input range is 2-16min\n2-16min with a 1 min step size\nDO NOT INCLUDE THE UNITS"
        elif var =="Ventricular Amplitude":
            text2=text2+"Valid input range is 3.5-7.0V\n3.5-7.0V with a 0.5V step size\nDO NOT INCLUDE THE UNITS"
        elif var =="Ventricular Pulse Width":
            text2=text2+"Valid input range is 0.1-1.9ms\n0.1-1.9ms with a 0.1ms step size\nDO NOT INCLUDE THE UNITS "
        elif var =="Ventricular Sensitivity":
            text2=text2+"Valid input range is 1-10mV\n1-10mV with a 0.5mV step size\nDO NOT INCLUDE THE UNITS "
        elif var =="Fixed AV Delay":
            text2=text2+"Valid input range is 70-300ms\n70-300ms with 10ms step size\nDO NOT INCLUDE THE UNITS"
        errr = Popup(title="Input Error: "+var,
        content=Label(text=text2),size_hint=(None, None), size=(400, 400))

        errr.open()


    def para(self,var,select):
        global font_size
        self.filetodic(var,select)#write file values in dici
        self.clear_widgets()
        self.AddButtons(select)
        self.cols = 3
        self.add_widget(Label(text="Lower Rate Limit"))# these blocks show the specific parameters for the mode...
        self.name1 = TextInput(multiline=False) # ...and gives the user the chance to change them
        self.add_widget(self.name1)
        self.submit1 = Button(text = "Change",font_size = font_size)

        self.submit1.bind(on_press = partial(self.pressed,self.name1,var,select,'Lower Rate Limit'))
        self.add_widget(self.submit1)

        self.add_widget(Label(text="Upper Rate Limit"))
        self.name2 = TextInput(multiline=False)
        self.add_widget(self.name2)
        self.submit2 = Button(text = "Change",font_size = font_size)
        self.submit2.bind(on_press = partial(self.pressed,self.name2,var,select,'Upper Rate Limit'))
        self.add_widget(self.submit2)

        if(select == 6 or select == 7 or select == 8 or select == 9 or select == 10):
            self.add_widget(Label(text="Maximum Sensor Rate"))
            self.name16 = TextInput(multiline=False)
            self.add_widget(self.name16)
            self.submit16 = Button(text = "Change",font_size = font_size)
            self.submit16.bind(on_press = partial(self.pressed,self.name16,var,select,'Maximum Sensor Rate'))
            self.add_widget(self.submit16)

        if(select == 5 or select == 10):
            self.add_widget(Label(text="Fixed AV Delay"))
            self.name14 = TextInput(multiline=False)
            self.add_widget(self.name14)
            self.submit14 = Button(text = "Change",font_size = font_size)
            self.submit14.bind(on_press = partial(self.pressed,self.name14,var,select,'Fixed AV Delay'))
            self.add_widget(self.submit14)

        if(select == None):
            self.add_widget(Label(text="Dynamic AV Delay"))
            self.name15 = TextInput(multiline=False)
            self.add_widget(self.name15)
            self.submit15 = Button(text = "Change",font_size = font_size)
            self.submit15.bind(on_press = partial(self.pressed,self.name15,var,select,'Dynamic AV Delay'))
            self.add_widget(self.submit15)


        if(select == 1 or select == 3 or select == 6 or select ==5 or select == 8 or select == 10):
            self.add_widget(Label(text="Atrial Amplitude"))
            self.name3 = TextInput(multiline=False)
            self.add_widget(self.name3)
            self.submit3 = Button(text = "Change",font_size = font_size)
            self.submit3.bind(on_press = partial(self.pressed,self.name3,var,select,'Atrial Amplitude'))
            self.add_widget(self.submit3)
        if(select == 1 or select == 3  or select == 5 or select == 6  or select == 8 or select == 10):
            self.add_widget(Label(text="Atrial Pulse Width"))
            self.name4 = TextInput(multiline=False)
            self.add_widget(self.name4)
            self.submit4 = Button(text = "Change",font_size = font_size)
            self.submit4.bind(on_press = partial(self.pressed,self.name4,var,select,'Atrial Pulse Width'))
            self.add_widget(self.submit4)

        if(select == 2 or select == 4  or select == 5 or select == 7  or select == 9 or select == 10):
            self.add_widget(Label(text="Ventricular Amplitude"))
            self.name5 = TextInput(multiline=False)
            self.add_widget(self.name5)
            self.submit5 = Button(text = "Change",font_size = font_size)
            self.submit5.bind(on_press = partial(self.pressed,self.name5,var,select,'Ventricular Amplitude'))
            self.add_widget(self.submit5)

        if(select == 2 or select == 4  or select == 5 or select == 7 or select == 9 or select == 10):
            self.add_widget(Label(text="Ventricular Pulse Width"))
            self.name6 = TextInput(multiline=False)
            self.add_widget(self.name6)
            self.submit6 = Button(text = "Change",font_size = font_size)
            self.submit6.bind(on_press = partial(self.pressed,self.name6,var,select,'Ventricular Pulse Width'))
            self.add_widget(self.submit6)


        if(select == 3  or select == 8):
            self.add_widget(Label(text="Atrial Sensitivity"))
            self.name8 = TextInput(multiline=False)
            self.add_widget(self.name8)
            self.submit8 = Button(text = "Change",font_size = font_size)
            self.submit8.bind(on_press = partial(self.pressed,self.name8,var,select,'Atrial Sensitivity'))
            self.add_widget(self.submit8)

        if(select == 9):
            self.add_widget(Label(text="VRP"))
            self.name21 = TextInput(multiline=False)
            self.add_widget(self.name21)
            self.submit21 = Button(text = "Change",font_size = font_size)
            self.submit21.bind(on_press = partial(self.pressed,self.name21,var,select,'VRP'))
            self.add_widget(self.submit21)

        if(select == 3  or select == 8 or select == 9):
            self.add_widget(Label(text="ARP"))
            self.name9 = TextInput(multiline=False)
            self.add_widget(self.name9)
            self.submit9 = Button(text = "Change",font_size = font_size)
            self.submit9.bind(on_press = partial(self.pressed,self.name9,var,select,'ARP'))
            self.add_widget(self.submit9)

        if(select == 3  or select == 8):
            self.add_widget(Label(text="PVARP"))
            self.name10 = TextInput(multiline=False)
            self.add_widget(self.name10)
            self.submit10 = Button(text = "Change",font_size = font_size)
            self.submit10.bind(on_press = partial(self.pressed,self.name10,var,select,'PVARP'))
            self.add_widget(self.submit10)

        # if(select == 3 or select == 4 or select == 8  or select == 9):
        #     self.add_widget(Label(text="Hysteresis"))
        #     self.name11 = TextInput(multiline=False)
        #     self.add_widget(self.name11)
        #     self.submit11 = Button(text = "Change",font_size = font_size)
        #     self.submit11.bind(on_press = partial(self.pressed,self.name11,var,select,'Hysteresis'))
        #     self.add_widget(self.submit11)

        if(select == 3 or select == 4  or select == 8  or select == 9):
            self.add_widget(Label(text="Rate Smoothing"))
            self.name12 = TextInput(multiline=False)
            self.add_widget(self.name12)
            self.submit12 = Button(text = "Change",font_size = font_size)
            self.submit12.bind(on_press = partial(self.pressed,self.name12,var,select,'Rate Smoothing'))
            self.add_widget(self.submit12)

        if(select == 4 or select == 9):
            self.add_widget(Label(text="Ventricular Sensitivity"))
            self.name13 = TextInput(multiline=False)
            self.add_widget(self.name13)
            self.submit13 = Button(text = "Change",font_size = font_size)
            self.submit13.bind(on_press = partial(self.pressed,self.name13,var,select,'Ventricular Sensitivity'))
            self.add_widget(self.submit13)


        if(select == 6 or select == 7 or select == 8 or select == 9 or select == 10):
            self.add_widget(Label(text="Activity Threshold"))
            self.name17 = TextInput(multiline=False)
            self.add_widget(self.name17)
            self.submit17 = Button(text = "Change",font_size = font_size)
            self.submit17.bind(on_press = partial(self.pressed,self.name17,var,select,'Activity Threshold'))
            self.add_widget(self.submit17)

        if(select == 6 or select == 7 or select == 8 or select == 9 or select == 10):
            self.add_widget(Label(text="Reaction Time"))
            self.name18 = TextInput(multiline=False)
            self.add_widget(self.name18)
            self.submit18 = Button(text = "Change",font_size = font_size)
            self.submit18.bind(on_press = partial(self.pressed,self.name18,var,select,'Reaction Time'))
            self.add_widget(self.submit18)

        if(select == 6 or select == 7 or select == 8 or select == 9 or select == 10):
            self.add_widget(Label(text="Response Factor"))
            self.name19 = TextInput(multiline=False)
            self.add_widget(self.name19)
            self.submit19 = Button(text = "Change",font_size = font_size)
            self.submit19.bind(on_press = partial(self.pressed,self.name19,var,select,'Response Factor'))
            self.add_widget(self.submit19)


        if(select == 6 or select == 7 or select == 8 or select == 9 or select == 10):
            self.add_widget(Label(text="Recovery Time"))
            self.name20 = TextInput(multiline=False)
            self.add_widget(self.name20)
            self.submit20 = Button(text = "Change",font_size = font_size)
            self.submit20.bind(on_press = partial(self.pressed,self.name20,var,select,'Recovery Time'))
            self.add_widget(self.submit20)



        Connect()

        self.add_widget(Label(text="Show "+var+" Parameters Values"))
        self.submitend = Button(text = "Values",font_size = font_size)
        self.submitend.bind(on_press = partial(self.Popup,var))
        self.add_widget(self.submitend)

        self.graphv = Button(text = "Ventricle E-GRAM",font_size = font_size)
        self.graphv.bind(on_press = startthreadV)
        self.add_widget(self.graphv)
        self.add_widget(Label(text=""+connection))
        self.add_widget(Label(text="NAME: "+name))
        self.grapha = Button(text = "Atrium E-GRAM",font_size = font_size)
        self.grapha.bind(on_press = startthreadA)
        self.add_widget(self.grapha)

    def __init__(self,**kwargs):
        super(MyGrid,self).__init__(**kwargs)

        self.cols = 1
        self.AddButtons(0)
# MODE FUNCTIONS

####################################################

    def AOO(self,temp): # This is the AOO function
        var = "AOO"
        self.para(var,1)

####################################################

    def VOO(self,temp): # This is the VOO function
        var = "VOO"
        self.para(var,2)
####################################################
    def AAI(self,temp): # this is the AAI function
        var = "AAI"
        self.para(var,3)
####################################################
    def VVI(self,temp): # this is the VVI function
        var = "VVI"
        self.para(var,4)
####################################################

####################################################

    def DOO(self,temp): # This is the DOO function
        var = "DOO"
        self.para(var,5)
####################################################

    def AOOR(self,temp): # This is the AOOR function
        var = "AOOR"
        self.para(var,6)
####################################################
    def VOOR(self,temp): # this is the VOOR function
        var = "VOOR"
        self.para(var,7)
####################################################
    def AAIR(self,temp): # this is the AAIR function
        var = "AAIR"
        self.para(var,8)
####################################################
####################################################
    def VVIR(self,temp): # this is the VVIR function
        var = "VVIR"
        self.para(var,9)
####################################################
####################################################
    def DOOR(self,temp): # this is the DOOR function
        var = "DOOR"
        self.para(var,10)
####################################################



    def pressed(self,instance,mode,select,var,temp3): # this function is invoked when the user presses any change button
        global user
        global allpara
        if(1==checkinput(self,var,instance.text,mode,temp3)):
            allpara["mode"] = select
            strg = user + '\\' + mode+'.txt' # the path for the required file
            f = open(strg, "r+")
            lines = f.readlines()
            i = 0
            line=""
            for line in lines: # this for loop finds where the requested parameter is located

                pos = line.find("(")
                pos1 = line.find("\n")
                line = line[:pos] + line[pos1+1:]

                if(line == var):
                    allpara[line] = float(instance.text)
                    break
                else:
                    i = i + 1
            line = line + "(" + instance.text + ")" + "\n" # the line gets the parameter inputed between the brackets
            lines[i] = line
            lines = ''.join(lines)
            f.seek(0)
            f.write(lines)# file gets overwritten with the new information
            f.truncate()
            f.close()
            # lines  =  ((re.findall('\(.*?\)',lines)))
            # for i in range(len(lines)):
            #     temp = list(lines[i])
            #     temp.pop(0)
            #     temp.pop(-1)
            #     temp = "".join(temp)
            #     lines[i] = temp
            # lines.insert(0,str(select))
            sendDatathread()
        else:
            pass


class MyApp(App):
    def build(self):
        return MyGrid()

def sendDatathread():
    t2 = threading.Thread(target = sendData)
    t2.start()


def sendData():
    global allpara
    global allparaarray
    SEND =bytes(0)
    for i in allparaarray:
        if(i == "Maximum Sensor Rate" or i =="Fixed AV Delay" or i ==  "VRP" or i == "ARP" or i == "PVARP"):
            SEND += struct.pack("H",int(allpara[i]))
        elif(i == "Atrial Pulse Width" or i == "Ventricular Pulse Width" or i == "Atrial Sensitivity" or i == "Ventricular Sensitivity" or i == "Atrial Amplitude" or i == "Ventricular Amplitude"):
            SEND += struct.pack("d",float(allpara[i]))
        else:
            SEND += struct.pack("B",int(allpara[i]))
        print(SEND)
    # path = serial.Serial(COM, 115200)
    ser.write(SEND)
    sendDatastop()

def sendDatastop():
    t2 = None


def main(namee,info):
    global user
    global name
    user = info
    name = namee
    print("this is",info)
    MyApp().run()
