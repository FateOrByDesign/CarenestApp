const db = require("../config/db");

exports.getBookings = (req, res, next) => {
  try {
    const { status, serviceType, search, from, to } = req.query;

    let sql = `
      SELECT b.*,
             f.name AS family_name, f.email AS family_email, f.phone AS family_phone,
             c.name AS caregiver_name, c.email AS caregiver_email, c.phone AS caregiver_phone
      FROM bookings b
      LEFT JOIN users f ON b.family_id = f.id
      LEFT JOIN users c ON b.caregiver_id = c.id
      WHERE 1=1
    `;
    const params = [];

    if (status && status !== "All") {
      sql += " AND b.status = ?";
      params.push(status);
    }

    if (serviceType && serviceType !== "All") {
      sql += " AND b.service_type = ?";
      params.push(serviceType);
    }

    if (search) {
      sql += " AND (b.id LIKE ? OR f.name LIKE ? OR f.email LIKE ? OR c.name LIKE ? OR c.email LIKE ?)";
      const like = `%${search}%`;
      params.push(like, like, like, like, like);
    }

    if (from) {
      sql += " AND b.date >= ?";
      params.push(from);
    }

    if (to) {
      sql += " AND b.date <= ?";
      params.push(to);
    }

    sql += " ORDER BY b.created_at DESC";

    const rows = db.prepare(sql).all(...params);

    const bookings = rows.map((row) => ({
      id: row.id,
      serviceType: row.service_type,
      status: row.status,
      createdAt: row.created_at,
      date: row.date,
      timeSlot: row.time_slot,
      location: row.location,
      paymentStatus: row.payment_status,
      flagged: !!row.flagged,
      family: { name: row.family_name, email: row.family_email, phone: row.family_phone },
      caregiver: { name: row.caregiver_name, email: row.caregiver_email, phone: row.caregiver_phone },
    }));

    res.json({ success: true, data: bookings });
  } catch (err) {
    next(err);
  }
};

exports.getBookingById = (req, res, next) => {
  try {
    const row = db.prepare(
      `SELECT b.*,
              f.name AS family_name, f.email AS family_email, f.phone AS family_phone,
              c.name AS caregiver_name, c.email AS caregiver_email, c.phone AS caregiver_phone
       FROM bookings b
       LEFT JOIN users f ON b.family_id = f.id
       LEFT JOIN users c ON b.caregiver_id = c.id
       WHERE b.id = ?`
    ).get(req.params.id);

    if (!row) {
      return res.status(404).json({ success: false, message: "Booking not found." });
    }

    res.json({
      success: true,
      data: {
        id: row.id,
        serviceType: row.service_type,
        status: row.status,
        createdAt: row.created_at,
        date: row.date,
        timeSlot: row.time_slot,
        location: row.location,
        paymentStatus: row.payment_status,
        flagged: !!row.flagged,
        family: { name: row.family_name, email: row.family_email, phone: row.family_phone },
        caregiver: { name: row.caregiver_name, email: row.caregiver_email, phone: row.caregiver_phone },
      },
    });
  } catch (err) {
    next(err);
  }
};

exports.toggleFlag = (req, res, next) => {
  try {
    const booking = db.prepare("SELECT id, flagged FROM bookings WHERE id = ?").get(req.params.id);

    if (!booking) {
      return res.status(404).json({ success: false, message: "Booking not found." });
    }

    const newFlagged = booking.flagged ? 0 : 1;

    db.prepare("UPDATE bookings SET flagged = ? WHERE id = ?").run(newFlagged, req.params.id);

    res.json({
      success: true,
      message: newFlagged ? "Booking flagged." : "Booking unflagged.",
      data: { flagged: !!newFlagged },
    });
  } catch (err) {
    next(err);
  }
};
