# pip3 freeze > requirements.txt

from flask import Flask, render_template, session, request, jsonify, Response, redirect, url_for
import secrets
import mysql.connector
from flask_login import LoginManager, current_user

from modules.appCourse import appClassCourse
from modules.appProject import appProject
from modules.appAuth import appAuth
from modules.appStaff import appStaff
from modules.appStudent import appStudent
from modules.appTeacher import appTeacher
from modules.appCertificate import appCertificate

app = Flask(__name__, static_folder='statics')
app.secret_key = secrets.token_urlsafe(16)
# login_manager = LoginManager(app)

# Đăng ký Blueprints vào app
app.register_blueprint(appClassCourse, url_prefix='/course')
app.register_blueprint(appProject, url_prefix='/project')
app.register_blueprint(appAuth, url_prefix='/auth')
app.register_blueprint(appStaff, url_prefix='/staff')
app.register_blueprint(appStudent, url_prefix='/student')
app.register_blueprint(appTeacher, url_prefix='/teacher')
app.register_blueprint(appCertificate, url_prefix='/certificate')

# IP = "192.168.31.254"
IP = 'localhost'

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="",
    database="danhgia"
)

@app.route("/")
def index():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    
    if session.get('idPerm') == 2: # Staff
        return redirect(url_for('appStaff.DashboardStaff'))

    elif session.get('idPerm') == 3: # Teacher
        return redirect(url_for('appTeacher.DashboardTeacher'))

    elif session.get('idPerm') == 4: # Student
        return redirect(url_for('appStudent.DashboardStudent'))

    mycursor = mydb.cursor()
    mycursor.execute("SELECT a.idClassCourse, CONCAT(a.codeClassCourse,' ',b.codeCourse,'- ',b.nameCourse) as fullnameClassCourse"
                     " FROM Classcourse a"
                     " LEFT JOIN Courses b ON a.idCourse = b.idCourse")
    data = mycursor.fetchall()
    return render_template("classcourse.html", response=data)

@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('appAuth.Login'))

# @app.errorhandler(404)
# def page_not_found(error):
#   return render_template('Student/404.html'), 404

if __name__ == "__main__":
    app.run(host=IP, port=5000, debug=True)