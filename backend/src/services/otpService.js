const generateOTP = () => {
  // Generate a random 6-digit OTP
  return Math.floor(100000 + Math.random() * 900000).toString();
};

const sendOTPSMS = async (mobile, otp) => {
  // In a real app, integrate Twilio, AWS SNS, or MSG91 here.
  // For development, we just log it.
  console.log(`[MOCK SMS] Sending OTP ${otp} to mobile ${mobile}`);
  return true;
};

module.exports = { generateOTP, sendOTPSMS };
