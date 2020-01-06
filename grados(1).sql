-- --------------------------------------------------------
-- Host:                         10.1.14.10
-- Versión del servidor:         10.3.11-MariaDB - MariaDB Server
-- SO del servidor:              Linux
-- HeidiSQL Versión:             10.2.0.5599
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Volcando estructura de base de datos para grados
CREATE DATABASE IF NOT EXISTS `grados` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `grados`;

-- -- Volcando estructura para tabla grados.Appointments
-- CREATE TABLE IF NOT EXISTS `Appointments` (
--   `appointmentId` int(11) NOT NULL AUTO_INCREMENT,
--   `tutoringHoursId` int(11) NOT NULL,
--   `studentId` int(11) NOT NULL,
--   `hour` time NOT NULL,
--   `date` date NOT NULL,
--   PRIMARY KEY (`appointmentId`),
--   KEY `tutoringHoursId` (`tutoringHoursId`),
--   KEY `studentId` (`studentId`),
--   CONSTRAINT `Appointments_ibfk_1` FOREIGN KEY (`tutoringHoursId`) REFERENCES `TutoringHours` (`tutoringHoursId`),
--   CONSTRAINT `Appointments_ibfk_2` FOREIGN KEY (`studentId`) REFERENCES `Students` (`studentId`)
-- ) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- -- Volcando datos para la tabla grados.Appointments: ~3 rows (aproximadamente)
-- /*!40000 ALTER TABLE `Appointments` DISABLE KEYS */;
-- REPLACE INTO `Appointments` (`appointmentId`, `tutoringHoursId`, `studentId`, `hour`, `date`) VALUES
-- 	(1, 1, 1, '13:00:00', '2019-11-18'),
-- 	(2, 2, 2, '18:20:00', '2019-11-19'),
-- 	(3, 4, 1, '15:00:00', '2019-11-20');
-- /*!40000 ALTER TABLE `Appointments` ENABLE KEYS */;

-- -- Volcando estructura para tabla grados.Classrooms
-- CREATE TABLE IF NOT EXISTS `Classrooms` (
--   `classroomId` int(11) NOT NULL AUTO_INCREMENT,
--   `name` varchar(60) NOT NULL,
--   `floor` int(11) NOT NULL,
--   `capacity` int(11) NOT NULL,
--   `hasProjector` tinyint(1) NOT NULL,
--   `hasLoudSpeakers` tinyint(1) NOT NULL,
--   PRIMARY KEY (`classroomId`),
--   UNIQUE KEY `name` (`name`),
--   CONSTRAINT `invalidFloor` CHECK (`floor` >= 0),
--   CONSTRAINT `invalidCapacity` CHECK (`capacity` > 0)
-- ) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- -- Volcando datos para la tabla grados.Classrooms: ~3 rows (aproximadamente)
-- /*!40000 ALTER TABLE `Classrooms` DISABLE KEYS */;
-- REPLACE INTO `Classrooms` (`classroomId`, `name`, `floor`, `capacity`, `hasProjector`, `hasLoudSpeakers`) VALUES
-- 	(1, 'F1.31', 1, 30, 1, 0),
-- 	(2, 'F1.33', 1, 35, 1, 0),
-- 	(3, 'A0.31', 1, 80, 1, 1);
-- /*!40000 ALTER TABLE `Classrooms` ENABLE KEYS */;

-- Volcando estructura para procedimiento grados.createGrade
DELIMITER //
CREATE DEFINER=`root`@`%` PROCEDURE `createGrade`(groupId INT, studentId INT, gradeCall INT, withHonours BOOLEAN, value DECIMAL(4,2))
BEGIN
	INSERT INTO Grades (groupId, studentId, gradeCall, withHonours, value) VALUES (groupId, studentId, gradeCall, withHonours, value);
END//
DELIMITER ;

