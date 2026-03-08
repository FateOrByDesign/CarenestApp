import { useState, useEffect } from "react";
import {
  Box,
  Button,
  Card,
  Chip,
  CircularProgress,
  Dialog,
  DialogContent,
  DialogActions,
  Divider,
  IconButton,
  InputAdornment,
  MenuItem,
  Select,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  TextField,
  Typography,
} from "@mui/material";
import {
  Search,
  Close,
  FilterAltOff,
  CalendarMonth,
  AccessTime,
  LocationOn,
  Email,
  Phone,
  PersonOutline,
  Flag,
  LocalHospital,
  Home,
  Payment,
  ConfirmationNumber,
} from "@mui/icons-material";
import Navbar from "../components/Navbar";

const API_BASE = "http://localhost:5001/api";

const getAuthHeaders = () => ({
  "Content-Type": "application/json",
  Authorization: `Bearer ${localStorage.getItem("token")}`,
});

const getStatusChipProps = (status) => {
  switch (status) {
    case "Pending":
      return { bgcolor: "#fff3e0", color: "#e65100" };
    case "Accepted":
      return { bgcolor: "#e3f2fd", color: "#1565c0" };
    case "Ongoing":
      return { bgcolor: "#ede7f6", color: "#5e35b1" };
    case "Completed":
      return { bgcolor: "#e8f5e9", color: "#2e7d32" };
    case "Cancelled":
      return { bgcolor: "#ffebee", color: "#c62828" };
    default:
      return { bgcolor: "#f5f5f5", color: "#555" };
  }
};

const getServiceChipProps = (type) => {
  switch (type) {
    case "Hospital":
      return { bgcolor: "#e3f2fd", color: "#1565c0", icon: <LocalHospital sx={{ fontSize: 14 }} /> };
    case "Home Visit":
      return { bgcolor: "#fff3e0", color: "#e65100", icon: <Home sx={{ fontSize: 14 }} /> };
    default:
      return { bgcolor: "#f5f5f5", color: "#555", icon: null };
  }
};

const getPaymentChipProps = (status) => {
  switch (status) {
    case "Paid":
      return { bgcolor: "#e8f5e9", color: "#2e7d32" };
    case "Unpaid":
      return { bgcolor: "#fff3e0", color: "#e65100" };
    case "Refunded":
      return { bgcolor: "#e3f2fd", color: "#1565c0" };
    default:
      return { bgcolor: "#f5f5f5", color: "#555" };
  }
};

