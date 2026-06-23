// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // import 'package:beatflirt/providers/user_list_provider.dart';

// // // // // class ViewedMePage extends ConsumerWidget {
// // // // //   const ViewedMePage({super.key});

// // // // //   @override
// // // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // // //     final state = ref.watch(userListProvider('viewed_me'));

// // // // //     return Scaffold(
// // // // //       backgroundColor: const Color(0xFFF0F2F5),
// // // // //       appBar: AppBar(
// // // // //         title: const Text('Viewed Me', style: TextStyle(color: Colors.black)),
// // // // //         backgroundColor: Colors.white,
// // // // //         elevation: 0,
// // // // //         iconTheme: const IconThemeData(color: Colors.black),
// // // // //         leading: IconButton(
// // // // //           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
// // // // //           onPressed: () => Navigator.pop(context),
// // // // //         ),
// // // // //       ),
// // // // //       body: CustomScrollView(
// // // // //         slivers: [
// // // // //           const SliverPadding(
// // // // //             padding: EdgeInsets.all(16),
// // // // //             sliver: SliverToBoxAdapter(
// // // // //               child: Text(
// // // // //                 'People who checked your profile recently',
// // // // //                 style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //           SliverPadding(
// // // // //             padding: const EdgeInsets.symmetric(horizontal: 16),
// // // // //             sliver: SliverGrid(
// // // // //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// // // // //                 crossAxisCount: 2,
// // // // //                 mainAxisSpacing: 16,
// // // // //                 crossAxisSpacing: 16,
// // // // //                 childAspectRatio: 0.8,
// // // // //               ),
// // // // //               delegate: SliverChildBuilderDelegate(
// // // // //                 (context, index) {
// // // // //                   final user = state.users[index];
// // // // //                   return Container(
// // // // //                     decoration: BoxDecoration(
// // // // //                       color: Colors.white,
// // // // //                       borderRadius: BorderRadius.circular(20),
// // // // //                       boxShadow: [
// // // // //                         BoxShadow(
// // // // //                           color: Colors.black.withValues(alpha: 0.05),
// // // // //                           blurRadius: 10,
// // // // //                         ),
// // // // //                       ],
// // // // //                     ),
// // // // //                     child: Column(
// // // // //                       children: [
// // // // //                         Expanded(
// // // // //                           child: Container(
// // // // //                             margin: const EdgeInsets.all(8),
// // // // //                             decoration: BoxDecoration(
// // // // //                               borderRadius: BorderRadius.circular(15),
// // // // //                               image: DecorationImage(
// // // // //                                 image: AssetImage(user.imageUrl),
// // // // //                                 fit: BoxFit.cover,
// // // // //                               ),
// // // // //                             ),
// // // // //                           ),
// // // // //                         ),
// // // // //                         Padding(
// // // // //                           padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
// // // // //                           child: Column(
// // // // //                             children: [
// // // // //                               Text(
// // // // //                                 user.name,
// // // // //                                 style: const TextStyle(fontWeight: FontWeight.bold),
// // // // //                               ),
// // // // //                               const SizedBox(height: 4),
// // // // //                               Text(
// // // // //                                 user.lastSeen,
// // // // //                                 style: TextStyle(color: Colors.pinkAccent, fontSize: 12),
// // // // //                               ),
// // // // //                             ],
// // // // //                           ),
// // // // //                         ),
// // // // //                       ],
// // // // //                     ),
// // // // //                   );
// // // // //                 },
// // // // //                 childCount: state.users.length,
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //           const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // import 'package:flutter/material.dart';
// // // // import 'package:http/http.dart' as http;
// // // // import 'dart:convert';
// // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // import 'package:beatflirt/core/services/auth_services.dart';

// // // // // ============================================================
// // // // //                    BEAT FLIRT - VIEWED ME INTEGRATION
// // // // //                    Single File - Ready to Copy
// // // // // ============================================================

// // // // const String VIEWED_ME_BASE_URL = 'https://app.beatflirtevent.com/App';

// // // // // ============================================================
// // // // //                           MODELS
// // // // // ============================================================

// // // // class ViewedUserModel {
// // // //   final int? id;
// // // //   final String? username;
// // // //   final String? profileImage;
// // // //   final String? viewedAt;
// // // //   final bool? isOnline;
// // // //   final String? age;
// // // //   final String? location;

// // // //   ViewedUserModel({
// // // //     this.id,
// // // //     this.username,
// // // //     this.profileImage,
// // // //     this.viewedAt,
// // // //     this.isOnline,
// // // //     this.age,
// // // //     this.location,
// // // //   });

// // // //   factory ViewedUserModel.fromJson(Map<String, dynamic> json) {
// // // //     return ViewedUserModel(
// // // //       id: json['id'],
// // // //       username: json['username'] ?? json['name'],
// // // //       profileImage: json['profile_image'] ?? json['image'],
// // // //       viewedAt: json['viewed_at'] ?? json['time'],
// // // //       isOnline: json['is_online'] ?? false,
// // // //       age: json['age']?.toString(),
// // // //       location: json['location'] ?? json['city'],
// // // //     );
// // // //   }
// // // // }

// // // // class UserProfileModel {
// // // //   final int? id;
// // // //   final String? username;
// // // //   final String? email;
// // // //   final String? profileImage;
// // // //   final String? coverImage;
// // // //   final String? bio;
// // // //   final String? age;
// // // //   final String? location;
// // // //   final String? gender;
// // // //   final bool? isOnline;
// // // //   final List<String>? interests;
// // // //   final List<String>? photos;
// // // //   final String? about;
// // // //   final bool? isCouple;

// // // //   UserProfileModel({
// // // //     this.id,
// // // //     this.username,
// // // //     this.email,
// // // //     this.profileImage,
// // // //     this.coverImage,
// // // //     this.bio,
// // // //     this.age,
// // // //     this.location,
// // // //     this.gender,
// // // //     this.isOnline,
// // // //     this.interests,
// // // //     this.photos,
// // // //     this.about,
// // // //     this.isCouple,
// // // //   });

// // // //   factory UserProfileModel.fromJson(Map<String, dynamic> json) {
// // // //     return UserProfileModel(
// // // //       id: json['id'],
// // // //       username: json['username'] ?? json['name'],
// // // //       email: json['email'],
// // // //       profileImage: json['profile_image'] ?? json['image'],
// // // //       coverImage: json['cover_image'],
// // // //       bio: json['bio'] ?? json['description'],
// // // //       age: json['age']?.toString(),
// // // //       location: json['location'] ?? json['city'],
// // // //       gender: json['gender'],
// // // //       isOnline: json['is_online'] ?? false,
// // // //       interests: json['interests'] != null ? List<String>.from(json['interests']) : null,
// // // //       photos: json['photos'] != null ? List<String>.from(json['photos']) : null,
// // // //       about: json['about'],
// // // //       isCouple: json['is_couple'] ?? false,
// // // //     );
// // // //   }
// // // // }

// // // // // ============================================================
// // // // //                           API SERVICE
// // // // // ============================================================

// // // // class ViewedMeApi {
// // // //   static String? _token;

// // // //   static Map<String, String> get _headers => {
// // // //         'Content-Type': 'application/json',
// // // //         'Accept': 'application/json',
// // // //         if (_token != null && _token!.isNotEmpty) 'Authorization': 'Bearer $_token',
// // // //       };

// // // //   static Future<void> saveToken(String token) async {
// // // //     _token = token;
// // // //     final prefs = await SharedPreferences.getInstance();
// // // //     await prefs.setString('bf_auth_token', token);
// // // //     debugPrint('ViewedMePage API: Token saved: $token');
// // // //   }

// // // //   static Future<void> loadToken() async {
// // // //     final prefs = await SharedPreferences.getInstance();
// // // //     _token = prefs.getString('bf_auth_token');
// // // //     debugPrint('ViewedMePage API: Checked bf_auth_token: $_token');
// // // //     if (_token == null || _token!.isEmpty) {
// // // //       _token = prefs.getString('auth_token');
// // // //       debugPrint('ViewedMePage API: Checked auth_token: $_token');
// // // //     }
// // // //     if (_token == null || _token!.isEmpty) {
// // // //       _token = await AuthService.getToken();
// // // //       debugPrint('ViewedMePage API: Checked AuthService token: $_token');
// // // //     }
// // // //   }

// // // //   static Future<void> clearToken() async {
// // // //     _token = null;
// // // //     final prefs = await SharedPreferences.getInstance();
// // // //     await prefs.remove('bf_auth_token');
// // // //     debugPrint('ViewedMePage API: Token cleared');
// // // //   }

// // // //   static bool get isLoggedIn => _token != null && _token!.isNotEmpty;

// // // //   // ==================== VIEWED ME ====================
// // // //   static Future<List<dynamic>> getViewedMe() async {
// // // //     await loadToken();

// // // //     final token = _token ?? '';
// // // //     final paths = ['/user/viewed_me', '/user/who_i_viewed'];

// // // //     // Define different header/parameter combinations to try
// // // //     final formats = [
// // // //       // 1. Authorization: Bearer <token>
// // // //       {'name': 'Header: Authorization: Bearer', 'method': 'GET', 'headers': {'Authorization': 'Bearer $token'}, 'url_suffix': ''},
// // // //       // 2. Authorization: <token>
// // // //       {'name': 'Header: Authorization: Raw', 'method': 'GET', 'headers': {'Authorization': token}, 'url_suffix': ''},
// // // //       // 3. token: <token>
// // // //       {'name': 'Header: token', 'method': 'GET', 'headers': {'token': token}, 'url_suffix': ''},
// // // //       // 4. Authtoken: <token>
// // // //       {'name': 'Header: Authtoken', 'method': 'GET', 'headers': {'Authtoken': token}, 'url_suffix': ''},
// // // //       // 5. access-token: <token>
// // // //       {'name': 'Header: access-token', 'method': 'GET', 'headers': {'access-token': token}, 'url_suffix': ''},
// // // //       // 6. access_token: <token>
// // // //       {'name': 'Header: access_token', 'method': 'GET', 'headers': {'access_token': token}, 'url_suffix': ''},
// // // //       // 7. GET Query param token
// // // //       {'name': 'Query: ?token=', 'method': 'GET', 'headers': <String, String>{}, 'url_suffix': '?token=$token'},
// // // //       // 8. GET Query param Authtoken
// // // //       {'name': 'Query: ?Authtoken=', 'method': 'GET', 'headers': <String, String>{}, 'url_suffix': '?Authtoken=$token'},
// // // //       // 9. POST body JSON token
// // // //       {'name': 'POST: Body JSON token', 'method': 'POST_JSON', 'headers': {'Content-Type': 'application/json'}, 'body': {'token': token}, 'url_suffix': ''},
// // // //       // 10. POST body Form token
// // // //       {'name': 'POST: Body Form token', 'method': 'POST_FORM', 'headers': {'Content-Type': 'application/x-www-form-urlencoded'}, 'body': {'token': token}, 'url_suffix': ''},
// // // //       // 11. POST body JSON Authtoken
// // // //       {'name': 'POST: Body JSON Authtoken', 'method': 'POST_JSON', 'headers': {'Content-Type': 'application/json'}, 'body': {'Authtoken': token}, 'url_suffix': ''},
// // // //       // 12. POST body Form Authtoken
// // // //       {'name': 'POST: Body Form Authtoken', 'method': 'POST_FORM', 'headers': {'Content-Type': 'application/x-www-form-urlencoded'}, 'body': {'Authtoken': token}, 'url_suffix': ''},
// // // //     ];

// // // //     for (final path in paths) {
// // // //       for (final fmt in formats) {
// // // //         final name = fmt['name'] as String;
// // // //         final method = fmt['method'] as String;
// // // //         final headers = Map<String, String>.from(fmt['headers'] as Map);
// // // //         final suffix = fmt['url_suffix'] as String;
// // // //         final url = Uri.parse('$VIEWED_ME_BASE_URL$path$suffix');

// // // //         debugPrint('ViewedMePage API PROBE: Trying $name on $url');

// // // //         try {
// // // //           http.Response response;
// // // //           if (method == 'GET') {
// // // //             response = await http.get(url, headers: {
// // // //               'Content-Type': 'application/json',
// // // //               'Accept': 'application/json',
// // // //               ...headers,
// // // //             });
// // // //           } else if (method == 'POST_JSON') {
// // // //             final bodyMap = fmt['body'] as Map<String, dynamic>;
// // // //             response = await http.post(url, headers: headers, body: jsonEncode(bodyMap));
// // // //           } else { // POST_FORM
// // // //             final bodyMap = fmt['body'] as Map<String, String>;
// // // //             response = await http.post(url, headers: headers, body: bodyMap);
// // // //           }

// // // //           debugPrint('ViewedMePage API PROBE [$name on $path]: Status ${response.statusCode}');
// // // //           debugPrint('ViewedMePage API PROBE [$name on $path]: Body: ${response.body}');

// // // //           if (response.statusCode == 200) {
// // // //             final decoded = jsonDecode(response.body);
// // // //             if (decoded is List) {
// // // //               debugPrint('ViewedMePage API PROBE WINNER: $name on $path');
// // // //               return decoded;
// // // //             } else if (decoded is Map) {
// // // //               final status = decoded['status']?.toString();
// // // //               if (status == '200' || status == 'success') {
// // // //                 if (decoded['data'] is List) {
// // // //                   debugPrint('ViewedMePage API PROBE WINNER: $name on $path');
// // // //                   return decoded['data'];
// // // //                 }
// // // //               }
// // // //             }
// // // //           }
// // // //         } catch (e) {
// // // //           debugPrint('ViewedMePage API PROBE [$name on $path] Error: $e');
// // // //         }
// // // //       }
// // // //     }

// // // //     throw Exception('All Viewed Me token passing configuration probes failed.');
// // // //   }

// // // //   // ==================== SINGLE USER PROFILE ====================
// // // //   static Future<Map<String, dynamic>> getSingleUserProfile(int userId) async {
// // // //     await loadToken();
// // // //     final url = Uri.parse('$VIEWED_ME_BASE_URL/single-user-profile?user_id=$userId');
// // // //     debugPrint('ViewedMePage API: GET Request to $url');
// // // //     debugPrint('ViewedMePage API: Headers: $_headers');
// // // //     try {
// // // //       final response = await http.get(url, headers: _headers);
// // // //       debugPrint('ViewedMePage API: Response Status Code: ${response.statusCode}');
// // // //       debugPrint('ViewedMePage API: Response Body: ${response.body}');
// // // //       if (response.statusCode == 200) {
// // // //         return jsonDecode(response.body);
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint('ViewedMePage API: GET Single User Profile failed: $e');
// // // //       rethrow;
// // // //     }
// // // //     throw Exception('Failed to load user profile');
// // // //   }

