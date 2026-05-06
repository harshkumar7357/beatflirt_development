const Card = require("../models/Card");

async function listCards(req, res) {
  try {
    const cards = await Card.find().sort({ createdAt: -1 });
    return res.status(200).json(cards);
  } catch (error) {
    return res.status(500).json({ message: "Failed to fetch cards", error: error.message });
  }
}

async function createCard(req, res) {
  try {
    const { imageUrl, title, description } = req.body ?? {};
    if (!title || !description) {
      return res.status(400).json({ message: "title and description are required" });
    }
    const card = await Card.create({ imageUrl: imageUrl || "", title, description });
    return res.status(201).json(card);
  } catch (error) {
    return res.status(500).json({ message: "Failed to create card", error: error.message });
  }
}

module.exports = { listCards, createCard };
