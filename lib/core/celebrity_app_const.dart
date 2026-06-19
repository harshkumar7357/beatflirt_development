// /// ============================================================
// /// API DOCUMENTATION - Beat Flirt Pay Per Click / Celebrity Panel
// /// ============================================================
// ///
// /// Base URL: https://app.beatflirtevent.com/App
// ///
// /// Authentication:
// ///   Headers required for all authenticated requests:
// ///   - Content-Type: application/json; charset=UTF-8
// ///   - Access-Token: <token from login>
// ///   - Access-Sign: <sign from login>
// ///
// /// ──────────────────────────────────────────────────────────────
// /// 1. LOGIN
// /// ──────────────────────────────────────────────────────────────
// /// Endpoint: POST /auth/login
// /// Payload:  { "username": "...", "password": "..." }
// /// Response: {
// ///   "status": "200",
// ///   "message": "Sucessfully login.",
// ///   "data": {
// ///     "token": "...",
// ///     "sign": "...",
// ///     "userid": "425",
// ///     "username": "PerfectPair",
// ///     "email": "d@gmail.com",
// ///     "profile_type": "couple",
// ///     "profile_image": "6a226bb817934.png"
// ///   }
// /// }
// ///
// /// ──────────────────────────────────────────────────────────────
// /// 2. CHECK CHOCOLATE FACTORY POST (Celebrity Panel Submission Check)
// /// ──────────────────────────────────────────────────────────────
// /// Endpoint: GET /payperclick/check_chocolate_factory_post
// /// Headers:  Access-Token, Access-Sign
// /// Response: { "status": "200" } or { "status": "404", "message": "No Record Found!" }
// /// Purpose:  Check if the logged-in user has already submitted a celebrity panel post.
// ///
// /// ──────────────────────────────────────────────────────────────
// /// 3. CHECK CHOCOLATE FACTORY POPUP
// /// ──────────────────────────────────────────────────────────────
// /// Endpoint: GET /payperclick/check_chocolate_factory_popup
// /// Headers:  Access-Token, Access-Sign
// /// Response: { "status": "200" } or { "status": "404", "message": "No Record Found!" }
// /// Purpose:  Check if the celebrity submission confirmation popup should be shown.
// ///
// /// ──────────────────────────────────────────────────────────────
// /// 4. GET MY CHOCOLATE FACTORY DATA
// /// ──────────────────────────────────────────────────────────────
// /// Endpoint: POST /payperclick/get_chocolate_factory_data
// /// Headers:  Access-Token, Access-Sign
// /// Payload:  { "user_type": "me" }
// /// Response: {
// ///   "status": "200",
// ///   "data": [{
// ///     "id": "44",
// ///     "username": "...",
// ///     "user_id": "285",
// ///     "image": [{ "profile_image": "...", "status": "0" }],
// ///     "face_picture": "...",
// ///     "shirtless_picture": "...",
// ///     "full_body_picture": "...",
// ///     "validation_picture": "...",
// ///     "bbc_type": "yes",
// ///     "preferences": ["Couple", "Dom"],
// ///     "profile_control": ["Age", "Height", "Weight", "Preferences"],
// ///     "state_of_residence": "...",
// ///     "lat": "...", "lng": "...",
// ///     "city_name": "...",
// ///     "contact_number": "...",
// ///     "updated_email": "...",
// ///     "screen_name": "...",
// ///     "life_style_nickname": "...",
// ///     "life_style_website": "...",
// ///     "age": "60",
// ///     "height_feet": "4.5",
// ///     "height_inch": "169",
// ///     "weight": "90",
// ///     "self_description": "No comment",
// ///     "status": "1",
// ///     "created": "2025-12-17"
// ///   }]
// /// }
// ///
// /// ──────────────────────────────────────────────────────────────
// /// 5. GET ALL CHOCOLATE FACTORY DATA (ALL CELEBRITIES)
// /// ──────────────────────────────────────────────────────────────
// /// Endpoint: POST /payperclick/get_all_chocolate_factory_data
// /// Headers:  Access-Token, Access-Sign
// /// Payload:  {
// ///   "age_minvalue": 18,
// ///   "age_maxvalue": 60,
// ///   "height_minvalue": 4,
// ///   "height_maxvalue": 7,
// ///   "weight_minvalue": 80,
// ///   "weight_maxvalue": 300,
// ///   "preferencesArray": []
// /// }
// /// Response: { "status": "200", "data": [ ...array of celebrity objects... ] }
// ///
// /// ──────────────────────────────────────────────────────────────
// /// 6. GET PAY PER CLICK TERMS & CONDITIONS
// /// ──────────────────────────────────────────────────────────────
// /// Endpoint: GET /auth/pay_per_click_terms_condition
// /// Headers:  Access-Token, Access-Sign
// /// Response: {
// ///   "status": "200",
// ///   "data": [{
// ///     "id": "5",
// ///     "title": "Pay Per Click Terms and Conditions",
// ///     "description": "<p>HTML content...</p>",
// ///     "status": "1"
// ///   }]
// /// }
// ///
// /// ──────────────────────────────────────────────────────────────
// /// 7. GET USER CALENDAR DETAILS
// /// ──────────────────────────────────────────────────────────────
// /// Endpoint: POST /payperclick/get_user_calender_details
// /// Headers:  Access-Token, Access-Sign
// /// Payload:  { "pay_per_id": "44" }
// /// Response: {
// ///   "status": "200",
// ///   "data": [{ ...booking slot details... }]
// /// }
// ///
// /// ──────────────────────────────────────────────────────────────
// /// 8. CHECK USER MEMBERSHIP
// /// ──────────────────────────────────────────────────────────────
// /// Endpoint: POST /user/check_login_user_membership
// /// Headers:  Access-Token, Access-Sign
// /// Response: { "status": "200", "membership_expire": "No" }
// ///

// class AppConstants {
//   static const String baseUrl = 'https://app.beatflirtevent.com/App';

//   // Auth Endpoints
//   static const String loginEndpoint = '/auth/login';

//   // Pay Per Click / Celebrity Panel Endpoints
//   static const String checkChocolateFactoryPost =
//       '/payperclick/check_chocolate_factory_post';
//   static const String checkChocolateFactoryPopup =
//       '/payperclick/check_chocolate_factory_popup';
//   static const String getChocolateFactoryData =
//       '/payperclick/get_chocolate_factory_data';
//   static const String getAllChocolateFactoryData =
//       '/payperclick/get_all_chocolate_factory_data';
//   static const String payPerClickTermsCondition =
//       '/auth/pay_per_click_terms_condition';
//   static const String getUserCalenderDetails =
//       '/payperclick/get_user_calender_details';

//   // User Endpoints
//   static const String checkMembership = '/user/check_login_user_membership';

//   // App Colors
//   static const int primaryColor = 0xFF560827;
//   static const int secondaryColor = 0xFF06032C;
//   static const int accentColor = 0xFFFF00BF;
//   static const int goldColor = 0xFFF4BA4A;
//   static const int bgLight = 0xFFF5F5F5;
// }
