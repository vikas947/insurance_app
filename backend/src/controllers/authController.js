const User = require('../models/User');
const { generateToken } = require('../services/jwtService');
const { generateOTP, sendOTPSMS } = require('../services/otpService');

// @route   POST /auth/send-otp
// @desc    Send OTP to mobile number
const sendOtp = async (req, res) => {
  const { mobile } = req.body;
  if (!mobile) return res.status(400).json({ message: 'Mobile number is required' });

  try {
    let user = await User.findOne({ mobile });
    const otp = generateOTP();
    const otpExpires = new Date(Date.now() + 10 * 60 * 1000); // 10 minutes

    if (!user) {
      // Create new user flow
      user = await User.create({
        mobile,
        loginType: 'mobile',
        otp,
        otpExpires,
        otpAttempts: 0,
      });
    } else {
      // Update existing user
      // Edge case check: Too many OTP attempts
      if (user.otpAttempts >= 5 && user.otpExpires > new Date()) {
        return res.status(429).json({ message: 'Too many attempts. Please try again later.' });
      }

      user.otp = otp;
      user.otpExpires = otpExpires;
      user.otpAttempts += 1;
      await user.save();
    }

    await sendOTPSMS(mobile, otp);

    res.status(200).json({ message: 'OTP sent successfully', isNewUser: !user.isVerified });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @route   POST /auth/verify-otp
// @desc    Verify OTP
const verifyOtp = async (req, res) => {
  const { mobile, otp } = req.body;
  if (!mobile || !otp) return res.status(400).json({ message: 'Mobile and OTP required' });

  try {
    const user = await User.findOne({ mobile });
    if (!user) return res.status(404).json({ message: 'User not found' });

    // Edge cases: Invalid/Expired OTP
    if (user.otp !== otp) {
      return res.status(400).json({ message: 'Invalid OTP' });
    }
    if (user.otpExpires < new Date()) {
      return res.status(400).json({ message: 'OTP has expired' });
    }

    // Success
    user.isVerified = true;
    user.otp = undefined;
    user.otpExpires = undefined;
    user.otpAttempts = 0;
    await user.save();

    res.status(200).json({
      _id: user._id,
      name: user.name,
      mobile: user.mobile,
      isVerified: user.isVerified,
      token: generateToken(user._id),
      isNewUser: user.kycStatus === 'pending',
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @route   POST /auth/login-email
// @desc    Login with email and password
const loginEmail = async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) return res.status(400).json({ message: 'Email and password required' });

  try {
    const user = await User.findOne({ email });
    if (user && (await user.matchPassword(password))) {
      res.status(200).json({
        _id: user._id,
        name: user.name,
        email: user.email,
        isVerified: user.isVerified,
        token: generateToken(user._id),
        isNewUser: user.kycStatus === 'pending',
      });
    } else {
      res.status(401).json({ message: 'Invalid email or password' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @route   POST /auth/social-login
// @desc    Login/Signup with Google or Facebook
const socialLogin = async (req, res) => {
  const { email, name, providerId, loginType } = req.body; // loginType: 'google' | 'facebook'

  try {
    let user = await User.findOne({ email });

    if (!user) {
      user = await User.create({
        email,
        name,
        loginType,
        isVerified: true,
      });
    }

    res.status(200).json({
      _id: user._id,
      name: user.name,
      email: user.email,
      isVerified: user.isVerified,
      token: generateToken(user._id),
      isNewUser: user.kycStatus === 'pending',
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  sendOtp,
  verifyOtp,
  loginEmail,
  socialLogin,
};
