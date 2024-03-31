# pip3 freeze > requirements.txt

from flask import Flask, render_template, session, request, jsonify, Response
import secrets
import mysql.connector
from flask_login import LoginManager, current_user

from modules.appCourse import appCourse
from modules.appProject import appProject

app = Flask(__name__, static_folder='statics')
app.secret_key = secrets.token_urlsafe(16)
# login_manager = LoginManager(app)

# Đăng ký Blueprints vào app
app.register_blueprint(appCourse, url_prefix='/course')
app.register_blueprint(appProject, url_prefix='/project')

IP = "192.168.2.184"
# IP = 'localhost'

mydb = mysql.connector.connect(
  host="localhost",
  user="root",
  password="",
  database="danhgia"
)

mycursor = mydb.cursor()

@app.route('/loadData')
def loadData():
    # mycursor.execute(
    #     "SELECT a.codeClassCourse, CONCAT(b.lastnameTeacher, ' ', b.firstnameTeacher) AS fullname"
    #     " FROM ClassCourse a"
    #     " LEFT JOIN Teachers b ON a.idTeacher = b.idTeacher"
    # )
    mycursor.execute('SELECT * FROM Classcourse')
    data = mycursor.fetchall()
    return jsonify(response=data) 

@app.route("/")
def index():
    mycursor.execute("SELECT a.idClassCourse, CONCAT(a.codeClassCourse,' ',b.codeCourse,'- ',b.nameCourse) as fullnameClassCourse"
                     " FROM Classcourse a"
                     " LEFT JOIN Courses b ON a.idCourse = b.idCourse")
    data = mycursor.fetchall()
    return render_template("classcourse.html", response=data)
    # if 'loggedin' in session:
    #     idPerm = session.get('idPerm')
    #     if idPerm == 0:
    #         return render_template('index_admin.html')
    #     elif idPerm == 1:
    # return render_template("index.html")

if __name__ == "__main__":
    app.run(host=IP, port=5000, debug=True)


