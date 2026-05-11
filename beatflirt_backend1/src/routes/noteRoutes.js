//const express = require('express');
//const router = express.Router();
//const auth = require('../middleware/authMiddle');
//const validate = require('../middleware/validationMiddleware');
//const { createNoteSchema, updateNoteSchema } = require('../validator/noteValidator');
//const {
//  createNote,
//  getAllNotes,
//  getNoteById,
//  updateNote,
//  deleteNote,
//  togglePin,
//  getNotesStats,
//} = require('../controllers/noteController');
//
//// All routes require authentication
//router.use(auth);
//
//// ─── Routes ────────────────────────────────────────────
//
//// Stats (place before `/:id` to avoid route conflict)
//router.get('/stats', getNotesStats);
//
//// CRUD
//router.post('/', validate(createNoteSchema), createNote);
//router.get('/', getAllNotes);
//router.get('/:id', getNoteById);
//router.put('/:id', validate(updateNoteSchema), updateNote);
//router.delete('/:id', deleteNote);
//
//// Toggle pin
//router.patch('/:id/pin', togglePin);
//
//module.exports = router;

const express = require('express');
const router = express.Router();
const {
  createNote,
  getAllNotes,
  deleteNote,
} = require('../controllers/note.controller');

// No auth middleware here!
router.post('/', createNote);
router.get('/', getAllNotes);
router.delete('/:id', deleteNote);

module.exports = router;