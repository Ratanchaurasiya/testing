import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import MainLayout from './components/MainLayout';
import StudentLayout from './components/StudentLayout';
import Dashboard from './pages/Dashboard';
import Login from './pages/Login';
import Students from './pages/Students';
import Attendance from './pages/Attendance';
import StudentDashboard from './pages/student/StudentDashboard';
import StudentCertificates from './pages/student/StudentCertificates';

const ProtectedRoute = ({ children, allowedRole }) => {
  const token = localStorage.getItem('token');
  const user = JSON.parse(localStorage.getItem('user') || '{}');

  if (!token) {
    return <Navigate to="/login" replace />;
  }

  // Simplified role check (in a real app, robust check needed)
  if (allowedRole && user.role !== allowedRole) {
    // Redirect to appropriate dashboard based on actual role
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
          <Route path="/courses" element={<div><div className="page-header"><h1 className="page-title">Courses Management</h1></div><div className="card">Courses List Placeholder</div></div>} />
          <Route path="/attendance" element={<Attendance />} />
          <Route path="/fees" element={<div><div className="page-header"><h1 className="page-title">Fee Management</h1></div><div className="card">Fees Placeholder</div></div>} />
        </Route>

        {/* Student Routes */}
        <Route element={<ProtectedRoute allowedRole="Student"><StudentLayout /></ProtectedRoute>}>
          <Route path="/student" element={<Navigate to="/student/dashboard" replace />} />
          <Route path="/student/dashboard" element={<StudentDashboard />} />
          <Route path="/student/certificates" element={<StudentCertificates />} />
          <Route path="/student/profile" element={<div><div className="page-header"><h1 className="page-title">My Profile</h1></div><div className="card">Profile details will appear here.</div></div>} />
        </Route>
      </Routes>
    </Router>
  );
};

export default App;
