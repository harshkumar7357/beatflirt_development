// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // import 'package:beatflirt/providers/user_list_provider.dart';

// // // class LikesPage extends ConsumerWidget {
// // //   const LikesPage({super.key});

// // //   @override
// // //   Widget build(BuildContext context, WidgetRef ref) {
// // //     final state = ref.watch(userListProvider('likes'));

// // //     return Scaffold(
// // //       backgroundColor: const Color(0xFFF8F9FB),
// // //       appBar: AppBar(
// // //         title: const Text('Likes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
// // //         backgroundColor: Colors.white,
// // //         elevation: 0,
// // //         iconTheme: const IconThemeData(color: Colors.black87),
// // //         actions: [
// // //           IconButton(
// // //             icon: const Icon(Icons.filter_list),
// // //             onPressed: () {},
// // //           ),
// // //         ],
// // //         leading: IconButton(
// // //           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
// // //           onPressed: () => Navigator.pop(context),
// // //         ),
// // //       ),
// // //       body: state.users.isEmpty
// // //           ? _buildEmptyState()
// // //           : ListView.separated(
// // //               padding: const EdgeInsets.all(16),
// // //               itemCount: state.users.length,
// // //               separatorBuilder: (context, index) => const SizedBox(height: 12),
// // //               itemBuilder: (context, index) {
// // //                 final user = state.users[index];
// // //                 return _buildUserCard(context, ref, user);
// // //               },
// // //             ),
// // //     );
// // //   }

