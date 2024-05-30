from flask import Blueprint, request, render_template, session, url_for, redirect, flash
import mysql.connector

# Tạo Blueprint cho module
appStaff = Blueprint('appStaff', __name__, static_folder='../statics')

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="",
    database="danhgia"
)


# Định nghĩa route trong module
@appStaff.route('/') # dashboard
def DashboardStaff():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if session.get('idPerm') != 2:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."
    
    return render_template('staff/staff_dashboard.html', title='Staff Dashboard', idPerm=session.get('idPerm'))

@appStaff.route('/teacher')
def TeacherStaff():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if session.get('idPerm') != 2:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."
    mycursor = mydb.cursor()
    mycursor.execute("SELECT teacher_id, CONCAT(lastnameTeacher,' ',firstnameTeacher), sex, birthday "
                    " from Teachers")
    data = mycursor.fetchall()    
    
    return render_template('staff/staff_teacher.html', response=data)

def loadTeacher():
    mycursor = mydb.cursor()
    mycursor.execute("SELECT teacher_id, CONCAT(lastnameTeacher,' ',firstnameTeacher) from Teachers")
    data = mycursor.fetchall()  
    return data

@appStaff.route('/teacher/add', methods=['GET', 'POST'])
def AddTeacherStaff():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if session.get('idPerm') != 2:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."
    if request.method == 'POST':
        try:
            lastnameTeacher = request.form['lastnameTeacher']
            firstnameTeacher = request.form['firstnameTeacher']
            sex = request.form['sex']
            birthday = request.form['birthday']
            
            mycursor = mydb.cursor()
            query= ("INSERT INTO Teachers (lastnameTeacher, firstnameTeacher, sex, birthday) VALUES (%s, %s, %s, %s)")
            values = (lastnameTeacher, firstnameTeacher, sex, birthday,)
            mycursor.execute(query, values)
            mydb.commit()
            
            flash('Thêm giảng viên thành công!', 'success')  # 'success' is a category
            return redirect(url_for('appStaff.AddTeacherStaff'))
        except Exception as e:
            flash('An error occurred: ' + str(e), 'error')  # 'error' is a category
            return str(e), 500

    return render_template('staff/staff_addteacher.html', idPerm=session.get('idPerm'))


@appStaff.route('/ListClass')
def ListClassStaff():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if session.get('idPerm') != 2:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."

    mycursor = mydb.cursor()
    mycursor.execute("SELECT a.ClassCourse_id, a.classCourse_code, CONCAT(b.course_code,' - ',b.course_name) as fullnameClassCourse, CONCAT(c.lastnameTeacher, ' ',c.firstnameTeacher)"
                     " FROM Classcourse a"
                     " LEFT JOIN Courses b ON a.course_code = b.course_code"
                     " LEFT JOIN Teachers c ON a.teacher_id = c.teacher_id")
    data = mycursor.fetchall()  
    
    return render_template('staff/staff_listclass.html', response=data, idPerm=session.get('idPerm'))


@appStaff.route('/project-proposals')
def ProjectProposalStaff():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if session.get('idPerm') != 2:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."
    
    mycursor = None
    data = None
    try:
        mycursor = mydb.cursor()
        query = """
            SELECT a.proposal_id, a.proposal_title, a.proposal_description, 
                a.teacherApproved_status, a.staffApproved_status, 
                CONCAT(s.student_code, ' - ',s.student_lastname, ' ', s.student_firstname),
                CONCAT(c.course_code, ' - ', c.course_name) AS course_info,
                CONCAT(lastnameTeacher, ' ', firstnameTeacher) AS teacher_fullname,
                DATE_FORMAT(a.datetimeProposal, '%H:%i:%s %d-%m-%Y') AS datetimeProposal,
                DATE_FORMAT(a.teacherApproved_datetime, '%H:%i:%s %d-%m-%Y') AS teacherApproved_datetime,
                DATE_FORMAT(a.staffApproved_datetime, '%H:%i:%s %d-%m-%Y') AS staffApproved_datetime
            FROM ProjectProposal a
            LEFT JOIN Students s ON a.student_code = s.student_code
            LEFT JOIN Teachers b ON a.teacher_code = b.teacher_code
            LEFT JOIN Courses c ON a.course_code = c.course_code
            WHERE teacherApproved_status = 1"""
        mycursor.execute(query)
        data = mycursor.fetchall()
        print(data)
    except Exception as e:
            flash('An error occurred: ' + str(e), 'error')  # 'error' is a category
            return str(e), 500
    finally:
        # Đóng cursor và kết nối
        if mycursor:
            mycursor.close()
    return render_template('staff/project-proposals.html', title="Đề xuất đồ án", response=data, idPerm=session.get('idPerm'))


@appStaff.route('/project-proposals/approve/<int:projectproposals_id>', methods=['POST'])
def project_proposals(projectproposals_id):
    if request.method == 'POST':
        mycursor = None
        try:
            mycursor = mydb.cursor()
            query = ("UPDATE projectproposal SET staffApproved_status = 1, staffApproved_datetime = NOW(), staffApproved=%s where proposal_id=%s")
            values = (session.get('staff_code'), projectproposals_id, )
            mycursor.execute(query, values)
            mydb.commit()
            mycursor.close()
        except Exception as e:
                print('An error occurred: ' + str(e), 'error')  # 'error' is a category
                return str(e), 500
        return redirect(url_for('appStaff.ProjectProposalStaff'))

