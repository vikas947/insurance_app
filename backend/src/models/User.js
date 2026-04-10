const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      trim: true,
    },
    email: {
      type: String,
      unique: true,
      sparse: true, // allows null/undefined values but unique if present
      trim: true,
      lowercase: true,
    },
    mobile: {
      type: String,
      unique: true,
      sparse: true,
    },
    password: {
      type: String,
    },
    loginType: {
      type: String,
      enum: ['mobile', 'email', 'google', 'facebook'],
      required: true,
    },
    isVerified: {
      type: Boolean,
      default: false,
    },
    // KYC and Onboarding details
    dob: {
      type: Date,
    },
    panNumber: {
      type: String,
      uppercase: true,
      trim: true,
    },
    aadhaarNumber: {
      type: String,
      trim: true,
    },
    kycStatus: {
      type: String,
      enum: ['pending', 'submitted', 'verified', 'rejected'],
      default: 'pending',
    },
    nominee: {
      name: String,
      relation: String,
      dob: Date,
    },
    // OTP Management
    otp: String,
    otpExpires: Date,
    otpAttempts: {
      type: Number,
      default: 0,
    },
  },
  {
    timestamps: true,
  }
);

// Method to verify password
userSchema.methods.matchPassword = async function (enteredPassword) {
  if (!this.password) return false;
  return await bcrypt.compare(enteredPassword, this.password);
};

// Pre-save hook to hash password
userSchema.pre('save', async function (next) {
  if (!this.isModified('password')) {
    next();
  }
  if (this.password) {
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
  }
});

const User = mongoose.model('User', userSchema);

module.exports = User;
