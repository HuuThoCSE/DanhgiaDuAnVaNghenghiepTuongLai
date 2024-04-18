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
                " FROM account"
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
                session['idPersonal'] = result[3]
                session['idPerm'] = result[4]
                if session.get('idPerm') == 3: # Teacher
                    return redirect(url_for('appTeacher.ListClassTeacher'))
                elif session.get('idPerm') == 4: # Student
                    return redirect(url_for('appStudent.DashboardStudent'))
                else:
                    return "Quyền không tồn tại!!!"
            else:
                # Mật khẩu không đúng
                # error = 'Invalid credentials'
                error = 'Mật khẩu không đúng ' + str(password) + ' - ' + str(fetched_hash)
                return render_template('auth/login.html', error=error)
        else:
            # Tên người dùng không tồn tại
            # error = 'Invalid credentials'
            error = 'Tên người dùng không tồn tại'
            return render_template('auth/login.html', error=error)

    return render_template('auth/login.html')

@appAuth.route('/logout')
def logout():
    session.pop('loggedin', None)
    session.pop('username', None)
    session.pop('idPerm', None)
    return redirect(url_for('appAuth.Login'))