const express = require('express');
const cors = require('cors');
const cookieParser = require('cookie-parser');
require('dotenv').config();
const connectDB = require('./config/db');
const router = require('./routes');
const bodyParser = require('body-parser');

const app = express();

// CORS configuration
app.use(cors({
    origin: process.env.FRONTEND_URL,
    credentials: true
}));

// Middleware to parse JSON bodies
app.use(express.json());

// Middleware to parse cookies
app.use(cookieParser());

// Increase the limit for incoming requests
app.use(bodyParser.json({ limit: '150mb' })); // Adjust the size as needed
app.use(bodyParser.urlencoded({ limit: '50mb', extended: true }));

// Use the router for API routes
app.use("/api", router);

// Basic route for server check
app.get('/', (req, res) => {
    res.send('Successfully Back-End Code Is Running.....');
});

// Port configuration
const PORT = process.env.PORT || 5000;

// Connect to the database and start the server
connectDB().then(() => {
    app.listen(PORT, () => {
        // console.log("Successfully Connected To Database...");
        console.log(`Server is running on port ${PORT}`);
    });
});
