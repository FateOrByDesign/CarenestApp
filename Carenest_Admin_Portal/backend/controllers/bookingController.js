const supabase = require("../config/db");

exports.getBookings = async (req, res, next) => {
  try {
    const { status, serviceType, search, from, to } = req.query;

    let query = supabase
      .from("bookings")
      .select(`
        *,
        patient_profiles!patient_id(name, email, phone),
        caregiver_profiles!caregiver_id(name, email, phone)
      `);

    if (status && status !== "All") {
      query = query.eq("status", status);
    }

    if (serviceType && serviceType !== "All") {
      query = query.eq("service_type", serviceType);
    }

    if (from) {
      query = query.gte("date", from);
    }

    if (to) {
      query = query.lte("date", to);
    }

    query = query.order("created_at", { ascending: false });

    const { data, error } = await query;
    if (error) throw error;

    let bookings = (data || []).map((row) => ({
      id: row.id,
      serviceType: row.service_type,
      status: row.status,
      createdAt: row.created_at,
      date: row.date,
      timeSlot: row.time_slot,
      location: row.location,
      paymentStatus: row.payment_status,
      flagged: !!row.flagged,
      family: {
        name: row.patient_profiles?.name || null,
        email: row.patient_profiles?.email || null,
        phone: row.patient_profiles?.phone || null,
      },
      caregiver: {
        name: row.caregiver_profiles?.name || null,
        email: row.caregiver_profiles?.email || null,
        phone: row.caregiver_profiles?.phone || null,
      },
    }));

    // Client-side search filter (for cross-table search)
    if (search) {
      const s = search.toLowerCase();
      bookings = bookings.filter(
        (b) =>
          b.id.toLowerCase().includes(s) ||
          (b.family.name && b.family.name.toLowerCase().includes(s)) ||
          (b.family.email && b.family.email.toLowerCase().includes(s)) ||
          (b.caregiver.name && b.caregiver.name.toLowerCase().includes(s)) ||
          (b.caregiver.email && b.caregiver.email.toLowerCase().includes(s))
      );
    }

    res.json({ success: true, data: bookings });
  } catch (err) {
    next(err);
  }
};

exports.getBookingById = async (req, res, next) => {
  try {
    const { data: row, error } = await supabase
      .from("bookings")
      .select(`
        *,
        patient_profiles!patient_id(name, email, phone),
        caregiver_profiles!caregiver_id(name, email, phone)
      `)
      .eq("id", req.params.id)
      .single();

    if (error || !row) {
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
        family: {
          name: row.patient_profiles?.name || null,
          email: row.patient_profiles?.email || null,
          phone: row.patient_profiles?.phone || null,
        },
        caregiver: {
          name: row.caregiver_profiles?.name || null,
          email: row.caregiver_profiles?.email || null,
          phone: row.caregiver_profiles?.phone || null,
        },
      },
    });
  } catch (err) {
    next(err);
  }
};

exports.toggleFlag = async (req, res, next) => {
  try {
    const { data: booking, error: fetchError } = await supabase
      .from("bookings")
      .select("id, flagged")
      .eq("id", req.params.id)
      .single();

    if (fetchError || !booking) {
      return res.status(404).json({ success: false, message: "Booking not found." });
    }

    const newFlagged = !booking.flagged;

    const { error: updateError } = await supabase
      .from("bookings")
      .update({ flagged: newFlagged })
      .eq("id", req.params.id);

    if (updateError) throw updateError;

    res.json({
      success: true,
      message: newFlagged ? "Booking flagged." : "Booking unflagged.",
      data: { flagged: newFlagged },
    });
  } catch (err) {
    next(err);
  }
};
