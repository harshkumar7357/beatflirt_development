const mongoose = require("mongoose");
const User = require("./src/models/User");
require("dotenv").config();

async function seed() {
  await mongoose.connect(process.env.MONGO_URI || "mongodb://127.0.0.1:27017/beatflirt");
  const users = await User.find();
  
  // Create some mock users if there aren't enough
  const mockUser1 = new User({ name: "Mock Sarah", email: "mock1@example.com", password: "password123", isOnline: true, photos: [{ mediaId: "1", path: "assets/images/notification-image1.jpg", isMain: true }] });
  const mockUser2 = new User({ name: "Mock John", email: "mock2@example.com", password: "password123", isOnline: false, photos: [{ mediaId: "2", path: "assets/images/notification-image4.jpg", isMain: true }] });
  
  await mockUser1.save().catch(e => {}); // ignore duplicate email error
  await mockUser2.save().catch(e => {});

  const m1 = await User.findOne({ email: "mock1@example.com" });
  const m2 = await User.findOne({ email: "mock2@example.com" });

  for (const user of users) {
    if (user.email === "mock1@example.com" || user.email === "mock2@example.com") continue;
    
    // Add mock users to friend requests of all real users
    if (!user.friendRequests) user.friendRequests = [];
    if (!user.friendRequests.includes(m1._id)) user.friendRequests.push(m1._id);
    if (!user.friendRequests.includes(m2._id)) user.friendRequests.push(m2._id);
    await user.save();
  }
  
  console.log("Seeded friend requests for all users!");
  process.exit(0);
}

seed().catch(console.error);
