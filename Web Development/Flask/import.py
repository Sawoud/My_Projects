import sqlite3

connection = sqlite3.connect("mysite.db") 
db = connection.cursor() 


def main():
    db.execute ("CREATE TABLE book (id INTEGER NOT NULL, isbn VARCHAR(30) NOT NULL, title VARCHAR(50) NOT NULL, author VARCHAR(50) NOT NULL, year INTEGER NOT NULL, PRIMARY KEY (id), UNIQUE (isbn));")
    db.execute ("CREATE TABLE review (id INTEGER NOT NULL, rating INTEGER NOT NULL, text VARCHAR(6000) NOT NULL, book_id INTEGER NOT NULL, PRIMARY KEY (id), FOREIGN KEY(book_id) REFERENCES book (id));")
    db.execute("CREATE TABLE user (id INTEGER NOT NULL, username VARCHAR(20) NOT NULL, password VARCHAR(60) NOT NULL, PRIMARY KEY (id), UNIQUE (username));")
