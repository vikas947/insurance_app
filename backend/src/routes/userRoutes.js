const express = require('express');
const router = express.Router();
const { getProfile, updateProfile, uploadDoc } = require('../controllers/userController');
const { protect } = require('../middlewares/authMiddleware');

router.route('/profile')
  .get(protect, getProfile);

router.route('/update-profile')
  .put(protect, updateProfile);

router.route('/upload-doc')
  .post(protect, uploadDoc);

module.exports = router;
