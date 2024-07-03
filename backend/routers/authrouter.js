const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

// Route for user signup
router.post('/signup', authController.signup);

// Route for user login
router.post('/login', authController.login);

// Route to send OTP
router.post('/send-otp', authController.sendOtp);

// Route to verify OTP
router.post('/verify-otp', authController.verifyOtp);

module.exports = router;
