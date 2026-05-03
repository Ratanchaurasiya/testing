const pool = require('../config/database');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// User Login
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ status: 'error', message: 'Please provide email and password' });
    }

    const [users] = await pool.execute('SELECT u.*, r.role_name FROM Users u LEFT JOIN UserRoles r ON u.role_id = r.role_id WHERE u.email = ?', [email]);
    
    if (users.length === 0) {
      return res.status(401).json({ status: 'error', message: 'Invalid credentials' });
    }

    const user = users[0];

    // Check if account is active
    if (!user.is_active) {
      return res.status(403).json({ status: 'error', message: 'Account is deactivated' });
    }

    // Verify password. Note: If passwords in DB are MD5 (as per the trigger in SQL), we should handle it. 
    // In the provided SQL, MD5 was used for default passwords. For a production app, bcrypt is better.
    // For this example, we'll check bcrypt. If it fails, we check MD5 as fallback for the dummy data.
    const crypto = require('crypto');
    const md5Password = crypto.createHash('md5').update(password).digest('hex');
    
    let isMatch = false;
    if (user.password_hash === md5Password) {
      isMatch = true;
      // Optionally upgrade password to bcrypt here
    } else {
      isMatch = await bcrypt.compare(password, user.password_hash);
    }

    if (!isMatch) {
      // Update login attempts here if needed
      return res.status(401).json({ status: 'error', message: 'Invalid credentials' });
    }

    // Generate JWT token
    const token = jwt.sign(
      { id: user.user_id, role: user.role_name, email: user.email },
      process.env.JWT_SECRET,
      { expiresIn: '24h' }
    );

    // Update last login
    await pool.execute('UPDATE Users SET last_login = CURRENT_TIMESTAMP, login_attempts = 0 WHERE user_id = ?', [user.user_id]);

    res.status(200).json({
      status: 'success',
      token,
      user: {
        id: user.user_id,
        username: user.username,
        email: user.email,
        role: user.role_name
      }
    });
  } catch (error) {
    console.error('Login Error:', error);
    res.status(500).json({ status: 'error', message: 'Server error during login' });
  }
};

// Check Auth Status (Validate Token)
exports.checkAuth = async (req, res) => {
  res.status(200).json({ status: 'success', user: req.user });
};
