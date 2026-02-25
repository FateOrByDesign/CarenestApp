import { useState } from "react";
import { NavLink, useNavigate } from "react-router-dom";
import {
  Avatar,
  Badge,
  Box,
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
  PersonOutline,
  SettingsOutlined,
  LogoutOutlined,
} from "@mui/icons-material";

const navItems = [
  { label: "Dashboard", path: "/dashboard" },
  { label: "Caregiver Verification", path: "/caregivers" },
  { label: "Users", path: "/users" },
  { label: "Bookings", path: "/bookings" },
];

const notifications = [
  { title: "New caregiver application received", time: "2h ago" },
  { title: "Booking BK-1024 confirmed by caregiver", time: "3h ago" },
];

function Navbar() {
  const navigate = useNavigate();
  const [notifAnchor, setNotifAnchor] = useState(null);
  const [accountAnchor, setAccountAnchor] = useState(null);

  const handleLogout = () => {
    setAccountAnchor(null);
    localStorage.removeItem("token");
    localStorage.removeItem("role");
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
            onClick={(e) => setNotifAnchor(e.currentTarget)}
          >
            <Badge variant="dot" color="error">
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
                  width: 320,
                  borderRadius: "14px",
                  boxShadow: "0 8px 30px rgba(0,0,0,0.12)",
                  mt: 1,
                },
              },
            }}
          >
            <Box sx={{ px: 2.5, py: 1.5 }}>
              <Typography sx={{ fontSize: "0.95rem", fontWeight: 700, color: "#1a1a2e" }}>
                Notifications
              </Typography>
            </Box>
            <Divider />
            {notifications.map((n, i) => (
              <MenuItem
                key={i}
                onClick={() => setNotifAnchor(null)}
                sx={{
                  py: 1.5,
                  px: 2.5,
                  "&:hover": { bgcolor: "#f5f7fa" },
                }}
              >
                <Box>
                  <Typography sx={{ fontSize: "0.83rem", color: "#333", lineHeight: 1.4 }}>
                    {n.title}
                  </Typography>
                  <Typography sx={{ fontSize: "0.72rem", color: "#999", mt: 0.3 }}>
                    {n.time}
                  </Typography>
                </Box>
              </MenuItem>
            ))}
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
            src="https://i.pravatar.cc/40?img=12"
            onClick={(e) => setAccountAnchor(e.currentTarget)}
            sx={{
              width: 42,
              height: 42,
              border: "2px solid #e0e0e0",
              cursor: "pointer",
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
              onClick={() => {
                setAccountAnchor(null);
                navigate("/dashboard");
              }}
              sx={{ py: 1.2, px: 2.5 }}
            >
              <ListItemIcon>
                <PersonOutline sx={{ fontSize: 20, color: "#555" }} />
              </ListItemIcon>
              <ListItemText
                primary="My Account"
                primaryTypographyProps={{ fontSize: "0.85rem" }}
              />
            </MenuItem>
            <MenuItem
              onClick={() => {
                setAccountAnchor(null);
                navigate("/dashboard");
              }}
              sx={{ py: 1.2, px: 2.5 }}
            >
              <ListItemIcon>
                <SettingsOutlined sx={{ fontSize: 20, color: "#555" }} />
              </ListItemIcon>
              <ListItemText
                primary="Settings"
                primaryTypographyProps={{ fontSize: "0.85rem" }}
              />
            </MenuItem>
            <Divider />
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
