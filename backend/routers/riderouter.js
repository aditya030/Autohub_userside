const express = require('express');
const router = express.Router();
const rideController = require('../controllers/rideController');

// Route for home page after login
router.get('/home', rideController.home);

// Route to get ride details
router.get('/ride/:rideId', rideController.getRideDetails);

// Route to update ride status
router.post('/update-status', rideController.updateStatus);

module.exports = router;
