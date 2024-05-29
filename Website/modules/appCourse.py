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
                {'name': 'Danh sách Đề xuất', 'url': '/teacher/project-proposals'},
                {'name': 'Thêm Đề xuất', 'url': '/teacher/project-proposals/create'}
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
    mycursor.execute("SELECT a.classcourse_id, a.classcourse_code, CONCAT(b.course_code, ' - ', b.course_name) as fullnameCourse,CONCAT(c.lastnameTeacher, ' ', c.firstnameTeacher) as fullnameTeaccher"
                     " FROM ClassCourse a"
                     " LEFT JOIN Courses b ON a.course_id = b.course_id"
                     " LEFT JOIN Teachers c ON a.teacher_id = c.teacher_id"
                     " where classcourse_id=%s", (idClassCourse, ))
    data = mycursor.fetchall()

    mycursor.close()
    return render_template('ClassCourse/panel.html', response=data)

@appClassCourse.route('/<idClassCourse>')
def editTeacherClass(idClassCourse):
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if 'idPerm' not in session:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."

    mycursor = mydb.cursor()
    
    query = """
            SELECT classcourse_id, classcourse_code, course_name, CONCAT(course_code,' - ', course_name), CONCAT(c.lastnameTeacher, ' ',c.firstnameTeacher),
                DATE_FORMAT(a.dateStart, '%d-%m-%Y'),
                DATE_FORMAT(a.dateEnd, '%d-%m-%Y')
            FROM ClassCourse a
            LEFT JOIN Courses b ON b.course_id = a.course_id
            LEFT JOIN Teachers c ON c.teacher_id = a.teacher_id
            where classcourse_id = %(teacher_id)s
        """
    mycursor.execute(query, {'teacher_id': idClassCourse})
    data = mycursor.fetchone()
    print(data)

    menus = get_menu(session.get('idPerm'))
    
    mycursor.close()
    return render_template('ClassCourse/classscourse_dashboard.html', title=data[2], response=data, idPerm=session.get('idPerm'), menus=menus)


@appClassCourse.route('/<idClassCourse>/project')
def ProjectClassCourse(idClassCourse):
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if 'idPerm' not in session:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."

    if session['idPerm'] == 4:
        mycursor = mydb.cursor()
        mycursor.execute("SELECT project_id FROM Projects WHERE student_code = %s AND classcourse_id = %s LIMIT 1", 
                         (session['student_code'], idClassCourse))
        project = mycursor.fetchone()
        
        if project:
            return redirect('/project/' + str(project['project_id']))
        else:
            return "Không tìm thấy dự án cho khóa học này."

    mycursor = mydb.cursor()
    mycursor.execute("SELECT a.project_id, a.nameProject, CONCAT(b.student_code, ' - ', b.lastnameStudent, ' ', b.firstnameStudent) as infoStudent, a.project_status"
                     " FROM Projects a"
                     " LEFT JOIN Students b ON a.student_code = b.student_code"
                     " WHERE classcourse_id=%s", (idClassCourse, ))
    data = mycursor.fetchall()
    print(data)

    menus = get_menu(session.get('idPerm'))

    mycursor.close()
    return render_template('ClassCourse/classscourse_project.html', title=data[2], response=data, idPerm=session.get('idPerm'), menus=menus)