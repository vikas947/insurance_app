const express = require('express');
const router = express.Router();
const {
  getUserPolicies,
  getRecommendations,
  getPolicyById,
  buyPolicy,
} = require('../controllers/policyController');
const { protect } = require('../middlewares/authMiddleware');

router.route('/')
  .get(protect, getUserPolicies);

router.route('/recommendations')
  .get(protect, getRecommendations);

router.route('/buy')
  .post(protect, buyPolicy);

router.route('/:id')
  .get(protect, getPolicyById);

module.exports = router;
