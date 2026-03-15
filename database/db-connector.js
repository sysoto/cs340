// =====================================================
// Citation:
// Date Retrieved: 02/11/2026
// Adapted from: CS340 NodeJS Starter Application (Canvas)
// Author: Oregon State University
//
// MySQL2 Documentation Referenced:
// https://github.com/sidorares/node-mysql2
// =====================================================

// Get an instance of mysql we can use in the app
let mysql = require('mysql2')

// Create a 'connection pool' using the provided credentials
const pool = mysql.createPool({
    waitForConnections: true,
    connectionLimit: 10,
    host: 'classmysql.engr.oregonstate.edu',
    user: 'cs340_username',
    password: 'yourpassword',
    database: 'cs340_username'
}).promise(); // This makes it so we can use async / await rather than callbacks

// Export it for use in our application
module.exports = pool;
