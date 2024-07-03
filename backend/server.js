const express = require('express');
const bodyParser = require('body-parser');
const dotenv = require('dotenv');
const connectDB = require('./db');
const authRouter = require('./routers/authRouter');
const bidRouter = require('./routers/bidRouter');
const rideRouter = require('./routers/rideRouter');
const paymentRouter = require('./routers/paymentRouter');

dotenv.config();

// Connect to the database
connectDB();

const app = express();

// Middleware
app.use(bodyParser.json());

// Routes
app.use('/auth', authRouter);
app.use('/bid', bidRouter);
app.use('/ride', rideRouter);
app.use('/payment', paymentRouter);

// Start the server
const port = process.env.PORT || 5000;
app.listen(port, () => console.log(`Server running on port ${port}`));
