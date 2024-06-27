from flask import Blueprint, request, render_template, session, url_for, redirect, flash
import requests
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
    
    return render_template('staff/staff_dashboard.html', title='TRANG CHỦ', idPerm=session.get('idPerm'), response = data, hist_course = data2)
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
    mycursor.close()

    return render_template('staff/staff_teacher.html', response=data)

def loadTeacher():
    mycursor = mydb.cursor()
    mycursor.execute("SELECT teacher_id, CONCAT(lastnameTeacher,' ',firstnameTeacher) from Teachers")
    data = mycursor.fetchall()
    mycursor.close()

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
            mycursor.close()
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
    mycursor.close()

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
                DATE_FORMAT(a.staffApproved_datetime, '%H:%i:%s %d-%m-%Y') AS staffApproved_datetime,
                a.category
            FROM ProjectProposal a
            LEFT JOIN Students s ON a.student_code = s.student_code
            LEFT JOIN Teachers b ON a.teacher_code = b.teacher_code
            LEFT JOIN Courses c ON a.course_code = c.course_code
            WHERE teacherApproved_status = 1"""
        mycursor.execute(query)
        data = mycursor.fetchall()
        print(data)
        mycursor.close()
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

            # Lấy tên dự án từ cơ sở dữ liệu
            query = "SELECT proposal_title FROM projectproposal WHERE proposal_id = %s"
            values = (projectproposals_id,)
            mycursor.execute(query, values)
            project_name = mycursor.fetchone()[0]

            # Gọi API /predict để dự đoán
            response = requests.post('http://localhost:5000/predict', json={'project_name': project_name})
            response_data = response.json()  # Lấy dữ liệu JSON từ phản hồi

            # Lưu kết quả dự đoán vào cơ sở dữ liệu (nếu cần)
            predicted_categories = response_data['categories']
            update_query = "UPDATE projectproposal SET category = %s, staffApproved_datetime = NOW(), staffApproved_status = 1, staffApproved = %s WHERE proposal_id = %s"
            update_values = (predicted_categories, "ST"+str(session.get('idStaff')), projectproposals_id)
            mycursor.execute(update_query, update_values)
            mydb.commit()
        except Exception as e:
            print(f'An error occurred: {e}', 'error')  # 'error' is a category
            if mycursor:
                mycursor.close()
            return str(e), 500
        finally:
            if mycursor:
                mycursor.close()
        return redirect(url_for('appStaff.ProjectProposalStaff'))

