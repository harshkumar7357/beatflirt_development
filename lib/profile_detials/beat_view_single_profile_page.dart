// // Beat Flirt /view-single-profile screen converted from:
// // https://beatflirtevent.com/view-single-profile
// //
// // Main class: ViewSingleProfilePage
// //
// // Required pubspec dependencies:
// //   http: ^1.2.2
// //   shared_preferences: ^2.3.2
// //   flutter_svg: ^2.0.10+1
// //   geocoding: ^3.0.0
// //   image_picker: ^1.1.2
// //
// // AndroidManifest.xml:
// //   <uses-permission android:name="android.permission.INTERNET" />

// import 'dart:convert';
// import 'dart:math' as math;

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// const String _webBase = 'https://beatflirtevent.com/';
// const String _apiBase = 'https://app.beatflirtevent.com/App';
// const String _apiAssetBase = 'https://app.beatflirtevent.com/assets/';

// String _webAsset(String path) => '$_webBase$path';

// String _resolveMediaUrl(String raw) {
//   final value = raw.trim();
//   if (value.isEmpty) return '';
//   if (value.startsWith('http://') || value.startsWith('https://')) return value;
//   if (value.startsWith('//')) return 'https:$value';
//   if (value.startsWith('assets/')) return '$_webBase$value';
//   if (value.startsWith('/assets/')) return '$_webBase${value.substring(1)}';
//   if (value.startsWith('/')) return 'https://app.beatflirtevent.com$value';
//   return '$_apiAssetBase$value';
// }

// bool _ok(dynamic status) => status?.toString() == '200';

// String _s(dynamic value, [String fallback = '']) {
//   if (value == null) return fallback;
//   final text = value.toString();
//   return text.isEmpty ? fallback : text;
// }

// int _i(dynamic value, [int fallback = 0]) {
//   if (value == null) return fallback;
//   if (value is int) return value;
//   return int.tryParse(value.toString()) ?? fallback;
// }

// double? _d(dynamic value) {
//   if (value == null) return null;
//   if (value is num) return value.toDouble();
//   return double.tryParse(value.toString());
// }

// class BeatViewSingleProfileApiException implements Exception {
//   BeatViewSingleProfileApiException(this.message);
//   final String message;

//   @override
//   String toString() => message;
// }

// class SingleProfileData {
//   SingleProfileData(this.raw);
//   final Map<String, dynamic> raw;

//   String get id => _s(raw['id']);
//   String get username => _s(raw['username'], 'User Profile');
//   String get address => _s(raw['address']);
//   String get address1 => _s(raw['address_1']);
//   String get distanceUnit => _s(raw['distance'], 'Km');
//   String get genderProfileType => _s(raw['gender_profile_type'], 'Single');
//   String get text => _s(raw['text']);
//   String get comment => _s(raw['comment']);
//   String get age => _s(raw['person1_age'], _s(raw['age'], '18'));
//   String get displayName => _s(raw['person1_name'], username);

//   String value(String key, [String fallback = 'N/A']) => _s(raw[key], fallback);
//   bool flag(String key) => raw[key]?.toString() == '1';

//   Map<String, dynamic> detailsPayload() {
//     final keys = <String>[
//       'text',
//       'comment',
//       'person1_name',
//       'person1_dob',
//       'person1_body_hair',
//       'person1_height',
//       'person1_weight',
//       'person1_body_type',
//       'person1_ethnic_background',
//       'person1_smoking',
//       'person1_drinking',
//       'person1_piercings',
//       'person1_tattoos',
//       'person1_language_spoken',
//       'person1_circumcised',
//       'person1_intelligence_importance',
//       'person1_sexuality',
//       'person1_relationship_orientation',
//       'person1_looks_important',
//       'height1_type',
//       'weight1_type',
//     ];
//     return {for (final k in keys) k: _s(raw[k])};
//   }

//   Map<String, dynamic> interestPayload() {
//     const keys = <String>[
//       'couple_male_female_swingers',
//       'couple_male_female_hookup_meetup',
//       'couple_female_female_swingers',
//       'couple_female_female_hookup_meetup',
//       'couple_male_male_swingers',
//       'couple_male_male_hookup_meetup',
//       'couple_male_swingers',
//       'couple_male_hookup_meetup',
//       'couple_female_swingers',
//       'couple_female_hookup_meetup',
//       'couple_transgender_swingers',
//       'couple_transgender_hookup_meetup',
//     ];
//     return {for (final k in keys) k: flag(k) ? 1 : 0};
//   }
// }

// class SingleProfileImage {
//   SingleProfileImage(this.raw);
//   final Map<String, dynamic> raw;
//   String get id => _s(raw['id']);
//   String get profileImage => _s(raw['profile_image']);
//   bool get isMain => raw['set_profile']?.toString() == '1';
// }

// class SingleProfileVideo {
//   SingleProfileVideo(this.raw);
//   final Map<String, dynamic> raw;
//   String get id => _s(raw['id']);
//   String get profileVideo => _s(raw['profile_video']);
// }

// class SingleAlbum {
//   SingleAlbum(this.raw);
//   final Map<String, dynamic> raw;
//   String get id => _s(raw['id']);
//   String get name => _s(raw['album_name']);
//   String get password => _s(raw['album_password']);
//   String get image => _s(raw['image']);
// }

// class SingleAlbumMedia {
//   SingleAlbumMedia(this.raw);
//   final Map<String, dynamic> raw;
//   bool get isImage => raw['image_status']?.toString() == '1';
//   bool get isVideo => raw['video_status']?.toString() == '1';
//   String get image => _s(raw['image']);
//   String get video => _s(raw['video']);
// }

// class SingleProfileBundle {
//   SingleProfileBundle({
//     required this.profile,
//     required this.profileImages,
//     required this.approvedImages,
//     required this.pendingImages,
//     required this.approvedVideos,
//     required this.pendingVideos,
//     required this.albums,
//     required this.pendingAlbumMedia,
//     required this.approvedAlbumMedia,
//   });

