import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import {
  Avatar,
  Box,
  Button,
  Card,
  Chip,
  CircularProgress,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Typography,
} from "@mui/material";
import {
  PendingActions,
  EventNote,
  People,
  PersonSearch,
  ArrowForward,
} from "@mui/icons-material";
import Navbar from "../components/Navbar";
import API_BASE, { getAuthHeaders } from "../services/api";

const quickActions = [
  { label: "Review Applications", path: "/caregivers" },
  { label: "Manage Users", path: "/users" },
  { label: "View Bookings", path: "/bookings" },
];

const iconMap = {
  PendingActions,
  EventNote,
  People,
  PersonSearch,
};

const getStatusChipProps = (status) => {
  switch (status) {
    case "Pending":
      return { bgcolor: "#fff3e0", color: "#e65100" };
    case "Under Review":
      return { bgcolor: "#e3f2fd", color: "#1565c0" };
    case "Approved":
      return { bgcolor: "#e8f5e9", color: "#2e7d32" };
    case "Pending Confirmation":
      return { bgcolor: "#fff3e0", color: "#e65100" };
    case "Active":
      return { bgcolor: "#e3f2fd", color: "#1565c0" };
    case "Accepted":
      return { bgcolor: "#e3f2fd", color: "#1565c0" };
    case "Ongoing":
      return { bgcolor: "#ede7f6", color: "#5e35b1" };
    case "Completed":
      return { bgcolor: "#e8f5e9", color: "#2e7d32" };
    case "Cancelled":
      return { bgcolor: "#ffebee", color: "#c62828" };
    case "Rejected":
      return { bgcolor: "#ffebee", color: "#c62828" };
    default:
      return { bgcolor: "#f5f5f5", color: "#555" };
  }
};

