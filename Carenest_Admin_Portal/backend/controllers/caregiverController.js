const supabase = require("../config/db");

exports.getApplications = async (req, res, next) => {
  try {
    const { status, search } = req.query;

    let query = supabase.from("caregiver_applications").select("*");

    if (status && status !== "All") {
      query = query.eq("status", status);
    }

    if (search) {
      query = query.or(`name.ilike.%${search}%,email.ilike.%${search}%,nic.ilike.%${search}%`);
    }

    query = query.order("submitted_date", { ascending: false });

    const { data, error } = await query;
    if (error) throw error;

    res.json({ success: true, data });
  } catch (err) {
    next(err);
  }
};

exports.getApplicationById = async (req, res, next) => {
  try {
    const { data, error } = await supabase
      .from("caregiver_applications")
      .select("*")
      .eq("id", req.params.id)
      .single();

    if (error || !data) {
      return res.status(404).json({ success: false, message: "Application not found." });
    }

    res.json({ success: true, data });
  } catch (err) {
    next(err);
  }
};

exports.approveApplication = async (req, res, next) => {
  try {
    const { data, error } = await supabase
      .from("caregiver_applications")
      .update({ status: "Approved" })
      .eq("id", req.params.id)
      .eq("status", "Pending")
      .select();

    if (error) throw error;

    if (!data || data.length === 0) {
      return res.status(404).json({ success: false, message: "Application not found or not pending." });
    }

    res.json({ success: true, message: "Application approved." });
  } catch (err) {
    next(err);
  }
};

exports.rejectApplication = async (req, res, next) => {
  try {
    const { reason } = req.body;

    if (!reason || !reason.trim()) {
      return res.status(400).json({ success: false, message: "Rejection reason is required." });
    }

    const { data, error } = await supabase
      .from("caregiver_applications")
      .update({ status: "Rejected", rejection_reason: reason })
      .eq("id", req.params.id)
      .eq("status", "Pending")
      .select();

    if (error) throw error;

    if (!data || data.length === 0) {
      return res.status(404).json({ success: false, message: "Application not found or not pending." });
    }

    res.json({ success: true, message: "Application rejected." });
  } catch (err) {
    next(err);
  }
};
