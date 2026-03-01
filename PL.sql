-- Reset
DROP PROCEDURE IF EXISTS sp_ResetDatabase;
DELIMITER //

CREATE PROCEDURE sp_ResetDatabase()
BEGIN

    SET FOREIGN_KEY_CHECKS = 0;
    SET AUTOCOMMIT = 0;
    START TRANSACTION;

    DROP TABLE IF EXISTS Enrollments;
    DROP TABLE IF EXISTS Sections;
    DROP TABLE IF EXISTS Students;
    DROP TABLE IF EXISTS Instructors;
    DROP TABLE IF EXISTS Courses;

    CREATE TABLE Students (
        studentID INT AUTO_INCREMENT,
        firstName VARCHAR(50) NOT NULL,
        lastName VARCHAR(50) NOT NULL,
        email VARCHAR(100) NOT NULL,
        enrollmentStatus VARCHAR(20) NOT NULL,
        PRIMARY KEY (studentID),
        UNIQUE (email)
    ) ENGINE=InnoDB;

    CREATE TABLE Courses (
        courseID INT AUTO_INCREMENT,
        courseCode VARCHAR(20) NOT NULL,
        courseTitle VARCHAR(100) NOT NULL,
        creditHours INT NOT NULL,
        departmentName VARCHAR(100) NOT NULL,
        PRIMARY KEY (courseID)
    ) ENGINE=InnoDB;

    CREATE TABLE Instructors (
        instructorID INT AUTO_INCREMENT,
        instructorName VARCHAR(100) NOT NULL,
        email VARCHAR(100) NOT NULL,
        employmentType VARCHAR(30) NOT NULL,
        PRIMARY KEY (instructorID),
        UNIQUE (email)
    ) ENGINE=InnoDB;

    CREATE TABLE Sections (
        sectionID INT AUTO_INCREMENT,
        courseID INT NOT NULL,
        instructorID INT NOT NULL,
        termLabel VARCHAR(20) NOT NULL,
        meetingDays VARCHAR(20) NOT NULL,
        startTime TIME NOT NULL,
        endTime TIME NOT NULL,
        capacityLimit INT NOT NULL,
        PRIMARY KEY (sectionID),
        FOREIGN KEY (courseID)
        REFERENCES Courses(courseID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        FOREIGN KEY (instructorID)
        REFERENCES Instructors(instructorID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
    ) ENGINE=InnoDB;

    CREATE TABLE Enrollments (
        enrollmentID INT AUTO_INCREMENT,
        studentID INT NOT NULL,
        sectionID INT NOT NULL,
        enrollmentDate DATE NOT NULL,
        enrollmentStatus VARCHAR(20) NOT NULL,
        PRIMARY KEY (enrollmentID),
        UNIQUE (studentID, sectionID),
        FOREIGN KEY (studentID)
        REFERENCES Students(studentID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
        FOREIGN KEY (sectionID)
        REFERENCES Sections(sectionID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
    ) ENGINE=InnoDB;


    INSERT INTO Students (studentID, firstName, lastName, email, enrollmentStatus) VALUES
    (1, 'Stan', 'Marsh', 'stan@uni.edu', 'active'),
    (2, 'Eric', 'Cartman', 'eric@uni.edu', 'active'),
    (3, 'Kyle', 'Broflovski', 'kyle@uni.edu', 'inactive');


    INSERT INTO Courses (courseID, courseCode, courseTitle, creditHours, departmentName) VALUES
    (1, 'CS340', 'Databases', 4, 'Computer Science'),
    (2, 'CS361', 'Software Eng I', 4, 'Computer Science'),
    (3, 'CS271', 'Computer Architecture', 4, 'Computer Science');


    INSERT INTO Instructors (instructorID, instructorName, email, employmentType) VALUES
    (1, 'Dr Garrison', 'garrison@uni.edu', 'full-time'),
    (2, 'Dr Mackey', 'mackey@uni.edu', 'adjunct'),
    (3, 'Dr Barbrady', 'barbrady@uni.edu', 'adjunct');


    INSERT INTO Sections (sectionID, courseID, instructorID, termLabel, meetingDays, startTime, endTime, capacityLimit) VALUES
    (1, 1, 1, 'Fall 2025', 'MWF', '10:00', '10:50', 30),
    (2, 2, 2, 'Fall 2025', 'TR', '13:00', '14:50', 25),
    (3, 3, 1, 'Fall 2025', 'MWF', '09:00', '09:50', 35);


    INSERT INTO Enrollments (enrollmentID, studentID, sectionID, enrollmentDate, enrollmentStatus) VALUES
    (1, 1, 1, '2025-08-20', 'enrolled'),
    (2, 2, 1, '2025-08-21', 'withdrawn'),
    (3, 1, 2, '2025-08-22', 'enrolled');

    SET FOREIGN_KEY_CHECKS = 1;
    COMMIT;

END //

DELIMITER ;

-- Insert

DROP PROCEDURE IF EXISTS sp_InsertStudent;
DELIMITER //

CREATE PROCEDURE sp_InsertStudent(
    IN p_firstName VARCHAR(50),
    IN p_lastName VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_enrollmentStatus VARCHAR(20)
)
BEGIN
    INSERT INTO Students (firstName, lastName, email, enrollmentStatus)
    VALUES (p_firstName, p_lastName, p_email, p_enrollmentStatus);
END //

DELIMITER ;

-- Update

DROP PROCEDURE IF EXISTS sp_UpdateStudent;
DELIMITER //

CREATE PROCEDURE sp_UpdateStudent(
    IN p_studentID INT,
    IN p_email VARCHAR(100),
    IN p_enrollmentStatus VARCHAR(20)
)
BEGIN
    UPDATE Students
    SET email = p_email,
        enrollmentStatus = p_enrollmentStatus
    WHERE studentID = p_studentID;
END //

DELIMITER ;

-- Delete

DROP PROCEDURE IF EXISTS sp_DeleteStudent;
DELIMITER //

CREATE PROCEDURE sp_DeleteStudent(IN p_studentID INT)
BEGIN
    DELETE FROM Students
    WHERE studentID = p_studentID;
END //

DELIMITER ;

-- Insert Enrollment

DROP PROCEDURE IF EXISTS sp_InsertEnrollment;
DELIMITER //

CREATE PROCEDURE sp_InsertEnrollment(
    IN p_studentID INT,
    IN p_sectionID INT,
    IN p_enrollmentDate DATE,
    IN p_enrollmentStatus VARCHAR(20)
)
BEGIN
    INSERT INTO Enrollments (studentID, sectionID, enrollmentDate, enrollmentStatus)
    VALUES (p_studentID, p_sectionID, p_enrollmentDate, p_enrollmentStatus);
END //

DELIMITER ;

-- Update Enrollment

DROP PROCEDURE IF EXISTS sp_UpdateEnrollment;
DELIMITER //

CREATE PROCEDURE sp_UpdateEnrollment(
    IN p_enrollmentID INT,
    IN p_sectionID INT
)
BEGIN
    UPDATE Enrollments
    SET sectionID = p_sectionID
    WHERE enrollmentID = p_enrollmentID;
END //

DELIMITER ;