// // //   Widget _buildUserCard(BuildContext context, WidgetRef ref, UserListItem user) {
// // //     return Container(
// // //       padding: const EdgeInsets.all(12),
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         borderRadius: BorderRadius.circular(20),
// // //         boxShadow: [
// // //           BoxShadow(
// // //             color: Colors.black.withValues(alpha: 0.05),
// // //             blurRadius: 10,
// // //             offset: const Offset(0, 4),
// // //           ),
// // //         ],
// // //       ),
// // //       child: Row(
// // //         children: [
// // //           Stack(
// // //             children: [
// // //               CircleAvatar(
// // //                 radius: 30,
// // //                 backgroundImage: AssetImage(user.imageUrl),
// // //               ),
// // //               if (user.isOnline)
// // //                 Positioned(
// // //                   right: 0,
// // //                   bottom: 0,
// // //                   child: Container(
// // //                     width: 14,
// // //                     height: 14,
// // //                     decoration: BoxDecoration(
// // //                       color: Colors.green,
// // //                       shape: BoxShape.circle,
// // //                       border: Border.all(color: Colors.white, width: 2),
// // //                     ),
// // //                   ),
// // //                 ),
// // //             ],
// // //           ),
// // //           const SizedBox(width: 16),
// // //           Expanded(
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Text(
// // //                   user.name,
// // //                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// // //                 ),
// // //                 Text(
// // //                   user.lastSeen,
// // //                   style: TextStyle(color: Colors.grey[600], fontSize: 13),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           IconButton(
// // //             icon: const Icon(Icons.favorite, color: Colors.pink),
// // //             onPressed: () {
// // //               // Action for mutual like or removing from likes
// // //             },
// // //           ),
// // //           IconButton(
// // //             icon: const Icon(Icons.chat_bubble_outline, color: Colors.blueAccent),
// // //             onPressed: () {},
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildEmptyState() {
// // //     return Center(
// // //       child: Column(
// // //         mainAxisAlignment: MainAxisAlignment.center,
// // //         children: [
// // //           Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
// // //           const SizedBox(height: 16),
// // //           const Text(
// // //             'No likes yet',
// // //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
// // //           ),
// // //           const SizedBox(height: 8),
// // //           const Text(
// // //             'Discover people and get noticed!',
// // //             style: TextStyle(color: Colors.grey),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }



// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:shared_preferences/shared_preferences.dart';

// // // ============================================================
// // //     BEAT FLIRT - COMPLETE LIKES + DETAILED PROFILE
// // //     Single File - Full UI + API + Models
// // // ============================================================

// // const String BASE_URL = 'https://beatflirtevent.com';

// // // ============================================================
// // //                           MODELS
// // // ============================================================

// // class LikeModel {
// //   final int? id;
// //   final String? username;
// //   final String? profileImage;
// //   final String? age;
// //   final String? gender;
// //   final String? location;
// //   final String? distance;
// //   final bool? isOnline;

// //   LikeModel({
// //     this.id,
// //     this.username,
// //     this.profileImage,
// //     this.age,
// //     this.gender,
// //     this.location,
// //     this.distance,
// //     this.isOnline,
// //   });

// //   factory LikeModel.fromJson(Map<String, dynamic> json) {
// //     return LikeModel(
// //       id: json['id'],
// //       username: json['username'] ?? json['name'],
// //       profileImage: json['profile_image'] ?? json['image'],
// //       age: json['age']?.toString(),
// //       gender: json['gender'],
// //       location: json['location'] ?? json['city'],
// //       distance: json['distance']?.toString(),
// //       isOnline: json['is_online'] ?? false,
// //     );
// //   }
// // }

// // class ProfileAnswer {
// //   final String question;
// //   final String answer;

// //   ProfileAnswer({required this.question, required this.answer});
// // }

// // class DetailedUserProfileModel {
// //   final int? id;
// //   final String? username;
// //   final String? profileImage;
// //   final String? coverImage;
// //   final String? age;
// //   final String? gender;
// //   final String? location;
// //   final String? fullLocation;
// //   final bool? isOnline;
// //   final List<ProfileAnswer> profileAnswers;
// //   final int alreadyFriends;
// //   final int dislikes;
// //   final int validates;
// //   final int remembers;
// //   final int notes;
// //   final int blocks;

// //   DetailedUserProfileModel({
// //     this.id,
// //     this.username,
// //     this.profileImage,
// //     this.coverImage,
// //     this.age,
// //     this.gender,
// //     this.location,
// //     this.fullLocation,
// //     this.isOnline,
// //     this.profileAnswers = const [],
// //     this.alreadyFriends = 0,
// //     this.dislikes = 0,
// //     this.validates = 0,
// //     this.remembers = 0,
// //     this.notes = 0,
// //     this.blocks = 0,
// //   });

// //   factory DetailedUserProfileModel.fromJson(Map<String, dynamic> json) {
// //     List<ProfileAnswer> answers = [];
    
// //     // Parse profile answers if available
// //     if (json['profile_answers'] != null) {
// //       for (var item in json['profile_answers']) {
// //         answers.add(ProfileAnswer(
// //           question: item['question'] ?? '',
// //           answer: item['answer'] ?? 'I\'m not comfortable sharing that',
// //         ));
// //       }
// //     } else {
// //       // Default answers matching the screenshot
// //       answers = [
// //         ProfileAnswer(question: "Age", answer: "18 Years"),
// //         ProfileAnswer(question: "Tattoos", answer: "I'm not comfortable sharing that"),
// //         ProfileAnswer(question: "Body Hair", answer: "I'm not comfortable sharing that"),
// //         ProfileAnswer(question: "Weight", answer: "I'm not comfortable sharing that"),
// //         ProfileAnswer(question: "Height", answer: "I'm not comfortable sharing that"),
// //         ProfileAnswer(question: "Smoking", answer: "I'm not comfortable sharing that"),
// //         ProfileAnswer(question: "Drinking", answer: "I'm not comfortable sharing that"),
// //         ProfileAnswer(question: "Body Type", answer: "I'm not comfortable sharing that"),
// //         ProfileAnswer(question: "Language Spoken", answer: "I'm not comfortable sharing that"),
// //         ProfileAnswer(question: "Ethnic Background", answer: "I'm not comfortable sharing that"),
// //       ];
// //     }

// //     return DetailedUserProfileModel(
// //       id: json['id'],
// //       username: json['username'] ?? json['name'],
// //       profileImage: json['profile_image'] ?? json['image'],
// //       coverImage: json['cover_image'],
// //       age: json['age']?.toString(),
// //       gender: json['gender'],
// //       location: json['location'] ?? json['city'],
// //       fullLocation: json['full_location'] ?? json['address'],
// //       isOnline: json['is_online'] ?? false,
// //       profileAnswers: answers,
// //       alreadyFriends: json['already_friends'] ?? 1,
// //       dislikes: json['dislikes'] ?? 1,
// //       validates: json['validates'] ?? 0,
// //       remembers: json['remembers'] ?? 0,
// //       notes: json['notes'] ?? 0,
// //       blocks: json['blocks'] ?? 0,
// //     );
// //   }
// // }

// // // ============================================================
// // //                           API SERVICE
// // // ============================================================

// // class BeatFlirtApi {
// //   static String? _token;

// //   static Map<String, String> get _headers => {
// //         'Content-Type': 'application/json',
// //         'Accept': 'application/json',
// //         if (_token != null) 'Authorization': 'Bearer $_token',
// //       };

// //   static Future<void> saveToken(String token) async {
// //     _token = token;
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setString('bf_auth_token', token);
// //   }

// //   static Future<void> loadToken() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     _token = prefs.getString('bf_auth_token');
// //   }

// //   static Future<void> clearToken() async {
// //     _token = null;
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.remove('bf_auth_token');
// //   }

// //   static bool get isLoggedIn => _token != null;

// //   // ==================== LIKES ====================
// //   static Future<List<dynamic>> getLikes() async {
// //     final response = await http.get(Uri.parse('$BASE_URL/likes'), headers: _headers);
// //     if (response.statusCode == 200) {
// //       return jsonDecode(response.body);
// //     }
// //     return [];
// //   }

// //   // ==================== DETAILED USER PROFILE ====================
// //   static Future<Map<String, dynamic>> getSingleUserProfile(int userId) async {
// //     final response = await http.get(
// //       Uri.parse('$BASE_URL/single-user-profile?user_id=$userId'),
// //       headers: _headers,
// //     );
// //     if (response.statusCode == 200) {
// //       return jsonDecode(response.body);
// //     }
// //     throw Exception('Failed to load user profile');
// //   }

// //   static Future<Map<String, dynamic>> getViewSingleProfile(int userId) async {
// //     final response = await http.get(
// //       Uri.parse('$BASE_URL/view-single-profile?id=$userId'),
// //       headers: _headers,
// //     );
// //     if (response.statusCode == 200) {
// //       return jsonDecode(response.body);
// //     }
// //     throw Exception('Failed to load user profile');
// //   }

// //   // ==================== ACTIONS ====================
// //   static Future<bool> sendMessage(int userId, String message) async {
// //     final response = await http.post(
// //       Uri.parse('$BASE_URL/message'),
// //       headers: _headers,
// //       body: jsonEncode({'receiver_id': userId, 'message': message}),
// //     );
// //     return response.statusCode == 200 || response.statusCode == 201;
// //   }

// //   static Future<bool> addToFriends(int userId) async {
// //     final response = await http.post(
// //       Uri.parse('$BASE_URL/add-friend'),
// //       headers: _headers,
// //       body: jsonEncode({'user_id': userId}),
// //     );
// //     return response.statusCode == 200;
// //   }

// //   static Future<bool> dislikeUser(int userId) async {
// //     final response = await http.post(
// //       Uri.parse('$BASE_URL/dislike'),
// //       headers: _headers,
// //       body: jsonEncode({'user_id': userId}),
// //     );
// //     return response.statusCode == 200;
// //   }

// //   static Future<bool> blockUser(int userId) async {
// //     final response = await http.post(
// //       Uri.parse('$BASE_URL/block-user'),
// //       headers: _headers,
// //       body: jsonEncode({'user_id': userId}),
// //     );
// //     return response.statusCode == 200;
// //   }
// // }

// // // ============================================================
// // //                    LIKES SCREEN
// // // ============================================================

// // class LikesPage extends StatefulWidget {
// //   const LikesPage({super.key});

// //   @override
// //   State<LikesPage> createState() => _LikesPageState();
// // }

// // class _LikesPageState extends State<LikesPage> {
// //   List<LikeModel> likes = [];
// //   List<LikeModel> filteredLikes = [];
// //   bool isLoading = true;

// //   String selectedGender = 'All';
// //   RangeValues ageRange = const RangeValues(18, 60);
// //   bool showOnlineOnly = false;
// //   String sortBy = 'Newest';

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadLikes();
// //   }

// //   Future<void> _loadLikes() async {
// //     setState(() => isLoading = true);
// //     try {
// //       final data = await BeatFlirtApi.getLikes();
// //       setState(() {
// //         likes = data.map((e) => LikeModel.fromJson(e)).toList();
// //         filteredLikes = List.from(likes);
// //         isLoading = false;
// //       });
// //       _applyFilters();
// //     } catch (e) {
// //       setState(() => isLoading = false);
// //     }
// //   }

// //   void _applyFilters() {
// //     setState(() {
// //       filteredLikes = likes.where((like) {
// //         if (selectedGender != 'All' && like.gender != null) {
// //           if (like.gender!.toLowerCase() != selectedGender.toLowerCase()) return false;
// //         }
// //         if (like.age != null) {
// //           final age = int.tryParse(like.age!) ?? 0;
// //           if (age < ageRange.start || age > ageRange.end) return false;
// //         }
// //         if (showOnlineOnly && (like.isOnline != true)) return false;
// //         return true;
// //       }).toList();

// //       if (sortBy == 'Closest') {
// //         filteredLikes.sort((a, b) {
// //           final distA = double.tryParse(a.distance ?? '99999') ?? 99999;
// //           final distB = double.tryParse(b.distance ?? '99999') ?? 99999;
// //           return distA.compareTo(distB);
// //         });
// //       } else if (sortBy == 'Age') {
// //         filteredLikes.sort((a, b) {
// //           final ageA = int.tryParse(a.age ?? '0') ?? 0;
// //           final ageB = int.tryParse(b.age ?? '0') ?? 0;
// //           return ageA.compareTo(ageB);
// //         });
// //       }
// //     });
// //   }

// //   void _showFilterBottomSheet() {
// //     showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       backgroundColor: const Color(0xFF1E1E1E),
// //       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
// //       builder: (context) {
// //         return StatefulBuilder(builder: (context, setModalState) {
// //           return Padding(
// //             padding: const EdgeInsets.all(20),
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 const Text('Filters', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
// //                 const SizedBox(height: 20),
// //                 const Text('Gender', style: TextStyle(fontWeight: FontWeight.w600)),
// //                 Wrap(
// //                   spacing: 8,
// //                   children: ['All', 'Male', 'Female', 'Other'].map((gender) {
// //                     return ChoiceChip(
// //                       label: Text(gender),
// //                       selected: selectedGender == gender,
// //                       onSelected: (_) => setModalState(() => selectedGender = gender),
// //                     );
// //                   }).toList(),
// //                 ),
// //                 const SizedBox(height: 20),
// //                 const Text('Age Range', style: TextStyle(fontWeight: FontWeight.w600)),
// //                 RangeSlider(
// //                   values: ageRange,
// //                   min: 18,
// //                   max: 80,
// //                   divisions: 62,
// //                   labels: RangeLabels(ageRange.start.round().toString(), ageRange.end.round().toString()),
// //                   onChanged: (values) => setModalState(() => ageRange = values),
// //                 ),
// //                 SwitchListTile(
// //                   title: const Text('Online Only'),
// //                   value: showOnlineOnly,
// //                   onChanged: (val) => setModalState(() => showOnlineOnly = val),
// //                 ),
// //                 const SizedBox(height: 20),
// //                 const Text('Sort By', style: TextStyle(fontWeight: FontWeight.w600)),
// //                 Wrap(
// //                   spacing: 8,
// //                   children: ['Newest', 'Closest', 'Age'].map((sort) {
// //                     return ChoiceChip(
// //                       label: Text(sort),
// //                       selected: sortBy == sort,
// //                       onSelected: (_) => setModalState(() => sortBy = sort),
// //                     );
// //                   }).toList(),
// //                 ),
// //                 const SizedBox(height: 30),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: OutlinedButton(
// //                         onPressed: () {
// //                           setState(() {
// //                             selectedGender = 'All';
// //                             ageRange = const RangeValues(18, 60);
// //                             showOnlineOnly = false;
// //                             sortBy = 'Newest';
// //                           });
// //                           _applyFilters();
// //                           Navigator.pop(context);
// //                         },
// //                         child: const Text('Reset'),
// //                       ),
// //                     ),
// //                     const SizedBox(width: 12),
// //                     Expanded(
// //                       child: ElevatedButton(
// //                         onPressed: () {
// //                           _applyFilters();
// //                           Navigator.pop(context);
// //                         },
// //                         style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE91E63)),
// //                         child: const Text('Apply'),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           );
// //         });
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Likes (${filteredLikes.length})'),
// //         actions: [
// //           IconButton(icon: const Icon(Icons.filter_list), onPressed: _showFilterBottomSheet),
// //           IconButton(icon: const Icon(Icons.refresh), onPressed: _loadLikes),
// //         ],
// //       ),
// //       body: isLoading
// //           ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFC107)))
// //           : filteredLikes.isEmpty
// //               ? _buildEmptyState()
// //               : ListView.builder(
// //                   padding: const EdgeInsets.all(16),
// //                   itemCount: filteredLikes.length,
// //                   itemBuilder: (context, index) {
// //                     final like = filteredLikes[index];
// //                     return _buildLikeCard(like);
// //                   },
// //                 ),
// //     );
// //   }

// //   Widget _buildEmptyState() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Icon(Icons.favorite_border, size: 80, color: Colors.grey[700]),
// //           const SizedBox(height: 20),
// //           const Text('No Likes Yet', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildLikeCard(LikeModel like) {
// //     return GestureDetector(
// //       onTap: () {
// //         if (like.id != null) {
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(builder: (_) => DetailedProfileScreen(userId: like.id!)),
// //           );
// //         }
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
// //             Container(
// //               margin: const EdgeInsets.only(top: 16),
// //               decoration: BoxDecoration(
// //                 shape: BoxShape.circle,
// //                 border: Border.all(color: const Color(0xFFE91E63), width: 3),
// //               ),
// //               child: CircleAvatar(
// //                 radius: 55,
// //                 backgroundColor: Colors.grey[800],
// //                 backgroundImage: like.profileImage != null ? NetworkImage(like.profileImage!) : null,
// //                 child: like.profileImage == null ? const Icon(Icons.person, size: 55, color: Colors.white70) : null,
// //               ),
// //             ),
// //             const SizedBox(height: 12),
// //             Text(like.username ?? 'Unknown', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
// //             if (like.age != null)
// //               Container(
// //                 margin: const EdgeInsets.only(top: 6),
// //                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
// //                 decoration: BoxDecoration(color: const Color(0xFFE91E63), borderRadius: BorderRadius.circular(20)),
// //                 child: Text('Age ${like.age}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
// //               ),
// //             const SizedBox(height: 12),
// //             if (like.gender != null) Text(like.gender!, style: const TextStyle(fontSize: 15, color: Colors.white70)),
// //             if (like.location != null || like.distance != null)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8, left: 20, right: 20),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     const Icon(Icons.location_on, size: 16, color: Colors.white54),
// //                     const SizedBox(width: 4),
// //                     Expanded(
// //                       child: Text(
// //                         '${like.location ?? ''} ${like.distance != null ? '• ${like.distance} km' : ''}',
// //                         style: const TextStyle(color: Colors.white54, fontSize: 13),
// //                         overflow: TextOverflow.ellipsis,
// //                       ),
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
// // //              DETAILED PROFILE SCREEN (Matching Screenshot)
// // // ============================================================

// // class DetailedProfileScreen extends StatefulWidget {
// //   final int userId;
// //   const DetailedProfileScreen({super.key, required this.userId});

// //   @override
// //   State<DetailedProfileScreen> createState() => _DetailedProfileScreenState();
// // }

// // class _DetailedProfileScreenState extends State<DetailedProfileScreen> {
// //   DetailedUserProfileModel? user;
// //   bool isLoading = true;
// //   bool isSendingMessage = false;
// //   final TextEditingController _messageController = TextEditingController();

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadDetailedProfile();
// //   }

// //   Future<void> _loadDetailedProfile() async {
// //     setState(() => isLoading = true);
// //     try {
// //       Map<String, dynamic> data;
// //       try {
// //         data = await BeatFlirtApi.getSingleUserProfile(widget.userId);
// //       } catch (_) {
// //         data = await BeatFlirtApi.getViewSingleProfile(widget.userId);
// //       }
// //       setState(() {
// //         user = DetailedUserProfileModel.fromJson(data);
// //         isLoading = false;
// //       });
// //     } catch (e) {
// //       setState(() => isLoading = false);
// //     }
// //   }

// //   Future<void> _sendMessage() async {
// //     if (_messageController.text.trim().isEmpty || user?.id == null) return;
// //     setState(() => isSendingMessage = true);
// //     try {
// //       await BeatFlirtApi.sendMessage(user!.id!, _messageController.text.trim());
// //       _messageController.clear();
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('Message sent!'), backgroundColor: Colors.green),
// //         );
// //       }
// //     } catch (e) {
// //       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
// //     }
// //     setState(() => isSendingMessage = false);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF8F5F5),
// //       appBar: AppBar(
// //         title: const Text('Profile'),
// //         backgroundColor: Colors.white,
// //         foregroundColor: Colors.black,
// //       ),
// //       body: isLoading
// //           ? const Center(child: CircularProgressIndicator(color: Color(0xFFE91E63)))
// //           : user == null
// //               ? const Center(child: Text('Failed to load profile'))
// //               : _buildDetailedProfile(),
// //     );
// //   }

// //   Widget _buildDetailedProfile() {
// //     return SingleChildScrollView(
// //       child: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Row(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // LEFT COLUMN - Profile Card + Sidebar
// //             Expanded(
// //               flex: 5,
// //               child: Column(
// //                 children: [
// //                   // Profile Card
// //                   Container(
// //                     decoration: BoxDecoration(
// //                       color: const Color(0xFF2D1B3D),
// //                       borderRadius: BorderRadius.circular(16),
// //                     ),
// //                     child: Column(
// //                       children: [
// //                         // Profile Image
// //                         ClipRRect(
// //                           borderRadius: const BorderRadius.only(
// //                             topLeft: Radius.circular(16),
// //                             topRight: Radius.circular(16),
// //                           ),
// //                           child: Image.network(
// //                             user!.profileImage ?? 'https://via.placeholder.com/300',
// //                             height: 320,
// //                             width: double.infinity,
// //                             fit: BoxFit.cover,
// //                             errorBuilder: (_, __, ___) => Container(
// //                               height: 320,
// //                               color: Colors.grey[800],
// //                               child: const Icon(Icons.person, size: 100, color: Colors.white54),
// //                             ),
// //                           ),
// //                         ),
// //                         Padding(
// //                           padding: const EdgeInsets.all(16),
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               Text(
// //                                 user!.username ?? 'User',
// //                                 style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
// //                               ),
// //                               const SizedBox(height: 6),
// //                               Text(
// //                                 '${user!.age ?? ''} Years',
// //                                 style: const TextStyle(color: Colors.white70, fontSize: 15),
// //                               ),
// //                               Text(
// //                                 user!.gender ?? '',
// //                                 style: const TextStyle(color: Colors.white70, fontSize: 15),
// //                               ),
// //                               Text(
// //                                 user!.fullLocation ?? user!.location ?? '',
// //                                 style: const TextStyle(color: Colors.white70, fontSize: 14),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),

// //                   const SizedBox(height: 16),

// //                   // Sidebar Actions
// //                   Container(
// //                     decoration: BoxDecoration(
// //                       color: const Color(0xFF2D1B3D),
// //                       borderRadius: BorderRadius.circular(16),
// //                     ),
// //                     child: Column(
// //                       children: [
// //                         _buildSidebarItem('Already Friends', user!.alreadyFriends, Icons.people),
// //                         _buildSidebarItem('Dislike', user!.dislikes, Icons.thumb_down),
// //                         _buildSidebarItem('Validate', user!.validates, Icons.verified),
// //                         _buildSidebarItem('Remember', user!.remembers, Icons.bookmark),
// //                         _buildSidebarItem('Notes', user!.notes, Icons.note),
// //                         _buildSidebarItem('Block User', user!.blocks, Icons.block),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),

// //             const SizedBox(width: 20),

// //             // RIGHT COLUMN - Profile Questions
// //             Expanded(
// //               flex: 6,
// //               child: Container(
// //                 padding: const EdgeInsets.all(20),
// //                 decoration: BoxDecoration(
// //                   color: Colors.white,
// //                   borderRadius: BorderRadius.circular(16),
// //                   boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
// //                 ),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     const Text(
// //                       'Profile Information',
// //                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D1B3D)),
// //                     ),
// //                     const SizedBox(height: 20),
// //                     ...user!.profileAnswers.map((answer) => _buildProfileAnswer(answer)).toList(),
// //                     const SizedBox(height: 30),
// //                     // Message Box
// //                     const Text('Send Message', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
// //                     const SizedBox(height: 10),
// //                     TextField(
// //                       controller: _messageController,
// //                       maxLines: 3,
// //                       decoration: InputDecoration(
// //                         hintText: 'Write your message...',
// //                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 12),
// //                     SizedBox(
// //                       width: double.infinity,
// //                       child: ElevatedButton.icon(
// //                         onPressed: isSendingMessage ? null : _sendMessage,
// //                         icon: const Icon(Icons.send),
// //                         label: Text(isSendingMessage ? 'Sending...' : 'Send Message'),
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: const Color(0xFFE91E63),
// //                           padding: const EdgeInsets.symmetric(vertical: 14),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildSidebarItem(String title, int count, IconData icon) {
// //     return ListTile(
// //       leading: Icon(icon, color: Colors.white70),
// //       title: Text(title, style: const TextStyle(color: Colors.white)),
// //       trailing: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// //         decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
// //         child: Text(count.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
// //       ),
// //     );
// //   }

// //   Widget _buildProfileAnswer(ProfileAnswer answer) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 16),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // Question bubble
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //             decoration: BoxDecoration(
// //               color: const Color(0xFF2D1B3D),
// //               borderRadius: BorderRadius.circular(20),
// //             ),
// //             child: Text(
// //               answer.question,
// //               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
// //             ),
// //           ),
// //           const SizedBox(width: 12),
// //           // Answer bubble
// //           Expanded(
// //             child: Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
// //               decoration: BoxDecoration(
// //                 color: Colors.grey[200],
// //                 borderRadius: BorderRadius.circular(20),
// //               ),
// //               child: Text(
// //                 answer.answer,
// //                 style: const TextStyle(color: Colors.black87),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ============================================================
// // //                    HOW TO USE
// // // ============================================================
// // //
// // // 1. Copy this file
// // // 2. Add dependencies: http + shared_preferences
// // // 3. Navigate:
// // //    Navigator.push(context, MaterialPageRoute(builder: (_) => const LikesScreen()));
// // //
// // // ============================================================


// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// // ============================================================
// //     BEAT FLIRT - COMPLETE LIKES + DETAILED PROFILE + ACTIONS
// //     Single File - Full UI + API + Models + All Actions
// // ============================================================

// const String BASE_URL = 'https://beatflirtevent.com';

// // ============================================================
// //                           MODELS
// // ============================================================

// class LikeModel {
//   final int? id;
//   final String? username;
//   final String? profileImage;
//   final String? age;
//   final String? gender;
//   final String? location;
//   final String? distance;
//   final bool? isOnline;

//   LikeModel({
//     this.id,
//     this.username,
//     this.profileImage,
//     this.age,
//     this.gender,
//     this.location,
//     this.distance,
//     this.isOnline,
//   });

//   factory LikeModel.fromJson(Map<String, dynamic> json) {
//     return LikeModel(
//       id: json['id'],
//       username: json['username'] ?? json['name'],
//       profileImage: json['profile_image'] ?? json['image'],
//       age: json['age']?.toString(),
//       gender: json['gender'],
//       location: json['location'] ?? json['city'],
//       distance: json['distance']?.toString(),
//       isOnline: json['is_online'] ?? false,
//     );
//   }
// }

// class ProfileAnswer {
//   final String question;
//   final String answer;

//   ProfileAnswer({required this.question, required this.answer});
// }

// class DetailedUserProfileModel {
//   final int? id;
//   final String? username;
//   final String? profileImage;
//   final String? coverImage;
//   final String? age;
//   final String? gender;
//   final String? location;
//   final String? fullLocation;
//   final bool? isOnline;
//   final List<ProfileAnswer> profileAnswers;
//   int alreadyFriends;
//   int dislikes;
//   int validates;
//   int remembers;
//   int notes;
//   int blocks;

//   DetailedUserProfileModel({
//     this.id,
//     this.username,
//     this.profileImage,
//     this.coverImage,
//     this.age,
//     this.gender,
//     this.location,
//     this.fullLocation,
//     this.isOnline,
//     this.profileAnswers = const [],
//     this.alreadyFriends = 0,
//     this.dislikes = 0,
//     this.validates = 0,
//     this.remembers = 0,
//     this.notes = 0,
//     this.blocks = 0,
//   });

//   factory DetailedUserProfileModel.fromJson(Map<String, dynamic> json) {
//     List<ProfileAnswer> answers = [];
    
//     if (json['profile_answers'] != null) {
//       for (var item in json['profile_answers']) {
//         answers.add(ProfileAnswer(
//           question: item['question'] ?? '',
//           answer: item['answer'] ?? "I'm not comfortable sharing that",
//         ));
//       }
//     } else {
//       answers = [
//         ProfileAnswer(question: "Age", answer: "18 Years"),
//         ProfileAnswer(question: "Tattoos", answer: "I'm not comfortable sharing that"),
//         ProfileAnswer(question: "Body Hair", answer: "I'm not comfortable sharing that"),
//         ProfileAnswer(question: "Weight", answer: "I'm not comfortable sharing that"),
//         ProfileAnswer(question: "Height", answer: "I'm not comfortable sharing that"),
//         ProfileAnswer(question: "Smoking", answer: "I'm not comfortable sharing that"),
//         ProfileAnswer(question: "Drinking", answer: "I'm not comfortable sharing that"),
//         ProfileAnswer(question: "Body Type", answer: "I'm not comfortable sharing that"),
//         ProfileAnswer(question: "Language Spoken", answer: "I'm not comfortable sharing that"),
//         ProfileAnswer(question: "Ethnic Background", answer: "I'm not comfortable sharing that"),
//       ];
//     }

//     return DetailedUserProfileModel(
//       id: json['id'],
//       username: json['username'] ?? json['name'],
//       profileImage: json['profile_image'] ?? json['image'],
//       coverImage: json['cover_image'],
//       age: json['age']?.toString(),
//       gender: json['gender'],
//       location: json['location'] ?? json['city'],
//       fullLocation: json['full_location'] ?? json['address'],
//       isOnline: json['is_online'] ?? false,
//       profileAnswers: answers,
//       alreadyFriends: json['already_friends'] ?? 1,
//       dislikes: json['dislikes'] ?? 1,
//       validates: json['validates'] ?? 0,
//       remembers: json['remembers'] ?? 0,
//       notes: json['notes'] ?? 0,
//       blocks: json['blocks'] ?? 0,
//     );
//   }
// }

// // ============================================================
// //                           API SERVICE
// // ============================================================

// class BeatFlirtApi {
//   static String? _token;

//   static Map<String, String> get _headers => {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         if (_token != null) 'Authorization': 'Bearer $_token',
//       };

//   static Future<void> saveToken(String token) async {
//     _token = token;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('bf_auth_token', token);
//   }

//   static Future<void> loadToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     _token = prefs.getString('bf_auth_token');
//   }

//   static Future<void> clearToken() async {
//     _token = null;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('bf_auth_token');
//   }

//   static bool get isLoggedIn => _token != null;

//   // ==================== LIKES ====================
//   static Future<List<dynamic>> getLikes() async {
//     final response = await http.get(Uri.parse('$BASE_URL/likes'), headers: _headers);
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     }
//     return [];
//   }

//   // ==================== DETAILED PROFILE ====================
//   static Future<Map<String, dynamic>> getSingleUserProfile(int userId) async {
//     final response = await http.get(
//       Uri.parse('$BASE_URL/single-user-profile?user_id=$userId'),
//       headers: _headers,
//     );
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     }
//     throw Exception('Failed to load user profile');
//   }

//   static Future<Map<String, dynamic>> getViewSingleProfile(int userId) async {
//     final response = await http.get(
//       Uri.parse('$BASE_URL/view-single-profile?id=$userId'),
//       headers: _headers,
//     );
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     }
//     throw Exception('Failed to load user profile');
//   }

