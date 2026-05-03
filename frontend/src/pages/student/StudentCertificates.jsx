import { useState, useEffect } from 'react';
import axios from 'axios';
import { downloadCSV } from '../../utils/downloadHelper';

const StudentCertificates = () => {
  const [requestType, setRequestType] = useState('Marksheet');
  const [message, setMessage] = useState('');
  const [results, setResults] = useState([]);

  useEffect(() => {
    fetchMyResults();
  }, []);

  const fetchMyResults = async () => {
    try {
      const user = JSON.parse(localStorage.getItem('user') || '{}');
      const token = localStorage.getItem('token');
      const config = token ? { headers: { Authorization: `Bearer ${token}` } } : {};
      const res = await axios.get(`http://localhost:5000/api/marks?student_id=${user.id}`, config);
      if (res.data.status === 'success') {
        setResults(res.data.data);
      }
    } catch (err) {
      console.error('Failed to fetch results', err);
    }
  };

  const handleDownloadMarksheet = () => {
    if (results.length === 0) return alert('No marks recorded yet.');
    downloadCSV(results, 'My_Marksheet_Fall_2024');
  };

  const handleDownloadCertificate = () => {
    const certData = [{
       Certificate: 'Bonafide Certificate',
       Issued_To: JSON.parse(localStorage.getItem('user') || '{}').username,
       Status: 'Verified',
       Date: new Date().toLocaleDateString()
    }];
    downloadCSV(certData, 'My_Certificate');
  };

  const handleRequest = (e) => {
    e.preventDefault();
    setMessage(`Your request for ${requestType} has been submitted successfully and is pending approval.`);
    setTimeout(() => setMessage(''), 5000);
  };

  return (
    <div>
      <div className="page-header">
        <h1 className="page-title">Certificates & Documents</h1>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '2rem' }}>
        <div className="card">
          <h2 className="chart-title">Request a Document</h2>
          {message && <div style={{ color: 'var(--success-color)', marginBottom: '1rem', fontWeight: 'bold' }}>{message}</div>}
          
          <form onSubmit={handleRequest}>
            <div className="form-group">
              <label className="form-label">Document Type</label>
              <select 
                className="form-control" 
                value={requestType}
                onChange={(e) => setRequestType(e.target.value)}
              >
                <option value="Marksheet">Marksheet (Current Semester)</option>
                <option value="Course Completion">Course Completion Certificate</option>
                <option value="Transfer Certificate">Transfer Certificate (TC)</option>
                <option value="Bonafide Certificate">Bonafide Certificate</option>
              </select>
            </div>
            <div className="form-group">
              <label className="form-label">Reason for Request</label>
              <textarea className="form-control" rows="4" placeholder="Briefly explain why you need this document..."></textarea>
            </div>
            <button type="submit" className="btn btn-primary">Submit Request</button>
          </form>
        </div>

        <div className="card">
          <h2 className="chart-title">My Issued Documents</h2>
          <div className="table-container">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Document</th>
                  <th>Date Issued</th>
                  <th>Status</th>
                  <th>Action</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>Semester 1 Marksheet</td>
                  <td>Jan 15, 2024</td>
                  <td><span className="status-badge status-active">Ready</span></td>
                  <td><button className="btn btn-success" style={{ padding: '0.25rem 0.5rem' }} onClick={handleDownloadMarksheet}>Download</button></td>
                </tr>
                <tr>
                  <td>Bonafide Certificate</td>
                  <td>Oct 20, 2024</td>
                  <td><span className="status-badge status-pending">Processing</span></td>
                  <td><button className="btn" style={{ padding: '0.25rem 0.5rem' }} onClick={handleDownloadCertificate}>Preview</button></td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
};

export default StudentCertificates;
