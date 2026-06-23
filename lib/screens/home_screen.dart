// import 'package:flutter/material.dart';
//
// import '../Api_services/api_services.dart';
// import '../content/app_drawer.dart';
// import '../content/card_data.dart';
// import '../core/services/auth_services.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final ApiServices _apiServices = ApiServices();
//   List<CardData> _cards = appCardsData;
//   bool _isRefreshing = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCards();
//   }
//
//   Future<void> _loadCards() async {
//     if (!_isRefreshing && mounted) {
//       setState(() {
//         _isRefreshing = true;
//       });
//     }
//     try {
//       final token = await AuthService.getToken();
//       final apiCards = await _apiServices.fetchCards(token: token);
//       if (!mounted) return;
//       setState(() {
//         _cards = apiCards.isEmpty ? appCardsData : apiCards;
//         _isRefreshing = false;
//       });
//     } catch (_) {
//       if (!mounted) return;
//       setState(() {
//         _cards = appCardsData;
//         _isRefreshing = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Text(
//           "Beat Flirt",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 26,
//             shadows: [
//               const Shadow(
//                 blurRadius: 8,
//                 color: Colors.pink,
//                 offset: Offset(0, 0),
//               ),
//               const Shadow(
//                 blurRadius: 16,
//                 color: Colors.pink,
//                 offset: Offset(0, 0),
//               ),
//               Shadow(
//                 blurRadius: 24,
//                 color: Colors.pink.withValues(alpha: 0.7),
//                 offset: const Offset(0, 0),
//               ),
//               Shadow(
//                 blurRadius: 32,
//                 color: Colors.pink.withValues(alpha: 0.8),
//                 offset: const Offset(0, 0),
//               ),
//             ],
//           ),
//         ),
//       ),
//       drawer: const AppDrawer(),
//       backgroundColor: Colors.pink.withValues(alpha: 0.5),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             RefreshIndicator(
//               onRefresh: _loadCards,
//               child: ListView.builder(
//                 padding: const EdgeInsets.all(24),
//                 itemCount: _cards.length,
//                 itemBuilder: (context, index) {
//                   return CustomCard(
//                     cardData: _cards[index],
//                     cardIndex: index,
//                   );
//                 },
//               ),
//             ),
//             if (_isRefreshing)
//               const Positioned(
//                 top: 12,
//                 left: 0,
//                 right: 0,
//                 child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// lib/screens/home_screen.dart

// import 'package:beatflirt/model/notification_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart'; // add to pubspec: flutter_html: ^3.0.0-beta.2
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';                 // add to pubspec: intl: ^0.19.0

// import '../Api_services/api_service(new).dart';
// import '../content/app_drawer.dart';
// import '../core/services/auth_services.dart';

// // ══════════════════════════════════════════════════════════════
// // STATE
// // ══════════════════════════════════════════════════════════════
// class HomePageState {
//   final List<NotificationModel> notifications;
//   final bool isLoading;
//   final bool isRefreshing;
//   final String? errorMessage;

//   const HomePageState({
//     this.notifications  = const [],
//     this.isLoading      = false,
//     this.isRefreshing   = false,
//     this.errorMessage,
//   });

//   HomePageState copyWith({
//     List<NotificationModel>? notifications,
//     bool?                    isLoading,
//     bool?                    isRefreshing,
//     String?                  errorMessage,
//   }) {
//     return HomePageState(
//       notifications: notifications ?? this.notifications,
//       isLoading:     isLoading     ?? this.isLoading,
//       isRefreshing:  isRefreshing  ?? this.isRefreshing,
//       errorMessage:  errorMessage,
//     );
//   }
// }

// // ══════════════════════════════════════════════════════════════
// // NOTIFIER
// // ══════════════════════════════════════════════════════════════
// class HomePageNotifier extends Notifier<HomePageState> {
//   final ApiService _api = ApiService();

//   @override
//   HomePageState build() => const HomePageState();

//   // ── Fetch notifications from API ──────────────────────────
//   // GET https://beatflirtevent.com/api/App/events/get_all_notification
//   // Header: Authorization: Bearer <token>
//   Future<void> loadNotifications() async {
//     state = state.copyWith(isLoading: true, errorMessage: null);

//     try {
//       final token         = await AuthService.getToken();
//       final notifications = await _api.getAllNotifications(token: token);

//       state = state.copyWith(
//         notifications: notifications,
//         isLoading:     false,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isLoading:    false,
//         errorMessage: e.toString().replaceFirst('Exception: ', ''),
//       );
//     }
//   }

