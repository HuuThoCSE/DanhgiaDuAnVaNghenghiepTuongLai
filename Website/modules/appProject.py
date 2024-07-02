from flask import Blueprint, request, render_template, session, url_for, redirect, send_from_directory
from werkzeug.utils import secure_filename
import mysql.connector
from datetime import datetime
import os
import uuid

# Tạo Blueprint cho module
appProject = Blueprint('appProject', __name__, static_folder='../statics')

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="",
    database="danhgia"
)

# Lấy đường dẫn tuyệt đối của file hiện tại
current_file_path = os.path.abspath(__file__)

# Lấy thư mục chứa file hiện tại
current_folder_path = os.path.dirname(current_file_path)

# Lấy thư mục gốc của ứng dụng (thư mục chứa thư mục modules)
root_folder_path = os.path.dirname(current_folder_path)

# Đường dẫn tới thư mục con "attachments" nằm trong thư mục gốc
uploads_folder_path = os.path.join(root_folder_path, 'attachments')

# Tạo thư mục nếu chưa tồn tại
os.makedirs(uploads_folder_path, exist_ok=True)

print("Current file path:", current_file_path)
print("Current folder path:", current_folder_path)
print("Root folder path:", root_folder_path)
print("Uploads folder path:", uploads_folder_path)

@appProject.route('/attachments/<filename>')
def download_file(filename):
    return send_from_directory(uploads_folder_path, filename)

