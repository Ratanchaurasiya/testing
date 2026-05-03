import { useState, useEffect } from 'react';
import axios from 'axios';

const StudentProfile = () => {
  const [profile, setProfile] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchProfile();
  }, []);

  const fetchProfile = async () => {
    try {
      const user = JSON.parse(localStorage.getItem('user') || '{}');
      const token = localStorage.getItem('token');
      const config = token ? { headers: { Authorization: `Bearer ${token}` } } : {};
      
      // Fetch student details using the logged in user's ID
      const res = await axios.get(`http://localhost:5000/api/students/${user.id}`, config);
      if (res.data.status === 'success') {
        setProfile(res.data.data);
      }
    } catch (err) {
      console.error('Failed to fetch profile', err);
      // Fallback dummy data
      setProfile({
        first_name: 'Rahul',
        last_name: 'Sharma',
        email: 'rahul@example.com',
        phone: '9876543210',
        student_roll_no: 'STU001',
        dob: '2005-05-15',
        gender: 'Male',
        address: '123, Model Town',
        city: 'Delhi',
        status: 'Active'
      });
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <div className="p-4">Loading profile...</div>;
  if (!profile) return <div className="p-4">Profile not found.</div>;

  return (
    <div>
      <div className="page-header">
        <h1 className="page-title">My Personal Profile</h1>
      </div>

      <div className="card" style={{ maxWidth: '800px', margin: '0 auto' }}>
        <div style={{ display: 'flex', gap: '2rem', alignItems: 'center', marginBottom: '2rem', borderBottom: '1px solid #eee', paddingBottom: '1rem' }}>
          <div style={{ width: '100px', height: '100px', borderRadius: '50%', backgroundColor: 'var(--primary-color)', color: 'white', display: 'flex', justifyContent: 'center', alignItems: 'center', fontSize: '2.5rem', fontWeight: 'bold' }}>
            {profile.first_name[0]}{profile.last_name[0]}
          </div>
          <div>
            <h2 style={{ fontSize: '1.8rem', color: 'var(--secondary-color)' }}>{profile.first_name} {profile.last_name}</h2>
            <p style={{ color: 'var(--text-light)' }}>Roll No: {profile.student_roll_no}</p>
            <span className={`status-badge status-${profile.status.toLowerCase()}`}>{profile.status}</span>
          </div>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '2rem' }}>
          <div>
            <label style={{ fontWeight: 'bold', color: 'var(--primary-color)', display: 'block', fontSize: '0.9rem' }}>EMAIL ADDRESS</label>
            <p style={{ marginBottom: '1.5rem', fontSize: '1.1rem' }}>{profile.email}</p>
            
            <label style={{ fontWeight: 'bold', color: 'var(--primary-color)', display: 'block', fontSize: '0.9rem' }}>PHONE NUMBER</label>
            <p style={{ marginBottom: '1.5rem', fontSize: '1.1rem' }}>{profile.phone || 'Not provided'}</p>
            
            <label style={{ fontWeight: 'bold', color: 'var(--primary-color)', display: 'block', fontSize: '0.9rem' }}>DATE OF BIRTH</label>
            <p style={{ marginBottom: '1.5rem', fontSize: '1.1rem' }}>{profile.dob ? new Date(profile.dob).toLocaleDateString() : 'Not set'}</p>
          </div>
          
          <div>
            <label style={{ fontWeight: 'bold', color: 'var(--primary-color)', display: 'block', fontSize: '0.9rem' }}>GENDER</label>
            <p style={{ marginBottom: '1.5rem', fontSize: '1.1rem' }}>{profile.gender || 'Not specified'}</p>
            
            <label style={{ fontWeight: 'bold', color: 'var(--primary-color)', display: 'block', fontSize: '0.9rem' }}>ADDRESS</label>
            <p style={{ marginBottom: '1.5rem', fontSize: '1.1rem' }}>{profile.address || 'N/A'}</p>
            
            <label style={{ fontWeight: 'bold', color: 'var(--primary-color)', display: 'block', fontSize: '0.9rem' }}>CITY / STATE</label>
            <p style={{ marginBottom: '1.5rem', fontSize: '1.1rem' }}>{profile.city || 'N/A'}</p>
          </div>
        </div>
        
        <div style={{ marginTop: '2rem', padding: '1rem', backgroundColor: '#f9f9f9', borderRadius: '8px', textAlign: 'center' }}>
          <p style={{ color: 'var(--text-light)', fontSize: '0.9rem' }}>To update your profile information, please contact the Administration Office.</p>
        </div>
      </div>
    </div>
  );
};

export default StudentProfile;
