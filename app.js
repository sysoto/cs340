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
app.get('/students', async function (req, res) {
    const [students] = await db.query('SELECT * FROM Students;');
    res.render('students', { students: students });
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

// ENROLLMENTS
app.get('/enrollments', async function (req, res) {
    const [enrollments] = await db.query('SELECT * FROM Enrollments;');
    res.render('enrollments', { enrollments: enrollments });
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
