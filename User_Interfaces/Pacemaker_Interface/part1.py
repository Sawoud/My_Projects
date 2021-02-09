# main.py

from kivy.app import App
from kivy.lang import Builder
from kivy.uix.screenmanager import ScreenManager, Screen
from kivy.properties import ObjectProperty
from kivy.uix.popup import Popup
from kivy.uix.label import Label
from database import DataBase
import os
from part2 import *

import os.path
import shutil

class CreateAccountWindow(Screen):
    namee = ObjectProperty(None)
    email = ObjectProperty(None)
    password = ObjectProperty(None)

    def submit(self):
        if self.namee.text != "" and self.email.text != "" and self.email.text.count("@") == 1 and self.email.text.count(".") > 0:
            if self.password != "" and db.get_user(self.email.text)==-1:
                if db.num_users()<10:
                    db.add_user(self.email.text, self.password.text, self.namee.text)
                    x=self.email.text
                    try:
                        os.makedirs(self.email.text)
                    except:
                        print("This user's folder has already been created")
                    Currentmode="DOOR"
                    AAIstring="Lower Rate Limit(60)\nUpper Rate Limit(120)\nAtrial Amplitude(3.5)\nAtrial Pulse Width(0.05)\nAtrial Sensitivity(0.5)\nARP(250)\nPVARP(250)\nRate Smoothing(0)\n" #8
                    AAIRstring="Lower Rate Limit(60)\nUpper Rate Limit(120)\nMaximum Sensor Rate(120)\nAtrial Amplitude(3.5)\nAtrial Pulse Width(0.05)\nAtrial Sensitivity(0.75)\nARP(250)\nPVARP(250)\nRate Smoothing(0)\nActivity Threshold(3)\nReaction Time(30)\nResponse Factor(8)\nRecovery Time(5)\n"
                    AOOstring="Lower Rate Limit(60)\nUpper Rate Limit(120)\nAtrial Amplitude(3.5)\nAtrial Pulse Width(0.05)\n"
                    AOORstring="Lower Rate Limit(60)\nUpper Rate Limit(120)\nMaximum Sensor Rate(120)\nAtrial Amplitude(3.5)\nAtrial Pulse Width(0.05)\nActivity Threshold(3)\nReaction Time(30)\nResponse Factor(8)\nRecovery Time(5)\n"
                    VVIstring="Lower Rate Limit(60)\nUpper Rate Limit(120)\nVentricular Amplitude(3.5)\nVentricular Pulse Width(0.4)\nVentricular Sensitivity(2.5)\nRate Smoothing(0)\n"
                    VVIRstring="Lower Rate Limit(60)\nUpper Rate Limit(120)\nMaximum Sensor Rate(120)\nVentricular Amplitude(3.5)\nVentricular Pulse Width(0.4)\nVRP(320)\nARP(250)\nRate Smoothing(0)\nVentricular Sensitivity(2.5)\nActivity Threshold(3)\nReaction Time(30)\nResponse Factor(8)\nRecovery Time(5)\n"
                    VOOstring="Lower Rate Limit(60)\nUpper Rate Limit(120)\nVentricular Amplitude(3.5)\nVentricular Pulse Width(0.4)\n"
                    VOORstring="Lower Rate Limit(60)\nUpper Rate Limit(120)\nMaximum Sensor Rate(120)\nVentricular Amplitude(3.5)\nVentricular Pulse Width(0.4)\nActivity Threshold(3)\nReaction Time(30)\nResponse Factor(8)\nRecovery Time(5)\n"
                    DOOstring="Lower Rate Limit(60)\nUpper Rate Limit(120)\nFixed AV Delay(150)\nAtrial Amplitude(3.5)\nAtrial Pulse Width(0.05)\nVentricular Amplitude(3.5)\nVentricular Pulse Width(0.4)\n"
                    DOORstring="Lower Rate Limit(60)\nUpper Rate Limit(120)\nMaximum Sensor Rate(120)\nFixed AV Delay(150)\nAtrial Amplitude(3.5)\nAtrial Pulse Width(0.05)\nVentricular Amplitude(3.5)\nVentricular Pulse Width(0.4)\nActivity Threshold(3)\nReaction Time(30)\nResponse Factor(8)\nRecovery Time(5)\n"

                    with open(os.path.join(x,"AAI.txt"), "a") as fileopened:
                        fileopened.write(AAIstring)
                    with open(os.path.join(x,"AOO.txt"), "a") as fileopened:
                        fileopened.write(AOOstring)
                    with open(os.path.join(x,"AAIR.txt"), "a") as fileopened:
                        fileopened.write(AAIRstring)
                    with open(os.path.join(x,"AOOR.txt"), "a") as fileopened:
                        fileopened.write(AOORstring)
                    with open(os.path.join(x,"VVI.txt"), "a") as fileopened:
                        fileopened.write(VVIstring)
                    with open(os.path.join(x,"VOO.txt"), "a") as fileopened:
                        fileopened.write(VOOstring)
                    with open(os.path.join(x,"VVIR.txt"), "a") as fileopened:
                        fileopened.write(VVIRstring)
                    with open(os.path.join(x,"VOOR.txt"), "a") as fileopened:
                        fileopened.write(VOORstring)
                    with open(os.path.join(x,"DOO.txt"), "a") as fileopened:
                        fileopened.write(DOOstring)
                    with open(os.path.join(x,"DOOR.txt"), "a") as fileopened:
                        fileopened.write(DOORstring)
                    with open(os.path.join(x,"SETTOMODE.txt"), "a") as fileopened:
                        fileopened.write(Currentmode)


                    self.reset()
                    sm.current = "login"

                else:
                    ToManyAccountsForm()
            else:
                invalidForm()
        else:
            invalidForm()

    def login(self):
        self.reset()
        sm.current = "login"

    def reset(self):
        self.email.text = ""
        self.password.text = ""
        self.namee.text = ""

