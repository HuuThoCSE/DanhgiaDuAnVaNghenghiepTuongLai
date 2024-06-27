from flask import Blueprint, request, render_template, session, url_for, redirect, flash
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

    mycursor = mydb.cursor()
    query = """
            SELECT histviewproject_idproject, CONCAT(student_code, ' - ' ,projects.nameProject)
            from hist_viewproject
            INNER Join Projects ON hist_viewproject.histviewproject_idproject = Projects.project_id
            where hist_viewproject.histviewproject_idAccount = %(idAccount)s
            ORDER BY hist_viewproject.histviewproject_timestamp DESC
            LIMIT 8;
            """
    mycursor.execute(query, {'idAccount': session['idAccount']})
    data = mycursor.fetchall()

    query = """
                SELECT histviewcourse_idclasscourse, CONCAT(classcourse.classcourse_code, ' - ' ,courses.course_name)
                from hist_viewcourse
                INNER Join classcourse ON hist_viewcourse.histviewcourse_idclasscourse = classcourse.classcourse_id
                INNER Join courses ON classcourse.course_code = courses.course_code
                where hist_viewcourse.histviewcourse_idAccount = %(idAccount)s
                ORDER BY hist_viewcourse.histviewcourse_timestamp DESC
                LIMIT 8;
                """
    mycursor.execute(query, {'idAccount': session['idAccount']})
    data2 = mycursor.fetchall()
    mycursor.close()


    return render_template('teacher/teacher_dashboard.html', title='TRANG CHỦ', response = data, hist_course = data2)

@appTeacher.route('/profile')
def profileTeacher():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if session.get('idPerm') != 3:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."

    mycursor.execute("SELECT username, CONCAT(lastnameTeacher,' ', firstnameTeacher) as fullname"
                      " from Teachers"
                      " INNER Join Accounts ON Teachers.account_id = Accounts.account_id"
                      " where teacher_id=%s", (session.get('idTeacher'), ))
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

    mycursor = mydb.cursor()
    mycursor.execute("SELECT a.classcourse_id, a.classcourse_code, CONCAT(b.course_code,' - ',b.course_name) as fullnameClassCourse, CONCAT(c.lastnameTeacher, ' ',c.firstnameTeacher)"
                     " FROM Classcourse a"
                     " LEFT JOIN Courses b ON a.course_code = b.course_code"
                     " LEFT JOIN Teachers c ON a.teacher_id = c.teacher_id"
                     " WHERE c.teacher_id=%s", (session.get('idTeacher'), ))
    data = mycursor.fetchall()
    mycursor.close()
    return render_template('teacher/project_listclass.html', response=data)

