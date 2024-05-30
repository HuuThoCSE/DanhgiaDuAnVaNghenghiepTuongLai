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
    

    if request.method == 'POST':
        project_id = request.form.get('project_id')
        student_code = session.get('student_code')
        milestone_name = request.form.get('milestone_name')
        milestone_description = request.form.get('milestone_description')

        mycursor = mydb.cursor()
        query = """
                INSERT INTO ProjectProgress (project_id, student_code, milestone_name, milestone_description)
                VALUES (%s, %s, %s, %s)
                """
        values = (project_id, student_code, milestone_name, milestone_description)

        mycursor.execute(query, values)
        mydb.commit()

        return redirect(url_for('project_page', project_id=project_id))

    mycursor = mydb.cursor()
    query = """
            SELECT a.project_id, a.nameProject, a.classcourse_code, CONCAT(d.course_code, ' - ', d.course_name),CONCAT(c.student_code, ' - ', c.student_lastname, ' ', c.student_firstname) as infoStudent, CONCAT(e.lastnameTeacher, ' ', e.firstnameTeacher), a.project_status,
                DATE_FORMAT(a.dateStart, '%d-%m-%Y'),
                DATE_FORMAT(a.dateEnd, '%d-%m-%Y')
            FROM Projects a
            LEFT JOIN ClassCourse b ON b.classcourse_code = a.classcourse_code
            LEFT JOIN Students c ON c.student_code = a.student_code
            LEFT JOIN Courses d ON d.course_code = b.course_code
            LEFT JOIN Teachers e ON e.teacher_code = a.teacher_code
            where project_id = %(project_id)s
        """
    mycursor.execute(query, {'project_id': project_id})
    data = mycursor.fetchone()
    
    print(data)
    
    mycursor.close()
    return render_template('Project/project_dashboard.html', 
                           response=data,
                           idPerm=session.get('idPerm'),)