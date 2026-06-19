const express = require("express");
const cors = require("cors");

const authRoutes = require("./routes/authRoutes");
const cardRoutes = require("./routes/cardRoutes");
const noteRoutes = require('./routes/noteRoutes');
const userRoutes = require("./routes/userRoutes");
const messageRoutes = require("./routes/messageRoutes");
const validationRoutes = require("./routes/validationRoutes");
const notificationRoutes = require("./routes/notificationRoutes");
const chatroomRoutes = require("./routes/chatroomRoutes");
const celebrityRoutes = require('./routes/celebrityRoutes');


const app = express();

app.use(cors());
app.use(express.json({ limit: "50mb" }));
app.use(express.urlencoded({ limit: "50mb", extended: true }));

app.get("/api/health", (req, res) => {
  res.status(200).json({ status: "ok", service: "beatflirt_backend1" });
});

app.use("/api/auth", authRoutes);
app.use("/api/cards", cardRoutes);
app.use('/api/notes', noteRoutes);
app.use("/api/users", userRoutes);
app.use("/api/messages", messageRoutes);
app.use("/api/validation", validationRoutes);
app.use("/api/notifications", notificationRoutes);
app.use("/api/chatrooms", chatroomRoutes);
app.use('/api/celebrities', celebrityRoutes);


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
