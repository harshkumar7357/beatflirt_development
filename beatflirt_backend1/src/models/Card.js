const mongoose = require("mongoose");

const cardSchema = new mongoose.Schema(
  {
    imageUrl: { type: String, default: "" },
    title: { type: String, required: true, trim: true },
    description: { type: String, required: true, trim: true },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Card", cardSchema);