//   final SingleProfileData? profile;
//   final List<SingleProfileImage> profileImages;
//   final List<SingleProfileImage> approvedImages;
//   final List<SingleProfileImage> pendingImages;
//   final List<SingleProfileVideo> approvedVideos;
//   final List<SingleProfileVideo> pendingVideos;
//   final List<SingleAlbum> albums;
//   final List<SingleAlbumMedia> pendingAlbumMedia;
//   final List<SingleAlbumMedia> approvedAlbumMedia;
// }

// class BeatViewSingleProfileApi {
//   BeatViewSingleProfileApi({
//     required this.accessToken,
//     required this.accessSign,
//     http.Client? client,
//     this.baseUrl = _apiBase,
//   }) : _client = client ?? http.Client();

//   final String accessToken;
//   final String accessSign;
//   final String baseUrl;
//   final http.Client _client;

//   Map<String, String> get _headers {
//     final h = <String, String>{'Content-Type': 'application/json; charset=UTF-8'};
//     if (accessToken.isNotEmpty && accessSign.isNotEmpty) {
//       h['Access-Token'] = accessToken;
//       h['Access-Sign'] = accessSign;
//     }
//     return h;
//   }

//   Future<Map<String, dynamic>> _get(String path) async {
//     final response = await _client.get(Uri.parse('$baseUrl$path'), headers: _headers);
//     return _decode(response);
//   }

//   Future<Map<String, dynamic>> _post(String path, [Map<String, dynamic>? body]) async {
//     final response = await _client.post(
//       Uri.parse('$baseUrl$path'),
//       headers: _headers,
//       body: jsonEncode(body ?? <String, dynamic>{}),
//     );
//     return _decode(response);
//   }

//   Map<String, dynamic> _decode(http.Response response) {
//     if (response.statusCode < 200 || response.statusCode >= 300) {
//       throw BeatViewSingleProfileApiException('HTTP ${response.statusCode}: ${response.reasonPhrase ?? 'Request failed'}');
//     }
//     final decoded = jsonDecode(response.body);
//     if (decoded is Map<String, dynamic>) return decoded;
//     throw BeatViewSingleProfileApiException('Unexpected API response');
//   }

//   List<T> _list<T>(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
//     if (!_ok(json['status'])) return <T>[];
//     final data = json['data'];
//     if (data is! List) return <T>[];
//     return data.whereType<Map>().map((e) => fromJson(Map<String, dynamic>.from(e))).toList();
//   }

//   Future<SingleProfileBundle> loadProfileBundle() async {
//     final profileJson = await _get('/user/signle_user_profile');
//     final profile = _ok(profileJson['status']) && profileJson['data'] is Map
//         ? SingleProfileData(Map<String, dynamic>.from(profileJson['data'] as Map))
//         : null;

//     final profileImages = _list(await _get('/user/signle_user_profile_image'), (e) => SingleProfileImage(e));
//     final approvedImages = _list(await _get('/user/signle_user_profile_approve_image'), (e) => SingleProfileImage(e));
//     final pendingImages = _list(await _get('/user/signle_user_profile_pending_image'), (e) => SingleProfileImage(e));
//     final approvedVideos = _list(await _get('/user/signle_user_profile_approve_video'), (e) => SingleProfileVideo(e));
//     final pendingVideos = _list(await _get('/user/signle_user_profile_pending_video'), (e) => SingleProfileVideo(e));
//     final albums = _list(await _get('/user/get_all_album'), (e) => SingleAlbum(e));
//     final pendingAlbum = _list(await _get('/user/get_all_pending_album_image'), (e) => SingleAlbumMedia(e));
//     final approvedAlbum = _list(await _get('/user/get_all_approve_album_image'), (e) => SingleAlbumMedia(e));

//     return SingleProfileBundle(
//       profile: profile,
//       profileImages: profileImages,
//       approvedImages: approvedImages,
//       pendingImages: pendingImages,
//       approvedVideos: approvedVideos,
//       pendingVideos: pendingVideos,
//       albums: albums,
//       pendingAlbumMedia: pendingAlbum,
//       approvedAlbumMedia: approvedAlbum,
//     );
//   }

//   Future<String> _messagePost(String path, Map<String, dynamic> body) async {
//     final json = await _post(path, body);
//     final message = _s(json['message'], _ok(json['status']) ? 'Success' : 'Request failed');
//     if (!_ok(json['status'])) throw BeatViewSingleProfileApiException(message);
//     return message;
//   }

//   Future<String> saveInterests(Map<String, dynamic> body) => _messagePost('/user/edit_single_profile_interest', body);
//   Future<String> saveProfileDetails(Map<String, dynamic> body) => _messagePost('/user/edit_single_profile_details', body);
//   Future<String> uploadProfileImage(String imageName) => _messagePost('/user/upload_profile_image', {'image': imageName});
//   Future<String> editProfileImage({required String id, required String imageName}) => _messagePost('/user/edit_profile_image', {'id': id, 'image': imageName});
//   Future<String> deleteProfileImage(String imageId) => _messagePost('/user/delete_profile_image', {'image_id': imageId});
//   Future<String> setProfileImage(String imageId) => _messagePost('/user/update_set_profile_image', {'image_id': imageId});
//   Future<String> uploadProfileVideo(String videoName) => _messagePost('/user/upload_profile_video', {'video': videoName});
//   Future<String> deleteProfileVideo(String videoId) => _messagePost('/user/delete_profile_video', {'video_id': videoId});
//   Future<String> createAlbum({required String name, required String password}) => _messagePost('/user/create_profile_album', {'album_name': name, 'album_password': password});
//   Future<String> updateAlbum({required String id, required String name, required String password}) => _messagePost('/user/update_profile_album', {'id': id, 'album_name': name, 'album_password': password});
//   Future<String> deleteAlbum(String albumId) => _messagePost('/user/delete_album', {'album_id': albumId});
//   Future<String> uploadAlbumImage({required String albumId, required String imageName}) => _messagePost('/user/single_user_mutiple_album_image', {'album_id': albumId, 'image': imageName});
//   Future<String> uploadAlbumVideo({required String albumId, required String videoName}) => _messagePost('/user/upload_profile_album_video', {'album_id': albumId, 'video': videoName});
//   Future<String> updateLocation(Map<String, dynamic> body) => _messagePost('/location/update_location', body);

