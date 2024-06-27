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
    return render_template('student/student_dashboard.html', title='TRANG CHỦ', response = data, hist_course = data2)

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

    return render_template('student/list_classproject.html', response=data, idPerm=session.get('idPerm'))

@appStudent.route('/profile')
def profileStudent():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if session.get('idPerm') != 4:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."

    mycursor.execute("SELECT username, student_code, CONCAT(student_lastname,' ',student_firstname) as fullname, industry_name_VNI"
                      " from Students"
                      " INNER Join Accounts ON Students.Account_id = Accounts.Account_id"
                      " INNER JOIN Industries ON Students.Industry_id = Industries.Industry_id"
                      " where student_id=%s", (session.get('idStudent'), ))
    data = mycursor.fetchall()
    
    print(data)

    return render_template('student/student_profile.html', response=data, title='Profile', idPerm=session.get('idPerm'))

@appStudent.route('/class')
def ListClassStudent():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    
    mycursor.execute("SELECT b.classcourse_id, b.classcourse_code, CONCAT(c.course_code,' - ',c.course_name) as fullnameClassCourse, CONCAT(d.lastnameTeacher, ' ',d.firstnameTeacher)"
                     " FROM ErollClassCourse a"
                     " LEFT JOIN ClassCourse b ON a.classcourse_code = b.classcourse_code"
                     " LEFT JOIN Courses c ON b.course_code = c.course_code"
                     " LEFT JOIN Teachers d ON b.teacher_id = d.teacher_id"
                     " WHERE student_code=%s", (session.get('student_code'), ))
    data = mycursor.fetchall()
    return render_template('student/student_listclass.html', response=data, idPerm=session.get('idPerm'))