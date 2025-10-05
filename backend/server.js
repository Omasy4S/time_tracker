const express = require('express');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;
const JWT_SECRET = process.env.JWT_SECRET || 'your_secret_key';

// Middleware
app.use(cors());
app.use(express.json());

// In-memory database (for demo purposes)
const users = [];
const shifts = [];
let userIdCounter = 1;
let shiftIdCounter = 1;

// Middleware to verify JWT token
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Access token required' });
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ error: 'Invalid or expired token' });
    }
    req.user = user;
    next();
  });
};

// Auth Routes
app.post('/auth/register', async (req, res) => {
  try {
    const { email, password, name } = req.body;

    // Validation
    if (!email || !password || !name) {
      return res.status(400).json({ error: 'All fields are required' });
    }

    // Check if user already exists
    const existingUser = users.find(u => u.email === email);
    if (existingUser) {
      return res.status(400).json({ error: 'User already exists' });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create user
    const user = {
      id: userIdCounter++,
      email,
      password: hashedPassword,
      name,
      createdAt: new Date().toISOString()
    };

    users.push(user);

    // Generate token
    const token = jwt.sign(
      { id: user.id, email: user.email },
      JWT_SECRET,
      { expiresIn: '7d' }
    );

    res.status(201).json({
      token,
      user: {
        id: user.id,
        email: user.email,
        name: user.name
      }
    });
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
});

app.post('/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    // Validation
    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password are required' });
    }

    // Find user
    const user = users.find(u => u.email === email);
    if (!user) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    // Check password
    const isValidPassword = await bcrypt.compare(password, user.password);
    if (!isValidPassword) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    // Generate token
    const token = jwt.sign(
      { id: user.id, email: user.email },
      JWT_SECRET,
      { expiresIn: '7d' }
    );

    res.json({
      token,
      user: {
        id: user.id,
        email: user.email,
        name: user.name
      }
    });
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
});

// Shift Routes
app.post('/shifts/start', authenticateToken, (req, res) => {
  try {
    const userId = req.user.id;

    // Check if user has an active shift
    const activeShift = shifts.find(
      s => s.userId === userId && s.status === 'active'
    );

    if (activeShift) {
      return res.status(400).json({ error: 'You already have an active shift' });
    }

    // Create new shift
    const shift = {
      id: shiftIdCounter++,
      userId,
      startTime: new Date().toISOString(),
      endTime: null,
      report: null,
      status: 'active',
      createdAt: new Date().toISOString()
    };

    shifts.push(shift);

    res.status(201).json(shift);
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
});

app.patch('/shifts/finish', authenticateToken, (req, res) => {
  try {
    const userId = req.user.id;
    const { report } = req.body;

    // Find active shift
    const shift = shifts.find(
      s => s.userId === userId && s.status === 'active'
    );

    if (!shift) {
      return res.status(404).json({ error: 'No active shift found' });
    }

    // Update shift
    shift.endTime = new Date().toISOString();
    shift.report = report || '';
    shift.status = 'completed';

    res.json(shift);
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
});

app.get('/shifts', authenticateToken, (req, res) => {
  try {
    const userId = req.user.id;

    // Get all user shifts
    const userShifts = shifts
      .filter(s => s.userId === userId)
      .sort((a, b) => new Date(b.startTime) - new Date(a.startTime));

    res.json(userShifts);
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
});

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

app.listen(PORT, () => {
  console.log(`🚀 Server is running on http://localhost:${PORT}`);
});
