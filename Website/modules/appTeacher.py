from flask import Blueprint, request, render_template, session, url_for, redirect
import mysql.connector

# Tạo Blueprint cho module
appTeacher = Blueprint('appTeacher', __name__, static_folder='../statics')

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="",
    database="danhgia"
)

mycursor = mydb.cursor()

# Định nghĩa route trong module
@appTeacher.route('/dashboard')
def DashboardTeacher():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if session.get('idPerm') != 3:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."
    return render_template('teacher/dashboard.html')


@appTeacher.route('/project/panel')
def PanelProjectTeacher():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    return render_template('teacher/project_dashboard.html')

@appTeacher.route('/class')
def ListClassTeacher():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    
    mycursor.execute("SELECT a.idClassCourse, a.codeClassCourse, CONCAT(b.codeCourse,' - ',b.nameCourse) as fullnameClassCourse"
                     " FROM Classcourse a"
                     " LEFT JOIN Courses b ON a.idCourse = b.idCourse")
    data = mycursor.fetchall()

    return render_template('teacher/project_listclass.html', response=data)

@appTeacher.route('/project/<nbr>/class')
def ClassProjectTeacher():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    
    idClassCourse = nbr
    mycursor = mydb.cursor()
    mycursor.execute("SELECT *"
                     " FROM Projects"
                     " where idClassCourse=%s", (idClassCourse, ))
    data = mycursor.fetchall()    

    return render_template('teacher/project_class.html')