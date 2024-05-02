from flask import Blueprint, request, render_template, session, url_for, redirect
import mysql.connector

# Tạo Blueprint cho module
appStudent = Blueprint('appStudent', __name__, static_folder='../statics')

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="",
    database="danhgia"
)

mycursor = mydb.cursor()

# Định nghĩa route trong module
@appStudent.route('/') # dashboard
def DashboardStudent():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if session.get('idPerm') != 4:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."
    
    return render_template('student/student_dashboard.html')

@appStudent.route('/project')
def listClassProject():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if session.get('idPerm') != 4:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."

    mycursor.execute("SELECT *"
                        " from projects"
                        " INNER JOIN Students ON projects.idLeader = Students.idStudent"
                        " where idStudent=%s", (session.get('idStudent'), ))
    data = mycursor.fetchall()

    print(data)

    return render_template('student/list_classproject.html', response=data)

@appStudent.route('/profile')
def profileStudent():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if session.get('idPerm') != 4:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."

    mycursor.execute("SELECT username, codeStudent, CONCAT(lastnameStudent,' ',firstnameStudent) as fullname, nameIndustry"
                      " from Students"
                      " INNER Join Account ON Students.idAccount = Account.idAccount"
                      " INNER JOIN Industries ON Students.IdIndustry = Industries.IdIndustry"
                      " where idStudent=%s", (session.get('idStudent'), ))
    data = mycursor.fetchall()
    
    print(data)

    return render_template('student/student_profile.html', response=data)

@appStudent.route('/class')
def ListClassStudent():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    
    mycursor.execute("SELECT a.idClassCourse, b.codeClassCourse, CONCAT(c.codeCourse,' - ',c.nameCourse) as fullnameClassCourse, CONCAT(d.lastnameTeacher, ' ',d.firstnameTeacher)"
                     " FROM ErollClassCourse a"
                     " LEFT JOIN ClassCourse b ON a.idClassCourse = b.idClassCourse"
                     " LEFT JOIN Courses c ON b.idCourse = c.idCourse"
                     " LEFT JOIN Teachers d ON b.idTeacher = d.idTeacher"
                     " WHERE idStudent=%s", (session.get('idStudent'), ))
    data = mycursor.fetchall()

    return render_template('student/student_listclass.html', response=data)