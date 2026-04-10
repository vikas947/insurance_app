const mongoose = require('mongoose');

const policySchema = new mongoose.Schema(
  {
    type: {
      type: String,
      required: true,
      enum: ['Health', 'Life', 'Motor', 'Home', 'Travel'],
    },
    name: {
      type: String,
      required: true,
    },
    provider: {
      type: String,
      required: true,
    },
    premium: {
      type: Number,
      required: true,
    },
    coverageAmount: {
      type: Number,
      required: true,
    },
    description: {
      type: String,
    },
    benefits: [String],
    // For active policies belonging to a user
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
    },
    status: {
      type: String,
      enum: ['Active', 'Expired', 'Pending', 'Cancelled'],
      default: 'Active',
    },
    startDate: Date,
    endDate: Date,
    documentUrl: String,
  },
  {
    timestamps: true,
  }
);

const Policy = mongoose.model('Policy', policySchema);

module.exports = Policy;
