const bcrypt = require("bcryptjs");
const crypto = require("crypto");
const jwt = require("jsonwebtoken");
const mongoose = require("mongoose");
const User = require("../models/User");

function buildToken(user) {
  return jwt.sign(
    { id: user._id, email: user.email },
    process.env.JWT_SECRET,
    { expiresIn: "7d" }
  );
}

async function register(req, res) {
  try {
    const { name, email, password } = req.body ?? {};
    if (!name || !email || !password) {
      return res.status(400).json({ message: "name, email and password are required" });
    }

    const existing = await User.findOne({ email });
    if (existing) {
      return res.status(409).json({ message: "Email already registered" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const user = await User.create({ name, email, password: hashedPassword });
    const token = buildToken(user);

    return res.status(201).json({
      message: "User registered successfully",
      token,
      user: { id: user._id, name: user.name, email: user.email },
    });
  } catch (error) {
    if (error?.code === 11000) {
      return res.status(409).json({ message: "Email already registered" });
    }
    return res.status(500).json({ message: "Failed to register user", error: error.message });
  }
}

async function login(req, res) {
  try {
    const { email, password } = req.body ?? {};
    if (!email || !password) {
      return res.status(400).json({ message: "email and password are required" });
    }

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    const token = buildToken(user);
    return res.status(200).json({
      message: "Login successful",
      token,
      user: { id: user._id, name: user.name, email: user.email },
    });
  } catch (error) {
    return res.status(500).json({ message: "Failed to login", error: error.message });
  }
}

async function requestPasswordReset(req, res) {
  try {
    const { email } = req.body ?? {};
    if (!email) {
      return res.status(400).json({ message: "email is required" });
    }

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const resetToken = crypto.randomBytes(3).toString("hex").toUpperCase();
    user.resetPasswordToken = crypto
      .createHash("sha256")
      .update(resetToken)
      .digest("hex");
    user.resetPasswordExpires = new Date(Date.now() + 10 * 60 * 1000);
    await user.save();

    // In production send this via email/SMS instead of returning it.
    return res.status(200).json({
      message: "Reset token generated",
      resetToken,
      expiresInMinutes: 10,
    });
  } catch (error) {
    return res
      .status(500)
      .json({ message: "Failed to generate reset token", error: error.message });
  }
}

async function resetPassword(req, res) {
  try {
    const { email, resetToken, newPassword } = req.body ?? {};
    if (!email || !resetToken || !newPassword) {
      return res
        .status(400)
        .json({ message: "email, resetToken and newPassword are required" });
    }
    if (String(newPassword).length < 6) {
      return res.status(400).json({ message: "newPassword must be at least 6 characters" });
    }

    const hashedToken = crypto.createHash("sha256").update(resetToken).digest("hex");
    const user = await User.findOne({
      email,
      resetPasswordToken: hashedToken,
      resetPasswordExpires: { $gt: new Date() },
    });
    if (!user) {
      return res.status(400).json({ message: "Invalid or expired reset token" });
    }

    user.password = await bcrypt.hash(newPassword, 10);
    user.resetPasswordToken = null;
    user.resetPasswordExpires = null;
    await user.save();

    return res.status(200).json({ message: "Password updated successfully" });
  } catch (error) {
    return res
      .status(500)
      .json({ message: "Failed to reset password", error: error.message });
  }
}

function profile(req, res) {
  return res.status(200).json({ message: "Profile fetched", user: req.user });
}

async function changePassword(req, res) {
  try {
    const { oldPassword, newPassword } = req.body ?? {};
    if (!oldPassword || !newPassword) {
      return res.status(400).json({ message: "oldPassword and newPassword are required" });
    }
    if (String(newPassword).length < 6) {
      return res.status(400).json({ message: "newPassword must be at least 6 characters" });
    }

    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const validOld = await bcrypt.compare(oldPassword, user.password);
    if (!validOld) {
      return res.status(401).json({ message: "Old password is incorrect" });
    }
    if (oldPassword === newPassword) {
      return res.status(400).json({ message: "New password must be different from old password" });
    }

    user.password = await bcrypt.hash(newPassword, 10);
    await user.save();
    return res.status(200).json({ message: "Password changed successfully" });
  } catch (error) {
    return res.status(500).json({ message: "Failed to change password", error: error.message });
  }
}

async function deleteAccount(req, res) {
  try {
    const user = await User.findByIdAndDelete(req.user.id);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    return res.status(200).json({ message: "Account deleted successfully" });
  } catch (error) {
    return res.status(500).json({ message: "Failed to delete account", error: error.message });
  }
}

async function getPhotos(req, res) {
  try {
    const user = await User.findById(req.user.id).select("photos");
    if (!user) return res.status(404).json({ message: "User not found" });
    return res.status(200).json({ photos: user.photos ?? [] });
  } catch (error) {
    return res.status(500).json({ message: "Failed to fetch photos", error: error.message });
  }
}

async function addPhoto(req, res) {
  try {
    const { path, title, status, isMain } = req.body ?? {};
    if (!path) return res.status(400).json({ message: "path is required" });
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: "User not found" });

    const photo = {
      mediaId: new mongoose.Types.ObjectId().toString(),
      path: String(path),
      title: String(title ?? ""),
      status: status === "approved" ? "approved" : "pending",
      isMain: isMain === true,
    };
    if (photo.isMain) {
      user.photos = (user.photos ?? []).map((p) => ({ ...p.toObject?.() ?? p, isMain: false }));
    }
    user.photos.push(photo);
    await user.save();
    return res.status(201).json({ message: "Photo added", photo });
  } catch (error) {
    return res.status(500).json({ message: "Failed to add photo", error: error.message });
  }
}

async function deletePhoto(req, res) {
  try {
    const { mediaId } = req.params;
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: "User not found" });
    const before = user.photos.length;
    user.photos = (user.photos ?? []).filter((p) => p.mediaId !== mediaId);
    if (user.photos.length === before) {
      return res.status(404).json({ message: "Photo not found" });
    }
    await user.save();
    return res.status(200).json({ message: "Photo deleted" });
  } catch (error) {
    return res.status(500).json({ message: "Failed to delete photo", error: error.message });
  }
}

