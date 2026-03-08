const express = require("express");
const router = express.Router();
const verifyToken = require("../middleware/auth");
const bookingController = require("../controllers/bookingController");

router.get("/", verifyToken, bookingController.getBookings);
router.get("/:id", verifyToken, bookingController.getBookingById);
router.patch("/:id/flag", verifyToken, bookingController.toggleFlag);

module.exports = router;