//   Future<SingleAlbum?> getAlbumDetails(String albumId) async {
//     final json = await _post('/user/get_album_details', {'album_id': albumId});
//     if (_ok(json['status']) && json['data'] is Map) return SingleAlbum(Map<String, dynamic>.from(json['data'] as Map));
//     return null;
//   }

//   Future<List<SingleAlbumMedia>> getAlbumMedia(String albumId) async {
//     final json = await _post('/user/get_album_image', {'album_id': albumId});
//     return _list(json, (e) => SingleAlbumMedia(e));
//   }

//   Future<String> uploadImageDataUrl(String dataUrl) async {
//     final json = await _post('/upload/imageupload', {'image': dataUrl});
//     if (_ok(json['status'])) return _s(json['data']);
//     throw BeatViewSingleProfileApiException(_s(json['message'], 'Image upload failed'));
//   }

//   Future<List<String>> uploadMultipleImages(List<String> dataUrls) async {
//     final json = await _post('/upload/imageuploadMultiple', {
//       'image': dataUrls.map((e) => {'image': e}).toList(),
//     });
//     if (!_ok(json['status'])) throw BeatViewSingleProfileApiException(_s(json['message'], 'Image upload failed'));
//     final data = json['data'];
//     if (data is! List) return <String>[];
//     return data.whereType<Map>().map((e) => _s(e['image_name'])).where((e) => e.isNotEmpty).toList();
//   }

//   Future<String> uploadVideoFile(XFile file) async {
//     final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload/video_upload'));
//     request.headers.addAll({
//       if (accessToken.isNotEmpty) 'Access-Token': accessToken,
//       if (accessSign.isNotEmpty) 'Access-Sign': accessSign,
//     });
//     request.files.add(await http.MultipartFile.fromPath('video', file.path, filename: file.name));
//     final streamed = await request.send();
//     final response = await http.Response.fromStream(streamed);
//     final json = _decode(response);
//     if (_ok(json['status']) && json['data'] is Map) return _s((json['data'] as Map)['file_name']);
//     throw BeatViewSingleProfileApiException(_s(json['message'], 'Video upload failed'));
//   }
// }

// class ViewSingleProfilePage extends StatefulWidget {
//   const ViewSingleProfilePage({
//     super.key,
//     this.api,
//     this.accessToken,
//     this.accessSign,
//     this.onGoBack,
//   });

//   final BeatViewSingleProfileApi? api;
//   final String? accessToken;
//   final String? accessSign;
//   final VoidCallback? onGoBack;

//   @override
//   State<ViewSingleProfilePage> createState() => _ViewSingleProfilePageState();
// }

// class _ViewSingleProfilePageState extends State<ViewSingleProfilePage> with TickerProviderStateMixin {
//   static const Color _lightBg = Color(0xFFFFF4FA);
//   static const Color _primary = Color(0xFF1D042A);
//   static const Color _maroon = Color(0xFF560827);
//   static const Color _navy = Color(0xFF06032C);
//   static const Color _pink = Color(0xFFE91E63);

//   late final TabController _tabController;
//   final ImagePicker _picker = ImagePicker();
//   BeatViewSingleProfileApi? _api;
//   SingleProfileBundle? _bundle;
//   SingleProfileData? get _profile => _bundle?.profile;
//   bool _loading = true;
//   bool _busy = false;
//   String? _error;
//   int _totalDistance = 0;

//   final _detailsControllers = <String, TextEditingController>{};
//   final _locationController = TextEditingController();
//   final _location1Controller = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 6, vsync: this);
//     _bootstrap();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     for (final c in _detailsControllers.values) {
//       c.dispose();
//     }
//     _locationController.dispose();
//     _location1Controller.dispose();
//     super.dispose();
//   }

//   Future<void> _bootstrap() async {
//     final prefs = await SharedPreferences.getInstance();
//     _api = widget.api ?? BeatViewSingleProfileApi(
//       accessToken: widget.accessToken ?? prefs.getString('Access-Token') ?? '',
//       accessSign: widget.accessSign ?? prefs.getString('Access-Sign') ?? '',
//     );
//     await _load();
//   }

