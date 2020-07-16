import pygame, sys
import time
import win32api
from tkinter import *

# Sorting will be done from smallesst to largest
max = 90
sort = [5,2,32,12,42,1,65,55,34,22,43,3,13,76,max,54]

######################## BUBBLESORT
def bubblesort(array):
   swap = True
   drawBS(array,-1,-1)
   j = 1
   while swap:
       swap = False
       for i in range(len(sort)-j):
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
    Bwidth = width //len(array)
    for i in range(len(array)):
        Bheight  = (int)((array[i]/max)*height)
        if(i == z or i == j):
            pygame.draw.rect(DISPLAY,(0,255,0),(x,height,Bwidth,-1*Bheight))
        else:
            pygame.draw.rect(DISPLAY,(0,0,0),(x,height,Bwidth,-1*Bheight))
        #pygame.draw.rect(DISPLAY,(0,0,0),(71*1,200,100,50))
        x = x + Bwidth
    pygame.display.update()
    time.sleep(0.2)
#########################################################################

#######################################################Merge Sort
def MergeSort(array):

    if(len(array) != 2):
        pass

#######################################################



width = 640
height = 480
DISPLAY =  pygame.display.set_mode((width, height))
DISPLAY.fill((24,65,171))

flag ="z"

while True:

    for event in pygame.event.get():
            if event.type==pygame.QUIT:
                pygame.quit()
                sys.exit()
    if(flag == "z"):
        bubblesort(sort)
        flag ="y"
    #MergeSort(sort)

    pygame.display.update()
# bubblesort()