class WelcomeWindow(Screen):
    num = ObjectProperty(None)

    def startbutton(self):
        sm.current="login"
    def on_enter(self, *args):
        number = str(db.num_users())
        self.num.text = "There are currently " +number+" users stored in the database"
class DeleteAccountWindow(Screen):
    email = ObjectProperty(None)
    password = ObjectProperty(None)

    def login(self):
        self.reset()
        sm.current = "login"

    def reset(self):
        self.email.text = ""
        self.password.text = ""
    def submit(self):
        if db.validate(self.email.text, self.password.text):
            ###code to delete stuff here
            db.delete_user(self.email.text)
            shutil.rmtree(os.getcwd()+'\\'+self.email.text)
            db.delete_user(self.email.text)
            self.reset()
        else:
            invalidLogin()
class LoginWindow(Screen):
    email = ObjectProperty(None)
    password = ObjectProperty(None)

    def loginBtn(self):
        if db.validate(self.email.text, self.password.text):
            MainWindow.current = self.email.text
            App.get_running_app().stop()
            name = db.get_user(self.email.text)
            main(name[1],self.email.text)
            self.reset()

        else:
            invalidLogin()
    def deleteBtn(self):
        self.reset()
        sm.current="delete"

    def createBtn(self):
        self.reset()
        sm.current = "create"

    def reset(self):
        self.email.text = ""
        self.password.text = ""


class MainWindow(Screen):
    print("MainWindow")
    n = ObjectProperty(None)
    created = ObjectProperty(None)
    email = ObjectProperty(None)
    current = ""
                            ####unused mainwindow screen for after loging in
    def logOut(self):
        sm.current = "login"

    def on_enter(self, *args):
        print("on_enter")



class WindowManager(ScreenManager):
    pass


def invalidLogin():
    pop = Popup(title='Invalid Login',
                  content=Label(text='Invalid email or password.'),
                  size_hint=(None, None), size=(400, 400))
    pop.open()


def invalidForm():
    pop = Popup(title='Invalid Form',
                  content=Label(text='Invalid info, Email may already have an account.'),
                  size_hint=(None, None), size=(400, 400))

    pop.open()

def ToManyAccountsForm():
    pop = Popup(title='To Many Accounts Form',
                      content=Label(text='There are already 10 users stored'),
                      size_hint=(None, None), size=(400, 400))

    pop.open()


kv = Builder.load_file("my.kv")
sm = WindowManager()
db = DataBase("users.txt")
screens = [WelcomeWindow(name="welcome"),LoginWindow(name="login"), CreateAccountWindow(name="create"), DeleteAccountWindow(name="delete")]
for screen in screens:
    sm.add_widget(screen)
sm.current = "welcome"


class MyMainApp(App):
    def build(self):
        return sm


if __name__ == "__main__":
    print(db.num_users())
    MyMainApp().run()
