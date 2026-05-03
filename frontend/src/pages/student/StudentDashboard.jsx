import { useState, useEffect } from 'react';

const StudentDashboard = () => {
  const user = JSON.parse(localStorage.getItem('user') || '{}');

  return (
    <div>
      <div className="page-header">
        <h1 className="page-title">Welcome back, {user.username}!</h1>
      </div>

      <div className="stats-grid">
        <div className="stat-card success">
          <div className="stat-icon">✅</div>
          <div className="stat-details">
            <h3>Attendance</h3>
            <p>85%</p>
          </div>
        </div>
        <div className="stat-card">
          <div className="stat-icon">📚</div>
          <div className="stat-details">
            <h3>My Courses</h3>
            <p>4</p>
          </div>
        </div>
        <div className="stat-card warning">
          <div className="stat-icon">💰</div>
          <div className="stat-details">
            <h3>Pending Fees</h3>
            <p>$150</p>
          </div>
        </div>
      </div>

      <div className="card">
        <h2 className="chart-title">My Recent Grades</h2>
        <div className="table-container">
          <table className="data-table">
            <thead>
              <tr>
                <th>Subject</th>
                <th>Exam</th>
                <th>Score</th>
                <th>Grade</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Computer Science 101</td>
                <td>Midterm</td>
                <td>88/100</td>
                <td><span className="status-badge status-active">A</span></td>
              </tr>
              <tr>
                <td>Mathematics 202</td>
                <td>Midterm</td>
                <td>72/100</td>
                <td><span className="status-badge status-pending">B</span></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default StudentDashboard;
