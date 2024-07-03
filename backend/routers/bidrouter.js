const express = require('express');
const router = express.Router();
const bidController = require('../controllers/bidController');

// Route to create a new bid
router.post('/create-bid', bidController.createBid);

// Route to get bids for a ride
router.get('/bids/:rideId', bidController.getBids);

// Route to select the minimum bid
router.post('/select-bid', bidController.selectBid);

module.exports = router;