//   Future<void> _load() async {
//     final api = _api;
//     if (api == null) return;
//     setState(() {
//       _loading = true;
//       _error = null;
//     });
//     try {
//       final bundle = await api.loadProfileBundle();
//       if (!mounted) return;
//       setState(() {
//         _bundle = bundle;
//         _totalDistance = bundle.profile == null ? 0 : _calculateDistance(bundle.profile!);
//       });
//       _hydrateControllers();
//     } catch (e) {
//       if (mounted) setState(() => _error = e.toString());
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   void _hydrateControllers() {
//     final profile = _profile;
//     if (profile == null) return;
//     for (final entry in profile.detailsPayload().entries) {
//       _detailsControllers.putIfAbsent(entry.key, () => TextEditingController()).text = _s(entry.value);
//     }
//     _locationController.text = profile.address;
//     _location1Controller.text = profile.address1;
//   }

//   int _calculateDistance(SingleProfileData profile) {
//     final lat = _d(profile.raw['lat']);
//     final lng = _d(profile.raw['lng']);
//     final lat1 = _d(profile.raw['lat_1']);
//     final lng1 = _d(profile.raw['lng_1']);
//     if (lat == null || lng == null || lat1 == null || lng1 == null) return 0;
//     if (lat == lat1 && lng == lng1) return 0;
//     final b = math.pi * lat / 180;
//     final g = math.pi * lat1 / 180;
//     final re = math.pi * (lng - lng1) / 180;
//     var x = math.sin(b) * math.sin(g) + math.cos(b) * math.cos(g) * math.cos(re);
//     if (x > 1) x = 1;
//     x = math.acos(x) * 180 / math.pi * 60 * 1.1515;
//     if (profile.distanceUnit.toLowerCase() == 'km') x *= 1.609344;
//     if (profile.distanceUnit.toLowerCase() == 'mi') x *= .8684;
//     return x.truncate();
//   }

//   void _snack(String message, {bool error = false}) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(message),
//       backgroundColor: error ? Colors.red.shade700 : Colors.green.shade700,
//     ));
//   }

//   Future<void> _runAction(Future<String> Function(BeatViewSingleProfileApi api) action) async {
//     final api = _api;
//     if (api == null) return;
//     setState(() => _busy = true);
//     try {
//       final message = await action(api);
//       _snack(message);
//       await _load();
//     } catch (e) {
//       _snack(e.toString(), error: true);
//     } finally {
//       if (mounted) setState(() => _busy = false);
//     }
//   }

//   Future<String?> _imageDataUrlFromPicker({bool multi = false}) async {
//     final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 88);
//     if (picked == null) return null;
//     final bytes = await picked.readAsBytes();
//     final ext = picked.name.toLowerCase().endsWith('.png') ? 'png' : 'jpeg';
//     return 'data:image/$ext;base64,${base64Encode(bytes)}';
//   }

//   Future<void> _uploadProfileImage() async {
//     final dataUrl = await _imageDataUrlFromPicker();
//     if (dataUrl == null) return;
//     await _runAction((api) async {
//       final name = await api.uploadImageDataUrl(dataUrl);
//       return api.uploadProfileImage(name);
//     });
//   }

//   Future<void> _replaceImage(SingleProfileImage img) async {
//     final dataUrl = await _imageDataUrlFromPicker();
//     if (dataUrl == null) return;
//     await _runAction((api) async {
//       final name = await api.uploadImageDataUrl(dataUrl);
//       return api.editProfileImage(id: img.id, imageName: name);
//     });
//   }

//   Future<void> _uploadProfileVideo() async {
//     final file = await _picker.pickVideo(source: ImageSource.gallery);
//     if (file == null) return;
//     await _runAction((api) async {
//       final name = await api.uploadVideoFile(file);
//       return api.uploadProfileVideo(name);
//     });
//   }

//   Future<void> _createAlbumDialog([SingleAlbum? album]) async {
//     final name = TextEditingController(text: album?.name ?? '');
//     final password = TextEditingController(text: album?.password ?? '');
//     final ok = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text(album == null ? 'Create Album' : 'Edit Album'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(controller: name, decoration: const InputDecoration(labelText: 'Album Name')),
//             TextField(controller: password, decoration: const InputDecoration(labelText: 'Album Password')),
//           ],
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
//           ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
//         ],
//       ),
//     );
//     if (ok != true) return;
//     await _runAction((api) {
//       if (album == null) return api.createAlbum(name: name.text.trim(), password: password.text.trim());
//       return api.updateAlbum(id: album.id, name: name.text.trim(), password: password.text.trim());
//     });
//   }

//   Future<void> _uploadAlbumImages(SingleAlbum album) async {
//     final picked = await _picker.pickMultiImage(imageQuality: 88);
//     if (picked.isEmpty) return;
//     await _runAction((api) async {
//       final dataUrls = <String>[];
//       for (final file in picked) {
//         final bytes = await file.readAsBytes();
//         final ext = file.name.toLowerCase().endsWith('.png') ? 'png' : 'jpeg';
//         dataUrls.add('data:image/$ext;base64,${base64Encode(bytes)}');
//       }
//       final names = await api.uploadMultipleImages(dataUrls);
//       var msg = 'Success';
//       for (final name in names) {
//         msg = await api.uploadAlbumImage(albumId: album.id, imageName: name);
//       }
//       return msg;
//     });
//   }

//   Future<void> _uploadAlbumVideo(SingleAlbum album) async {
//     final file = await _picker.pickVideo(source: ImageSource.gallery);
//     if (file == null) return;
//     await _runAction((api) async {
//       final name = await api.uploadVideoFile(file);
//       return api.uploadAlbumVideo(albumId: album.id, videoName: name);
//     });
//   }

//   Future<void> _viewAlbum(SingleAlbum album) async {
//     final api = _api;
//     if (api == null) return;
//     setState(() => _busy = true);
//     try {
//       final media = await api.getAlbumMedia(album.id);
//       if (!mounted) return;
//       showDialog<void>(
//         context: context,
//         builder: (_) => Dialog.fullscreen(
//           backgroundColor: Colors.black,
//           child: SafeArea(
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Expanded(child: Padding(padding: const EdgeInsets.all(12), child: Text(album.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)))),
//                     IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.white)),
//                   ],
//                 ),
//                 Expanded(
//                   child: GridView.builder(
//                     padding: const EdgeInsets.all(12),
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
//                     itemCount: media.length,
//                     itemBuilder: (_, i) {
//                       final item = media[i];
//                       if (item.isVideo) return const Center(child: Icon(Icons.videocam, color: Colors.white, size: 44));
//                       return Image.network(_resolveMediaUrl(item.image), fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.white));
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     } catch (e) {
//       _snack(e.toString(), error: true);
//     } finally {
//       if (mounted) setState(() => _busy = false);
//     }
//   }

//   Future<void> _saveInterests() async {
//     final profile = _profile;
//     if (profile == null) return;
//     await _runAction((api) => api.saveInterests(profile.interestPayload()));
//   }

//   Future<void> _saveDetails() async {
//     final payload = <String, dynamic>{};
//     for (final entry in _detailsControllers.entries) {
//       payload[entry.key] = entry.value.text;
//     }
//     await _runAction((api) => api.saveProfileDetails(payload));
//   }

//   Future<void> _saveLocation() async {
//     final address = _locationController.text.trim();
//     final address1 = _location1Controller.text.trim();
//     var lat = '0';
//     var lng = '0';
//     var lat1 = '0';
//     var lng1 = '0';
//     try {
//       if (address.isNotEmpty) {
//         final loc = await locationFromAddress(address);
//         if (loc.isNotEmpty) {
//           lat = loc.first.latitude.toString();
//           lng = loc.first.longitude.toString();
//         }
//       }
//       if (address1.isNotEmpty) {
//         final loc = await locationFromAddress(address1);
//         if (loc.isNotEmpty) {
//           lat1 = loc.first.latitude.toString();
//           lng1 = loc.first.longitude.toString();
//         }
//       }
//     } catch (_) {}
//     await _runAction((api) => api.updateLocation({
//           'formatted_address': address,
//           'lat': lat,
//           'lng': lng,
//           'formatted_address_1': address1,
//           'lat_1': lat1,
//           'lng_1': lng1,
//           'city_name': address,
//           'place_id': '',
//           'map_url': '',
//           'city_name_1': address1,
//           'place_id_1': '',
//           'map_url_1': '',
//         }));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _lightBg,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             if (_loading && _bundle == null)
//               const Center(child: CircularProgressIndicator(color: _maroon))
//             else if (_error != null)
//               _errorBox(_error!)
//             else
//               _content(),
//             if (_busy || (_loading && _bundle != null))
//               Positioned.fill(child: IgnorePointer(child: Container(color: Colors.black.withOpacity(.05), child: const Align(alignment: Alignment.topCenter, child: LinearProgressIndicator(color: _maroon))))),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _content() {
//     final profile = _profile;
//     if (profile == null) return _errorBox('Profile not found');
//     return RefreshIndicator(
//       color: _maroon,
//       onRefresh: _load,
//       child: ListView(
//         padding: const EdgeInsets.all(20),
//         children: [
//           _tabBar(),
//           const SizedBox(height: 18),
//           SizedBox(
//             height: MediaQuery.of(context).size.height * .78,
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 SingleChildScrollView(child: _homeTab(profile)),
//                 SingleChildScrollView(child: Column(children: [_detailsEditor(profile), _interestsEditor(profile)])),
//                 SingleChildScrollView(child: _photosManager()),
//                 SingleChildScrollView(child: _videosManager()),
//                 SingleChildScrollView(child: _albumsManager()),
//                 SingleChildScrollView(child: _locationEditor(profile)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _profileHeader(SingleProfileData profile) {
//     final image = _bundle?.profileImages.isNotEmpty == true ? _bundle!.profileImages.first.profileImage : '';
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: _gradientBox(radius: 16),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Image.network(_resolveMediaUrl(image), width: 100, height: 100, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 100, height: 100, color: Colors.white, child: const Icon(Icons.people, color: _maroon, size: 46))),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(profile.username, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20)),
//                 const SizedBox(height: 6),
//                 Text('${profile.age} Years', style: const TextStyle(color: Colors.white70)),
//                 Text(profile.genderProfileType, style: const TextStyle(color: Colors.white70)),
//                 if (profile.address.isNotEmpty) Text(profile.address, style: const TextStyle(color: Colors.white70)),
//                 if (profile.address1.isNotEmpty) Text('${profile.address1} | $_totalDistance ${profile.distanceUnit}', style: const TextStyle(color: Colors.white70)),
//               ],
//             ),
//           ),
//           IconButton(onPressed: widget.onGoBack ?? () => Navigator.maybePop(context), icon: const Icon(Icons.arrow_back, color: Colors.white)),
//         ],
//       ),
//     );
//   }

