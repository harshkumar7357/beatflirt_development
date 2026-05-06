const express = require("express");
const {
  register,
  login,
  requestPasswordReset,
  resetPassword,
  profile,
  changePassword,
  deleteAccount,
  getPhotos,
  addPhoto,
  deletePhoto,
  getVideos,
  addVideo,
  deleteVideo,
  logout,
} = require("../controllers/authController");
const authMiddleware = require("../middleware/authMiddleware");

const router = express.Router();

router.post("/register", register);
router.post("/login", login);
router.post("/forgot-password/request", requestPasswordReset);
router.post("/forgot-password/reset", resetPassword);
router.get("/profile", authMiddleware, profile);
router.post("/change-password", authMiddleware, changePassword);
router.delete("/delete-account", authMiddleware, deleteAccount);
router.get("/photos", authMiddleware, getPhotos);
router.post("/photos", authMiddleware, addPhoto);
router.delete("/photos/:mediaId", authMiddleware, deletePhoto);
router.get("/videos", authMiddleware, getVideos);
router.post("/videos", authMiddleware, addVideo);
router.delete("/videos/:mediaId", authMiddleware, deleteVideo);
router.post("/logout", authMiddleware, logout);

module.exports = router;
