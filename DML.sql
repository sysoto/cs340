
-- DELETE Student

DELETE FROM Students 
WHERE studentID = @studentIDInput;

-- DELETE Enrollment (M:N)


DELETE FROM Enrollments
WHERE studentID = @studentIDInput
AND sectionID = @sectionIDInput;


-- UPDATE Enrollment (M:N)

UPDATE Enrollments
SET enrollmentDate = @dateInput,
    enrollmentStatus = @statusInput
WHERE enrollmentID = @enrollmentIDInput;


-- UPDATE Student

UPDATE Students
SET email = @emailInput,
    enrollmentStatus = @statusInput
WHERE studentID = @studentIDInput;


-- INSERT Student

INSERT INTO Students (firstName, lastName, email, enrollmentStatus)
VALUES (@firstNameInput, @lastNameInput, @emailInput, @statusInput);


-- INSERT Enrollment (M:N)

INSERT INTO Enrollments (studentID, sectionID, enrollmentDate, enrollmentStatus)
VALUES (@studentIDInput, @sectionIDInput, @dateInput, @statusInput);


-- SELECT Students

SELECT * FROM Students;


-- SELECT Enrollments with JOIN

SELECT 
    e.enrollmentID,
    CONCAT(s.firstName, ' ', s.lastName) AS studentName,
    e.sectionID,
    e.enrollmentDate,
    e.enrollmentStatus
FROM Enrollments e
JOIN Students s ON e.studentID = s.studentID
JOIN Sections sec ON e.sectionID = sec.sectionID;


-- SELECT Courses

SELECT * FROM Courses;


-- SELECT Instructors

SELECT * FROM Instructors;


-- SELECT Sections

SELECT * FROM Sections;
