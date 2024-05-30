DROP DATABASE IF EXISTS DanhGia;

CREATE DATABASE DanhGia;

USE DanhGia;

CREATE TABLE Semesters (
    semester_id INT AUTO_INCREMENT,
    semester_code VARCHAR(3),
    nameSemester TEXT,
    yearSemester VARCHAR(9),
    CONSTRAINT PK_Semesters PRIMARY KEY (semester_id),
    CONSTRAINT U_Semester UNIQUE (semester_code)
) ENGINE=InnoDB;

CREATE TABLE Industries (
    industry_id INT AUTO_INCREMENT,
    industry_code varchar(8),
    industry_name_VNI varchar(255),
    industry_name_ENG varchar(255),
    CONSTRAINT PK_Industries PRIMARY KEY (industry_id, industry_code),
    CONSTRAINT U_Industries UNIQUE (industry_code)
) ENGINE=InnoDB;

CREATE TABLE Majors (
    major_id INT AUTO_INCREMENT,
    major_code VARCHAR(8),
    major_name_VNI VARCHAR(255),
    major_name_ENG VARCHAR(255),
    CONSTRAINT PK_Majors PRIMARY KEY (major_id),
    CONSTRAINT U_Majors UNIQUE (major_code)
) ENGINE=InnoDB;

CREATE TABLE specializations (
    specialization_id int AUTO_INCREMENT primary key,
    specialization_code varchar(8),
    specialization_name_VNI varchar(255),
    specialization_name_ENG varchar(255)
) ENGINE=InnoDB;

CREATE TABLE Permission (
    perm_id INT AUTO_INCREMENT primary key,
    namePerm text
) ENGINE=InnoDB;

CREATE TABLE Accounts (
    account_id int AUTO_INCREMENT primary key,
    username varchar(12),
    password varchar(12),
    perm_id int,
    FOREIGN KEY (perm_id) REFERENCES Permission (perm_id)
) ENGINE=InnoDB;

CREATE TABLE Courses (
    course_id int AUTO_INCREMENT,
    course_code VARCHAR(6),
    course_name TEXT,
    course_name_ENG text NULL,
    NumberLecture int,
    NumberPractice int,
    sumcredit int,
    CONSTRAINT PK_Courses PRIMARY KEY (course_id, course_code),
    CONSTRAINT U_Courses UNIQUE (course_code)
) ENGINE=InnoDB;

DELIMITER //
CREATE TRIGGER calculate_sumcredit BEFORE UPDATE ON Courses
FOR EACH ROW
BEGIN
  IF NEW.NumberLecture <> OLD.NumberLecture OR NEW.NumberPractice <> OLD.NumberPractice THEN 
    SET NEW.sumcredit = NEW.NumberLecture + NEW.NumberPractice;
  END IF;
END //
DELIMITER ;

CREATE TABLE Teachers (
    teacher_id int AUTO_INCREMENT,
    teacher_code varchar(8),
    firstnameTeacher varchar(50),
    lastnameTeacher varchar(100),
    sex int(1) null,
    birthday date null,
    account_id INT NULL,
    CONSTRAINT PK_Teachers PRIMARY KEY (teacher_id, teacher_code),
    CONSTRAINT U_Teacher UNIQUE (teacher_code),
    CONSTRAINT PK_Teachers_Accounts 
        FOREIGN KEY (account_id) REFERENCES Accounts (account_id)
) ENGINE=InnoDB;

CREATE TABLE Staffs (
    staff_id int AUTO_INCREMENT,
    staff_code varchar(8),
    lastnameStaff varchar(10),
    firstnameStaff varchar(10),
    account_id int(8),
    CONSTRAINT PK_Staffs PRIMARY KEY (staff_id, staff_code),
    CONSTRAINT U_Staffs UNIQUE (staff_code),
    CONSTRAINT PK_Staffs_Accounts 
        FOREIGN KEY (account_id) REFERENCES Accounts (account_id)
) ENGINE=InnoDB;

