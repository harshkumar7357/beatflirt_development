//const Joi = require('joi');
//
//const createNoteSchema = Joi.object({
//  title: Joi.string()
//    .trim()
//    .min(1)
//    .max(100)
//    .required()
//    .messages({
//      'string.empty': 'Title cannot be empty',
//      'string.max': 'Title cannot exceed 100 characters',
//      'any.required': 'Title is required',
//    }),
//  content: Joi.string()
//    .trim()
//    .min(1)
//    .max(2000)
//    .required()
//    .messages({
//      'string.empty': 'Content cannot be empty',
//      'string.max': 'Content cannot exceed 2000 characters',
//      'any.required': 'Content is required',
//    }),
//  tag: Joi.string()
//    .valid('Dating', 'Gift Ideas', 'Locations', 'General', 'Reminders', 'Conversation')
//    .default('General')
//    .messages({
//      'any.only': 'Tag must be one of: Dating, Gift Ideas, Locations, General, Reminders, Conversation',
//    }),
//  isPinned: Joi.boolean().default(false),
//});
//
//const updateNoteSchema = Joi.object({
//  title: Joi.string()
//    .trim()
//    .min(1)
//    .max(100)
//    .messages({
//      'string.empty': 'Title cannot be empty',
//      'string.max': 'Title cannot exceed 100 characters',
//    }),
//  content: Joi.string()
//    .trim()
//    .min(1)
//    .max(2000)
//    .messages({
//      'string.empty': 'Content cannot be empty',
//      'string.max': 'Content cannot exceed 2000 characters',
//    }),
//  tag: Joi.string()
//    .valid('Dating', 'Gift Ideas', 'Locations', 'General', 'Reminders', 'Conversation')
//    .messages({
//      'any.only': 'Tag must be one of: Dating, Gift Ideas, Locations, General, Reminders, Conversation',
//    }),
//  isPinned: Joi.boolean(),
//}).min(1).messages({
//  'object.min': 'At least one field must be provided for update',
//});
//
//module.exports = {
//  createNoteSchema,
//  updateNoteSchema,
//};