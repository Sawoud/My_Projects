################################################################IMPORTS

from datetime import datetime
from flask_session import Session
from flask import Flask, render_template, url_for, flash, redirect,request
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager,UserMixin, login_user, logout_user
############################################################### App Declrations
app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///site.db'
db = SQLAlchemy(app)
app.secret_key = "nice"


import requests
res = requests.get("https://www.goodreads.com/book/review_counts.json", params={"key": "wUkXP1iRIaKript47qrqA", "isbns": "9781632168146"})
print(type(res))
print(res.json())

######################################################### Login Setup
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = "login";


@login_manager.user_loader
def load_user(user_id):
    try:
        return User.query.get(user_id)
    except:
        return None

############################################## CLASSES
class User(db.Model, UserMixin):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(20), unique=True, nullable=False)
    password = db.Column(db.String(60), nullable=False)

    def __repr__(self):
        return f"User('{self.username}', '{self.password}')"

class Book(db.Model):
    id = db.Column(db.Integer, primary_key = True)
    isbn = db.Column(db.String(30), unique = True, nullable=False)
    title = db.Column(db.String(50), nullable=False)
    author = db.Column(db.String(50), nullable=False)
    year = db.Column(db.Integer, nullable=False)
    reviews = db.relationship('Review',backref = 'author', lazy = True)
    def __repr__(self):
        return f"{self.isbn}, '{self.title}',{self.author}, {self.year}"



class Review(db.Model):
    id = db.Column(db.Integer, primary_key = True)
    rating = db.Column(db.Integer, nullable = False)
    text  = db.Column(db.String(6000), nullable = False)
    book_id = db.Column(db.Integer, db.ForeignKey('book.id'),nullable = False)
    
    def __repr__(self):
        return f"{self.rating}, '{self.text}'"


######################################################### FUNCTIONS
def NotSame(username): # Makes sure a username is not taken
    user = User.query.filter_by(username = username).first()
    if user:
        return False
    else:
        return True

def make_table(): # creates the database
    db = SQLAlchemy(app)
    flag = 0
    with app.app_context():
        with open('books.csv', mode='r') as csv_file:
            for row in csv_file:
                if (flag == 0):
                    flag = flag + 1
                    continue
                row = row.split(',')
                print(row[0],row[1], row[2],row[3])
                book = Book(isbn = row[0],title = row[1],author = row[2],year = row[3])
                db.session.add(book)
            db.session.commit()
######################################################## PAGES

@app.route("/")
def index():
    return render_template('home.html')


@app.route("/search",methods=['GET', 'POST'])

def search(): # this view serches, it gets its input from an html from in the file "templates/home.html"
    item = request.form['item']
    books = Book.query.filter(Book.isbn.like("%{}%".format(item))).all()
    if(books):
        return render_template('results.html', books = books)
    else:
        return render_template('results.html', books = None)

@app.route("/search/<string:book_title>",methods=['GET', 'POST'])# this function sends the book's info to get displayed
def book(book_title):
    book = Book.query.filter(Book.title.like("%{}%".format(book_title))).all()
    res = requests.get("https://www.goodreads.com/book/review_counts.json", params={"key": "wUkXP1iRIaKript47qrqA", "isbns": book[0].isbn})
    print(res.json())
    print(type(book))
    return render_template('book_info.html', book = book, res = res) # this function is used to add a book review

@app.route("/search/<string:book_title>/review", methods=['GET', 'POST'])
def review(book_title):
    book = Book.query.filter(Book.title.like("%{}%".format(book_title))).all()
    rating = request.form['rating']
    description = request.form['description']
    newReview = Review(rating=rating,text=description, book_id = book[0].id)
    db.session.add(newReview)
    db.session.commit()
    return redirect(url_for('index'))

@app.route("/api/<string:isbn>", methods=['GET', 'POST']) # this function displays the goodreads info
def goodreads_review(isbn):
    res = requests.get("https://www.goodreads.com/book/review_counts.json", params={"key": "wUkXP1iRIaKript47qrqA", "isbns": isbn})
    if(res):
        return render_template('book_info_goodreads.html', res = res)
    else:
        return "404 BOOK NOT FOUND, CHECK ISBN NUMBER"


############################################################################Login views
@app.route("/registration.html")
def registration(): # this function renders the registration template
    return render_template('registration.html')

@app.route("/send", methods=['GET', 'POST'])
def register(): # this function makes sure there exists no conflict in the User registration
    username = request.form['username']
    password = request.form['password']
    c_password = request.form['c_password']
    check = NotSame(username)
    if(c_password != password):
        flash('Passwords do not match, Please try again')
        return redirect(url_for('registration'))
    elif check:
        newUser = User(username=username,password=password)
        db.session.add(newUser)
        db.session.commit()
        flash('User successfully created')
        return redirect(url_for('login_page'))
    else:
        flash('Username Already Exists, Please choose another')
        return redirect(url_for('registration'))





@app.route("/login.html", methods=['GET', 'POST']) # these two functions log-in the user
def login_page():
    return render_template('login.html')

@app.route("/log_in", methods=['GET', 'POST'])
def login():
    username = request.form['username']
    password = request.form['password']
    user = User.query.filter_by(username = username).first()
    if (user and (password == user.password)):
        login_user(user)
        return redirect(url_for('index'))
    else:
        flash('login failed')
        return redirect(url_for('login_page'))





@app.route("/logout") # this function loges out the user
def logout():
    logout_user()
    return redirect(url_for('index'))

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if __name__ == '__main__':
#    db.create_all()
#    make_table()
    app.run(debug=True)
