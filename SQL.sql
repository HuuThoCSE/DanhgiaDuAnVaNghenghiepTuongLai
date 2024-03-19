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

CREATE TABLE Courses (
    idCourse int AUTO_INCREMENT primary key,
    CodeCourse varchar(6),
    nameCourse text,
    NumberLecture int,
    NumberPractice int,
    sumcredit int
)

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

INSERT TABLE Courses (CodeCourse, nameCourse, NumberLecture, NumberPractice)
    VALUES
        ('TH1510', 'Đồ án cơ sở ngành Khoa học máy tính', 0, 2)