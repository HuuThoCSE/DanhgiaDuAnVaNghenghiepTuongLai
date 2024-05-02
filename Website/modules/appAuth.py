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

mycursor = mydb.cursor()

# Định nghĩa route trong module
@appAuth.route('/', methods=['GET', 'POST'])
def Login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        query = ("SELECT *"
                " FROM Account"
                " WHERE username = %s")
        values = (username,)
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

                if session.get('idPerm') == 2: # Staff
                    return redirect(url_for('appStaff.DashboardStaff'))

                elif session.get('idPerm') == 3: # Teacher
                    mycursor.execute("SELECT idTeacher from Teachers where idAccount=%s", (result[0], ))
                    result1 = mycursor.fetchone()
                    session['idTeacher'] = result1[0]
                    print(result[0])
                    return redirect(url_for('appTeacher.DashboardTeacher'))

                elif session.get('idPerm') == 4: # Student
                    mycursor.execute("SELECT idStudent from Students where idAccount=%s", (result[0], ))
                    result1 = mycursor.fetchone()
                    session['idStudent'] = result1[0]
                    print(result1[0])
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

    return render_template('auth/authentication-login.html')