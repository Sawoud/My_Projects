import pygame as p
from Chess import Engine
p.init()
W = H = 512
MAX_FPS = 15
DIM = 8
sq_size = H // DIM
IMG = {}

def LOADIMG():
    pieces = ["bR","bN","bB","bQ","bK","bB","bN","bR","bp","wp","wR","wN","wB","wQ","wK","wB","wN","wR"]

    for piece in pieces:
        IMG[piece] = p.transform.scale(p.image.load("Chess/images/"+piece+".png"),(sq_size,sq_size))

def main():
    screen = p.display.set_mode((W,H))
    clock = p.time.Clock()
    screen.fill(p.Color("blue"))
    gs =  Engine.State()
    moveMade = False
    print(gs.board)
    LOADIMG()
    running = True
    sqSelected = ()
    playerClicks = []
    while running:# Run game
        for e in p.event.get(): # get event
            if e.type == p.QUIT: # if exit, quit
                running = False
                #MOUSE
            elif (e.type == p.MOUSEBUTTONDOWN): # get which square is clicked
                location = p.mouse.get_pos()
                col = location[0]//sq_size
                row = location[1]//sq_size
                if sqSelected == (row,col): # if its the same square, ignore
                    sqSelected = ()
                    playerClicks = []
                else: # if its diffrent append clicks
                    sqSelected = (row,col)
                    playerClicks.append(sqSelected)
                if len(playerClicks) == 2: # if the player cicks twice, do the operations
                    move = Engine.Move(playerClicks[0],playerClicks[1],gs.board)
                    print(move.getChessNotation)
                    gs.makeMove(move)
                    moveMade = True
                    sqSelected = ()
                    playerClicks = []
                    #BUTTON
            if e.type == p.KEYDOWN:# if "z"is pressed, undo move
                if e.key ==  p.K_z:
                    gs.UndoMove(move)
                    moveMade = True
        if moveMade: # if a move has been made, draw screen
            moveMade = False
        drawState(screen,gs)
        clock.tick(MAX_FPS)
        p.display.flip()
        print(gs.board)

def drawState(screen,gs):
    drawBoard(screen)
    drawPieces(screen,gs.board)

def drawBoard(screen):
    colors = [p.Color("white"),p.Color("grey")]

    for r in range(DIM):
        for c in range(DIM):
            color = colors[(r+c)%2]
            p.draw.rect(screen,color,p.Rect(c*sq_size,r*sq_size,sq_size,sq_size))


def drawPieces(screen,board):
    for r in range(DIM):
        for c in range(DIM):
            piece = board[r][c]
            if piece != "--":
                screen.blit(IMG[piece],p.Rect(c*sq_size,r*sq_size,sq_size,sq_size))
main()
