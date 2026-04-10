const User = require('../models/User');

// @route   GET /user/profile
// @desc    Get user profile
const getProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user._id);
    if (user) {
      res.json(user);
    } else {
      res.status(404).json({ message: 'User not found' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @route   PUT /user/update-profile
// @desc    Update user profile & KYC details
const updateProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user._id);

    if (user) {
      user.name = req.body.name || user.name;
      user.email = req.body.email || user.email;
      user.dob = req.body.dob || user.dob;
      user.panNumber = req.body.panNumber || user.panNumber;
      user.aadhaarNumber = req.body.aadhaarNumber || user.aadhaarNumber;

      if (req.body.nominee) {
        user.nominee = { ...user.nominee, ...req.body.nominee };
      }

      // Automatically change KYC status to submitted if PAN/Aadhaar are updated
      if (user.panNumber && user.aadhaarNumber && user.kycStatus === 'pending') {
        user.kycStatus = 'submitted';
      }

      const updatedUser = await user.save();
      res.json(updatedUser);
    } else {
      res.status(404).json({ message: 'User not found' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @route   POST /user/upload-doc
// @desc    Upload KYC documents (Mock implementation)
const uploadDoc = async (req, res) => {
  // In a real app, this would use multer and AWS S3/Cloudinary
  try {
    const user = await User.findById(req.user._id);
    if (!user) return res.status(404).json({ message: 'User not found' });

    user.kycStatus = 'verified'; // Mock auto-verification for demo
    await user.save();

    res.json({ message: 'Document uploaded successfully', kycStatus: user.kycStatus });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  getProfile,
  updateProfile,
  uploadDoc,
};