//   // ==================== ACTIONS ====================
//   static Future<bool> sendMessage(int userId, String message) async {
//     final response = await http.post(
//       Uri.parse('$BASE_URL/message'),
//       headers: _headers,
//       body: jsonEncode({'receiver_id': userId, 'message': message}),
//     );
//     return response.statusCode == 200 || response.statusCode == 201;
//   }

//   static Future<bool> addToFriends(int userId) async {
//     final response = await http.post(
//       Uri.parse('$BASE_URL/add-friend'),
//       headers: _headers,
//       body: jsonEncode({'user_id': userId}),
//     );
//     return response.statusCode == 200;
//   }

//   static Future<bool> dislikeUser(int userId) async {
//     final response = await http.post(
//       Uri.parse('$BASE_URL/dislike'),
//       headers: _headers,
//       body: jsonEncode({'user_id': userId}),
//     );
//     return response.statusCode == 200;
//   }

//   static Future<bool> validateUser(int userId) async {
//     final response = await http.post(
//       Uri.parse('$BASE_URL/validate'),
//       headers: _headers,
//       body: jsonEncode({'user_id': userId}),
//     );
//     return response.statusCode == 200;
//   }

//   static Future<bool> rememberUser(int userId) async {
//     final response = await http.post(
//       Uri.parse('$BASE_URL/remember'),
//       headers: _headers,
//       body: jsonEncode({'user_id': userId}),
//     );
//     return response.statusCode == 200;
//   }

