/// API Configuration for BeatFlirt
class ApiConfig {
  /// Base URL for all API endpoints
  static const String baseUrl = 'https://app.beatflirtevent.com/App';

  /// Agora Chat URL
  static const String agoraChatUrl = 'https://a71.chat.agora.io/711245752/1441455';

  /// Socket URL
  static const String socketUrl = 'https://node.technoderivation.com:3301/';

  // ============================================================
  // USER ENDPOINTS
  // ============================================================

  /// GET - Get single user profile data
  static const String getUserProfile = '/user/signle_user_profile';

  /// GET - Get single user profile images
  static const String getUserProfileImage = '/user/signle_user_profile_image';

  /// GET - Get approved profile images
  static const String getUserProfileApproveImage =
      '/user/signle_user_profile_approve_image';

  /// GET - Get pending profile images
  static const String getUserProfilePendingImage =
      '/user/signle_user_profile_pending_image';

  /// GET - Get approved profile videos
  static const String getUserProfileApproveVideo =
      '/user/signle_user_profile_approve_video';

  /// GET - Get pending profile videos
  static const String getUserProfilePendingVideo =
      '/user/signle_user_profile_pending_video';

  /// GET - Get all albums
  static const String getAllAlbum = '/user/get_all_album';

  /// GET - Get all approved album images
  static const String getAllApproveAlbumImage =
      '/user/get_all_approve_album_image';

  /// GET - Get all pending album images
  static const String getAllPendingAlbumImage =
      '/user/get_all_pending_album_image';

  /// POST - Edit single profile interest
  static const String editSingleProfileInterest =
      '/user/edit_single_profile_interest';

  /// POST - Edit couple profile details
  static const String editCoupleProfileDetails =
      '/user/edit_couple_profile_details';

  /// POST - Upload image (general)
  static const String uploadImage = '/upload/imageupload';

  /// POST - Upload profile image
  static const String uploadProfileImage = '/user/upload_profile_image';

  /// POST - Delete profile image
  static const String deleteProfileImage = '/user/delete_profile_image';

  /// POST - Edit profile image
  static const String editProfileImage = '/user/edit_profile_image';

  /// POST - Upload profile video
  static const String uploadProfileVideo = '/user/upload_profile_video';

  /// POST - Delete profile video
  static const String deleteProfileVideo = '/user/delete_profile_video';

  /// POST - Get album details
  static const String getAlbumDetails = '/user/get_album_details';

  /// POST - Create profile album
  static const String createProfileAlbum = '/user/create_profile_album';

  /// POST - Update profile album
  static const String updateProfileAlbum = '/user/update_profile_album';

  /// POST - Get album images
  static const String getAlbumImage = '/user/get_album_image';

  /// POST - Delete album
  static const String deleteAlbum = '/user/delete_album';

  /// POST - Upload multiple images
  static const String uploadMultipleImages = '/upload/imageuploadMultiple';

  /// POST - Upload multiple album images
  static const String uploadMultipleAlbumImages =
      '/user/single_user_mutiple_album_image';

  /// POST - Upload album video
  static const String uploadAlbumVideo = '/user/upload_profile_album_video';

  /// POST - Update location
  static const String updateLocation = '/location/update_location';

  /// POST - Update/set profile image
  static const String updateSetProfileImage = '/user/update_set_profile_image';

  // ============================================================
  // AUTH ENDPOINTS
  // ============================================================

  /// GET - Get current user info
  static const String getCurrentUser = '/user/me';

  /// GET - Logout
  static const String logout = '/user/logout';

  // ============================================================
  // NOTIFICATION ENDPOINTS
  // ============================================================

  /// GET - Get notification count
  static const String getNotificationCount = '/notification/all_count';

  /// GET - Get all short notifications
  static const String getShortNotifications =
      '/notification/get_all_short_notification';

  // ============================================================
  // MEMBERSHIP ENDPOINTS
  // ============================================================

  /// GET - Check login user membership
  static const String checkMembership = '/user/check_login_user_membership';

  // ============================================================
  // CHAT ENDPOINTS
  // ============================================================

  /// POST - Create chat room
  static const String createChatRoom = '/user/create_chat_room';

  // ============================================================
  // OTHER ENDPOINTS
  // ============================================================

  /// GET - Who I viewed
  static const String whoIViewed = '/user/who_i_viewed';

  // Helper to get full URL
  static String getFullUrl(String endpoint) => '$baseUrl$endpoint';
}



/// API Configuration for Beat Flirt
/// 
/// Update these values with your actual API credentials

class ApiConfiguration {
  // Base URL - Change this to your production API URL
  static const String baseUrl = 'https://beatflirtevent.com/api';
  
  // Alternative Base URLs
  static const String stagingUrl = 'https://staging.beatflirtevent.com/api';
  static const String devUrl = 'http://localhost:3000/api';
  
  // Authentication
  static const bool requiresAuth = true;
  static const String authType = 'Bearer'; // 'Bearer' or 'Basic'
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // API Versions
  static const String apiVersion = 'v1';
  
  // Endpoints
  static const Map<String, String> endpoints = {
    // Authentication
    'login': '/auth/login',
    'register': '/auth/register',
    'logout': '/auth/logout',
    'refreshToken': '/auth/refresh',
    
    // Profile
    'coupleProfile': '/couple-profile',
    'userProfile': '/user-profile',
    'updateProfile': '/update-profile',
    'uploadPhoto': '/upload-photo',
    'deletePhoto': '/delete-photo',
    
    // Social
    'like': '/like',
    'unlike': '/unlike',
    'follow': '/follow',
    'unfollow': '/unfollow',
    'block': '/block',
    'report': '/report',
    
    // Messaging
    'sendMessage': '/message',
    'getMessages': '/messages',
    'markRead': '/messages/read',
    
    // Events
    'events': '/events',
    'attending': '/attending',
    'rsvp': '/rsvp',
    
    // Search & Discovery
    'search': '/search',
    'discover': '/discover',
    'suggestions': '/suggestions',
  };
  
  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };
  
  // Query Parameters
  static const Map<String, String> defaultQueryParams = {
    'platform': 'mobile',
    'app_version': '1.0.0',
  };
}

/// User ID for testing
/// Replace with actual user ID from your database
class TestConfig {
  static const String testUserId = '422';
  static const String testCoupleId = '422';
  
  // Mock data for development
  static const bool useMockData = true;
  static const bool enableLogging = true;
  static const bool showErrors = true;
}