function Dashboard() {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [stats, setStats] = useState({
    pendingApplications: 0,
    totalBookings: 0,
    totalUsers: 0,
    activeCaregivers: 0,
  });
  const [recentApplications, setRecentApplications] = useState([]);
  const [recentBookings, setRecentBookings] = useState([]);

  useEffect(() => {
    const fetchDashboardData = async () => {
      try {
        const headers = getAuthHeaders();
        const [statsRes, appsRes, bookingsRes] = await Promise.all([
          fetch(`${API_BASE}/dashboard/stats`, { headers }),
          fetch(`${API_BASE}/dashboard/recent-applications`, { headers }),
          fetch(`${API_BASE}/dashboard/recent-bookings`, { headers }),
        ]);

        const statsData = await statsRes.json();
        const appsData = await appsRes.json();
        const bookingsData = await bookingsRes.json();

        if (statsData.success) setStats(statsData.data);
        if (appsData.success) setRecentApplications(appsData.data);
        if (bookingsData.success) setRecentBookings(bookingsData.data);
      } catch (err) {
        console.error("Failed to fetch dashboard data:", err);
      } finally {
        setLoading(false);
      }
    };
    fetchDashboardData();
  }, []);

  const statsCards = [
    {
      label: "Pending Applications",
      value: stats.pendingApplications,
      sub: "Awaiting review",
      iconName: "PendingActions",
      bgColor: "#fff3e0",
      color: "#e65100",
    },
    {
      label: "Total Bookings",
      value: stats.totalBookings,
      sub: "All time",
      iconName: "EventNote",
      bgColor: "#e3f2fd",
      color: "#1565c0",
    },
    {
      label: "Total Users",
      value: stats.totalUsers,
      sub: "Registered users",
      iconName: "People",
      bgColor: "#e8f5e9",
      color: "#2e7d32",
    },
    {
      label: "Active Caregivers",
      value: stats.activeCaregivers,
      sub: "Verified & active",
      iconName: "PersonSearch",
      bgColor: "#f3e5f5",
      color: "#7b1fa2",
    },
  ];

  if (loading) {
    return (
      <Box
        sx={{
          width: "100vw",
          minHeight: "100vh",
          bgcolor: "#e8ecf0",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
        }}
      >
        <CircularProgress sx={{ color: "#1565c0" }} />
      </Box>
    );
  }

  return (
    <Box
      sx={{
        width: "100vw",
        minHeight: "100vh",
        bgcolor: "#e8ecf0",
        p: "20px",
        boxSizing: "border-box",
      }}
    >
      <Box
        sx={{
          width: "100%",
          minHeight: "calc(100vh - 40px)",
          bgcolor: "#fff",
          borderRadius: "24px",
          boxShadow: "0 8px 40px rgba(0,0,0,0.08)",
          display: "flex",
          flexDirection: "column",
          overflow: "hidden",
        }}
      >
        <Navbar />

        <Box sx={{ flex: 1, px: 5, py: 4, overflow: "auto" }}>
          <Box sx={{ textAlign: "center", mb: 4 }}>
            <Typography
              sx={{ fontSize: "2rem", fontWeight: 700, color: "#1a1a2e", mb: 0.5 }}
            >
              Dashboard
            </Typography>
            <Typography sx={{ fontSize: "0.95rem", color: "#888" }}>
              Platform overview and administrative controls.
            </Typography>
          </Box>

          <Box sx={{ display: "flex", gap: 3, mb: 4 }}>
            {statsCards.map((card) => {
              const IconComp = iconMap[card.iconName];
              return (
                <Card
                  key={card.label}
                  elevation={0}
                  sx={{
                    flex: 1,
                    display: "flex",
                    alignItems: "center",
                    gap: 2.5,
                    px: 3,
                    py: 3,
                    border: "1px solid #ebebeb",
                    borderRadius: "16px",
                    transition: "box-shadow 0.2s, transform 0.2s",
                    "&:hover": {
                      boxShadow: "0 4px 20px rgba(0,0,0,0.06)",
                      transform: "translateY(-2px)",
                    },
                  }}
                >
                  <Box
                    sx={{
                      width: 48,
                      height: 48,
                      borderRadius: "50%",
                      bgcolor: card.bgColor,
                      display: "flex",
                      alignItems: "center",
                      justifyContent: "center",
                      border: `2px solid ${card.color}`,
                      flexShrink: 0,
                    }}
                  >
                    {IconComp && <IconComp sx={{ color: card.color, fontSize: 22 }} />}
                  </Box>
                  <Box>
                    <Typography sx={{ fontSize: "0.78rem", color: "#999", fontWeight: 500 }}>
                      {card.label}
                    </Typography>
                    <Typography
                      sx={{ fontSize: "1.7rem", fontWeight: 700, color: "#1a1a2e", lineHeight: 1.2 }}
                    >
                      {card.value}
                    </Typography>
                    <Typography sx={{ fontSize: "0.72rem", color: card.color, fontWeight: 500 }}>
                      {card.sub}
                    </Typography>
                  </Box>
                </Card>
              );
            })}
          </Box>

          <Card
            elevation={0}
            sx={{
              display: "flex",
              alignItems: "center",
              gap: 2,
              px: 3,
              py: 2,
              mb: 4,
              border: "1px solid #ebebeb",
              borderRadius: "14px",
              bgcolor: "#fafbfc",
            }}
          >
            <Typography sx={{ fontSize: "0.85rem", fontWeight: 600, color: "#555", mr: 1 }}>
              Quick Actions
            </Typography>
            {quickActions.map((action) => (
              <Button
                key={action.label}
                variant="outlined"
                size="small"
                endIcon={<ArrowForward sx={{ fontSize: 14 }} />}
                onClick={() => navigate(action.path)}
                sx={{
                  borderRadius: "10px",
                  textTransform: "none",
                  fontSize: "0.82rem",
                  fontWeight: 500,
                  borderColor: "#ddd",
                  color: "#1565c0",
                  px: 2.5,
                  "&:hover": { bgcolor: "rgba(21,101,192,0.04)", borderColor: "#1565c0" },
                }}
              >
                {action.label}
              </Button>
            ))}
          </Card>

          <Box sx={{ display: "flex", gap: 3 }}>
            <Card
              elevation={0}
              sx={{
                flex: 1.2,
                border: "1px solid #ebebeb",
                borderRadius: "18px",
                p: 3,
                display: "flex",
                flexDirection: "column",
                height: 420,
              }}
            >
              <Box
                sx={{
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "space-between",
                  mb: 2,
                  flexShrink: 0,
                }}
              >
                <Typography sx={{ fontSize: "1.1rem", fontWeight: 700, color: "#1a1a2e" }}>
                  Recent Caregiver Applications
                </Typography>
                <Button
                  size="small"
                  onClick={() => navigate("/caregivers")}
                  sx={{ textTransform: "none", fontSize: "0.8rem", color: "#1565c0", fontWeight: 500 }}
                >
                  View all
                </Button>
              </Box>
              <TableContainer sx={{ flex: 1, overflowY: "auto" }}>
                <Table size="small" stickyHeader>
                  <TableHead>
                    <TableRow>
                      {["Applicant", "Submitted", "Status", "Action"].map((h) => (
                        <TableCell
                          key={h}
                          sx={{
                            fontWeight: 700,
                            fontSize: "0.78rem",
                            color: "#888",
                            borderBottom: "2px solid #f0f0f0",
                            py: 1.5,
                            bgcolor: "#fff",
                          }}
                        >
                          {h}
                        </TableCell>
                      ))}
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {recentApplications.map((row, i) => {
                      const chipProps = getStatusChipProps(row.status);
                      return (
                        <TableRow key={row.id} sx={{ "&:hover": { bgcolor: "#fafbfc" } }}>
                          <TableCell sx={{ py: 2, borderBottom: "1px solid #f5f5f5" }}>
                            <Box sx={{ display: "flex", alignItems: "center", gap: 1.5 }}>
                              <Avatar
                                src={`https://i.pravatar.cc/32?img=${i + 20}`}
                                sx={{ width: 34, height: 34 }}
                              />
                              <Typography sx={{ fontSize: "0.85rem", fontWeight: 500 }}>
                                {row.name}
                              </Typography>
                            </Box>
                          </TableCell>
                          <TableCell
                            sx={{ fontSize: "0.83rem", color: "#666", borderBottom: "1px solid #f5f5f5" }}
                          >
                            {row.submitted_date}
                          </TableCell>
                          <TableCell sx={{ borderBottom: "1px solid #f5f5f5" }}>
                            <Chip
                              label={row.status}
                              size="small"
                              sx={{
                                bgcolor: chipProps.bgcolor,
                                color: chipProps.color,
                                fontWeight: 600,
                                fontSize: "0.7rem",
                                height: 26,
                              }}
                            />
                          </TableCell>
                          <TableCell sx={{ borderBottom: "1px solid #f5f5f5" }}>
                            <Button
                              size="small"
                              onClick={() => navigate("/caregivers")}
                              sx={{
                                fontSize: "0.78rem",
                                color: "#1565c0",
                                textTransform: "none",
                                fontWeight: 500,
                                minWidth: 0,
                                p: 0,
                              }}
                            >
                              Review
                            </Button>
                          </TableCell>
                        </TableRow>
                      );
                    })}
                  </TableBody>
                </Table>
              </TableContainer>
            </Card>

            <Card
              elevation={0}
              sx={{
                flex: 1,
                border: "1px solid #ebebeb",
                borderRadius: "18px",
                p: 3,
                display: "flex",
                flexDirection: "column",
                height: 420,
              }}
            >
              <Box
                sx={{
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "space-between",
                  mb: 2,
                  flexShrink: 0,
                }}
              >
                <Typography sx={{ fontSize: "1.1rem", fontWeight: 700, color: "#1a1a2e" }}>
                  Recent Bookings
                </Typography>
                <Button
                  size="small"
                  onClick={() => navigate("/bookings")}
                  sx={{ textTransform: "none", fontSize: "0.8rem", color: "#1565c0", fontWeight: 500 }}
                >
                  View all
                </Button>
              </Box>
              <TableContainer sx={{ flex: 1, overflowY: "auto" }}>
                <Table size="small" stickyHeader>
                  <TableHead>
                    <TableRow>
                      {["Booking", "Patient", "Caregiver", "Status"].map((h) => (
                        <TableCell
                          key={h}
                          sx={{
                            fontWeight: 700,
                            fontSize: "0.78rem",
                            color: "#888",
                            borderBottom: "2px solid #f0f0f0",
                            py: 1.5,
                            bgcolor: "#fff",
                          }}
                        >
                          {h}
                        </TableCell>
                      ))}
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {recentBookings.map((row) => {
                      const chipProps = getStatusChipProps(row.status);
                      return (
                        <TableRow key={row.id} sx={{ "&:hover": { bgcolor: "#fafbfc" } }}>
                          <TableCell
                            sx={{
                              fontSize: "0.83rem",
                              fontWeight: 600,
                              color: "#1565c0",
                              borderBottom: "1px solid #f5f5f5",
                              py: 2,
                            }}
                          >
                            {row.id}
                          </TableCell>
                          <TableCell
                            sx={{ fontSize: "0.83rem", color: "#444", borderBottom: "1px solid #f5f5f5" }}
                          >
                            {row.family_name}
                          </TableCell>
                          <TableCell
                            sx={{ fontSize: "0.83rem", color: "#666", borderBottom: "1px solid #f5f5f5" }}
                          >
                            {row.caregiver_name}
                          </TableCell>
                          <TableCell sx={{ borderBottom: "1px solid #f5f5f5" }}>
                            <Chip
                              label={row.status}
                              size="small"
                              sx={{
                                bgcolor: chipProps.bgcolor,
                                color: chipProps.color,
                                fontWeight: 600,
                                fontSize: "0.68rem",
                                height: 26,
                              }}
                            />
                          </TableCell>
                        </TableRow>
                      );
                    })}
                  </TableBody>
                </Table>
              </TableContainer>
            </Card>
          </Box>
        </Box>
      </Box>
    </Box>
  );
}

export default Dashboard;
