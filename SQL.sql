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
    lastnameTeacher varchar(100),
    firstnameTeacher varchar(50),
    sex int(1) null,
    birthday date null
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
    idClassCourse int,
    idLeader int,
    typeProject char(3), -- Team or individual
    FOREIGN KEY (idClassCourse) REFERENCES ClassCourse (idClassCourse),
    FOREIGN KEY (idLeader) REFERENCES Students (idStudent)
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
        ('admin', '123456', 1),
        ('pdt1', '123456', 2),
        ('21022008', '123456', 4),
        ('teacher1', '123456', 3),
        ('21022002', '123456', 4),
        ('21022010', '123456', 4);

INSERT INTO Staffs (firstnameStaff, lastnameStaff, idAccount)
    VALUES
        ('Van A', 'Nguyen', 2);

INSERT INTO Students (codeStudent, firstnameStudent, lastnameStudent, IdIndustry, idAccount)
    VALUES
        ('21022002', 'Thư', 'Âu Thị Anh', 1,  5),
        ('21022008', 'Thọ', 'Nguyễn Hữu', 1,  3),
        ('21022010', 'Bình', 'Lê Nguyễn Quang', 1, 6);

INSERT INTO Teachers (lastnameTeacher, firstnameTeacher, sex) 
    VALUES 
        ('Lê Hoàng', 'An', 1),
        ('Trần Thái', 'Bảo', 1),
        ('Trần Hồ', 'Đạt', 1),
        ('Nguyễn Ngọc', 'Nga', 0),
        ('Trần Minh', 'Sang', 1),
        ('Phan Anh', 'Cang', 1);

INSERT INTO Courses (CodeCourse, nameCourse, NumberLecture, NumberPractice)
    VALUES
        ('TH1510', 'Đồ án cơ sở ngành Khoa học máy tính', 0, 2),
        ('SP1418', 'Chuẩn bị dạy học', 3, 0),
        ('TH1391', 'Nguyên lý máy học', 2, 2);

INSERT INTO ClassCourse (codeClassCourse, idCourse, idTeacher)
    VALUES
        ('232_1TH1510_KS3A_01_ngoaigio', 1, 1),
        ('233_1SP1418_KS1A_tructiep', 2, 5),
        ('222_1TH1391_KS2A_tructiep', 3, 6);

INSERT INTO Projects (nameProject, description, idClassCourse, idLeader, typeProject)
    VALUES
        ('Phát hiện và khoanh vùng khối u não ', '',1, 1, 'ind'),
        ('Hệ thống quản lý đồ án và đánh giá kỹ nănng CNTT sinh viên', 'Website quản lý đồ án sinh viên thông qua các giao diện',1, 2, 'ind'),
        ('Nhận diện khuôn mặt', '',2, 2, 'ind'),
        ('Phát hiện khối u não', '',3, 2, 'tea');

INSERT INTO TeamProjects (idProject, idStudent)
    VALUES
        (4, 2),
        (4, 3);