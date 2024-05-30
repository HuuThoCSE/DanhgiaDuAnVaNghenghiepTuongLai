from flask import Blueprint, request, render_template, session, url_for, redirect, flash
import mysql.connector

# Tạo Blueprint cho module
appClassCourse = Blueprint('appClassCourse', __name__, static_folder='../statics')

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="",
    database="danhgia"
)

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

@appClassCourse.route('/teacher/<nbr>')
def TeacherClass(nbr):
    idClassCourse = nbr
    mycursor = mydb.cursor()
    mycursor.execute("""
        SELECT a.classcourse_id, a.classcourse_code, CONCAT(b.course_code, ' - ', b.course_name) AS fullnameCourse, 
        CONCAT(c.lastnameTeacher, ' ', c.firstnameTeacher) AS fullnameTeacher 
        FROM ClassCourse a
        LEFT JOIN Courses b ON a.course_code = b.course_code
        LEFT JOIN Teachers c ON a.teacher_id = c.teacher_id
        WHERE a.classcourse_id = %s""", (idClassCourse,)
    )
    data = mycursor.fetchall()

    mycursor.close()
    return render_template('ClassCourse/panel.html', response=data)

@appClassCourse.route('/<idClassCourse>', methods=['GET', 'POST'])
def editTeacherClass(idClassCourse):

    if request.method == 'POST':
        mycursor = mydb.cursor()
        query = """
                SELECT project_id FROM Projects WHERE classcourse_code = (SELECT classcourse_code FROM ClassCourse WHERE ClassCourse_id = %(idClassCourse)s) AND student_code = %(student_code)s
                """
        mycursor.execute(query, {'idClassCourse': idClassCourse, 'student_code': session.get('student_code')})
        data = mycursor.fetchone()  # Chỉ lấy một kết quả vì chúng ta mong đợi chỉ có một dự án

        if data:
            project_id = data[0]  # Lấy giá trị project_id từ tuple
            return redirect(url_for('appProject.infoProject', project_id=project_id))
        else:
            # Xử lý khi không tìm thấy dự án
            return "No project found for the given class course and student."

    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if 'idPerm' not in session:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."

    mycursor = mydb.cursor()
    query = """
            SELECT classcourse_id, classcourse_code, course_name, CONCAT(a.course_code,' - ', course_name), CONCAT(c.lastnameTeacher, ' ',c.firstnameTeacher),
                DATE_FORMAT(a.dateStart, '%d-%m-%Y'),
                DATE_FORMAT(a.dateEnd, '%d-%m-%Y')
            FROM ClassCourse a
            LEFT JOIN Courses b ON b.course_code = a.course_code
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
        mycursor.execute("SELECT project_id FROM Projects WHERE student_code = %s AND classcourse_code = (select classcourse_code from ClassCourse where classcourse_id = %s) LIMIT 1", 
                         (session['student_code'], idClassCourse))
        project = mycursor.fetchone()
        
        if project:
            return redirect('/project/' + str(project['project_id']))
        else:
            return "Không tìm thấy dự án cho khóa học này."

    mycursor = mydb.cursor()
    mycursor.execute("SELECT a.project_id, a.nameProject, CONCAT(b.student_code, ' - ', b.student_lastname, ' ', b.student_firstname) as infoStudent, a.project_status"
                     " FROM Projects a"
                     " LEFT JOIN Students b ON a.student_code = b.student_code"
                     " WHERE classcourse_code = (select classcourse_code from ClassCourse where classcourse_id = %s)", (idClassCourse, ))
    data = mycursor.fetchall()
    print(data)

    menus = get_menu(session.get('idPerm'))

    mycursor.close()
    return render_template('ClassCourse/classscourse_project.html', title=data[2], response=data, idPerm=session.get('idPerm'), menus=menus)

# Đề xuất đồ án cho sinh viên
@appClassCourse.route('<int:classcourse_id>/project-proposals')
def ProjectProposals(classcourse_id):
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if session.get('idPerm') != 4:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."

    mycursor = mydb.cursor()
    query = """
        SELECT a.proposal_id, a.proposal_title, a.proposal_description, a.teacherApproved_status, a.staffApproved_status, 
               CONCAT(c.course_code, ' - ', c.course_name) AS course_info,
               DATE_FORMAT(a.datetimeProposal, '%H:%i:%s %d-%m-%Y') AS datetimeProposal,
               DATE_FORMAT(a.teacherApproved_datetime, '%H:%i:%s %d-%m-%Y') AS teacherApproved_datetime,
               DATE_FORMAT(a.staffApproved_datetime, '%H:%i:%s %d-%m-%Y') AS staffApproved_datetime
        FROM ProjectProposal a
        LEFT JOIN Teachers b ON a.teacher_code = b.teacher_code
        LEFT JOIN Courses c ON a.course_code = c.course_code
        WHERE a.classcourse_code = (SELECT classcourse_code FROM ClassCourse WHERE classcourse_id = %(classcourse_id)s)
    """
    mycursor.execute(query, {'classcourse_id': classcourse_id})
    data = mycursor.fetchall()

    return render_template('ClassCourse/project_proposals.html', title="Đề xuất Đề tài", response=data, idPerm=session.get('idPerm'))

@appClassCourse.route('/<int:classcourse_id>/project-proposals/create', methods=['GET', 'POST'])
def CreateProjectProposals(classcourse_id):
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if session.get('idPerm') != 4:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."
    
    if request.method == 'POST':
        try:
            proposal_title = request.form['proposal_title']
            proposal_description = request.form['proposal_description']
            student_code = session.get('student_code')
            
            mycursor = mydb.cursor()
            # Truy vấn để lấy teacher_code từ bảng ClassCourse dựa trên classcourse_code
            mycursor.execute("""SELECT classcourse_code, course_code, semester_code, teacher_code
                             FROM ClassCourse 
                             LEFT JOIN Teachers ON ClassCourse.teacher_id = Teachers.teacher_id
                             WHERE ClassCourse_id = %s""", (classcourse_id,))
            result = mycursor.fetchone()
            if not result:
                flash('Không tìm thấy giáo viên cho khóa học này.', 'error')
                return redirect(request.url)
            
            classcourse_code = result[0]
            course_code = result[1]
            semester_code = result[2]
            teacher_code = result[3]
            
            # Chèn dữ liệu vào bảng ProjectProposal
            query = ("""
                INSERT INTO ProjectProposal (proposal_title, proposal_description, student_code, course_code, classcourse_code, semester_code, teacher_code)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """)
            values = (proposal_title, proposal_description, student_code, course_code, classcourse_code, semester_code, teacher_code)
            mycursor.execute(query, values)
            mydb.commit()

            flash('Thêm đề xuất đề tài thành công!', 'success')
            return redirect(url_for('appClassCourse.ProjectProposals', classcourse_id=classcourse_id))
        except Exception as e:
            flash('An error occurred: ' + str(e), 'error')
            return str(e), 500
    else:
        mycursor = mydb.cursor()
        query = """
                SELECT ClassCourse.course_code, CONCAT(ClassCourse.course_code, ' - ', course_name) as fullnameCourse
                FROM ClassCourse
                LEFT JOIN Courses ON ClassCourse.course_code = Courses.course_code
                WHERE ClassCourse.classcourse_id = %(classcourse_id)s
                """

        mycursor.execute(query, {'classcourse_id': classcourse_id})
        courses = mycursor.fetchone()

        print(courses)

        return render_template('ClassCourse/project_proposal_create.html', courses=courses, idPerm=session.get('idPerm'))
