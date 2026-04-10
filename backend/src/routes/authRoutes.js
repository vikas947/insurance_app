const express = require('express');
const router = express.Router();
const {
  sendOtp,
  verifyOtp,
  loginEmail,
  socialLogin,
} = require('../controllers/authController');

router.post('/send-otp', sendOtp);
router.post('/verify-otp', verifyOtp);
router.post('/login-email', loginEmail);
router.post('/social-login', socialLogin);

module.exports = router;
