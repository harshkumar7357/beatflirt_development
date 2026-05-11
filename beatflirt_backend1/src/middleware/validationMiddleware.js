const ApiResponse = require('../utils/apiResponse');

const validate = (schema) => {
  return (req, res, next) => {
    const { error, value } = schema.validate(req.body, {
      abortEarly: false,
      stripUnknown: true,
    });

    if (error) {
      const errors = error.details.map((detail) => ({
        field: detail.path.join('.'),
        message: detail.message,
      }));

      return ApiResponse.error(res, {
        message: 'Validation failed',
        statusCode: 422,
        errors,
      });
    }

    req.body = value;
    next();
  };
};

module.exports = validate;