# Định nghĩa route trong module
@appProject.route('/<int:project_id>', methods=['GET', 'POST'])
def infoProject(project_id):
    if 'loggedin' not in session:
        return redirect(url_for('appAuth.Login'))
    if 'idPerm' not in session:
        return "Bạn không có quyền vào trang này. Nếu lỗi liên hệ admin."

    if request.method == 'POST' and request.form.get('Ins_Report') is not None:
        teacher_create = session.get('idTeacher')
        ppr_title = request.form.get('ppr_title')
        start_datetime = request.form.get('start_datetime')
        end_datetime = request.form.get('end_datetime')

        mycursor = mydb.cursor()
        query = """
                INSERT INTO projectprogressreports (project_id, teacher_create, ppr_title, start_date, end_date)
                VALUES (%s, %s, %s, %s, %s)
                """
        values = (project_id, teacher_create, ppr_title, start_datetime, end_datetime)
        mycursor.execute(query, values)
        mydb.commit()
        return redirect(url_for('appProject.infoProject', project_id=project_id))

    if request.method == 'POST' and request.form.get('Ins_Comment') is not None:
        print("OK1")
        ppr_id = request.form.get('ppr_id')
        ppr_comment = request.form.get('ppr_comment')

        mycursor = mydb.cursor()
        query = """
                UPDATE projectprogressreports
                SET ppr_comment = %s
                WHERE ppr_id = %s 
                """
        values = (ppr_comment, int(ppr_id))
        mycursor.execute(query, values)
        mydb.commit()
        mycursor.close()

    # Xử lý báo cáo
    if request.form.get('Upd_Ketthuc') is not None:
        project_id = request.form.get('project_id')
        point = request.form.get('point')
        project_comment_end = request.form.get('project_comment_end')

        mycursor = mydb.cursor()
        query = """
                UPDATE projects
                SET project_comment_end = %s,
                    point = %s,
                    project_status = 1
                WHERE project_id = %s 
                """
        values = (project_comment_end, point, int(project_id))
        mycursor.execute(query, values)
        mydb.commit()


    # Xử lý báo cáo
    if request.form.get('Ins_Content') is not None:
        print("OK2")
        ppr_id = request.form.get('ppr_id')
        ppr_content = request.form.get('ppr_content')

        mycursor = mydb.cursor()
        query = """
                        UPDATE projectprogressreports
                        SET ppr_content = %s
                        WHERE ppr_id = %s 
                        """
        values = (ppr_content, int(ppr_id))
        mycursor.execute(query, values)
        mydb.commit()

        # Lưu file đính kèm mới
        files = request.files.getlist('attachments')
        for file in files:
            if file.filename:
                # Chuẩn hóa tên file
                filename = secure_filename(file.filename)
                unique_filename = f"{uuid.uuid4().hex}_{filename}"
                filepath = os.path.join(uploads_folder_path, unique_filename)
                file.save(filepath)

                # Lưu thông tin file vào cơ sở dữ liệu
                query = """
                                            INSERT INTO attachments (ppr_id, file_path, file_name, file_name_short)
                                            VALUES (%s, %s, %s, %s)
                                            """
                values = (ppr_id, filepath, unique_filename, filename)
                mycursor.execute(query, values)
                mydb.commit()
        mycursor.close()

    # Xử lý xóa file
    if request.form.get('delete_file') is not None:
        print("OK2")
        file_id = request.form.get('delete_file')
        print(file_id)
        mycursor = mydb.cursor()
        query = "SELECT file_path FROM attachments WHERE file_id = %s"
        mycursor.execute(query, (file_id,))
        file_path = mycursor.fetchone()[0]
        if os.path.exists(file_path):
            os.remove(file_path)
            print(f"File {file_path} has been deleted.")
        else:
            print(f"File {file_path} does not exist.")

        query = "DELETE FROM attachments WHERE file_id = %s"
        mycursor.execute(query, (file_id,))
        mydb.commit()

        mycursor.close()

    mycursor = mydb.cursor()
    query = """
                INSERT INTO hist_viewproject (histviewproject_idproject, histviewproject_idAccount) 
                VALUES (%(histviewproject_idproject)s, %(histviewproject_idAccount)s)
                """
    mycursor.execute(query,
                     {'histviewproject_idproject': project_id, 'histviewproject_idAccount': session['idAccount']})
    mydb.commit()
    mycursor.close()

    mycursor = mydb.cursor()
    query = """
                SELECT a.project_id, a.nameProject, a.classcourse_code, CONCAT(d.course_code, ' - ', d.course_name),CONCAT(c.student_code, ' - ', c.student_lastname, ' ', c.student_firstname) as infoStudent, CONCAT(e.lastnameTeacher, ' ', e.firstnameTeacher), a.project_status,
                    DATE_FORMAT(b.dateStart, '%d-%m-%Y'),
                    DATE_FORMAT(b.dateEnd, '%d-%m-%Y')
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

    query = """
            SELECT ppr_id, project_id, teacher_create, ppr_title, ppr_content, ppr_comment, start_date, end_date
            FROM projectprogressreports 
            WHERE project_id = %(project_id)s
            ORDER BY ppr_id DESC
            """

    mycursor.execute(query, {'project_id': project_id})

    project_list = mycursor.fetchall()

    # Thêm thông tin file đính kèm vào project_list
    formatted_project_list = []
    file_list = []  # Biến chứa danh sách file đính kèm
    for ppr in project_list:
        ppr_id = ppr[0]
        query = """
                    SELECT file_id, ppr_id, file_name_short, file_name, file_path
                    FROM attachments
                    WHERE ppr_id = %s
                    """
        mycursor.execute(query, (ppr_id,))
        attachments = mycursor.fetchall()
        ppr_with_attachments = ppr + (attachments,)
        formatted_project_list.append(ppr_with_attachments)
        file_list.extend(attachments)  # Thêm các file đính kèm vào danh sách file_list

    print(file_list)
    mycursor.close()

    # Chuyển đổi start_date và end_date thành đối tượng datetime nếu cần thiết và thêm cột boolean
    now = datetime.now()
    for i in range(len(formatted_project_list)):
        ppr_id, project_id, teacher_create, ppr_title, ppr_content, ppr_comment, start_date, end_date, attachments = \
        formatted_project_list[i]
        if isinstance(start_date, str):
            try:
                start_date = datetime.strptime(start_date, '%Y-%m-%d %H:%M:%S')
            except ValueError:
                start_date = None
        if isinstance(end_date, str):
            try:
                end_date = datetime.strptime(end_date, '%Y-%m-%d %H:%M:%S')
            except ValueError:
                end_date = None
        within_timeframe = start_date <= now <= end_date if start_date and end_date else False
        formatted_project_list[i] = (ppr_id, project_id, teacher_create, ppr_title, ppr_content, ppr_comment,
                                     start_date, end_date, within_timeframe, attachments)

    return render_template('Project/project_dashboard.html',
                           response=data,
                           idPerm=session.get('idPerm'),
                           project_list=formatted_project_list,
                           file_list=file_list)  # Truyền danh sách file đính kèm vào template
