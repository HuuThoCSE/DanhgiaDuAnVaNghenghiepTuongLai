DROP DATABASE IF EXISTS DanhGia;

CREATE DATABASE DanhGia;

USE DanhGia;

CREATE TABLE Industries (
    IdIndustry int AUTO_INCREMENT primary key,
    nameIndustry text
);

CREATE TABLE Permission (
    IDPerm int AUTO_INCREMENT primary key,
    namePerm text
);

CREATE TABLE Account (
    IdAccount int AUTO_INCREMENT primary key,
    username varchar(12),
    password varchar(12),
    IdPerm int,
    FOREIGN KEY (IdPerm) REFERENCES Permission (IdPerm)
);

CREATE TABLE Courses (
    idCourse int AUTO_INCREMENT primary key,
    CodeCourse varchar(6),
    nameCourse text,
    NumberLecture int,
    NumberPractice int,
    sumcredit int
);

DELIMITER //
CREATE TRIGGER calculate_sumcredit AFTER UPDATE ON Courses
FOR EACH ROW
BEGIN
  IF NEW.NumberLecture <> OLD.NumberLecture OR NEW.NumberPractice <> OLD.NumberPractice THEN 
    UPDATE Courses 
    SET sumcredit = NEW.NumberLecture + NEW.NumberPractice 
    WHERE idCourse = NEW.idCourse;
  END IF;
END //
DELIMITER ;

CREATE TABLE Teachers (
    idTeacher int AUTO_INCREMENT primary key,
    firstnameTeacher varchar(50),
    lastnameTeacher varchar(100),
    sex int(1) null,
    birthday date null,
    idAccount INT NULL,
    CONSTRAINT PK_Teachers_Accounts 
        FOREIGN KEY (idAccount) REFERENCES Account (idAccount)
);

CREATE TABLE Staffs (
    idStaff int AUTO_INCREMENT primary key,
    lastnameStaff varchar(10),
    firstnameStaff varchar(10),
    idAccount int(8),
    CONSTRAINT PK_Staffs_Accounts 
        FOREIGN KEY (idAccount) REFERENCES Account (idAccount)
);

CREATE TABLE Students (
    idStudent INT AUTO_INCREMENT primary key,
    codeStudent int(8),
    lastnameStudent varchar(100),
    firstnameStudent varchar(100),
    idAccount int(8),
    IdIndustry int(8),
    CONSTRAINT PK_Students_Accounts 
        FOREIGN KEY (idAccount) REFERENCES Account (idAccount),
    CONSTRAINT PK_Students_Industries
        FOREIGN KEY (IdIndustry) REFERENCES Industries (IdIndustry)
);

CREATE TABLE ClassCourse (
    idClassCourse int AUTO_INCREMENT primary key,
    codeClassCourse varchar(50),
    idCourse int,
    idTeacher int,
    FOREIGN KEY (idCourse) REFERENCES Courses (idCourse),
    FOREIGN KEY (idTeacher) REFERENCES Teachers (idTeacher)
);

CREATE TABLE Projects (
    idProject INT AUTO_INCREMENT primary key,
    nameProject nvarchar(500),
    description TEXT,
    idClassCourse int null,
    idTeacher INT,
    idLeader int,
    typeProject char(3), -- Team or individual
    FOREIGN KEY (idClassCourse) REFERENCES ClassCourse (idClassCourse),
    FOREIGN KEY (idLeader) REFERENCES Students (idStudent)
);

CREATE TABLE TemplProject (
    idTemlProject INT AUTO_INCREMENT,
    nameTemlProject nvarchar(500),
    CodeCourse varchar(6) NULL,
    CONSTRAINT PK_TemplProject PRIMARY KEY (idTemlProject)
);

CREATE TABLE TeamProjects (
    idTermProject INT AUTO_INCREMENT primary key,
    idProject INT,
    idStudent INT,
    FOREIGN KEY (idProject) REFERENCES Projects (idProject),
    FOREIGN KEY (idStudent) REFERENCES Students (idStudent)
);

-- Bảng lưu trữ thông tin về các nghề nghiệp
CREATE TABLE Careers (
    idCareer INT AUTO_INCREMENT PRIMARY KEY,
    nameCareer TEXT
);

