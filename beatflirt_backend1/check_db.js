const mongoose = require("mongoose");
const User = require("./src/models/User");
require("dotenv").config();

async function check() {
  await mongoose.connect(process.env.MONGO_URI || "mongodb://127.0.0.1:27017/beatflirt");
  const users = await User.find({}, "email friendRequests friends");
  console.log("Users in DB:");
  users.forEach(u => console.log(u.email, "- requests:", u.friendRequests.length, "- friends:", u.friends.length));
  process.exit(0);
}

check().catch(console.error);