//   static Future<bool> addNote(int userId, String note) async {
//     final response = await http.post(
//       Uri.parse('$BASE_URL/add-note'),
//       headers: _headers,
//       body: jsonEncode({'user_id': userId, 'note': note}),
//     );
//     return response.statusCode == 200;
//   }

//   static Future<bool> blockUser(int userId) async {
//     final response = await http.post(
//       Uri.parse('$BASE_URL/block-user'),
//       headers: _headers,
//       body: jsonEncode({'user_id': userId}),
//     );
//     return response.statusCode == 200;
//   }
// }

// // ============================================================
// //                    LIKES SCREEN
// // ============================================================

// class LikesPage extends StatefulWidget {
//   const LikesPage({super.key});

//   @override
//   State<LikesPage> createState() => _LikesPageState();
// }

// class _LikesPageState extends State<LikesPage> {
//   List<LikeModel> likes = [];
//   List<LikeModel> filteredLikes = [];
//   bool isLoading = true;

//   String selectedGender = 'All';
//   RangeValues ageRange = const RangeValues(18, 60);
//   bool showOnlineOnly = false;
//   String sortBy = 'Newest';

//   @override
//   void initState() {
//     super.initState();
//     _loadLikes();
//   }

//   Future<void> _loadLikes() async {
//     setState(() => isLoading = true);
//     try {
//       final data = await BeatFlirtApi.getLikes();
//       setState(() {
//         likes = data.map((e) => LikeModel.fromJson(e)).toList();
//         filteredLikes = List.from(likes);
//         isLoading = false;
//       });
//       _applyFilters();
//     } catch (e) {
//       setState(() => isLoading = false);
//     }
//   }

