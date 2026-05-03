const express = require('express');
const router = express.Router();
const markController = require('../controllers/markController');
const auth = require('../middleware/auth');

router.use(auth);
router.post('/', markController.saveMarks);
router.get('/', markController.getStudentResults);

module.exports = router;
