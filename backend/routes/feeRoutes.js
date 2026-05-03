const express = require('express');
const router = express.Router();
const feeController = require('../controllers/feeController');
const auth = require('../middleware/auth');

router.use(auth);
router.get('/', feeController.getAllFees);
router.put('/:id', feeController.updateFee);

module.exports = router;