//   // ── Pull-to-refresh ───────────────────────────────────────
//   Future<void> refreshNotifications() async {
//     state = state.copyWith(isRefreshing: true, errorMessage: null);

//     try {
//       final token         = await AuthService.getToken();
//       final notifications = await _api.getAllNotifications(token: token);

//       state = state.copyWith(
//         notifications: notifications,
//         isRefreshing:  false,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isRefreshing:  false,
//         errorMessage:  e.toString().replaceFirst('Exception: ', ''),
//       );
//     }
//   }
// }

// // ══════════════════════════════════════════════════════════════
// // PROVIDER
// // ══════════════════════════════════════════════════════════════
// final homePageProvider =
//     NotifierProvider<HomePageNotifier, HomePageState>(HomePageNotifier.new);

// // ══════════════════════════════════════════════════════════════
// // WIDGET — HOME PAGE
// // ══════════════════════════════════════════════════════════════
// class HomePage extends ConsumerStatefulWidget {
//   const HomePage({super.key});

//   @override
//   ConsumerState<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends ConsumerState<HomePage> {
//   @override
//   void initState() {
//     super.initState();
//     // Load notifications when page opens
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(homePageProvider.notifier).loadNotifications();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state    = ref.watch(homePageProvider);
//     final notifier = ref.read(homePageProvider.notifier);

//     return Scaffold(
//       // ── AppBar ─────────────────────────────────────────
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.black),
//         title: Text(
//           "Beat Flirt",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 26,
//             shadows: [
//               const Shadow(blurRadius: 8,  color: Colors.pink, offset: Offset(0, 0)),
//               const Shadow(blurRadius: 16, color: Colors.pink, offset: Offset(0, 0)),
//               Shadow(blurRadius: 24, color: Colors.pink.withValues(alpha: 0.7), offset: const Offset(0, 0)),
//               Shadow(blurRadius: 32, color: Colors.pink.withValues(alpha: 0.8), offset: const Offset(0, 0)),
//               Shadow(blurRadius: 40, color: Colors.pink.withValues(alpha: 0.8), offset: const Offset(0, 0)),
//               Shadow(blurRadius: 48, color: Colors.pink.withValues(alpha: 0.8), offset: const Offset(0, 0)),
//             ],
//           ),
//         ),
//       ),

//       drawer: const AppDrawer(),
//       backgroundColor: Colors.pink.shade900,

//       // ── Body ───────────────────────────────────────────
//       body: SafeArea(
//         child: Stack(
//           children: [

//             // ── Loading state (first load) ────────────────
//             if (state.isLoading && state.notifications.isEmpty)
//               const Center(
//                 child: CircularProgressIndicator(color: Colors.white),
//               )