// // // //   static Future<Map<String, dynamic>> getViewSingleProfile(int userId) async {
// // // //     await loadToken();
// // // //     final url = Uri.parse('$VIEWED_ME_BASE_URL/view-single-profile?id=$userId');
// // // //     debugPrint('ViewedMePage API: GET Request to $url');
// // // //     debugPrint('ViewedMePage API: Headers: $_headers');
// // // //     try {
// // // //       final response = await http.get(url, headers: _headers);
// // // //       debugPrint('ViewedMePage API: Response Status Code: ${response.statusCode}');
// // // //       debugPrint('ViewedMePage API: Response Body: ${response.body}');
// // // //       if (response.statusCode == 200) {
// // // //         return jsonDecode(response.body);
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint('ViewedMePage API: GET View Single Profile failed: $e');
// // // //       rethrow;
// // // //     }
// // // //     throw Exception('Failed to load user profile');
// // // //   }

// // // //   // ==================== MESSAGING ====================
// // // //   static Future<bool> sendMessage(int userId, String message) async {
// // // //     await loadToken();
// // // //     final url = Uri.parse('$VIEWED_ME_BASE_URL/message');
// // // //     debugPrint('ViewedMePage API: POST Request to $url');
// // // //     debugPrint('ViewedMePage API: Headers: $_headers');
// // // //     final payload = {'receiver_id': userId, 'message': message};
// // // //     debugPrint('ViewedMePage API: Body: $payload');
// // // //     try {
// // // //       final response = await http.post(
// // // //         url,
// // // //         headers: _headers,
// // // //         body: jsonEncode(payload),
// // // //       );
// // // //       debugPrint('ViewedMePage API: Response Status Code: ${response.statusCode}');
// // // //       debugPrint('ViewedMePage API: Response Body: ${response.body}');
// // // //       return response.statusCode == 200 || response.statusCode == 201;
// // // //     } catch (e) {
// // // //       debugPrint('ViewedMePage API: POST Send Message failed: $e');
// // // //       return false;
// // // //     }
// // // //   }
// // // // }

// // // // // ============================================================
// // // // //                    VIEWED ME SCREEN
// // // // // ============================================================

// // // // class ViewedMePage extends StatefulWidget {
// // // //   const ViewedMePage({super.key});

// // // //   @override
// // // //   State<ViewedMePage> createState() => _ViewedMePageState();
// // // // }

// // // // class _ViewedMePageState extends State<ViewedMePage> {
// // // //   List<ViewedUserModel> users = [];
// // // //   bool isLoading = true;

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _loadViewedMe();
// // // //   }

// // // //   Future<void> _loadViewedMe() async {
// // // //     setState(() => isLoading = true);
// // // //     try {
// // // //       final data = await ViewedMeApi.getViewedMe();
// // // //       setState(() {
// // // //         users = data.map((e) => ViewedUserModel.fromJson(e)).toList();
// // // //         isLoading = false;
// // // //       });
// // // //     } catch (e) {
// // // //       setState(() => isLoading = false);
// // // //       if (mounted) {
// // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // //           SnackBar(content: Text('Failed to load viewed users: $e')),
// // // //         );
// // // //       }
// // // //     }
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: const Text('Who Viewed Me'),
// // // //         actions: [
// // // //           IconButton(
// // // //             icon: const Icon(Icons.refresh),
// // // //             onPressed: _loadViewedMe,
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       body: isLoading
// // // //           ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFC107)))
// // // //           : users.isEmpty
// // // //               ? _buildEmptyState()
// // // //               : _buildUserList(),
// // // //     );
// // // //   }

// // // //   Widget _buildEmptyState() {
// // // //     return Center(
// // // //       child: Column(
// // // //         mainAxisAlignment: MainAxisAlignment.center,
// // // //         children: [
// // // //           Icon(Icons.visibility_off, size: 80, color: Colors.grey[700]),
// // // //           const SizedBox(height: 20),
// // // //           const Text('No Views Yet', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
// // // //           const SizedBox(height: 8),
// // // //           const Text(
// // // //             'When someone views your profile,\nthey will appear here.',
// // // //             textAlign: TextAlign.center,
// // // //             style: TextStyle(color: Colors.grey),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildUserList() {
// // // //     return RefreshIndicator(
// // // //       onRefresh: _loadViewedMe,
// // // //       child: ListView.builder(
// // // //         padding: const EdgeInsets.all(12),
// // // //         itemCount: users.length,
// // // //         itemBuilder: (context, index) {
// // // //           final user = users[index];
// // // //           return _buildUserCard(user);
// // // //         },
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildUserCard(ViewedUserModel user) {
// // // //     return Card(
// // // //       margin: const EdgeInsets.only(bottom: 12),
// // // //       elevation: 4,
// // // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// // // //       child: InkWell(
// // // //         borderRadius: BorderRadius.circular(16),
// // // //         onTap: () {
// // // //           if (user.id != null) {
// // // //             Navigator.push(
// // // //               context,
// // // //               MaterialPageRoute(
// // // //                 builder: (_) => SingleUserProfileScreen(userId: user.id!),
// // // //               ),
// // // //             );
// // // //           }
// // // //         },
// // // //         child: Padding(
// // // //           padding: const EdgeInsets.all(16),
// // // //           child: Row(
// // // //             children: [
// // // //               Stack(
// // // //                 children: [
// // // //                   CircleAvatar(
// // // //                     radius: 35,
// // // //                     backgroundColor: Colors.grey[800],
// // // //                     backgroundImage: user.profileImage != null
// // // //                         ? NetworkImage(user.profileImage!)
// // // //                         : null,
// // // //                     child: user.profileImage == null
// // // //                         ? const Icon(Icons.person, size: 35, color: Colors.white70)
// // // //                         : null,
// // // //                   ),
// // // //                   if (user.isOnline == true)
// // // //                     Positioned(
// // // //                       bottom: 4,
// // // //                       right: 4,
// // // //                       child: Container(
// // // //                         width: 14,
// // // //                         height: 14,
// // // //                         decoration: BoxDecoration(
// // // //                           color: Colors.green,
// // // //                           shape: BoxShape.circle,
// // // //                           border: Border.all(color: Colors.black, width: 2),
// // // //                         ),
// // // //                       ),
// // // //                     ),
// // // //                 ],
// // // //               ),
// // // //               const SizedBox(width: 16),
// // // //               Expanded(
// // // //                 child: Column(
// // // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // // //                   children: [
// // // //                     Text(
// // // //                       user.username ?? 'Unknown User',
// // // //                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // // //                     ),
// // // //                     if (user.age != null || user.location != null)
// // // //                       Padding(
// // // //                         padding: const EdgeInsets.only(top: 4),
// // // //                         child: Text(
// // // //                           '${user.age != null ? '${user.age} years' : ''}'
// // // //                           '${user.age != null && user.location != null ? ' • ' : ''}'
// // // //                           '${user.location ?? ''}',
// // // //                           style: const TextStyle(color: Colors.grey),
// // // //                         ),
// // // //                       ),
// // // //                     const SizedBox(height: 6),
// // // //                     Text(
// // // //                       user.viewedAt != null ? 'Viewed ${user.viewedAt}' : 'Recently viewed you',
// // // //                       style: TextStyle(color: Colors.grey[400], fontSize: 13),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //               const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // // ============================================================
// // // // //                 SINGLE USER PROFILE SCREEN
// // // // // ============================================================

// // // // class SingleUserProfileScreen extends StatefulWidget {
// // // //   final int userId;
// // // //   const SingleUserProfileScreen({super.key, required this.userId});

// // // //   @override
// // // //   State<SingleUserProfileScreen> createState() => _SingleUserProfileScreenState();
// // // // }

// // // // class _SingleUserProfileScreenState extends State<SingleUserProfileScreen> {
// // // //   UserProfileModel? user;
// // // //   bool isLoading = true;
// // // //   bool isSendingMessage = false;
// // // //   final TextEditingController _messageController = TextEditingController();

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _loadUserProfile();
// // // //   }

// // // //   Future<void> _loadUserProfile() async {
// // // //     setState(() => isLoading = true);
// // // //     try {
// // // //       Map<String, dynamic> data;
// // // //       try {
// // // //         data = await ViewedMeApi.getSingleUserProfile(widget.userId);
// // // //       } catch (_) {
// // // //         data = await ViewedMeApi.getViewSingleProfile(widget.userId);
// // // //       }

// // // //       setState(() {
// // // //         user = UserProfileModel.fromJson(data);
// // // //         isLoading = false;
// // // //       });
// // // //     } catch (e) {
// // // //       setState(() => isLoading = false);
// // // //       if (mounted) {
// // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // //           SnackBar(content: Text('Failed to load profile: $e')),
// // // //         );
// // // //       }
// // // //     }
// // // //   }

// // // //   Future<void> _sendMessage() async {
// // // //     if (_messageController.text.trim().isEmpty || user?.id == null) return;

// // // //     setState(() => isSendingMessage = true);

// // // //     try {
// // // //       final success = await ViewedMeApi.sendMessage(
// // // //         user!.id!,
// // // //         _messageController.text.trim(),
// // // //       );

// // // //       if (success) {
// // // //         _messageController.clear();
// // // //         if (mounted) {
// // // //           ScaffoldMessenger.of(context).showSnackBar(
// // // //             const SnackBar(
// // // //               content: Text('Message sent successfully!'),
// // // //               backgroundColor: Colors.green,
// // // //             ),
// // // //           );
// // // //         }
// // // //       } else {
// // // //         throw Exception('Failed to send message');
// // // //       }
// // // //     } catch (e) {
// // // //       if (mounted) {
// // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // //           SnackBar(content: Text('Failed to send message: $e')),
// // // //         );
// // // //       }
// // // //     }

// // // //     setState(() => isSendingMessage = false);
// // // //   }

// // // //   @override
// // // //   void dispose() {
// // // //     _messageController.dispose();
// // // //     super.dispose();
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       backgroundColor: const Color(0xFF121212),
// // // //       body: isLoading
// // // //           ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFC107)))
// // // //           : user == null
// // // //               ? _buildErrorState()
// // // //               : _buildProfileContent(),
// // // //     );
// // // //   }

// // // //   Widget _buildErrorState() {
// // // //     return Scaffold(
// // // //       appBar: AppBar(title: const Text('Profile')),
// // // //       body: Center(
// // // //         child: Column(
// // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // //           children: [
// // // //             const Icon(Icons.error_outline, size: 60, color: Colors.red),
// // // //             const SizedBox(height: 16),
// // // //             const Text('Failed to load profile'),
// // // //             const SizedBox(height: 20),
// // // //             ElevatedButton(
// // // //               onPressed: _loadUserProfile,
// // // //               child: const Text('Try Again'),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildProfileContent() {
// // // //     return CustomScrollView(
// // // //       slivers: [
// // // //         SliverAppBar(
// // // //           expandedHeight: 280,
// // // //           pinned: true,
// // // //           backgroundColor: const Color(0xFF1E1E1E),
// // // //           flexibleSpace: FlexibleSpaceBar(
// // // //             background: Stack(
// // // //               fit: StackFit.expand,
// // // //               children: [
// // // //                 user!.coverImage != null
// // // //                     ? Image.network(
// // // //                         user!.coverImage!,
// // // //                         fit: BoxFit.cover,
// // // //                         errorBuilder: (_, __, ___) => _buildDefaultCover(),
// // // //                       )
// // // //                     : _buildDefaultCover(),
// // // //                 Container(
// // // //                   decoration: BoxDecoration(
// // // //                     gradient: LinearGradient(
// // // //                       begin: Alignment.topCenter,
// // // //                       end: Alignment.bottomCenter,
// // // //                       colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //                 if (user!.isOnline == true)
// // // //                   Positioned(
// // // //                     top: 50,
// // // //                     right: 16,
// // // //                     child: Container(
// // // //                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // // //                       decoration: BoxDecoration(
// // // //                         color: Colors.green,
// // // //                         borderRadius: BorderRadius.circular(20),
// // // //                       ),
// // // //                       child: const Row(
// // // //                         mainAxisSize: MainAxisSize.min,
// // // //                         children: [
// // // //                           Icon(Icons.circle, size: 10, color: Colors.white),
// // // //                           SizedBox(width: 6),
// // // //                           Text('Online', style: TextStyle(color: Colors.white, fontSize: 12)),
// // // //                         ],
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ),
// // // //         SliverToBoxAdapter(
// // // //           child: Padding(
// // // //             padding: const EdgeInsets.all(20),
// // // //             child: Column(
// // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // //               children: [
// // // //                 // Profile Header
// // // //                 Row(
// // // //                   children: [
// // // //                     CircleAvatar(
// // // //                       radius: 50,
// // // //                       backgroundColor: Colors.grey[800],
// // // //                       backgroundImage: user!.profileImage != null
// // // //                           ? NetworkImage(user!.profileImage!)
// // // //                           : null,
// // // //                       child: user!.profileImage == null
// // // //                           ? const Icon(Icons.person, size: 50, color: Colors.white70)
// // // //                           : null,
// // // //                     ),
// // // //                     const SizedBox(width: 20),
// // // //                     Expanded(
// // // //                       child: Column(
// // // //                         crossAxisAlignment: CrossAxisAlignment.start,
// // // //                         children: [
// // // //                           Text(
// // // //                             user!.username ?? 'User',
// // // //                             style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
// // // //                           ),
// // // //                           if (user!.age != null || user!.location != null)
// // // //                             Padding(
// // // //                               padding: const EdgeInsets.only(top: 6),
// // // //                               child: Text(
// // // //                                 '${user!.age != null ? '${user!.age} years' : ''}'
// // // //                                 '${user!.age != null && user!.location != null ? ' • ' : ''}'
// // // //                                 '${user!.location ?? ''}',
// // // //                                 style: const TextStyle(fontSize: 16, color: Colors.grey),
// // // //                               ),
// // // //                             ),
// // // //                           if (user!.gender != null)
// // // //                             Padding(
// // // //                               padding: const EdgeInsets.only(top: 4),
// // // //                               child: Text(user!.gender!, style: const TextStyle(color: Colors.grey)),
// // // //                             ),
// // // //                         ],
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ),

// // // //                 const SizedBox(height: 30),

// // // //                 // About
// // // //                 if (user!.about != null || user!.bio != null) ...[
// // // //                   const Text('About', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// // // //                   const SizedBox(height: 10),
// // // //                   Container(
// // // //                     padding: const EdgeInsets.all(16),
// // // //                     decoration: BoxDecoration(
// // // //                       color: const Color(0xFF1E1E1E),
// // // //                       borderRadius: BorderRadius.circular(12),
// // // //                     ),
// // // //                     child: Text(
// // // //                       user!.about ?? user!.bio ?? '',
// // // //                       style: const TextStyle(fontSize: 15, height: 1.5),
// // // //                     ),
// // // //                   ),
// // // //                   const SizedBox(height: 30),
// // // //                 ],