async function getVideos(req, res) {
  try {
    const user = await User.findById(req.user.id).select("videos");
    if (!user) return res.status(404).json({ message: "User not found" });
    return res.status(200).json({ videos: user.videos ?? [] });
  } catch (error) {
    return res.status(500).json({ message: "Failed to fetch videos", error: error.message });
  }
}

async function addVideo(req, res) {
  try {
    const { path, thumbnailPath, status } = req.body ?? {};
    if (!path) return res.status(400).json({ message: "path is required" });
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: "User not found" });

    const video = {
      mediaId: new mongoose.Types.ObjectId().toString(),
      path: String(path),
      thumbnailPath: String(thumbnailPath ?? ""),
      status: status === "approved" ? "approved" : "pending",
    };
    user.videos.push(video);
    await user.save();
    return res.status(201).json({ message: "Video added", video });
  } catch (error) {
    return res.status(500).json({ message: "Failed to add video", error: error.message });
  }
}

async function deleteVideo(req, res) {
  try {
    const { mediaId } = req.params;
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: "User not found" });
    const before = user.videos.length;
    user.videos = (user.videos ?? []).filter((v) => v.mediaId !== mediaId);
    if (user.videos.length === before) {
      return res.status(404).json({ message: "Video not found" });
    }
    await user.save();
    return res.status(200).json({ message: "Video deleted" });
  } catch (error) {
    return res.status(500).json({ message: "Failed to delete video", error: error.message });
  }
}

function logout(req, res) {
  // Stateless JWT: client discards the token. This endpoint confirms intent server-side
  // (metrics, future denylist, etc.).
  return res.status(200).json({ message: "Logged out successfully" });
}

module.exports = {
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
};
