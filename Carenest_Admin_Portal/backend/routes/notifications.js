const express = require("express");
const router = express.Router();
const verifyToken = require("../middleware/auth");
const notificationController = require("../controllers/notificationController");

router.get("/activity", verifyToken, notificationController.getActivityFeed);

module.exports = router;
