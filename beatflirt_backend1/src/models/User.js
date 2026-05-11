const mongoose = require("mongoose");

const mediaPhotoSchema = new mongoose.Schema(
  {
    mediaId: { type: String, required: true },
    path: { type: String, required: true, trim: true },
    title: { type: String, default: "" },
    status: { type: String, enum: ["approved", "pending"], default: "pending" },
    isMain: { type: Boolean, default: false },
  },
  { _id: false, timestamps: true }
);

const mediaVideoSchema = new mongoose.Schema(
  {
    mediaId: { type: String, required: true },
    path: { type: String, required: true, trim: true },
    thumbnailPath: { type: String, default: "" },
    status: { type: String, enum: ["approved", "pending"], default: "pending" },
  },
  { _id: false, timestamps: true }
);

const userSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true },
    email: { type: String, required: true, unique: true, lowercase: true, trim: true },
    password: { type: String, required: true },
    resetPasswordToken: { type: String, default: null },
    resetPasswordExpires: { type: Date, default: null },
    photos: { type: [mediaPhotoSchema], default: [] },
    videos: { type: [mediaVideoSchema], default: [] },
    privacy: {
      showOnlineStatus: { type: Boolean, default: true },
      showProfileToPublic: { type: Boolean, default: true },
      allowMessagesFromStrangers: { type: Boolean, default: true },
      showLastSeen: { type: Boolean, default: true },
      hideFromSearch: { type: Boolean, default: false },
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("User", userSchema);
