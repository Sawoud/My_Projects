class State():
    def __init__(self):
        self.board = [
            ["bR","bN","bB","bQ","bK","bB","bN","bR"],
            ["bp","bp","bp","bp","bp","bp","bp","bp"],
            ["--","--","--","--","--","--","--","--"],
            ["--","--","--","--","--","--","--","--"],
            ["--","--","--","--","--","--","--","--"],
            ["--","--","--","--","--","--","--","--"],
            ["wp","wp","wp","wp","wp","wp","wp","wp"],
            ["wR","wN","wB","wQ","wK","wB","wN","wR"],
        ]
        self.wT = True
        self.log = []

    def makeMove(self, move):
            self.board[move.Sr][move.Sc] = "--"
            self.board[move.Er][move.Ec] = move.pMoved
            self.log.append(move)
            self.wT = not self.wT
            print(self.board)

    def UndoMove(self,move):
        if (len(self.log) != 0):
            move = self.log.pop()
            self.board[move.Sr][move.Sc] = move.pMoved
            self.board[move.Er][move.Ec] = move.pCaptured
            self.wT = not self.wT
            print(self.board)

class Move():
    ranksToRows = {"1":7,"2":6,"3":5,"4":4,"5":3,"6":2,"7":1,"8":0}
    rowsToRanks = {v:k for k,v in ranksToRows.items()}
    filesToCols = {"a":0,"b":1,"c":2,"d":3,"e":4,"f":5,"g":6,"h":7}
    colsToFiles = {v:k for k,v in filesToCols.items()}

    def __init__(self,Ssq,Esq,board):
        self.Sr = Ssq[0]
        self.Sc = Ssq[1]
        self.Er = Esq[0]
        self.Ec = Esq[1]
        self.pMoved = board[self.Sr][self.Sc]
        self.pCaptured = board[self.Er][self.Ec]
        self.moveID = self.Sr*1000+self.Sc*100+self.Er*10+self.Ec
    def __eq__(self,other):
        if isInstance(other,Move):
            return self.moveID == other.moveID
        return False

    def getChessNotation(self):
        return self.getRanKFile(self.Sr,self.Sc)+getRanKFile(self.Er,self.Ec)

    def getRanKFile(self,r,c):
            return self.colsToFiles[c] + self.rowsToRanks[r]