// // // //                 // Interests
// // // //                 if (user!.interests != null && user!.interests!.isNotEmpty) ...[
// // // //                   const Text('Interests', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// // // //                   const SizedBox(height: 12),
// // // //                   Wrap(
// // // //                     spacing: 8,
// // // //                     runSpacing: 8,
// // // //                     children: user!.interests!.map((interest) {
// // // //                       return Chip(
// // // //                         label: Text(interest),
// // // //                         backgroundColor: const Color(0xFFFFC107).withOpacity(0.15),
// // // //                         labelStyle: const TextStyle(color: Color(0xFFFFC107)),
// // // //                       );
// // // //                     }).toList(),
// // // //                   ),
// // // //                   const SizedBox(height: 30),
// // // //                 ],

// // // //                 // Photos
// // // //                 if (user!.photos != null && user!.photos!.isNotEmpty) ...[
// // // //                   const Text('Photos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// // // //                   const SizedBox(height: 12),
// // // //                   SizedBox(
// // // //                     height: 120,
// // // //                     child: ListView.builder(
// // // //                       scrollDirection: Axis.horizontal,
// // // //                       itemCount: user!.photos!.length,
// // // //                       itemBuilder: (context, index) {
// // // //                         return Padding(
// // // //                           padding: const EdgeInsets.only(right: 12),
// // // //                           child: ClipRRect(
// // // //                             borderRadius: BorderRadius.circular(12),
// // // //                             child: Image.network(
// // // //                               user!.photos![index],
// // // //                               width: 120,
// // // //                               height: 120,
// // // //                               fit: BoxFit.cover,
// // // //                               errorBuilder: (_, __, ___) => Container(
// // // //                                 width: 120,
// // // //                                 height: 120,
// // // //                                 color: Colors.grey[800],
// // // //                                 child: const Icon(Icons.image_not_supported),
// // // //                               ),
// // // //                             ),
// // // //                           ),
// // // //                         );
// // // //                       },
// // // //                     ),
// // // //                   ),
// // // //                   const SizedBox(height: 40),
// // // //                 ],

// // // //                 // Message Section
// // // //                 const Text('Send a Message', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// // // //                 const SizedBox(height: 16),
// // // //                 Container(
// // // //                   decoration: BoxDecoration(
// // // //                     color: const Color(0xFF1E1E1E),
// // // //                     borderRadius: BorderRadius.circular(16),
// // // //                   ),
// // // //                   child: Column(
// // // //                     children: [
// // // //                       TextField(
// // // //                         controller: _messageController,
// // // //                         maxLines: 4,
// // // //                         minLines: 3,
// // // //                         decoration: const InputDecoration(
// // // //                           hintText: 'Write your message here...',
// // // //                           border: InputBorder.none,
// // // //                           contentPadding: EdgeInsets.all(16),
// // // //                         ),
// // // //                       ),
// // // //                       const Divider(height: 1),
// // // //                       Padding(
// // // //                         padding: const EdgeInsets.all(12),
// // // //                         child: SizedBox(
// // // //                           width: double.infinity,
// // // //                           child: ElevatedButton.icon(
// // // //                             onPressed: isSendingMessage ? null : _sendMessage,
// // // //                             icon: isSendingMessage
// // // //                                 ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
// // // //                                 : const Icon(Icons.send),
// // // //                             label: Text(isSendingMessage ? 'Sending...' : 'Send Message'),
// // // //                             style: ElevatedButton.styleFrom(
// // // //                               backgroundColor: const Color(0xFFE91E63),
// // // //                               padding: const EdgeInsets.symmetric(vertical: 14),
// // // //                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // // //                             ),
// // // //                           ),
// // // //                         ),
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //                 const SizedBox(height: 40),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }

// // // //   Widget _buildDefaultCover() {
// // // //     return Container(
// // // //       color: const Color(0xFF1E1E1E),
// // // //       child: const Center(child: Icon(Icons.image, size: 80, color: Colors.white24)),
// // // //     );
// // // //   }
// // // // }

// // // // // ============================================================
// // // // //                    HOW TO USE THIS FILE
// // // // // ============================================================
// // // // //
// // // // // 1. Copy this entire file into your project (e.g. lib/beat_flirt_viewed_me.dart)
// // // // //
// // // // // 2. Add these dependencies to pubspec.yaml:
// // // // //    dependencies:
// // // // //      http: ^1.2.0
// // // // //      shared_preferences: ^2.2.3
// // // // //
// // // // // 3. Initialize token in main.dart:
// // // // //    await BeatFlirtApi.loadToken();
// // // // //
// // // // // 4. Navigate to Viewed Me screen:
// // // // //    Navigator.push(context, MaterialPageRoute(builder: (_) => const ViewedMeScreen()));
// // // // //
// // // // // ============================================================

// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'dart:convert';
// // // import 'package:shared_preferences/shared_preferences.dart';

// // // // ============================================================
// // // //                    BEAT FLIRT - VIEWED ME INTEGRATION
// // // //                    Single File - Ready to Copy
// // // // ============================================================

// // // const String BASE_URL = 'https://beatflirtevent.com';

// // // // ============================================================
// // // //                           MODELS
// // // // ============================================================

// // // class ViewedUserModel {
// // //   final int? id;
// // //   final String? username;
// // //   final String? profileImage;
// // //   final String? viewedAt;
// // //   final bool? isOnline;
// // //   final String? age;
// // //   final String? location;

// // //   ViewedUserModel({
// // //     this.id,
// // //     this.username,
// // //     this.profileImage,
// // //     this.viewedAt,
// // //     this.isOnline,
// // //     this.age,
// // //     this.location,
// // //   });

// // //   factory ViewedUserModel.fromJson(Map<String, dynamic> json) {
// // //     return ViewedUserModel(
// // //       id: json['id'],
// // //       username: json['username'] ?? json['name'],
// // //       profileImage: json['profile_image'] ?? json['image'],
// // //       viewedAt: json['viewed_at'] ?? json['time'],
// // //       isOnline: json['is_online'] ?? false,
// // //       age: json['age']?.toString(),
// // //       location: json['location'] ?? json['city'],
// // //     );
// // //   }
// // // }

// // // class UserProfileModel {
// // //   final int? id;
// // //   final String? username;
// // //   final String? email;
// // //   final String? profileImage;
// // //   final String? coverImage;
// // //   final String? bio;
// // //   final String? age;
// // //   final String? location;
// // //   final String? gender;
// // //   final bool? isOnline;
// // //   final List<String>? interests;
// // //   final List<String>? photos;
// // //   final String? about;
// // //   final bool? isCouple;

// // //   UserProfileModel({
// // //     this.id,
// // //     this.username,
// // //     this.email,
// // //     this.profileImage,
// // //     this.coverImage,
// // //     this.bio,
// // //     this.age,
// // //     this.location,
// // //     this.gender,
// // //     this.isOnline,
// // //     this.interests,
// // //     this.photos,
// // //     this.about,
// // //     this.isCouple,
// // //   });

// // //   factory UserProfileModel.fromJson(Map<String, dynamic> json) {
// // //     return UserProfileModel(
// // //       id: json['id'],
// // //       username: json['username'] ?? json['name'],
// // //       email: json['email'],
// // //       profileImage: json['profile_image'] ?? json['image'],
// // //       coverImage: json['cover_image'],
// // //       bio: json['bio'] ?? json['description'],
// // //       age: json['age']?.toString(),
// // //       location: json['location'] ?? json['city'],
// // //       gender: json['gender'],
// // //       isOnline: json['is_online'] ?? false,
// // //       interests: json['interests'] != null ? List<String>.from(json['interests']) : null,
// // //       photos: json['photos'] != null ? List<String>.from(json['photos']) : null,
// // //       about: json['about'],
// // //       isCouple: json['is_couple'] ?? false,
// // //     );
// // //   }
// // // }

// // // // ============================================================
// // // //                           API SERVICE
// // // // ============================================================

// // // class BeatFlirtApi {
// // //   static String? _token;

// // //   static Map<String, String> get _headers => {
// // //         'Content-Type': 'application/json',
// // //         'Accept': 'application/json',
// // //         if (_token != null) 'Authorization': 'Bearer $_token',
// // //       };

// // //   static Future<void> saveToken(String token) async {
// // //     _token = token;
// // //     final prefs = await SharedPreferences.getInstance();
// // //     await prefs.setString('bf_auth_token', token);
// // //   }

// // //   static Future<void> loadToken() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     _token = prefs.getString('bf_auth_token');
// // //   }

// // //   static Future<void> clearToken() async {
// // //     _token = null;
// // //     final prefs = await SharedPreferences.getInstance();
// // //     await prefs.remove('bf_auth_token');
// // //   }

// // //   static bool get isLoggedIn => _token != null;

// // //   // ==================== VIEWED ME ====================
// // //   static Future<List<dynamic>> getViewedMe() async {
// // //     final response = await http.get(Uri.parse('$BASE_URL/viewed-me'), headers: _headers);
// // //     if (response.statusCode == 200) {
// // //       return jsonDecode(response.body);
// // //     }
// // //     return [];
// // //   }

// // //   // ==================== SINGLE USER PROFILE ====================
// // //   static Future<Map<String, dynamic>> getSingleUserProfile(int userId) async {
// // //     final response = await http.get(
// // //       Uri.parse('$BASE_URL/single-user-profile?user_id=$userId'),
// // //       headers: _headers,
// // //     );
// // //     if (response.statusCode == 200) {
// // //       return jsonDecode(response.body);
// // //     }
// // //     throw Exception('Failed to load user profile');
// // //   }

// // //   static Future<Map<String, dynamic>> getViewSingleProfile(int userId) async {
// // //     final response = await http.get(
// // //       Uri.parse('$BASE_URL/view-single-profile?id=$userId'),
// // //       headers: _headers,
// // //     );
// // //     if (response.statusCode == 200) {
// // //       return jsonDecode(response.body);
// // //     }
// // //     throw Exception('Failed to load user profile');
// // //   }

// // //   // ==================== MESSAGING ====================
// // //   static Future<bool> sendMessage(int userId, String message) async {
// // //     final response = await http.post(
// // //       Uri.parse('$BASE_URL/message'),
// // //       headers: _headers,
// // //       body: jsonEncode({'receiver_id': userId, 'message': message}),
// // //     );
// // //     return response.statusCode == 200 || response.statusCode == 201;
// // //   }
// // // }

// // // // ============================================================
// // // //                    VIEWED ME SCREEN
// // // // ============================================================

// // // class ViewedMePage extends StatefulWidget {
// // //   const ViewedMePage({super.key});

// // //   @override
// // //   State<ViewedMePage> createState() => _ViewedMePageState();
// // // }

// // // class _ViewedMePageState extends State<ViewedMePage> {
// // //   List<ViewedUserModel> users = [];
// // //   bool isLoading = true;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _loadViewedMe();
// // //   }

// // //   Future<void> _loadViewedMe() async {
// // //     setState(() => isLoading = true);
// // //     try {
// // //       final data = await BeatFlirtApi.getViewedMe();
// // //       setState(() {
// // //         users = data.map((e) => ViewedUserModel.fromJson(e)).toList();
// // //         isLoading = false;
// // //       });
// // //     } catch (e) {
// // //       setState(() => isLoading = false);
// // //       if (mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(content: Text('Failed to load viewed users: $e')),
// // //         );
// // //       }
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text('Who Viewed Me'),
// // //         actions: [
// // //           IconButton(
// // //             icon: const Icon(Icons.refresh),
// // //             onPressed: _loadViewedMe,
// // //           ),
// // //         ],
// // //       ),
// // //       body: isLoading
// // //           ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFC107)))
// // //           : users.isEmpty
// // //               ? _buildEmptyState()
// // //               : _buildUserList(),
// // //     );
// // //   }

