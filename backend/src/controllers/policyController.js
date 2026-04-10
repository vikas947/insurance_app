const Policy = require('../models/Policy');

// Mock data initialization
const MOCK_RECOMMENDATIONS = [
  {
    type: 'Health',
    name: 'Comprehensive Family Health Plus',
    provider: 'SecureLife Insurance',
    premium: 500,
    coverageAmount: 1000000,
    description: 'All around health coverage for you and your family.',
    benefits: ['Cashless Treatment', 'Maternity Cover', 'No Room Rent Cap'],
  },
  {
    type: 'Life',
    name: 'Term Shield 1CR',
    provider: 'TermMax',
    premium: 1200,
    coverageAmount: 10000000,
    description: 'Pure protection term plan with high coverage.',
    benefits: ['Return of Premium', 'Critical Illness Rider', 'Tax Benefits'],
  },
  {
    type: 'Motor',
    name: 'Car Secure Pro',
    provider: 'AutoSafe',
    premium: 8000,
    coverageAmount: 500000,
    description: 'Comprehensive motor insurance with zero depreciation.',
    benefits: ['Zero Dep Cover', 'Engine Protection', 'Roadside Assistance'],
  }
];

// @route   GET /policies
// @desc    Get user's active policies
const getUserPolicies = async (req, res) => {
  try {
    const policies = await Policy.find({ user: req.user._id });
    res.json(policies);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @route   GET /policies/recommendations
// @desc    Get recommended policies to buy
const getRecommendations = async (req, res) => {
  try {
    // In a real app, this would query a dynamic catalog or ML model
    res.json(MOCK_RECOMMENDATIONS);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @route   GET /policy/:id
// @desc    Get specific policy details
const getPolicyById = async (req, res) => {
  try {
    const policy = await Policy.findById(req.params.id);
    if (!policy) return res.status(404).json({ message: 'Policy not found' });
    
    // Ensure the policy belongs to the user
    if (policy.user.toString() !== req.user._id.toString()) {
      return res.status(403).json({ message: 'Not authorized to view this policy' });
    }

    res.json(policy);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @route   POST /policy/buy
// @desc    Buy a new policy
const buyPolicy = async (req, res) => {
  const { type, name, provider, premium, coverageAmount } = req.body;

  try {
    const newPolicy = await Policy.create({
      type,
      name,
      provider,
      premium,
      coverageAmount,
      user: req.user._id,
      status: 'Active',
      startDate: new Date(),
      endDate: new Date(new Date().setFullYear(new Date().getFullYear() + 1)), // 1 year expiry
    });

    res.status(201).json(newPolicy);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  getUserPolicies,
  getRecommendations,
  getPolicyById,
  buyPolicy,
};
