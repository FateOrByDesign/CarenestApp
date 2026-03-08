const express = require("express");
const router = express.Router();
const verifyToken = require("../middleware/auth");
const caregiverController = require("../controllers/caregiverController");

router.get("/applications", verifyToken, caregiverController.getApplications);
router.get("/applications/:id", verifyToken, caregiverController.getApplicationById);
router.patch("/applications/:id/approve", verifyToken, caregiverController.approveApplication);
router.patch("/applications/:id/reject", verifyToken, caregiverController.rejectApplication);

module.exports = router;