//             // ── Error state ───────────────────────────────
//             else if (state.errorMessage != null && state.notifications.isEmpty)
//               Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(24),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(
//                         Icons.wifi_off_rounded,
//                         color: Colors.white54,
//                         size: 56,
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         state.errorMessage!,
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 14,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       ElevatedButton.icon(
//                         onPressed: notifier.loadNotifications,
//                         icon: const Icon(Icons.refresh),
//                         label: const Text("Retry"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           foregroundColor: Colors.pink.shade900,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )

//             // ── Empty state ───────────────────────────────
//             else if (state.notifications.isEmpty)
//               const Center(
//                 child: Text(
//                   "No notifications yet.",
//                   style: TextStyle(color: Colors.white70, fontSize: 16),
//                 ),
//               )

//             // ── Notification list ─────────────────────────
//             else
//               RefreshIndicator(
//                 onRefresh: notifier.refreshNotifications,
//                 color: Colors.pink.shade900,
//                 child: ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: state.notifications.length,
//                   itemBuilder: (context, index) {
//                     return _NotificationCard(
//                       notification: state.notifications[index],
//                     );
//                   },
//                 ),
//               ),

//             // ── Pull-to-refresh spinner overlay ───────────
//             if (state.isRefreshing)
//               const Positioned(
//                 top: 12,
//                 left: 0,
//                 right: 0,
//                 child: Center(
//                   child: SizedBox(
//                     width: 24,
//                     height: 24,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ══════════════════════════════════════════════════════════════
// // NOTIFICATION CARD WIDGET
// // Displays each notification from the API
// // ══════════════════════════════════════════════════════════════
// class _NotificationCard extends StatelessWidget {
//   final NotificationModel notification;

//   const _NotificationCard({required this.notification});

//   // Format "2026-05-28" → "28 May 2026"
//   String _formatDate(String raw) {
//     try {
//       final date = DateTime.parse(raw);
//       return DateFormat('dd MMM yyyy').format(date);
//     } catch (_) {
//       return raw;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 4,
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [

//           // ── Event Image ─────────────────────────────────
//           if (notification.image.isNotEmpty)
//             AspectRatio(
//               aspectRatio: 16 / 9,
//               child: Image.network(
//                 notification.image,
//                 fit: BoxFit.cover,
//                 loadingBuilder: (context, child, progress) {
//                   if (progress == null) return child;
//                   return Container(
//                     color: Colors.pink.shade50,
//                     child: const Center(
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     ),
//                   );
//                 },
//                 errorBuilder: (_, __, ___) => Container(
//                   color: Colors.pink.shade100,
//                   height: 180,
//                   child: const Center(
//                     child: Icon(
//                       Icons.image_not_supported_outlined,
//                       color: Colors.pink,
//                       size: 40,
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//           // ── Card Content ────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [

//                 // ── Title ──────────────────────────────────
//                 Text(
//                   notification.title,
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.pink.shade900,
//                   ),
//                 ),

//                 const SizedBox(height: 8),

//                 // ── Date + Time row ────────────────────────
//                 Row(
//                   children: [
//                     Icon(Icons.calendar_today_outlined,
//                         size: 14, color: Colors.grey.shade500),
//                     const SizedBox(width: 4),
//                     Text(
//                       _formatDate(notification.created),
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey.shade500,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Icon(Icons.access_time_outlined,
//                         size: 14, color: Colors.grey.shade500),
//                     const SizedBox(width: 4),
//                     Text(
//                       notification.notificationTime,
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey.shade500,
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 6),

//                 // ── Send time badge ────────────────────────
//                 if (notification.sendMsgTime.isNotEmpty)
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 10, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.pink.shade50,
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: Colors.pink.shade100),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(Icons.schedule,
//                             size: 12, color: Colors.pink.shade400),
//                         const SizedBox(width: 4),
//                         Text(
//                           notification.sendMsgTime,
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: Colors.pink.shade400,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                 const SizedBox(height: 10),

//                 // ── Description (HTML rendered) ────────────
//                 if (notification.description.isNotEmpty)
//                   Html(
//                     data: notification.description,
//                     style: {
//                       "p": Style(
//                         fontSize: FontSize(13),
//                         color: Colors.grey.shade700,
//                         margin: Margins.zero,
//                         padding: HtmlPaddings.zero,
//                       ),
//                       "br": Style(lineHeight: LineHeight.number(1.4)),
//                     },
//                   ),

//                 // ── Event details (if available) ───────────
//                 if (notification.eventName.isNotEmpty) ...[
//                   const Divider(height: 20),
//                   Row(
//                     children: [
//                       Icon(Icons.event, size: 16, color: Colors.pink.shade300),
//                       const SizedBox(width: 6),
//                       Expanded(
//                         child: Text(
//                           notification.eventName,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: Colors.pink.shade700,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:beatflirt/model/notification_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';

// import '../Api_services/api_service(new).dart';
// import '../content/app_drawer.dart';
// import '../core/services/auth_services.dart';

// // ══════════════════════════════════════════════════════════════
// // STATE
// // ══════════════════════════════════════════════════════════════
// class HomePageState {
//   final List<NotificationModel> notifications;
//   final bool isLoading;
//   final bool isRefreshing;
//   final String? errorMessage;

//   const HomePageState({
//     this.notifications = const [],
//     this.isLoading = false,
//     this.isRefreshing = false,
//     this.errorMessage,
//   });

//   HomePageState copyWith({
//     List<NotificationModel>? notifications,
//     bool? isLoading,
//     bool? isRefreshing,
//     String? errorMessage,
//   }) {
//     return HomePageState(
//       notifications: notifications ?? this.notifications,
//       isLoading: isLoading ?? this.isLoading,
//       isRefreshing: isRefreshing ?? this.isRefreshing,
//       errorMessage: errorMessage,
//     );
//   }
// }

// // ══════════════════════════════════════════════════════════════
// // NOTIFIER
// // ══════════════════════════════════════════════════════════════
// class HomePageNotifier extends Notifier<HomePageState> {
//   final ApiService _api = ApiService();

//   @override
//   HomePageState build() => const HomePageState();

//   Future<void> loadNotifications() async {
//     state = state.copyWith(isLoading: true, errorMessage: null);

//     try {
//       final token = await AuthService.getToken();

//       if (token == null || token.trim().isEmpty) {
//         state = state.copyWith(
//           isLoading: false,
//           errorMessage: 'TOKEN_MISSING',
//         );
//         return;
//       }

//       final notifications = await _api.getAllNotifications(token: token);
//       state = state.copyWith(
//         notifications: notifications,
//         isLoading: false,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         errorMessage: e.toString().replaceFirst('Exception: ', ''),
//       );
//     }
//   }

//   Future<void> refreshNotifications() async {
//     state = state.copyWith(isRefreshing: true, errorMessage: null);

//     try {
//       final token = await AuthService.getToken();

//       if (token == null || token.trim().isEmpty) {
//         state = state.copyWith(
//           isRefreshing: false,
//           errorMessage: 'TOKEN_MISSING',
//         );
//         return;
//       }

//       final notifications = await _api.getAllNotifications(token: token);
//       state = state.copyWith(
//         notifications: notifications,
//         isRefreshing: false,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isRefreshing: false,
//         errorMessage: e.toString().replaceFirst('Exception: ', ''),
//       );
//     }
//   }
// }

// // ══════════════════════════════════════════════════════════════
// // PROVIDER
// // ══════════════════════════════════════════════════════════════
// final homePageProvider =
//     NotifierProvider<HomePageNotifier, HomePageState>(HomePageNotifier.new);

// // ══════════════════════════════════════════════════════════════
// // WIDGET — HOME PAGE
// // ══════════════════════════════════════════════════════════════
// class HomePage extends ConsumerStatefulWidget {
//   const HomePage({super.key});

//   @override
//   ConsumerState<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends ConsumerState<HomePage> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(homePageProvider.notifier).loadNotifications();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(homePageProvider);
//     final notifier = ref.read(homePageProvider.notifier);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.black),
//         title: Text(
//           "Beat Flirt",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 26,
//             shadows: [
//               const Shadow(blurRadius: 8, color: Colors.pink, offset: Offset(0, 0)),
//               const Shadow(blurRadius: 16, color: Colors.pink, offset: Offset(0, 0)),
//               Shadow(blurRadius: 24, color: Colors.pink.withValues(alpha: 0.7), offset: const Offset(0, 0)),
//               Shadow(blurRadius: 32, color: Colors.pink.withValues(alpha: 0.8), offset: const Offset(0, 0)),
//               Shadow(blurRadius: 40, color: Colors.pink.withValues(alpha: 0.8), offset: const Offset(0, 0)),
//               Shadow(blurRadius: 48, color: Colors.pink.withValues(alpha: 0.8), offset: const Offset(0, 0)),
//             ],
//           ),
//         ),
//       ),
//       drawer: const AppDrawer(),
//       backgroundColor: Colors.pink.shade900,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             // ── Loading state (first load) ────────────────
//             if (state.isLoading && state.notifications.isEmpty)
//               const Center(
//                 child: CircularProgressIndicator(color: Colors.white),
//               )

//             // ── Error / Token-missing state ─────────────
//             else if (state.errorMessage != null && state.notifications.isEmpty)
//               Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(24),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         state.errorMessage == 'TOKEN_MISSING'
//                             ? Icons.lock_outline
//                             : Icons.wifi_off_rounded,
//                         color: Colors.white54,
//                         size: 56,
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         state.errorMessage == 'TOKEN_MISSING'
//                             ? 'You need to log in to view notifications.'
//                             : state.errorMessage!,
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 14,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       ElevatedButton.icon(
//                         onPressed: () {
//                           if (state.errorMessage == 'TOKEN_MISSING') {
//                             // TODO: navigate to your Login screen
//                             // Navigator.pushNamed(context, '/login');
//                           } else {
//                             notifier.loadNotifications();
//                           }
//                         },
//                         icon: Icon(
//                           state.errorMessage == 'TOKEN_MISSING'
//                               ? Icons.login
//                               : Icons.refresh,
//                         ),
//                         label: Text(
//                           state.errorMessage == 'TOKEN_MISSING'
//                               ? 'Go to Login'
//                               : 'Retry',
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           foregroundColor: Colors.pink.shade900,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )

//             // ── Empty state ───────────────────────────────
//             else if (state.notifications.isEmpty)
//               const Center(
//                 child: Text(
//                   "No notifications yet.",
//                   style: TextStyle(color: Colors.white70, fontSize: 16),
//                 ),
//               )

//             // ── Notification list ─────────────────────────
//             else
//               RefreshIndicator(
//                 onRefresh: notifier.refreshNotifications,
//                 color: Colors.pink.shade900,
//                 child: ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: state.notifications.length,
//                   itemBuilder: (context, index) {
//                     return _NotificationCard(
//                       notification: state.notifications[index],
//                     );
//                   },
//                 ),
//               ),

//             // ── Pull-to-refresh spinner overlay ───────────
//             if (state.isRefreshing)
//               const Positioned(
//                 top: 12,
//                 left: 0,
//                 right: 0,
//                 child: Center(
//                   child: SizedBox(
//                     width: 24,
//                     height: 24,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ══════════════════════════════════════════════════════════════
// // NOTIFICATION CARD
// // ══════════════════════════════════════════════════════════════
// class _NotificationCard extends StatelessWidget {
//   final NotificationModel notification;

//   const _NotificationCard({required this.notification});

//   String _formatDate(String raw) {
//     try {
//       final date = DateTime.parse(raw);
//       return DateFormat('dd MMM yyyy').format(date);
//     } catch (_) {
//       return raw;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 4,
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── Event Image ─────────────────────────────────
//           if (notification.image.isNotEmpty)
//             AspectRatio(
//               aspectRatio: 16 / 9,
//               child: Image.network(
//                 notification.image,
//                 fit: BoxFit.cover,
//                 loadingBuilder: (context, child, progress) {
//                   if (progress == null) return child;
//                   return Container(
//                     color: Colors.pink.shade50,
//                     child: const Center(
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     ),
//                   );
//                 },
//                 errorBuilder: (_, __, ___) => Container(
//                   color: Colors.pink.shade100,
//                   height: 180,
//                   child: const Center(
//                     child: Icon(
//                       Icons.image_not_supported_outlined,
//                       color: Colors.pink,
//                       size: 40,
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//           // ── Card Content ────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ── Title ──────────────────────────────────
//                 Text(
//                   notification.title,
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.pink.shade900,
//                   ),
//                 ),

