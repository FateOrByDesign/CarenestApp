const db = require("../config/db");

exports.getStats = (req, res, next) => {
  try {
    const { pendingApplications } = db.prepare(
      "SELECT COUNT(*) AS pendingApplications FROM caregiver_applications WHERE status = 'Pending'"
    ).get();
    const { totalBookings } = db.prepare(
      "SELECT COUNT(*) AS totalBookings FROM bookings"
    ).get();
    const { totalUsers } = db.prepare(
      "SELECT COUNT(*) AS totalUsers FROM users"
    ).get();
    const { activeCaregivers } = db.prepare(
      "SELECT COUNT(*) AS activeCaregivers FROM users WHERE role = 'Caregiver' AND status = 'Active'"
    ).get();

    res.json({
      success: true,
      data: { pendingApplications, totalBookings, totalUsers, activeCaregivers },
    });
  } catch (err) {
    next(err);
  }
};

exports.getRecentApplications = (req, res, next) => {
  try {
    const rows = db.prepare(
      "SELECT id, name, email, submitted_date, status FROM caregiver_applications ORDER BY submitted_date DESC LIMIT 10"
    ).all();
    res.json({ success: true, data: rows });
  } catch (err) {
    next(err);
  }
};

exports.getRecentBookings = (req, res, next) => {
  try {
    const rows = db.prepare(
      `SELECT b.id, b.service_type, b.status, b.date, b.time_slot,
              f.name AS family_name, c.name AS caregiver_name
       FROM bookings b
       LEFT JOIN users f ON b.family_id = f.id
       LEFT JOIN users c ON b.caregiver_id = c.id
       ORDER BY b.created_at DESC LIMIT 10`
    ).all();
    res.json({ success: true, data: rows });
  } catch (err) {
    next(err);
  }
};