-- Bảng lưu trữ ước mơ nghề nghiệp hiện tại của sinh viên
CREATE TABLE StudentDream (
    idAccount INT(8) PRIMARY KEY,
    idCareer INT,
    FOREIGN KEY (idCareer) REFERENCES Careers(idCareer)
);

-- Bảng lưu trữ lịch sử thay đổi ước mơ nghề nghiệp của sinh viên
CREATE TABLE hisStudentDream (
    idhisStudentDream INT AUTO_INCREMENT PRIMARY KEY,
    idAccount INT(8),
    idCareer INT,
    timestamphisStudentDream TIMESTAMP,
    FOREIGN KEY (idAccount) REFERENCES StudentDream(idAccount),
    FOREIGN KEY (idCareer) REFERENCES Careers(idCareer)
);

-- ALTER TABLE TemplProject
--   ADD CONSTRAINT FK_TemplProject_Courses FOREIGN KEY (CodeCourse)
--     REFERENCES Courses(CodeCourse);

INSERT INTO Industries (nameIndustry) VALUES 
    ('Công nghệ thông tin'),
    ('Ô tô');

INSERT INTO Permission (namePerm) 
    VALUES
        ('Admin'),
        ('Staff'),
        ('Teacher'),
        ('Student');

INSERT INTO Account (username, password, IdPerm) 
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
        ('21022007', '123456', 4);      -- 13

INSERT INTO Staffs (firstnameStaff, lastnameStaff, idAccount)
    VALUES
        ('Van A', 'Nguyen', 2);

INSERT INTO Students (codeStudent, firstnameStudent, lastnameStudent, IdIndustry, idAccount)
    VALUES
        ('21022002', 'Thư', 'Âu Thị Anh', 1,  11),
        ('21022008', 'Thọ', 'Nguyễn Hữu', 1,  3),
        ('21022010', 'Bình', 'Lê Nguyễn Quang', 1, 12),
        ('21022007', 'Huyên', 'Nguyễn Văn', 1, 13);

INSERT INTO Teachers (lastnameTeacher, firstnameTeacher, sex, idAccount) 
    VALUES 
        ('Lê Hoàng', 'An', 1, 4),
        ('Trần Thái', 'Bảo', 1, 5),
        ('Trần Hồ', 'Đạt', 1, 6),
        ('Nguyễn Ngọc', 'Nga', 0, 7),
        ('Trần Minh', 'Sang', 1, 8),
        ('Phan Anh', 'Cang', 1, 9),
        ('Mai Thiên', 'Thư', 0, 10);

INSERT INTO Courses (CodeCourse, nameCourse, NumberLecture, NumberPractice)
    VALUES
        ('TH1510', 'Đồ án cơ sở ngành Khoa học máy tính', 0, 2),
        ('SP1418', 'Chuẩn bị dạy học', 3, 0),
        ('TH1507', 'Đồ án CNTT 1', 0, 1),
        ('TH1512', 'Đồ án CNTT 2', 0, 1),
        ('TH1391', 'Nguyên lý máy học', 2, 2);

INSERT INTO ClassCourse (codeClassCourse, idCourse, idTeacher)
    VALUES
        ('232_1TH1510_KS3A_01_ngoaigio', 1, 1),
        ('233_1SP1418_KS1A_tructiep', 2, 5),
        ('231_1TH1507_KS3A_04_ngoaigio', 3, 7),
        ('222_1TH1391_KS2A_tructiep', 4, 6);

INSERT INTO Projects (nameProject, description, idTeacher,idClassCourse, idLeader, typeProject)
    VALUES
        ('Phát hiện và khoanh vùng khối u não ', '', 1, 1, 1, 'ind'),
        ('Hệ thống quản lý đồ án và đánh giá kỹ nănng CNTT sinh viên', 'Website quản lý đồ án sinh viên thông qua các giao diện', 1, 1, 2, 'ind'),
        ('Nhận diện khuôn mặt', '', 5, 2, 2, 'ind'),
        ('Thiết kế và thực hiện mạch cân bằng Arduino cho quadcopter', '', 1, 1, 4, 'ind'),
        ('Phát hiện khối u não', '', 6, 3, 2, 'tea');

INSERT INTO TeamProjects (idProject, idStudent)
    VALUES
        (4, 2),
        (4, 3);
 
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