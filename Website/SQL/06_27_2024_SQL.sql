-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th6 27, 2024 lúc 08:38 AM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `danhgia`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `accounts`
--

CREATE TABLE `accounts` (
  `account_id` int(11) NOT NULL,
  `username` varchar(12) DEFAULT NULL,
  `password` varchar(12) DEFAULT NULL,
  `perm_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `accounts`
--

INSERT INTO `accounts` (`account_id`, `username`, `password`, `perm_id`) VALUES
(1, 'admin', '123456', 1),
(2, 'pdt1', '123456', 2),
(3, '21022008', '123456', 4),
(4, 'teacher1', '123456', 3),
(5, 'teacher2', '123456', 3),
(6, 'teacher3', '123456', 3),
(7, 'teacher4', '123456', 3),
(8, 'teacher5', '123456', 3),
(9, 'teacher6', '123456', 3),
(10, 'teacher7', '123456', 3),
(11, '21022002', '123456', 4),
(12, '21022010', '123456', 4),
(13, '21022007', '123456', 4),
(14, '21022009', '123456', 4);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `careers`
--

CREATE TABLE `careers` (
  `idCareer` int(11) NOT NULL,
  `nameCareer` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `classcourse`
--

CREATE TABLE `classcourse` (
  `classcourse_id` int(11) NOT NULL,
  `classcourse_code` varchar(50) DEFAULT NULL,
  `dateStart` date DEFAULT NULL,
  `dateEnd` date DEFAULT NULL,
  `course_code` varchar(6) DEFAULT NULL,
  `semester_code` varchar(3) DEFAULT NULL,
  `teacher_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `classcourse`
--

INSERT INTO `classcourse` (`classcourse_id`, `classcourse_code`, `dateStart`, `dateEnd`, `course_code`, `semester_code`, `teacher_id`) VALUES
(1, '232_1TH1510_KS3A_01_ngoaigio', '2024-03-11', '2024-06-30', 'TH1510', '232', 1),
(2, '233_1SP1418_KS1A_tructiep', '2023-03-11', '2023-06-30', 'SP1418', '233', 5),
(3, '231_1TH1507_KS3A_04_ngoaigio', '2023-03-11', '2023-06-30', 'TH1507', '231', 7),
(4, '222_1TH1391_KS2A_tructiep', '2023-03-11', '2023-06-30', 'TH1391', '222', 6),
(5, '232_1TH1382_KS2A_tructiep', '2024-03-11', '2024-06-30', 'TH1382', '232', 6),
(6, '232_1TH1333_KS2A_01_tructiep', NULL, NULL, 'TH1333', '232', 1),
(7, '232_1TH1333_KS2A_02_tructiep', NULL, NULL, 'TH1333', '232', 1),
(8, '232_1TH1333_KS2A_03_tructiep', NULL, NULL, 'TH1333', '232', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `courses`
--

CREATE TABLE `courses` (
  `course_id` int(11) NOT NULL,
  `course_code` varchar(6) NOT NULL,
  `course_name` text DEFAULT NULL,
  `course_name_ENG` text DEFAULT NULL,
  `NumberLecture` int(11) DEFAULT NULL,
  `NumberPractice` int(11) DEFAULT NULL,
  `sumcredit` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `courses`
--

INSERT INTO `courses` (`course_id`, `course_code`, `course_name`, `course_name_ENG`, `NumberLecture`, `NumberPractice`, `sumcredit`) VALUES
(1, 'TH1510', 'Đồ án cơ sở ngành Khoa học máy tính', '', 0, 2, NULL),
(2, 'SP1418', 'Chuẩn bị dạy học', '', 3, 0, NULL),
(3, 'TH1507', 'Đồ án CNTT 1', '', 0, 1, NULL),
(4, 'TH1512', 'Đồ án CNTT 2', '', 0, 1, NULL),
(5, 'TH1391', 'Nguyên lý máy học', 'Machine Learning', 2, 2, NULL),
(6, 'TH1382', 'Học sâu', 'Deep Learning', 2, 2, NULL),
(7, 'TH1333', 'Trí tuệ nhân tạo', NULL, 2, 1, 3);

--
-- Bẫy `courses`
--
DELIMITER $$
CREATE TRIGGER `calculate_sumcredit` BEFORE UPDATE ON `courses` FOR EACH ROW BEGIN
  IF NEW.NumberLecture <> OLD.NumberLecture OR NEW.NumberPractice <> OLD.NumberPractice THEN 
    SET NEW.sumcredit = NEW.NumberLecture + NEW.NumberPractice;
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `erollclasscourse`
--

CREATE TABLE `erollclasscourse` (
  `student_code` varchar(8) NOT NULL,
  `classcourse_code` varchar(50) NOT NULL,
  `semester_code` varchar(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `erollclasscourse`
--

INSERT INTO `erollclasscourse` (`student_code`, `classcourse_code`, `semester_code`) VALUES
('21022002', '232_1TH1510_KS3A_01_ngoaigio', '232'),
('21022008', '232_1TH1382_KS2A_tructiep', '232'),
('21022008', '232_1TH1510_KS3A_01_ngoaigio', '232');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `hisstudentdream`
--

CREATE TABLE `hisstudentdream` (
  `idhisStudentDream` int(11) NOT NULL,
  `idAccount` int(8) DEFAULT NULL,
  `idCareer` int(11) DEFAULT NULL,
  `timestamphisStudentDream` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `hist_viewcourse`
--

CREATE TABLE `hist_viewcourse` (
  `histviewcourse_id` int(11) NOT NULL,
  `histviewcourse_idclasscourse` int(11) NOT NULL,
  `histviewcourse_idAccount` int(11) NOT NULL,
  `histviewcourse_timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `hist_viewcourse`
--

INSERT INTO `hist_viewcourse` (`histviewcourse_id`, `histviewcourse_idclasscourse`, `histviewcourse_idAccount`, `histviewcourse_timestamp`) VALUES
(1, 1, 3, '2024-06-27 03:58:44'),
(2, 5, 3, '2024-06-27 03:58:50'),
(3, 1, 4, '2024-06-27 04:19:59'),
(4, 6, 4, '2024-06-27 04:20:07'),
(5, 1, 4, '2024-06-27 04:21:33'),
(6, 1, 3, '2024-06-27 04:34:36'),
(7, 1, 3, '2024-06-27 04:36:01'),
(8, 1, 3, '2024-06-27 04:40:10'),
(9, 1, 3, '2024-06-27 04:46:28'),
(10, 1, 3, '2024-06-27 04:47:54'),
(11, 1, 4, '2024-06-27 05:06:46'),
(12, 1, 4, '2024-06-27 05:07:42'),
(13, 4, 2, '2024-06-27 05:09:01'),
(14, 4, 2, '2024-06-27 05:14:36'),
(15, 1, 2, '2024-06-27 05:14:43'),
(16, 6, 2, '2024-06-27 05:14:46'),
(17, 6, 2, '2024-06-27 05:16:12'),
(18, 4, 2, '2024-06-27 05:17:43'),
(19, 1, 2, '2024-06-27 05:21:18'),
(20, 1, 2, '2024-06-27 05:21:51');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `hist_viewproject`
--

CREATE TABLE `hist_viewproject` (
  `histviewproject_id` int(11) NOT NULL,
  `histviewproject_idproject` int(11) NOT NULL,
  `histviewproject_idAccount` int(11) NOT NULL,
  `histviewproject_timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `hist_viewproject`
--

INSERT INTO `hist_viewproject` (`histviewproject_id`, `histviewproject_idproject`, `histviewproject_idAccount`, `histviewproject_timestamp`) VALUES
(1, 2, 3, '2024-06-27 02:51:18'),
(2, 2, 4, '2024-06-27 02:53:13'),
(3, 6, 4, '2024-06-27 03:11:02'),
(4, 2, 4, '2024-06-27 03:15:05'),
(5, 2, 4, '2024-06-27 03:15:22'),
(6, 6, 4, '2024-06-27 03:15:27'),
(7, 2, 4, '2024-06-27 03:15:31'),
(8, 2, 4, '2024-06-27 03:16:21'),
(9, 6, 4, '2024-06-27 03:16:24'),
(10, 1, 4, '2024-06-27 03:39:30'),
(11, 2, 4, '2024-06-27 03:41:03'),
(12, 1, 4, '2024-06-27 03:41:07'),
(13, 2, 4, '2024-06-27 03:41:10'),
(14, 1, 3, '2024-06-27 03:54:06'),
(15, 1, 3, '2024-06-27 03:55:26'),
(16, 1, 3, '2024-06-27 03:55:30'),
(17, 2, 3, '2024-06-27 03:55:37'),
(18, 5, 3, '2024-06-27 03:55:41'),
(19, 1, 3, '2024-06-27 03:55:44'),
(20, 5, 3, '2024-06-27 03:55:46'),
(21, 2, 3, '2024-06-27 04:49:06'),
(22, 2, 2, '2024-06-27 05:21:55');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `industries`
--

CREATE TABLE `industries` (
  `industry_id` int(11) NOT NULL,
  `industry_code` varchar(8) NOT NULL,
  `industry_name_VNI` varchar(255) DEFAULT NULL,
  `industry_name_ENG` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `industries`
--

INSERT INTO `industries` (`industry_id`, `industry_code`, `industry_name_VNI`, `industry_name_ENG`) VALUES
(1, 'CTT', 'Công nghệ thông tin', NULL),
(2, 'OTO', 'Ô tô', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `majors`
--

CREATE TABLE `majors` (
  `major_id` int(11) NOT NULL,
  `major_code` varchar(8) DEFAULT NULL,
  `major_name_VNI` varchar(255) DEFAULT NULL,
  `major_name_ENG` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `permission`
--

CREATE TABLE `permission` (
  `perm_id` int(11) NOT NULL,
  `namePerm` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `permission`
--

INSERT INTO `permission` (`perm_id`, `namePerm`) VALUES
(1, 'Admin'),
(2, 'Staff'),
(3, 'Teacher'),
(4, 'Student');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `projectprogress`
--

CREATE TABLE `projectprogress` (
  `ProjectProgress_id` int(11) NOT NULL,
  `project_id` int(11) DEFAULT NULL,
  `student_code` varchar(8) DEFAULT NULL,
  `milestone_name` varchar(255) DEFAULT NULL,
  `milestone_description` text DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `projectprogress`
--

INSERT INTO `projectprogress` (`ProjectProgress_id`, `project_id`, `student_code`, `milestone_name`, `milestone_description`, `last_updated`) VALUES
(1, NULL, '21022008', 'Báo cáo tiến độ 1', 'Xây dựng mô hình cơ bản website', '2024-05-30 07:31:05'),
(2, NULL, '21022008', 'Báo cáo tiến độ 1', 'Xây dựng mô hình website cơ bản', '2024-05-30 07:32:09'),
(3, NULL, '21022008', 'Báo cáo tiến độ 1', 'Xây dựng cấu trúc website cơ bản', '2024-05-30 07:34:59'),
(4, NULL, '21022008', 'Báo cáo tiến độ 1', 'Xây đựng tiến độ thực hiện báo cáo', '2024-05-30 07:35:47'),
(5, NULL, '21022008', 'Báo cáo tiến độ 1', 'Xây đựng tiến độ thực hiện báo cáo', '2024-05-30 07:38:20'),
(6, 2, '21022008', 'Báo cáo tiến độ 1', 'Xây đựng tiến độ thực hiện báo cáo', '2024-05-30 07:39:19'),
(7, 2, '21022008', 'Báo cáo tiến độ 2', 'Xây dựng cơ sở dữ liệu', '2024-05-30 07:49:50'),
(8, 2, '21022008', 'Báo cáo tiến độ 3', 'Xây đựng CSDL', '2024-06-06 07:51:17');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `projectproposal`
--

CREATE TABLE `projectproposal` (
  `proposal_id` int(11) NOT NULL,
  `proposal_title` varchar(500) DEFAULT NULL,
  `proposal_description` text DEFAULT NULL,
  `category` text DEFAULT NULL,
  `classcourse_code` varchar(50) DEFAULT NULL,
  `student_code` varchar(8) DEFAULT NULL,
  `teacher_code` varchar(3) DEFAULT NULL,
  `course_code` varchar(6) DEFAULT NULL,
  `semester_code` varchar(3) DEFAULT NULL,
  `staffApproved_status` varchar(8) DEFAULT '0',
  `teacherApproved_status` varchar(8) DEFAULT '0',
  `datetimeProposal` timestamp NOT NULL DEFAULT current_timestamp(),
  `teacherApproved_datetime` datetime DEFAULT NULL,
  `staffApproved_datetime` datetime DEFAULT NULL,
  `staffApproved` varchar(8) DEFAULT NULL,
  `TeacherApproved` varchar(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `projectproposal`
--

INSERT INTO `projectproposal` (`proposal_id`, `proposal_title`, `proposal_description`, `category`, `classcourse_code`, `student_code`, `teacher_code`, `course_code`, `semester_code`, `staffApproved_status`, `teacherApproved_status`, `datetimeProposal`, `teacherApproved_datetime`, `staffApproved_datetime`, `staffApproved`, `TeacherApproved`) VALUES
(1, 'Thiết lập Captive Portal trên OPNPfsense', NULL, NULL, NULL, NULL, 'GV2', 'TH1510', '232', '0', '1', '2024-05-30 07:13:19', NULL, NULL, NULL, NULL),
(2, 'Áp dụng Ansible để tự động hoá cấu hình thiết bị mạng', NULL, NULL, NULL, NULL, 'GV2', 'TH1510', '232', '0', '1', '2024-05-30 07:13:19', NULL, NULL, NULL, NULL),
(3, 'Phát hiện tấn công mạng bằng máy học', NULL, NULL, NULL, NULL, 'GV2', 'TH1510', '232', '0', '1', '2024-05-30 07:13:19', NULL, NULL, NULL, NULL),
(4, 'Các mô hình học sâu (Deep Learning) sử dụng cho phát hiện xâm nhập mạng', NULL, NULL, NULL, NULL, 'GV2', 'TH1510', '232', '0', '1', '2024-05-30 07:13:19', NULL, NULL, NULL, NULL),
(5, 'Phát hiện mã độc dựa vào học máy và thông tin PE Header', NULL, NULL, NULL, NULL, 'GV2', 'TH1510', '232', '0', '1', '2024-05-30 07:13:19', NULL, NULL, NULL, NULL),
(6, 'PHÁT HIỆN TẤN CÔNG SQL INJECTION BẰNG HỌC MÁY', NULL, NULL, NULL, NULL, 'GV2', 'TH1510', '232', '0', '1', '2024-05-30 07:13:19', NULL, NULL, NULL, NULL),
(7, 'Web Application Firewalls (NGINX ModSecurity)', NULL, NULL, NULL, NULL, 'GV2', 'TH1510', '232', '0', '1', '2024-05-30 07:13:19', NULL, NULL, NULL, NULL),
(8, 'Web Application Firewalls (open-appsec)', NULL, NULL, NULL, NULL, 'GV2', 'TH1510', '232', '0', '1', '2024-05-30 07:13:19', NULL, NULL, NULL, NULL),
(9, 'Web Application Firewalls (Naxsi)', NULL, NULL, NULL, NULL, 'GV2', 'TH1510', '232', '0', '1', '2024-05-30 07:13:19', NULL, NULL, NULL, NULL),
(10, 'Web Application Firewalls (Shadow Daemon)', NULL, NULL, NULL, NULL, 'GV2', 'TH1510', '232', '0', '1', '2024-05-30 07:13:19', NULL, NULL, NULL, NULL),
(11, 'Web Application Firewalls (IronBee)', NULL, NULL, NULL, NULL, 'GV2', 'TH1510', '232', '0', '1', '2024-05-30 07:13:19', NULL, NULL, NULL, NULL),
(12, 'Web Application Firewalls (Lua-resty-WAF)', NULL, NULL, NULL, NULL, 'GV2', 'TH1510', '232', '0', '1', '2024-05-30 07:13:19', NULL, NULL, NULL, NULL),
(13, 'Chương trình mã hóa ứng dụng kỹ thuật machine learning', 'Python', NULL, '232_1TH1510_KS3A_01_ngoaigio', '21022008', 'GV1', 'TH1510', '232', '1', '1', '2024-05-30 07:53:29', '2024-05-30 15:01:54', '2024-05-30 15:02:20', 'ST1', NULL),
(14, 'Lập trình website thương mại điện tử', 'PHP Mysql', NULL, '232_1TH1510_KS3A_01_ngoaigio', '21022008', 'GV1', 'TH1510', '232', '1', '1', '2024-06-06 07:47:54', '2024-06-06 14:48:53', '2024-06-06 14:50:02', 'ST1', NULL),
(15, 'Lập trình website bán linh kiện điện tử', '', 'website', '232_1TH1510_KS3A_01_ngoaigio', '21022008', 'GV1', 'TH1510', '232', '1', '1', '2024-06-13 09:02:48', '2024-06-13 16:09:42', '2024-06-13 16:29:41', 'ST1', NULL),
(16, 'Xây dựng website bán đồ ăn việt nam', '', 'website', '232_1TH1510_KS3A_01_ngoaigio', '21022008', 'GV1', 'TH1510', '232', '1', '1', '2024-06-13 09:10:12', '2024-06-13 16:11:36', '2024-06-13 16:30:02', 'ST1', NULL),
(17, 'Xây dựng website bán linh kiện điện gia dụng', '', 'website', '232_1TH1510_KS3A_01_ngoaigio', '21022008', 'GV1', 'TH1510', '232', '1', '1', '2024-06-13 09:11:19', '2024-06-13 16:25:18', '2024-06-13 16:29:49', 'ST1', NULL),
(18, 'Viết một website bán hàng đồ ăn Vĩnh Long', '', 'website', '232_1TH1510_KS3A_01_ngoaigio', '21022002', 'GV1', 'TH1510', '232', '1', '1', '2024-06-13 09:41:42', '2024-06-13 16:42:06', '2024-06-13 16:43:00', 'ST1', NULL),
(19, 'Lập trình trí tuệ nhân tạo để dự đoán giá nhà', '', 'website', '232_1TH1510_KS3A_01_ngoaigio', '21022008', 'GV1', 'TH1510', '232', '1', '1', '2024-06-13 10:15:12', '2024-06-13 17:16:04', '2024-06-13 17:17:12', 'ST1', NULL),
(20, 'Lập trình website để bán cá cảnh', '', 'website', '232_1TH1510_KS3A_01_ngoaigio', '21022008', 'GV1', 'TH1510', '232', '1', '1', '2024-06-13 10:15:27', '2024-06-13 17:16:07', '2024-06-13 17:17:29', 'ST1', NULL),
(21, 'Lập trình ứng dụng di động để bán đồ ăn nhanh', '', 'mobile-app', '232_1TH1510_KS3A_01_ngoaigio', '21022008', 'GV1', 'TH1510', '232', '1', '1', '2024-06-13 10:15:41', '2024-06-13 17:16:08', '2024-06-13 17:17:43', 'ST1', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `projects`
--

CREATE TABLE `projects` (
  `project_id` int(11) NOT NULL,
  `nameProject` varchar(500) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `project_status` tinyint(4) DEFAULT 0,
  `dateStart` date DEFAULT NULL,
  `dateEnd` date DEFAULT NULL,
  `classcourse_code` varchar(50) DEFAULT NULL,
  `teacher_code` varchar(8) DEFAULT NULL,
  `student_code` varchar(8) DEFAULT NULL,
  `typeProject` char(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `projects`
--

INSERT INTO `projects` (`project_id`, `nameProject`, `description`, `project_status`, `dateStart`, `dateEnd`, `classcourse_code`, `teacher_code`, `student_code`, `typeProject`) VALUES
(1, 'Phát hiện và khoanh vùng khối u não', '', 0, NULL, NULL, '232_1TH1510_KS3A_01_ngoaigio', 'GV1', '21022002', 'ind'),
(2, 'Hệ thống quản lý đồ án và phân loại chủ đề đồ án công nghệ thông tin', 'Website quản lý đồ án sinh viên thông qua các giao diện', 0, NULL, NULL, '232_1TH1510_KS3A_01_ngoaigio', 'GV1', '21022008', 'ind'),
(3, 'Nhận diện khuôn mặt', '', 0, NULL, NULL, '233_1SP1418_KS1A_tructiep', 'GV5', '21022008', 'ind'),
(4, 'Thiết kế và thực hiện mạch cân bằng Arduino cho quadcopter', '', 0, NULL, NULL, '232_1TH1510_KS3A_01_ngoaigio', 'GV1', '21022007', 'ind'),
(5, 'Phát hiện khối u não', '', 0, NULL, NULL, '231_1TH1507_KS3A_04_ngoaigio', 'GV6', '21022008', 'tea'),
(6, 'Phát hiện vật thể bằng YOLOv8 trên website', '', 0, NULL, NULL, '232_1TH1510_KS3A_01_ngoaigio', 'GV1', '21022006', 'ind');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `semesters`
--

CREATE TABLE `semesters` (
  `semester_id` int(11) NOT NULL,
  `semester_code` varchar(3) DEFAULT NULL,
  `nameSemester` text DEFAULT NULL,
  `yearSemester` varchar(9) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `semesters`
--

INSERT INTO `semesters` (`semester_id`, `semester_code`, `nameSemester`, `yearSemester`) VALUES
(1, '222', 'Học kỳ 2', '2022-2023'),
(2, '231', 'Học kỳ 1', '2023-2024'),
(3, '232', 'Học kỳ 2', '2023-2024'),
(4, '233', 'Học kỳ phụ', '2023-2024'),
(5, '234', 'Học kỳ hè', '2023-2024');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `specializations`
--

CREATE TABLE `specializations` (
  `specialization_id` int(11) NOT NULL,
  `specialization_code` varchar(8) DEFAULT NULL,
  `specialization_name_VNI` varchar(255) DEFAULT NULL,
  `specialization_name_ENG` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `staffs`
--

CREATE TABLE `staffs` (
  `staff_id` int(11) NOT NULL,
  `staff_code` varchar(8) NOT NULL,
  `lastnameStaff` varchar(10) DEFAULT NULL,
  `firstnameStaff` varchar(10) DEFAULT NULL,
  `account_id` int(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `staffs`
--

INSERT INTO `staffs` (`staff_id`, `staff_code`, `lastnameStaff`, `firstnameStaff`, `account_id`) VALUES
(1, 'ST1', 'Nguyen', 'Van A', 2);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `studentdream`
--

CREATE TABLE `studentdream` (
  `idAccount` int(8) NOT NULL,
  `idCareer` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `students`
--

CREATE TABLE `students` (
  `student_id` int(11) NOT NULL,
  `student_code` varchar(8) NOT NULL,
  `student_lastname` varchar(100) DEFAULT NULL,
  `student_firstname` varchar(100) DEFAULT NULL,
  `account_id` int(11) DEFAULT NULL,
  `industry_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `students`
--

INSERT INTO `students` (`student_id`, `student_code`, `student_lastname`, `student_firstname`, `account_id`, `industry_id`) VALUES
(1, '21022002', 'Âu Thị Anh', 'Thư', 11, 1),
(2, '21022008', 'Nguyễn Hữu', 'Thọ', 3, 1),
(3, '21022010', 'Lê Nguyễn Quang', 'Bình', 12, 1),
(4, '21022007', 'Nguyễn Văn', 'Huyên', 13, 1),
(5, '21022006', 'Tăng Huỳnh Thanh', 'Phú', 14, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `teachers`
--

CREATE TABLE `teachers` (
  `teacher_id` int(11) NOT NULL,
  `teacher_code` varchar(8) NOT NULL,
  `firstnameTeacher` varchar(50) DEFAULT NULL,
  `lastnameTeacher` varchar(100) DEFAULT NULL,
  `sex` int(1) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `account_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `teachers`
--

INSERT INTO `teachers` (`teacher_id`, `teacher_code`, `firstnameTeacher`, `lastnameTeacher`, `sex`, `birthday`, `account_id`) VALUES
(1, 'GV1', 'An', 'Lê Hoàng', 1, NULL, 4),
(2, 'GV2', 'Bảo', 'Trần Thái', 1, NULL, 5),
(3, 'GV3', 'Đạt', 'Trần Hồ', 1, NULL, 6),
(4, 'GV4', 'Nga', 'Nguyễn Ngọc', 0, NULL, 7),
(5, 'GV5', 'Sang', 'Trần Minh', 1, NULL, 8),
(6, 'GV6', 'Cang', 'Phan Anh', 1, NULL, 9),
(7, 'GV7', 'Thư', 'Mai Thiên', 0, NULL, 10);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `teamprojects`
--

CREATE TABLE `teamprojects` (
  `termproject_id` int(11) NOT NULL,
  `project_id` int(11) DEFAULT NULL,
  `student_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `teamprojects`
--

INSERT INTO `teamprojects` (`termproject_id`, `project_id`, `student_id`) VALUES
(1, 4, 2),
(2, 4, 3);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `templproject`
--

CREATE TABLE `templproject` (
  `idTemlProject` int(11) NOT NULL,
  `nameTemlProject` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `CodeCourse` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `templproject`
--

INSERT INTO `templproject` (`idTemlProject`, `nameTemlProject`, `CodeCourse`) VALUES
(1, 'Viết web bằng joomla', 'TH1502'),
(2, 'Viết web bằng wordpress', 'TH1502'),
(3, 'Chatbot tư vấn tuyển sinh', 'TH1502'),
(4, 'Xây dựng website tin tức đoàn khoa', 'TH1502'),
(5, 'Xây dựng website đăng ký tham gia phong trào', 'TH1502'),
(6, 'Xây dựng website quản lý đoàn phí', 'TH1502'),
(7, 'Xây dựng website quản lý sổ đoàn', 'TH1502'),
(8, 'Xây dựng website hỗ trợ học anh văn chuyên ngành', 'TH1502'),
(9, 'Xây dựng website quản lý tiệm net', 'TH1502'),
(10, 'Xây dựng website quản lý karaoke', 'TH1502'),
(11, 'Xây dựng website quản lý quán cà phê', 'TH1502'),
(12, 'Xây dựng website thi trắc nghiệm', 'TH1502'),
(13, 'Xây dựng website bán hàng trực tuyến', 'TH1502'),
(14, 'Thiết kế logo đoàn khoa dựa vào kỹ thuật xử lý hình ảnh', 'TH1502'),
(15, 'Xây dựng hệ thống nhận diện ảnh', 'TH1502'),
(16, 'Xây dựng hệ thống quản lý điểm công tác xã hội', 'TH1502'),
(17, 'Xây dựng hệ thống xếp thời khóa biểu cho giảng viên', 'TH1502'),
(18, 'Robot điều khiển bằng giọng nói', 'TH1502'),
(19, 'Robot điều khiển bằng smartphone', 'TH1502'),
(20, 'Lập trình game mini', 'TH1502'),
(21, 'Hệ thống bật tắt đèn bằng app', 'TH1502'),
(22, 'Hệ thống điều khiển thiết bị từ xa', 'TH1502'),
(23, 'Hệ thống điểm danh bằng gương mặt', 'TH1502'),
(24, 'Hệ thống điểm danh bằng thẻ', 'TH1502'),
(25, 'Hệ thống điểm danh bằng mã QR', 'TH1502'),
(26, 'Xây dựng ứng dụng trích xuất thông tin căn cước công dân', 'TH1512'),
(27, 'Nhận diện sự kiện trong video bóng đá', 'TH1512'),
(28, 'Xây dựng hệ thống nhận diện ngôn ngữ ký hiệu hỗ trợ người khiếm khuyết', 'TH1512'),
(29, 'Xây dựng website 360 độ và ứng dụng trợ lý ảo trong tham quan csvc của khoa CNTT', 'TH1512'),
(30, 'Triển khai hệ thống phân tích dự đoán, hỗ trợ nhà tuyển dụng ứng dụng công nghệ AI', 'TH1512'),
(31, 'Ứng dụng IoT trong phát triển ứng dụng theo dõi mô hình hồ cá thông minh và dự đoán bệnh ở cá', 'TH1512'),
(32, 'Xây dựng website đề tài, khoá luận - ĐH SPKT Vĩnh Long', 'TH1512'),
(33, 'Xây dựng website hỗ trợ học tập cho sinh viên trường ĐH SPKT Vĩnh Long', 'TH1512'),
(34, 'Phát triển hệ thống quản lý vườn thanh long thông minh ứng dụng công nghệ iot và chuẩn đoán bệnh ở cây thanh long', 'TH1512');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`account_id`),
  ADD KEY `perm_id` (`perm_id`);

--
-- Chỉ mục cho bảng `careers`
--
ALTER TABLE `careers`
  ADD PRIMARY KEY (`idCareer`);

--
-- Chỉ mục cho bảng `classcourse`
--
ALTER TABLE `classcourse`
  ADD PRIMARY KEY (`classcourse_id`),
  ADD UNIQUE KEY `U_ClassCourse` (`classcourse_code`),
  ADD KEY `PK_ClassCourse_Courses` (`course_code`),
  ADD KEY `PK_ClassCourse_Semesters` (`semester_code`),
  ADD KEY `PK_ClassCourse_Teachers` (`teacher_id`);

--
-- Chỉ mục cho bảng `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`course_id`,`course_code`),
  ADD UNIQUE KEY `U_Courses` (`course_code`);

--
-- Chỉ mục cho bảng `erollclasscourse`
--
ALTER TABLE `erollclasscourse`
  ADD PRIMARY KEY (`student_code`,`classcourse_code`),
  ADD KEY `classcourse_code` (`classcourse_code`);

--
-- Chỉ mục cho bảng `hisstudentdream`
--
ALTER TABLE `hisstudentdream`
  ADD PRIMARY KEY (`idhisStudentDream`),
  ADD KEY `idAccount` (`idAccount`),
  ADD KEY `idCareer` (`idCareer`);

--
-- Chỉ mục cho bảng `hist_viewcourse`
--
ALTER TABLE `hist_viewcourse`
  ADD PRIMARY KEY (`histviewcourse_id`);

--
-- Chỉ mục cho bảng `hist_viewproject`
--
ALTER TABLE `hist_viewproject`
  ADD PRIMARY KEY (`histviewproject_id`);

--
-- Chỉ mục cho bảng `industries`
--
ALTER TABLE `industries`
  ADD PRIMARY KEY (`industry_id`,`industry_code`),
  ADD UNIQUE KEY `U_Industries` (`industry_code`);

--
-- Chỉ mục cho bảng `majors`
--
ALTER TABLE `majors`
  ADD PRIMARY KEY (`major_id`),
  ADD UNIQUE KEY `U_Majors` (`major_code`);

--
-- Chỉ mục cho bảng `permission`
--
ALTER TABLE `permission`
  ADD PRIMARY KEY (`perm_id`);

--
-- Chỉ mục cho bảng `projectprogress`
--
ALTER TABLE `projectprogress`
  ADD PRIMARY KEY (`ProjectProgress_id`),
  ADD KEY `project_id` (`project_id`),
  ADD KEY `student_code` (`student_code`);

--
-- Chỉ mục cho bảng `projectproposal`
--
ALTER TABLE `projectproposal`
  ADD PRIMARY KEY (`proposal_id`),
  ADD KEY `classcourse_code` (`classcourse_code`),
  ADD KEY `student_code` (`student_code`),
  ADD KEY `teacher_code` (`teacher_code`),
  ADD KEY `TeacherApproved` (`TeacherApproved`),
  ADD KEY `staffApproved` (`staffApproved`),
  ADD KEY `course_code` (`course_code`),
  ADD KEY `semester_code` (`semester_code`);

--
-- Chỉ mục cho bảng `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`project_id`),
  ADD KEY `classcourse_code` (`classcourse_code`),
  ADD KEY `teacher_code` (`teacher_code`);

--
-- Chỉ mục cho bảng `semesters`
--
ALTER TABLE `semesters`
  ADD PRIMARY KEY (`semester_id`),
  ADD UNIQUE KEY `U_Semester` (`semester_code`);

--
-- Chỉ mục cho bảng `specializations`
--
ALTER TABLE `specializations`
  ADD PRIMARY KEY (`specialization_id`);

--
-- Chỉ mục cho bảng `staffs`
--
ALTER TABLE `staffs`
  ADD PRIMARY KEY (`staff_id`,`staff_code`),
  ADD UNIQUE KEY `U_Staffs` (`staff_code`),
  ADD KEY `PK_Staffs_Accounts` (`account_id`);

--
-- Chỉ mục cho bảng `studentdream`
--
ALTER TABLE `studentdream`
  ADD PRIMARY KEY (`idAccount`),
  ADD KEY `idCareer` (`idCareer`);

--
-- Chỉ mục cho bảng `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`student_id`,`student_code`),
  ADD UNIQUE KEY `U_Students` (`student_code`),
  ADD KEY `PK_Students_Accounts` (`account_id`),
  ADD KEY `PK_Students_Industries` (`industry_id`);

--
-- Chỉ mục cho bảng `teachers`
--
ALTER TABLE `teachers`
  ADD PRIMARY KEY (`teacher_id`,`teacher_code`),
  ADD UNIQUE KEY `U_Teacher` (`teacher_code`),
  ADD KEY `PK_Teachers_Accounts` (`account_id`);

--
-- Chỉ mục cho bảng `teamprojects`
--
ALTER TABLE `teamprojects`
  ADD PRIMARY KEY (`termproject_id`),
  ADD KEY `project_id` (`project_id`),
  ADD KEY `student_id` (`student_id`);

--
-- Chỉ mục cho bảng `templproject`
--
ALTER TABLE `templproject`
  ADD PRIMARY KEY (`idTemlProject`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `accounts`
--
ALTER TABLE `accounts`
  MODIFY `account_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT cho bảng `careers`
--
ALTER TABLE `careers`
  MODIFY `idCareer` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `classcourse`
--
ALTER TABLE `classcourse`
  MODIFY `classcourse_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT cho bảng `courses`
--
ALTER TABLE `courses`
  MODIFY `course_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `hisstudentdream`
--
ALTER TABLE `hisstudentdream`
  MODIFY `idhisStudentDream` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `hist_viewcourse`
--
ALTER TABLE `hist_viewcourse`
  MODIFY `histviewcourse_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT cho bảng `hist_viewproject`
--
ALTER TABLE `hist_viewproject`
  MODIFY `histviewproject_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT cho bảng `industries`
--
ALTER TABLE `industries`
  MODIFY `industry_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `majors`
--
ALTER TABLE `majors`
  MODIFY `major_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `permission`
--
ALTER TABLE `permission`
  MODIFY `perm_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `projectprogress`
--
ALTER TABLE `projectprogress`
  MODIFY `ProjectProgress_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT cho bảng `projectproposal`
--
ALTER TABLE `projectproposal`
  MODIFY `proposal_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT cho bảng `projects`
--
ALTER TABLE `projects`
  MODIFY `project_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `semesters`
--
ALTER TABLE `semesters`
  MODIFY `semester_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `specializations`
--
ALTER TABLE `specializations`
  MODIFY `specialization_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `staffs`
--
ALTER TABLE `staffs`
  MODIFY `staff_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `students`
--
ALTER TABLE `students`
  MODIFY `student_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `teachers`
--
ALTER TABLE `teachers`
  MODIFY `teacher_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `teamprojects`
--
ALTER TABLE `teamprojects`
  MODIFY `termproject_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `templproject`
--
ALTER TABLE `templproject`
  MODIFY `idTemlProject` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `accounts`
--
ALTER TABLE `accounts`
  ADD CONSTRAINT `accounts_ibfk_1` FOREIGN KEY (`perm_id`) REFERENCES `permission` (`perm_id`);

--
-- Các ràng buộc cho bảng `classcourse`
--
ALTER TABLE `classcourse`
  ADD CONSTRAINT `PK_ClassCourse_Courses` FOREIGN KEY (`course_code`) REFERENCES `courses` (`course_code`),
  ADD CONSTRAINT `PK_ClassCourse_Semesters` FOREIGN KEY (`semester_code`) REFERENCES `semesters` (`semester_code`),
  ADD CONSTRAINT `PK_ClassCourse_Teachers` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`teacher_id`);

--
-- Các ràng buộc cho bảng `erollclasscourse`
--
ALTER TABLE `erollclasscourse`
  ADD CONSTRAINT `erollclasscourse_ibfk_1` FOREIGN KEY (`student_code`) REFERENCES `students` (`student_code`),
  ADD CONSTRAINT `erollclasscourse_ibfk_2` FOREIGN KEY (`classcourse_code`) REFERENCES `classcourse` (`classcourse_code`);

--
-- Các ràng buộc cho bảng `hisstudentdream`
--
ALTER TABLE `hisstudentdream`
  ADD CONSTRAINT `hisstudentdream_ibfk_1` FOREIGN KEY (`idAccount`) REFERENCES `studentdream` (`idAccount`),
  ADD CONSTRAINT `hisstudentdream_ibfk_2` FOREIGN KEY (`idCareer`) REFERENCES `careers` (`idCareer`);

--
-- Các ràng buộc cho bảng `projectprogress`
--
ALTER TABLE `projectprogress`
  ADD CONSTRAINT `projectprogress_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`),
  ADD CONSTRAINT `projectprogress_ibfk_2` FOREIGN KEY (`student_code`) REFERENCES `students` (`student_code`);

--
-- Các ràng buộc cho bảng `projectproposal`
--
ALTER TABLE `projectproposal`
  ADD CONSTRAINT `projectproposal_ibfk_1` FOREIGN KEY (`classcourse_code`) REFERENCES `classcourse` (`classcourse_code`),
  ADD CONSTRAINT `projectproposal_ibfk_2` FOREIGN KEY (`student_code`) REFERENCES `students` (`student_code`),
  ADD CONSTRAINT `projectproposal_ibfk_3` FOREIGN KEY (`teacher_code`) REFERENCES `teachers` (`teacher_code`),
  ADD CONSTRAINT `projectproposal_ibfk_4` FOREIGN KEY (`TeacherApproved`) REFERENCES `teachers` (`teacher_code`),
  ADD CONSTRAINT `projectproposal_ibfk_5` FOREIGN KEY (`staffApproved`) REFERENCES `staffs` (`staff_code`),
  ADD CONSTRAINT `projectproposal_ibfk_6` FOREIGN KEY (`course_code`) REFERENCES `courses` (`course_code`),
  ADD CONSTRAINT `projectproposal_ibfk_7` FOREIGN KEY (`semester_code`) REFERENCES `semesters` (`semester_code`);

--
-- Các ràng buộc cho bảng `projects`
--
ALTER TABLE `projects`
  ADD CONSTRAINT `projects_ibfk_1` FOREIGN KEY (`classcourse_code`) REFERENCES `classcourse` (`classcourse_code`),
  ADD CONSTRAINT `projects_ibfk_2` FOREIGN KEY (`teacher_code`) REFERENCES `teachers` (`teacher_code`);

--
-- Các ràng buộc cho bảng `staffs`
--
ALTER TABLE `staffs`
  ADD CONSTRAINT `PK_Staffs_Accounts` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`account_id`);

--
-- Các ràng buộc cho bảng `studentdream`
--
ALTER TABLE `studentdream`
  ADD CONSTRAINT `studentdream_ibfk_1` FOREIGN KEY (`idCareer`) REFERENCES `careers` (`idCareer`);

--
-- Các ràng buộc cho bảng `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `PK_Students_Accounts` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`account_id`),
  ADD CONSTRAINT `PK_Students_Industries` FOREIGN KEY (`industry_id`) REFERENCES `industries` (`industry_id`);

--
-- Các ràng buộc cho bảng `teachers`
--
ALTER TABLE `teachers`
  ADD CONSTRAINT `PK_Teachers_Accounts` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`account_id`);

--
-- Các ràng buộc cho bảng `teamprojects`
--
ALTER TABLE `teamprojects`
  ADD CONSTRAINT `teamprojects_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`),
  ADD CONSTRAINT `teamprojects_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
