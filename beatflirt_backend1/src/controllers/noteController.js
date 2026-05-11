//const Note = require('../models/note');
//const ApiResponse = require('../utils/apiResponse');
//const mongoose = require('mongoose');
//
//// ─── CREATE NOTE ────────────────────────────────────────
//const createNote = async (req, res) => {
//  try {
//    const { title, content, tag, isPinned } = req.body;
//    const userId = req.user.userId;
//
//    const note = await Note.create({
//      userId,
//      title,
//      content,
//      tag,
//      isPinned,
//    });
//
//    return ApiResponse.success(res, {
//      data: note,
//      message: 'Note created successfully',
//      statusCode: 201,
//    });
//  } catch (error) {
//    console.error('Create Note Error:', error);
//    return ApiResponse.error(res, {
//      message: 'Failed to create note',
//      statusCode: 500,
//    });
//  }
//};
//
//// ─── GET ALL NOTES ──────────────────────────────────────
//const getAllNotes = async (req, res) => {
//  try {
//    const userId = req.user.userId;
//    const {
//      page = 1,
//      limit = 10,
//      tag,
//      search,
//      pinned,
//    } = req.query;
//
//    const filter = { userId };
//
//    // Filter by tag
//    if (tag && tag !== 'All') {
//      filter.tag = tag;
//    }
//
//    // Filter pinned only
//    if (pinned === 'true') {
//      filter.isPinned = true;
//    }
//
//    // Search by title or content
//    if (search) {
//      filter.$or = [
//        { title: { $regex: search, $options: 'i' } },
//        { content: { $regex: search, $options: 'i' } },
//      ];
//    }
//
//    const skip = (Number(page) - 1) * Number(limit);
//
//    const [notes, total] = await Promise.all([
//      Note.find(filter)
//        .sort({ isPinned: -1, createdAt: -1 })
//        .skip(skip)
//        .limit(Number(limit))
//        .lean(),
//      Note.countDocuments(filter),
//    ]);
//
//    // Add a computed "timeAgo" field
//    const notesWithTimeAgo = notes.map((note) => ({
//      ...note,
//      timeAgo: getTimeAgo(note.createdAt),
//    }));
//
//    return ApiResponse.paginated(res, {
//      data: notesWithTimeAgo,
//      page: Number(page),
//      limit: Number(limit),
//      total,
//      message: 'Notes fetched successfully',
//    });
//  } catch (error) {
//    console.error('Get Notes Error:', error);
//    return ApiResponse.error(res, {
//      message: 'Failed to fetch notes',
//      statusCode: 500,
//    });
//  }
//};
//
//// ─── GET SINGLE NOTE ───────────────────────────────────
//const getNoteById = async (req, res) => {
//  try {
//    const { id } = req.params;
//    const userId = req.user.userId;
//
//    if (!mongoose.Types.ObjectId.isValid(id)) {
//      return ApiResponse.error(res, {
//        message: 'Invalid note ID',
//        statusCode: 400,
//      });
//    }
//
//    const note = await Note.findOne({ _id: id, userId }).lean();
//
//    if (!note) {
//      return ApiResponse.error(res, {
//        message: 'Note not found',
//        statusCode: 404,
//      });
//    }
//
//    return ApiResponse.success(res, {
//      data: { ...note, timeAgo: getTimeAgo(note.createdAt) },
//      message: 'Note fetched successfully',
//    });
//  } catch (error) {
//    console.error('Get Note Error:', error);
//    return ApiResponse.error(res, {
//      message: 'Failed to fetch note',
//      statusCode: 500,
//    });
//  }
//};
//
//// ─── UPDATE NOTE ────────────────────────────────────────
//const updateNote = async (req, res) => {
//  try {
//    const { id } = req.params;
//    const userId = req.user.userId;
//
//    if (!mongoose.Types.ObjectId.isValid(id)) {
//      return ApiResponse.error(res, {
//        message: 'Invalid note ID',
//        statusCode: 400,
//      });
//    }
//
//    const updatedNote = await Note.findOneAndUpdate(
//      { _id: id, userId },
//      { $set: req.body },
//      { new: true, runValidators: true }
//    );
//
//    if (!updatedNote) {
//      return ApiResponse.error(res, {
//        message: 'Note not found',
//        statusCode: 404,
//      });
//    }
//
//    return ApiResponse.success(res, {
//      data: updatedNote,
//      message: 'Note updated successfully',
//    });
//  } catch (error) {
//    console.error('Update Note Error:', error);
//
//    if (error.name === 'ValidationError') {
//      const errors = Object.values(error.errors).map((e) => ({
//        field: e.path,
//        message: e.message,
//      }));
//      return ApiResponse.error(res, {
//        message: 'Validation failed',
//        statusCode: 422,
//        errors,
//      });
//    }
//
//    return ApiResponse.error(res, {
//      message: 'Failed to update note',
//      statusCode: 500,
//    });
//  }
//};
//
//// ─── DELETE NOTE ────────────────────────────────────────
//const deleteNote = async (req, res) => {
//  try {
//    const { id } = req.params;
//    const userId = req.user.userId;
//
//    if (!mongoose.Types.ObjectId.isValid(id)) {
//      return ApiResponse.error(res, {
//        message: 'Invalid note ID',
//        statusCode: 400,
//      });
//    }
//
//    const deletedNote = await Note.findOneAndDelete({ _id: id, userId });
//
//    if (!deletedNote) {
//      return ApiResponse.error(res, {
//        message: 'Note not found',
//        statusCode: 404,
//      });
//    }
//
//    return ApiResponse.success(res, {
//      message: 'Note deleted successfully',
//    });
//  } catch (error) {
//    console.error('Delete Note Error:', error);
//    return ApiResponse.error(res, {
//      message: 'Failed to delete note',
//      statusCode: 500,
//    });
//  }
//};
//
//// ─── TOGGLE PIN ─────────────────────────────────────────
//const togglePin = async (req, res) => {
//  try {
//    const { id } = req.params;
//    const userId = req.user.userId;
//
//    if (!mongoose.Types.ObjectId.isValid(id)) {
//      return ApiResponse.error(res, {
//        message: 'Invalid note ID',
//        statusCode: 400,
//      });
//    }
//
//    const note = await Note.findOne({ _id: id, userId });
//
//    if (!note) {
//      return ApiResponse.error(res, {
//        message: 'Note not found',
//        statusCode: 404,
//      });
//    }
//
//    note.isPinned = !note.isPinned;
//    await note.save();
//
//    return ApiResponse.success(res, {
//      data: note,
//      message: note.isPinned ? 'Note pinned' : 'Note unpinned',
//    });
//  } catch (error) {
//    console.error('Toggle Pin Error:', error);
//    return ApiResponse.error(res, {
//      message: 'Failed to toggle pin',
//      statusCode: 500,
//    });
//  }
//};
//
//// ─── GET NOTES STATS ────────────────────────────────────
//const getNotesStats = async (req, res) => {
//  try {
//    const userId = req.user.userId;
//
//    const [totalNotes, pinnedCount, tagBreakdown] = await Promise.all([
//      Note.countDocuments({ userId }),
//      Note.countDocuments({ userId, isPinned: true }),
//      Note.aggregate([
//        { $match: { userId: new mongoose.Types.ObjectId(userId) } },
//        { $group: { _id: '$tag', count: { $sum: 1 } } },
//        { $sort: { count: -1 } },
//      ]),
//    ]);
//
//    return ApiResponse.success(res, {
//      data: {
//        totalNotes,
//        pinnedCount,
//        tagBreakdown: tagBreakdown.map((t) => ({
//          tag: t._id,
//          count: t.count,
//        })),
//      },
//      message: 'Stats fetched successfully',
//    });
//  } catch (error) {
//    console.error('Stats Error:', error);
//    return ApiResponse.error(res, {
//      message: 'Failed to fetch stats',
//      statusCode: 500,
//    });
//  }
//};
//
//// ─── HELPER: Time Ago ──────────────────────────────────
//function getTimeAgo(date) {
//  const now = new Date();
//  const diff = now - new Date(date);
//  const seconds = Math.floor(diff / 1000);
//  const minutes = Math.floor(seconds / 60);
//  const hours = Math.floor(minutes / 60);
//  const days = Math.floor(hours / 24);
//  const weeks = Math.floor(days / 7);
//  const months = Math.floor(days / 30);
//
//  if (seconds < 60) return 'Just now';
//  if (minutes < 60) return `${minutes}m ago`;
//  if (hours < 24) return `${hours}h ago`;
//  if (days < 7) return `${days}d ago`;
//  if (weeks < 4) return `${weeks}w ago`;
//  return `${months}mo ago`;
//}
//
//module.exports = {
//  createNote,
//  getAllNotes,
//  getNoteById,
//  updateNote,
//  deleteNote,
//  togglePin,
//  getNotesStats,
//};

const Note = require('../models/note.model');
const mongoose = require('mongoose');

// CREATE
const createNote = async (req, res) => {
  try {
    const { title, content, tag } = req.body;
    const note = await Note.create({ title, content, tag });
    res.status(201).json({ success: true, data: note });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Failed to create note' });
  }
};

// GET ALL
const getAllNotes = async (req, res) => {
  try {
    const notes = await Note.find().sort({ createdAt: -1 });
    res.status(200).json({ success: true, data: notes });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Failed to fetch notes' });
  }
};

// DELETE
const deleteNote = async (req, res) => {
  try {
    const { id } = req.params;
    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ success: false, message: 'Invalid ID' });
    }
    await Note.findByIdAndDelete(id);
    res.status(200).json({ success: true, message: 'Note deleted' });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Failed to delete note' });
  }
};

module.exports = { createNote, getAllNotes, deleteNote };