from flask import Blueprint, request, render_template, session, url_for, redirect
import mysql.connector

# Tạo Blueprint cho module
appStaff = Blueprint('appStaff', __name__, static_folder='../statics')

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="",
    database="danhgia"
)

mycursor = mydb.cursor()

# Định nghĩa route trong module
@appStaff.route('/dashboard')
def DashboardStaff():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if session.get('idPerm') != 2:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."
    
    return render_template('staff/staff_dashboard.html')

@appStaff.route('/teacher')
def TeacherStaff():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if session.get('idPerm') != 2:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."

    mycursor.execute("SELECT IdTeacher, CONCAT(lastnameTeacher,' ',firstnameTeacher), sex, birthday "
                    " from Teachers")
    data = mycursor.fetchall()    
    
    return render_template('staff/staff_teacher.html', response=data)

def loadTeacher():
    mycursor.execute("SELECT IdTeacher, CONCAT(lastnameTeacher,' ',firstnameTeacher) from Teachers")
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
            
            query= ("INSERT INTO Teachers (lastnameTeacher, firstnameTeacher, sex, birthday) VALUES (%s, %s, %s, %s)")
            values = (lastnameTeacher, firstnameTeacher, sex, birthday,)
            mycursor.execute(query, values)
            mydb.commit()

            return redirect(url_for('appStaff.AddTeacherStaff'))
        except Exception as e:
            print(e)
            return str(e), 500

    return render_template('staff/staff_addteacher.html')