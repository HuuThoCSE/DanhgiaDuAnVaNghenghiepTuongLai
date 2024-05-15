from flask import Blueprint, request, render_template, session, url_for, redirect
import mysql.connector

# Tạo Blueprint cho module
appClassCourse = Blueprint('appClassCourse', __name__, static_folder='../statics')

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="",
    database="danhgia"
)

mycursor = mydb.cursor()

# Tạo cấu trúc dữ liệu cho các menu
def get_menu(idPerm):
    menus = []
    if idPerm == 1:  # Admin
        menus.append({
            'title': 'Giảng viên',
            'icon': 'fa-cog',
            'submenus': [
                {'name': 'Danh sách giảng viên', 'url': '/staff/teacher'},
                {'name': 'Thêm giáo viên', 'url': '/staff/teacher/add'}
            ]
        })
    if idPerm == 1 or idPerm == 2:  # Admin hoặc Nhân viên quản lý
        menus.append({
            'title': 'Lớp học',
            'icon': 'fa-cog',
            'submenus': [
                {'name': 'Danh sách lớp học', 'url': '/staff/ListClass'}
            ]
        })
    if idPerm == 3:  # Chỉ Giáo viên
        menus.append({
            'title': 'Đề tài',
            'icon': 'fa-book',
            'submenus': [
                {'name': 'Danh sách đề tài', 'url': '/teacher/topics'},
                {'name': 'Thêm đề tài mới', 'url': '/teacher/topics/add'}
            ]
        })
    if idPerm == 4:  # Chỉ Sinh viên
        menus.append({
            'title': 'Các khóa học',
            'icon': 'fa-graduation-cap',
            'submenus': [
                {'name': 'Khóa học đang theo học', 'url': '/student/courses'},
                {'name': 'Đề tài đang thực hiện', 'url': '/student/projects'}
            ]
        })
    return menus

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
@appClassCourse.route('/teacher/<nbr>')
def TeacherClass(nbr):
    idClassCourse = nbr
    mycursor = mydb.cursor()
    mycursor.execute("SELECT a.idClassCourse, a.codeClassCourse, CONCAT(b.course_code, ' - ', b.nameCourse) as fullnameCourse,CONCAT(c.lastnameTeacher, ' ', c.firstnameTeacher) as fullnameTeaccher"
                     " FROM ClassCourse a"
                     " LEFT JOIN Courses b ON a.idCourse = b.idCourse"
                     " LEFT JOIN Teachers c ON a.idTeacher = c.idTeacher"
                     " where idClassCourse=%s", (idClassCourse, ))
    data = mycursor.fetchall()
    return render_template('ClassCourse/panel.html', response=data)

@appClassCourse.route('/<idClassCourse>')
def editTeacherClass(idClassCourse):
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if 'idPerm' not in session:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."

    mycursor = mydb.cursor()
    mycursor.execute("SELECT idClassCourse, codeClassCourse, nameCourse, CONCAT(course_code,' - ', nameCourse), CONCAT(c.lastnameTeacher, ' ',c.firstnameTeacher)"
                     " FROM ClassCourse a"
                     " LEFT JOIN Courses b ON b.idCourse = a.idCourse"
                     " LEFT JOIN Teachers c ON c.idTeacher = a.idTeacher"
                     " where idClassCourse=%s", (idClassCourse, ))
    data = mycursor.fetchone()
    print(data)
    menus = get_menu(session.get('idPerm'))
    
    return render_template('ClassCourse/index_course.html', title=data[2], response=data, idPerm=session.get('idPerm'), menus=menus)


@appClassCourse.route('/<idClassCourse>/project')
def ProjectClassCourse(idClassCourse):
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if 'idPerm' not in session:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."
    
    mycursor = mydb.cursor()
    mycursor.execute("SELECT idClassCourse, codeClassCourse, nameCourse, CONCAT(course_code,' - ', nameCourse), CONCAT(c.lastnameTeacher, ' ',c.firstnameTeacher)"
                     " FROM ClassCourse a"
                     " LEFT JOIN Courses b ON b.idCourse = a.idCourse"
                     " LEFT JOIN Teachers c ON c.idTeacher = a.idTeacher"
                     " where idClassCourse=%s", (idClassCourse, ))
    data = mycursor.fetchone()
    print(data)

    role = session.get('idPerm')

    return render_template('ClassCourse/index_course.html', title=data[2], response=data, idPerm=session.get('idPerm'))