@appTeacher.route('class/<nbr>/ListProject')
def ListProjectTeacher(nbr):
    idClassCourse = nbr
    mycursor = mydb.cursor()
    mycursor.execute("SELECT a.idProject, a.nameProject, CONCAT(b.codeStudent, ' - ', b.student_lastname, ' ', b.student_firstname) as infoStudent, a.idClassCourse"
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
    mycursor.execute("SELECT idClassCourse, codeClassCourse, CONCAT(codeClassCourse, ' | ', course_code, ' - ',course_name), CONCAT(lastnameTeacher, ' ', firstnameTeacher)"
                     " FROM Classcourse"
                     " LEFT JOIN Courses ON Classcourse.idCourse = Courses.idCourse"
                     " LEFT JOIN Teachers ON Classcourse.idTeacher = Teachers.idTeacher"
                     " where idClassCourse=%s", (idClassCourse, ))
    data = mycursor.fetchone()    
    print(data)
    return render_template('teacher/project_class.html', title = data[1], response=data, dataclass=idClassCourse, idPerm=session.get('idPerm'))

# @appTeacher.route('class/<nbr>/Project')
# def ProjectTeacher(nbr):
#     idProject = nbr
#     mycursor = mydb.cursor()
#     mycursor.execute("SELECT a.idProject, a.nameProject, CONCAT(b.codeStudent, ' - ', b.student_lastname, ' ', b.student_firstname) as infoStudent"
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
    mycursor.execute("SELECT a.idProject, a.nameProject, CONCAT(b.codeStudent, ' - ', b.student_lastname, ' ', b.student_firstname) as infoStudent"
                     " FROM Projects a"
                     " LEFT JOIN Students b ON b.student_code = a.leader_code"
                     " WHERE idProject=%s", (idProject, ))
    data = mycursor.fetchall()
    return render_template('teacher/project_class.html')

# Đề xuất đồ án với đường dẫn /project-proposals
@appTeacher.route('/project-proposals')
def ProjectProposals():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if session.get('idPerm') != 3:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."

    teacher_id = session.get('idTeacher')
    query = """
            SELECT a.proposal_id, a.proposal_title, a.proposal_description, a.teacherApproved_status, a.staffApproved_status,
                CONCAT(c.course_code, ' - ', c.course_name),
                CONCAT(s.student_code, ' - ', s.student_lastname, ' ', s.student_firstname),
                DATE_FORMAT(a.datetimeProposal, '%H:%i:%s %d-%m-%Y'),
                DATE_FORMAT(a.teacherApproved_datetime, '%H:%i:%s %d-%m-%Y')
            FROM ProjectProposal a
            LEFT JOIN Students s ON a.student_code = s.student_code
            LEFT JOIN Teachers b ON a.teacher_code = b.teacher_code
            LEFT JOIN Courses c ON a.course_code = c.course_code
            WHERE b.teacher_id = %(teacher_id)s
        """
    mycursor.execute(query, {'teacher_id': teacher_id})
    data = mycursor.fetchall()

    print(data)

    return render_template('teacher/project_proposals.html', title="Đề xuất Đề tài", response=data, idPerm=session.get('idPerm'))

@appTeacher.route('/project-proposals/create', methods=['GET', 'POST'])
def CreateProjectProposals():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if session.get('idPerm') != 3:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."
    
    if request.method == 'POST':
        try:
            proposal_title = request.form['proposal_title']
            proposal_description = request.form['proposal_description']
            course_code = request.form['course_code']
            semester_code = request.form['semester_code']
            teacher_code = session.get('teacher_code')
            
            query = ("INSERT INTO ProjectProposal (proposal_title, proposal_description, course_code, teacher_code, semester_code, staffApproved_status)"
                     " VALUES (%s, %s, %s, %s, %s)")
            values = (proposal_title, proposal_description, course_code, teacher_code, semester_code, 1)
            mycursor.execute(query, values)
            mydb.commit()

            flash('Thêm đề xuất đề tài thành công!', 'success')  # 'success' is a category
            return redirect(url_for('appTeacher.ProjectProposals'))
        except Exception as e:
            flash('An error occurred: ' + str(e), 'error')  # 'error' is a category
            return str(e), 500
        
    mycursor.execute("SELECT course_code, CONCAT(course_code, ' - ', course_name) as fullnameCourse from Courses")
    courses = mycursor.fetchall()

    mycursor.execute("SELECT semester_code, CONCAT(semester_code, ' - Học kỳ ', nameSemester, ', ', yearSemester) from Semesters")
    semesters = mycursor.fetchall()

    return render_template('teacher/project_proposal_create.html', courses=courses, semesters=semesters, idPerm=session.get('idPerm'))

@appTeacher.route('/project-proposals/modify/<int:proposal_id>', methods=['GET', 'POST'])
def ModifyProposalTeacher(proposal_id):
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if session.get('idPerm') != 3:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."
    
    if request.method == 'POST':
        proposal_title = request.form['proposal_title']
        proposal_description = request.form['proposal_description']
        course_code = request.form['course_code']
        semester_code = request.form['semester_code']
        
        try:
            query = """
                UPDATE ProjectProposal
                SET proposal_title = %s, proposal_description = %s, course_code = %s, 
                    semester_code = %s
                WHERE proposal_id = %s
            """
            values = (proposal_title, proposal_description, course_code, semester_code, proposal_id)
            mycursor.execute(query, values)
            mydb.commit()
            
            flash('Cập nhật đề xuất đề tài thành công!', 'success')
            return redirect(url_for('appTeacher.ProjectProposals'))
        except Exception as e:
            flash('An error occurred: ' + str(e), 'error')
            return str(e), 500
    
    # Truy vấn dữ liệu hiện có để hiển thị trong form
    mycursor.execute("""
        SELECT proposal_title, proposal_description, course_code, semester_code
        FROM ProjectProposal
        WHERE proposal_id = %s
    """, (proposal_id,))
    data = mycursor.fetchone()

    print(data)
    
    # Truy vấn danh sách các khóa học và học kỳ
    mycursor.execute("SELECT course_code, CONCAT(course_code, ' - ', course_name) as fullnameCourse from Courses")
    courses = mycursor.fetchall()
    
    mycursor.execute("SELECT semester_code, CONCAT(semester_code, ' - Học kỳ ', nameSemester, ', ', yearSemester) from Semesters")
    semesters = mycursor.fetchall()
    
    return render_template('teacher/project_proposal_modify.html', data=data, courses=courses, semesters=semesters, idPerm=session.get('idPerm'))

@appTeacher.route('/project-proposals/approve/<int:projectproposals_id>', methods=['POST'])
def project_proposals(projectproposals_id):
    if request.method == 'POST':
        mycursor = None
        try:
            mycursor = mydb.cursor()
            query = ("UPDATE projectproposal SET teacherApproved_status = 1, teacherApproved_datetime = NOW(), teacherApproved=%s where proposal_id=%s")
            values = (session.get('staff_code'), projectproposals_id, )
            mycursor.execute(query, values)
            mydb.commit()
        except Exception as e:
            print(f'An error occurred: {e}', 'error')  # 'error' is a category
            if mycursor:
                mycursor.close()
            return str(e), 500
        finally:
            if mycursor:
                mycursor.close()
        return redirect(url_for('appTeacher.ProjectProposals'))