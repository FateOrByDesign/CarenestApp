import { useState } from "react";
import { NavLink, useNavigate } from "react-router-dom";
import {
  Avatar,
  Badge,
  Box,
  CircularProgress,
  Divider,
  IconButton,
  ListItemIcon,
  ListItemText,
  Menu,
  MenuItem,
  Typography,
} from "@mui/material";
import {
  NotificationsNoneOutlined,
  LogoutOutlined,
} from "@mui/icons-material";
import CareNestLogo from "../assets/carenest_logo.png";
import API_BASE, { getAuthHeaders } from "../services/api";

const navItems = [
  { label: "Dashboard", path: "/dashboard" },
  { label: "Caregiver Verification", path: "/caregivers" },
  { label: "Users", path: "/users" },
  { label: "Bookings", path: "/bookings" },
];

function formatTimeAgo(timestamp) {
  const now = new Date();
  const date = new Date(timestamp);
  const seconds = Math.floor((now - date) / 1000);

  if (seconds < 60) return "Just now";
  const minutes = Math.floor(seconds / 60);
  if (minutes < 60) return `${minutes}m ago`;
  const hours = Math.floor(minutes / 60);
  if (hours < 24) return `${hours}h ago`;
  const days = Math.floor(hours / 24);
  if (days < 7) return `${days}d ago`;
  return date.toLocaleDateString();
}

