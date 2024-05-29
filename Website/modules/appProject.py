from flask import Blueprint, request, render_template, session, url_for, redirect
import mysql.connector

# Tạo Blueprint cho module
appProject = Blueprint('appProject', __name__, static_folder='../statics')

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="",
    database="danhgia"
)

# Định nghĩa route trong module
@appProject.route('/<int:project_id>')
def infoProject(project_id):
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if 'idPerm' not in session:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."

    mycursor = mydb.cursor()
    query = """
            SELECT a.project_id, a.nameProject, classcourse_code, CONCAT(d.course_code, ' - ', d.course_name),CONCAT(c.student_code, ' - ', c.lastnameStudent, ' ', c.firstnameStudent) as infoStudent, CONCAT(e.lastnameTeacher, ' ', e.firstnameTeacher), a.project_status,
                DATE_FORMAT(a.dateStart, '%d-%m-%Y'),
                DATE_FORMAT(a.dateEnd, '%d-%m-%Y')
            FROM Projects a
            LEFT JOIN ClassCourse b ON b.classcourse_id = a.classcourse_id
            LEFT JOIN Students c ON c.student_code = a.student_code
            LEFT JOIN Courses d ON d.course_id = b.course_id
            LEFT JOIN Teachers e ON e.teacher_code = a.teacher_code
            where project_id = %(project_id)s
        """
    mycursor.execute(query, {'project_id': project_id})
    data = mycursor.fetchone()
    
    print(data)
    
    mycursor.close()
    return render_template('Project/project_dashboard.html', response=data)