// // //   Widget _buildEmptyState() {
// // //     return Center(
// // //       child: Column(
// // //         mainAxisAlignment: MainAxisAlignment.center,
// // //         children: [
// // //           Icon(Icons.visibility_off, size: 80, color: Colors.grey[700]),
// // //           const SizedBox(height: 20),
// // //           const Text('No Views Yet', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
// // //           const SizedBox(height: 8),
// // //           const Text(
// // //             'When someone views your profile,\nthey will appear here.',
// // //             textAlign: TextAlign.center,
// // //             style: TextStyle(color: Colors.grey),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildUserList() {
// // //     return RefreshIndicator(
// // //       onRefresh: _loadViewedMe,
// // //       child: ListView.builder(
// // //         padding: const EdgeInsets.all(12),
// // //         itemCount: users.length,
// // //         itemBuilder: (context, index) {
// // //           final user = users[index];
// // //           return _buildUserCard(user);
// // //         },
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildUserCard(ViewedUserModel user) {
// // //     return Card(
// // //       margin: const EdgeInsets.only(bottom: 12),
// // //       elevation: 4,
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// // //       child: InkWell(
// // //         borderRadius: BorderRadius.circular(16),
// // //         onTap: () {
// // //           if (user.id != null) {
// // //             Navigator.push(
// // //               context,
// // //               MaterialPageRoute(
// // //                 builder: (_) => SingleUserProfileScreen(userId: user.id!),
// // //               ),
// // //             );
// // //           }
// // //         },
// // //         child: Padding(
// // //           padding: const EdgeInsets.all(16),
// // //           child: Row(
// // //             children: [
// // //               Stack(
// // //                 children: [
// // //                   CircleAvatar(
// // //                     radius: 35,
// // //                     backgroundColor: Colors.grey[800],
// // //                     backgroundImage: user.profileImage != null
// // //                         ? NetworkImage(user.profileImage!)
// // //                         : null,
// // //                     child: user.profileImage == null
// // //                         ? const Icon(Icons.person, size: 35, color: Colors.white70)
// // //                         : null,
// // //                   ),
// // //                   if (user.isOnline == true)
// // //                     Positioned(
// // //                       bottom: 4,
// // //                       right: 4,
// // //                       child: Container(
// // //                         width: 14,
// // //                         height: 14,
// // //                         decoration: BoxDecoration(
// // //                           color: Colors.green,
// // //                           shape: BoxShape.circle,
// // //                           border: Border.all(color: Colors.black, width: 2),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                 ],
// // //               ),
// // //               const SizedBox(width: 16),
// // //               Expanded(
// // //                 child: Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   children: [
// // //                     Text(
// // //                       user.username ?? 'Unknown User',
// // //                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // //                     ),
// // //                     if (user.age != null || user.location != null)
// // //                       Padding(
// // //                         padding: const EdgeInsets.only(top: 4),
// // //                         child: Text(
// // //                           '${user.age != null ? '${user.age} years' : ''}'
// // //                           '${user.age != null && user.location != null ? ' • ' : ''}'
// // //                           '${user.location ?? ''}',
// // //                           style: const TextStyle(color: Colors.grey),
// // //                         ),
// // //                       ),
// // //                     const SizedBox(height: 6),
// // //                     Text(
// // //                       user.viewedAt != null ? 'Viewed ${user.viewedAt}' : 'Recently viewed you',
// // //                       style: TextStyle(color: Colors.grey[400], fontSize: 13),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //               const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // // ============================================================
// // // //                 SINGLE USER PROFILE SCREEN
// // // // ============================================================

// // // class SingleUserProfileScreen extends StatefulWidget {
// // //   final int userId;
// // //   const SingleUserProfileScreen({super.key, required this.userId});

// // //   @override
// // //   State<SingleUserProfileScreen> createState() => _SingleUserProfileScreenState();
// // // }

// // // class _SingleUserProfileScreenState extends State<SingleUserProfileScreen> {
// // //   UserProfileModel? user;
// // //   bool isLoading = true;
// // //   bool isSendingMessage = false;
// // //   final TextEditingController _messageController = TextEditingController();

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _loadUserProfile();
// // //   }

// // //   Future<void> _loadUserProfile() async {
// // //     setState(() => isLoading = true);
// // //     try {
// // //       Map<String, dynamic> data;
// // //       try {
// // //         data = await BeatFlirtApi.getSingleUserProfile(widget.userId);
// // //       } catch (_) {
// // //         data = await BeatFlirtApi.getViewSingleProfile(widget.userId);
// // //       }

// // //       setState(() {
// // //         user = UserProfileModel.fromJson(data);
// // //         isLoading = false;
// // //       });
// // //     } catch (e) {
// // //       setState(() => isLoading = false);
// // //       if (mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(content: Text('Failed to load profile: $e')),
// // //         );
// // //       }
// // //     }
// // //   }

// // //   Future<void> _sendMessage() async {
// // //     if (_messageController.text.trim().isEmpty || user?.id == null) return;

// // //     setState(() => isSendingMessage = true);

// // //     try {
// // //       final success = await BeatFlirtApi.sendMessage(
// // //         user!.id!,
// // //         _messageController.text.trim(),
// // //       );

// // //       if (success) {
// // //         _messageController.clear();
// // //         if (mounted) {
// // //           ScaffoldMessenger.of(context).showSnackBar(
// // //             const SnackBar(
// // //               content: Text('Message sent successfully!'),
// // //               backgroundColor: Colors.green,
// // //             ),
// // //           );
// // //         }
// // //       } else {
// // //         throw Exception('Failed to send message');
// // //       }
// // //     } catch (e) {
// // //       if (mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(content: Text('Failed to send message: $e')),
// // //         );
// // //       }
// // //     }

// // //     setState(() => isSendingMessage = false);
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _messageController.dispose();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: const Color(0xFF121212),
// // //       body: isLoading
// // //           ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFC107)))
// // //           : user == null
// // //               ? _buildErrorState()
// // //               : _buildProfileContent(),
// // //     );
// // //   }

// // //   Widget _buildErrorState() {
// // //     return Scaffold(
// // //       appBar: AppBar(title: const Text('Profile')),
// // //       body: Center(
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: [
// // //             const Icon(Icons.error_outline, size: 60, color: Colors.red),
// // //             const SizedBox(height: 16),
// // //             const Text('Failed to load profile'),
// // //             const SizedBox(height: 20),
// // //             ElevatedButton(
// // //               onPressed: _loadUserProfile,
// // //               child: const Text('Try Again'),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildProfileContent() {
// // //     return CustomScrollView(
// // //       slivers: [
// // //         SliverAppBar(
// // //           expandedHeight: 280,
// // //           pinned: true,
// // //           backgroundColor: const Color(0xFF1E1E1E),
// // //           flexibleSpace: FlexibleSpaceBar(
// // //             background: Stack(
// // //               fit: StackFit.expand,
// // //               children: [
// // //                 user!.coverImage != null
// // //                     ? Image.network(
// // //                         user!.coverImage!,
// // //                         fit: BoxFit.cover,
// // //                         errorBuilder: (_, __, ___) => _buildDefaultCover(),
// // //                       )
// // //                     : _buildDefaultCover(),
// // //                 Container(
// // //                   decoration: BoxDecoration(
// // //                     gradient: LinearGradient(
// // //                       begin: Alignment.topCenter,
// // //                       end: Alignment.bottomCenter,
// // //                       colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 if (user!.isOnline == true)
// // //                   Positioned(
// // //                     top: 50,
// // //                     right: 16,
// // //                     child: Container(
// // //                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // //                       decoration: BoxDecoration(
// // //                         color: Colors.green,
// // //                         borderRadius: BorderRadius.circular(20),
// // //                       ),
// // //                       child: const Row(
// // //                         mainAxisSize: MainAxisSize.min,
// // //                         children: [
// // //                           Icon(Icons.circle, size: 10, color: Colors.white),
// // //                           SizedBox(width: 6),
// // //                           Text('Online', style: TextStyle(color: Colors.white, fontSize: 12)),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //         SliverToBoxAdapter(
// // //           child: Padding(
// // //             padding: const EdgeInsets.all(20),
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 // Profile Header
// // //                 Row(
// // //                   children: [
// // //                     CircleAvatar(
// // //                       radius: 50,
// // //                       backgroundColor: Colors.grey[800],
// // //                       backgroundImage: user!.profileImage != null
// // //                           ? NetworkImage(user!.profileImage!)
// // //                           : null,
// // //                       child: user!.profileImage == null
// // //                           ? const Icon(Icons.person, size: 50, color: Colors.white70)
// // //                           : null,
// // //                     ),
// // //                     const SizedBox(width: 20),
// // //                     Expanded(
// // //                       child: Column(
// // //                         crossAxisAlignment: CrossAxisAlignment.start,
// // //                         children: [
// // //                           Text(
// // //                             user!.username ?? 'User',
// // //                             style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
// // //                           ),
// // //                           if (user!.age != null || user!.location != null)
// // //                             Padding(
// // //                               padding: const EdgeInsets.only(top: 6),
// // //                               child: Text(
// // //                                 '${user!.age != null ? '${user!.age} years' : ''}'
// // //                                 '${user!.age != null && user!.location != null ? ' • ' : ''}'
// // //                                 '${user!.location ?? ''}',
// // //                                 style: const TextStyle(fontSize: 16, color: Colors.grey),
// // //                               ),
// // //                             ),
// // //                           if (user!.gender != null)
// // //                             Padding(
// // //                               padding: const EdgeInsets.only(top: 4),
// // //                               child: Text(user!.gender!, style: const TextStyle(color: Colors.grey)),
// // //                             ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),

// // //                 const SizedBox(height: 30),

// // //                 // About
// // //                 if (user!.about != null || user!.bio != null) ...[
// // //                   const Text('About', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// // //                   const SizedBox(height: 10),
// // //                   Container(
// // //                     padding: const EdgeInsets.all(16),
// // //                     decoration: BoxDecoration(
// // //                       color: const Color(0xFF1E1E1E),
// // //                       borderRadius: BorderRadius.circular(12),
// // //                     ),
// // //                     child: Text(
// // //                       user!.about ?? user!.bio ?? '',
// // //                       style: const TextStyle(fontSize: 15, height: 1.5),
// // //                     ),
// // //                   ),
// // //                   const SizedBox(height: 30),
// // //                 ],

// // //                 // Interests
// // //                 if (user!.interests != null && user!.interests!.isNotEmpty) ...[
// // //                   const Text('Interests', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// // //                   const SizedBox(height: 12),
// // //                   Wrap(
// // //                     spacing: 8,
// // //                     runSpacing: 8,
// // //                     children: user!.interests!.map((interest) {
// // //                       return Chip(
// // //                         label: Text(interest),
// // //                         backgroundColor: const Color(0xFFFFC107).withOpacity(0.15),
// // //                         labelStyle: const TextStyle(color: Color(0xFFFFC107)),
// // //                       );
// // //                     }).toList(),
// // //                   ),
// // //                   const SizedBox(height: 30),
// // //                 ],

// // //                 // Photos
// // //                 if (user!.photos != null && user!.photos!.isNotEmpty) ...[
// // //                   const Text('Photos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// // //                   const SizedBox(height: 12),
// // //                   SizedBox(
// // //                     height: 120,
// // //                     child: ListView.builder(
// // //                       scrollDirection: Axis.horizontal,
// // //                       itemCount: user!.photos!.length,
// // //                       itemBuilder: (context, index) {
// // //                         return Padding(
// // //                           padding: const EdgeInsets.only(right: 12),
// // //                           child: ClipRRect(
// // //                             borderRadius: BorderRadius.circular(12),
// // //                             child: Image.network(
// // //                               user!.photos![index],
// // //                               width: 120,
// // //                               height: 120,
// // //                               fit: BoxFit.cover,
// // //                               errorBuilder: (_, __, ___) => Container(
// // //                                 width: 120,
// // //                                 height: 120,
// // //                                 color: Colors.grey[800],
// // //                                 child: const Icon(Icons.image_not_supported),
// // //                               ),
// // //                             ),
// // //                           ),
// // //                         );
// // //                       },
// // //                     ),
// // //                   ),
// // //                   const SizedBox(height: 40),
// // //                 ],

// // //                 // Message Section
// // //                 const Text('Send a Message', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// // //                 const SizedBox(height: 16),
// // //                 Container(
// // //                   decoration: BoxDecoration(
// // //                     color: const Color(0xFF1E1E1E),
// // //                     borderRadius: BorderRadius.circular(16),
// // //                   ),
// // //                   child: Column(
// // //                     children: [
// // //                       TextField(
// // //                         controller: _messageController,
// // //                         maxLines: 4,
// // //                         minLines: 3,
// // //                         decoration: const InputDecoration(
// // //                           hintText: 'Write your message here...',
// // //                           border: InputBorder.none,
// // //                           contentPadding: EdgeInsets.all(16),
// // //                         ),
// // //                       ),
// // //                       const Divider(height: 1),
// // //                       Padding(
// // //                         padding: const EdgeInsets.all(12),
// // //                         child: SizedBox(
// // //                           width: double.infinity,
// // //                           child: ElevatedButton.icon(
// // //                             onPressed: isSendingMessage ? null : _sendMessage,
// // //                             icon: isSendingMessage
// // //                                 ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
// // //                                 : const Icon(Icons.send),
// // //                             label: Text(isSendingMessage ? 'Sending...' : 'Send Message'),
// // //                             style: ElevatedButton.styleFrom(
// // //                               backgroundColor: const Color(0xFFE91E63),
// // //                               padding: const EdgeInsets.symmetric(vertical: 14),
// // //                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 40),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Widget _buildDefaultCover() {
// // //     return Container(
// // //       color: const Color(0xFF1E1E1E),
// // //       child: const Center(child: Icon(Icons.image, size: 80, color: Colors.white24)),
// // //     );
// // //   }
// // // }

// // // // ============================================================
// // // //                    HOW TO USE THIS FILE
// // // // ============================================================
// // // //
// // // // 1. Copy this entire file into your project (e.g. lib/beat_flirt_viewed_me.dart)
// // // //
// // // // 2. Add these dependencies to pubspec.yaml:
// // // //    dependencies:
// // // //      http: ^1.2.0
// // // //      shared_preferences: ^2.2.3
// // // //
// // // // 3. Initialize token in main.dart:
// // // //    await BeatFlirtApi.loadToken();
// // // //
// // // // 4. Navigate to Viewed Me screen:
// // // //    Navigator.push(context, MaterialPageRoute(builder: (_) => const ViewedMeScreen()));
// // // //
// // // // ============================================================
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:beatflirt/core/services/auth_services.dart';

// // // ============================================================
// // //           BEAT FLIRT - VIEWED ME (ALL 24 APIs + UI)
// // // ============================================================

// // const String VIEWED_ME_BASE_URL = 'https://app.beatflirtevent.com/App';

// // class ViewedMeApi {
// //   static String? _token;
// //   static int? currentUserId;

// //   static Future<Map<String, String>> getHeaders() async {
// //     final token = await AuthService.getToken();
// //     return {
// //       'Content-Type': 'application/json',
// //       'Accept': 'application/json',
// //       if (token != null && token.isNotEmpty) ...{
// //         'Authorization': 'Bearer $token',
// //         'access-token': token,
// //       }
// //     };
// //   }

// //   static Future<void> saveToken(String token) async {
// //     _token = token;
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setString('bf_auth_token', token);
// //   }

// //   static Future<void> loadToken() async {
// //     _token = await AuthService.getToken();
// //     final userIdStr = await AuthService.getUserId();
// //     if (userIdStr != null) {
// //       currentUserId = int.tryParse(userIdStr);
// //     }
// //   }

// //   // ==================== VIEWED ME ====================
// //   static Future<List<dynamic>> getViewedMe() async {
// //     final response = await http.post(
// //       Uri.parse('$VIEWED_ME_BASE_URL/user/viewed_me'),
// //       headers: await getHeaders(),
// //       body: jsonEncode({
// //         "type": "all", "search_keyword": "", "lat": "0", "lng": "0", "profileTypeArray": []
// //       }),
// //     );
// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       return data['status'] == "200" ? data['data'] ?? [] : [];
// //     }
// //     return [];
// //   }

// //   // ==================== CHECK BLOCKED ====================
// //   static Future<bool> isUserBlocked(int profileUserId) async {
// //     if (currentUserId == null) return false;
// //     final response = await http.post(
// //       Uri.parse('$VIEWED_ME_BASE_URL/profile/check_user_blocked'),
// //       headers: await getHeaders(),
// //       body: jsonEncode({
// //         "profile_user_id": profileUserId.toString(),
// //         "login_user_id": currentUserId.toString(),
// //       }),
// //     );
// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       return data['status'] == "200" && data['data'] == "1";
// //     }
// //     return false;
// //   }

// //   // ==================== SINGLE USER PROFILE ====================
// //   static Future<Map<String, dynamic>?> getSingleUserProfile(int userId) async {
// //     final response = await http.post(
// //       Uri.parse('$VIEWED_ME_BASE_URL/profile/signle_user_profile'),
// //       headers: await getHeaders(),
// //       body: jsonEncode({"user_id": userId.toString()}),
// //     );
// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       return data['status'] == "200" ? data['data'] : null;
// //     }
// //     return null;
// //   }

// //   // ==================== PROFILE IMAGES ====================
// //   static Future<List<String>> getUserProfileImages(int userId) async {
// //     final response = await http.post(
// //       Uri.parse('$VIEWED_ME_BASE_URL/profile/signle_user_profile_image'),
// //       headers: await getHeaders(),
// //       body: jsonEncode({"user_id": userId.toString()}),
// //     );
// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       if (data['status'] == "200" && data['data'] != null) {
// //         return (data['data'] as List).map((e) => e['profile_image'].toString()).toList();
// //       }
// //     }
// //     return [];
// //   }

// //   // ==================== TRACK VIEW ====================
// //   static Future<void> trackProfileView(int profileUserId) async {
// //     if (currentUserId == null) return;
// //     await http.post(
// //       Uri.parse('$VIEWED_ME_BASE_URL/profile/who_i_viewed_insert'),
// //       headers: await getHeaders(),
// //       body: jsonEncode({
// //         "login_user_id": currentUserId.toString(),
// //         "profile_user_id": profileUserId.toString(),
// //       }),
// //     );
// //   }

// //   // ==================== ACTIONS ====================
// //   static Future<bool> sendLike(int userId, int status) async {
// //     if (currentUserId == null) return false;
// //     final res = await http.post(
// //       Uri.parse('$VIEWED_ME_BASE_URL/profile/send_like'),
// //       headers: await getHeaders(),
// //       body: jsonEncode({
// //         "sendor_id": currentUserId.toString(),
// //         "recieved_id": userId.toString(),
// //         "status": status.toString()
// //       }),
// //     );
// //     return res.statusCode == 200;
// //   }

// //   static Future<bool> sendFriendRequest(int userId) async {
// //     if (currentUserId == null) return false;
// //     final res = await http.post(
// //       Uri.parse('$VIEWED_ME_BASE_URL/profile/send_friend_request'),
// //       headers: await getHeaders(),
// //       body: jsonEncode({
// //         "sendor_id": currentUserId.toString(),
// //         "recieved_id": userId.toString()
// //       }),
// //     );
// //     return res.statusCode == 200;
// //   }

// //   static Future<bool> sendValidate(int userId, String message) async {
// //     if (currentUserId == null) return false;
// //     final res = await http.post(
// //       Uri.parse('$VIEWED_ME_BASE_URL/profile/send_validate'),
// //       headers: await getHeaders(),
// //       body: jsonEncode({
// //         "sendor_id": currentUserId.toString(),
// //         "recieved_id": userId.toString(),
// //         "message": message
// //       }),
// //     );
// //     return res.statusCode == 200;
// //   }

// //   static Future<bool> sendRemember(int userId) async {
// //     if (currentUserId == null) return false;
// //     final res = await http.post(
// //       Uri.parse('$VIEWED_ME_BASE_URL/profile/send_remember'),
// //       headers: await getHeaders(),
// //       body: jsonEncode({
// //         "sendor_id": currentUserId.toString(),
// //         "recieved_id": userId.toString()
// //       }),
// //     );
// //     return res.statusCode == 200;
// //   }

// //   static Future<bool> sendNotes(int userId, String message) async {
// //     if (currentUserId == null) return false;
// //     final res = await http.post(
// //       Uri.parse('$VIEWED_ME_BASE_URL/profile/send_notes'),
// //       headers: await getHeaders(),
// //       body: jsonEncode({
// //         "sendor_id": currentUserId.toString(),
// //         "recieved_id": userId.toString(),
// //         "message": message
// //       }),
// //     );
// //     return res.statusCode == 200;
// //   }

// //   static Future<bool> blockUser(int userId) async {
// //     if (currentUserId == null) return false;
// //     final res = await http.post(
// //       Uri.parse('$VIEWED_ME_BASE_URL/profile/send_block'),
// //       headers: await getHeaders(),
// //       body: jsonEncode({
// //         "sendor_id": currentUserId.toString(),
// //         "recieved_id": userId.toString()
// //       }),
// //     );
// //     return res.statusCode == 200;
// //   }
// // }

// // // ============================================================
// // //                    VIEWED ME SCREEN (Exact Match)
// // // ============================================================

// // class ViewedMePage extends StatefulWidget {
// //   const ViewedMePage({super.key});

// //   @override
// //   State<ViewedMePage> createState() => _ViewedMePageState();
// // }

// // class _ViewedMePageState extends State<ViewedMePage> {
// //   List<dynamic> users = [];
// //   bool isLoading = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadViewedMe();
// //   }

// //   Future<void> _loadViewedMe() async {
// //     setState(() => isLoading = true);
// //     await ViewedMeApi.loadToken();
// //     final data = await ViewedMeApi.getViewedMe();
// //     setState(() {
// //       users = data;
// //       isLoading = false;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Viewed Me')),
// //       body: isLoading
// //           ? const Center(child: CircularProgressIndicator())
// //           : users.isEmpty
// //               ? const Center(child: Text('No views yet'))
// //               : ListView.builder(
// //                   padding: const EdgeInsets.all(16),
// //                   itemCount: users.length,
// //                   itemBuilder: (context, index) {
// //                     final user = users[index];
// //                     return _buildUserCard(user);
// //                   },
// //                 ),
// //     );
// //   }

// //   Widget _buildUserCard(dynamic user) {
// //     final imageUrl = user['image'] != null && user['image'].isNotEmpty
// //         ? user['image'][0]['profile_image']
// //         : null;

// //     return GestureDetector(
// //       onTap: () async {
// //         final userId = int.tryParse(user['id'].toString()) ?? 0;
// //         await ViewedMeApi.trackProfileView(userId);

// //         final blocked = await ViewedMeApi.isUserBlocked(userId);
// //         if (blocked) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(content: Text('This user has blocked you.')),
// //           );
// //           return;
// //         }

// //         Navigator.push(
// //           context,
// //           MaterialPageRoute(builder: (_) => SingleUserProfileScreen(userId: userId)),
// //         );
// //       },
// //       child: Container(
// //         margin: const EdgeInsets.only(bottom: 20),
// //         decoration: BoxDecoration(
// //           color: const Color(0xFF1E1E1E),
// //           borderRadius: BorderRadius.circular(20),
// //           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
// //         ),
// //         child: Column(
// //           children: [
// //             // Profile Image with Pink Border
// //             Container(
// //               margin: const EdgeInsets.only(top: 16),
// //               decoration: BoxDecoration(
// //                 shape: BoxShape.circle,
// //                 border: Border.all(color: const Color(0xFFE91E63), width: 3),
// //               ),
// //               child: CircleAvatar(
// //                 radius: 55,
// //                 backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
// //                 child: imageUrl == null ? const Icon(Icons.person, size: 55) : null,
// //               ),
// //             ),
// //             const SizedBox(height: 12),
// //             Text(user['username'] ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

// //             // Age Badge
// //             if (user['age'] != null)
// //               Container(
// //                 margin: const EdgeInsets.only(top: 6),
// //                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
// //                 decoration: BoxDecoration(color: const Color(0xFFE91E63), borderRadius: BorderRadius.circular(20)),
// //                 child: Text('Age ${user['age']}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
// //               ),

// //             const SizedBox(height: 12),
// //             Text(user['gender_profile_type'] ?? '', style: const TextStyle(fontSize: 15, color: Colors.white70)),

// //             if (user['formatted_address'] != null)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     const Icon(Icons.location_on, size: 16, color: Colors.white54),
// //                     const SizedBox(width: 4),
// //                     Text(
// //                       '${user['city_name'] ?? ''} • ${user['total_distance'] ?? 0} km',
// //                       style: const TextStyle(color: Colors.white54, fontSize: 13),
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //             const SizedBox(height: 16),
// //             const Icon(Icons.chat_bubble_outline, color: Color(0xFFE91E63), size: 28),
// //             const SizedBox(height: 20),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ============================================================
// // //                 SINGLE USER PROFILE SCREEN (Exact Match)
// // // ============================================================

// // class SingleUserProfileScreen extends StatefulWidget {
// //   final int userId;
// //   const SingleUserProfileScreen({super.key, required this.userId});

// //   @override
// //   State<SingleUserProfileScreen> createState() => _SingleUserProfileScreenState();
// // }

// // class _SingleUserProfileScreenState extends State<SingleUserProfileScreen> {
// //   Map<String, dynamic>? profile;
// //   List<String> images = [];
// //   bool isLoading = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadProfile();
// //   }

// //   Future<void> _loadProfile() async {
// //     setState(() => isLoading = true);
// //     await ViewedMeApi.loadToken();
// //     profile = await ViewedMeApi.getSingleUserProfile(widget.userId);
// //     images = await ViewedMeApi.getUserProfileImages(widget.userId);
// //     setState(() => isLoading = false);
// //   }

// //   Future<void> _performAction(String action, Future<bool> Function() apiCall) async {
// //     final success = await apiCall();
// //     if (success) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('$action successful'), backgroundColor: Colors.green),
// //       );
// //     } else {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('$action failed')),
// //       );
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF8F5F5),
// //       appBar: AppBar(title: const Text('Profile')),
// //       body: isLoading
// //           ? const Center(child: CircularProgressIndicator())
// //           : profile == null
// //               ? const Center(child: Text('Profile not found'))
// //               : SingleChildScrollView(
// //                   padding: const EdgeInsets.all(16),
// //                   child: Row(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       // Left Column - Profile Card + Sidebar
// //                       Expanded(
// //                         flex: 5,
// //                         child: Column(
// //                           children: [
// //                             Container(
// //                               decoration: BoxDecoration(
// //                                 color: const Color(0xFF2D1B3D),
// //                                 borderRadius: BorderRadius.circular(16),
// //                               ),
// //                               child: Column(
// //                                 children: [
// //                                   if (images.isNotEmpty)
// //                                     ClipRRect(
// //                                       borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
// //                                       child: Image.network(images[0], height: 280, width: double.infinity, fit: BoxFit.cover),
// //                                     ),
// //                                   Padding(
// //                                     padding: const EdgeInsets.all(16),
// //                                     child: Column(
// //                                       crossAxisAlignment: CrossAxisAlignment.start,
// //                                       children: [
// //                                         Text(profile!['username'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
// //                                         Text('${profile!['age']} | 0 Years', style: const TextStyle(color: Colors.white70)),
// //                                         Text(profile!['gender_profile_type'] ?? '', style: const TextStyle(color: Colors.white70)),
// //                                         Text(profile!['address'] ?? '', style: const TextStyle(color: Colors.white70, fontSize: 13)),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                   Container(
// //                                     color: const Color(0xFF2D1B3D),
// //                                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //                                     child: Column(
// //                                       children: [
// //                                         _buildSidebarItem('Already Friends', 5, Icons.people),
// //                                         _buildSidebarItem('Like', 3, Icons.thumb_up),
// //                                         _buildSidebarItem('Validate Pending', 4, Icons.verified),
// //                                         _buildSidebarItem('Already remember', 3, Icons.favorite),
// //                                         _buildSidebarItem('Notes', 3, Icons.note),
// //                                         _buildSidebarItem('Block User', 0, Icons.block, isDestructive: true),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),

// //                       const SizedBox(width: 20),

// //                       // Right Column - Questions
// //                       Expanded(
// //                         flex: 6,
// //                         child: Container(
// //                           padding: const EdgeInsets.all(20),
// //                           decoration: BoxDecoration(
// //                             color: Colors.white,
// //                             borderRadius: BorderRadius.circular(16),
// //                           ),
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               _buildQuestionBubble('Age', '${profile!['age']} Years'),
// //                               _buildQuestionBubble('Tattoos', profile!['person1_tattoos'] ?? 'Im not comfortable sharing that'),
// //                               _buildQuestionBubble('Body Hair', 'Im not comfortable sharing that'),
// //                               _buildQuestionBubble('Weight', 'Im not comfortable sharing that'),
// //                               _buildQuestionBubble('Height', 'Im not comfortable sharing that'),
// //                               _buildQuestionBubble('Smoking', profile!['person1_smoking'] ?? 'Im not comfortable sharing that'),
// //                               _buildQuestionBubble('Drinking', profile!['person1_drinking'] ?? 'Im not comfortable sharing that'),
// //                               _buildQuestionBubble('Body Type', profile!['person1_body_type'] ?? 'Im not comfortable sharing that'),
// //                               _buildQuestionBubble('Language Spoken', 'Im not comfortable sharing that'),
// //                               _buildQuestionBubble('Ethnic Background', 'Im not comfortable sharing that'),
// //                               _buildQuestionBubble('Piercings', 'Im not comfortable sharing that'),
// //                               _buildQuestionBubble('Circumcised', 'Im not comfortable sharing that'),
// //                               _buildQuestionBubble('Sexuality', 'Im not comfortable sharing that'),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //     );
// //   }

// //   Widget _buildSidebarItem(String title, int count, IconData icon, {bool isDestructive = false}) {
// //     return ListTile(
// //       leading: Icon(icon, color: isDestructive ? Colors.red : Colors.white70),
// //       title: Text(title, style: TextStyle(color: isDestructive ? Colors.red : Colors.white)),
// //       trailing: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// //         decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
// //         child: Text(count.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
// //       ),
// //       onTap: () {
// //         if (title == 'Like') _performAction('Like', () => ViewedMeApi.sendLike(widget.userId, 1));
// //         if (title == 'Block User') _performAction('Block', () => ViewedMeApi.blockUser(widget.userId));
// //         if (title == 'Already Friends') _performAction('Friend Request', () => ViewedMeApi.sendFriendRequest(widget.userId));
// //         if (title == 'Validate Pending') _performAction('Validate', () => ViewedMeApi.sendValidate(widget.userId, "Verified"));
// //         if (title == 'Already remember') _performAction('Remember', () => ViewedMeApi.sendRemember(widget.userId));
// //         if (title == 'Notes') _performAction('Note', () => ViewedMeApi.sendNotes(widget.userId, "Nice profile!"));
// //       },
// //     );
// //   }

// //   Widget _buildQuestionBubble(String question, String answer) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 14),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
// //             decoration: BoxDecoration(color: const Color(0xFF2D1B3D), borderRadius: BorderRadius.circular(20)),
// //             child: Text(question, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
// //           ),
// //           const SizedBox(width: 10),
// //           Expanded(
// //             child: Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
// //               decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
// //               child: Text(answer, style: const TextStyle(color: Colors.black87)),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:beatflirt/single_user_profile_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:beatflirt/core/services/auth_services.dart';

// // ============================================================
// //           BEAT FLIRT - VIEWED ME (ALL 24 APIs + UI)
// // ============================================================

// const String VIEWED_ME_BASE_URL = 'https://app.beatflirtevent.com/App';

// class ViewedMeApi {
//   static String? _token;
//   static int? currentUserId;

//   static Future<Map<String, String>> getHeaders() async {
//     final token = await AuthService.getToken();
//     return {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//       if (token != null && token.isNotEmpty) ...{
//         'Authorization': 'Bearer $token',
//         'access-token': token,
//       }
//     };
//   }

//   static Future<void> saveToken(String token) async {
//     _token = token;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('bf_auth_token', token);
//   }

//   static Future<void> loadToken() async {
//     _token = await AuthService.getToken();
//     final userIdStr = await AuthService.getUserId();
//     if (userIdStr != null) {
//       currentUserId = int.tryParse(userIdStr);
//     }
//   }

//   // ==================== VIEWED ME ====================
//   static Future<List<dynamic>> getViewedMe() async {
//     final response = await http.post(
//       Uri.parse('$VIEWED_ME_BASE_URL/user/viewed_me'),
//       headers: await getHeaders(),
//       body: jsonEncode({
//         "type": "all",
//         "search_keyword": "",
//         "lat": "0",
//         "lng": "0",
//         "profileTypeArray": [],
//       }),
//     );
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['status'] == "200" ? data['data'] ?? [] : [];
//     }
//     return [];
//   }

//   // ==================== CHECK BLOCKED ====================
//   static Future<bool> isUserBlocked(int profileUserId) async {
//     if (currentUserId == null) return false;
//     final response = await http.post(
//       Uri.parse('$VIEWED_ME_BASE_URL/profile/check_user_blocked'),
//       headers: await getHeaders(),
//       body: jsonEncode({
//         "profile_user_id": profileUserId.toString(),
//         "login_user_id": currentUserId.toString(),
//       }),
//     );
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['status'] == "200" && data['data'] == "1";
//     }
//     return false;
//   }

//   // ==================== SINGLE USER PROFILE ====================
//   static Future<Map<String, dynamic>?> getSingleUserProfile(int userId) async {
//     final response = await http.post(
//       Uri.parse('$VIEWED_ME_BASE_URL/profile/signle_user_profile'),
//       headers: await getHeaders(),
//       body: jsonEncode({"user_id": userId.toString()}),
//     );
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['status'] == "200" ? data['data'] : null;
//     }
//     return null;
//   }

//   // ==================== PROFILE IMAGES ====================
//   static Future<List<String>> getUserProfileImages(int userId) async {
//     final response = await http.post(
//       Uri.parse('$VIEWED_ME_BASE_URL/profile/signle_user_profile_image'),
//       headers: await getHeaders(),
//       body: jsonEncode({"user_id": userId.toString()}),
//     );
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       if (data['status'] == "200" && data['data'] != null) {
//         return (data['data'] as List)
//             .map((e) => e['profile_image'].toString())
//             .toList();
//       }
//     }
//     return [];
//   }

//   // ==================== TRACK VIEW ====================
//   static Future<void> trackProfileView(int profileUserId) async {
//     if (currentUserId == null) return;
//     await http.post(
//       Uri.parse('$VIEWED_ME_BASE_URL/profile/who_i_viewed_insert'),
//       headers: await getHeaders(),
//       body: jsonEncode({
//         "login_user_id": currentUserId.toString(),
//         "profile_user_id": profileUserId.toString(),
//       }),
//     );
//   }

//   // ==================== ACTIONS ====================
//   static Future<bool> sendLike(int userId, int status) async {
//     if (currentUserId == null) return false;
//     final res = await http.post(
//       Uri.parse('$VIEWED_ME_BASE_URL/profile/send_like'),
//       headers: await getHeaders(),
//       body: jsonEncode({
//         "sendor_id": currentUserId.toString(),
//         "recieved_id": userId.toString(),
//         "status": status.toString(),
//       }),
//     );
//     return res.statusCode == 200;
//   }

//   static Future<bool> sendFriendRequest(int userId) async {
//     if (currentUserId == null) return false;
//     final res = await http.post(
//       Uri.parse('$VIEWED_ME_BASE_URL/profile/send_friend_request'),
//       headers: await getHeaders(),
//       body: jsonEncode({
//         "sendor_id": currentUserId.toString(),
//         "recieved_id": userId.toString(),
//       }),
//     );
//     return res.statusCode == 200;
//   }

//   static Future<bool> sendValidate(int userId, String message) async {
//     if (currentUserId == null) return false;
//     final res = await http.post(
//       Uri.parse('$VIEWED_ME_BASE_URL/profile/send_validate'),
//       headers: await getHeaders(),
//       body: jsonEncode({
//         "sendor_id": currentUserId.toString(),
//         "recieved_id": userId.toString(),
//         "message": message,
//       }),
//     );
//     return res.statusCode == 200;
//   }

//   static Future<bool> sendRemember(int userId) async {
//     if (currentUserId == null) return false;
//     final res = await http.post(
//       Uri.parse('$VIEWED_ME_BASE_URL/profile/send_remember'),
//       headers: await getHeaders(),
//       body: jsonEncode({
//         "sendor_id": currentUserId.toString(),
//         "recieved_id": userId.toString(),
//       }),
//     );
//     return res.statusCode == 200;
//   }

//   static Future<bool> sendNotes(int userId, String message) async {
//     if (currentUserId == null) return false;
//     final res = await http.post(
//       Uri.parse('$VIEWED_ME_BASE_URL/profile/send_notes'),
//       headers: await getHeaders(),
//       body: jsonEncode({
//         "sendor_id": currentUserId.toString(),
//         "recieved_id": userId.toString(),
//         "message": message,
//       }),
//     );
//     return res.statusCode == 200;
//   }

//   static Future<bool> blockUser(int userId) async {
//     if (currentUserId == null) return false;
//     final res = await http.post(
//       Uri.parse('$VIEWED_ME_BASE_URL/profile/send_block'),
//       headers: await getHeaders(),
//       body: jsonEncode({
//         "sendor_id": currentUserId.toString(),
//         "recieved_id": userId.toString(),
//       }),
//     );
//     return res.statusCode == 200;
//   }
// }

// // ============================================================
// //                    VIEWED ME SCREEN (Exact Match)
// // ============================================================

// class ViewedMePage extends StatefulWidget {
//   const ViewedMePage({super.key});

//   @override
//   State<ViewedMePage> createState() => _ViewedMePageState();
// }

// class _ViewedMePageState extends State<ViewedMePage> {
//   List<dynamic> users = [];
//   bool isLoading = true;
//   String loggedInUsername = "User";
//   String loggedInLocation = "American Samoa";

//   @override
//   void initState() {
//     super.initState();
//     _loadViewedMe();
//     _loadLoggedInUserInfo();
//   }

//   Future<void> _loadLoggedInUserInfo() async {
//     final email = await AuthService.getSavedEmail();
//     if (email != null && email.contains('@')) {
//       setState(() {
//         loggedInUsername = email.split('@')[0];
//       });
//     }
//   }

//   Future<void> _loadViewedMe() async {
//     setState(() => isLoading = true);
//     await ViewedMeApi.loadToken();
//     final data = await ViewedMeApi.getViewedMe();
//     setState(() {
//       users = data;
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFFF8F8),
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'Viewed Me (${users.length})',
//           style: const TextStyle(
//             color: Colors.black87,
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : users.isEmpty
//               ? const Center(child: Text('No views yet', style: TextStyle(color: Colors.grey)))
//               : ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                   itemCount: users.length,
//                   itemBuilder: (context, index) {
//                     final user = users[index];
//                     return _buildUserCard(user);
//                   },
//                 ),
//     );
//   }

//   Widget _buildUserCard(dynamic user) {
//     final imageUrl = user['image'] != null && user['image'].isNotEmpty
//         ? user['image'][0]['profile_image']
//         : null;

//     return GestureDetector(
//       onTap: () async {
//         final userId = int.tryParse(user['id'].toString()) ?? 0;
//         await ViewedMeApi.trackProfileView(userId);

//         final blocked = await ViewedMeApi.isUserBlocked(userId);
//       if (blocked) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('This user has blocked you.')),
//           );
//           return;
//         }

//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => BeatSingleUserProfileScreen(
//               userId: userId.toString(),
//             ),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 24),
//         padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
//         decoration: BoxDecoration(
//           color: const Color(0xFF2D1B3D), // Exact dark purple background from the screenshot
//           borderRadius: BorderRadius.circular(24),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.15),
//               blurRadius: 12,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             // Circular profile picture with pink border
//             Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: const Color(0xFFE91E63), width: 3),
//               ),
//               child: CircleAvatar(
//                 radius: 54,
//                 backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
//                 backgroundColor: Colors.grey[800],
//                 child: imageUrl == null ? const Icon(Icons.person, size: 54, color: Colors.white) : null,
//               ),
//             ),
//             const SizedBox(height: 14),

//             // Username
//             Text(
//               user['username'] ?? 'Unknown',
//               style: const TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 6),

//             // Age Badge
//             if (user['age'] != null)
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFE91E63),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   'Age ${user['age']}',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             const SizedBox(height: 10),

