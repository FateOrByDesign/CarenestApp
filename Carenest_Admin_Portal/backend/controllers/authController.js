const jwt = require("jsonwebtoken");
const supabase = require("../config/db");

exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ success: false, message: "Email and password are required." });
    }

    // Authenticate via Supabase Auth
    const { data: authData, error: authError } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (authError) {
      return res.status(401).json({ success: false, message: "Invalid email or password." });
    }

    // Check if user is an admin
    const { data: admin, error: adminError } = await supabase
      .from("admins")
      .select("*")
      .eq("auth_id", authData.user.id)
      .single();

    if (adminError || !admin) {
      return res.status(403).json({ success: false, message: "You are not authorized as an admin." });
    }

    const token = jwt.sign(
      { id: admin.id, email: admin.email, role: admin.role, auth_id: admin.auth_id },
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

    // Check if admin already exists
    const { data: existing } = await supabase
      .from("admins")
      .select("id")
      .eq("email", email)
      .single();

    if (existing) {
      return res.status(409).json({ success: false, message: "Email already registered." });
    }

    // Create Supabase Auth user
    const { data: authData, error: authError } = await supabase.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
    });

    if (authError) {
      return res.status(400).json({ success: false, message: authError.message });
    }

    // Insert into admins table
    const { data: admin, error: insertError } = await supabase
      .from("admins")
      .insert({ auth_id: authData.user.id, name, email, role: role || "admin" })
      .select()
      .single();

    if (insertError) {
      // Cleanup: delete the auth user if admin insert fails
      await supabase.auth.admin.deleteUser(authData.user.id);
      return res.status(500).json({ success: false, message: "Failed to create admin account." });
    }

    const token = jwt.sign(
      { id: admin.id, email: admin.email, role: admin.role, auth_id: admin.auth_id },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN }
    );

    res.status(201).json({
      success: true,
      token,
      admin: { id: admin.id, name: admin.name, email: admin.email, role: admin.role },
    });
  } catch (err) {
    next(err);
  }
};
