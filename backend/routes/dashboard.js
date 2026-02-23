const express = require("express");
const router = express.Router();
const verifyToken = require("../middleware/auth");
const dashboardController = require("../controllers/dashboardController");

router.get("/stats", verifyToken, dashboardController.getStats);
router.get("/recent-applications", verifyToken, dashboardController.getRecentApplications);
router.get("/recent-bookings", verifyToken, dashboardController.getRecentBookings);

module.exports = router;