-- Volcando estructura para procedimiento grados.createTables
DELIMITER //
CREATE DEFINER=`root`@`%` PROCEDURE `createTables`()
BEGIN
	SET FOREIGN_KEY_CHECKS=0;
	DROP TABLE IF EXISTS Degrees;
	DROP TABLE IF EXISTS Subjects;
	DROP TABLE IF EXISTS Groups;
	DROP TABLE IF EXISTS Students;
	DROP TABLE IF EXISTS GroupsStudents;
	DROP TABLE IF EXISTS Grades;
	DROP TABLE IF EXISTS Offices;
	DROP TABLE IF EXISTS Classrooms;
	DROP TABLE IF EXISTS Departments;
	DROP TABLE IF EXISTS TutoringHours;
	DROP TABLE IF EXISTS TeachingLoads;
	DROP TABLE IF EXISTS Appointments;
	DROP TABLE IF EXISTS Professors;
	SET FOREIGN_KEY_CHECKS=1;

	CREATE TABLE Offices (
		officeId INT NOT NULL AUTO_INCREMENT,
		name VARCHAR(60) NOT NULL,
		floor INT NOT NULL, 
		capacity INT NOT NULL,
		PRIMARY KEY (officeId),
		CONSTRAINT invalidFloor CHECK (floor >= 0),
		CONSTRAINT invalidCapacity CHECK (capacity > 0),
		UNIQUE (name)
	);

	CREATE TABLE Classrooms (
		classroomId INT NOT NULL AUTO_INCREMENT,
		name VARCHAR(60) NOT NULL UNIQUE,
		floor INT NOT NULL, 
		capacity INT NOT NULL,
		hasProjector BOOLEAN NOT NULL,
		hasLoudSpeakers BOOLEAN NOT NULL,
		PRIMARY KEY (classroomId),
		CONSTRAINT invalidFloor CHECK (floor >= 0),
		CONSTRAINT invalidCapacity CHECK (capacity > 0)
	);

	CREATE TABLE Departments (
		departmentId INT NOT NULL AUTO_INCREMENT,
		name VARCHAR(60) NOT NULL UNIQUE,
		PRIMARY KEY (departmentId)
	);

	CREATE TABLE Degrees(
		degreeId INT NOT NULL AUTO_INCREMENT,
		name VARCHAR(60) NOT NULL UNIQUE,
		years INT DEFAULT(4) NOT NULL,
		PRIMARY KEY (degreeId),
		CONSTRAINT invalidDegreeYear CHECK (years >=3 AND years <=5)
	);

	CREATE TABLE Subjects(
		subjectId INT NOT NULL AUTO_INCREMENT,
		name VARCHAR(100) NOT NULL UNIQUE,
		acronym VARCHAR(8) NOT NULL UNIQUE,
		credits INT NOT NULL,
		course INT NOT NULL,
		type VARCHAR(20) NOT NULL,
		degreeId INT NOT NULL,
		departmentId INT NOT NULL,
		PRIMARY KEY (subjectId),
		FOREIGN KEY (degreeId) REFERENCES Degrees (degreeId),
		FOREIGN KEY (departmentId) REFERENCES Departments (departmentId),
		CONSTRAINT negativeSubjectCredits CHECK (credits > 0),
		CONSTRAINT invalidSubjectCourse CHECK (course > 0 AND course < 6),
		CONSTRAINT invalidSubjectType CHECK (type IN ('Formacion Basica',
																	'Optativa',
																	'Obligatoria'))
	);

	CREATE TABLE Groups(
		groupId INT NOT NULL AUTO_INCREMENT,
		name VARCHAR(30) NOT NULL,
		activity VARCHAR(20) NOT NULL,
		year INT NOT NULL,
		subjectId INT NOT NULL,
		classroomId INT NOT NULL,
		PRIMARY KEY (groupId),
		FOREIGN KEY (subjectId) REFERENCES Subjects (subjectId),
		FOREIGN KEY (classroomId) REFERENCES Classrooms (classroomId),
		UNIQUE (name, year, subjectId),
		CONSTRAINT negativeGroupYear CHECK (year > 0),
		CONSTRAINT invalidGroupActivity CHECK (activity IN ('Teoria',
																			'Laboratorio'))
	);

	CREATE TABLE Students(
		studentId INT NOT NULL AUTO_INCREMENT,
		accessMethod VARCHAR(30) NOT NULL,
		dni CHAR(9) NOT NULL UNIQUE,
		firstName VARCHAR(100) NOT NULL,
		surname VARCHAR(100) NOT NULL,
		birthDate DATE NOT NULL,
		email VARCHAR(250) NOT NULL UNIQUE,
		PRIMARY KEY (studentId),
		CONSTRAINT invalidStudentAccessMethod CHECK (accessMethod IN ('Selectividad',
																						'Ciclo',
																						'Mayor',
																						'Titulado Extranjero'))
	);

	CREATE TABLE GroupsStudents(
		groupStudentId INT NOT NULL AUTO_INCREMENT,
		groupId INT NOT NULL,
		studentId INT NOT NULL,
		PRIMARY KEY (groupStudentId),
		FOREIGN KEY (groupId) REFERENCES Groups (groupId) ON DELETE CASCADE,
		FOREIGN KEY (studentId) REFERENCES Students (studentId),
		UNIQUE (groupId, studentId)
	);

	CREATE TABLE Grades(
		gradeId INT NOT NULL AUTO_INCREMENT,
		value DECIMAL(4,2) NOT NULL,
		gradeCall INT NOT NULL,
		withHonours BOOLEAN NOT NULL,
		studentId INT NOT NULL,
		groupId INT NOT NULL,
		PRIMARY KEY (gradeId),
		FOREIGN KEY (studentId) REFERENCES Students (studentId),
		FOREIGN KEY (groupId) REFERENCES Groups (groupId) ON DELETE CASCADE,
		CONSTRAINT invalidGradeValue CHECK (value >= 0 AND value <= 10),
		CONSTRAINT invalidGradeCall CHECK (gradeCall >= 1 AND gradeCall <= 3),
		CONSTRAINT duplicatedCallGrade UNIQUE (gradeCall, studentId, groupId)
	);

	CREATE TABLE Professors (
		professorId INT NOT NULL AUTO_INCREMENT,
		officeId INT NOT NULL,
		departmentId INT NOT NULL,
		category VARCHAR(5) NOT NULL,
		dni CHAR(9) NOT NULL UNIQUE,
		firstName VARCHAR(100) NOT NULL,
		surname VARCHAR(100) NOT NULL,
		birthDate DATE NOT NULL,
		email VARCHAR(250) NOT NULL UNIQUE,
		PRIMARY KEY (professorId),
		FOREIGN KEY (officeId) REFERENCES Offices (officeId),
		FOREIGN KEY (departmentId) REFERENCES Departments (departmentId),
		CONSTRAINT invalidCategory CHECK (category IN ('CU',
														'TU',
														'PCD',
														'PAD'))
	);

	CREATE TABLE TutoringHours(
		tutoringHoursId INT NOT NULL AUTO_INCREMENT,
		professorId INT NOT NULL,
		dayOfWeek INT NOT NULL,
		startHour TIME,
		endHour TIME,
		PRIMARY KEY (tutoringHoursId),
		FOREIGN KEY (professorId) REFERENCES Professors (professorId),
		CONSTRAINT invalidDayOfWeek CHECK (dayOfWeek >= 0 AND dayOfWeek <= 6)
	);

	CREATE TABLE Appointments(
		appointmentId INT NOT NULL AUTO_INCREMENT,
		tutoringHoursId INT NOT NULL,
		studentId INT NOT NULL,
		hour TIME NOT NULL,
		date DATE NOT NULL,
		PRIMARY KEY (appointmentId),
		FOREIGN KEY (tutoringHoursId) REFERENCES TutoringHours (tutoringHoursId),
		FOREIGN KEY (studentId) REFERENCES Students (studentId)
	);

	CREATE TABLE TeachingLoads(
		teachingLoadId INT NOT NULL AUTO_INCREMENT,
		professorId INT NOT NULL,
		groupId INT NOT NULL,
		credits INT NOT NULL,
		PRIMARY KEY (teachingLoadId),
		FOREIGN KEY (professorId) REFERENCES Professors (professorId),
		FOREIGN KEY (groupId) REFERENCES Groups (groupId),
		CONSTRAINT invalidCredits CHECK (credits > 0)
	);
END//
DELIMITER ;

