const Dashboard = () => {
  return (
    <div>
      <div className="page-header">
        <h1 className="page-title">Dashboard Overview</h1>
        <button className="btn btn-primary">Download Report</button>
      </div>

      <div className="stats-grid">
        <div className="stat-card success">
          <div className="stat-icon">👥</div>
          <div className="stat-details">
            <h3>Total Students</h3>
            <p>1,254</p>
          </div>
        </div>
        <div className="stat-card warning">
          <div className="stat-icon">📚</div>
          <div className="stat-details">
            <h3>Active Courses</h3>
            <p>42</p>
          </div>
        </div>
        <div className="stat-card danger">
          <div className="stat-icon">💰</div>
          <div className="stat-details">
            <h3>Pending Fees</h3>
            <p>$12,450</p>
          </div>
        </div>
        <div className="stat-card">
          <div className="stat-icon">👨‍🏫</div>
          <div className="stat-details">
            <h3>Faculty Members</h3>
            <p>86</p>
          </div>
        </div>
      </div>

      <div className="card">
        <h2 className="chart-title">Recent Enrollments</h2>
        <div className="table-container">
          <table className="data-table">
            <thead>
              <tr>
                <th>Roll No</th>
                <th>Name</th>
                <th>Course</th>
                <th>Date</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>STU021</td>
                <td>Alex Johnson</td>
                <td>Computer Science</td>
                <td>Oct 24, 2024</td>
                <td><span className="status-badge status-active">Active</span></td>
              </tr>
              <tr>
                <td>STU022</td>
                <td>Maria Garcia</td>
                <td>Mathematics</td>
                <td>Oct 23, 2024</td>
                <td><span className="status-badge status-active">Active</span></td>
              </tr>
              <tr>
                <td>STU023</td>
                <td>James Smith</td>
                <td>Physics</td>
                <td>Oct 21, 2024</td>
                <td><span className="status-badge status-pending">Pending</span></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
