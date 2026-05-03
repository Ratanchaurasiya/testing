import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import MainLayout from './components/MainLayout';
import StudentLayout from './components/StudentLayout';
import Dashboard from './pages/Dashboard';
import Login from './pages/Login';
import Students from './pages/Students';
import Attendance from './pages/Attendance';
import Courses from './pages/Courses';
import Fees from './pages/Fees';
import Marks from './pages/Marks';
import StudentDashboard from './pages/student/StudentDashboard';
import StudentCertificates from './pages/student/StudentCertificates';
import StudentProfile from './pages/student/StudentProfile';

const ProtectedRoute = ({ children, allowedRole }) => {
  const token = localStorage.getItem('token');
  const user = JSON.parse(localStorage.getItem('user') || '{}');

  if (!token) {
    return <Navigate to="/login" replace />;
  }

  if (allowedRole && user.role !== allowedRole) {
    return <Navigate to={user.role === 'Student' ? '/student/dashboard' : '/dashboard'} replace />;
  }

  return children;
};

const App = () => {
  return (
    <Router>
      <Routes>
        <Route path="/login" element={<Login />} />
        
        {/* Admin Routes */}
        <Route element={<ProtectedRoute allowedRole="Admin"><MainLayout /></ProtectedRoute>}>
          <Route path="/" element={<Navigate to="/dashboard" replace />} />
          <Route path="/dashboard" element={<Dashboard />} />
          <Route path="/students" element={<Students />} />
          <Route path="/courses" element={<Courses />} />
          <Route path="/attendance" element={<Attendance />} />
          <Route path="/fees" element={<Fees />} />
          <Route path="/marks" element={<Marks />} />
        </Route>

        {/* Student Routes */}
        <Route element={<ProtectedRoute allowedRole="Student"><StudentLayout /></ProtectedRoute>}>
          <Route path="/student" element={<Navigate to="/student/dashboard" replace />} />
          <Route path="/student/dashboard" element={<StudentDashboard />} />
          <Route path="/student/certificates" element={<StudentCertificates />} />
          <Route path="/student/profile" element={<StudentProfile />} />
        </Route>
      </Routes>
    </Router>
  );
};

export default App;
