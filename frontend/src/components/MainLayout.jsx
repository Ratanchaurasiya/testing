import { Outlet, Link, useNavigate } from 'react-router-dom';
import '../assets/css/dashboard.css';

const Sidebar = () => {
  return (
    <div className="sidebar">
      <div className="sidebar-header">
        <div className="sidebar-logo">SMS Admin</div>
      </div>
      <ul className="nav-menu">
        <li>
          <Link to="/dashboard" className="nav-item active">
            <span className="nav-icon">📊</span> Dashboard
          </Link>
        </li>
        <li>
          <Link to="/students" className="nav-item">
            <span className="nav-icon">👥</span> Students
          </Link>
        </li>
        <li>
          <Link to="/courses" className="nav-item">
            <span className="nav-icon">📚</span> Courses
          </Link>
        </li>
        <li>
          <Link to="/attendance" className="nav-item">
            <span className="nav-icon">✅</span> Attendance
          </Link>
        </li>
        <li>
          <Link to="/marks" className="nav-item">
            <span className="nav-icon">📊</span> Student Marks
          </Link>
        </li>
        <li>
          <Link to="/fees" className="nav-item">
            <span className="nav-icon">💰</span> Fees Management
          </Link>
        </li>
      </ul>
    </div>
  );
};

const Navbar = () => {
  const navigate = useNavigate();
  const user = JSON.parse(localStorage.getItem('user') || '{}');

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    navigate('/login');
  };

  return (
    <nav className="navbar">
      <button className="menu-toggle">☰</button>
      <div className="user-profile" style={{ display: 'flex', gap: '1rem', alignItems: 'center' }}>
        <div style={{ display: 'flex', alignItems: 'center' }}>
          <div className="user-avatar">{user?.username?.charAt(0) || 'A'}</div>
          <div>
            <strong>{user?.username || 'Admin User'}</strong>
            <div style={{ fontSize: '0.8rem', color: 'var(--text-secondary)' }}>Role: {user?.role || 'Admin'}</div>
          </div>
        </div>
        <button onClick={handleLogout} className="btn btn-danger" style={{ padding: '0.25rem 0.5rem', fontSize: '0.8rem' }}>Logout</button>
      </div>
    </nav>
  );
};

const MainLayout = () => {
  return (
    <div className="app-container">
      <Sidebar />
      <div className="main-wrapper">
        <Navbar />
        <main className="page-content">
          <Outlet />
        </main>
      </div>
    </div>
  );
};

export default MainLayout;