function Bookings() {
  const [bookings, setBookings] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState("");
  const [statusFilter, setStatusFilter] = useState("All");
  const [serviceFilter, setServiceFilter] = useState("All");
  const [dateFrom, setDateFrom] = useState("");
  const [dateTo, setDateTo] = useState("");
  const [selectedBooking, setSelectedBooking] = useState(null);
  const [detailOpen, setDetailOpen] = useState(false);
  const [actionLoading, setActionLoading] = useState(false);

  const fetchBookings = async () => {
    try {
      const params = new URLSearchParams();
      if (statusFilter !== "All") params.append("status", statusFilter);
      if (serviceFilter !== "All") params.append("serviceType", serviceFilter);
      if (searchQuery) params.append("search", searchQuery);
      if (dateFrom) params.append("from", dateFrom);
      if (dateTo) params.append("to", dateTo);

      const res = await fetch(`${API_BASE}/bookings?${params}`, {
        headers: getAuthHeaders(),
      });
      const data = await res.json();
      if (data.success) setBookings(data.data);
    } catch (err) {
      console.error("Failed to fetch bookings:", err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchBookings();
  }, [statusFilter, serviceFilter, searchQuery, dateFrom, dateTo]);

  const handleView = (booking) => {
    setSelectedBooking(booking);
    setDetailOpen(true);
  };

  const handleClose = () => {
    setDetailOpen(false);
    setSelectedBooking(null);
  };

  const handleFlag = async () => {
    if (!selectedBooking) return;
    setActionLoading(true);
    try {
      const res = await fetch(`${API_BASE}/bookings/${selectedBooking.id}/flag`, {
        method: "PATCH",
        headers: getAuthHeaders(),
      });
      const data = await res.json();
      if (data.success) {
        const newFlagged = data.data.flagged;
        setBookings((prev) =>
          prev.map((b) =>
            b.id === selectedBooking.id ? { ...b, flagged: newFlagged } : b
          )
        );
        setSelectedBooking((prev) => ({ ...prev, flagged: newFlagged }));
      }
    } catch (err) {
      console.error("Failed to toggle flag:", err);
    } finally {
      setActionLoading(false);
    }
  };

  const clearFilters = () => {
    setSearchQuery("");
    setStatusFilter("All");
    setServiceFilter("All");
    setDateFrom("");
    setDateTo("");
  };

  const hasFilters =
    searchQuery !== "" ||
    statusFilter !== "All" ||
    serviceFilter !== "All" ||
    dateFrom !== "" ||
    dateTo !== "";

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
          {/* Header */}
          <Box sx={{ textAlign: "center", mb: 4 }}>
            <Typography
              sx={{ fontSize: "2rem", fontWeight: 700, color: "#1a1a2e", mb: 0.5 }}
            >
              Bookings
            </Typography>
            <Typography sx={{ fontSize: "0.95rem", color: "#888" }}>
              Monitor bookings and track session status.
            </Typography>
          </Box>

          {/* Filter / Search Card */}
          <Card
            elevation={0}
            sx={{
              display: "flex",
              alignItems: "center",
              gap: 2,
              px: 3,
              py: 2,
              mb: 3,
              border: "1px solid #ebebeb",
              borderRadius: "14px",
              bgcolor: "#fafbfc",
              flexWrap: "wrap",
            }}
          >
            <TextField
              placeholder="Search by ID, family, or caregiver..."
              size="small"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              sx={{
                flex: 1,
                minWidth: 240,
                "& .MuiOutlinedInput-root": {
                  borderRadius: "10px",
                  fontSize: "0.88rem",
                  bgcolor: "#fff",
                },
              }}
              InputProps={{
                startAdornment: (
                  <InputAdornment position="start">
                    <Search sx={{ color: "#aaa", fontSize: 20 }} />
                  </InputAdornment>
                ),
              }}
            />
            <Select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
              size="small"
              sx={{ minWidth: 140, borderRadius: "10px", fontSize: "0.88rem", bgcolor: "#fff" }}
            >
              <MenuItem value="All">All Statuses</MenuItem>
              <MenuItem value="Pending">Pending</MenuItem>
              <MenuItem value="Accepted">Accepted</MenuItem>
              <MenuItem value="Ongoing">Ongoing</MenuItem>
              <MenuItem value="Completed">Completed</MenuItem>
              <MenuItem value="Cancelled">Cancelled</MenuItem>
            </Select>
            <Select
              value={serviceFilter}
              onChange={(e) => setServiceFilter(e.target.value)}
              size="small"
              sx={{ minWidth: 150, borderRadius: "10px", fontSize: "0.88rem", bgcolor: "#fff" }}
            >
              <MenuItem value="All">All Services</MenuItem>
              <MenuItem value="Hospital">Hospital</MenuItem>
              <MenuItem value="Home Visit">Home Visit</MenuItem>
            </Select>
            <TextField
              type="date"
              size="small"
              label="From"
              value={dateFrom}
              onChange={(e) => setDateFrom(e.target.value)}
              InputLabelProps={{ shrink: true }}
              sx={{
                width: 155,
                "& .MuiOutlinedInput-root": {
                  borderRadius: "10px",
                  fontSize: "0.84rem",
                  bgcolor: "#fff",
                },
                "& .MuiInputLabel-root": { fontSize: "0.82rem" },
              }}
            />
            <TextField
              type="date"
              size="small"
              label="To"
              value={dateTo}
              onChange={(e) => setDateTo(e.target.value)}
              InputLabelProps={{ shrink: true }}
              sx={{
                width: 155,
                "& .MuiOutlinedInput-root": {
                  borderRadius: "10px",
                  fontSize: "0.84rem",
                  bgcolor: "#fff",
                },
                "& .MuiInputLabel-root": { fontSize: "0.82rem" },
              }}
            />
            {hasFilters && (
              <Button
                size="small"
                startIcon={<FilterAltOff sx={{ fontSize: 16 }} />}
                onClick={clearFilters}
                sx={{
                  textTransform: "none",
                  fontSize: "0.82rem",
                  fontWeight: 500,
                  color: "#999",
                  borderRadius: "10px",
                  border: "1px solid #e0e0e0",
                  px: 2,
                  "&:hover": { bgcolor: "#f5f5f5", borderColor: "#ccc" },
                }}
              >
                Clear
              </Button>
            )}
            <Typography sx={{ fontSize: "0.82rem", color: "#888", ml: "auto", whiteSpace: "nowrap" }}>
              {bookings.length} result{bookings.length !== 1 ? "s" : ""}
            </Typography>
          </Card>

          {/* Table Card */}
          <Card
            elevation={0}
            sx={{
              border: "1px solid #ebebeb",
              borderRadius: "18px",
              p: 3,
              display: "flex",
              flexDirection: "column",
              height: 520,
            }}
          >
            <TableContainer sx={{ flex: 1, overflowY: "auto" }}>
              <Table size="small" stickyHeader>
                <TableHead>
                  <TableRow>
                    {[
                      "Booking ID",
                      "Service Type",
                      "Family",
                      "Caregiver",
                      "Date & Time",
                      "Status",
                      "Action",
                    ].map((h) => (
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
                  {bookings.length === 0 ? (
                    <TableRow>
                      <TableCell colSpan={7} sx={{ textAlign: "center", py: 6 }}>
                        <Typography sx={{ color: "#aaa", fontSize: "0.9rem" }}>
                          No bookings found.
                        </Typography>
                      </TableCell>
                    </TableRow>
                  ) : (
                    bookings.map((row) => {
                      const statusProps = getStatusChipProps(row.status);
                      const serviceProps = getServiceChipProps(row.serviceType);
                      return (
                        <TableRow
                          key={row.id}
                          sx={{
                            "&:hover": { bgcolor: "#fafbfc" },
                            bgcolor: row.flagged ? "#fffde7" : "transparent",
                          }}
                        >
                          <TableCell
                            sx={{
                              py: 2,
                              borderBottom: "1px solid #f5f5f5",
                              fontWeight: 600,
                              fontSize: "0.85rem",
                              color: "#1565c0",
                            }}
                          >
                            <Box sx={{ display: "flex", alignItems: "center", gap: 0.8 }}>
                              {row.id}
                              {row.flagged && (
                                <Flag sx={{ fontSize: 15, color: "#e65100" }} />
                              )}
                            </Box>
                          </TableCell>
                          <TableCell sx={{ borderBottom: "1px solid #f5f5f5" }}>
                            <Chip
                              icon={serviceProps.icon}
                              label={row.serviceType}
                              size="small"
                              sx={{
                                bgcolor: serviceProps.bgcolor,
                                color: serviceProps.color,
                                fontWeight: 600,
                                fontSize: "0.7rem",
                                height: 26,
                                "& .MuiChip-icon": { color: serviceProps.color },
                              }}
                            />
                          </TableCell>
                          <TableCell sx={{ py: 2, borderBottom: "1px solid #f5f5f5" }}>
                            <Typography
                              sx={{ fontSize: "0.85rem", fontWeight: 500, color: "#1a1a2e" }}
                            >
                              {row.family.name}
                            </Typography>
                          </TableCell>
                          <TableCell sx={{ py: 2, borderBottom: "1px solid #f5f5f5" }}>
                            <Typography
                              sx={{ fontSize: "0.85rem", fontWeight: 500, color: "#1a1a2e" }}
                            >
                              {row.caregiver.name}
                            </Typography>
                          </TableCell>
                          <TableCell sx={{ borderBottom: "1px solid #f5f5f5" }}>
                            <Typography sx={{ fontSize: "0.83rem", color: "#444", fontWeight: 500 }}>
                              {row.date}
                            </Typography>
                            <Typography sx={{ fontSize: "0.72rem", color: "#999" }}>
                              {row.timeSlot}
                            </Typography>
                          </TableCell>
                          <TableCell sx={{ borderBottom: "1px solid #f5f5f5" }}>
                            <Chip
                              label={row.status}
                              size="small"
                              sx={{
                                bgcolor: statusProps.bgcolor,
                                color: statusProps.color,
                                fontWeight: 600,
                                fontSize: "0.7rem",
                                height: 26,
                              }}
                            />
                          </TableCell>
                          <TableCell sx={{ borderBottom: "1px solid #f5f5f5" }}>
                            <Button
                              size="small"
                              onClick={() => handleView(row)}
                              sx={{
                                fontSize: "0.78rem",
                                color: "#1565c0",
                                textTransform: "none",
                                fontWeight: 600,
                                minWidth: 0,
                                px: 2,
                                py: 0.5,
                                borderRadius: "8px",
                                border: "1px solid #e0e0e0",
                                "&:hover": {
                                  bgcolor: "rgba(21,101,192,0.04)",
                                  borderColor: "#1565c0",
                                },
                              }}
                            >
                              View
                            </Button>
                          </TableCell>
                        </TableRow>
                      );
                    })
                  )}
                </TableBody>
              </Table>
            </TableContainer>
          </Card>
        </Box>
      </Box>

      {/* Detail Dialog */}
      <Dialog
        open={detailOpen}
        onClose={handleClose}
        maxWidth="sm"
        fullWidth
        PaperProps={{
          sx: {
            borderRadius: "20px",
            p: 0,
            overflow: "hidden",
          },
        }}
      >
        {selectedBooking && (() => {
          const statusProps = getStatusChipProps(selectedBooking.status);
          const serviceProps = getServiceChipProps(selectedBooking.serviceType);
          const paymentProps = selectedBooking.paymentStatus
            ? getPaymentChipProps(selectedBooking.paymentStatus)
            : null;

          return (
            <>
              {/* Dialog Header */}
              <Box
                sx={{
                  background: "linear-gradient(135deg, #1565c0 0%, #0d47a1 100%)",
                  px: 3.5,
                  py: 3,
                  display: "flex",
                  alignItems: "center",
                  gap: 2,
                }}
              >
                <Box
                  sx={{
                    width: 50,
                    height: 50,
                    borderRadius: "14px",
                    bgcolor: "rgba(255,255,255,0.15)",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                  }}
                >
                  <ConfirmationNumber sx={{ color: "#fff", fontSize: 26 }} />
                </Box>
                <Box sx={{ flex: 1 }}>
                  <Typography
                    sx={{ fontSize: "1.25rem", fontWeight: 700, color: "#fff" }}
                  >
                    {selectedBooking.id}
                  </Typography>
                  <Typography sx={{ fontSize: "0.85rem", color: "rgba(255,255,255,0.7)" }}>
                    Created {selectedBooking.createdAt}
                  </Typography>
                </Box>
                <Chip
                  label={selectedBooking.status}
                  size="small"
                  sx={{
                    bgcolor: "rgba(255,255,255,0.2)",
                    color: "#fff",
                    fontWeight: 600,
                    fontSize: "0.75rem",
                  }}
                />
                {selectedBooking.flagged && (
                  <Chip
                    icon={<Flag sx={{ fontSize: 14, color: "#fff" }} />}
                    label="Flagged"
                    size="small"
                    sx={{
                      bgcolor: "rgba(230,81,0,0.4)",
                      color: "#fff",
                      fontWeight: 600,
                      fontSize: "0.75rem",
                      "& .MuiChip-icon": { color: "#fff" },
                    }}
                  />
                )}
                <IconButton onClick={handleClose} sx={{ color: "rgba(255,255,255,0.7)" }}>
                  <Close />
                </IconButton>
              </Box>

              <DialogContent sx={{ px: 3.5, py: 3 }}>
                {/* Session Info */}
                <Typography
                  sx={{
                    fontSize: "0.75rem",
                    fontWeight: 700,
                    color: "#999",
                    textTransform: "uppercase",
                    letterSpacing: 1,
                    mb: 1.5,
                  }}
                >
                  Session Details
                </Typography>
                <Box sx={{ display: "flex", flexDirection: "column", gap: 1.5, mb: 3 }}>
                  <Box sx={{ display: "flex", alignItems: "center", gap: 1.5 }}>
                    {selectedBooking.serviceType === "Hospital" ? (
                      <LocalHospital sx={{ fontSize: 18, color: "#1565c0" }} />
                    ) : (
                      <Home sx={{ fontSize: 18, color: "#e65100" }} />
                    )}
                    <Typography sx={{ fontSize: "0.9rem", color: "#444" }}>
                      {selectedBooking.serviceType}
                    </Typography>
                    <Chip
                      label={selectedBooking.status}
                      size="small"
                      sx={{
                        bgcolor: statusProps.bgcolor,
                        color: statusProps.color,
                        fontWeight: 600,
                        fontSize: "0.7rem",
                        height: 24,
                        ml: 1,
                      }}
                    />
                  </Box>
                  <Box sx={{ display: "flex", alignItems: "center", gap: 1.5 }}>
                    <CalendarMonth sx={{ fontSize: 18, color: "#1565c0" }} />
                    <Typography sx={{ fontSize: "0.9rem", color: "#444" }}>
                      {selectedBooking.date}
                    </Typography>
                  </Box>
                  <Box sx={{ display: "flex", alignItems: "center", gap: 1.5 }}>
                    <AccessTime sx={{ fontSize: 18, color: "#1565c0" }} />
                    <Typography sx={{ fontSize: "0.9rem", color: "#444" }}>
                      {selectedBooking.timeSlot}
                    </Typography>
                  </Box>
                  <Box sx={{ display: "flex", alignItems: "center", gap: 1.5 }}>
                    <LocationOn sx={{ fontSize: 18, color: "#1565c0" }} />
                    <Typography sx={{ fontSize: "0.9rem", color: "#444" }}>
                      {selectedBooking.location}
                    </Typography>
                  </Box>
                  {paymentProps && (
                    <Box sx={{ display: "flex", alignItems: "center", gap: 1.5 }}>
                      <Payment sx={{ fontSize: 18, color: "#1565c0" }} />
                      <Typography sx={{ fontSize: "0.9rem", color: "#444", mr: 1 }}>
                        Payment:
                      </Typography>
                      <Chip
                        label={selectedBooking.paymentStatus}
                        size="small"
                        sx={{
                          bgcolor: paymentProps.bgcolor,
                          color: paymentProps.color,
                          fontWeight: 600,
                          fontSize: "0.7rem",
                          height: 24,
                        }}
                      />
                    </Box>
                  )}
                </Box>

                <Divider sx={{ mb: 3 }} />

                {/* Family Details */}
                <Typography
                  sx={{
                    fontSize: "0.75rem",
                    fontWeight: 700,
                    color: "#999",
                    textTransform: "uppercase",
                    letterSpacing: 1,
                    mb: 1.5,
                  }}
                >
                  Family
                </Typography>
                <Box sx={{ display: "flex", flexDirection: "column", gap: 1.5, mb: 3 }}>
                  <Box sx={{ display: "flex", alignItems: "center", gap: 1.5 }}>
                    <PersonOutline sx={{ fontSize: 18, color: "#1565c0" }} />
                    <Typography sx={{ fontSize: "0.9rem", color: "#444", fontWeight: 500 }}>
                      {selectedBooking.family.name}
                    </Typography>
                  </Box>
                  <Box sx={{ display: "flex", alignItems: "center", gap: 1.5 }}>
                    <Email sx={{ fontSize: 18, color: "#1565c0" }} />
                    <Typography sx={{ fontSize: "0.9rem", color: "#444" }}>
                      {selectedBooking.family.email}
                    </Typography>
                  </Box>
                  <Box sx={{ display: "flex", alignItems: "center", gap: 1.5 }}>
                    <Phone sx={{ fontSize: 18, color: "#1565c0" }} />
                    <Typography sx={{ fontSize: "0.9rem", color: "#444" }}>
                      {selectedBooking.family.phone}
                    </Typography>
                  </Box>
                </Box>

                <Divider sx={{ mb: 3 }} />

                {/* Caregiver Details */}
                <Typography
                  sx={{
                    fontSize: "0.75rem",
                    fontWeight: 700,
                    color: "#999",
                    textTransform: "uppercase",
                    letterSpacing: 1,
                    mb: 1.5,
                  }}
                >
                  Caregiver
                </Typography>
                <Box sx={{ display: "flex", flexDirection: "column", gap: 1.5, mb: 1 }}>
                  <Box sx={{ display: "flex", alignItems: "center", gap: 1.5 }}>
                    <PersonOutline sx={{ fontSize: 18, color: "#7b1fa2" }} />
                    <Typography sx={{ fontSize: "0.9rem", color: "#444", fontWeight: 500 }}>
                      {selectedBooking.caregiver.name}
                    </Typography>
                  </Box>
                  <Box sx={{ display: "flex", alignItems: "center", gap: 1.5 }}>
                    <Email sx={{ fontSize: 18, color: "#7b1fa2" }} />
                    <Typography sx={{ fontSize: "0.9rem", color: "#444" }}>
                      {selectedBooking.caregiver.email}
                    </Typography>
                  </Box>
                  <Box sx={{ display: "flex", alignItems: "center", gap: 1.5 }}>
                    <Phone sx={{ fontSize: 18, color: "#7b1fa2" }} />
                    <Typography sx={{ fontSize: "0.9rem", color: "#444" }}>
                      {selectedBooking.caregiver.phone}
                    </Typography>
                  </Box>
                </Box>
              </DialogContent>

              {/* Actions */}
              <DialogActions sx={{ px: 3.5, pb: 3, pt: 0, gap: 1.5 }}>
                <Button
                  onClick={handleFlag}
                  variant={selectedBooking.flagged ? "contained" : "outlined"}
                  startIcon={actionLoading ? <CircularProgress size={16} color="inherit" /> : <Flag />}
                  disabled={actionLoading}
                  sx={{
                    borderRadius: "10px",
                    textTransform: "none",
                    fontWeight: 600,
                    fontSize: "0.88rem",
                    px: 3,
                    ...(selectedBooking.flagged
                      ? {
                          bgcolor: "#e65100",
                          color: "#fff",
                          "&:hover": { bgcolor: "#bf360c" },
                        }
                      : {
                          borderColor: "#e65100",
                          color: "#e65100",
                          "&:hover": { bgcolor: "rgba(230,81,0,0.04)", borderColor: "#bf360c" },
                        }),
                  }}
                >
                  {selectedBooking.flagged ? "Unflag Booking" : "Flag Booking"}
                </Button>
              </DialogActions>
            </>
          );
        })()}
      </Dialog>
    </Box>
  );
}

export default Bookings;
