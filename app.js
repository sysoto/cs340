// =====================================================
// Citation for starter code used in this project:
// Date Retrieved: 02/11/2026
// Adapted from: CS340 NodeJS Starter Application
// Type: Source code (starter application)
// Author: Oregon State University
// Source: CS340 Course Materials (Canvas)
// Description: Basic Express server setup and Handlebars configuration
// were adapted from the provided starter application. Mods made from starter code.
// All database routes and entity pages were developed by the project team.
// =====================================================


// ########################################
// ########## SETUP

const express = require('express');
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = 1213;

// Database
const db = require('./database/db-connector');

// Handlebars
const { engine } = require('express-handlebars');
app.engine('.hbs', engine({ extname: '.hbs' }));
app.set('view engine', '.hbs');


// ########################################
// ########## ROUTES


// HOME
app.get('/', async function (req, res) {
    res.render('home');
});



// STUDENTS

// Browse Students
app.get('/students', async function (req, res) {
    const [students] = await db.query('SELECT * FROM Students;');
    res.render('students', { students: students });
});

// Add Student
app.post('/students/add', async function (req, res) {
    const { firstName, lastName, email, enrollmentStatus } = req.body;

    await db.query(
        'INSERT INTO Students (firstName, lastName, email, enrollmentStatus) VALUES (?, ?, ?, ?);',
        [firstName, lastName, email, enrollmentStatus]
    );

    res.redirect('/students');
});

// Delete Student
app.post('/students/delete', async function (req, res) {
    const { studentID } = req.body;

    await db.query(
        'DELETE FROM Students WHERE studentID = ?;',
        [studentID]
    );

    res.redirect('/students');
});

// Update Student
app.post('/students/update', async function (req, res) {
    const { studentID, email, enrollmentStatus } = req.body;

    await db.query(
        'UPDATE Students SET email = ?, enrollmentStatus = ? WHERE studentID = ?;',
        [email, enrollmentStatus, studentID]
    );

    res.redirect('/students');
});



// COURSES

app.get('/courses', async function (req, res) {
    const [courses] = await db.query('SELECT * FROM Courses;');
    res.render('courses', { courses: courses });
});



// INSTRUCTORS

app.get('/instructors', async function (req, res) {
    const [instructors] = await db.query('SELECT * FROM Instructors;');
    res.render('instructors', { instructors: instructors });
});



// SECTIONS

app.get('/sections', async function (req, res) {
    const [sections] = await db.query('SELECT * FROM Sections;');
    res.render('sections', { sections: sections });
});



// ENROLLMENTS (M:N)

// Browse Enrollments with JOIN for readable student name
app.get('/enrollments', async function (req, res) {

    const [enrollments] = await db.query(`
        SELECT 
            Enrollments.enrollmentID,
            CONCAT(Students.firstName, ' ', Students.lastName) AS studentName,
            Enrollments.sectionID,
            Enrollments.enrollmentDate,
            Enrollments.enrollmentStatus
        FROM Enrollments
        JOIN Students ON Enrollments.studentID = Students.studentID
        JOIN Sections ON Enrollments.sectionID = Sections.sectionID;
    `);

    const [students] = await db.query('SELECT * FROM Students;');
    const [sections] = await db.query('SELECT * FROM Sections;');

    res.render('enrollments', {
        enrollments: enrollments,
        students: students,
        sections: sections
    });
});

// Add Enrollment (M:N INSERT)
app.post('/enrollments/add', async function (req, res) {
    const { studentID, sectionID, enrollmentDate, enrollmentStatus } = req.body;

    await db.query(
        'INSERT INTO Enrollments (studentID, sectionID, enrollmentDate, enrollmentStatus) VALUES (?, ?, ?, ?);',
        [studentID, sectionID, enrollmentDate, enrollmentStatus]
    );

    res.redirect('/enrollments');
});

// Update Enrollment (M:N UPDATE)
app.post('/enrollments/update', async function (req, res) {
    const { enrollmentID, sectionID } = req.body;

    await db.query(
        'UPDATE Enrollments SET sectionID = ? WHERE enrollmentID = ?;',
        [sectionID, enrollmentID]
    );

    res.redirect('/enrollments');
});


// ########################################
// ########## LISTENER

app.listen(PORT, function () {
    console.log(
        'Express started on http://classwork.engr.oregonstate.edu:' +
        PORT +
        '; press Ctrl-C to terminate.'
    );
});