function Navbar() {
  const navigate = useNavigate();
  const [notifAnchor, setNotifAnchor] = useState(null);
  const [accountAnchor, setAccountAnchor] = useState(null);
  const [notifications, setNotifications] = useState([]);
  const [notifLoading, setNotifLoading] = useState(false);

  const handleNotifOpen = async (e) => {
    setNotifAnchor(e.currentTarget);
    const clearedAt = localStorage.getItem("notifClearedAt");
    if (clearedAt) return;
    setNotifLoading(true);
    try {
      const res = await fetch(`${API_BASE}/notifications/activity?limit=10`, {
        headers: getAuthHeaders(),
      });
      const data = await res.json();
      if (data.success) {
        setNotifications(data.data);
      }
    } catch (err) {
      console.error("Failed to fetch notifications:", err);
    } finally {
      setNotifLoading(false);
    }
  };

  const handleClearNotifications = () => {
    setNotifications([]);
    localStorage.setItem("notifClearedAt", new Date().toISOString());
    setNotifAnchor(null);
  };

  const handleLogout = () => {
    setAccountAnchor(null);
    localStorage.removeItem("token");
    localStorage.removeItem("role");
    localStorage.removeItem("adminName");
    localStorage.removeItem("notifClearedAt");
    navigate("/");
  };

  return (
    <Box>
      <Box
        sx={{
          display: "flex",
          alignItems: "center",
          justifyContent: "space-between",
          px: 5,
          py: 2,
        }}
      >
        <Box sx={{ display: "flex", alignItems: "center", gap: 6 }}>
          <Typography
            sx={{
              fontWeight: 700,
              fontSize: "1.7rem",
              color: "#1565c0",
              letterSpacing: -0.5,
            }}
          >
            CareNest.lk
          </Typography>
          <Box sx={{ display: "flex", gap: 0.5 }}>
            {navItems.map((item) => (
              <NavLink
                key={item.label}
                to={item.path}
                style={{ textDecoration: "none" }}
              >
                {({ isActive }) => (
                  <Box
                    sx={{
                      px: 2,
                      py: 1.2,
                      cursor: "pointer",
                      borderBottom: isActive
                        ? "2.5px solid #1565c0"
                        : "2.5px solid transparent",
                      transition: "border-color 0.2s",
                      "&:hover": {
                        borderBottom: isActive
                          ? "2.5px solid #1565c0"
                          : "2.5px solid #ccc",
                      },
                    }}
                  >
                    <Typography
                      sx={{
                        fontSize: "0.9rem",
                        fontWeight: isActive ? 600 : 400,
                        color: isActive ? "#1565c0" : "#777",
                      }}
                    >
                      {item.label}
                    </Typography>
                  </Box>
                )}
              </NavLink>
            ))}
          </Box>
        </Box>

        <Box sx={{ display: "flex", alignItems: "center", gap: 2 }}>
          {/* Notification Bell */}
          <IconButton
            sx={{ color: "#555" }}
            onClick={handleNotifOpen}
          >
            <Badge
              variant="dot"
              color="error"
              invisible={notifications.length === 0}
            >
              <NotificationsNoneOutlined sx={{ fontSize: 26 }} />
            </Badge>
          </IconButton>
          <Menu
            anchorEl={notifAnchor}
            open={Boolean(notifAnchor)}
            onClose={() => setNotifAnchor(null)}
            anchorOrigin={{ vertical: "bottom", horizontal: "right" }}
            transformOrigin={{ vertical: "top", horizontal: "right" }}
            slotProps={{
              paper: {
                sx: {
                  width: 340,
                  borderRadius: "14px",
                  boxShadow: "0 8px 30px rgba(0,0,0,0.12)",
                  mt: 1,
                },
              },
            }}
          >
            <Box sx={{ px: 2.5, py: 1.5, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
              <Typography sx={{ fontSize: "0.95rem", fontWeight: 700, color: "#1a1a2e" }}>
                Notifications
              </Typography>
              {notifications.length > 0 && (
                <Typography
                  onClick={handleClearNotifications}
                  sx={{
                    fontSize: "0.75rem",
                    color: "#1565c0",
                    fontWeight: 600,
                    cursor: "pointer",
                    "&:hover": { textDecoration: "underline" },
                  }}
                >
                  Clear all
                </Typography>
              )}
            </Box>
            <Divider />
            {notifLoading ? (
              <Box sx={{ display: "flex", justifyContent: "center", py: 3 }}>
                <CircularProgress size={22} />
              </Box>
            ) : notifications.length === 0 ? (
              <MenuItem disabled sx={{ py: 2, px: 2.5 }}>
                <Typography sx={{ fontSize: "0.83rem", color: "#999" }}>
                  No recent activity
                </Typography>
              </MenuItem>
            ) : (
              notifications.map((n) => (
                <MenuItem
                  key={n.id}
                  onClick={() => setNotifAnchor(null)}
                  sx={{
                    py: 1.5,
                    px: 2.5,
                    whiteSpace: "normal",
                    "&:hover": { bgcolor: "#f5f7fa" },
                  }}
                >
                  <Box>
                    <Typography sx={{ fontSize: "0.83rem", color: "#333", lineHeight: 1.4 }}>
                      {n.title}
                    </Typography>
                    <Typography sx={{ fontSize: "0.72rem", color: "#999", mt: 0.3 }}>
                      {formatTimeAgo(n.timestamp)}
                    </Typography>
                  </Box>
                </MenuItem>
              ))
            )}
            <Divider />
            <MenuItem
              onClick={() => {
                setNotifAnchor(null);
                navigate("/dashboard");
              }}
              sx={{
                justifyContent: "center",
                py: 1.2,
              }}
            >
              <Typography sx={{ fontSize: "0.82rem", color: "#1565c0", fontWeight: 600 }}>
                View all
              </Typography>
            </MenuItem>
          </Menu>

          {/* Account Avatar */}
          <Avatar
            src={CareNestLogo}
            onClick={(e) => setAccountAnchor(e.currentTarget)}
            sx={{
              width: 42,
              height: 42,
              border: "2px solid #e0e0e0",
              cursor: "pointer",
              bgcolor: "#1565c0",
            }}
          />
          <Menu
            anchorEl={accountAnchor}
            open={Boolean(accountAnchor)}
            onClose={() => setAccountAnchor(null)}
            anchorOrigin={{ vertical: "bottom", horizontal: "right" }}
            transformOrigin={{ vertical: "top", horizontal: "right" }}
            slotProps={{
              paper: {
                sx: {
                  width: 200,
                  borderRadius: "12px",
                  boxShadow: "0 8px 30px rgba(0,0,0,0.12)",
                  mt: 1,
                },
              },
            }}
          >
            <MenuItem
              onClick={handleLogout}
              sx={{ py: 1.2, px: 2.5 }}
            >
              <ListItemIcon>
                <LogoutOutlined sx={{ fontSize: 20, color: "#e53935" }} />
              </ListItemIcon>
              <ListItemText
                primary="Logout"
                primaryTypographyProps={{ fontSize: "0.85rem", color: "#e53935" }}
              />
            </MenuItem>
          </Menu>
        </Box>
      </Box>
      <Divider sx={{ borderColor: "#f0f0f0" }} />
    </Box>
  );
}

export default Navbar;
