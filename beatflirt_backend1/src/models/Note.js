//const mongoose = require('mongoose');
//
//const noteSchema = new mongoose.Schema(
//  {
//    userId: {
//      type: mongoose.Schema.Types.ObjectId,
//      ref: 'User',
//      required: [true, 'UserId is required'],
//      index: true,
//    },
//    title: {
//      type: String,
//      required: [true, 'Title is required'],
//      trim: true,
//      maxlength: [100, 'Title cannot exceed 100 characters'],
//    },
//    content: {
//      type: String,
//      required: [true, 'Content is required'],
//      trim: true,
//      maxlength: [2000, 'Content cannot exceed 2000 characters'],
//    },
//    tag: {
//      type: String,
//      trim: true,
//      default: 'General',
//      enum: [
//        'Dating',
//        'Gift Ideas',
//        'Locations',
//        'General',
//        'Reminders',
//        'Conversation',
//      ],
//    },
//    isPinned: {
//      type: Boolean,
//      default: false,
//    },
//  },
//  {
//    timestamps: true,
//    versionKey: false,
//  }
//);
//
//// Index for sorting: pinned first, then by newest
//noteSchema.index({ userId: 1, isPinned: -1, createdAt: -1 });
//
//module.exports = mongoose.model('Note', noteSchema);

const mongoose = require('mongoose');

const noteSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: [true, 'Title is required'],
      trim: true,
      maxlength: 100,
    },
    content: {
      type: String,
      required: [true, 'Content is required'],
      trim: true,
      maxlength: 2000,
    },
    tag: {
      type: String,
      trim: true,
      default: 'Dating',
    },
    isPinned: {
      type: Boolean,
      default: false,
    },
  },
  { timestamps: true, versionKey: false }
);

module.exports = mongoose.model('Note', noteSchema);