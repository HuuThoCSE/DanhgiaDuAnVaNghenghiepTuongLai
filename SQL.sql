DROP DATABASE IF EXISTS DanhGia;

CREATE DATABASE DanhGia;

USE DanhGia;

CREATE TABLE Industry (
    IdIndustry int AUTO_INCREMENT primary key,
    nameIndustry text
);

CREATE TABLE Persional (
    IdPersional int AUTO_INCREMENT primary key,
    fistname text,
    lastname text,
    IdIndustry int,
    FOREIGN KEY (IdIndustry) REFERENCES Industry (IdIndustry)
);

CREATE TABLE Permission (
    IDPerm int AUTO_INCREMENT primary key,
    namePerm text
);

CREATE TABLE Account (
    IdAccount int AUTO_INCREMENT primary key,
    username varchar(12),
    password varchar(12),
    IdPersional int,
    IdPerm int,
    FOREIGN KEY (IdPersional) REFERENCES Persional (IdPersional),
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
    lastnameTeacher varchar(10),
    firstnameTeacher varchar(10)
);

CREATE TABLE Students (
    idStudent int AUTO_INCREMENT primary key,
    codeStudent int(8),
    lastnameStudent varchar(100),
    firstnameStudent varchar(100)
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
    nameProject TEXT,
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

INSERT INTO Industry (nameIndustry) VALUES 
    ('Công nghệ thông tin'),
    ('Ô tô');

INSERT INTO Persional (fistname, lastname, IdIndustry) VALUES 
    ('Huu Tho', 'Nguyen', 1),
    ('Huu A', 'Nguyen', 2);

INSERT INTO Permission (namePerm) 
    VALUES
        ('Admin'),
        ('Staff'),
        ('Teacher'),
        ('Student');

INSERT INTO Account (username, password, IdPersional, IdPerm) 
    VALUES 
        ('thonh', '123456', 1, 1),
        ('user2', '123456', 2, 3);

INSERT INTO Students (codeStudent, firstnameStudent, lastnameStudent)
    VALUES
        ('21022008', 'Hữu Thọ', 'Nguyễn');

INSERT INTO Teachers (lastnameTeacher, firstnameTeacher) 
    VALUES 
        ('Le Hoang', 'T');

INSERT INTO Courses (CodeCourse, nameCourse, NumberLecture, NumberPractice)
    VALUES
        ('TH1510', 'Đồ án cơ sở ngành Khoa học máy tính', 0, 2);

INSERT INTO ClassCourse (codeClassCourse, idCourse, idTeacher)
    VALUES
        ('232_1TH1510_KS3A_01_ngoaigio', 1, 1);

INSERT INTO Projects (nameProject, idClassCourse, idLeader, typeProject)
    VALUES
        ('Hệ thống quản lý đồ án và đánh giá kỹ nănng CNTT sinh viên', 1, 1, 'ind');