//   Widget _tabBar() {
//     return Container(
//       padding: const EdgeInsets.all(4),
//       decoration: _gradientBox(radius: 30),
//       child: TabBar(
//         controller: _tabController,
//         isScrollable: true,
//         indicator: BoxDecoration(color: _pink, borderRadius: BorderRadius.circular(26)),
//         indicatorSize: TabBarIndicatorSize.tab,
//         dividerColor: Colors.transparent,
//         labelColor: Colors.white,
//         unselectedLabelColor: Colors.white,
//         labelStyle: const TextStyle(fontWeight: FontWeight.w700),
//         tabs: const [
//           Tab(text: 'Home'),
//           Tab(text: 'Edit'),
//           Tab(text: 'Photos'),
//           Tab(text: 'Video'),
//           Tab(text: 'Album'),
//           Tab(text: 'Location'),
//         ],
//       ),
//     );
//   }

//   Widget _homeTab(SingleProfileData profile) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final wide = constraints.maxWidth >= 900;
//         if (wide) {
//           return Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(width: 320, child: _leftProfileCard(profile)),
//               const SizedBox(width: 42),
//               Expanded(child: _singleDetailTimeline(profile)),
//             ],
//           );
//         }
//         return Column(
//           children: [
//             _leftProfileCard(profile),
//             const SizedBox(height: 24),
//             _singleDetailTimeline(profile),
//           ],
//         );
//       },
//     );
//   }

