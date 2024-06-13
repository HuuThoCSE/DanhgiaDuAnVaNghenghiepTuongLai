# pip3 freeze > requirements.txt

import os
os.environ['TF_ENABLE_ONEDNN_OPTS'] = '0'
import keras

from flask import Flask, render_template, session, request, jsonify, Response, redirect, url_for
import secrets
import mysql.connector
from flask_login import LoginManager, current_user

import os
from tensorflow.keras.preprocessing.sequence import pad_sequences
from tensorflow.keras.models import load_model
import joblib

from modules.appCourse import appClassCourse
from modules.appProject import appProject
from modules.appAuth import appAuth
from modules.appStaff import appStaff
from modules.appStudent import appStudent
from modules.appTeacher import appTeacher
from modules.appCertificate import appCertificate

app = Flask(__name__, static_folder='statics')
app.secret_key = secrets.token_urlsafe(16)
# login_manager = LoginManager(app)

# Đăng ký Blueprints vào app
app.register_blueprint(appClassCourse, url_prefix='/course')
app.register_blueprint(appProject, url_prefix='/project')
app.register_blueprint(appAuth, url_prefix='/auth')
app.register_blueprint(appStaff, url_prefix='/staff')
app.register_blueprint(appStudent, url_prefix='/student')
app.register_blueprint(appTeacher, url_prefix='/teacher')
app.register_blueprint(appCertificate, url_prefix='/certificate')

# IP = "192.168.31.254"
IP = 'localhost'

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="",
    database="danhgia"
)

# Lấy đường dẫn của thư mục gốc của ứng dụng
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# Đường dẫn đến thư mục tài nguyên chứa tokenizer và mô hình
RESOURCES_DIR = os.path.join(BASE_DIR, 'resources')

# Đọc các cấu hình từ file
with open(RESOURCES_DIR+'/config.txt', 'r') as file:
    config = {line.split(':')[0]: int(line.split(':')[1]) for line in file}
max_length = config.get('MaxLength')

tokenizer_path = os.path.join(RESOURCES_DIR, 'tokenizer.joblib')
categories_path = os.path.join(RESOURCES_DIR, 'categories.joblib')
model_path = os.path.join(RESOURCES_DIR, 'best_model.keras')

# Tải tokenizer và mô hình
tokenizer = joblib.load(tokenizer_path)
categories = joblib.load(categories_path)
model = load_model(model_path)

@app.route("/")
def index():
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    
    if session.get('idPerm') == 2: # Staff
        return redirect(url_for('appStaff.DashboardStaff'))

    elif session.get('idPerm') == 3: # Teacher
        return redirect(url_for('appTeacher.DashboardTeacher'))

    elif session.get('idPerm') == 4: # Student
        return redirect(url_for('appStudent.DashboardStudent'))

    mycursor = mydb.cursor()
    mycursor.execute("SELECT a.idClassCourse, CONCAT(a.codeClassCourse,' ',b.codeCourse,'- ',b.nameCourse) as fullnameClassCourse"
                     " FROM Classcourse a"
                     " LEFT JOIN Courses b ON a.idCourse = b.idCourse")
    data = mycursor.fetchall()
    return render_template("classcourse.html", response=data)

@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('appAuth.Login'))

# @app.errorhandler(404)
# def page_not_found(error):
#   return render_template('Student/404.html'), 404

@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json(force=True)
    project_name = data['project_name']
    sequence = tokenizer.texts_to_sequences([project_name])
    padded_sequence = pad_sequences(sequence, maxlen=max_length)
    prediction = model.predict(padded_sequence)
    predicted_categories = (prediction > 0.1).astype(int)
    predicted_labels = [categories[idx] for idx, is_present in enumerate(predicted_categories[0]) if is_present]
    return jsonify({'project_name': project_name, 'categories': ', '.join(predicted_labels) if predicted_labels else 'Không xác định'})

if __name__ == "__main__":
    app.run(host=IP, port=5000, debug=True)