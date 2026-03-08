const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const db = require("../config/db");

exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ success: false, message: "Email and password are required." });
    }

    const admin = db.prepare("SELECT * FROM admins WHERE email = ?").get(email);

    if (!admin) {
      return res.status(401).json({ success: false, message: "Invalid email or password." });
    }

    const isMatch = await bcrypt.compare(password, admin.password_hash);

    if (!isMatch) {
      return res.status(401).json({ success: false, message: "Invalid email or password." });
    }

    const token = jwt.sign(
      { id: admin.id, email: admin.email, role: admin.role },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN }
    );

    res.json({
      success: true,
      token,
      admin: { id: admin.id, name: admin.name, email: admin.email, role: admin.role },
    });
  } catch (err) {
    next(err);
  }
};

exports.register = async (req, res, next) => {
  try {
    const { name, email, password, role } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({ success: false, message: "Name, email, and password are required." });
    }

    const existing = db.prepare("SELECT id FROM admins WHERE email = ?").get(email);

    if (existing) {
      return res.status(409).json({ success: false, message: "Email already registered." });
    }

    const salt = await bcrypt.genSalt(10);
    const password_hash = await bcrypt.hash(password, salt);

    const result = db.prepare(
      "INSERT INTO admins (name, email, password_hash, role) VALUES (?, ?, ?, ?)"
    ).run(name, email, password_hash, role || "admin");

    const token = jwt.sign(
      { id: result.lastInsertRowid, email, role: role || "admin" },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN }
    );

    res.status(201).json({
      success: true,
      token,
      admin: { id: result.lastInsertRowid, name, email, role: role || "admin" },
    });
  } catch (err) {
    next(err);
  }
};