//             // interlocking male/female symbols
//             const Text(
//               '⚧⚧⚧',
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Color(0xFFE91E63),
//               ),
//             ),
//             const SizedBox(height: 4),

//             // Gender Profile Type
//             Text(
//               user['gender_profile_type'] ?? 'Male',
//               style: const TextStyle(
//                 fontSize: 15,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 8),

//             // Location & Distance Info
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(Icons.location_on, size: 16, color: Colors.white70),
//                       const SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           user['formatted_address'] ?? user['city_name'] ?? 'Location not specified',
//                           style: const TextStyle(color: Colors.white70, fontSize: 13),
//                           textAlign: TextAlign.center,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                   if (user['total_distance'] != null) ...[
//                     const SizedBox(height: 4),
//                     Text(
//                       '${double.tryParse(user['total_distance'].toString())?.toStringAsFixed(0) ?? 0} km',
//                       style: const TextStyle(color: Colors.white70, fontSize: 12),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//             const SizedBox(height: 18),

//             // Floating message/chat bubble action button
//             Container(
//               width: 50,
//               height: 50,
//               decoration: const BoxDecoration(
//                 color: Color(0xFFE91E63),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.chat_bubble,
//                 color: Colors.white,
//                 size: 24,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ============================================================
// //                 SINGLE USER PROFILE SCREEN (Exact Match)
// // ============================================================