CREATE TABLE Students (
    student_id INT AUTO_INCREMENT,
    student_code VARCHAR(8),
    student_lastname VARCHAR(100),
    student_firstname VARCHAR(100),
    account_id INT,
    industry_id INT,
    CONSTRAINT PK_Students PRIMARY KEY (student_id, student_code),
    CONSTRAINT U_Students UNIQUE (student_code),
    CONSTRAINT PK_Students_Accounts 
        FOREIGN KEY (account_id) REFERENCES Accounts (account_id),
    CONSTRAINT PK_Students_Industries
        FOREIGN KEY (industry_id) REFERENCES Industries (industry_id)
) ENGINE=InnoDB;

CREATE TABLE ClassCourse (
    classcourse_id INT AUTO_INCREMENT,
    classcourse_code varchar(50),
    dateStart DATE,
    dateEnd DATE,
    course_code VARCHAR(6),
    semester_code VARCHAR(3),
    teacher_id INT,
    CONSTRAINT PK_ClassCourse PRIMARY KEY (classcourse_id),
    CONSTRAINT U_ClassCourse UNIQUE (classcourse_code),
    CONSTRAINT PK_ClassCourse_Courses
        FOREIGN KEY (course_code) REFERENCES Courses (course_code),
    CONSTRAINT PK_ClassCourse_Semesters
        FOREIGN KEY (semester_code) REFERENCES Semesters (semester_code),
    CONSTRAINT PK_ClassCourse_Teachers
        FOREIGN KEY (teacher_id) REFERENCES Teachers (teacher_id)
) ENGINE=InnoDB;
    
CREATE TABLE ProjectProposal (
    proposal_id INT AUTO_INCREMENT PRIMARY KEY,
    proposal_title VARCHAR(500),
    proposal_description TEXT NULL,
    classcourse_code varchar(50),
    student_code VARCHAR(8),
    teacher_code VARCHAR(3),
    course_code VARCHAR(6),
    semester_code VARCHAR(3),
    staffApproved_status VARCHAR(8) DEFAULT '0',
    teacherApproved_status VARCHAR(8) DEFAULT '0',
    datetimeProposal TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    teacherApproved_datetime DATETIME NULL,
    staffApproved_datetime DATETIME NULL,
    staffApproved VARCHAR(8) NULL,
    TeacherApproved VARCHAR(8) NULL,
    FOREIGN KEY (classcourse_code) REFERENCES ClassCourse (classcourse_code),
    FOREIGN KEY (student_code) REFERENCES Students (student_code),
    FOREIGN KEY (teacher_code) REFERENCES Teachers (teacher_code),
    FOREIGN KEY (TeacherApproved) REFERENCES Teachers (teacher_code),
    FOREIGN KEY (staffApproved) REFERENCES Staffs (staff_code),
    FOREIGN KEY (course_code) REFERENCES Courses (course_code),
    FOREIGN KEY (semester_code) REFERENCES Semesters (semester_code)
) ENGINE=InnoDB;

CREATE TABLE Projects (
    project_id INT AUTO_INCREMENT primary key,
    nameProject varchar(500),
    description TEXT,
    project_status TINYINT DEFAULT 0,
    dateStart date NULL,
    dateEnd date NULL,
    classcourse_code varchar(50),
    teacher_code VARCHAR(8),
    student_code VARCHAR(8),
    typeProject char(3), -- Team or individual
    FOREIGN KEY (classcourse_code) REFERENCES ClassCourse (classcourse_code),
    FOREIGN KEY (teacher_code) REFERENCES Teachers (teacher_code)
    -- FOREIGN KEY (student_code) REFERENCES Students (student_code)
) ENGINE=InnoDB;

CREATE TABLE TemplProject (
    idTemlProject INT AUTO_INCREMENT,
    nameTemlProject nvarchar(500),
    CodeCourse varchar(6) NULL,
    CONSTRAINT PK_TemplProject PRIMARY KEY (idTemlProject)
) ENGINE=InnoDB;

CREATE TABLE TeamProjects (
    termproject_id INT AUTO_INCREMENT primary key,
    project_id INT,
    student_id INT,
    FOREIGN KEY (project_id) REFERENCES Projects (project_id),
    FOREIGN KEY (student_id) REFERENCES Students (student_id)
) ENGINE=InnoDB;

-- Bảng lưu trữ thông tin về các nghề nghiệp
CREATE TABLE Careers (
    idCareer INT AUTO_INCREMENT PRIMARY KEY,
    nameCareer TEXT
) ENGINE=InnoDB;

