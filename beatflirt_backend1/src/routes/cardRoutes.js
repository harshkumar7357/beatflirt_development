const express = require("express");
const { listCards, createCard } = require("../controllers/cardController");
const authMiddleware = require("../middleware/authMiddleware");

const router = express.Router();

router.get("/", listCards);
router.post("/", authMiddleware, createCard);

module.exports = router;
