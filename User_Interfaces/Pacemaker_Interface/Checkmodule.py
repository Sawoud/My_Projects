


def checkinput(self,variable,value,mode,temp3):
    print("mode being changed is:",mode)
    print("variable is:",variable)
    print("value from user is:",str(type(value)))

    try:
        value=float(value)
    except:
        pass

    if variable =="Lower Rate Limit":
        if str(type(value))=="<class 'str'>":
            self.error(variable,temp3)
            return -1
        elif  50>=value>=30 or 175>=value>=90:
            if value%5 !=0:
                self.error(variable,temp3)
                return -1
        elif 90>=value>=50:
            if value%1!=0:
                self.error(variable,temp3)
                return -1
        else:
            self.error(variable,temp3)
            return -1

    elif variable =="Upper Rate Limit":
        if str(type(value))=="<class 'str'>":
            self.error(variable,temp3)
            return -1
        elif  175>=value>=50:
            if value%5 !=0:
                self.error(variable,temp3)
                return -1
        else:
            self.error(variable,temp3)
            return -1
    elif variable =="Atrial Amplitude":
        if value=="Off":
            pass
        elif str(type(value))=="<class 'str'>":
            self.error(variable,temp3)
            return -1
        elif 3.2>=value>=0.5:
            if (value*10)%1 !=0 :
                self.error(variable,temp3)
                return -1
        else:
            self.error(variable,temp3)
            return -1

    elif variable =="Atrial Pulse Width":
        if value==0.05:
            pass
        else:
            self.error(variable,temp3)
            return -1
    elif variable =="Atrial Sensitivity":
        if str(type(value))=="<class 'str'>":
            self.error(variable,temp3)
            return -1
        elif 0.75>=value>=0.25:
            if (value*100)%25!=0:
                self.error(variable,temp3)
                return -1
        else:
            self.error(variable,temp3)
            return -1

    elif variable =="ARP":
        if str(type(value))=="<class 'str'>":
            self.error(variable,temp3)
            return -1
        elif 500>=value>=150:
            if value%10!=0:
                self.error(variable,temp3)
                return -1
        else:
            self.error(variable,temp3)
            return -1
    elif variable =="PVARP":
        if str(type(value))=="<class 'str'>":
            self.error(variable,temp3)
            return -1
        elif 500>=value>=150:
            if value%10!=0:
                self.error(variable,temp3)
                return -1
        else:
            self.error(variable,temp3)
            return -1
    elif variable =="Rate Smoothing":
        if value ==0 or value==25:
            pass
        elif str(type(value))=="<class 'str'>":
            self.error(variable,temp3)
            return -1
        elif 21>=value>=3:
            if value%3!=0:
                self.error(variable,temp3)
                return -1
        else:
            self.error(variable,temp3)
            return -1
    elif variable =="Maximum Sensor Rate":
        if str(type(value))=="<class 'str'>":
            self.error(variable,temp3)
            return -1
        elif  175>=value>=50:
            if value%5 !=0:
                self.error(variable,temp3)
                return -1
        else:
            self.error(variable,temp3)
            return -1

    elif variable =="Activity Threshold":
        if str(type(value))=="<class 'str'>":
            self.error(variable,temp3)
            return -1
        elif 6>=value>=0:
            if value%1!=0:
                self.error(variable,temp3)
                return -1
        else:
            self.error(variable,temp3)
            return -1
    elif variable =="Reaction Time":
        if str(type(value))=="<class 'str'>":
            self.error(variable,temp3)
            return -1
        elif 50>=value>=10:
            if value%10!=0:
                self.error(variable,temp3)
                return -1
        else:
            self.error(variable,temp3)
            return -1
    elif variable =="Response Factor":
        if str(type(value))=="<class 'str'>":
            self.error(variable,temp3)
            return -1
        elif 16>=value>=1:
            if value%1!=0:
                self.error(variable,temp3)
                return -1
        else:
            self.error(variable,temp3)
            return -1
    elif variable =="Recovery Time":
        if str(type(value))=="<class 'str'>":
            self.error(variable,temp3)
            return -1
        elif 16>=value>=2:
            if value%1!=0:
                self.error(variable,temp3)
                return -1
        else:
            self.error(variable,temp3)
            return -1

    elif variable =="Ventricular Amplitude":
        if str(type(value))=="<class 'str'>":
            self.error(variable,temp3)
            return -1
        elif 7>=value>=3.5:
            if (value*10)%5!=0:
                self.error(variable,temp3)
                return -1
        else:
            self.error(variable,temp3)
            return -1
    elif variable == "Ventricular Pulse Width":
        if str(type(value))=="<class 'str'>":
            self.error(variable,temp3)
            return -1
        elif 1.9>=value>=0.1:
            if (value*10)%1!=0:
                self.error(variable,temp3)
                return -1
        else:
            self.error(variable,temp3)
            return -1
    elif variable =="Ventricular Sensitivity":
        if str(type(value))=="<class 'str'>":
            self.error(variable,temp3)
            return -1
        elif 10>=value>=1:
            if (value*10)%5!=0:
                self.error(variable,temp3)
                return -1
        else:
            self.error(variable,temp3)
            return -1
    elif variable =="Fixed AV Delay":
        if str(type(value))=="<class 'str'>":
            self.error(variable,temp3)
            return -1
        elif 300>=value>=70:
            if value%10!=0:
                self.error(variable,temp3)
                return -1
        else:
            self.error(variable,temp3)
            return -1

    elif variable =="VRP":
        if str(type(value))=="<class 'str'>":
            self.error(variable,temp3)
            return -1
        elif 500>=value>=150:
            if value%10!=0:
                self.error(variable,temp3)
                return -1
        else:
            self.error(variable,temp3)
            return -1
    else:
        return -1
    return 1
