from flask import Blueprint, request, render_template, session, url_for, redirect
import mysql.connector

# Tạo Blueprint cho module
appProject = Blueprint('appProject', __name__, static_folder='../statics')

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="",
    database="danhgia"
)

mycursor = mydb.cursor()

# Định nghĩa route trong module
@appProject.route('/<nbr>')
def infoProject(nbr):
    idProject = nbr
    mycursor = mydb.cursor()
    mycursor.execute("SELECT a.idProject, a.nameProject, CONCAT(b.codeStudent, ' - ', b.lastnameStudent, ' ', b.firstnameStudent) as infoStudent"
                     " FROM Projects a"
                     " LEFT JOIN Students b ON a.IdLeader = b.IdStudent"
                     " WHERE idProject=%s", (idProject, ))
    data = mycursor.fetchall()
    return render_template('Project/index.html', response=data)