//   Widget _leftProfileCard(SingleProfileData profile) {
//     final image = _bundle?.profileImages.isNotEmpty == true ? _bundle!.profileImages.first.profileImage : '';
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: _gradientBox(radius: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(5),
//             child: Image.network(
//               _resolveMediaUrl(image),
//               width: double.infinity,
//               height: 360,
//               fit: BoxFit.cover,
//               errorBuilder: (_, __, ___) => Container(
//                 height: 360,
//                 color: Colors.black,
//                 child: const Center(child: Icon(Icons.person, color: Colors.white, size: 68)),
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(profile.username, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
//           const SizedBox(height: 8),
//           Text('${profile.age} Years', style: const TextStyle(color: Colors.white, fontSize: 14)),
//           const SizedBox(height: 6),
//           Text(profile.genderProfileType, style: const TextStyle(color: Colors.white, fontSize: 14)),
//           if (profile.address.isNotEmpty) ...[
//             const SizedBox(height: 6),
//             Text(profile.address, style: const TextStyle(color: Colors.white, fontSize: 14)),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _singleDetailTimeline(SingleProfileData profile) {
//     final rows = <MapEntry<String, String>>[
//       MapEntry('Age', '${profile.age} Years'),
//       MapEntry('Tattoos', profile.value('person1_tattoos', 'Im not comfortable sharing that')),
//       MapEntry('Body Hair', profile.value('person1_body_hair', 'Im not comfortable sharing that')),
//       MapEntry('Weight', '${profile.value('person1_weight', 'Im not comfortable sharing that')} ${profile.value('weight1_type', '')}'.trim()),
//       MapEntry('Height', '${profile.value('person1_height', 'Im not comfortable sharing that')} ${profile.value('height1_type', '')}'.trim()),
//       MapEntry('Smoking', profile.value('person1_smoking', 'Im not comfortable sharing that')),
//       MapEntry('Drinking', profile.value('person1_drinking', 'Im not comfortable sharing that')),
//       MapEntry('Body Type', profile.value('person1_body_type', 'Im not comfortable sharing that')),
//       MapEntry('Language Spoken', profile.value('person1_language_spoken', 'Im not comfortable sharing that')),
//       MapEntry('Ethnic Background', profile.value('person1_ethnic_background', 'Im not comfortable sharing that')),
//       MapEntry('Piercings', profile.value('person1_piercings', 'Im not comfortable sharing that')),
//       MapEntry('Intelligence as importance', profile.value('person1_intelligence_importance', 'Im not comfortable sharing that')),
//       MapEntry('Looks are Important', profile.value('person1_looks_important', 'Im not comfortable sharing that')),
//       MapEntry('Relationship Orientation', profile.value('person1_relationship_orientation', 'Im not comfortable sharing that')),
//       MapEntry('Circumcised', profile.value('person1_circumcised', 'Im not comfortable sharing that')),
//       MapEntry('Sexuality', profile.value('person1_sexuality', 'Im not comfortable sharing that')),
//     ];
//     return Column(
//       children: rows.map((row) => _singleDetailRow(row.key, row.value.isEmpty ? 'N/A' : row.value)).toList(),
//     );
//   }

//   Widget _singleDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 26),
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           if (constraints.maxWidth < 620) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 _detailPill(label),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     _genderCircle(_genderAsset(_profile?.genderProfileType ?? 'Female')),
//                     const SizedBox(width: 14),
//                     Expanded(child: _valueBubble(value)),
//                   ],
//                 ),
//               ],
//             );
//           }
//           return Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(width: 230, child: _detailPill(label)),
//               const SizedBox(width: 34),
//               _genderCircle(_genderAsset(_profile?.genderProfileType ?? 'Female')),
//               const SizedBox(width: 18),
//               Flexible(child: _valueBubble(value)),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _detailPill(String text) {
//     return Container(
//       height: 38,
//       alignment: Alignment.center,
//       decoration: _gradientBox(radius: 22),
//       child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
//     );
//   }

//   Widget _valueBubble(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18), bottomRight: Radius.circular(18)),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 22, offset: const Offset(0, 8))],
//       ),
//       child: Text(text, style: const TextStyle(color: Colors.black, fontSize: 14)),
//     );
//   }

//   Widget _genderCircle(String asset) {
//     return Container(
//       width: 52,
//       height: 52,
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         shape: BoxShape.circle,
//         boxShadow: [BoxShadow(color: _pink.withOpacity(.23), blurRadius: 24, spreadRadius: 8)],
//       ),
//       child: asset.endsWith('.svg')
//           ? SvgPicture.network(_webAsset(asset), placeholderBuilder: (_) => const SizedBox())
//           : Image.network(_webAsset(asset), errorBuilder: (_, __, ___) => const SizedBox()),
//     );
//   }

//   String _genderAsset(String gender) {
//     if (gender == 'Male') return 'assets/img/icons/male.svg';
//     if (gender == 'Transgender') return 'assets/img/icons/transgender.svg';
//     return 'assets/img/icons/female.svg';
//   }

//   Widget _overview(SingleProfileData profile) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _section('Swingers', _iconWrap(profile, const {
//           'couple_male_female_swingers': 'assets/img/icon/female-male.png',
//           'couple_female_female_swingers': 'assets/img/icon/female-female.png',
//           'couple_male_male_swingers': 'assets/img/icon/male-male.png',
//           'couple_male_swingers': 'assets/img/icon/male.png',
//           'couple_female_swingers': 'assets/img/icon/female.png',
//           'couple_transgender_swingers': 'assets/img/icon/transgender.png',
//         })),
//         _section('HookUps/Meetups', _iconWrap(profile, const {
//           'couple_male_female_hookup_meetup': 'assets/img/icon/female-male.png',
//           'couple_female_female_hookup_meetup': 'assets/img/icon/female-female.png',
//           'couple_male_male_hookup_meetup': 'assets/img/icon/male-male.png',
//           'couple_male_hookup_meetup': 'assets/img/icon/male.png',
//           'couple_female_hookup_meetup': 'assets/img/icon/female.png',
//           'couple_transgender_hookup_meetup': 'assets/img/icon/transgender.png',
//         })),
//         if (profile.text.isNotEmpty || profile.comment.isNotEmpty)
//           _section('Bio', Text('${profile.text}\n${profile.comment}'.trim(), style: const TextStyle(fontSize: 14))),
//         _section('Profile Details', _singleDetailsTable(profile)),
//       ],
//     );
//   }

//   Widget _singleDetailsTable(SingleProfileData p) {
//     final fields = <String, String>{
//       'Age': '${p.age} Years',
//       'Tattoos': p.value('person1_tattoos'),
//       'Body Hair': p.value('person1_body_hair'),
//       'Weight': '${p.value('person1_weight', '')} ${p.value('weight1_type', '')}'.trim(),
//       'Height': '${p.value('person1_height', '')} ${p.value('height1_type', '')}'.trim(),
//       'Smoking': p.value('person1_smoking'),
//       'Drinking': p.value('person1_drinking'),
//       'Body Type': p.value('person1_body_type'),
//       'Language Spoken': p.value('person1_language_spoken'),
//       'Ethnic Background': p.value('person1_ethnic_background'),
//       'Piercings': p.value('person1_piercings'),
//       'Intelligence': p.value('person1_intelligence_importance'),
//       'Looks are Important': p.value('person1_looks_important'),
//       'Sexuality': p.value('person1_sexuality'),
//       'Relationship': p.value('person1_relationship_orientation'),
//       'Circumcised': p.value('person1_circumcised'),
//     };
//     return Container(
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
//       padding: const EdgeInsets.all(14),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(p.displayName, style: const TextStyle(fontSize: 18, color: _primary, fontWeight: FontWeight.w700)),
//           const Divider(),
//           ...fields.entries.map((e) => Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 5),
//                 child: Row(children: [Expanded(child: Text(e.key, style: const TextStyle(fontWeight: FontWeight.w600))), Expanded(child: Text(e.value.isEmpty ? 'N/A' : e.value))]),
//               )),
//         ],
//       ),
//     );
//   }

//   Widget _detailsEditor(SingleProfileData profile) {
//     final fields = <String>[
//       'text',
//       'comment',
//       'person1_name',
//       'person1_dob',
//       'person1_height',
//       'person1_weight',
//       'person1_body_type',
//       'person1_ethnic_background',
//       'person1_smoking',
//       'person1_drinking',
//       'person1_piercings',
//       'person1_tattoos',
//       'person1_language_spoken',
//       'person1_circumcised',
//       'person1_intelligence_importance',
//       'person1_sexuality',
//       'person1_relationship_orientation',
//       'person1_looks_important',
//       'person1_body_hair',
//       'height1_type',
//       'weight1_type',
//     ];
//     return _section('Edit Single Profile Details', Column(
//       children: [
//         ...fields.map((key) => Padding(
//               padding: const EdgeInsets.only(bottom: 10),
//               child: TextField(
//                 controller: _detailsControllers.putIfAbsent(key, () => TextEditingController(text: _s(profile.raw[key]))),
//                 maxLines: key == 'text' || key == 'comment' ? 3 : 1,
//                 decoration: InputDecoration(labelText: key.replaceAll('_', ' '), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
//               ),
//             )),
//         _primaryButton('Save Profile Details', _saveDetails),
//       ],
//     ));
//   }

//   Widget _interestsEditor(SingleProfileData profile) {
//     final payload = profile.interestPayload();
//     return _section('Edit Interests', StatefulBuilder(builder: (context, setLocal) {
//       Widget check(String label, String key) => CheckboxListTile(
//             value: _i(payload[key]) == 1,
//             onChanged: (v) => setLocal(() => payload[key] = v == true ? 1 : 0),
//             title: Text(label),
//             activeColor: _maroon,
//           );
//       return Column(
//         children: [
//           const Text('Swingers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
//           check('Couple Female/Male', 'couple_male_female_swingers'),
//           check('Couple Female/Female', 'couple_female_female_swingers'),
//           check('Couple Male/Male', 'couple_male_male_swingers'),
//           check('Female', 'couple_female_swingers'),
//           check('Male', 'couple_male_swingers'),
//           check('Transgender', 'couple_transgender_swingers'),
//           const Divider(),
//           const Text('Hookup / Meetup', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
//           check('Couple Female/Male', 'couple_male_female_hookup_meetup'),
//           check('Couple Female/Female', 'couple_female_female_hookup_meetup'),
//           check('Couple Male/Male', 'couple_male_male_hookup_meetup'),
//           check('Female', 'couple_female_hookup_meetup'),
//           check('Male', 'couple_male_hookup_meetup'),
//           check('Transgender', 'couple_transgender_hookup_meetup'),
//           _primaryButton('Save Interests', () => _runAction((api) => api.saveInterests(payload))),
//         ],
//       );
//     }));
//   }

//   Widget _photosManager() {
//     final b = _bundle;
//     if (b == null) return const SizedBox.shrink();
//     return _section('Photos', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Wrap(spacing: 10, runSpacing: 10, children: [
//         ...b.approvedImages.map((img) => _imageCard(img, approved: true)),
//         ...b.pendingImages.map((img) => _imageCard(img, approved: false)),
//       ]),
//       const SizedBox(height: 12),
//       _primaryButton('Upload Profile Photo', _uploadProfileImage),
//     ]));
//   }

//   Widget _videosManager() {
//     final b = _bundle;
//     if (b == null) return const SizedBox.shrink();
//     return _section('Video', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Wrap(spacing: 10, runSpacing: 10, children: [
//         ...b.approvedVideos.map((v) => _videoCard(v, approved: true)),
//         ...b.pendingVideos.map((v) => _videoCard(v, approved: false)),
//       ]),
//       const SizedBox(height: 12),
//       _primaryButton('Upload Profile Video', _uploadProfileVideo),
//     ]));
//   }

//   Widget _albumsManager() {
//     final b = _bundle;
//     if (b == null) return const SizedBox.shrink();
//     return _section('Album', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Wrap(spacing: 12, runSpacing: 12, children: b.albums.map(_albumCard).toList()),
//       const SizedBox(height: 12),
//       _primaryButton('Create Album', () => _createAlbumDialog()),
//     ]));
//   }

//   Widget _mediaManager() {
//     final b = _bundle;
//     if (b == null) return const SizedBox.shrink();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _section('Profile Photos', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Wrap(spacing: 10, runSpacing: 10, children: [
//             ...b.approvedImages.map((img) => _imageCard(img, approved: true)),
//             ...b.pendingImages.map((img) => _imageCard(img, approved: false)),
//           ]),
//           const SizedBox(height: 12),
//           _primaryButton('Upload Profile Photo', _uploadProfileImage),
//         ])),
//         _section('Profile Videos', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Wrap(spacing: 10, runSpacing: 10, children: [
//             ...b.approvedVideos.map((v) => _videoCard(v, approved: true)),
//             ...b.pendingVideos.map((v) => _videoCard(v, approved: false)),
//           ]),
//           const SizedBox(height: 12),
//           _primaryButton('Upload Profile Video', _uploadProfileVideo),
//         ])),
//         _section('Albums', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Wrap(spacing: 12, runSpacing: 12, children: b.albums.map(_albumCard).toList()),
//           const SizedBox(height: 12),
//           _primaryButton('Create Album', () => _createAlbumDialog()),
//         ])),
//       ],
//     );
//   }

//   Widget _imageCard(SingleProfileImage img, {required bool approved}) {
//     return Container(
//       width: 145,
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//       child: Column(children: [
//         Stack(children: [
//           ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(_resolveMediaUrl(img.profileImage), width: 128, height: 105, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox(width: 128, height: 105, child: Icon(Icons.broken_image)))),
//           Positioned(top: 4, left: 4, child: _statusBadge(approved ? 'Approved' : 'Pending', approved ? Colors.green : Colors.orange)),
//         ]),
//         CheckboxListTile(
//           value: img.isMain,
//           dense: true,
//           contentPadding: EdgeInsets.zero,
//           title: const Text('Set Main', style: TextStyle(fontSize: 12)),
//           onChanged: approved ? (_) => _runAction((api) => api.setProfileImage(img.id)) : null,
//         ),
//         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           IconButton(onPressed: () => _replaceImage(img), icon: const Icon(Icons.edit, size: 18)),
//           IconButton(onPressed: () => _runAction((api) => api.deleteProfileImage(img.id)), icon: const Icon(Icons.delete, size: 18, color: Colors.red)),
//         ]),
//       ]),
//     );
//   }

//   Widget _videoCard(SingleProfileVideo video, {required bool approved}) {
//     return Container(
//       width: 150,
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//       child: Column(children: [
//         Container(height: 92, alignment: Alignment.center, decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.play_circle, color: Colors.white, size: 42)),
//         const SizedBox(height: 6),
//         _statusBadge(approved ? 'APPROVED' : 'Awaiting Approval', approved ? Colors.green : Colors.orange),
//         IconButton(onPressed: () => _runAction((api) => api.deleteProfileVideo(video.id)), icon: const Icon(Icons.delete, color: Colors.red)),
//       ]),
//     );
//   }

//   Widget _albumCard(SingleAlbum album) {
//     return Container(
//       width: 170,
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Text(album.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
//         const SizedBox(height: 8),
//         ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(_resolveMediaUrl(album.image), width: 150, height: 105, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox(width: 150, height: 105, child: Icon(Icons.photo_album)))),
//         Wrap(children: [
//           TextButton(onPressed: () => _viewAlbum(album), child: const Text('View')),
//           TextButton(onPressed: () => _uploadAlbumImages(album), child: const Text('Add Photo')),
//           TextButton(onPressed: () => _uploadAlbumVideo(album), child: const Text('Add Video')),
//           IconButton(onPressed: () => _createAlbumDialog(album), icon: const Icon(Icons.edit, size: 18)),
//           IconButton(onPressed: () => _runAction((api) => api.deleteAlbum(album.id)), icon: const Icon(Icons.delete, size: 18, color: Colors.red)),
//         ]),
//       ]),
//     );
//   }

//   Widget _locationEditor(SingleProfileData profile) {
//     return _section('Location Settings', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       const Text('Your Current location is', style: TextStyle(fontWeight: FontWeight.w700)),
//       Text(profile.address),
//       const SizedBox(height: 12),
//       TextField(controller: _locationController, decoration: _input('Current Location')),
//       const SizedBox(height: 12),
//       TextField(controller: _location1Controller, decoration: _input('Second Location')),
//       const SizedBox(height: 12),
//       _primaryButton('Update Location', _saveLocation),
//     ]));
//   }

//   Widget _section(String title, Widget child) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 25)]),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Text(title, style: const TextStyle(color: _primary, fontWeight: FontWeight.w700, fontSize: 20)),
//         const SizedBox(height: 12),
//         child,
//       ]),
//     );
//   }

//   Widget _iconWrap(SingleProfileData profile, Map<String, String> flags) {
//     final icons = flags.entries.where((e) => profile.flag(e.key)).map((e) => e.value).toList();
//     if (icons.isEmpty) return const Text('N/A');
//     return Wrap(spacing: 8, runSpacing: 8, children: icons.map((path) => Image.network(_webAsset(path), width: 28, height: 28, errorBuilder: (_, __, ___) => const SizedBox())).toList());
//   }

//   Widget _statusBadge(String text, Color color) {
//     return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)), child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)));
//   }

//   InputDecoration _input(String label) => InputDecoration(labelText: label, filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)));

//   Widget _primaryButton(String label, Future<void> Function() onTap) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(backgroundColor: _maroon, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))),
//         onPressed: _busy ? null : onTap,
//         child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
//       ),
//     );
//   }

//   BoxDecoration _gradientBox({double radius = 12}) => BoxDecoration(
//         borderRadius: BorderRadius.circular(radius),
//         gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [_maroon, _navy]),
//       );

//   Widget _errorBox(String message) => Center(
//         child: Container(
//           margin: const EdgeInsets.all(20),
//           padding: const EdgeInsets.all(18),
//           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
//           child: Column(mainAxisSize: MainAxisSize.min, children: [
//             const Icon(Icons.error_outline, color: Colors.red, size: 42),
//             const SizedBox(height: 10),
//             Text(message, textAlign: TextAlign.center),
//             const SizedBox(height: 14),
//             ElevatedButton(onPressed: _load, style: ElevatedButton.styleFrom(backgroundColor: _maroon, foregroundColor: Colors.white), child: const Text('Retry')),
//           ]),
//         ),
//       );
// }