-- Bảng lưu trữ ước mơ nghề nghiệp hiện tại của sinh viên
CREATE TABLE StudentDream (
    idAccount INT(8) PRIMARY KEY,
    idCareer INT,
    FOREIGN KEY (idCareer) REFERENCES Careers(idCareer)
) ENGINE=InnoDB;

-- Bảng lưu trữ lịch sử thay đổi ước mơ nghề nghiệp của sinh viên
CREATE TABLE hisStudentDream (
    idhisStudentDream INT AUTO_INCREMENT PRIMARY KEY,
    idAccount INT(8),
    idCareer INT,
    timestamphisStudentDream TIMESTAMP,
    FOREIGN KEY (idAccount) REFERENCES StudentDream(idAccount),
    FOREIGN KEY (idCareer) REFERENCES Careers(idCareer)
) ENGINE=InnoDB;

-- ALTER TABLE TemplProject
--   ADD CONSTRAINT FK_TemplProject_Courses FOREIGN KEY (CodeCourse)
--     REFERENCES Courses(CodeCourse);

CREATE TABLE ErollClassCourse (
    student_code VARCHAR(8),
    classcourse_code varchar(50),
    semester_code varchar(3),
    PRIMARY KEY (student_code, classcourse_code),
    FOREIGN KEY (student_code) REFERENCES Students (student_code),
    FOREIGN KEY (classcourse_code) REFERENCES ClassCourse (classcourse_code)
) ENGINE=InnoDB;


CREATE TABLE ProjectProgress (
    ProjectProgress_id INT AUTO_INCREMENT,
    project_id INT,
    student_code VARCHAR(8),
    milestone_name VARCHAR(255),
    milestone_description TEXT,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_ProjectProgress PRIMARY KEY (ProjectProgress_id),
    FOREIGN KEY (project_id) REFERENCES Projects (project_id),
    FOREIGN KEY (student_code) REFERENCES Students (student_code)
) ENGINE=InnoDB;

INSERT INTO Semesters (semester_code, nameSemester, yearSemester) VALUES 
    ('222', 'Học kỳ 2', '2022-2023'),
    ('231', 'Học kỳ 1', '2023-2024'),
    ('232', 'Học kỳ 2', '2023-2024'),
    ('233', 'Học kỳ phụ', '2023-2024'),
    ('234', 'Học kỳ hè', '2023-2024');

INSERT INTO Industries (industry_code, industry_name_VNI) VALUES 
    ('CTT', 'Công nghệ thông tin'), -- Infomation Technology
    ('OTO', 'Ô tô'); -- automobile

INSERT INTO Permission (namePerm) 
    VALUES
        ('Admin'),
        ('Staff'),
        ('Teacher'),
        ('Student');

INSERT INTO Accounts (username, password, perm_id) 
    VALUES 
        ('admin', '123456', 1),         -- 1
        ('pdt1', '123456', 2),          -- 2
        ('21022008', '123456', 4),      -- 3
        ('teacher1', '123456', 3),      -- 4
        ('teacher2', '123456', 3),      -- 5
        ('teacher3', '123456', 3),      -- 6
        ('teacher4', '123456', 3),      -- 7
        ('teacher5', '123456', 3),      -- 8
        ('teacher6', '123456', 3),      -- 9
        ('teacher7', '123456', 3),      -- 10
        ('21022002', '123456', 4),      -- 11
        ('21022010', '123456', 4),      -- 12
        ('21022007', '123456', 4),      -- 13
        ('21022009', '123456', 4);      -- 14

INSERT INTO Staffs (staff_code, firstnameStaff, lastnameStaff, account_id)
    VALUES
        ('ST1', 'Van A', 'Nguyen', 2);

INSERT INTO Students (student_code, student_firstname, student_lastname, industry_id, account_id)
    VALUES
        ('21022002', 'Thư', 'Âu Thị Anh', 1,  11),
        ('21022008', 'Thọ', 'Nguyễn Hữu', 1,  3),
        ('21022010', 'Bình', 'Lê Nguyễn Quang', 1, 12),
        ('21022007', 'Huyên', 'Nguyễn Văn', 1, 13),
        ('21022006', 'Phú', 'Tăng Huỳnh Thanh', 1, 14);

