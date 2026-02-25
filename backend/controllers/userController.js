const db = require("../config/db");

exports.getUsers = (req, res, next) => {
  try {
    const { role, status, search } = req.query;

    let sql = "SELECT * FROM users WHERE 1=1";
    const params = [];

    if (role && role !== "All") {
      sql += " AND role = ?";
      params.push(role);
    }

    if (status && status !== "All") {
      sql += " AND status = ?";
      params.push(status);
    }

    if (search) {
      sql += " AND (name LIKE ? OR email LIKE ? OR phone LIKE ?)";
      const like = `%${search}%`;
      params.push(like, like, like);
    }

    sql += " ORDER BY created_at DESC";

    const rows = db.prepare(sql).all(...params);
    res.json({ success: true, data: rows });
  } catch (err) {
    next(err);
  }
};

exports.getUserById = (req, res, next) => {
  try {
    const row = db.prepare("SELECT * FROM users WHERE id = ?").get(req.params.id);

    if (!row) {
      return res.status(404).json({ success: false, message: "User not found." });
    }

    res.json({ success: true, data: row });
  } catch (err) {
    next(err);
  }
};

exports.toggleUserStatus = (req, res, next) => {
  try {
    const user = db.prepare("SELECT id, status FROM users WHERE id = ?").get(req.params.id);

    if (!user) {
      return res.status(404).json({ success: false, message: "User not found." });
    }

    const newStatus = user.status === "Active" ? "Suspended" : "Active";

    db.prepare("UPDATE users SET status = ? WHERE id = ?").run(newStatus, req.params.id);

    res.json({ success: true, message: `User ${newStatus.toLowerCase()}.`, data: { status: newStatus } });
  } catch (err) {
    next(err);
  }
};
