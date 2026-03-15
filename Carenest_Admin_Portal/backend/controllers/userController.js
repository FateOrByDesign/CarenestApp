const supabase = require("../config/db");

exports.getUsers = async (req, res, next) => {
  try {
    const { role, status, search } = req.query;

    let query = supabase.from("all_users").select("*");

    if (role && role !== "All") {
      query = query.eq("role", role);
    }

    if (status && status !== "All") {
      query = query.eq("status", status);
    }

    if (search) {
      query = query.or(`name.ilike.%${search}%,email.ilike.%${search}%,phone.ilike.%${search}%`);
    }

    query = query.order("created_at", { ascending: false });

    const { data, error } = await query;
    if (error) throw error;

    res.json({ success: true, data });
  } catch (err) {
    next(err);
  }
};

exports.getUserById = async (req, res, next) => {
  try {
    const { role } = req.query;
    const id = req.params.id;

    let data = null;

    if (role === "Caregiver") {
      const result = await supabase.from("caregiver_profiles").select("*").eq("id", id).single();
      if (result.data) data = { ...result.data, role: "Caregiver" };
    } else if (role === "Family") {
      const result = await supabase.from("patient_profiles").select("*").eq("id", id).single();
      if (result.data) data = { ...result.data, role: "Family" };
    } else {
      // Try both tables
      const cgResult = await supabase.from("caregiver_profiles").select("*").eq("id", id).single();
      if (cgResult.data) {
        data = { ...cgResult.data, role: "Caregiver" };
      } else {
        const ptResult = await supabase.from("patient_profiles").select("*").eq("id", id).single();
        if (ptResult.data) data = { ...ptResult.data, role: "Family" };
      }
    }

    if (!data) {
      return res.status(404).json({ success: false, message: "User not found." });
    }

    res.json({ success: true, data });
  } catch (err) {
    next(err);
  }
};

exports.toggleUserStatus = async (req, res, next) => {
  try {
    const id = req.params.id;
    const { role } = req.body;

    const table = role === "Caregiver" ? "caregiver_profiles" : "patient_profiles";

    // Get current status
    const { data: user, error: fetchError } = await supabase
      .from(table)
      .select("id, status")
      .eq("id", id)
      .single();

    if (fetchError || !user) {
      return res.status(404).json({ success: false, message: "User not found." });
    }

    const newStatus = user.status === "Active" ? "Suspended" : "Active";

    const { error: updateError } = await supabase
      .from(table)
      .update({ status: newStatus })
      .eq("id", id);

    if (updateError) throw updateError;

    res.json({ success: true, message: `User ${newStatus.toLowerCase()}.`, data: { status: newStatus } });
  } catch (err) {
    next(err);
  }
};