//                 const SizedBox(height: 8),

//                 // ── Date + Time row ────────────────────────
//                 Row(
//                   children: [
//                     Icon(Icons.calendar_today_outlined,
//                         size: 14, color: Colors.grey.shade500),
//                     const SizedBox(width: 4),
//                     Text(
//                       _formatDate(notification.created),
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey.shade500,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Icon(Icons.access_time_outlined,
//                         size: 14, color: Colors.grey.shade500),
//                     const SizedBox(width: 4),
//                     Text(
//                       notification.notificationTime,
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey.shade500,
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 6),

//                 // ── Send time badge ────────────────────────
//                 if (notification.sendMsgTime.isNotEmpty)
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 10, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.pink.shade50,
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: Colors.pink.shade100),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(Icons.schedule,
//                             size: 12, color: Colors.pink.shade400),
//                         const SizedBox(width: 4),
//                         Text(
//                           notification.sendMsgTime,
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: Colors.pink.shade400,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                 const SizedBox(height: 10),

//                 // ── Description (HTML rendered) ────────────
//                 if (notification.description.isNotEmpty)
//                   Html(
//                     data: notification.description,
//                     style: {
//                       "p": Style(
//                         fontSize: FontSize(13),
//                         color: Colors.grey.shade700,
//                         margin: Margins.zero,
//                         padding: HtmlPaddings.zero,
//                       ),
//                       "br": Style(lineHeight: LineHeight.number(1.4)),
//                     },
//                   ),

//                 // ── Event details (if available) ───────────
//                 if (notification.eventName.isNotEmpty) ...[
//                   const Divider(height: 20),
//                   Row(
//                     children: [
//                       Icon(Icons.event, size: 16, color: Colors.pink.shade300),
//                       const SizedBox(width: 6),
//                       Expanded(
//                         child: Text(
//                           notification.eventName,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: Colors.pink.shade700,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:beatflirt/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
// import '../Api_services/api_service(new).dart';
import '../Api_services/api_service.dart';
import '../content/app_drawer.dart';
import '../core/services/auth_services.dart';
import 'drawer_pages/validation_request_page.dart';
import 'drawer_pages/friend_request_page.dart';
import 'drawer_pages/likes_page.dart';
import 'drawer_pages/viewed_me_page.dart';
import '../providers/notification_provider.dart';
import 'search_screen.dart';

// ══════════════════════════════════════════════════════════════
// STATE
// ══════════════════════════════════════════════════════════════
class HomePageState {
  final List<NotificationModel> notifications;
  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;

  const HomePageState({
    this.notifications = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
  });

  HomePageState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
  }) {
    return HomePageState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage,
    );
  }
}

