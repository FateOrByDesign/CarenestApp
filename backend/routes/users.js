const express = require("express");
const router = express.Router();
const verifyToken = require("../middleware/auth");
const userController = require("../controllers/userController");

router.get("/", verifyToken, userController.getUsers);
router.get("/:id", verifyToken, userController.getUserById);
router.patch("/:id/status", verifyToken, userController.toggleUserStatus);

module.exports = router;
