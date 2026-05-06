const express = require("express");
const cors = require("cors");

const authRoutes = require("./routes/authRoutes");
const cardRoutes = require("./routes/cardRoutes");

const app = express();

app.use(cors());
app.use(express.json({ limit: "1mb" }));
app.use(express.urlencoded({ extended: true }));

app.get("/api/health", (req, res) => {
  res.status(200).json({ status: "ok", service: "beatflirt_backend1" });
});

app.use("/api/auth", authRoutes);
app.use("/api/cards", cardRoutes);

app.use((req, res) => {
  res.status(404).json({ message: "Route not found" });
});

// Return JSON for bad JSON payloads and other runtime errors.
app.use((err, req, res, next) => {
  if (err instanceof SyntaxError && "body" in err) {
    return res.status(400).json({ message: "Invalid JSON body" });
  }
  console.error("Unhandled error:", err);
  return res.status(500).json({ message: "Internal server error" });
});

module.exports = app;