-- Volcando estructura para tabla grados.Degrees
CREATE TABLE IF NOT EXISTS `Degrees` (
  `degreeId` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `years` int(11) NOT NULL DEFAULT 4,
  PRIMARY KEY (`degreeId`),
  UNIQUE KEY `name` (`name`),
  CONSTRAINT `invalidDegreeYear` CHECK (`years` >= 3 and `years` <= 5)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla grados.Degrees: ~3 rows (aproximadamente)
/*!40000 ALTER TABLE `Degrees` DISABLE KEYS */;
REPLACE INTO `Degrees` (`degreeId`, `name`, `years`) VALUES
	(1, 'Ingeniería del Software', 4),
	(2, 'Ingeniería del Computadores', 4),
	(3, 'Tecnologías Informáticas', 4);
/*!40000 ALTER TABLE `Degrees` ENABLE KEYS */;

-- Volcando estructura para tabla grados.Departments
CREATE TABLE IF NOT EXISTS `Departments` (
  `departmentId` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  PRIMARY KEY (`departmentId`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla grados.Departments: ~2 rows (aproximadamente)
/*!40000 ALTER TABLE `Departments` DISABLE KEYS */;
REPLACE INTO `Departments` (`departmentId`, `name`) VALUES
	(1, 'Lenguajes y Sistemas Informáticos'),
	(2, 'Matemáticas');
/*!40000 ALTER TABLE `Departments` ENABLE KEYS */;

-- Volcando estructura para función grados.functionAvgGrade
DELIMITER //
CREATE DEFINER=`root`@`%` FUNCTION `functionAvgGrade`(studentId INT) RETURNS double
BEGIN
	RETURN (	SELECT AVG(value) 
	 			FROM Grades 
				WHERE GRADES.studentId=studentId);
END//
DELIMITER ;

-- Volcando estructura para función grados.functionProfessorHighestLoad
DELIMITER //
CREATE DEFINER=`root`@`%` FUNCTION `functionProfessorHighestLoad`(subjectId INT, year INT) RETURNS int(11)
BEGIN
	RETURN (SELECT TeachingLoads.professorId
				FROM TeachingLoads
				JOIN Groups ON (TeachingLoads.groupId = Groups.groupId)
				JOIN Subjects ON (Groups.subjectId = Subjects.subjectId)
				WHERE Subjects.subjectId = subjectId AND Groups.year = year
				GROUP BY TeachingLoads.professorId
				ORDER BY SUM(TeachingLoads.credits) DESC
				LIMIT 1);
END//
DELIMITER ;

-- Volcando estructura para tabla grados.Grades
CREATE TABLE IF NOT EXISTS `Grades` (
  `gradeId` int(11) NOT NULL AUTO_INCREMENT,
  `value` decimal(4,2) NOT NULL,
  `gradeCall` int(11) NOT NULL,
  `withHonours` tinyint(1) NOT NULL,
  `studentId` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  PRIMARY KEY (`gradeId`),
  UNIQUE KEY `duplicatedCallGrade` (`gradeCall`,`studentId`,`groupId`),
  KEY `studentId` (`studentId`),
  KEY `groupId` (`groupId`),
  CONSTRAINT `Grades_ibfk_1` FOREIGN KEY (`studentId`) REFERENCES `Students` (`studentId`),
  CONSTRAINT `Grades_ibfk_2` FOREIGN KEY (`groupId`) REFERENCES `Groups` (`groupId`) ON DELETE CASCADE,
  CONSTRAINT `invalidGradeValue` CHECK (`value` >= 0 and `value` <= 10),
  CONSTRAINT `invalidGradeCall` CHECK (`gradeCall` >= 1 and `gradeCall` <= 3)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla grados.Grades: ~10 rows (aproximadamente)
/*!40000 ALTER TABLE `Grades` DISABLE KEYS */;
REPLACE INTO `Grades` (`gradeId`, `value`, `gradeCall`, `withHonours`, `studentId`, `groupId`) VALUES
	(1, 4.50, 1, 0, 1, 1),
	(2, 3.25, 2, 0, 1, 1),
	(3, 9.95, 1, 0, 1, 7),
	(4, 7.50, 1, 0, 1, 10),
	(5, 2.50, 1, 0, 2, 2),
	(6, 5.00, 2, 0, 2, 2),
	(7, 10.00, 1, 1, 2, 10),
	(8, 0.00, 1, 0, 21, 18),
	(9, 1.25, 2, 0, 21, 18),
	(10, 0.50, 3, 0, 21, 18);
/*!40000 ALTER TABLE `Grades` ENABLE KEYS */;

-- Volcando estructura para tabla grados.Groups
CREATE TABLE IF NOT EXISTS `Groups` (
  `groupId` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `activity` varchar(20) NOT NULL,
  `year` int(11) NOT NULL,
  `subjectId` int(11) NOT NULL,
  `classroomId` int(11) NOT NULL,
  PRIMARY KEY (`groupId`),
  UNIQUE KEY `name` (`name`,`year`,`subjectId`),
  KEY `subjectId` (`subjectId`),
  KEY `classroomId` (`classroomId`),
  CONSTRAINT `Groups_ibfk_1` FOREIGN KEY (`subjectId`) REFERENCES `Subjects` (`subjectId`),
  CONSTRAINT `Groups_ibfk_2` FOREIGN KEY (`classroomId`) REFERENCES `Classrooms` (`classroomId`),
  CONSTRAINT `negativeGroupYear` CHECK (`year` > 0),
  CONSTRAINT `invalidGroupActivity` CHECK (`activity` in ('Teoria','Laboratorio'))
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla grados.Groups: ~25 rows (aproximadamente)
/*!40000 ALTER TABLE `Groups` DISABLE KEYS */;
REPLACE INTO `Groups` (`groupId`, `name`, `activity`, `year`, `subjectId`, `classroomId`) VALUES
	(1, 'T1', 'Teoria', 2018, 1, 1),
	(2, 'T2', 'Teoria', 2018, 1, 2),
	(3, 'L1', 'Laboratorio', 2018, 1, 3),
	(4, 'L2', 'Laboratorio', 2018, 1, 1),
	(5, 'L3', 'Laboratorio', 2018, 1, 2),
	(6, 'T1', 'Teoria', 2019, 1, 3),
	(7, 'T2', 'Teoria', 2019, 1, 1),
	(8, 'L1', 'Laboratorio', 2019, 1, 2),
	(9, 'L2', 'Laboratorio', 2019, 1, 3),
	(10, 'Teor1', 'Teoria', 2018, 2, 1),
	(11, 'Teor2', 'Teoria', 2018, 2, 2),
	(12, 'Lab1', 'Laboratorio', 2018, 2, 3),
	(13, 'Lab2', 'Laboratorio', 2018, 2, 1),
	(14, 'Teor1', 'Teoria', 2019, 2, 2),
	(15, 'Lab1', 'Laboratorio', 2019, 2, 3),
	(16, 'Lab2', 'Laboratorio', 2019, 2, 1),
	(17, 'T1', 'Teoria', 2019, 10, 2),
	(18, 'T2', 'Teoria', 2019, 10, 3),
	(19, 'T3', 'Teoria', 2019, 10, 1),
	(20, 'L1', 'Laboratorio', 2019, 10, 2),
	(21, 'L2', 'Laboratorio', 2019, 10, 3),
	(22, 'L3', 'Laboratorio', 2019, 10, 1),
	(23, 'L4', 'Laboratorio', 2019, 10, 2),
	(24, 'Clase', 'Teoria', 2019, 12, 3),
	(25, 'T1', 'Teoria', 2019, 6, 1);
/*!40000 ALTER TABLE `Groups` ENABLE KEYS */;

-- Volcando estructura para tabla grados.GroupsStudents
CREATE TABLE IF NOT EXISTS `GroupsStudents` (
  `groupStudentId` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL,
  `studentId` int(11) NOT NULL,
  PRIMARY KEY (`groupStudentId`),
  UNIQUE KEY `groupId` (`groupId`,`studentId`),
  KEY `studentId` (`studentId`),
  CONSTRAINT `GroupsStudents_ibfk_1` FOREIGN KEY (`groupId`) REFERENCES `Groups` (`groupId`) ON DELETE CASCADE,
  CONSTRAINT `GroupsStudents_ibfk_2` FOREIGN KEY (`studentId`) REFERENCES `Students` (`studentId`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla grados.GroupsStudents: ~13 rows (aproximadamente)
/*!40000 ALTER TABLE `GroupsStudents` DISABLE KEYS */;
REPLACE INTO `GroupsStudents` (`groupStudentId`, `groupId`, `studentId`) VALUES
	(1, 1, 1),
	(13, 1, 9),
	(7, 2, 2),
	(2, 3, 1),
	(8, 3, 2),
	(3, 7, 1),
	(4, 8, 1),
	(5, 10, 1),
	(9, 10, 2),
	(6, 12, 1),
	(10, 12, 2),
	(11, 18, 21),
	(12, 21, 21);
/*!40000 ALTER TABLE `GroupsStudents` ENABLE KEYS */;

-- Volcando estructura para tabla grados.Offices
CREATE TABLE IF NOT EXISTS `Offices` (
  `officeId` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `floor` int(11) NOT NULL,
  `capacity` int(11) NOT NULL,
  PRIMARY KEY (`officeId`),
  UNIQUE KEY `name` (`name`),
  CONSTRAINT `invalidFloor` CHECK (`floor` >= 0),
  CONSTRAINT `invalidCapacity` CHECK (`capacity` > 0)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla grados.Offices: ~2 rows (aproximadamente)
/*!40000 ALTER TABLE `Offices` DISABLE KEYS */;
REPLACE INTO `Offices` (`officeId`, `name`, `floor`, `capacity`) VALUES
	(1, 'F1.85', 1, 5),
	(2, 'F0.45', 0, 3);
/*!40000 ALTER TABLE `Offices` ENABLE KEYS */;

-- Volcando estructura para procedimiento grados.populate
DELIMITER //
CREATE DEFINER=`root`@`%` PROCEDURE `populate`()
BEGIN
	SET FOREIGN_KEY_CHECKS=0;
	DELETE FROM Degrees;
	DELETE FROM Subjects;
	DELETE FROM Groups;
	DELETE FROM Students;
	DELETE FROM GroupsStudents;
	DELETE FROM Grades;
	DELETE FROM Offices;
	DELETE FROM Classrooms;
	DELETE FROM Departments;
	DELETE FROM TutoringHours;
	DELETE FROM TeachingLoads;
	DELETE FROM Appointments;
	DELETE FROM Professors;
	SET FOREIGN_KEY_CHECKS=1;
	ALTER TABLE Degrees AUTO_INCREMENT=1;
	ALTER TABLE Subjects AUTO_INCREMENT=1;
	ALTER TABLE Groups AUTO_INCREMENT=1;
	ALTER TABLE Students AUTO_INCREMENT=1;
	ALTER TABLE GroupsStudents AUTO_INCREMENT=1;
	ALTER TABLE Grades AUTO_INCREMENT=1;
	ALTER TABLE Offices AUTO_INCREMENT=1;
	ALTER TABLE Classrooms AUTO_INCREMENT=1;
	ALTER TABLE Departments AUTO_INCREMENT=1;
	ALTER TABLE TutoringHours AUTO_INCREMENT=1;
	ALTER TABLE TeachingLoads AUTO_INCREMENT=1;
	ALTER TABLE Appointments AUTO_INCREMENT=1;
	ALTER TABLE Professors AUTO_INCREMENT=1;
	
	INSERT INTO Offices (name, floor, capacity) VALUES
		('F1.85', 1, 5),
		('F0.45', 0, 3);
	
	INSERT INTO Classrooms (name, floor, capacity, hasProjector, hasLoudSpeakers) VALUES
		('F1.31', 1, 30, TRUE, FALSE),
		('F1.33', 1, 35, TRUE, FALSE),
		('A0.31', 1, 80, TRUE, TRUE);
	
	INSERT INTO Departments (name) VALUES
		('Lenguajes y Sistemas Informáticos'),
		('Matemáticas');
	
	INSERT INTO Degrees (name, years) VALUES
		('Ingeniería del Software', 4),
		('Ingeniería del Computadores', 4),
		('Tecnologías Informáticas', 4);
	
	INSERT INTO Subjects (name, acronym, credits, course, type, degreeId, departmentId) VALUES
		('Diseño y Pruebas', 'DP', 12, 3, 'Obligatoria', 1, 1),
		('Acceso Inteligente a la Informacion', 'AII', 6, 4, 'Optativa', 1, 1),
		('Optimizacion de Sistemas', 'OS', 6, 4, 'Optativa', 1, 1),
		('Ingeniería de Requisitos', 'IR', 6, 2, 'Obligatoria', 1, 1),
		('Análisis y Diseño de Datos y Algoritmos', 'ADDA', 12, 2, 'Obligatoria', 1, 1),
	-- 5/6
		('Introducción a la Matematica Discreta', 'IMD', 6, 1, 'Formacion Basica', 2, 2),
		('Redes de Computadores', 'RC', 6, 2, 'Obligatoria', 2, 1),
		('Teoría de Grafos', 'TG', 6, 3, 'Obligatoria', 2, 2),
		('Aplicaciones de Soft Computing', 'ASC', 6, 4, 'Optativa', 2, 1),
	-- 9/10
		('Fundamentos de Programación', 'FP', 12, 1, 'Formacion Basica', 3, 1),
		('Lógica Informatica', 'LI', 6, 2, 'Optativa', 3, 2),
		('Gestión y Estrategia Empresarial', 'GEE', 80, 3, 'Optativa', 3, 1),
		('Trabajo de Fin de Grado', 'TFG', 12, 4, 'Obligatoria', 3, 1);
		
	INSERT INTO Groups (name, activity, year, subjectId, classroomId) VALUES
		('T1', 'Teoria', 2018, 1, 1),
		('T2', 'Teoria', 2018, 1, 2),
		('L1', 'Laboratorio', 2018, 1, 3),
		('L2', 'Laboratorio', 2018, 1, 1),
		('L3', 'Laboratorio', 2018, 1, 2),
		('T1', 'Teoria', 2019, 1, 3),
		('T2', 'Teoria', 2019, 1, 1),
		('L1', 'Laboratorio', 2019, 1, 2),
		('L2', 'Laboratorio', 2019, 1, 3),
	-- 9/10
		('Teor1', 'Teoria', 2018, 2, 1),
		('Teor2', 'Teoria', 2018, 2, 2),
		('Lab1', 'Laboratorio', 2018, 2, 3),
		('Lab2', 'Laboratorio', 2018, 2, 1),
		('Teor1', 'Teoria', 2019, 2, 2),
		('Lab1', 'Laboratorio', 2019, 2, 3),
		('Lab2', 'Laboratorio', 2019, 2, 1),
	-- 16/17
		('T1', 'Teoria', 2019, 10, 2),
		('T2', 'Teoria', 2019, 10, 3),
		('T3', 'Teoria', 2019, 10, 1),
		('L1', 'Laboratorio', 2019, 10, 2),
		('L2', 'Laboratorio', 2019, 10, 3),
		('L3', 'Laboratorio', 2019, 10, 1),
		('L4', 'Laboratorio', 2019, 10, 2),
	-- 23/24
		('Clase', 'Teoria', 2019, 12, 3),
		('T1', 'Teoria', 2019, 6, 1);
		
	INSERT INTO Students (accessMethod, dni, firstname, surname, birthdate, email) VALUES
		('Selectividad', '12345678A', 'Daniel', 'Pérez', '1991-01-01', 'daniel@alum.us.es'),
		('Selectividad', '22345678A', 'Rafael', 'Ramírez', '1992-01-01', 'rafael@alum.us.es'),
		('Selectividad', '32345678A', 'Gabriel', 'Hernández', '1993-01-01', 'gabriel@alum.us.es'),
		('Selectividad', '42345678A', 'Manuel', 'Fernández', '1994-01-01', 'manuel@alum.us.es'),
		('Selectividad', '52345678A', 'Joel', 'Gómez', '1995-01-01', 'joel@alum.us.es'),
		('Selectividad', '62345678A', 'Abel', 'López', '1996-01-01', 'abel@alum.us.es'),
		('Selectividad', '72345678A', 'Azael', 'González', '1997-01-01', 'azael@alum.us.es'),
		('Selectividad', '8345678A', 'Uriel', 'Martínez', '1998-01-01', 'uriel@alum.us.es'),
		('Selectividad', '92345678A', 'Gael', 'Sánchez', '1999-01-01', 'gael@alum.us.es'),
		('Titulado Extranjero', '12345678B', 'Noel', 'Álvarez', '1991-02-02', 'noel@alum.us.es'),
		('Titulado Extranjero', '22345678B', 'Ismael', 'Antúnez', '1992-02-02', 'ismael@alum.us.es'),
		('Titulado Extranjero', '32345678B', 'Nathanael', 'Antolinez', '1993-02-02', 'nathanael@alum.us.es'),
		('Titulado Extranjero', '42345678B', 'Ezequiel', 'Aznárez', '1994-02-02', 'ezequiel@alum.us.es'),
		('Titulado Extranjero', '52345678B', 'Ángel', 'Chávez', '1995-02-02', 'angel@alum.us.es'),
		('Titulado Extranjero', '62345678B', 'Matusael', 'Gutiérrez', '1996-02-02', 'matusael@alum.us.es'),
		('Titulado Extranjero', '72345678B', 'Samael', 'Gálvez', '1997-02-02', 'samael@alum.us.es'),
		('Titulado Extranjero', '82345678B', 'Baraquiel', 'Ibáñez', '1998-02-02', 'baraquiel@alum.us.es'),
		('Titulado Extranjero', '92345678B', 'Otoniel', 'Idiáquez', '1999-02-02', 'otoniel@alum.us.es'),
		('Titulado Extranjero', '12345678C', 'Niriel', 'Benítez', '1991-03-03', 'niriel@alum.us.es'),
		('Titulado Extranjero', '22345678C', 'Múriel', 'Bermúdez', '1992-03-03', 'muriel@alum.us.es'),
		('Titulado Extranjero', '32345678C', 'John', 'AII', '2000-01-01', 'john@alum.us.es');
		
	INSERT INTO GroupsStudents (groupId, studentId) VALUES
		(1, 1),
		(3, 1),
		(7, 1),
		(8, 1),
		(10, 1),
		(12, 1),
	-- 6/7
		(2, 2),
		(3, 2),
		(10, 2),
		(12, 2),
	-- 10/11
		(18, 21),
		(21, 21),
	-- 12/13
		(1, 9);
		
	INSERT INTO Grades (value, gradeCall, withHonours, studentId, groupId) VALUES
		(4.50, 1, 0, 1, 1),
		(3.25, 2, 0, 1, 1),
		(9.95, 1, 0, 1, 7),
		(7.5, 1, 0, 1, 10),
	-- 4/5
		(2.50, 1, 0, 2, 2),
		(5.00, 2, 0, 2, 2),
		(10.00, 1, 1, 2, 10),
	-- 7/8
		(0.00, 1, 0, 21, 18),
		(1.25, 2, 0, 21, 18),
		(0.5, 3, 0, 21, 18);
	
	INSERT INTO Professors (officeId, departmentId, category, dni, firstname, surname, birthdate, email) VALUES
		(1, 1, 'PAD', '42345678C', 'Fernando', 'Ramírez', '1960-05-02', 'fernando@us.es'),
		(1, 1, 'TU', '52345678C', 'David', 'Zuir', '1902-01-01', 'dzuir@us.es'),
		(1, 1, 'TU', '62345678C', 'Antonio', 'Zuir', '1902-01-01', 'azuir@us.es'),
		(1, 2, 'CU', '72345678C', 'Rafael', 'Gómez', '1959-12-12', 'rdgomez@us.es'),
		(2, 1, 'TU', '82345678C', 'Inma', 'Hernández', '1234-5-6', 'inmahrdz@us.es');
	
	INSERT INTO TutoringHours (professorId, dayOfWeek, startHour, endHour) VALUES
		(1, 0, '12:00:00', '14:00:00'),
		(1, 1, '18:00:00', '19:00:00'),
		(1, 1, '11:30:00', '12:30:00'),
		(2, 2, '10:00:00', '20:00:00');
	
	INSERT INTO Appointments (tutoringHoursId, studentId, hour, date) VALUES
		(1, 1, '13:00:00', '2019-11-18'),
		(2, 2, '18:20:00', '2019-11-19'),
		(4, 1, '15:00:00', '2019-11-20');
	
	INSERT INTO TeachingLoads (professorId, groupId, credits) VALUES
		(1, 1, 6),
		(2, 1, 12),
		(1, 2, 6),
		(1, 3, 12);
END//
DELIMITER ;

-- Volcando estructura para procedimiento grados.procedureCreateTeachingLoad
DELIMITER //
CREATE DEFINER=`root`@`%` PROCEDURE `procedureCreateTeachingLoad`(professorId INT, groupId INT, credits INT)
BEGIN
	INSERT INTO TeachingLoads(professorId, groupId, credits) VALUES (professorId, groupId, credits);
END//
DELIMITER ;

-- Volcando estructura para procedimiento grados.procedureDeleteGrades
DELIMITER //
CREATE DEFINER=`root`@`%` PROCEDURE `procedureDeleteGrades`(studentDni CHAR(9))
BEGIN
	DECLARE id INT;
	SET id = (SELECT studentId FROM Students WHERE dni=studentDni);
	DELETE FROM Grades WHERE studentId=id;
END//
DELIMITER ;

-- Volcando estructura para procedimiento grados.procedureGetAppointments
DELIMITER //
CREATE DEFINER=`root`@`%` PROCEDURE `procedureGetAppointments`(professorId INT, dayOfWeek INT)
BEGIN
	SELECT * FROM
	TutoringHours JOIN Appointments ON (TutoringHours.tutoringHoursId = Appointments.tutoringHoursId)
	JOIN Students ON (Appointments.studentId = Students.studentId)
	WHERE TutoringHours.professorId=professorId AND TutoringHours.dayOfWeek=dayOfWeek;
END//
DELIMITER ;

-- Volcando estructura para tabla grados.Professors
CREATE TABLE IF NOT EXISTS `Professors` (
  `professorId` int(11) NOT NULL AUTO_INCREMENT,
  `officeId` int(11) NOT NULL,
  `departmentId` int(11) NOT NULL,
  `category` varchar(5) NOT NULL,
  `dni` char(9) NOT NULL,
  `firstName` varchar(100) NOT NULL,
  `surname` varchar(100) NOT NULL,
  `birthDate` date NOT NULL,
  `email` varchar(250) NOT NULL,
  PRIMARY KEY (`professorId`),
  UNIQUE KEY `dni` (`dni`),
  UNIQUE KEY `email` (`email`),
  KEY `officeId` (`officeId`),
  KEY `departmentId` (`departmentId`),
  CONSTRAINT `Professors_ibfk_1` FOREIGN KEY (`officeId`) REFERENCES `Offices` (`officeId`),
  CONSTRAINT `Professors_ibfk_2` FOREIGN KEY (`departmentId`) REFERENCES `Departments` (`departmentId`),
  CONSTRAINT `invalidCategory` CHECK (`category` in ('CU','TU','PCD','PAD'))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla grados.Professors: ~5 rows (aproximadamente)
/*!40000 ALTER TABLE `Professors` DISABLE KEYS */;
REPLACE INTO `Professors` (`professorId`, `officeId`, `departmentId`, `category`, `dni`, `firstName`, `surname`, `birthDate`, `email`) VALUES
	(1, 1, 1, 'PAD', '42345678C', 'Fernando', 'Ramírez', '1960-05-02', 'fernando@us.es'),
	(2, 1, 1, 'TU', '52345678C', 'David', 'Zuir', '1902-01-01', 'dzuir@us.es'),
	(3, 1, 1, 'TU', '62345678C', 'Antonio', 'Zuir', '1902-01-01', 'azuir@us.es'),
	(4, 1, 2, 'CU', '72345678C', 'Rafael', 'Gómez', '1959-12-12', 'rdgomez@us.es'),
	(5, 2, 1, 'TU', '82345678C', 'Inma', 'Hernández', '1234-05-06', 'inmahrdz@us.es');
/*!40000 ALTER TABLE `Professors` ENABLE KEYS */;

-- Volcando estructura para vista grados.ProfessorsTeachingLoads
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `ProfessorsTeachingLoads` (
	`professorId` INT(11) NOT NULL,
	`firstName` VARCHAR(100) NOT NULL COLLATE 'latin1_swedish_ci',
	`surname` VARCHAR(100) NOT NULL COLLATE 'latin1_swedish_ci',
	`year` INT(11) NOT NULL,
	`credits` DECIMAL(32,0) NULL
) ENGINE=MyISAM;

-- Volcando estructura para tabla grados.Students
CREATE TABLE IF NOT EXISTS `Students` (
  `studentId` int(11) NOT NULL AUTO_INCREMENT,
  `accessMethod` varchar(30) NOT NULL,
  `dni` char(9) NOT NULL,
  `firstName` varchar(100) NOT NULL,
  `surname` varchar(100) NOT NULL,
  `birthDate` date NOT NULL,
  `email` varchar(250) NOT NULL,
  PRIMARY KEY (`studentId`),
  UNIQUE KEY `dni` (`dni`),
  UNIQUE KEY `email` (`email`),
  CONSTRAINT `invalidStudentAccessMethod` CHECK (`accessMethod` in ('Selectividad','Ciclo','Mayor','Titulado Extranjero'))
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla grados.Students: ~21 rows (aproximadamente)
/*!40000 ALTER TABLE `Students` DISABLE KEYS */;
REPLACE INTO `Students` (`studentId`, `accessMethod`, `dni`, `firstName`, `surname`, `birthDate`, `email`) VALUES
	(1, 'Selectividad', '12345678A', 'Daniel', 'Pérez', '1991-01-01', 'daniel@alum.us.es'),
	(2, 'Selectividad', '22345678A', 'Rafael', 'Ramírez', '1992-01-01', 'rafael@alum.us.es'),
	(3, 'Selectividad', '32345678A', 'Gabriel', 'Hernández', '1993-01-01', 'gabriel@alum.us.es'),
	(4, 'Selectividad', '42345678A', 'Manuel', 'Fernández', '1994-01-01', 'manuel@alum.us.es'),
	(5, 'Selectividad', '52345678A', 'Joel', 'Gómez', '1995-01-01', 'joel@alum.us.es'),
	(6, 'Selectividad', '62345678A', 'Abel', 'López', '1996-01-01', 'abel@alum.us.es'),
	(7, 'Selectividad', '72345678A', 'Azael', 'González', '1997-01-01', 'azael@alum.us.es'),
	(8, 'Selectividad', '8345678A', 'Uriel', 'Martínez', '1998-01-01', 'uriel@alum.us.es'),
	(9, 'Selectividad', '92345678A', 'Gael', 'Sánchez', '1999-01-01', 'gael@alum.us.es'),
	(10, 'Titulado Extranjero', '12345678B', 'Noel', 'Álvarez', '1991-02-02', 'noel@alum.us.es'),
	(11, 'Titulado Extranjero', '22345678B', 'Ismael', 'Antúnez', '1992-02-02', 'ismael@alum.us.es'),
	(12, 'Titulado Extranjero', '32345678B', 'Nathanael', 'Antolinez', '1993-02-02', 'nathanael@alum.us.es'),
	(13, 'Titulado Extranjero', '42345678B', 'Ezequiel', 'Aznárez', '1994-02-02', 'ezequiel@alum.us.es'),
	(14, 'Titulado Extranjero', '52345678B', 'Ángel', 'Chávez', '1995-02-02', 'angel@alum.us.es'),
	(15, 'Titulado Extranjero', '62345678B', 'Matusael', 'Gutiérrez', '1996-02-02', 'matusael@alum.us.es'),
	(16, 'Titulado Extranjero', '72345678B', 'Samael', 'Gálvez', '1997-02-02', 'samael@alum.us.es'),
	(17, 'Titulado Extranjero', '82345678B', 'Baraquiel', 'Ibáñez', '1998-02-02', 'baraquiel@alum.us.es'),
	(18, 'Titulado Extranjero', '92345678B', 'Otoniel', 'Idiáquez', '1999-02-02', 'otoniel@alum.us.es'),
	(19, 'Titulado Extranjero', '12345678C', 'Niriel', 'Benítez', '1991-03-03', 'niriel@alum.us.es'),
	(20, 'Titulado Extranjero', '22345678C', 'Múriel', 'Bermúdez', '1992-03-03', 'muriel@alum.us.es'),
	(21, 'Titulado Extranjero', '32345678C', 'John', 'AII', '2000-01-01', 'john@alum.us.es');
/*!40000 ALTER TABLE `Students` ENABLE KEYS */;

-- Volcando estructura para tabla grados.Subjects
CREATE TABLE IF NOT EXISTS `Subjects` (
  `subjectId` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `acronym` varchar(8) NOT NULL,
  `credits` int(11) NOT NULL,
  `course` int(11) NOT NULL,
  `type` varchar(20) NOT NULL,
  `degreeId` int(11) NOT NULL,
  `departmentId` int(11) NOT NULL,
  PRIMARY KEY (`subjectId`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `acronym` (`acronym`),
  KEY `degreeId` (`degreeId`),
  KEY `departmentId` (`departmentId`),
  CONSTRAINT `Subjects_ibfk_1` FOREIGN KEY (`degreeId`) REFERENCES `Degrees` (`degreeId`),
  CONSTRAINT `Subjects_ibfk_2` FOREIGN KEY (`departmentId`) REFERENCES `Departments` (`departmentId`),
  CONSTRAINT `negativeSubjectCredits` CHECK (`credits` > 0),
  CONSTRAINT `invalidSubjectCourse` CHECK (`course` > 0 and `course` < 6),
  CONSTRAINT `invalidSubjectType` CHECK (`type` in ('Formacion Basica','Optativa','Obligatoria'))
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla grados.Subjects: ~13 rows (aproximadamente)
/*!40000 ALTER TABLE `Subjects` DISABLE KEYS */;
REPLACE INTO `Subjects` (`subjectId`, `name`, `acronym`, `credits`, `course`, `type`, `degreeId`, `departmentId`) VALUES
	(1, 'Diseño y Pruebas', 'DP', 12, 3, 'Obligatoria', 1, 1),
	(2, 'Acceso Inteligente a la Informacion', 'AII', 6, 4, 'Optativa', 1, 1),
	(3, 'Optimizacion de Sistemas', 'OS', 6, 4, 'Optativa', 1, 1),
	(4, 'Ingeniería de Requisitos', 'IR', 6, 2, 'Obligatoria', 1, 1),
	(5, 'Análisis y Diseño de Datos y Algoritmos', 'ADDA', 12, 2, 'Obligatoria', 1, 1),
	(6, 'Introducción a la Matematica Discreta', 'IMD', 6, 1, 'Formacion Basica', 2, 2),
	(7, 'Redes de Computadores', 'RC', 6, 2, 'Obligatoria', 2, 1),
	(8, 'Teoría de Grafos', 'TG', 6, 3, 'Obligatoria', 2, 2),
	(9, 'Aplicaciones de Soft Computing', 'ASC', 6, 4, 'Optativa', 2, 1),
	(10, 'Fundamentos de Programación', 'FP', 12, 1, 'Formacion Basica', 3, 1),
	(11, 'Lógica Informatica', 'LI', 6, 2, 'Optativa', 3, 2),
	(12, 'Gestión y Estrategia Empresarial', 'GEE', 80, 3, 'Optativa', 3, 1),
	(13, 'Trabajo de Fin de Grado', 'TFG', 12, 4, 'Obligatoria', 3, 1);
/*!40000 ALTER TABLE `Subjects` ENABLE KEYS */;

-- Volcando estructura para tabla grados.TeachingLoads
CREATE TABLE IF NOT EXISTS `TeachingLoads` (
  `teachingLoadId` int(11) NOT NULL AUTO_INCREMENT,
  `professorId` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `credits` int(11) NOT NULL,
  PRIMARY KEY (`teachingLoadId`),
  KEY `professorId` (`professorId`),
  KEY `groupId` (`groupId`),
  CONSTRAINT `TeachingLoads_ibfk_1` FOREIGN KEY (`professorId`) REFERENCES `Professors` (`professorId`),
  CONSTRAINT `TeachingLoads_ibfk_2` FOREIGN KEY (`groupId`) REFERENCES `Groups` (`groupId`),
  CONSTRAINT `invalidCredits` CHECK (`credits` > 0)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla grados.TeachingLoads: ~4 rows (aproximadamente)
/*!40000 ALTER TABLE `TeachingLoads` DISABLE KEYS */;
REPLACE INTO `TeachingLoads` (`teachingLoadId`, `professorId`, `groupId`, `credits`) VALUES
	(1, 1, 1, 6),
	(2, 2, 1, 12),
	(3, 1, 2, 6),
	(4, 1, 3, 12);
/*!40000 ALTER TABLE `TeachingLoads` ENABLE KEYS */;

-- Volcando estructura para tabla grados.TutoringHours
CREATE TABLE IF NOT EXISTS `TutoringHours` (
  `tutoringHoursId` int(11) NOT NULL AUTO_INCREMENT,
  `professorId` int(11) NOT NULL,
  `dayOfWeek` int(11) NOT NULL,
  `startHour` time DEFAULT NULL,
  `endHour` time DEFAULT NULL,
  PRIMARY KEY (`tutoringHoursId`),
  KEY `professorId` (`professorId`),
  CONSTRAINT `TutoringHours_ibfk_1` FOREIGN KEY (`professorId`) REFERENCES `Professors` (`professorId`),
  CONSTRAINT `invalidDayOfWeek` CHECK (`dayOfWeek` >= 0 and `dayOfWeek` <= 6)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla grados.TutoringHours: ~4 rows (aproximadamente)
/*!40000 ALTER TABLE `TutoringHours` DISABLE KEYS */;
REPLACE INTO `TutoringHours` (`tutoringHoursId`, `professorId`, `dayOfWeek`, `startHour`, `endHour`) VALUES
	(1, 1, 0, '12:00:00', '14:00:00'),
	(2, 1, 1, '18:00:00', '19:00:00'),
	(3, 1, 1, '11:30:00', '12:30:00'),
	(4, 2, 2, '10:00:00', '20:00:00');
/*!40000 ALTER TABLE `TutoringHours` ENABLE KEYS */;

-- Volcando estructura para vista grados.ViewOldStudents
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `ViewOldStudents` (
	`studentId` INT(11) NOT NULL,
	`accessMethod` VARCHAR(30) NOT NULL COLLATE 'latin1_swedish_ci',
	`dni` CHAR(9) NOT NULL COLLATE 'latin1_swedish_ci',
	`firstName` VARCHAR(100) NOT NULL COLLATE 'latin1_swedish_ci',
	`surname` VARCHAR(100) NOT NULL COLLATE 'latin1_swedish_ci',
	`birthDate` DATE NOT NULL,
	`email` VARCHAR(250) NOT NULL COLLATE 'latin1_swedish_ci'
) ENGINE=MyISAM;

-- Volcando estructura para vista grados.ViewStudentsList
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `ViewStudentsList` (
	`firstName` VARCHAR(100) NOT NULL COLLATE 'latin1_swedish_ci',
	`surname` VARCHAR(100) NOT NULL COLLATE 'latin1_swedish_ci',
	`subject` VARCHAR(100) NULL COLLATE 'latin1_swedish_ci',
	`groupName` VARCHAR(30) NULL COLLATE 'latin1_swedish_ci'
) ENGINE=MyISAM;

-- Volcando estructura para vista grados.ViewSubjectsSoft2018
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `ViewSubjectsSoft2018` (
	`name` VARCHAR(100) NOT NULL COLLATE 'latin1_swedish_ci',
	`acronym` VARCHAR(8) NOT NULL COLLATE 'latin1_swedish_ci',
	`credits` INT(11) NOT NULL,
	`type` VARCHAR(20) NOT NULL COLLATE 'latin1_swedish_ci'
) ENGINE=MyISAM;

-- Volcando estructura para disparador grados.triggerConsistentDepartment
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `triggerConsistentDepartment` BEFORE INSERT ON `TeachingLoads` FOR EACH ROW BEGIN
	DECLARE professorDepartment INT;
	DECLARE subjectDepartment INT;
	SET professorDepartment = (SELECT departmentId 
										FROM Professors
										WHERE Professors.professorId = new.professorId);
	SET subjectDepartment = (SELECT departmentId 
										FROM Groups JOIN Subjects ON (Groups.subjectId = Subjects.subjectId)
										WHERE Groups.groupId = new.groupId);
	IF(professorDepartment != subjectDepartment) THEN
		SIGNAL SQLSTATE '45000' SET message_text = 
				'Un profesor no puede dar asignaturas fueras de su departamento';
	END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador grados.triggergGradeStudentGroup
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `triggergGradeStudentGroup` BEFORE INSERT ON `Grades` FOR EACH ROW BEGIN
	DECLARE isInGroup INT;
	SET isInGroup = (SELECT COUNT(*) 
						FROM GroupsStudents
						WHERE studentId = new.studentId AND groupId = new.groupId);
	IF(isInGroup < 1) THEN
		SIGNAL SQLSTATE '45000' SET message_text = 
		'Un alumno no puede tener notas en grupos a los que no pertenece';
	END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador grados.triggerGradesChangeDifference
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `triggerGradesChangeDifference` BEFORE UPDATE ON `Grades` FOR EACH ROW BEGIN
	DECLARE difference DECIMAL(4,2);
	DECLARE student ROW TYPE OF Students;
	SET difference = new.value - old.value;
	IF(difference > 4) THEN
		SELECT * INTO student FROM Students WHERE studentId = new.studentId;
		SET @error_message = CONCAT('Al alumno ', student.firstName, ' ', student.surname, 
				 ' se le ha intentado subir una nota en ', difference, ' puntos');
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_message;
	END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador grados.triggerMaximumTeachingLoad
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `triggerMaximumTeachingLoad` BEFORE INSERT ON `TeachingLoads` FOR EACH ROW BEGIN
	DECLARE groupYear INT;
	DECLARE currentCredits INT;
	SET groupYear = (SELECT year FROM Groups WHERE groupId = new.groupId);
	SET currentCredits = (SELECT SUM(credits) 
								FROM TeachingLoads JOIN Groups ON (TeachingLoads.groupId = Groups.groupId)
								WHERE professorId = new.professorId AND year=groupYear);
	IF((currentCredits+new.credits) > 25) THEN
		SIGNAL SQLSTATE '45000' SET message_text = 
				'Un profesor no puede tener más de 25 créditos de docencia en un año';
	END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador grados.triggerUniqueGradesSubject
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `triggerUniqueGradesSubject` BEFORE INSERT ON `Grades` FOR EACH ROW BEGIN
	DECLARE subject INT; -- La asignatura en la que se inserta la nota
	DECLARE groupYear INT; -- El año al que corresponde
	DECLARE subjectGrades INT; -- Conteo de notas de la misma asignatura/alumno/año/convocatoria
	SELECT subjectId, year INTO subject, groupYear FROM Groups WHERE groupId = new.groupId;
	SET subjectGrades = (SELECT COUNT(*) 
					FROM Grades, Groups
					WHERE (Grades.studentId = new.studentId AND -- Mismo estudiante
							 Grades.gradeCall = new.gradeCall AND -- Misma convocatoria
							 Grades.groupId = Groups.groupId AND 
							 Groups.year = groupYear AND -- Mismo año
							 Groups.subjectId = subject)); -- Misma asignatura
	IF(subjectGrades > 0) THEN
		SIGNAL SQLSTATE '45000' SET message_text = 
		'Un alumno no puede tener varias notas asociadas a la misma \r\n\t\tasignatura en la misma convocatoria, el mismo año';
	END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador grados.triggerValidAge
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `triggerValidAge` BEFORE INSERT ON `Students` FOR EACH ROW BEGIN
	IF (new.accessMethod='Selectividad' AND (YEAR(CURDATE()) - YEAR(new.birthdate) < 16)) THEN
		SIGNAL SQLSTATE '45000' SET message_text = 
		'Para entrar por selectividad hay que tener más de 16 años';
	END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador grados.triggerValidTutoringAppointment
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `triggerValidTutoringAppointment` BEFORE INSERT ON `Appointments` FOR EACH ROW BEGIN
	DECLARE startHour TIME;
	DECLARE endHour TIME;
	DECLARE weekDay INT;
	SELECT TutoringHours.startHour, TutoringHours.endHour, dayOfWeek INTO startHour, endHour, weekDay
		FROM TutoringHours
		WHERE TutoringHours.tutoringHoursId = new.tutoringHoursId;
	IF (new.hour < startHour OR new.hour > endHour OR WEEKDAY(new.date)!=weekDay) THEN
		SIGNAL SQLSTATE '45000' SET message_text = 
				'Las citas de tutoría deben ser consistentes con el horario';
	END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador grados.triggerWithHonours
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `triggerWithHonours` BEFORE INSERT ON `Grades` FOR EACH ROW BEGIN
	IF (new.withHonours = 1 AND new.value < 9.0) THEN
		SIGNAL SQLSTATE '45000' SET message_text = 
		'Para obtener matrícula hay que sacar al menos un 9';
	END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para vista grados.ProfessorsTeachingLoads
-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `ProfessorsTeachingLoads`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `ProfessorsTeachingLoads` AS select `Professors`.`professorId` AS `professorId`,`Professors`.`firstName` AS `firstName`,`Professors`.`surname` AS `surname`,`Groups`.`year` AS `year`,sum(`TeachingLoads`.`credits`) AS `credits` from ((`Professors` join `TeachingLoads` on(`Professors`.`professorId` = `TeachingLoads`.`professorId`)) join `Groups` on(`TeachingLoads`.`groupId` = `Groups`.`groupId`)) group by `Professors`.`professorId`,`Groups`.`year`;

-- Volcando estructura para vista grados.ViewOldStudents
-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `ViewOldStudents`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `ViewOldStudents` AS select `Students`.`studentId` AS `studentId`,`Students`.`accessMethod` AS `accessMethod`,`Students`.`dni` AS `dni`,`Students`.`firstName` AS `firstName`,`Students`.`surname` AS `surname`,`Students`.`birthDate` AS `birthDate`,`Students`.`email` AS `email` from `Students` where `Students`.`accessMethod` = 'Mayor';

-- Volcando estructura para vista grados.ViewStudentsList
-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `ViewStudentsList`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `ViewStudentsList` AS select `Students`.`firstName` AS `firstName`,`Students`.`surname` AS `surname`,`Subjects`.`name` AS `subject`,`Groups`.`name` AS `groupName` from (((`Students` left join `GroupsStudents` on(`Students`.`studentId` = `GroupsStudents`.`studentId`)) left join `Groups` on(`GroupsStudents`.`groupId` = `Groups`.`groupId`)) left join `Subjects` on(`Groups`.`subjectId` = `Subjects`.`subjectId`)) order by `Students`.`firstName`;

-- Volcando estructura para vista grados.ViewSubjectsSoft2018
-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `ViewSubjectsSoft2018`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `ViewSubjectsSoft2018` AS select `Subjects`.`name` AS `name`,`Subjects`.`acronym` AS `acronym`,`Subjects`.`credits` AS `credits`,`Subjects`.`type` AS `type` from `Subjects` where `Subjects`.`degreeId` = 1 and (select count(0) from `Groups` where `Groups`.`year` = 2018 and `Groups`.`subjectId` = `Subjects`.`subjectId`) > 0 order by `Subjects`.`acronym`;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