// class SingleUserProfileScreen extends StatefulWidget {
//   final int userId;
//   const SingleUserProfileScreen({super.key, required this.userId});

//   @override
//   State<SingleUserProfileScreen> createState() =>
//       _SingleUserProfileScreenState();
// }

// class _SingleUserProfileScreenState extends State<SingleUserProfileScreen> {
//   Map<String, dynamic>? profile;
//   List<String> images = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadProfile();
//   }

//   Future<void> _loadProfile() async {
//     setState(() => isLoading = true);
//     await ViewedMeApi.loadToken();
//     profile = await ViewedMeApi.getSingleUserProfile(widget.userId);
//     images = await ViewedMeApi.getUserProfileImages(widget.userId);
//     setState(() => isLoading = false);
//   }

//   Future<void> _performAction(
//     String action,
//     Future<bool> Function() apiCall,
//   ) async {
//     final success = await apiCall();
//     if (success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('$action successful'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('$action failed')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isMobile = MediaQuery.of(context).size.width < 768;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F5F5),
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new,size:24,color:Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text('Profile'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         elevation: 0,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : profile == null
//               ? const Center(child: Text('Profile not found'))
//               : SingleChildScrollView(
//                   padding: const EdgeInsets.all(16),
//                   child: isMobile
//                       ? Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             _buildProfileCard(),
//                             const SizedBox(height: 20),
//                             _buildSwingersCard(),
//                             const SizedBox(height: 20),
//                             _buildQuestionsCard(),
//                           ],
//                         )
//                       : Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               flex: 5,
//                               child: Column(
//                                 children: [
//                                   _buildProfileCard(),
//                                   const SizedBox(height: 20),
//                                   _buildSwingersCard(),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(width: 20),
//                             Expanded(
//                               flex: 6,
//                               child: _buildQuestionsCard(),
//                             ),
//                           ],
//                         ),
//                 ),
//     );
//   }

//   Widget _buildProfileCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF2D1B3D),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         children: [
//           if (images.isNotEmpty)
//             ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(16),
//                 topRight: Radius.circular(16),
//               ),
//               child: Image.network(
//                 images[0],
//                 height: 280,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   profile!['username'] ?? '',
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '${profile!['age']} | 0 Years',
//                   style: const TextStyle(color: Colors.white70),
//                 ),
//                 Text(
//                   profile!['gender_profile_type'] ?? '',
//                   style: const TextStyle(color: Colors.white70),
//                 ),
//                 Text(
//                   profile!['address'] ?? '',
//                   style: const TextStyle(
//                     color: Colors.white70,
//                     fontSize: 13,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 12,
//             ),
//             child: Column(
//               children: [
//                 _buildSidebarItem('Already Friends', 5, Icons.people),
//                 _buildSidebarItem('Like', 3, Icons.thumb_up),
//                 _buildSidebarItem('Validate Pending', 4, Icons.verified),
//                 _buildSidebarItem('Already remember', 3, Icons.favorite),
//                 _buildSidebarItem('Notes', 3, Icons.note),
//                 _buildSidebarItem(
//                   'Block User',
//                   0,
//                   Icons.block,
//                   isDestructive: true,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSwingersCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Swingers',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2D1B3D),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildGenderIcon('♂♀', profile!['couple_male_female_swingers'] == "1"),
//               _buildGenderIcon('♀♀', profile!['couple_female_female_swingers'] == "1"),
//               _buildGenderIcon('♂♂', profile!['couple_male_male_swingers'] == "1"),
//             ],
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'HookUps/Meetups',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2D1B3D),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildGenderIcon('♂♀', profile!['couple_male_female_hookup_meetup'] == "1"),
//               _buildGenderIcon('♀♀', profile!['couple_female_female_hookup_meetup'] == "1"),
//               _buildGenderIcon('♂♂', profile!['couple_male_male_hookup_meetup'] == "1"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuestionsCard() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Profile Details',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2D1B3D),
//             ),
//           ),
//           const SizedBox(height: 20),
//           _buildQuestionBubble('Age', '${profile!['age']} Years'),
//           _buildQuestionBubble(
//             'Tattoos',
//             profile!['person1_tattoos'] ?? 'Im not comfortable sharing that',
//           ),
//           _buildQuestionBubble('Body Hair', 'Im not comfortable sharing that'),
//           _buildQuestionBubble('Weight', 'Im not comfortable sharing that'),
//           _buildQuestionBubble('Height', 'Im not comfortable sharing that'),
//           _buildQuestionBubble(
//             'Smoking',
//             profile!['person1_smoking'] ?? 'Im not comfortable sharing that',
//           ),
//           _buildQuestionBubble(
//             'Drinking',
//             profile!['person1_drinking'] ?? 'Im not comfortable sharing that',
//           ),
//           _buildQuestionBubble(
//             'Body Type',
//             profile!['person1_body_type'] ?? 'Im not comfortable sharing that',
//           ),
//           _buildQuestionBubble('Language Spoken', 'Im not comfortable sharing that'),
//           _buildQuestionBubble('Ethnic Background', 'Im not comfortable sharing that'),
//           _buildQuestionBubble('Piercings', 'Im not comfortable sharing that'),
//           _buildQuestionBubble('Circumcised', 'Im not comfortable sharing that'),
//           _buildQuestionBubble('Sexuality', 'Im not comfortable sharing that'),
//         ],
//       ),
//     );
//   }