//   void _applyFilters() {
//     setState(() {
//       filteredLikes = likes.where((like) {
//         if (selectedGender != 'All' && like.gender != null) {
//           if (like.gender!.toLowerCase() != selectedGender.toLowerCase()) return false;
//         }
//         if (like.age != null) {
//           final age = int.tryParse(like.age!) ?? 0;
//           if (age < ageRange.start || age > ageRange.end) return false;
//         }
//         if (showOnlineOnly && (like.isOnline != true)) return false;
//         return true;
//       }).toList();

//       if (sortBy == 'Closest') {
//         filteredLikes.sort((a, b) {
//           final distA = double.tryParse(a.distance ?? '99999') ?? 99999;
//           final distB = double.tryParse(b.distance ?? '99999') ?? 99999;
//           return distA.compareTo(distB);
//         });
//       } else if (sortBy == 'Age') {
//         filteredLikes.sort((a, b) {
//           final ageA = int.tryParse(a.age ?? '0') ?? 0;
//           final ageB = int.tryParse(b.age ?? '0') ?? 0;
//           return ageA.compareTo(ageB);
//         });
//       }
//     });
//   }

//   void _showFilterBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: const Color(0xFF1E1E1E),
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       builder: (context) {
//         return StatefulBuilder(builder: (context, setModalState) {
//           return Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('Filters', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 20),
//                 const Text('Gender', style: TextStyle(fontWeight: FontWeight.w600)),
//                 Wrap(
//                   spacing: 8,
//                   children: ['All', 'Male', 'Female', 'Other'].map((gender) {
//                     return ChoiceChip(
//                       label: Text(gender),
//                       selected: selectedGender == gender,
//                       onSelected: (_) => setModalState(() => selectedGender = gender),
//                     );
//                   }).toList(),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text('Age Range', style: TextStyle(fontWeight: FontWeight.w600)),
//                 RangeSlider(
//                   values: ageRange,
//                   min: 18,
//                   max: 80,
//                   divisions: 62,
//                   labels: RangeLabels(ageRange.start.round().toString(), ageRange.end.round().toString()),
//                   onChanged: (values) => setModalState(() => ageRange = values),
//                 ),
//                 SwitchListTile(
//                   title: const Text('Online Only'),
//                   value: showOnlineOnly,
//                   onChanged: (val) => setModalState(() => showOnlineOnly = val),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text('Sort By', style: TextStyle(fontWeight: FontWeight.w600)),
//                 Wrap(
//                   spacing: 8,
//                   children: ['Newest', 'Closest', 'Age'].map((sort) {
//                     return ChoiceChip(
//                       label: Text(sort),
//                       selected: sortBy == sort,
//                       onSelected: (_) => setModalState(() => sortBy = sort),
//                     );
//                   }).toList(),
//                 ),
//                 const SizedBox(height: 30),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () {
//                           setState(() {
//                             selectedGender = 'All';
//                             ageRange = const RangeValues(18, 60);
//                             showOnlineOnly = false;
//                             sortBy = 'Newest';
//                           });
//                           _applyFilters();
//                           Navigator.pop(context);
//                         },
//                         child: const Text('Reset'),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           _applyFilters();
//                           Navigator.pop(context);
//                         },
//                         style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE91E63)),
//                         child: const Text('Apply'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         });
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Likes (${filteredLikes.length})'),
//         actions: [
//           IconButton(icon: const Icon(Icons.filter_list), onPressed: _showFilterBottomSheet),
//           IconButton(icon: const Icon(Icons.refresh), onPressed: _loadLikes),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFC107)))
//           : filteredLikes.isEmpty
//               ? _buildEmptyState()
//               : ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: filteredLikes.length,
//                   itemBuilder: (context, index) {
//                     final like = filteredLikes[index];
//                     return _buildLikeCard(like);
//                   },
//                 ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.favorite_border, size: 80, color: Colors.grey[700]),
//           const SizedBox(height: 20),
//           const Text('No Likes Yet', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }

//   Widget _buildLikeCard(LikeModel like) {
//     return GestureDetector(
//       onTap: () {
//         if (like.id != null) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => DetailedProfileScreen(userId: like.id!)),
//           );
//         }
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 20),
//         decoration: BoxDecoration(
//           color: const Color(0xFF1E1E1E),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
//         ),
//         child: Column(
//           children: [
//             Container(
//               margin: const EdgeInsets.only(top: 16),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: const Color(0xFFE91E63), width: 3),
//               ),
//               child: CircleAvatar(
//                 radius: 55,
//                 backgroundColor: Colors.grey[800],
//                 backgroundImage: like.profileImage != null ? NetworkImage(like.profileImage!) : null,
//                 child: like.profileImage == null ? const Icon(Icons.person, size: 55, color: Colors.white70) : null,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(like.username ?? 'Unknown', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//             if (like.age != null)
//               Container(
//                 margin: const EdgeInsets.only(top: 6),
//                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
//                 decoration: BoxDecoration(color: const Color(0xFFE91E63), borderRadius: BorderRadius.circular(20)),
//                 child: Text('Age ${like.age}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
//               ),
//             const SizedBox(height: 12),
//             if (like.gender != null) Text(like.gender!, style: const TextStyle(fontSize: 15, color: Colors.white70)),
//             if (like.location != null || like.distance != null)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8, left: 20, right: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.location_on, size: 16, color: Colors.white54),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       child: Text(
//                         '${like.location ?? ''} ${like.distance != null ? '• ${like.distance} km' : ''}',
//                         style: const TextStyle(color: Colors.white54, fontSize: 13),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             const SizedBox(height: 16),
//             const Icon(Icons.chat_bubble_outline, color: Color(0xFFE91E63), size: 28),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ============================================================
// //              DETAILED PROFILE SCREEN + ALL ACTIONS
// // ============================================================

