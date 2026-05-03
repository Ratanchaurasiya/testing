const express = require('express');
const router = express.Router();
const attendanceController = require('../controllers/attendanceController');
const auth = require('../middleware/auth');

// All attendance routes should be protected
router.use(auth);

router.get('/', attendanceController.getAttendanceByDate);
router.post('/mark', attendanceController.markAttendance);
router.get('/student/:student_id', attendanceController.getStudentAttendance);

module.exports = router;