//   Widget _buildSidebarItem(
//     String title,
//     int count,
//     IconData icon, {
//     bool isDestructive = false,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: isDestructive ? Colors.red : Colors.white70),
//       title: Text(
//         title,
//         style: TextStyle(color: isDestructive ? Colors.red : Colors.white),
//       ),
//       trailing: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//         decoration: BoxDecoration(
//           color: Colors.white24,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Text(
//           count.toString(),
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       onTap: () {
//         if (title == 'Like') {
//           _performAction('Like', () => ViewedMeApi.sendLike(widget.userId, 1));
//         }
//         if (title == 'Block User') {
//           _performAction('Block', () => ViewedMeApi.blockUser(widget.userId));
//         }
//         if (title == 'Already Friends') {
//           _performAction(
//             'Friend Request',
//             () => ViewedMeApi.sendFriendRequest(widget.userId),
//           );
//         }
//         if (title == 'Validate Pending') {
//           _performAction(
//             'Validate',
//             () => ViewedMeApi.sendValidate(widget.userId, "Verified"),
//           );
//         }
//         if (title == 'Already remember') {
//           _performAction(
//             'Remember',
//             () => ViewedMeApi.sendRemember(widget.userId),
//           );
//         }
//         if (title == 'Notes') {
//           _performAction(
//             'Note',
//             () => ViewedMeApi.sendNotes(widget.userId, "Nice profile!"),
//           );
//         }
//       },
//     );
//   }

//   Widget _buildQuestionBubble(String question, String answer) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Question pill badge
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF180024), Color(0xFF3D0053)],
//               ),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               question,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12,
//               ),
//             ),
//           ),
//           const SizedBox(height: 6),
//           // Answer bubble taking full width, looking like a speech bubble
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: const BorderRadius.only(
//                 topRight: Radius.circular(16),
//                 bottomLeft: Radius.circular(16),
//                 bottomRight: Radius.circular(16),
//               ),
//               border: Border.all(color: const Color(0xFFE6DFF0)),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.purple.withOpacity(0.05),
//                   blurRadius: 6,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Text(
//               answer,
//               style: const TextStyle(
//                 color: Colors.black87,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGenderIcon(String label, bool active) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: active
//             ? const Color(0xFFE91E63).withOpacity(0.15)
//             : Colors.grey[200],
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           fontSize: 18,
//           color: active ? const Color(0xFFE91E63) : Colors.grey,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }



// Beat Flirt /viewed-me screen converted from https://beatflirtevent.com/viewed-me
//
// Required pubspec dependencies:
//   http: ^1.2.2
//   shared_preferences: ^2.3.2
//   flutter_svg: ^2.0.10+1
//   geocoding: ^3.0.0
//   video_player: ^2.9.2
//
// AndroidManifest.xml needs INTERNET permission:
//   <uses-permission android:name="android.permission.INTERNET" />

import 'dart:async';
import 'dart:convert';

import 'package:beatflirt/single_user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'upgrade_page.dart';



const String _webBase = 'https://beatflirtevent.com/';
const String _apiBase = 'https://app.beatflirtevent.com/App';
const String _apiAssetBase = 'https://app.beatflirtevent.com/assets/';

String _webAsset(String path) => '$_webBase$path';

String _resolveMediaUrl(String raw) {
  final value = raw.trim();
  if (value.isEmpty) return '';
  if (value.startsWith('http://') || value.startsWith('https://')) return value;
  if (value.startsWith('//')) return 'https:$value';
  if (value.startsWith('assets/')) return '$_webBase$value';
  if (value.startsWith('/assets/')) return '${_webBase}${value.substring(1)}';
  if (value.startsWith('/')) return 'https://app.beatflirtevent.com$value';
  return '$_apiAssetBase$value';
}

String _btoa(String value) => base64Encode(utf8.encode(value));

bool _okStatus(dynamic status) => status?.toString() == '200';

String _string(dynamic value, [String fallback = '']) {
  if (value == null) return fallback;
  final s = value.toString();
  return s.isEmpty ? fallback : s;
}

int _int(dynamic value, [int fallback = 0]) {
  if (value == null) return fallback;
  if (value is int) return value;
  return int.tryParse(value.toString()) ?? fallback;
}

class BeatViewedMeApiException implements Exception {
  BeatViewedMeApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class BeatViewedMeApi {
  BeatViewedMeApi({
    required this.accessToken,
    required this.accessSign,
    http.Client? client,
    this.baseUrl = _apiBase,
  }) : _client = client ?? http.Client();

  final String accessToken;
  final String accessSign;
  final String baseUrl;
  final http.Client _client;

  Map<String, String> get _headers {
    final h = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
    if (accessToken.isNotEmpty) {
      h['Access-Token'] = accessToken;
      h['access-token'] = accessToken;
      h['Authorization'] = 'Bearer $accessToken';
    }
    if (accessSign.isNotEmpty) {
      h['Access-Sign'] = accessSign;
    }
    return h;
  }

  Future<Map<String, dynamic>> _get(String path) async {
    final response = await _client.get(Uri.parse('$baseUrl$path'), headers: _headers);
    return _decode(response);
  }

  Future<Map<String, dynamic>> _post(String path, [Map<String, dynamic>? body]) async {
    final response = await _client.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body ?? <String, dynamic>{}),
    );
    return _decode(response);
  }

  Map<String, dynamic> _decode(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw BeatViewedMeApiException('HTTP ${response.statusCode}: ${response.reasonPhrase ?? 'Request failed'}');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) return decoded;
    throw BeatViewedMeApiException('Unexpected API response');
  }

  /// Website API: POST /user/viewed_me
  Future<List<ViewedMeUser>> getViewedMe(ViewedMeFilter filter) async {
    final json = await _post('/user/viewed_me', filter.toJson());
    if (_okStatus(json['status'])) {
      final data = json['data'];
      if (data is List) return data.map((e) => ViewedMeUser.fromJson(Map<String, dynamic>.from(e))).toList();
      return <ViewedMeUser>[];
    }

    final message = _string(json['message']);
    if (message.toLowerCase().contains('token')) {
      throw BeatViewedMeApiException(message);
    }
    return <ViewedMeUser>[];
  }

  /// Website API: POST /user/create_chat_room
  Future<void> createChatRoom({
    required String fromUser,
    required String toUser,
    required String lastLogin,
  }) async {
    final json = await _post('/user/create_chat_room', {
      'from_user': fromUser,
      'to_user': toUser,
      'last_login': lastLogin,
    });
    if (!_okStatus(json['status']) && _string(json['message']).toLowerCase().contains('token')) {
      throw BeatViewedMeApiException(_string(json['message'], 'Unable to create chat room'));
    }
  }

  /// Common layout API used by the web header before opening this page.
  /// It returns membership_expire; the Angular code stores it as `membership`.
  Future<String?> checkLoginUserMembership() async {
    final json = await _post('/user/check_login_user_membership');
    return json['membership_expire']?.toString();
  }

  /// Optional common layout count API, included because the web shell calls it.
  Future<Map<String, dynamic>> notificationAllCount() => _get('/notification/all_count');
}

class ViewedMeFilter {
  const ViewedMeFilter({
    this.type = 'all',
    this.searchKeyword = '',
    this.locationText = '',
    this.lat = '0',
    this.lng = '0',
    this.city = '0',
    this.profileTypeArray = const <String>[],
  });

  final String type; // latest, all
  final String searchKeyword;
  final String locationText;
  final String lat;
  final String lng;
  final String city;
  final List<String> profileTypeArray; // Couple, Female, Male, Transgender

  ViewedMeFilter copyWith({
    String? type,
    String? searchKeyword,
    String? locationText,
    String? lat,
    String? lng,
    String? city,
    List<String>? profileTypeArray,
  }) {
    return ViewedMeFilter(
      type: type ?? this.type,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      locationText: locationText ?? this.locationText,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      city: city ?? this.city,
      profileTypeArray: profileTypeArray ?? this.profileTypeArray,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        // Initial Angular request sends search_keyword; filter submit sends keyword.
        // Sending both keeps the screen compatible with the current backend.
        'search_keyword': searchKeyword,
        'keyword': searchKeyword,
        'lat': lat,
        'lng': lng,
        'city': city,
        'profileTypeArray': profileTypeArray,
      };
}

class ViewedMeUserImage {
  ViewedMeUserImage({required this.profileImage});
  final String profileImage;

  factory ViewedMeUserImage.fromJson(Map<String, dynamic> json) => ViewedMeUserImage(
        profileImage: _string(json['profile_image']),
      );
}

class ViewedMeUserVideo {
  ViewedMeUserVideo({required this.video});
  final String video;

  factory ViewedMeUserVideo.fromJson(Map<String, dynamic> json) => ViewedMeUserVideo(
        video: _string(json['video']),
      );
}

class ViewedMeUser {
  ViewedMeUser({
    required this.raw,
    required this.id,
    required this.username,
    required this.email,
    required this.profileType,
    required this.genderProfileType,
    required this.age,
    required this.age2,
    required this.formattedAddress,
    required this.totalDistance,
    required this.distance,
    required this.lastLogin,
    required this.likesCount,
    required this.friendsCount,
    required this.validationCount,
    required this.images,
    required this.videos,
  });

  final Map<String, dynamic> raw;
  final String id;
  final String username;
  final String email;
  final String profileType;
  final String genderProfileType;
  final String age;
  final String age2;
  final String formattedAddress;
  final String totalDistance;
  final String distance;
  final String lastLogin;
  final int likesCount;
  final int friendsCount;
  final int validationCount;
  final List<ViewedMeUserImage> images;
  final List<ViewedMeUserVideo> videos;

