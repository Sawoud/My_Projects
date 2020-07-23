import pygame, sys
import time
import win32api
from tkinter import *

# Sorting will be done from smallest to largest
max = 400
width = 640
height = 480
DISPLAY =  None
sec = 1
#DISPLAY.fill((24,65,171))
#DISPLAY2 =  pygame.display.set_mode((width, height))
#DISPLAY2.fill((124,33,65))

########################QUIT
def Quit():
    sys.exit()

def displayinit():
    global DISPLAY
    DISPLAY = pygame.display.set_mode((width, height))
######################## BUBBLESORT
def BubbleSort(array,root):
   root.destroy()
   root1 = Tk()
   root1.title("Explanation")
   text = Text(root1,height = 6)
   text.insert(INSERT,"Bubble sort works by checking the elements the are beside each other\nand determining whether they need switching or not\n")
   text.insert(END, "The higlighted elements are the ones getting checked\nClose this window to see the sorting in action\nAlso you can click on the screen at anytime to end the visuliztion")
   text.tag_config(root1, justify='center')
   text.pack()
   root1.mainloop()

   swap = True
   displayinit()
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

       j = j + 1
   drawBS(array,-1,-1)
   pygame.event.clear()
   while True:
       for event in pygame.event.get():
         if (event.type == pygame.QUIT):
             sys.exit()
         if (event.type == pygame.MOUSEBUTTONDOWN):
             pygame.display.quit()
             main()

def drawBS(array,z,j):
    global sec
    print(sec)
    for event in pygame.event.get():
      if (event.type == pygame.QUIT):
          sys.exit()
      if (event.type == pygame.MOUSEBUTTONDOWN):
          pygame.display.quit()
          main()
    DISPLAY.fill((24,65,171))
    x = 0
    Bwidth = width /len(array)
    for i in range(len(array)):
        print(i)
        Bheight = ((array[i]/max)*height)
        if(i == z or i == j):
            pygame.draw.rect(DISPLAY,(0,255,0),(x,height,Bwidth,-1*Bheight))
        else:
            pygame.draw.rect(DISPLAY,(0,0,0),(x,height,Bwidth,-1*Bheight))
        #pygame.draw.rect(DISPLAY,(0,0,0),(71*1,200,100,50))
        x = x + Bwidth
    pygame.display.update()
    time.sleep(sec)
#########################################################################

#######################################################Merge Sort
def N_MergeSort(array,root):
    root.destroy()
    root1 = Tk()
    root1.title("Explanation")
    text = Text(root1,height = 9)
    text.insert(INSERT,"Merge sort works by using a divide and conquer strategy\nIt keeps dividing the array recursively until it reaches one element\nit then starts going back out and orgnizes the elements based on value\nnow is has semi-sorted mini arrays until it sorts the entire array\n")
    text.insert(END, "The higlighted elements are the ones getting put in the recurstion stack\nClose this window to see the sorting in action\nAlso you can click on the screen at anytime to end the visuliztion")
    text.tag_config(root1, justify='center')
    text.pack()
    root1.mainloop()
    displayinit()
    MergeSort(array)
    pygame.event.clear()
    while True:
        for event in pygame.event.get():
          if (event.type == pygame.QUIT):
              sys.exit()
          if (event.type == pygame.MOUSEBUTTONDOWN):
              pygame.display.quit()
              main()

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
    global sec
    pygame.event.clear()
    for event in pygame.event.get():
      if (event.type == pygame.QUIT):
          sys.exit()
      if (event.type == pygame.MOUSEBUTTONDOWN):
          pygame.display.quit()
          main()
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
    time.sleep(sec)
#######################################################

####################################################QuickSort
def N_QuickSort(array, start, end,root):
    root.destroy()
    root1 = Tk()
    root1.title("Explanation")
    text = Text(root1,height = 8)
    text.insert(INSERT,"Quick sort works by choosing a pivot\nitems smaller than the pivot are placed to the left while items larger are\nplaced to the right\nIt keeps doing the recursivly to both sides of the pivot until array is sorted\n")
    text.insert(END, "The higlighted elements are the ones getting put in the recurstion stack\nClose this window to see the sorting in action\nAlso you can click on the screen at anytime to end the visuliztion")
    text.tag_config(root1, justify='center')
    text.pack()
    root1.mainloop()
    displayinit()
    QuickSort(array, start, end)
    pygame.event.clear()
    while True:
        for event in pygame.event.get():
          if (event.type == pygame.QUIT):
              sys.exit()
          if (event.type == pygame.MOUSEBUTTONDOWN):
              pygame.display.quit()
              main()

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
    global x
    pygame.event.clear()
    for event in pygame.event.get():
      if (event.type == pygame.QUIT):
          sys.exit()
      if (event.type == pygame.MOUSEBUTTONDOWN):
          pygame.display.quit()
          main()
    DISPLAY.fill((24,65,171))
    global sec
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
    time.sleep(sec)
####################################################
def time_delay(time,root):
    global sec
    sec = ((float)(time))/1000
    root.destroy()


def main():

        root = Tk()
        Label(root,text="Time Delay (ms)").grid(row=0)

        e1 = Entry(root)
        root.title("Sorting Visulizer")
        e1.grid(row=0, column=1)

        Button(root,text='OK', command= lambda: time_delay(e1.get(),root)).grid(row=3,column=1,sticky=W,pady=4)

        mainloop()
        while True:
            sort = [max,5,2,32,12,42,1,64,55,34,22,254,43,3,13,76,65,23,187,345,213,98,54]
            root = Tk()
            root.title("Sorting Visulizer")
            text = Text(root,height = 2)
            text.insert(INSERT,"Welocme To the Sorting Visulizer !\n")
            text.insert(END, "If you would like to stop any algorithm, just click the display")
            text.tag_config(root, justify='center')
            text.pack()
            button_1 = Button(root,text="\t Option 1: Bubble Sort\t",command= lambda: BubbleSort(sort,root))
            button_1.pack()
            button_2 = Button(root,text="\t Option 2: Merge Sort\t",command = lambda: N_MergeSort(sort,root))
            button_2.pack()
            button_3 = Button(root,text="\t Option 3: Quick Sort\t",command = lambda: N_QuickSort(sort,0,len(sort)-1,root))
            button_3.pack()
            button_4 = Button(text = 'QUIT', command= Quit)
            button_4.pack()
            root.mainloop()

main()
