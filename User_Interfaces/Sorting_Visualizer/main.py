import pygame, sys
import time
import win32api
from tkinter import *

# Sorting will be done from smallesst to largest
max = 122
sort = [5,2,32,12,42,1,65,55,34,22,43,3,13,76,122,54]

def bubblesort():
   swap = True
   draw(sort,-1,-1)
   while swap:
       swap = False
       for i in range(len(sort)-1):
           draw(sort,i,i+1)
           pygame.display.update()
           time.sleep(1)
           if (sort[i] > sort[i+1]):
               DISPLAY.fill((24,65,171))
               sort[i],sort[i+1] = sort[i+1],sort[i]
               time.sleep(1)
               DISPLAY.fill((24,65,171))
               draw(sort,i,i+1)
               pygame.display.update()
               swap = True
       draw(sort,-1,-1)


width = 640
height = 480
DISPLAY =  pygame.display.set_mode((width, height))
DISPLAY.fill((24,65,171))


def draw(array,z,j):
    x = 0
    Bwidth = width //len(array)
    print(Bwidth)
    for i in range(len(array)):
        Bheight  = (int)((array[i]/max)*height)
        if(i == z or i == j):
            pygame.draw.rect(DISPLAY,(0,255,0),(x,480,Bwidth,-1*Bheight))
        else:
            pygame.draw.rect(DISPLAY,(0,0,0),(x,480,Bwidth,-1*Bheight))
        #pygame.draw.rect(DISPLAY,(0,0,0),(71*1,200,100,50))
        print(x)
        x = x + Bwidth
while True:

    for event in pygame.event.get():
            if event.type==pygame.QUIT:
                pygame.quit()
                sys.exit()
    bubblesort()

    pygame.display.update()
# bubblesort()