  factory ViewedMeUser.fromJson(Map<String, dynamic> json) {
    final imageList = json['image'] is List ? json['image'] as List : const [];
    final videoList = json['video'] is List ? json['video'] as List : const [];
    return ViewedMeUser(
      raw: json,
      id: _string(json['id']),
      username: _string(json['username']),
      email: _string(json['email']),
      profileType: _string(json['profile_type']),
      genderProfileType: _string(json['gender_profile_type']),
      age: _string(json['age'], '21'),
      age2: _string(json['age2']),
      formattedAddress: _string(json['formatted_address']),
      totalDistance: _string(json['total_distance']),
      distance: _string(json['distance']),
      lastLogin: _string(json['last_login']),
      likesCount: _int(json['likes_count']),
      friendsCount: _int(json['friends_count']),
      validationCount: _int(json['validation_count']),
      images: imageList
          .whereType<Map>()
          .map((e) => ViewedMeUserImage.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      videos: videoList
          .whereType<Map>()
          .map((e) => ViewedMeUserVideo.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  String get primaryImage => images.isNotEmpty ? images.first.profileImage : '';

  bool flag(String key) => raw[key]?.toString() == '1';
}

class ViewedMePage extends StatefulWidget {
  const ViewedMePage({
    super.key,
    this.api,
    this.accessToken,
    this.accessSign,
    this.loginUserId,
    this.membershipValue,
    this.autoCheckMembership = true,
    this.lockCardsWhenMembershipValueIsYes = true,
    this.onOpenProfile,
    this.onOpenMessenger,
    this.onOpenMembership,
  });

  /// Pass your own API instance or pass accessToken/accessSign.
  /// If neither is passed, the widget reads SharedPreferences keys:
  /// Access-Token, Access-Sign, user-id, membership.
  final BeatViewedMeApi? api;
  final String? accessToken;
  final String? accessSign;
  final String? loginUserId;
  final String? membershipValue;

  /// The Angular app checks /user/check_login_user_membership in the shell header.
  /// Keep true when using this as a standalone Flutter screen.
  final bool autoCheckMembership;

  /// The website stores membership_expire as `membership`; current Angular logic
  /// locks cards when that value is "Yes".
  final bool lockCardsWhenMembershipValueIsYes;

  final void Function(BuildContext context, ViewedMeUser user)? onOpenProfile;
  final void Function(BuildContext context, ViewedMeUser user)? onOpenMessenger;
  final VoidCallback? onOpenMembership;
  @override
  State<ViewedMePage> createState() => _ViewedMePageState();
}

class _ViewedMePageState extends State<ViewedMePage> {
  BeatViewedMeApi? _api;
  ViewedMeFilter _filter = const ViewedMeFilter();
  List<ViewedMeUser> _friends = <ViewedMeUser>[];
  bool _booting = true;
  bool _loading = false;
  String? _error;
  String _loginUserId = '';
  String _membershipValue = '';

  final _filterSearchController = TextEditingController();
  final _filterLocationController = TextEditingController();

  @override
  void dispose() {
    _filterSearchController.dispose();
    _filterLocationController.dispose();
    super.dispose();
  }

  static const Color _lightBg = Color(0xFFFFF4FA);
  static const Color _primary = Color(0xFF1D042A);
  static const Color _maroon = Color(0xFF560827);
  static const Color _pink = Color(0xFFE91E63);
  static const Color _navy = Color(0xFF06032C);


  bool get _lockedByMembership {
    if (!widget.lockCardsWhenMembershipValueIsYes) return false;
    return _membershipValue == 'Yes';
  }

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final token = widget.accessToken ??
          prefs.getString('Access-Token') ??
          prefs.getString('access_token') ??
          prefs.getString('accessToken') ??
          prefs.getString('token') ??
          prefs.getString('auth_token') ??
          '';

      final sign = widget.accessSign ??
          prefs.getString('Access-Sign') ??
          prefs.getString('access_sign') ??
          prefs.getString('accessSign') ??
          prefs.getString('sign') ??
          '';

      _loginUserId = widget.loginUserId ??
          prefs.getString('user-id') ??
          prefs.getString('user_id') ??
          '';

      _membershipValue = widget.membershipValue ?? prefs.getString('membership') ?? '';
      _api = widget.api ?? BeatViewedMeApi(accessToken: token, accessSign: sign);

      if (widget.autoCheckMembership && token.isNotEmpty && sign.isNotEmpty) {
        final membershipExpire = await _api!.checkLoginUserMembership();
        if (membershipExpire != null) {
          _membershipValue = membershipExpire;
          await prefs.setString('membership', membershipExpire);
        }
      }

      if (!mounted) return;
      setState(() => _booting = false);
      await _loadFriends();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _booting = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _loadFriends() async {
    final api = _api;
    if (api == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await api.getViewedMe(_filter);
      if (!mounted) return;
      setState(() => _friends = data);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String message, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red.shade700 : Colors.green.shade700,
      ),
    );
  }

  Future<void> _chat(ViewedMeUser user) async {
    final api = _api;
    if (api == null) return;
    setState(() => _loading = true);
    try {
      await api.createChatRoom(fromUser: _loginUserId, toUser: user.id, lastLogin: user.lastLogin);
      if (!mounted) return;
      if (widget.onOpenMessenger != null) {
        widget.onOpenMessenger!(context, user);
      } else {
        Navigator.pushNamed(context, '/messenger', arguments: {'userid': _btoa(user.email)});
      }
    } catch (e) {
      _snack(e.toString(), error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _openProfile(ViewedMeUser user) {
    if (widget.onOpenProfile != null) {
      widget.onOpenProfile!(context, user);
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BeatSingleUserProfileScreen(
          userId: user.id,
          accessToken: widget.accessToken,
          accessSign: widget.accessSign,
          loginUserId: _loginUserId,
        ),
      ),
    );
  }

  Future<void> _openFilterSheet() async {
    _filterSearchController.text = _filter.searchKeyword;
    _filterLocationController.text = _filter.locationText;
    var draft = _filter;
    var resolvingLocation = false;

    final result = await showModalBottomSheet<ViewedMeFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> submit() async {
              setModalState(() => resolvingLocation = true);
              var lat = '0';
              var lng = '0';
              var city = '0';
              final locationText = _filterLocationController.text.trim();
              if (locationText.isNotEmpty) {
                try {
                  final locations = await locationFromAddress(locationText);
                  if (locations.isNotEmpty) {
                    lat = locations.first.latitude.toString();
                    lng = locations.first.longitude.toString();
                    city = locationText;
                  }
                } catch (_) {
                  // Keep original web fallback: 0/0 when no Google place is selected.
                }
              }
              if (!mounted) return;
              Navigator.pop(
                context,
                draft.copyWith(
                  searchKeyword: _filterSearchController.text.trim(),
                  locationText: locationText,
                  lat: lat,
                  lng: lng,
                  city: city,
                ),
              );
            }

            Widget radio(String label, String value) => InkWell(
                  onTap: () => setModalState(() => draft = draft.copyWith(type: value)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Radio<String>(
                          value: value,
                          groupValue: draft.type,
                          activeColor: Colors.white,
                          fillColor: MaterialStateProperty.all(Colors.white),
                          onChanged: (v) => setModalState(() => draft = draft.copyWith(type: v)),
                        ),
                        Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
                      ],
                    ),
                  ),
                );

            Widget checkbox(String label, String value, Color dotColor) {
              final checked = draft.profileTypeArray.contains(value);
              return InkWell(
                onTap: () {
                  final next = List<String>.from(draft.profileTypeArray);
                  checked ? next.remove(value) : next.add(value);
                  setModalState(() => draft = draft.copyWith(profileTypeArray: next));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Checkbox(
                        value: checked,
                        activeColor: Colors.white,
                        checkColor: _maroon,
                        side: const BorderSide(color: Colors.white),
                        onChanged: (v) {
                          final next = List<String>.from(draft.profileTypeArray);
                          v == true ? next.add(value) : next.remove(value);
                          setModalState(() => draft = draft.copyWith(profileTypeArray: next.toSet().toList()));
                        },
                      ),
                      Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
                      const SizedBox(width: 6),
                      Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
                    ],
                  ),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [_maroon, _navy],
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                ),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            width: 42,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                        radio('Latest', 'latest'),
                        radio('All', 'all'),
                        const Divider(color: Colors.white54),
                        checkbox('Couples', 'Couple', Colors.red),
                        checkbox('Females', 'Female', Colors.pink),
                        checkbox('Males', 'Male', Colors.orange),
                        checkbox('Transgenders', 'Transgender', Colors.yellow),
                        const SizedBox(height: 8),
                        _filterTextField(_filterSearchController, 'Search Username...'),
                        const SizedBox(height: 8),
                        _filterTextField(_filterLocationController, 'Search Location...'),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                          onPressed: resolvingLocation ? null : submit,
                          child: resolvingLocation
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Text('Ok', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() => _filter = result);
      await _loadFriends();
    }
  }

  Widget _filterTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_ios_new,size: 20, color: _primary)),
        title: 
         RichText(
            text: TextSpan(
              text: 'Viewed Me ',
              style: const TextStyle(color: _primary, fontSize: 22, fontWeight: FontWeight.w600),
              children: [
                if (_friends.isNotEmpty)
                  TextSpan(text: '(${_friends.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          
          centerTitle: true,
        ),
      
      backgroundColor: _lightBg,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _loadFriends,
              color: _maroon,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _header(),
                  if (_booting) const Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Center(child: CircularProgressIndicator(color: _maroon)),
                  ) else if (_error != null) ...[
                    _errorBox(_error!),
                  ] else if (_friends.isEmpty && !_loading) ...[
                    _noData(),
                  ] else ...[
                    const SizedBox(height: 16),
                    _friendGrid(),
                  ],
                ],
              ),
            ),
            if (_loading && !_booting)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: Colors.black.withOpacity(0.04),
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.only(top: 8),
                    child: const LinearProgressIndicator(minHeight: 3, color: _maroon),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_ios_new,size: 20, color: _primary)),
        // Flexible(
        //   child: RichText(
        //     text: TextSpan(
        //       text: 'Viewed Me ',
        //       style: const TextStyle(color: _primary, fontSize: 22, fontWeight: FontWeight.w600),
        //       children: [
        //         if (_friends.isNotEmpty)
        //           TextSpan(text: '(${_friends.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        //       ],
        //     ),
        //   ),
        // ),
        if (!_lockedByMembership)
          InkWell(
            onTap: _openFilterSheet,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: SvgPicture.network(
                _webAsset('assets/img/icons/filter.svg'),
                width: 20,
                height: 20,
                placeholderBuilder: (_) => const Icon(Icons.filter_alt, size: 20, color: _maroon),
              ),
            ),
          ),
      ],
    );
  }

  Widget _friendGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 920 ? 4 : width >= 620 ? 2 : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _friends.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 18,
            mainAxisSpacing: 20,
            mainAxisExtent: 505,
          ),
          itemBuilder: (context, index) {
            final user = _friends[index];
            if (_lockedByMembership) {
              return _lockedCard();
            }
            return _friendCard(user);
          },
        );
      },
    );
  }

  Widget _friendCard(ViewedMeUser user) {
    final imageCount = user.images.length;
    final videoCount = user.videos.length;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        GestureDetector(
          onTap: () => _openProfile(user),
          child: Container(
            margin: const EdgeInsets.only(top: 60),
          height: 425,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_maroon, _navy],
            ),
            boxShadow: const [BoxShadow(color: Color(0x4D000000), blurRadius: 40, offset: Offset(0, 20))],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 64, 16, 12),
            child: Column(
              children: [
                InkWell(
                  onTap: () => _openProfile(user),
                  child: Text(
                    user.username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  user.age2.isNotEmpty ? 'Age ${user.age} | ${user.age2}' : 'Age ${user.age}',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
                const SizedBox(height: 8),
                _genderIcons(user),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(color: _pink, borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    user.genderProfileType,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 12),
                _locationLine(user),
                const SizedBox(height: 10),
                if (_loginUserId != user.id)
                  InkWell(
                    onTap: () => _chat(user),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        _webAsset('assets/img/icons/chat.jpg'),
                        width: 30,
                        height: 30,
                        errorBuilder: (_, __, ___) => const Icon(Icons.chat_bubble, color: Colors.white),
                      ),
                    ),
                  ),
                const Spacer(),
                _actionBar(user, imageCount, videoCount),
              ],
            ),
          ),
        ),
        ),
        Positioned(
          top: 0,
          child: GestureDetector(
            onTap: () => _openProfile(user),
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _pink, width: 4),
                color: Colors.white,
              ),
              clipBehavior: Clip.antiAlias,
              child: _networkImage(user.primaryImage, fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }

  Widget _lockedCard() {
    return GestureDetector(
      onTap: _showMembershipDialog,
      child: Container(
        margin: const EdgeInsets.only(top: 60),
        height: 425,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [_maroon, _navy]),
          boxShadow: const [BoxShadow(color: Color(0x4D000000), blurRadius: 40, offset: Offset(0, 20))],
        ),
        child: Center(
          child: Container(
            width: 240,
            height: 300,
            padding: const EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                _webAsset('assets/img/celebrity/bg-logo.jpg'),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.lock, color: Colors.white, size: 54),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _genderIcons(ViewedMeUser user) {
    final icons = <String>[];
    if (user.flag('couple_male_female_swingers')) icons.add('assets/img/icons/couple-logo.svg');
    if (user.flag('couple_female_female_swingers')) icons.add('assets/img/icons/female-logo.svg');
    if (user.flag('couple_male_male_swingers')) icons.add('assets/img/icons/male-logo.svg');
    if (user.flag('couple_male_swingers')) icons.add('assets/img/icons/single-male.svg');
    if (user.flag('couple_female_swingers')) icons.add('assets/img/icons/single-female.svg');
    if (user.flag('couple_transgender_swingers')) icons.add('assets/img/icons/transgender-logo.svg');

    if (icons.isEmpty) return const SizedBox(height: 20);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: icons
          .map(
            (path) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: SvgPicture.network(
                _webAsset(path),
                width: 20,
                height: 20,
                placeholderBuilder: (_) => const SizedBox(width: 20, height: 20),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _locationLine(ViewedMeUser user) {
    final distanceText = '${user.totalDistance} ${user.distance}'.trim();
    final parts = <String>[
      if (user.formattedAddress.isNotEmpty) user.formattedAddress,
      if (distanceText.isNotEmpty) distanceText,
    ];
    final text = parts.join(' | ');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.location_on, color: Colors.white, size: 20),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text.trim(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _smallButton(String text, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _actionBar(ViewedMeUser user, int imageCount, int videoCount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _actionItem('assets/img/icons/camera.svg', '$imageCount', imageCount > 0 ? () => _showImages(user) : null),
          _actionItem('assets/img/icons/like.svg', '${user.likesCount}', null),
          _actionItem('assets/img/icons/people.svg', '${user.friendsCount}', null),
          _actionItem('assets/img/icons/share.svg', '${user.validationCount}', null),
          _actionItem('assets/img/icons/video.svg', '$videoCount', videoCount > 0 ? () => _showVideos(user) : null),
        ],
      ),
    );
  }

  Widget _actionItem(String iconPath, String count, VoidCallback? onTap) {
    final child = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.network(
          _webAsset(iconPath),
          // width: 22,
          // height: 22,

          width: 15,
          height: 15,
          placeholderBuilder: (_) => const Icon(Icons.circle, color: Colors.white, size: 18),
        ),
        const SizedBox(height: 3),
        Text(count, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
    if (onTap == null) return Opacity(opacity: 0.92, child: child);
    return InkWell(onTap: onTap, child: child);
  }

  Widget _networkImage(String rawUrl, {BoxFit fit = BoxFit.cover}) {
    final url = _resolveMediaUrl(rawUrl);
    if (url.isEmpty) {
      return Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: const Icon(Icons.person, color: _maroon, size: 46),
      );
    }
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: const Icon(Icons.person, color: _maroon, size: 46),
      ),
      loadingBuilder: (context, child, loading) {
        if (loading == null) return child;
        return const Center(child: CircularProgressIndicator(strokeWidth: 2, color: _maroon));
      },
    );
  }

  void _showImages(ViewedMeUser user) {
    if (user.images.isEmpty) return;
    showDialog(
      context: context,
      builder: (_) => _MediaDialog(
        title: user.username,
        itemCount: user.images.length,
        itemBuilder: (context, index) => InteractiveViewer(
          child: Image.network(
            _resolveMediaUrl(user.images[index].profileImage),
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.white, size: 60),
          ),
        ),
      ),
    );
  }

  void _showVideos(ViewedMeUser user) {
    if (user.videos.isEmpty) return;
    showDialog(
      context: context,
      builder: (_) => _MediaDialog(
        title: user.username,
        itemCount: user.videos.length,
        itemBuilder: (context, index) => _NetworkVideoPlayer(url: _resolveMediaUrl(user.videos[index].video)),
      ),
    );
  }

  Widget _errorBox(String message) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 42),
          const SizedBox(height: 10),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87)),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: _loadFriends,
            style: ElevatedButton.styleFrom(backgroundColor: _maroon, foregroundColor: Colors.white),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _noData() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 30, offset: Offset(0, 10))],
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(color: Color(0x1A01529C), shape: BoxShape.circle),
            child: const Icon(Icons.person_off_outlined, size: 62, color: _maroon),
          ),
          const SizedBox(height: 25),
          const Text('No Record Found', style: TextStyle(color: _primary, fontWeight: FontWeight.w600, fontSize: 24)),
          const SizedBox(height: 10),
          const Text(
            "It looks like no one has viewed your profile yet. Try updating your profile or joining some events!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF777777), fontSize: 16, height: 1.6),
          ),
        ],
      ),
    );
  }

  void _showMembershipDialog() {
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [_maroon, _navy]),
          ),
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Beat Flirt Team!', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              const Text(
                '"You have not purchased a Beat Flirt membership plan. Buy membership"',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: _maroon, foregroundColor: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                  if (widget.onOpenMembership != null) {
                    widget.onOpenMembership!();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const UpgradePage()),
                    );
                  }
                },
                child: const Text('Purchase'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MediaDialog extends StatefulWidget {
  const _MediaDialog({required this.title, required this.itemCount, required this.itemBuilder});

  final String title;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  State<_MediaDialog> createState() => _MediaDialogState();
}

class _MediaDialogState extends State<_MediaDialog> {
  final PageController _pageController = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text('${_index + 1}/${widget.itemCount}', style: const TextStyle(color: Colors.white70)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.white)),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.itemCount,
                onPageChanged: (v) => setState(() => _index = v),
                itemBuilder: widget.itemBuilder,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NetworkVideoPlayer extends StatefulWidget {
  const _NetworkVideoPlayer({required this.url});

  final String url;

  @override
  State<_NetworkVideoPlayer> createState() => _NetworkVideoPlayerState();
}

class _NetworkVideoPlayerState extends State<_NetworkVideoPlayer> {
  VideoPlayerController? _controller;
  Future<void>? _init;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _init = _controller!.initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _init,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }
        if (snapshot.hasError || _controller == null) {
          return const Center(child: Icon(Icons.videocam_off, color: Colors.white, size: 64));
        }
        final controller = _controller!;
        return Center(
          child: GestureDetector(
            onTap: () {
              setState(() => controller.value.isPlaying ? controller.pause() : controller.play());
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(aspectRatio: controller.value.aspectRatio, child: VideoPlayer(controller)),
                if (!controller.value.isPlaying)
                  Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.45), shape: BoxShape.circle),
                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 52),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