INSERT INTO Teachers (teacher_code, lastnameTeacher, firstnameTeacher, sex, account_id) 
    VALUES 
        ('GV1', 'Lê Hoàng', 'An', 1, 4),       -- 1
        ('GV2', 'Trần Thái', 'Bảo', 1, 5),     -- 2
        ('GV3', 'Trần Hồ', 'Đạt', 1, 6),       -- 3
        ('GV4', 'Nguyễn Ngọc', 'Nga', 0, 7),   -- 4
        ('GV5', 'Trần Minh', 'Sang', 1, 8),    -- 5
        ('GV6', 'Phan Anh', 'Cang', 1, 9),     -- 6
        ('GV7', 'Mai Thiên', 'Thư', 0, 10);    -- 7

INSERT INTO Courses (course_code, course_name, course_name_ENG, NumberLecture, NumberPractice)
    VALUES
        ('TH1510', 'Đồ án cơ sở ngành Khoa học máy tính', '',0, 2),
        ('SP1418', 'Chuẩn bị dạy học', '',3, 0),
        ('TH1507', 'Đồ án CNTT 1', '',0, 1),
        ('TH1512', 'Đồ án CNTT 2', '',0, 1),
        ('TH1391', 'Nguyên lý máy học', 'Machine Learning', 2, 2),
        ('TH1382', 'Học sâu', 'Deep Learning', 2, 2);

INSERT INTO ClassCourse (classcourse_code, dateStart, dateEnd, course_code, semester_code, teacher_id)
    VALUES
        ('232_1TH1510_KS3A_01_ngoaigio', '2024-03-11', '2024-06-30', 'TH1510', '232', 1),
        ('233_1SP1418_KS1A_tructiep', '2023-03-11', '2023-06-30', 'SP1418', '233', 5),
        ('231_1TH1507_KS3A_04_ngoaigio', '2023-03-11', '2023-06-30', 'TH1507', '231', 7),
        ('222_1TH1391_KS2A_tructiep', '2023-03-11', '2023-06-30', 'TH1391', '222', 6),
        ('232_1TH1382_KS2A_tructiep', '2024-03-11', '2024-06-30', 'TH1382', '232', 6);

INSERT INTO Projects (nameProject, description, teacher_code, classcourse_code, student_code, typeProject)
    VALUES
        ('Phát hiện và khoanh vùng khối u não', '', 'GV1', '232_1TH1510_KS3A_01_ngoaigio', '21022002', 'ind'),
        ('Hệ thống quản lý đồ án và phân loại chủ đề đồ án công nghệ thông tin', 'Website quản lý đồ án sinh viên thông qua các giao diện', 'GV1', '232_1TH1510_KS3A_01_ngoaigio', '21022008', 'ind'),
        ('Nhận diện khuôn mặt', '', 'GV5', '233_1SP1418_KS1A_tructiep', '21022008', 'ind'),
        ('Thiết kế và thực hiện mạch cân bằng Arduino cho quadcopter', '', 'GV1', '232_1TH1510_KS3A_01_ngoaigio', '21022007', 'ind'),
        ('Phát hiện khối u não', '', 'GV6', '231_1TH1507_KS3A_04_ngoaigio', '21022008', 'tea'),
        ('Phát hiện vật thể bằng YOLOv8 trên website', '', 'GV1', '232_1TH1510_KS3A_01_ngoaigio', '21022006', 'ind');

INSERT INTO ErollClassCourse (student_code, classcourse_code, semester_code)
    VALUES
        ('21022008', '232_1TH1510_KS3A_01_ngoaigio', '232'),
        ('21022008', '232_1TH1382_KS2A_tructiep', '232'),
        ('21022002', '232_1TH1510_KS3A_01_ngoaigio', '232');

INSERT INTO TeamProjects (project_id, student_id)
    VALUES
        (4, 2),
        (4, 3);

