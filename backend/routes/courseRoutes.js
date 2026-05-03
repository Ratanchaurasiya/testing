const express = require('express');
const router = express.Router();
const courseController = require('../controllers/courseController');
const auth = require('../middleware/auth');

router.use(auth);
router.get('/', courseController.getAllCourses);
router.post('/', courseController.createCourse);

module.exports = router;
