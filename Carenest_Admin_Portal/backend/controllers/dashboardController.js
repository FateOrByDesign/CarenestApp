const supabase = require("../config/db");

exports.getStats = async (req, res, next) => {
  try {
    const [appsRes, bookingsRes, caregiversRes, patientsRes, activeCaregiversRes] = await Promise.all([
      supabase.from("caregiver_applications").select("id", { count: "exact", head: true }).eq("status", "Pending"),
      supabase.from("bookings").select("id", { count: "exact", head: true }),
      supabase.from("caregiver_profiles").select("id", { count: "exact", head: true }),
      supabase.from("patient_profiles").select("id", { count: "exact", head: true }),
      supabase.from("caregiver_profiles").select("id", { count: "exact", head: true }).eq("status", "Active"),
    ]);

    res.json({
      success: true,
      data: {
        pendingApplications: appsRes.count || 0,
        totalBookings: bookingsRes.count || 0,
        totalUsers: (caregiversRes.count || 0) + (patientsRes.count || 0),
        activeCaregivers: activeCaregiversRes.count || 0,
      },
    });
  } catch (err) {
    next(err);
  }
};

exports.getRecentApplications = async (req, res, next) => {
  try {
    const { data, error } = await supabase
      .from("caregiver_applications")
      .select("id, name, email, submitted_date, status")
      .order("submitted_date", { ascending: false })
      .limit(10);

    if (error) throw error;

    res.json({ success: true, data });
  } catch (err) {
    next(err);
  }
};

exports.getRecentBookings = async (req, res, next) => {
  try {
    const { data, error } = await supabase
      .from("bookings")
      .select(`
        id, service_type, status, date, time_slot,
        patient_profiles!patient_id(name),
        caregiver_profiles!caregiver_id(name)
      `)
      .order("created_at", { ascending: false })
      .limit(10);

    if (error) throw error;

    const rows = (data || []).map((row) => ({
      id: row.id,
      service_type: row.service_type,
      status: row.status,
      date: row.date,
      time_slot: row.time_slot,
      family_name: row.patient_profiles?.name || null,
      caregiver_name: row.caregiver_profiles?.name || null,
    }));

    res.json({ success: true, data: rows });
  } catch (err) {
    next(err);
  }
};
