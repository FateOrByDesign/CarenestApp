const supabase = require("../config/db");

exports.getActivityFeed = async (req, res, next) => {
  try {
    const limit = parseInt(req.query.limit) || 20;

    // Fetch recent caregiver applications
    const { data: applications, error: appError } = await supabase
      .from("caregiver_applications")
      .select("id, name, status, submitted_date")
      .order("submitted_date", { ascending: false })
      .limit(limit);

    if (appError) throw appError;

    // Fetch recent bookings with patient and caregiver names
    const { data: bookings, error: bookingError } = await supabase
      .from("bookings")
      .select(
        `id, status, service_type, created_at,
        patient_profiles!patient_id(name),
        caregiver_profiles!caregiver_id(name)`
      )
      .order("created_at", { ascending: false })
      .limit(limit);

    if (bookingError) throw bookingError;

    // Transform applications into activity items
    const appActivities = (applications || []).map((app) => ({
      id: `app-${app.id}`,
      type: "application",
      title: getApplicationTitle(app),
      timestamp: app.submitted_date,
      status: app.status,
    }));

    // Transform bookings into activity items
    const bookingActivities = (bookings || []).map((booking) => ({
      id: `booking-${booking.id}`,
      type: "booking",
      title: getBookingTitle(booking),
      timestamp: booking.created_at,
      status: booking.status,
    }));

    // Merge and sort by timestamp descending
    const allActivities = [...appActivities, ...bookingActivities]
      .sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp))
      .slice(0, limit);

    res.json({ success: true, data: allActivities });
  } catch (err) {
    next(err);
  }
};

function getApplicationTitle(app) {
  switch (app.status) {
    case "Pending":
      return `New caregiver application from ${app.name}`;
    case "Approved":
      return `Caregiver ${app.name} was approved`;
    case "Rejected":
      return `Caregiver ${app.name} was rejected`;
    default:
      return `Caregiver application update: ${app.name}`;
  }
}

function getBookingTitle(booking) {
  const patientName = booking.patient_profiles?.name || "Unknown";
  const caregiverName = booking.caregiver_profiles?.name;
  const service = booking.service_type || "care service";

  switch (booking.status) {
    case "Pending Confirmation":
      return `New ${service} booking by ${patientName}`;
    case "Accepted":
      return `Booking for ${patientName} accepted by ${caregiverName || "caregiver"}`;
    case "Ongoing":
      return `Booking for ${patientName} is now ongoing`;
    case "Completed":
      return `Booking for ${patientName} completed`;
    case "Cancelled":
      return `Booking for ${patientName} was cancelled`;
    default:
      return `Booking update for ${patientName}`;
  }
}
