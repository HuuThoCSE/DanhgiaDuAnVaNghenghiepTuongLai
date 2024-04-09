from flask import Blueprint, request, render_template, session, url_for, redirect
import mysql.connector

# Tạo Blueprint cho module
appTeacher = Blueprint('appTeacher', __name__, static_folder='../statics')

# Định nghĩa route trong module
@appTeacher.route('/dashboard')
def DashboardTeacher():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if session.get('idPerm') != 3:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."
    
    return render_template('teacher/dashboard.html')