INSERT INTO ProjectProposal (proposal_title, teacher_code, course_code, semester_code, teacherApproved_status)
    VALUES
        ("Thiết lập Captive Portal trên OPNPfsense", "GV2", "TH1510", '232', 1),
        ("Áp dụng Ansible để tự động hoá cấu hình thiết bị mạng", "GV2", "TH1510", '232', 1),
        ("Phát hiện tấn công mạng bằng máy học", "GV2", "TH1510", '232', 1),
        ("Các mô hình học sâu (Deep Learning) sử dụng cho phát hiện xâm nhập mạng", "GV2", "TH1510", '232', 1),
        ("Phát hiện mã độc dựa vào học máy và thông tin PE Header", "GV2", "TH1510", '232', 1),
        ("PHÁT HIỆN TẤN CÔNG SQL INJECTION BẰNG HỌC MÁY", "GV2", "TH1510", '232', 1),
        ("Web Application Firewalls (NGINX ModSecurity)", "GV2", "TH1510", '232', 1),
        ("Web Application Firewalls (open-appsec)", "GV2", "TH1510", '232', 1),
        ("Web Application Firewalls (Naxsi)", "GV2", "TH1510", '232', 1),
        ("Web Application Firewalls (Shadow Daemon)", "GV2", "TH1510", '232', 1),
        ("Web Application Firewalls (IronBee)", "GV2", "TH1510", '232', 1),
        ("Web Application Firewalls (Lua-resty-WAF)", "GV2", "TH1510", '232', 1);
 
INSERT INTO TemplProject (nameTemlProject, CodeCourse)
    VALUES
        ('Viết web bằng joomla', 'TH1502'),
        ('Viết web bằng wordpress', 'TH1502'),
        ('Chatbot tư vấn tuyển sinh', 'TH1502'),
        ('Xây dựng website tin tức đoàn khoa', 'TH1502'),
        ('Xây dựng website đăng ký tham gia phong trào', 'TH1502'),
        ('Xây dựng website quản lý đoàn phí', 'TH1502'),
        ('Xây dựng website quản lý sổ đoàn', 'TH1502'),
        ('Xây dựng website hỗ trợ học anh văn chuyên ngành', 'TH1502'),
        ('Xây dựng website quản lý tiệm net', 'TH1502'),
        ('Xây dựng website quản lý karaoke', 'TH1502'),
        ('Xây dựng website quản lý quán cà phê', 'TH1502'),
        ('Xây dựng website thi trắc nghiệm', 'TH1502'),
        ('Xây dựng website bán hàng trực tuyến', 'TH1502'),
        ('Thiết kế logo đoàn khoa dựa vào kỹ thuật xử lý hình ảnh', 'TH1502'),
        ('Xây dựng hệ thống nhận diện ảnh', 'TH1502'),
        ('Xây dựng hệ thống quản lý điểm công tác xã hội', 'TH1502'),
        ('Xây dựng hệ thống xếp thời khóa biểu cho giảng viên', 'TH1502'),
        ('Robot điều khiển bằng giọng nói', 'TH1502'),
        ('Robot điều khiển bằng smartphone', 'TH1502'),
        ('Lập trình game mini', 'TH1502'),
        ('Hệ thống bật tắt đèn bằng app', 'TH1502'),
        ('Hệ thống điều khiển thiết bị từ xa', 'TH1502'),
        ('Hệ thống điểm danh bằng gương mặt', 'TH1502'),
        ('Hệ thống điểm danh bằng thẻ', 'TH1502'),
        ('Hệ thống điểm danh bằng mã QR', 'TH1502'),
        ('Xây dựng ứng dụng trích xuất thông tin căn cước công dân', 'TH1512'),
        ('Nhận diện sự kiện trong video bóng đá', 'TH1512'),
        ('Xây dựng hệ thống nhận diện ngôn ngữ ký hiệu hỗ trợ người khiếm khuyết', 'TH1512'),
        ('Xây dựng website 360 độ và ứng dụng trợ lý ảo trong tham quan csvc của khoa CNTT', 'TH1512'),
        ('Triển khai hệ thống phân tích dự đoán, hỗ trợ nhà tuyển dụng ứng dụng công nghệ AI', 'TH1512'),
        ('Ứng dụng IoT trong phát triển ứng dụng theo dõi mô hình hồ cá thông minh và dự đoán bệnh ở cá', 'TH1512'),
        ('Xây dựng website đề tài, khoá luận - ĐH SPKT Vĩnh Long', 'TH1512'),
        ('Xây dựng website hỗ trợ học tập cho sinh viên trường ĐH SPKT Vĩnh Long', 'TH1512'),
        ('Phát triển hệ thống quản lý vườn thanh long thông minh ứng dụng công nghệ iot và chuẩn đoán bệnh ở cây thanh long', 'TH1512');