// ══════════════════════════════════════════════════════════════
// NOTIFIER
// ══════════════════════════════════════════════════════════════
class HomePageNotifier extends Notifier<HomePageState> {
  final ApiService _api = ApiService();

  @override
  HomePageState build() => const HomePageState();

  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final token = await AuthService.getToken();
      if (token == null || token.trim().isEmpty) {
        state = state.copyWith(isLoading: false, errorMessage: 'TOKEN_MISSING');
        return;
      }
      final notifications = await _api.getAllNotifications(token: token);
      state = state.copyWith(notifications: notifications, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> refreshNotifications() async {
    state = state.copyWith(isRefreshing: true, errorMessage: null);
    try {
      final token = await AuthService.getToken();
      if (token == null || token.trim().isEmpty) {
        state = state.copyWith(
          isRefreshing: false,
          errorMessage: 'TOKEN_MISSING',
        );
        return;
      }
      final notifications = await _api.getAllNotifications(token: token);
      state = state.copyWith(notifications: notifications, isRefreshing: false);
    } catch (e) {
      state = state.copyWith(
        isRefreshing: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}

// ══════════════════════════════════════════════════════════════
// PROVIDER
// ══════════════════════════════════════════════════════════════
final homePageProvider = NotifierProvider<HomePageNotifier, HomePageState>(
  HomePageNotifier.new,
);

// ══════════════════════════════════════════════════════════════
// WIDGET — HOME PAGE
// ══════════════════════════════════════════════════════════════
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homePageProvider.notifier).loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homePageProvider);
    final notifier = ref.read(homePageProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "BeatFlirt Notifications",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            // shadows: [
            //   const Shadow(blurRadius: 8, color: Colors.pink, offset: Offset(0, 0)),
            //   const Shadow(blurRadius: 16, color: Colors.pink, offset: Offset(0, 0)),
            //   Shadow(blurRadius: 24, color: Colors.pink.withValues(alpha: 0.7), offset: const Offset(0, 0)),
            //   Shadow(blurRadius: 32, color: Colors.pink.withValues(alpha: 0.8), offset: const Offset(0, 0)),
            //   Shadow(blurRadius: 40, color: Colors.pink.withValues(alpha: 0.8), offset: const Offset(0, 0)),
            //   Shadow(blurRadius: 48, color: Colors.pink.withValues(alpha: 0.8), offset: const Offset(0, 0)),
            // ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: const Icon(
                Icons.notifications_active,
                color: Colors.amber,
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      endDrawer: const NotificationEndDrawer(),
      // backgroundColor: Colors.pink.shade900,
      backgroundColor: Color(0xFF530827),
      body: SafeArea(
        child: Stack(
          children: [
            // ── Loading state (first load) ────────────────
            if (state.isLoading && state.notifications.isEmpty)
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            // ── Error / Token-missing state ─────────────
            else if (state.errorMessage != null && state.notifications.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        state.errorMessage == 'TOKEN_MISSING'
                            ? Icons.lock_outline
                            : Icons.wifi_off_rounded,
                        color: Colors.white54,
                        size: 56,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.errorMessage == 'TOKEN_MISSING'
                            ? 'You need to log in to view notifications.'
                            // : state.errorMessage!,
                            : 'Check Your Internet Connection',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (state.errorMessage == 'TOKEN_MISSING') {
                            // TODO: navigate to your Login screen
                            // Navigator.pushNamed(context, '/login');
                          } else {
                            notifier.loadNotifications();
                          }
                        },
                        icon: Icon(
                          state.errorMessage == 'TOKEN_MISSING'
                              ? Icons.login
                              : Icons.refresh,
                        ),
                        label: Text(
                          state.errorMessage == 'TOKEN_MISSING'
                              ? 'Go to Login'
                              : 'Retry',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.pink.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            // ── Empty state ───────────────────────────────
            else if (state.notifications.isEmpty)
              const Center(
                child: Text(
                  "No notifications yet.",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              )
            // ── Notification list ─────────────────────────
            else
              RefreshIndicator(
                onRefresh: notifier.refreshNotifications,
                color: Colors.pink.shade900,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.notifications.length,
                  itemBuilder: (context, index) {
                    return _NotificationCard(
                      notification: state.notifications[index],
                    );
                  },
                ),
              ),

            // ── Pull-to-refresh spinner overlay ───────────
            if (state.isRefreshing)
              const Positioned(
                top: 12,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// NOTIFICATION CARD
// ══════════════════════════════════════════════════════════════
class _NotificationCard extends StatefulWidget {
  final NotificationModel notification;
  const _NotificationCard({required this.notification});

  @override
  State<_NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<_NotificationCard> {
  bool _isExpanded = false;

  /// Strips HTML tags from a string for plain-text preview.
  String _stripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  String _formatDate(String raw) {
    try {
      final date = DateTime.parse(raw);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notification = this.widget.notification;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Event Image ─────────────────────────────────
          if (notification.image.isNotEmpty)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                notification.image,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: Colors.pink.shade50,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.pink.shade100,
                  height: 180,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.pink,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),

          // ── Card Content ────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Title ──────────────────────────────────
                Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.pink.shade900,
                  ),
                ),
                const SizedBox(height: 8),

                // ── Date + Time row ────────────────────────
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(notification.created),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.access_time_outlined,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      notification.notificationTime,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // ── Send time badge ────────────────────────
                if (notification.sendMsgTime.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.pink.shade100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 12,
                          color: Colors.pink.shade400,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          notification.sendMsgTime,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.pink.shade400,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 10),

                // ── Description — collapsed / expanded ────
                if (notification.description.isNotEmpty) ...[
                  // Collapsed: plain-text preview, 3 lines max
                  if (!_isExpanded)
                    Text(
                      _stripHtml(notification.description),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),

                  // Expanded: full HTML rendering
                  if (_isExpanded)
                    Html(
                      data: notification.description,
                      style: {
                        "p": Style(
                          fontSize: FontSize(13),
                          color: Colors.grey.shade700,
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                        ),
                        "br": Style(lineHeight: LineHeight.number(1.4)),
                      },
                    ),

                  // ── See more / See less button ─────────
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        _isExpanded ? 'See less' : 'See more',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.pink.shade400,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],

                // ── Event details (if available) ───────────
                if (notification.eventName.isNotEmpty) ...[
                  const Divider(height: 20),
                  Row(
                    children: [
                      Icon(Icons.event, size: 16, color: Colors.pink.shade300),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          notification.eventName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.pink.shade700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../Api_services/api_services.dart';
// import '../content/app_drawer.dart';
// import '../content/card_data.dart';
// import '../core/services/auth_services.dart';

// // --- STATE ---
// class HomePageState {
//   final List<CardData> cards;
//   final bool isRefreshing;

//   const HomePageState({
//     this.cards = const [],
//     this.isRefreshing = false,
//   });

//   HomePageState copyWith({
//     List<CardData>? cards,
//     bool? isRefreshing,
//   }) {
//     return HomePageState(
//       cards: cards ?? this.cards,
//       isRefreshing: isRefreshing ?? this.isRefreshing,
//     );
//   }
// }

// // --- NOTIFIER ---
// class HomePageNotifier extends Notifier<HomePageState> {
//   final ApiServices _apiServices = ApiServices();

//   @override
//   HomePageState build() {
//     return HomePageState(cards: appCardsData);
//   }

//   Future<void> loadCards() async {
//     state = state.copyWith(isRefreshing: true);
//     try {
//       final token = await AuthService.getToken();
//       final apiCards = await _apiServices.fetchCards(token: token);
//       state = state.copyWith(
//         cards: apiCards.isEmpty ? appCardsData : apiCards,
//         isRefreshing: false,
//       );
//     } catch (_) {
//       state = state.copyWith(
//         cards: appCardsData,
//         isRefreshing: false,
//       );
//     }
//   }
// }

// // --- PROVIDER ---
// final homePageProvider =
// NotifierProvider<HomePageNotifier, HomePageState>(
//   HomePageNotifier.new,
// );

// // --- WIDGET ---
// class HomePage extends ConsumerStatefulWidget {
//   const HomePage({super.key});

//   @override
//   ConsumerState<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends ConsumerState<HomePage> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(homePageProvider.notifier).loadCards();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(homePageProvider);
//     final notifier = ref.read(homePageProvider.notifier);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.black),

//         title: Text(
//           "Beat Flirt",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 26,
//             shadows: [
//               const Shadow(
//                 blurRadius: 8,
//                 color: Colors.pink,
//                 offset: Offset(0, 0),
//               ),
//               const Shadow(
//                 blurRadius: 16,
//                 color: Colors.pink,
//                 offset: Offset(0, 0),
//               ),
//               Shadow(
//                 blurRadius: 24,
//                 color: Colors.pink.withValues(alpha: 0.7),
//                 offset: const Offset(0, 0),
//               ),
//               Shadow(
//                 blurRadius: 32,
//                 color: Colors.pink.withValues(alpha: 0.8),
//                 offset: const Offset(0, 0),
//               ),
//               Shadow(
//                 blurRadius: 40,
//                 color: Colors.pink.withValues(alpha: 0.8),
//                 offset: const Offset(0, 0),
//               ),Shadow(
//                 blurRadius: 48,
//                 color: Colors.pink.withValues(alpha: 0.8),
//                 offset: const Offset(0, 0),
//               ),

//             ],
//           ),
//         ),
//       ),
//       drawer: const AppDrawer(),
//       // backgroundColor: Colors.pink.withValues(alpha: 0.5),
//       backgroundColor: Colors.pink.shade900,
      
//       body: SafeArea(
//         child: Stack(
//           children: [
//             RefreshIndicator(
//               onRefresh: notifier.loadCards,
//               child: ListView.builder(
//                 padding: const EdgeInsets.all(24),
//                 itemCount: state.cards.length,
//                 itemBuilder: (context, index) {
//                   return CustomCard(
//                     cardData: state.cards[index],
//                     cardIndex: index,
//                   );
//                 },
//               ),
//             ),
//             if (state.isRefreshing)
//               const Positioned(
//                 top: 12,
//                 left: 0,
//                 right: 0,
//                 child: Center(
//                   child: SizedBox(
//                     width: 24,
//                     height: 24,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class NotificationEndDrawer extends ConsumerStatefulWidget {
  const NotificationEndDrawer({super.key});

  @override
  ConsumerState<NotificationEndDrawer> createState() => _NotificationEndDrawerState();
}

class _NotificationEndDrawerState extends ConsumerState<NotificationEndDrawer> {
  List<NotificationModel> _shortNotifications = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadShortNotifications();
  }

  Future<void> _loadShortNotifications() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final token = await AuthService.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('User token not found');
      }
      final apiService = ApiService();
      final data = await apiService.getShortNotifications(token: token);
      if (!mounted) return;
      setState(() {
        _shortNotifications = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header matching style
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            color: const Color(0xFF560827), // Burgundy/maroon theme
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF560827)))
                : _error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ),
                      )
                    : _shortNotifications.isEmpty
                        ? const Center(
                            child: Text(
                              'No notifications',
                              style: TextStyle(color: Colors.black54),
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: _shortNotifications.length,
                            separatorBuilder: (context, index) => const Divider(
                              height: 1,
                              color: Color(0xFFEEEEEE),
                            ),
                            itemBuilder: (context, index) {
                              final item = _shortNotifications[index];
                              return InkWell(
                                onTap: () {
                                  // Close drawer
                                  Navigator.of(context).pop();

                                  // Mark as read in provider
                                  if (item.id.isNotEmpty) {
                                    ref.read(notificationProvider.notifier).markAsRead(item.id);
                                  }

                                  // Route to correct page
                                  Widget? targetPage;
                                  final typeLower = item.type.toLowerCase();
                                  final titleLower = item.title.toLowerCase();
                                  if (typeLower.contains('validation_request')) {
                                    targetPage = const ValidationRequestPage();
                                  } else if (typeLower.contains('friend_request')) {
                                    targetPage = const FriendRequestsPage();
                                  } else if (typeLower.contains('like')) {
                                    targetPage = const LikesPage();
                                  } else if (typeLower.contains('viewed_me') ||
                                      typeLower.contains('viewed') ||
                                      typeLower.contains('view') ||
                                      titleLower.contains('viewed') ||
                                      titleLower.contains('view')) {
                                    targetPage = const ViewedMePage();
                                  }

                                  if (targetPage != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => targetPage!),
                                    );
                                  }

                                  // Remove from local list so it disappears from drawer list
                                  setState(() {
                                    _shortNotifications.removeWhere((n) => n.id == item.id);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Avatar/Image on Left
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: item.image.isNotEmpty
                                            ? Image.network(
                                                item.image,
                                                width: 36,
                                                height: 36,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) =>
                                                    _buildFallbackAvatar(),
                                              )
                                            : _buildFallbackAvatar(),
                                      ),
                                      const SizedBox(width: 12),
                                      // Title & Time on Right
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.title,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              item.sendMsgTime.isNotEmpty
                                                  ? item.sendMsgTime
                                                  : '${item.created} ${item.notificationTime}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackAvatar() {
    return Container(
      width: 36,
      height: 36,
      color: Colors.grey.shade200,
      child: const Icon(Icons.person, color: Colors.grey, size: 20),
    );
  }
}