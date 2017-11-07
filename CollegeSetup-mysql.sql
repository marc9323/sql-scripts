DROP VIEW  IF EXISTS SectionsView;
DROP TABLE IF EXISTS Sections;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Instructors;
DROP TABLE IF EXISTS Rooms;

CREATE TABLE Instructors 
(
	InstructorId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	LastName VARCHAR(30) NOT NULL,
	FirstName VARCHAR(30) NOT NULL
);

ALTER TABLE Instructors
	ADD CONSTRAINT ucInstructors_Name  UNIQUE (LastName, FirstName);

CREATE TABLE Courses
(
	CourseId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    CourseNbr VARCHAR(10) NOT NULL,
	CourseDesc VARCHAR(50) NOT NULL,
	CreditHours DECIMAL(2,1)
);

ALTER TABLE Courses
	ADD CONSTRAINT ucCourses_CourseNbr  UNIQUE (CourseNbr);

CREATE TABLE Rooms
(
	RoomNbr VARCHAR(8) PRIMARY KEY,
    SeatsInRoom INT,
    ProjectorFlag VARCHAR(1)    -- 0 or 1    
);


CREATE TABLE Sections
(
	SectionId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,    
    CourseId INT NOT NULL,
    SectionNbr VARCHAR(5) NOT NULL,
    InstructorId INT NOT NULL,
    RoomNbr VARCHAR(8),
    MaxStudents INT,
    StartDate DATE,
    EndDate DATE,
    ProjectorNeededFlag VARCHAR(1),   -- 0 or 1
    ClassType VARCHAR(3),              -- STD, ONL, or HYB
    Registered INT
);

ALTER TABLE Sections
	ADD CONSTRAINT ucSections_Number  UNIQUE (CourseId, SectionNbr);

ALTER TABLE Sections 
	ADD CONSTRAINT fkSections_Courses
	FOREIGN KEY (CourseId) 
	REFERENCES Courses (CourseId);

ALTER TABLE Sections 
	ADD CONSTRAINT fkSections_Rooms
	FOREIGN KEY (RoomNbr) 
	REFERENCES Rooms (RoomNbr);

ALTER TABLE Sections 
	ADD CONSTRAINT fkSections_Instructors
	FOREIGN KEY (InstructorId) 
	REFERENCES Instructors (InstructorId);    

INSERT INTO Rooms 
     SELECT * 
       FROM cis2360.Rooms;

INSERT INTO Instructors 
     SELECT * 
       FROM cis2360.Instructors;

INSERT INTO Courses 
     SELECT * 
       FROM cis2360.Courses;

INSERT INTO Sections 
     SELECT * 
       FROM cis2360.Sections;

CREATE VIEW SectionsView AS       
    SELECT s.SectionId,
           s.CourseId,
           c.CourseNbr,
           c.CourseDesc,
           c.CreditHours,
           s.SectionNbr,
           s.InstructorId,
           i.LastName,
           i.FirstName,
           s.RoomNbr,
           r.SeatsInRoom,
           r.ProjectorFlag,     
           s.MaxStudents,
           s.StartDate,
           s.EndDate,
           s.ProjectorNeededFlag,
           s.ClassType,
           s.Registered
      FROM Sections AS s
INNER JOIN Instructors AS i
        ON s.InstructorId = i.InstructorId
INNER JOIN Rooms AS r
        ON s.RoomNbr = r.RoomNbr
INNER JOIN Courses AS c
        ON s.CourseId = c.CourseId;       
