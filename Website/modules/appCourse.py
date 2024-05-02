from flask import Blueprint, request, render_template, session, url_for, redirect
import mysql.connector

# Tạo Blueprint cho module
appCourse = Blueprint('appCourse', __name__, static_folder='../statics')

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="",
    database="danhgia"
)

mycursor = mydb.cursor()

def loadCourse(idCourseClass):
    mycursor = mydb.cursor()
    mycursor.execute("SELECT DayClass.*, CourseClass.codeCourseClass, CourseClass.nameCourseClass"
                     " FROM DayClass"
                     " INNER JOIN CourseClass ON DayClass.idCourseClass = CourseClass.idCourseClass "
                     " WHERE Dayclass.idCourseClass=%s order by 1 desc", (idCourseClass,))
    data = mycursor.fetchall()
    mycursor.close()

    return data

# Định nghĩa route trong module
@appCourse.route('/teacher/<nbr>')
def TeacherClass(nbr):
    idClassCourse = nbr
    mycursor = mydb.cursor()
    mycursor.execute("SELECT a.idClassCourse, a.codeClassCourse, CONCAT(b.CodeCourse, ' - ', b.nameCourse) as fullnameCourse,CONCAT(c.lastnameTeacher, ' ', c.firstnameTeacher) as fullnameTeaccher"
                     " FROM ClassCourse a"
                     " LEFT JOIN Courses b ON a.idCourse = b.idCourse"
                     " LEFT JOIN Teachers c ON a.idTeacher = c.idTeacher"
                     " where idClassCourse=%s", (idClassCourse, ))
    data = mycursor.fetchall()
    return render_template('ClassCourse/panel.html', response=data)

@appCourse.route('/<idClassCourse>')
def editTeacherClass(idClassCourse):
    mycursor = mydb.cursor()
    mycursor.execute("SELECT idClassCourse, codeClassCourse, nameCourse, CONCAT(CodeCourse,' - ', nameCourse), CONCAT(c.lastnameTeacher, ' ',c.firstnameTeacher)"
                     " FROM ClassCourse a"
                     " LEFT JOIN Courses b ON b.idCourse = a.idCourse"
                     " LEFT JOIN Teachers c ON c.idTeacher = a.idTeacher"
                     " where idClassCourse=%s", (idClassCourse, ))
    data = mycursor.fetchone()
    print(data)
    return render_template('course/index_course.html', title=data[2], response=data)

