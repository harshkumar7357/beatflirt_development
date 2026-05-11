//const jwt = require('jsonwebtoken');
//const ApiResponse = require('../utils/apiResponse');
//
//const auth = (req, res, next) => {
//  try {
//    const authHeader = req.headers.authorization;
//
//    if (!authHeader || !authHeader.startsWith('Bearer ')) {
//      return ApiResponse.error(res, {
//        message: 'Access denied. No token provided.',
//        statusCode: 401,
//      });
//    }
//
//    const token = authHeader.split(' ')[1];
//
//    if (!process.env.JWT_SECRET) {
//      return ApiResponse.error(res, {
//        message: 'Server configuration error.',
//        statusCode: 500,
//      });
//    }
//
//    const decoded = jwt.verify(token, process.env.JWT_SECRET);
//    req.user = decoded; // { userId, email, ... }
//    next();
//  } catch (error) {
//    if (error.name === 'TokenExpiredError') {
//      return ApiResponse.error(res, {
//        message: 'Token expired. Please login again.',
//        statusCode: 401,
//      });
//    }
//    return ApiResponse.error(res, {
//      message: 'Invalid token.',
//      statusCode: 401,
//    });
//  }
//};
//
//module.exports = auth;