// class DetailedProfileScreen extends StatefulWidget {
//   final int userId;
//   const DetailedProfileScreen({super.key, required this.userId});

//   @override
//   State<DetailedProfileScreen> createState() => _DetailedProfileScreenState();
// }

// class _DetailedProfileScreenState extends State<DetailedProfileScreen> {
//   DetailedUserProfileModel? user;
//   bool isLoading = true;
//   bool isSendingMessage = false;
//   final TextEditingController _messageController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _loadDetailedProfile();
//   }

//   Future<void> _loadDetailedProfile() async {
//     setState(() => isLoading = true);
//     try {
//       Map<String, dynamic> data;
//       try {
//         data = await BeatFlirtApi.getSingleUserProfile(widget.userId);
//       } catch (_) {
//         data = await BeatFlirtApi.getViewSingleProfile(widget.userId);
//       }
//       setState(() {
//         user = DetailedUserProfileModel.fromJson(data);
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() => isLoading = false);
//     }
//   }

//   // ==================== ACTION METHODS ====================

//   Future<void> _performAction(String action, Function() apiCall) async {
//     try {
//       final success = await apiCall();
//       if (success) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('$action successful!'), backgroundColor: Colors.green),
//           );
//         }
//         // Refresh counts if needed
//         _loadDetailedProfile();
//       } else {
//         throw Exception('Failed');
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('$action failed: $e')),
//         );
//       }
//     }
//   }

