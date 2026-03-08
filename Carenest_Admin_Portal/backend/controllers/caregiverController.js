const db = require("../config/db");

exports.getApplications = (req, res, next) => {
  try {
    const { status, search } = req.query;

    let sql = "SELECT * FROM caregiver_applications WHERE 1=1";
    const params = [];

    if (status && status !== "All") {
      sql += " AND status = ?";
      params.push(status);
    }

    if (search) {
      sql += " AND (name LIKE ? OR email LIKE ? OR nic LIKE ?)";
      const like = `%${search}%`;
      params.push(like, like, like);
    }

    sql += " ORDER BY submitted_date DESC";

    const rows = db.prepare(sql).all(...params);
    res.json({ success: true, data: rows });
  } catch (err) {
    next(err);
  }
};

exports.getApplicationById = (req, res, next) => {
  try {
    const row = db.prepare("SELECT * FROM caregiver_applications WHERE id = ?").get(req.params.id);

    if (!row) {
      return res.status(404).json({ success: false, message: "Application not found." });
    }

    res.json({ success: true, data: row });
  } catch (err) {
    next(err);
  }
};

exports.approveApplication = (req, res, next) => {
  try {
    const result = db.prepare(
      "UPDATE caregiver_applications SET status = 'Approved' WHERE id = ? AND status = 'Pending'"
    ).run(req.params.id);

    if (result.changes === 0) {
      return res.status(404).json({ success: false, message: "Application not found or not pending." });
    }

    res.json({ success: true, message: "Application approved." });
  } catch (err) {
    next(err);
  }
};

exports.rejectApplication = (req, res, next) => {
  try {
    const { reason } = req.body;

    if (!reason || !reason.trim()) {
      return res.status(400).json({ success: false, message: "Rejection reason is required." });
    }

    const result = db.prepare(
      "UPDATE caregiver_applications SET status = 'Rejected', rejection_reason = ? WHERE id = ? AND status = 'Pending'"
    ).run(reason, req.params.id);

    if (result.changes === 0) {
      return res.status(404).json({ success: false, message: "Application not found or not pending." });
    }

    res.json({ success: true, message: "Application rejected." });
  } catch (err) {
    next(err);
  }
};
