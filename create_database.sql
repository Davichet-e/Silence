DROP TABLE IF EXISTS Grades;
DROP TABLE IF EXISTS GroupsStudents;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Groups;
DROP TABLE IF EXISTS Subjects;
DROP TABLE IF EXISTS Degrees;

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
	PRIMARY KEY (subjectId),
	FOREIGN KEY (degreeId) REFERENCES Degrees (degreeId),
	CONSTRAINT negativeSubjectCredits CHECK (credits > 0),
	CONSTRAINT invalidSubjectCourse CHECK (course > 0 AND course < 6),
	CONSTRAINT invalidSubjectType CHECK (type IN ('Formacion Basica', 'Optativa', 'Obligatoria'))
);

CREATE TABLE Groups(
	groupId INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(30) NOT NULL,
	activity VARCHAR(20) NOT NULL,
	year INT NOT NULL,
	subjectId INT NOT NULL,
	PRIMARY KEY (groupId),
	FOREIGN KEY (subjectId) REFERENCES Subjects (subjectId),
	UNIQUE (name, year, subjectId),
	CONSTRAINT negativeGroupYear CHECK (year > 0),
	CONSTRAINT invalidGroupActivity CHECK (activity IN ('Teoria', 'Laboratorio'))
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
	CONSTRAINT invalidStudentAccessMethod CHECK (accessMethod IN ('Selectividad', 'Ciclo', 'Mayor', 'Titulado Extranjero'))
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

INSERT INTO Degrees (name, years) VALUES
	('Ingeniería del Software', 4),
	('Ingeniería del Computadores', 4),
	('Tecnologías Informáticas', 4);

INSERT INTO Subjects (name, acronym, credits, course, type, degreeId) VALUES
	('Diseño y Pruebas', 'DP', 12, 3, 'Obligatoria', 1),
	('Acceso Inteligente a la Informacion', 'AII', 6, 4, 'Optativa', 1),
	('Optimizacion de Sistemas', 'OS', 6, 4, 'Optativa', 1),
	('Ingeniería de Requisitos', 'IR', 6, 2, 'Obligatoria', 1),
	('Análisis y Diseño de Datos y Algoritmos', 'ADDA', 12, 2, 'Obligatoria', 1),
	('Introducción a la Matematica Discreta', 'IMD', 6, 1, 'Formacion Basica', 2),
	('Redes de Computadores', 'RC', 6, 2, 'Obligatoria', 2),
	('Teoría de Grafos', 'TG', 6, 3, 'Obligatoria', 2),
	('Aplicaciones de Soft Computing', 'ASC', 6, 4, 'Optativa', 2),
	('Fundamentos de Programación', 'FP', 12, 1, 'Formacion Basica', 3),
	('Lógica Informatica', 'LI', 6, 2, 'Optativa', 3),
	('Gestión y Estrategia Empresarial', 'GEE', 80, 3, 'Optativa', 3),
	('Trabajo de Fin de Grado', 'TFG', 12, 4, 'Obligatoria', 3);
	
INSERT INTO Groups (name, activity, year, subjectId) VALUES
	('T1', 'Teoria', 2018, 1),
	('T2', 'Teoria', 2018, 1),
	('L1', 'Laboratorio', 2018, 1),
	('L2', 'Laboratorio', 2018, 1),
	('L3', 'Laboratorio', 2018, 1),
	('T1', 'Teoria', 2019, 1),
	('T2', 'Teoria', 2019, 1),
	('L1', 'Laboratorio', 2019, 1),
	('L2', 'Laboratorio', 2019, 1),
	('Teor1', 'Teoria', 2018, 2),
	('Teor2', 'Teoria', 2018, 2),
	('Lab1', 'Laboratorio', 2018, 2),
	('Lab2', 'Laboratorio', 2018, 2),
	('Teor1', 'Teoria', 2019, 2),
	('Lab1', 'Laboratorio', 2019, 2),
	('Lab2', 'Laboratorio', 2019, 2),
	('T1', 'Teoria', 2019, 10),
	('T2', 'Teoria', 2019, 10),
	('T3', 'Teoria', 2019, 10),
	('L1', 'Laboratorio', 2019, 10),
	('L2', 'Laboratorio', 2019, 10),
	('L3', 'Laboratorio', 2019, 10),
	('L4', 'Laboratorio', 2019, 10),
	('Clase', 'Teoria', 2019, 12);
	
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
	(2, 2),
	(3, 2),
	(10, 2),
	(12, 2),
	(18, 21),
	(21, 21);
	
INSERT INTO Grades (value, gradeCall, withHonours, studentId, groupId) VALUES
	(4.50, 1, 0, 1, 1),
	(3.25, 2, 0, 1, 1),
	(9.95, 1, 0, 1, 7),
	(7.5, 1, 0, 1, 10),
	(2.50, 1, 0, 2, 2),
	(5.00, 2, 0, 2, 2),
	(10.00, 1, 1, 2, 10),
	(0.00, 1, 0, 21, 18),
	(1.25, 2, 0, 21, 18),
	(0.5, 3, 0, 21, 18);