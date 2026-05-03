import { Outlet, Link, useNavigate } from 'react-router-dom';
import '../assets/css/dashboard.css';

const Sidebar = () => {
  return (
    <div className="sidebar" style={{ backgroundColor: '#1a365d' }}> {/* Different color to distinguish Student Portal */}
      <div className="sidebar-header">
        <div className="sidebar-logo">Student Portal</div>
      </div>
      <ul className="nav-menu">
        <li>
          <Link to="/student/dashboard" className="nav-item">
            <span className="nav-icon">🎓</span> My Dashboard
          </Link>
        </li>
        <li>
          <Link to="/student/certificates" className="nav-item">
            <span className="nav-icon">📜</span> Certificates
          </Link>
        </li>
        <li>
          <Link to="/student/profile" className="nav-item">
            <span className="nav-icon">👤</span> My Profile
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
          <div className="user-avatar" style={{ backgroundColor: '#1a365d' }}>{user?.username?.charAt(0) || 'S'}</div>
          <div>
            <strong>{user?.username || 'Student User'}</strong>
            <div style={{ fontSize: '0.8rem', color: 'var(--text-secondary)' }}>Role: {user?.role || 'Student'}</div>
          </div>
        </div>
        <button onClick={handleLogout} className="btn btn-danger" style={{ padding: '0.25rem 0.5rem', fontSize: '0.8rem' }}>Logout</button>
      </div>
    </nav>
  );
};

const StudentLayout = () => {
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

export default StudentLayout;
