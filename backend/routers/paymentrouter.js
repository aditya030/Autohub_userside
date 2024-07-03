const express = require('express');
const router = express.Router();
const paymentController = require('../controllers/paymentController');

// Route to process payment
router.post('/process-payment', paymentController.processPayment);

// Route to update payment status
router.post('/update-status', paymentController.updateStatus);

module.exports = router;
