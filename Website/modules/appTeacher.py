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
@appTeacher.route('/') # dashboard
def DashboardTeacher():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if session.get('idPerm') != 3:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."
    return render_template('teacher/teacher_dashboard.html')

@appTeacher.route('/profile')
def profileTeacher():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if session.get('idPerm') != 3:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."

    mycursor.execute("SELECT username, CONCAT(lastnameTeacher,' ', firstnameTeacher) as fullname"
                      " from Teachers"
                      " INNER Join Account ON Teachers.idAccount = Account.idAccount"
                      " where idTeacher=%s", (session.get('idTeacher'), ))
    data = mycursor.fetchall()
    
    print(data)

    return render_template('teacher/teacher_profile.html', response=data)


# @appTeacher.route('/project/panel')
# def PanelProjectTeacher():
#     if 'loggedin' not in session:
#         return redirect(url_for('appAuth.Login'))
#     return render_template('teacher/project_dashboard.html')

@appTeacher.route('/class')
def ListClassTeacher():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    
    mycursor.execute("SELECT a.idClassCourse, a.codeClassCourse, CONCAT(b.codeCourse,' - ',b.nameCourse) as fullnameClassCourse"
                     " FROM Classcourse a"
                     " LEFT JOIN Courses b ON a.idCourse = b.idCourse"
                     " WHERE idTeacher=%s", (session.get('idTeacher'), ) )
    data = mycursor.fetchall()

    return render_template('teacher/project_listclass.html', response=data)

@appTeacher.route('class/<nbr>/ListProject')
def ListProjectTeacher(nbr):
    idClassCourse = nbr
    mycursor = mydb.cursor()
    mycursor.execute("SELECT a.idProject, a.nameProject, CONCAT(b.codeStudent, ' - ', b.lastnameStudent, ' ', b.firstnameStudent) as infoStudent, a.idClassCourse"
                     " FROM Projects a"
                     " LEFT JOIN Students b ON a.IdLeader = b.IdStudent"
                     " WHERE idClassCourse=%s", (idClassCourse, ))
    data = mycursor.fetchall()
    print(data)
    return render_template('teacher/project_ListProject.html', response=data)

@appTeacher.route('/class/<nbr>')
def ClassProjectTeacher(nbr):
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    
    idClassCourse = nbr
    mycursor = mydb.cursor()
    mycursor.execute("SELECT idClassCourse, codeClassCourse, CONCAT(codeClassCourse, ' | ', codeCourse, ' - ',nameCourse), CONCAT(lastnameTeacher, ' ', firstnameTeacher)"
                     " FROM Classcourse"
                     " LEFT JOIN Courses ON Classcourse.idCourse = Courses.idCourse"
                     " LEFT JOIN Teachers ON Classcourse.idTeacher = Teachers.idTeacher"
                     " where idClassCourse=%s", (idClassCourse, ))
    data = mycursor.fetchone()    
    print(data)
    return render_template('teacher/project_class.html', title = data[1], response=data, dataclass=idClassCourse)

# @appTeacher.route('class/<nbr>/Project')
# def ProjectTeacher(nbr):
#     idProject = nbr
#     mycursor = mydb.cursor()
#     mycursor.execute("SELECT a.idProject, a.nameProject, CONCAT(b.codeStudent, ' - ', b.lastnameStudent, ' ', b.firstnameStudent) as infoStudent"
#                      " FROM Projects a"
#                      " LEFT JOIN Students b ON a.IdLeader = b.IdStudent"
#                      " WHERE idProject=%s", (idProject, ))
#     data = mycursor.fetchall()
#     return render_template('teacher/project_class.html')

@appTeacher.route('class/<idclass>/Project/<idproject>')
def PanelProjectTeacher(idclass, idproject):
    idClass = idclass
    idProject = idproject
    mycursor = mydb.cursor()
    mycursor.execute("SELECT a.idProject, a.nameProject, CONCAT(b.codeStudent, ' - ', b.lastnameStudent, ' ', b.firstnameStudent) as infoStudent"
                     " FROM Projects a"
                     " LEFT JOIN Students b ON a.IdLeader = b.IdStudent"
                     " WHERE idProject=%s", (idProject, ))
    data = mycursor.fetchall()
    return render_template('teacher/project_class.html')

