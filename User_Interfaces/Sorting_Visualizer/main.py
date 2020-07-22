import pygame, sys
import time
import win32api
from tkinter import *

# Sorting will be done from smallesst to largest
max = 400
width = 640
height = 480
DISPLAY =  pygame.display.set_mode((width, height))
DISPLAY2 =  pygame.display.set_mode((width, height))
DISPLAY.fill((24,65,171))
DISPLAY2.fill((124,33,65))

########################QUIT
def Quit():
    sys.exit()
######################## BUBBLESORT
def bubblesort(array):
   swap = True
   drawBS(array,-1,-1)
   j = 1
   while swap:
       swap = False
       for i in range(len(array)-j):
           drawBS(array,i,i+1)
           if (array[i] > array[i+1]):
               temp = array[i]
               array[i] = array[i+1]
               array[i+1] = temp
               drawBS(array,i,i+1)
               swap = True
       print(swap)

       j = j + 1
   drawBS(array,-1,-1)

def drawBS(array,z,j):
    DISPLAY.fill((24,65,171))
    x = 0
    Bwidth = width /len(array)
    for i in range(len(array)):
        Bheight = ((array[i]/max)*height)
        if(i == z or i == j):
            pygame.draw.rect(DISPLAY,(0,255,0),(x,height,Bwidth,-1*Bheight))
        else:
            pygame.draw.rect(DISPLAY,(0,0,0),(x,height,Bwidth,-1*Bheight))
        #pygame.draw.rect(DISPLAY,(0,0,0),(71*1,200,100,50))
        x = x + Bwidth
    pygame.display.update()
    time.sleep(0.1)
#########################################################################

#######################################################Merge Sort
def MergeSort(array):
    drawMS(array,1)
    print(array)
    if len(array) <= 1:
        return array

    half = len(array)//2
    L = MergeSort(array[0:half])
    R = MergeSort(array[half:len(array)])
    fixed = combine(L,R)
    drawMS(fixed,0)
    return combine(L,R)


def combine(L,R):
    result = []
    Li = Ri = 0
    while Li < len(L) and Ri < len(R):

        if (L[Li]<R[Ri]):
            result.append(L[Li])
            Li += 1
        else:
            result.append(R[Ri])
            Ri += 1
    result.extend(L[Li:])
    result.extend(R[Ri:])

    return result

def drawMS(array,flag): # still wanna figure out how to draw this
    DISPLAY.fill((24,65,171))
    x = 0
    Bwidth = width /len(array)
    for i in range(len(array)):
        Bheight  = ((array[i]/max)*height)
        if (i<len(array)//2 and flag == 1):
            pygame.draw.rect(DISPLAY,(0,255,0),(x,height,Bwidth,-1*Bheight))
        else:
            pygame.draw.rect(DISPLAY,(0,0,0),(x,height,Bwidth,-1*Bheight))
        x = x + Bwidth
    pygame.display.update()
    time.sleep(1)
#######################################################

####################################################QuickSort
def QuickSort(array, start, end):
    print(array)
    if start >= end:
        return

    p = partition(array, start, end)
    QuickSort(array, start, p-1)
    QuickSort(array, p+1, end)

def partition(array, start, end):
    pivot = array[start]
    low = start + 1
    high = end
    drawQS(array,pivot,high,low)


    while True:
        # If the current value we're looking at is larger than the pivot
        # it's in the right place (right side of pivot) and we can move left,
        # to the next element.
        # We also need to make sure we haven't surpassed the low pointer, since that
        # indicates we have already moved all the elements to their correct side of the pivot
        while low <= high and array[high] >= pivot:
            high = high - 1

        # Opposite process of the one above
        while low <= high and array[low] <= pivot:
            low = low + 1

        # We either found a value for both high and low that is out of order
        # or low is higher than high, in which case we exit the loop
        if low <= high:
            array[low], array[high] = array[high], array[low]
            # The loop continues
        else:
            # We exit out of the loop
            break

    array[start], array[high] = array[high], array[start]
    drawQS(array,pivot,high,low)

    return high

def drawQS(array,pivot,high,low): # still wanna figure out how to draw this
    DISPLAY.fill((24,65,171))
    x = 0
    Bwidth = width /len(array)
    for i in range(len(array)):
        Bheight  = ((array[i]/max)*height)
        if (array[i] == pivot):
            pygame.draw.rect(DISPLAY,(0,255,0),(x,height,Bwidth,-1*Bheight))
        elif (array[i] == high):
            pygame.draw.rect(DISPLAY,(255,0,0),(x,height,Bwidth,-1*Bheight))
        elif (array[i] == low):
            pygame.draw.rect(DISPLAY,(0,0,255),(x,height,Bwidth,-1*Bheight))
        else:
            pygame.draw.rect(DISPLAY,(0,0,0),(x,height,Bwidth,-1*Bheight))
        x = x + Bwidth
    pygame.display.update()
    time.sleep(1)
####################################################


def main():
    sort = [max,5,2,32,12,42,1,64,55,34,22,254,43,3,13,76,65,23,187,345,213,98,54]
    print("not true")
    while True:
        print("dg")
        root = Tk()
        root.title("Sorting Visulizer")
        text = Text(root,height = 1)
        text.insert(INSERT,"Welocme To the Sorting Visulizer !")
        text.insert(END, "")
        text.tag_config(root, justify='center')
        text.pack()
        button_1 = Button(root,text="\t Option 1: Bubble Sort\t",command= lambda: bubblesort(sort))
        button_1.pack()
        button_2 = Button(root,text="\t Option 2: Merge Sort\t",command = lambda: MergeSort(sort))
        button_2.pack()
        button_3 = Button(root,text="\t Option 3: Quick Sort\t",command = lambda: QuickSort(sort,0,len(sort)-1))
        button_3.pack()
        button_4 = Button(text = '\tQUIT\t', command= Quit)
        button_4.pack()

        root.mainloop()

main()