//   Future<void> _addNote() async {
//     final TextEditingController noteController = TextEditingController();
    
//     final result = await showDialog<String>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Add Note'),
//         content: TextField(
//           controller: noteController,
//           maxLines: 4,
//           decoration: const InputDecoration(
//             hintText: 'Write your note here...',
//             border: OutlineInputBorder(),
//           ),
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, noteController.text),
//             child: const Text('Save'),
//           ),
//         ],
//       ),
//     );

//     if (result != null && result.trim().isNotEmpty && user?.id != null) {
//       await _performAction('Note added', () => BeatFlirtApi.addNote(user!.id!, result.trim()));
//     }
//   }

//   Future<void> _sendMessage() async {
//     if (_messageController.text.trim().isEmpty || user?.id == null) return;
//     setState(() => isSendingMessage = true);
//     try {
//       await BeatFlirtApi.sendMessage(user!.id!, _messageController.text.trim());
//       _messageController.clear();
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Message sent!'), backgroundColor: Colors.green),
//         );
//       }
//     } catch (e) {
//       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
//     }
//     setState(() => isSendingMessage = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F5F5),
//       appBar: AppBar(
//         title: const Text('Profile'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator(color: Color(0xFFE91E63)))
//           : user == null
//               ? const Center(child: Text('Failed to load profile'))
//               : _buildDetailedProfile(),
//     );
//   }

