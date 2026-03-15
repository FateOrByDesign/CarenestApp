import { useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  Box,
  Button,
  Checkbox,
  FormControlLabel,
  IconButton,
  InputAdornment,
  Link,
  TextField,
  Typography,
} from "@mui/material";
import {
  EmailOutlined,
  LockOutlined,
  Visibility,
  VisibilityOff,
} from "@mui/icons-material";
import AdminImg from "../assets/hackerPic2.png";
import API_BASE from "../services/api";


function Login() {
  const navigate = useNavigate();
  const [showPassword, setShowPassword] = useState(false);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [rememberMe, setRememberMe] = useState(false);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setLoading(true);

    try {
      const res = await fetch(`${API_BASE}/auth/login`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email, password }),
      });

      const data = await res.json();

      if (!data.success) {
        setError(data.message);
        setLoading(false);
        return;
      }

      localStorage.setItem("token", data.token);
      localStorage.setItem("role", data.admin.role);
      localStorage.setItem("adminName", data.admin.name);
      navigate("/dashboard");
    } catch (err) {
      setError("Cannot connect to server. Make sure backend is running.");
    }
    setLoading(false);
  };

  return (
    <Box
      sx={{
        width: "100vw",
        height: "100vh",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        bgcolor: "#e8ecf0",
        p: "20px",
        boxSizing: "border-box",
      }}
    >
      <Box
        sx={{
          display: "flex",
          alignItems: "stretch",
          width: "100%",
          height: "100%",
          borderRadius: "24px",
          overflow: "hidden",
          boxShadow: "0 8px 40px rgba(0,0,0,0.12)",
        }}
      >
        {/* Left Panel */}
        <Box
          sx={{
            flex: 1,
            background: "linear-gradient(160deg, #1976d2 0%, #42a5f5 50%, #64b5f6 100%)",
            display: "flex",
            flexDirection: "column",
            justifyContent: "flex-start",
            pt: 6,
            px: 6,
            pb: 0,
            position: "relative",
            overflow: "hidden",
          }}
        >
          {/* Decorative circles */}
          <Box
            sx={{
              position: "absolute",
              top: -80,
              right: -80,
              width: 300,
              height: 300,
              borderRadius: "50%",
              bgcolor: "rgba(255,255,255,0.08)",
            }}
          />
          <Box
            sx={{
              position: "absolute",
              top: 20,
              right: 20,
              width: 200,
              height: 200,
              borderRadius: "50%",
              bgcolor: "rgba(255,255,255,0.06)",
            }}
          />
          {/* Bottom-left decorative circle */}
          <Box
            sx={{
              position: "absolute",
              bottom: -80,
              left: -80,
              width: 250,
              height: 250,
              borderRadius: "50%",
              bgcolor: "rgba(255,255,255,0.07)",
            }}
          />

          <Box sx={{ position: "relative", zIndex: 1 }}>
            <Typography
              sx={{
                color: "#fff",
                fontWeight: 800,
                fontSize: "1.5rem",
                mb: 4,
              }}
            >
              CareNest.lk
            </Typography>

            <Typography
              sx={{
                color: "#fff",
                fontWeight: 700,
                fontSize: "2.4rem",
                lineHeight: 1.25,
                mb: 2,
              }}
            >
              Monitor care sessions,
              <br />
              resolve issues, and keep the
              <br /> platform safe.
            </Typography>

            <Typography
              sx={{
                color: "rgba(255,255,255,0.85)",
                fontSize: "1.1rem",
                lineHeight: 1.7,
              }}
            >
              Review caregiver applications, approve profiles, and 
              <br />
              monitor bookings from one secure dashboard.
            </Typography>
          </Box>

          <Box
            sx={{
              position: "absolute",
              bottom: 0,
              left: 0,
              right: 0,
              zIndex: 1,
              display: "flex",
              justifyContent: "center",
              alignItems: "flex-end",
            }}
          >
            <Box
              component="img"
              src={AdminImg}
              alt="Hacker"
              sx={{
                width: "100%",
                maxHeight: "55%",
                objectFit: "contain",
                objectPosition: "bottom",
              }}
            />
          </Box>
        </Box>

        {/* Right Panel */}
        <Box
          sx={{
            flex: 1,
            bgcolor: "#fff",
            display: "flex",
            flexDirection: "column",
            justifyContent: "center",
            px: 8,
            pt: 18,
            pb: 4,
          }}
        >
          <Typography
            sx={{
              fontWeight: 700,
              color: "#1a1a2e",
              fontSize: "2.2rem",
              mb: 0.5,
            }}
          >
            Admin Portal
          </Typography>

          <Typography
            sx={{
              color: "#666",
              fontSize: "0.95rem",
              mb: 4,
            }}
          >
            Welcome back. Please enter your details.
          </Typography>

          <Box component="form" onSubmit={handleSubmit}>
            <Typography
              sx={{ fontWeight: 600, color: "#333", fontSize: "0.9rem", mb: 1 }}
            >
              Email or Mobile Number
            </Typography>
            <TextField
              fullWidth
              placeholder="Enter your email or mobile"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              sx={{ mb: 3 }}
              slotProps={{
                input: {
                  startAdornment: (
                    <InputAdornment position="start">
                      <EmailOutlined sx={{ color: "#999", fontSize: 22 }} />
                    </InputAdornment>
                  ),
                  sx: {
                    borderRadius: "12px",
                    bgcolor: "#fff",
                    fontSize: "0.95rem",
                    py: 0.5,
                  },
                },
              }}
            />

            <Typography
              sx={{ fontWeight: 600, color: "#333", fontSize: "0.9rem", mb: 1 }}
            >
              Password
            </Typography>
            <TextField
              fullWidth
              type={showPassword ? "text" : "password"}
              placeholder="Enter your password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              sx={{ mb: 2 }}
              slotProps={{
                input: {
                  startAdornment: (
                    <InputAdornment position="start">
                      <LockOutlined sx={{ color: "#999", fontSize: 22 }} />
                    </InputAdornment>
                  ),
                  endAdornment: (
                    <InputAdornment position="end">
                      <IconButton
                        onClick={() => setShowPassword(!showPassword)}
                        edge="end"
                        size="small"
                      >
                        {showPassword ? (
                          <VisibilityOff sx={{ fontSize: 22 }} />
                        ) : (
                          <Visibility sx={{ fontSize: 22 }} />
                        )}
                      </IconButton>
                    </InputAdornment>
                  ),
                  sx: {
                    borderRadius: "12px",
                    bgcolor: "#fff",
                    fontSize: "0.95rem",
                    py: 0.5,
                  },
                },
              }}
            />

            {error && (
              <Typography sx={{ color: "#c62828", fontSize: "0.85rem", mb: 1 }}>
                {error}
              </Typography>
            )}

            <Box
              sx={{
                display: "flex",
                justifyContent: "space-between",
                alignItems: "center",
                mb: 3,
              }}
            >
              <FormControlLabel
                control={
                  <Checkbox
                    checked={rememberMe}
                    onChange={(e) => setRememberMe(e.target.checked)}
                    size="small"
                  />
                }
                label={
                  <Typography sx={{ color: "#555", fontSize: "0.875rem" }}>
                    Remember Me
                  </Typography>
                }
              />
              <Link
                href="#"
                underline="none"
                sx={{
                  fontSize: "0.9rem",
                  color: "#1565c0",
                  fontWeight: 500,
                  "&:hover": { textDecoration: "underline" },
                }}
              >
                Forgot password
              </Link>
            </Box>

            <Button
              type="submit"
              fullWidth
              variant="contained"
              disabled={loading}
              sx={{
                py: 1.8,
                borderRadius: "12px",
                textTransform: "uppercase",
                fontWeight: 700,
                fontSize: "1rem",
                bgcolor: "#0d2744",
                "&:hover": {
                  bgcolor: "#1a3a5c",
                },
                boxShadow: "none",
                letterSpacing: 1.5,
              }}
            >
              {loading ? "Logging in..." : "Log In"}
            </Button>
          </Box>

          <Box sx={{ textAlign: "center", mt: 3 }}>
            <Link
              href="/register"
              underline="none"
              sx={{
                fontSize: "1.025rem",
                color: "#1565c0",
                fontWeight: 500,
                "&:hover": { textDecoration: "underline" },
              }}
            >
              Create an account
            </Link>
          </Box>

          <Typography
            sx={{
              textAlign: "center",
              color: "#bbb",
              fontSize: "0.85rem",
              mt: "auto",
              pt: 3,
            }}
          >
            Powered by CareNest.lk
          </Typography>
        </Box>
      </Box>
    </Box>
  );
}

export default Login;
