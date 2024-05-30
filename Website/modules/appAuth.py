from flask import Blueprint, request, render_template, session, url_for, redirect
import mysql.connector

# Tạo Blueprint cho module
appAuth = Blueprint('appAuth', __name__, static_folder='../statics')

# Kết nối database
# connection = connect(config.DATABASE['host'])
# mycursor = connection.cursor()

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="",
    database="danhgia"
)

# Định nghĩa route trong module
@appAuth.route('/', methods=['GET', 'POST'])
def Login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        query = ("SELECT *"
                " FROM Accounts"
                " WHERE username = %s")
        values = (username,)
        mycursor = mydb.cursor()
        mycursor.execute(query, values)
        result = mycursor.fetchone()

        print(result)
        
        if result:
            fetched_hash = result[2]
            if fetched_hash == password:
                # Đăng nhập thành công
                session['loggedin'] = True
                session['idAccount'] = result[0]
                session['idPerm'] = result[3]
                
                print("ID Account:", session.get('idAccount'))
                print("Quyền:", session.get('idPerm'))

                if session.get('idPerm') == 2: # Staff
                    mycursor.execute("SELECT staff_id, staff_code from Staffs where account_id=%s", (result[0], ))
                    result1 = mycursor.fetchone()
                    session['idStaff'] = result1[0]
                    session['staff_code'] = result1[1]
                    print(result[0])
                    print(result1[1])
                    mycursor.close()
                    return redirect(url_for('appStaff.DashboardStaff'))

                elif session.get('idPerm') == 3: # Teacher
                    mycursor.execute("SELECT teacher_id, teacher_code from Teachers where account_id=%s", (result[0], ))
                    result1 = mycursor.fetchone()
                    session['idTeacher'] = result1[0]
                    session['teacher_code'] = result1[1]
                    print(result[0])
                    print(result1[1])
                    mycursor.close()
                    return redirect(url_for('appTeacher.DashboardTeacher'))

                elif session.get('idPerm') == 4: # Student
                    mycursor.execute("SELECT student_id, student_code from Students where account_id=%s", (result[0], ))
                    result1 = mycursor.fetchone()
                    session['idStudent'] = result1[0]
                    session['student_code'] = result1[1]
                    print(result1[0])
                    print(result1[1])
                    mycursor.close()
                    return redirect(url_for('appStudent.DashboardStudent'))
                else:
                    return "Quyền không tồn tại!!!"
            else:
                # Mật khẩu không đúng
                # error = 'Invalid credentials'
                error = 'Mật khẩu không đúng ' + str(password) + ' - ' + str(fetched_hash)
                return render_template('auth/authentication-login.html', error=error)
        else:
            # Tên người dùng không tồn tại
            # error = 'Invalid credentials'
            error = 'Tên người dùng không tồn tại'
            return render_template('auth/authentication-login.html', error=error)

    return render_template('auth/authentication-login.html', title="ĐĂNG NHẬP")