//   Widget _buildDetailedProfile() {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // LEFT COLUMN
//             Expanded(
//               flex: 5,
//               child: Column(
//                 children: [
//                   // Profile Card
//                   Container(
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF2D1B3D),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Column(
//                       children: [
//                         ClipRRect(
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(16),
//                             topRight: Radius.circular(16),
//                           ),
//                           child: Image.network(
//                             user!.profileImage ?? 'https://via.placeholder.com/300',
//                             height: 320,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                             errorBuilder: (_, __, ___) => Container(
//                               height: 320,
//                               color: Colors.grey[800],
//                               child: const Icon(Icons.person, size: 100, color: Colors.white54),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(user!.username ?? 'User',
//                                   style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
//                               const SizedBox(height: 6),
//                               Text('${user!.age ?? ''} Years', style: const TextStyle(color: Colors.white70, fontSize: 15)),
//                               Text(user!.gender ?? '', style: const TextStyle(color: Colors.white70, fontSize: 15)),
//                               Text(user!.fullLocation ?? user!.location ?? '',
//                                   style: const TextStyle(color: Colors.white70, fontSize: 14)),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 16),

//                   // Sidebar with Actions
//                   Container(
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF2D1B3D),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Column(
//                       children: [
//                         _buildActionItem('Already Friends', user!.alreadyFriends, Icons.people, () {
//                           _performAction('Added to Friends', () => BeatFlirtApi.addToFriends(user!.id!));
//                         }),
//                         _buildActionItem('Dislike', user!.dislikes, Icons.thumb_down, () {
//                           _performAction('Disliked', () => BeatFlirtApi.dislikeUser(user!.id!));
//                         }),
//                         _buildActionItem('Validate', user!.validates, Icons.verified, () {
//                           _performAction('Validated', () => BeatFlirtApi.validateUser(user!.id!));
//                         }),
//                         _buildActionItem('Remember', user!.remembers, Icons.bookmark, () {
//                           _performAction('Remembered', () => BeatFlirtApi.rememberUser(user!.id!));
//                         }),
//                         _buildActionItem('Notes', user!.notes, Icons.note, _addNote),
//                         _buildActionItem('Block User', user!.blocks, Icons.block, () {
//                           _performAction('Blocked', () => BeatFlirtApi.blockUser(user!.id!));
//                         }),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(width: 20),

//             // RIGHT COLUMN - Profile Questions + Message
//             Expanded(
//               flex: 6,
//               child: Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text('Profile Information',
//                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D1B3D))),
//                     const SizedBox(height: 20),
//                     ...user!.profileAnswers.map((answer) => _buildProfileAnswer(answer)).toList(),
//                     const SizedBox(height: 30),
//                     const Text('Send Message', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                     const SizedBox(height: 10),
//                     TextField(
//                       controller: _messageController,
//                       maxLines: 3,
//                       decoration: InputDecoration(
//                         hintText: 'Write your message...',
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton.icon(
//                         onPressed: isSendingMessage ? null : _sendMessage,
//                         icon: const Icon(Icons.send),
//                         label: Text(isSendingMessage ? 'Sending...' : 'Send Message'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFFE91E63),
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActionItem(String title, int count, IconData icon, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       child: ListTile(
//         leading: Icon(icon, color: Colors.white70),
//         title: Text(title, style: const TextStyle(color: Colors.white)),
//         trailing: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//           decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
//           child: Text(count.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileAnswer(ProfileAnswer answer) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: const Color(0xFF2D1B3D),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(answer.question, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//               decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
//               child: Text(answer.answer, style: const TextStyle(color: Colors.black87)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ============================================================
// //                    HOW TO USE
// // ============================================================
// //
// // 1. Copy this file
// // 2. Add dependencies: http + shared_preferences
// // 3. Navigate:
// //    Navigator.push(context, MaterialPageRoute(builder: (_) => const LikesScreen()));
// //
// // All sidebar actions are now fully functional!
// // ============================================================


// Beat Flirt /likes screen converted from https://beatflirtevent.com/likes
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

// import 'beat_single_user_profile_screen.dart';

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

class BeatLikesApiException implements Exception {
  BeatLikesApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class BeatLikesApi {
  BeatLikesApi({
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
      throw BeatLikesApiException('HTTP ${response.statusCode}: ${response.reasonPhrase ?? 'Request failed'}');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) return decoded;
    throw BeatLikesApiException('Unexpected API response');
  }

  /// Website API: POST /feed/get_all_like_request
  Future<List<LikeUser>> getLikes(LikesFilter filter) async {
    final json = await _post('/feed/get_all_like_request', filter.toJson());
    if (_okStatus(json['status'])) {
      final data = json['data'];
      if (data is List) return data.map((e) => LikeUser.fromJson(Map<String, dynamic>.from(e))).toList();
      return <LikeUser>[];
    }

    final message = _string(json['message']);
    if (message.toLowerCase().contains('token')) {
      throw BeatLikesApiException(message);
    }
    return <LikeUser>[];
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
      throw BeatLikesApiException(_string(json['message'], 'Unable to create chat room'));
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

class LikesFilter {
  const LikesFilter({
    this.type = 'me',
    this.searchKeyword = '',
    this.locationText = '',
    this.lat = '0',
    this.lng = '0',
    this.city = '0',
    this.profileTypeArray = const <String>[],
  });

  final String type; // me = Who did I like?, other = Who likes me
  final String searchKeyword;
  final String locationText;
  final String lat;
  final String lng;
  final String city;
  final List<String> profileTypeArray; // Couple, Female, Male, Transgender

  LikesFilter copyWith({
    String? type,
    String? searchKeyword,
    String? locationText,
    String? lat,
    String? lng,
    String? city,
    List<String>? profileTypeArray,
  }) {
    return LikesFilter(
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

class LikeUserImage {
  LikeUserImage({required this.profileImage});
  final String profileImage;

  factory LikeUserImage.fromJson(Map<String, dynamic> json) => LikeUserImage(
        profileImage: _string(json['profile_image']),
      );
}

class LikeUserVideo {
  LikeUserVideo({required this.video});
  final String video;

  factory LikeUserVideo.fromJson(Map<String, dynamic> json) => LikeUserVideo(
        video: _string(json['video']),
      );
}

class LikeUser {
  LikeUser({
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
  final List<LikeUserImage> images;
  final List<LikeUserVideo> videos;

  factory LikeUser.fromJson(Map<String, dynamic> json) {
    final imageList = json['image'] is List ? json['image'] as List : const [];
    final videoList = json['video'] is List ? json['video'] as List : const [];
    return LikeUser(
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
          .map((e) => LikeUserImage.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      videos: videoList
          .whereType<Map>()
          .map((e) => LikeUserVideo.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  String get primaryImage => images.isNotEmpty ? images.first.profileImage : '';

  bool flag(String key) => raw[key]?.toString() == '1';
}

class LikesPage extends StatefulWidget {
  const LikesPage({
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
  final BeatLikesApi? api;
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

  final void Function(BuildContext context, LikeUser user)? onOpenProfile;
  final void Function(BuildContext context, LikeUser user)? onOpenMessenger;
  final VoidCallback? onOpenMembership;
  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  BeatLikesApi? _api;
  LikesFilter _filter = const LikesFilter();
  List<LikeUser> _friends = <LikeUser>[];
  bool _booting = true;
  bool _loading = false;
  String? _error;
  String _loginUserId = '';
  String _membershipValue = '';

  final _filterSearchController = TextEditingController();
  final _filterLocationController = TextEditingController();

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

  @override
  void dispose() {
    _filterSearchController.dispose();
    _filterLocationController.dispose();
    super.dispose();
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
      _api = widget.api ?? BeatLikesApi(accessToken: token, accessSign: sign);

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
      final data = await api.getLikes(_filter);
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

  Future<void> _chat(LikeUser user) async {
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

  void _openProfile(LikeUser user) {
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

    final result = await showModalBottomSheet<LikesFilter>(
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

            Widget radio(String label, String value) {
              return InkWell(
                onTap: () {
                  setModalState(() {
                    draft = draft.copyWith(type: value);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: value,
                        groupValue: draft.type,
                        activeColor: Colors.white,
                        fillColor: MaterialStateProperty.all(Colors.white),
                        onChanged: (v) {
                          setModalState(() {
                            draft = draft.copyWith(type: v);
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

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
                        radio('Who did I like?', 'me'),
                        radio('Who likes me', 'other'),
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
    }   }

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
        // title: _header(),
        title: RichText(
            text: TextSpan(
              text: 'Likes ',
              style: const TextStyle(color: _primary, fontSize: 22, fontWeight: FontWeight.w600),
              children: [
                if (_friends.isNotEmpty)
                  TextSpan(text: '(${_friends.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        centerTitle: true,
        backgroundColor: _lightBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _primary,size:20),
          onPressed: () => Navigator.pop(context),
        ),
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
      mainAxisAlignment : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Flexible(
        //   child: RichText(
        //     text: TextSpan(
        //       text: 'Likes ',
        //       style: const TextStyle(color: _primary, fontSize: 26, fontWeight: FontWeight.w600),
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

  Widget _friendCard(LikeUser user) {
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

  Widget _genderIcons(LikeUser user) {
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

  Widget _locationLine(LikeUser user) {
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

  Widget _actionBar(LikeUser user, int imageCount, int videoCount) {
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
          width: 22,
          height: 22,
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

  void _showImages(LikeUser user) {
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

  void _showVideos(LikeUser user) {
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
            "It looks like no one has liked your profile yet. Try updating your profile or joining some events!",
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
