from flask import Blueprint, request, render_template, session, url_for, redirect
import mysql.connector

# Tạo Blueprint cho module
appStudent = Blueprint('appStudent', __name__, static_folder='../statics')

# Định nghĩa route trong module
@appStudent.route('/dashboard')
def DashboardStudent():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if session.get('idPerm') != 4:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."
    
    return render_template('student/dashboard.html')