// // // import 'dart:io';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // // import 'package:beatflirt/providers/events_party_provider.dart';
// // //
// // // class EventsPartyPage extends ConsumerWidget {
// // //   const EventsPartyPage({super.key});
// // //
// // //   @override
// // //   Widget build(BuildContext context, WidgetRef ref) {
// // //     final eventsPartyState = ref.watch(eventsPartyProvider);
// // //     final eventsPartyNotifier = ref.read(eventsPartyProvider.notifier);
// // //
// // //     return Scaffold(
// // //       backgroundColor: const Color(0xFF0F0F1A),
// // //       body: CustomScrollView(
// // //         physics: const BouncingScrollPhysics(),
// // //         slivers: [
// // //           _buildAppBar(context),
// // //           _buildEventHero(eventsPartyState),
// // //           _buildSectionHeader('Upcoming Parties', 'Exclusive events near you'),
// // //           _buildEventsList(eventsPartyState, eventsPartyNotifier),
// // //           const SliverPadding(padding: EdgeInsets.only(bottom: 50)),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildAppBar(BuildContext context) {
// // //     return SliverAppBar(
// // //       floating: true,
// // //       pinned: true,
// // //       backgroundColor: const Color(0xFF0F0F1A),
// // //       elevation: 0,
// // //       leading: IconButton(
// // //         icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
// // //         onPressed: () => Navigator.pop(context),
// // //       ),
// // //       centerTitle: true,
// // //       title: const Text(
// // //         'EVENTS & PARTIES',
// // //         style: TextStyle(
// // //           color: Colors.white,
// // //           fontWeight: FontWeight.w900,
// // //           fontSize: 16,
// // //           letterSpacing: 2.0,
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildEventHero(EventsPartyState state) {
// // //     final featuredEvent = state.featuredEvent;
// // //     final title = featuredEvent?.title ?? 'Midnight Summer Gala';
// // //     final location = featuredEvent?.location ?? 'Grand Plaza Hotel • Starting 10 PM';
// // //     final imageUrl = featuredEvent?.imageUrl ?? 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?q=80&w=2070&auto=format&fit=crop';
// // //
// // //     return SliverToBoxAdapter(
// // //       child: Container(
// // //         margin: const EdgeInsets.all(20),
// // //         height: 220,
// // //         decoration: BoxDecoration(
// // //           borderRadius: BorderRadius.circular(30),
// // //           image: DecorationImage(
// // //             image: NetworkImage(imageUrl),
// // //             fit: BoxFit.cover,
// // //           ),
// // //         ),
// // //         child: Container(
// // //           decoration: BoxDecoration(
// // //             borderRadius: BorderRadius.circular(30),
// // //             gradient: LinearGradient(
// // //               begin: Alignment.topCenter,
// // //               end: Alignment.bottomCenter,
// // //               colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
// // //             ),
// // //           ),
// // //           padding: const EdgeInsets.all(25),
// // //           child: Column(
// // //             mainAxisAlignment: MainAxisAlignment.end,
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               Container(
// // //                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// // //                 decoration: BoxDecoration(
// // //                   color: Colors.pinkAccent,
// // //                   borderRadius: BorderRadius.circular(10),
// // //                 ),
// // //                 child: const Text('FEATURED', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
// // //               ),
// // //               const SizedBox(height: 10),
// // //               Text(
// // //                 title,
// // //                 style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
// // //               ),
// // //               Text(
// // //                 location,
// // //                 style: const TextStyle(color: Colors.white70, fontSize: 14),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildSectionHeader(String title, String subtitle) {
// // //     return SliverToBoxAdapter(
// // //       child: Padding(
// // //         padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Text(
// // //               title,
// // //               style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
// // //             ),
// // //             Text(
// // //               subtitle,
// // //               style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildEventsList(EventsPartyState state, EventsPartyNotifier notifier) {
// // //     final events = state.events;
// // //
// // //     if (state.isLoading) {
// // //       return const SliverToBoxAdapter(
// // //         child: Padding(
// // //           padding: EdgeInsets.all(20),
// // //           child: Center(
// // //             child: CircularProgressIndicator(color: Colors.pinkAccent),
// // //           ),
// // //         ),
// // //       );
// // //     }
// // //
// // //     // Fall back to hardcoded data if API fails or returns empty
// // //     if (state.error != null || events.isEmpty) {
// // //       return SliverList(
// // //         delegate: SliverChildBuilderDelegate(
// // //           (context, index) {
// // //             return _buildEventCard(index, notifier);
// // //           },
// // //           childCount: 4,
// // //         ),
// // //       );
// // //     }
// // //
// // //     return SliverList(
// // //       delegate: SliverChildBuilderDelegate(
// // //         (context, index) {
// // //           return _buildEventCardFromData(events[index], notifier);
// // //         },
// // //         childCount: events.length,
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildEventCard(int index, EventsPartyNotifier notifier) {
// // //     final titles = ['Pool Side Mixer', 'Rooftop DJ Night', 'Jazz Evening', 'Beach Party'];
// // //     final dates = ['Fri, 24 May', 'Sat, 25 May', 'Sun, 26 May', 'Mon, 27 May'];
// // //
// // //     return Container(
// // //       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
// // //       padding: const EdgeInsets.all(15),
// // //       decoration: BoxDecoration(
// // //         color: Colors.white.withValues(alpha: 0.05),
// // //         borderRadius: BorderRadius.circular(20),
// // //         border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
// // //       ),
// // //       child: Row(
// // //         children: [
// // //           Container(
// // //             width: 80,
// // //             height: 80,
// // //             decoration: BoxDecoration(
// // //               borderRadius: BorderRadius.circular(15),
// // //               color: Colors.white10,
// // //             ),
// // //             child: const Center(child: FaIcon(FontAwesomeIcons.calendarDay, color: Colors.pinkAccent)),
// // //           ),
// // //           const SizedBox(width: 15),
// // //           Expanded(
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Text(dates[index % dates.length], style: const TextStyle(color: Colors.pinkAccent, fontSize: 12, fontWeight: FontWeight.bold)),
// // //                 const SizedBox(height: 4),
// // //                 Text(titles[index % titles.length], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
// // //                 const SizedBox(height: 4),
// // //                 const Row(
// // //                   children: [
// // //                     Icon(Icons.location_on, color: Colors.white54, size: 14),
// // //                     SizedBox(width: 4),
// // //                     Text('Downtown Venue', style: TextStyle(color: Colors.white54, fontSize: 12)),
// // //                   ],
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           IconButton(
// // //             onPressed: () {},
// // //             icon: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 18),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildEventCardFromData(Event event, EventsPartyNotifier notifier) {
// // //     return Container(
// // //       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
// // //       padding: const EdgeInsets.all(15),
// // //       decoration: BoxDecoration(
// // //         color: Colors.white.withValues(alpha: 0.05),
// // //         borderRadius: BorderRadius.circular(20),
// // //         border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
// // //       ),
// // //       child: Row(
// // //         children: [
// // //           Container(
// // //             width: 80,
// // //             height: 80,
// // //             decoration: BoxDecoration(
// // //               borderRadius: BorderRadius.circular(15),
// // //               color: Colors.white10,
// // //             ),
// // //             child: const Center(child: FaIcon(FontAwesomeIcons.calendarDay, color: Colors.pinkAccent)),
// // //           ),
// // //           const SizedBox(width: 15),
// // //           Expanded(
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Text(event.date, style: const TextStyle(color: Colors.pinkAccent, fontSize: 12, fontWeight: FontWeight.bold)),
// // //                 const SizedBox(height: 4),
// // //                 Text(event.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
// // //                 const SizedBox(height: 4),
// // //                 Row(
// // //                   children: [
// // //                     const Icon(Icons.location_on, color: Colors.white54, size: 14),
// // //                     const SizedBox(width: 4),
// // //                     Text(event.location, style: const TextStyle(color: Colors.white54, fontSize: 12)),
// // //                   ],
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           IconButton(
// // //             onPressed: () => notifier.rsvpEvent(event.id),
// // //             icon: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 18),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // lib/screens/events_page.dart
// // //
// // // One screen with two tabs:
// // //   - Events  (event_type: "public")
// // //   - Parties (event_type: "private")
// // //
// // // Both call POST /App/events/get_all_events via ApiService.getAllEvents().
// // // Search by keyword + date, pull-to-refresh, image, price chip, location, dates.

// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';

// // import 'package:beatflirt/Api_services/api_service.dart';
// // import 'package:beatflirt/core/services/auth_services.dart';
// // // import 'package:beatflirt/model/event_model.dart';

// // import '../../model/parties_event_model.dart';

// // // ════════════════════════════════════════════════════════════════════════
// // //  STATE
// // // ════════════════════════════════════════════════════════════════════════

// // enum EventTab { events, parties }

// // extension on EventTab {
// //   String get apiValue => this == EventTab.events ? 'public' : 'private';
// //   String get label    => this == EventTab.events ? 'Events'  : 'Parties';
// // }

// // class EventsState {
// //   final bool isLoading;
// //   final List<EventModel> items;
// //   final String? error;

// //   // filters
// //   final String keyword;
// //   final String searchDate; // yyyy-MM-dd, empty for none

// //   const EventsState({
// //     this.isLoading = true,
// //     this.items = const [],
// //     this.error,
// //     this.keyword = '',
// //     this.searchDate = '',
// //   });

// //   EventsState copyWith({
// //     bool? isLoading,
// //     List<EventModel>? items,
// //     String? error,
// //     bool clearError = false,
// //     String? keyword,
// //     String? searchDate,
// //   }) {
// //     return EventsState(
// //       isLoading: isLoading ?? this.isLoading,
// //       items: items ?? this.items,
// //       error: clearError ? null : (error ?? this.error),
// //       keyword: keyword ?? this.keyword,
// //       searchDate: searchDate ?? this.searchDate,
// //     );
// //   }
// // }

// // // ════════════════════════════════════════════════════════════════════════
// // //  NOTIFIER (family by tab)
// // // ════════════════════════════════════════════════════════════════════════

// // class EventsNotifier extends FamilyNotifier<EventsState, EventTab> {
// //   final ApiService _api = ApiService();
// //   late EventTab _tab;

// //   @override
// //   EventsState build(EventTab arg) {
// //     _tab = arg;
// //     return const EventsState();
// //   }

// //   Future<void> load({String? keyword, String? searchDate}) async {
// //     state = state.copyWith(
// //       isLoading: true,
// //       clearError: true,
// //       keyword: keyword ?? state.keyword,
// //       searchDate: searchDate ?? state.searchDate,
// //     );

// //     try {
// //       final token = await AuthService.getToken() ?? '';
// //       final body = await _api.getAllEvents(
// //         token: token,
// //         eventType: _tab.apiValue,
// //         keyword: state.keyword,
// //         searchDate: state.searchDate,
// //         lat: '0',
// //         lng: '0',
// //       );

// //       final apiStatus = body['status']?.toString() ?? '';
// //       if (apiStatus != '200') {
// //         state = state.copyWith(
// //           isLoading: false,
// //           items: const [],
// //           error: body['message']?.toString() ?? 'Failed to load events',
// //         );
// //         return;
// //       }

// //       final raw = body['data'];
// //       final list = (raw is List)
// //           ? raw
// //           .whereType<Map<String, dynamic>>()
// //           .map(EventModel.fromJson)
// //           .toList()
// //           : <EventModel>[];

// //       state = state.copyWith(isLoading: false, items: list, clearError: true);
// //     } catch (e, st) {
// //       if (kDebugMode) debugPrint('[Events/$_tab] $e\n$st');
// //       state = state.copyWith(
// //         isLoading: false,
// //         items: const [],
// //         error: 'Error: $e',
// //       );
// //     }
// //   }

// //   void clearFilters() {
// //     state = state.copyWith(keyword: '', searchDate: '');
// //     load();
// //   }
// // }

// // final eventsProvider =
// // NotifierProvider.family<EventsNotifier, EventsState, EventTab>(
// //   EventsNotifier.new,
// // );

// // // ════════════════════════════════════════════════════════════════════════
// // //  WIDGET
// // // ════════════════════════════════════════════════════════════════════════

// // class EventsPage extends ConsumerStatefulWidget {
// //   const EventsPage({super.key});

// //   @override
// //   ConsumerState<EventsPage> createState() => _EventsPageState();
// // }

// // class _EventsPageState extends ConsumerState<EventsPage>
// //     with SingleTickerProviderStateMixin {
// //   late final TabController _tabController;
// //   final _searchController = TextEditingController();

// //   @override
// //   void initState() {
// //     super.initState();
// //     _tabController = TabController(length: 2, vsync: this);
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       // initial load both tabs
// //       ref.read(eventsProvider(EventTab.events).notifier).load();
// //       ref.read(eventsProvider(EventTab.parties).notifier).load();
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _tabController.dispose();
// //     _searchController.dispose();
// //     super.dispose();
// //   }

// //   EventTab get _currentTab =>
// //       _tabController.index == 0 ? EventTab.events : EventTab.parties;

// //   Future<void> _pickDate() async {
// //     final now = DateTime.now();
// //     final picked = await showDatePicker(
// //       context: context,
// //       initialDate: now,
// //       firstDate: DateTime(now.year - 1),
// //       lastDate: DateTime(now.year + 5),
// //     );
// //     if (picked == null) return;
// //     final iso =
// //         '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
// //     ref.read(eventsProvider(_currentTab).notifier).load(searchDate: iso);
// //   }

// //   void _submitKeyword(String value) {
// //     ref.read(eventsProvider(_currentTab).notifier).load(keyword: value.trim());
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF7EFF7),
// //       appBar: AppBar(
// //         title: const Text('Events & Parties'),
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back_ios_new,
// //               color: Colors.black, size: 20),
// //           onPressed: () => Navigator.pop(context),
// //         ),
// //         bottom: TabBar(
// //           controller: _tabController,
// //           onTap: (_) => setState(() {}),
// //           indicatorColor: const Color(0xFF220027),
// //           labelColor: const Color(0xFF220027),
// //           unselectedLabelColor: Colors.black54,
// //           labelStyle: const TextStyle(fontWeight: FontWeight.w700),
// //           tabs: const [Tab(text: 'Events'), Tab(text: 'Parties')],
// //         ),
// //       ),
// //       body: Column(
// //         children: [
// //           _searchBar(),
// //           _activeFiltersBar(),
// //           Expanded(
// //             child: TabBarView(
// //               controller: _tabController,
// //               children: const [
// //                 _EventsTabBody(tab: EventTab.events),
// //                 _EventsTabBody(tab: EventTab.parties),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _searchBar() {
// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
// //       child: Row(
// //         children: [
// //           Expanded(
// //             child: TextField(
// //               controller: _searchController,
// //               textInputAction: TextInputAction.search,
// //               onSubmitted: _submitKeyword,
// //               decoration: InputDecoration(
// //                 hintText: 'Search ${_currentTab.label.toLowerCase()}…',
// //                 prefixIcon: const Icon(Icons.search),
// //                 isDense: true,
// //                 filled: true,
// //                 fillColor: Colors.white,
// //                 contentPadding:
// //                 const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
// //                 enabledBorder: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(10),
// //                   borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// //                 ),
// //                 focusedBorder: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(10),
// //                   borderSide: const BorderSide(color: Color(0xFF220027)),
// //                 ),
// //               ),
// //             ),
// //           ),
// //           const SizedBox(width: 8),
// //           Material(
// //             color: const Color(0xFF220027),
// //             borderRadius: BorderRadius.circular(10),
// //             child: InkWell(
// //               borderRadius: BorderRadius.circular(10),
// //               onTap: _pickDate,
// //               child: const Padding(
// //                 padding: EdgeInsets.all(12),
// //                 child:
// //                 Icon(Icons.calendar_month, color: Colors.white, size: 22),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _activeFiltersBar() {
// //     final state = ref.watch(eventsProvider(_currentTab));
// //     if (state.keyword.isEmpty && state.searchDate.isEmpty) {
// //       return const SizedBox.shrink();
// //     }
// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
// //       child: Wrap(
// //         spacing: 8,
// //         runSpacing: 4,
// //         children: [
// //           if (state.keyword.isNotEmpty)
// //             Chip(
// //               label: Text('Keyword: ${state.keyword}'),
// //               onDeleted: () {
// //                 _searchController.clear();
// //                 ref
// //                     .read(eventsProvider(_currentTab).notifier)
// //                     .load(keyword: '');
// //               },
// //             ),
// //           if (state.searchDate.isNotEmpty)
// //             Chip(
// //               label: Text('Date: ${state.searchDate}'),
// //               onDeleted: () => ref
// //                   .read(eventsProvider(_currentTab).notifier)
// //                   .load(searchDate: ''),
// //             ),
// //           TextButton(
// //             onPressed: () {
// //               _searchController.clear();
// //               ref.read(eventsProvider(_currentTab).notifier).clearFilters();
// //             },
// //             child: const Text('Clear all'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ────────────────────────────────────────────────────────────────────────
// // //  TAB BODY
// // // ────────────────────────────────────────────────────────────────────────

// // class _EventsTabBody extends ConsumerWidget {
// //   final EventTab tab;
// //   const _EventsTabBody({required this.tab});

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final state = ref.watch(eventsProvider(tab));

// //     if (state.isLoading && state.items.isEmpty) {
// //       return const Center(child: CircularProgressIndicator());
// //     }

// //     if (state.error != null && state.items.isEmpty) {
// //       return _EmptyState(
// //         icon: Icons.error_outline,
// //         title: 'Could not load ${tab.label.toLowerCase()}',
// //         message: state.error!,
// //         onRetry: () => ref.read(eventsProvider(tab).notifier).load(),
// //       );
// //     }

// //     if (state.items.isEmpty) {
// //       return _EmptyState(
// //         icon: Icons.event_busy,
// //         title: 'No ${tab.label.toLowerCase()} found',
// //         message: 'Try changing your search or come back later.',
// //         onRetry: () => ref.read(eventsProvider(tab).notifier).load(),
// //       );
// //     }

// //     return RefreshIndicator(
// //       onRefresh: () => ref.read(eventsProvider(tab).notifier).load(),
// //       child: ListView.separated(
// //         padding: const EdgeInsets.all(16),
// //         itemCount: state.items.length,
// //         separatorBuilder: (_, __) => const SizedBox(height: 12),
// //         itemBuilder: (_, i) => _EventCard(event: state.items[i]),
// //       ),
// //     );
// //   }
// // }

// // // ────────────────────────────────────────────────────────────────────────
// // //  CARD
// // // ────────────────────────────────────────────────────────────────────────

// // class _EventCard extends StatelessWidget {
// //   final EventModel event;
// //   const _EventCard({required this.event});

// //   static const _months = [
// //     'Jan','Feb','Mar','Apr','May','Jun',
// //     'Jul','Aug','Sep','Oct','Nov','Dec',
// //   ];
// //   String _fmtDate(String raw) {
// //     if (raw.isEmpty) return '';
// //     try {
// //       final d = DateTime.parse(raw);
// //       return '${_months[d.month - 1]} ${d.day}, ${d.year}';
// //     } catch (_) { return raw; }
// //   }

// //   String _dateRange() {
// //     final from = _fmtDate(event.eventFromDate);
// //     final to   = _fmtDate(event.eventToDate);
// //     if (from.isEmpty && to.isEmpty) return '';
// //     if (from.isNotEmpty && to.isNotEmpty && from != to) return '$from → $to';
// //     return from.isNotEmpty ? from : to;
// //   }

// //   String _timeRange() {
// //     final from = event.eventFromTime;
// //     final to   = event.eventToTime;
// //     if (from.isEmpty && to.isEmpty) return '';
// //     if (from.isNotEmpty && to.isNotEmpty) return '$from – $to';
// //     return from.isNotEmpty ? from : to;
// //   }

// //   /// Very lightweight HTML→text for the card preview.
// //   String _previewFromHtml(String html, {int max = 140}) {
// //     final stripped = html
// //         .replaceAll(RegExp(r'<[^>]+>'), ' ')
// //         .replaceAll('&nbsp;', ' ')
// //         .replaceAll('&amp;', '&')
// //         .replaceAll('&rsquo;', "'")
// //         .replaceAll('&lsquo;', "'")
// //         .replaceAll('&ldquo;', '"')
// //         .replaceAll('&rdquo;', '"')
// //         .replaceAll(RegExp(r'\s+'), ' ')
// //         .trim();
// //     if (stripped.length <= max) return stripped;
// //     return '${stripped.substring(0, max)}…';
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final location = event.cityName.isNotEmpty
// //         ? event.cityName
// //         : event.formattedAddress;

// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(14),
// //         border: Border.all(color: const Color(0xFFE8E0F2)),
// //       ),
// //       clipBehavior: Clip.antiAlias,
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // Image with price chip overlay
// //           AspectRatio(
// //             aspectRatio: 16 / 9,
// //             child: Stack(
// //               fit: StackFit.expand,
// //               children: [
// //                 if (event.eventImage.isNotEmpty)
// //                   Image.network(
// //                     event.eventImage,
// //                     fit: BoxFit.cover,
// //                     errorBuilder: (_, __, ___) => Container(
// //                       color: const Color(0xFFEDE3F2),
// //                       child: const Center(
// //                         child: Icon(Icons.image_not_supported,
// //                             size: 40, color: Color(0xFF220027)),
// //                       ),
// //                     ),
// //                     loadingBuilder: (ctx, child, p) {
// //                       if (p == null) return child;
// //                       return Container(
// //                         color: const Color(0xFFEDE3F2),
// //                         child: const Center(child: CircularProgressIndicator()),
// //                       );
// //                     },
// //                   )
// //                 else
// //                   Container(
// //                     color: const Color(0xFFEDE3F2),
// //                     child: const Center(
// //                       child: Icon(Icons.event, size: 40, color: Color(0xFF220027)),
// //                     ),
// //                   ),
// //                 if (event.eventPrice.isNotEmpty)
// //                   Positioned(
// //                     top: 10,
// //                     right: 10,
// //                     child: Container(
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 10, vertical: 6),
// //                       decoration: BoxDecoration(
// //                         color: const Color(0xFF220027),
// //                         borderRadius: BorderRadius.circular(20),
// //                       ),
// //                       child: Text(
// //                         '\$${event.eventPrice}',
// //                         style: const TextStyle(
// //                           color: Colors.white,
// //                           fontWeight: FontWeight.w700,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 Positioned(
// //                   top: 10,
// //                   left: 10,
// //                   child: Container(
// //                     padding: const EdgeInsets.symmetric(
// //                         horizontal: 10, vertical: 4),
// //                     decoration: BoxDecoration(
// //                       color: Colors.white.withValues(alpha: 0.9),
// //                       borderRadius: BorderRadius.circular(20),
// //                     ),
// //                     child: Text(
// //                       event.eventType.toUpperCase(),
// //                       style: const TextStyle(
// //                         color: Color(0xFF220027),
// //                         fontWeight: FontWeight.w700,
// //                         fontSize: 11,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(14),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   event.eventName,
// //                   maxLines: 2,
// //                   overflow: TextOverflow.ellipsis,
// //                   style: const TextStyle(
// //                     fontSize: 17,
// //                     fontWeight: FontWeight.w700,
// //                     color: Color(0xFF220027),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 if (_dateRange().isNotEmpty)
// //                   _row(Icons.calendar_today, _dateRange()),
// //                 if (_timeRange().isNotEmpty) ...[
// //                   const SizedBox(height: 4),
// //                   _row(Icons.access_time, _timeRange()),
// //                 ],
// //                 if (location.isNotEmpty) ...[
// //                   const SizedBox(height: 4),
// //                   _row(Icons.location_on_outlined, location),
// //                 ],
// //                 if (event.eventDescription.isNotEmpty) ...[
// //                   const SizedBox(height: 10),
// //                   Text(
// //                     _previewFromHtml(event.eventDescription),
// //                     maxLines: 3,
// //                     overflow: TextOverflow.ellipsis,
// //                     style: TextStyle(color: Colors.grey[700], height: 1.35),
// //                   ),
// //                 ],
// //                 const SizedBox(height: 12),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: Text(
// //                         event.eventNoOfTicket.isEmpty
// //                             ? ''
// //                             : '${event.eventNoOfTicket} tickets',
// //                         style: TextStyle(
// //                           color: Colors.grey[600],
// //                           fontSize: 12,
// //                         ),
// //                       ),
// //                     ),
// //                     ElevatedButton(
// //                       onPressed: () {
// //                         // TODO: navigate to event details / RSVP
// //                         ScaffoldMessenger.of(context).showSnackBar(
// //                           SnackBar(
// //                             content: Text('Open "${event.eventName}" (id=${event.id})'),
// //                           ),
// //                         );
// //                       },
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: const Color(0xFF220027),
// //                         foregroundColor: Colors.white,
// //                         shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(20)),
// //                       ),
// //                       child: const Text('View'),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _row(IconData icon, String text) {
// //     return Row(
// //       children: [
// //         Icon(icon, size: 16, color: const Color(0xFF220027)),
// //         const SizedBox(width: 6),
// //         Expanded(
// //           child: Text(
// //             text,
// //             maxLines: 1,
// //             overflow: TextOverflow.ellipsis,
// //             style: const TextStyle(fontWeight: FontWeight.w500),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // // ────────────────────────────────────────────────────────────────────────
// // //  EMPTY / ERROR
// // // ────────────────────────────────────────────────────────────────────────

// // class _EmptyState extends StatelessWidget {
// //   final IconData icon;
// //   final String title;
// //   final String message;
// //   final VoidCallback onRetry;
// //   const _EmptyState({
// //     required this.icon,
// //     required this.title,
// //     required this.message,
// //     required this.onRetry,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return ListView(
// //       // ListView so it works with RefreshIndicator if you wrap it later
// //       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
// //       children: [
// //         Icon(icon, size: 56, color: const Color(0xFF220027)),
// //         const SizedBox(height: 12),
// //         Text(
// //           title,
// //           textAlign: TextAlign.center,
// //           style: const TextStyle(
// //               fontSize: 18, fontWeight: FontWeight.w700),
// //         ),
// //         const SizedBox(height: 6),
// //         Text(
// //           message,
// //           textAlign: TextAlign.center,
// //           style: TextStyle(color: Colors.grey[700]),
// //         ),
// //         const SizedBox(height: 16),
// //         Center(
// //           child: ElevatedButton.icon(
// //             onPressed: onRetry,
// //             icon: const Icon(Icons.refresh),
// //             label: const Text('Try again'),
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: const Color(0xFF220027),
// //               foregroundColor: Colors.white,
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // lib/screens/events_page.dart

// // Parties & Events screen — matches the BeatFlirt web design.

// //  - Title: "Parties & Events"
// //  - Two pill toggles: "Public Party" (event_type: public) / "Private Party" (event_type: private)
// //  - Small filter icon (date picker)
// //  - "Terms & Conditions" link
// //  - List of cards: image, name, "Wed - Wed, February 28-28, 2029   12:57 am",
// //    location with pin, gender/orientation icon row, avatar, full-width "Buy Ticket"

// // Calls POST /App/events/get_all_events via ApiService.getAllEvents().

// // import 'package:beatflirt/core/services/token_services.dart';
// // import 'package:beatflirt/core/services/auth_services.dart';

// import 'package:beatflirt/screens/drawer_pages/event_booking_page.dart';
// import 'package:beatflirt/screens/drawer_pages/events_terms_conditions.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:beatflirt/Api_services/api_service.dart';
// import 'package:beatflirt/core/services/auth_services.dart';
// // import 'package:beatflirt/model/event_model.dart';

// import '../../model/parties_event_model.dart';

// // ════════════════════════════════════════════════════════════════════════
// //  STATE
// // ════════════════════════════════════════════════════════════════════════

// enum PartyTab { public, private }

// extension on PartyTab {
//   String get apiValue => this == PartyTab.public ? 'public' : 'private';
// }

// class EventsState {
//   final bool isLoading;
//   final List<EventModel> items;
//   final String? error;
//   final PartyTab tab;
//   final String keyword;
//   final String searchDate;

//   const EventsState({
//     this.isLoading = true,
//     this.items = const [],
//     this.error,
//     this.tab = PartyTab.public,
//     this.keyword = '',
//     this.searchDate = '',
//   });

//   EventsState copyWith({
//     bool? isLoading,
//     List<EventModel>? items,
//     String? error,
//     bool clearError = false,
//     PartyTab? tab,
//     String? keyword,
//     String? searchDate,
//   }) =>
//       EventsState(
//         isLoading: isLoading ?? this.isLoading,
//         items: items ?? this.items,
//         error: clearError ? null : (error ?? this.error),
//         tab: tab ?? this.tab,
//         keyword: keyword ?? this.keyword,
//         searchDate: searchDate ?? this.searchDate,
//       );
// }

// // ════════════════════════════════════════════════════════════════════════
// //  NOTIFIER
// // ════════════════════════════════════════════════════════════════════════

// class EventsNotifier extends Notifier<EventsState> {
//   final ApiService _api = ApiService();

//   @override
//   EventsState build() => const EventsState();

//   Future<void> setTab(PartyTab tab) async {
//     if (state.tab == tab) return;
//     state = state.copyWith(tab: tab);
//     await load();
//   }

//   Future<void> load({String? keyword, String? searchDate}) async {
//     state = state.copyWith(
//       isLoading: true,
//       clearError: true,
//       keyword: keyword ?? state.keyword,
//       searchDate: searchDate ?? state.searchDate,
//     );

//     try {
//       final token = await AuthService.getToken() ?? '';
//       final body = await _api.getAllEvents(
//         token: token,
//         eventType: state.tab.apiValue,
//         keyword: state.keyword,
//         searchDate: state.searchDate,
//         lat: '0',
//         lng: '0',
//       );

//       final apiStatus = body['status']?.toString() ?? '';
//       if (apiStatus != '200') {
//         state = state.copyWith(
//           isLoading: false,
//           items: const [],
//           error: body['message']?.toString() ?? 'Failed to load events',
//         );
//         return;
//       }

//       final raw = body['data'];
//       final list = (raw is List)
//           ? raw
//           .whereType<Map<String, dynamic>>()
//           .map(EventModel.fromJson)
//           .toList()
//           : <EventModel>[];

//       state = state.copyWith(isLoading: false, items: list, clearError: true);
//     } catch (e, st) {
//       if (kDebugMode) debugPrint('[Events] $e\n$st');
//       state = state.copyWith(
//         isLoading: false,
//         items: const [],
//         error: 'Error: $e',
//       );
//     }
//   }

//   void clearFilters() {
//     state = state.copyWith(keyword: '', searchDate: '');
//     load();
//   }
// }

// final eventsProvider =
// NotifierProvider<EventsNotifier, EventsState>(EventsNotifier.new);

// // ════════════════════════════════════════════════════════════════════════
// //  COLORS
// // ════════════════════════════════════════════════════════════════════════

// const _kBg          = Color(0xFFF9EFF3); // page background (soft pink)
// const _kPrimary     = Color(0xFF220027); // dark purple
// const _kBorder      = Color(0xFFE8E0F2);
// const _kPink        = Color(0xFFE91E63);
// const _kBlue        = Color(0xFF2196F3);
// const _kTrans       = Color(0xFFAB47BC); // transgender purple

// // ════════════════════════════════════════════════════════════════════════
// //  WIDGET
// // ════════════════════════════════════════════════════════════════════════

// class EventsPage extends ConsumerStatefulWidget {
//   const EventsPage({super.key});

//   @override
//   ConsumerState<EventsPage> createState() => _EventsPageState();
// }

// class _EventsPageState extends ConsumerState<EventsPage> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(eventsProvider.notifier).load();
//     });
//   }

//   // Future<void> _pickDate() async {
//   //   final now = DateTime.now();
//   //   final picked = await showDatePicker(
//   //     context: context,
//   //     initialDate: now,
//   //     firstDate: DateTime(now.year - 1),
//   //     lastDate: DateTime(now.year + 5),
//   //   );
//   //   if (picked == null) return;
//   //   final iso =
//   //       '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
//   //   ref.read(eventsProvider.notifier).load(searchDate: iso);
//   // }

//   // void _openTerms() {
//   //   ScaffoldMessenger.of(context).showSnackBar(
//   //     const SnackBar(content: Text('Terms & Conditions')),
//   //   );
//   // }
//     void _openTerms() {
//       TermsConditionsSheet.show(context);
//     }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(eventsProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Events & Parties"),
//         centerTitle: true,
//         backgroundColor: _kBg,
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Icons.arrow_back_ios_new,size: 20,),
//         ),
//       ),
//       backgroundColor: _kBg,
//       body: SafeArea(
//         child: RefreshIndicator(
//           onRefresh: () => ref.read(eventsProvider.notifier).load(),
//           child: CustomScrollView(
//             slivers: [
//               SliverToBoxAdapter(child: _header(state)),
//               SliverToBoxAdapter(child: _termsRow()),
//               if (state.isLoading && state.items.isEmpty)
//                 const SliverFillRemaining(
//                   hasScrollBody: false,
//                   child: Center(child: CircularProgressIndicator()),
//                 )
//               else if (state.error != null && state.items.isEmpty)
//                 SliverFillRemaining(
//                   hasScrollBody: false,
//                   child: _empty(
//                     icon: Icons.error_outline,
//                     title: 'Could not load events',
//                     message: state.error!,
//                   ),
//                 )
//               else if (state.items.isEmpty)
//                   SliverFillRemaining(
//                     hasScrollBody: false,
//                     child: _empty(
//                       icon: Icons.event_busy,
//                       title: state.tab == PartyTab.public
//                           ? 'No public parties found'
//                           : 'No private parties found',
//                       message: 'Pull down to refresh.',
//                     ),
//                   )
//                 else
//                   SliverPadding(
//                     padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
//                     sliver: SliverList.separated(
//                       itemCount: state.items.length,
//                       separatorBuilder: (_, __) => const SizedBox(height: 16),
//                       itemBuilder: (_, i) => _EventCard(event: state.items[i]),
//                     ),
//                   ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ── Header ───────────────────────────────────────────────────────────
//   Widget _header(EventsState state) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Title
//           // const Expanded(
//           //   flex: 4,
//           //   child: Text(
//           //     'Parties\n& Events',
//           //     style: TextStyle(
//           //       fontSize: 24,
//           //       fontWeight: FontWeight.w800,
//           //       height: 1.1,
//           //       color: _kPrimary,
//           //     ),
//           //   ),
//           // ),
//           // const SizedBox(width: 8),

//           // Pill toggles
//           // Expanded(
//             // flex: 6,
//             // child: Column(
//               // crossAxisAlignment: CrossAxisAlignment.stretch,
//               // children: [
//                 _PillButton(
//                   label: 'Public Party',
//                   selected: state.tab == PartyTab.public,
//                   onTap: () =>
//                       ref.read(eventsProvider.notifier).setTab(PartyTab.public),
//                 ),
//                 // const SizedBox(height: 8),
//                 SizedBox(width: MediaQuery.of(context).size.width*0.05),
//                 _PillButton(
//                   label: 'Private Party',
//                   selected: state.tab == PartyTab.private,
//                   onTap: () => ref
//                       .read(eventsProvider.notifier)
//                       .setTab(PartyTab.private),
//                 ),
//               // ],
//             // ),
//           // ),
//           const SizedBox(width: 8),

//           // Filter / date picker icon
//           InkWell(
//             // onTap: _pickDate,
//             onTap: () =>EventFilterDialog.show(context),

//             borderRadius: BorderRadius.circular(8),
//             child: const Padding(
//               padding: EdgeInsets.all(6),
//               child: Icon(Icons.tune, color: _kPrimary, size: 22),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _termsRow() {
//     return Center(
//       child: TextButton(
//         onPressed: _openTerms,
//         child: const Text(
//           'Terms & Conditions',
//           style: TextStyle(
//             color: _kPrimary,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _empty({
//     required IconData icon,
//     required String title,
//     required String message,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 56, color: _kPrimary),
//           const SizedBox(height: 12),
//           Text(title,
//               textAlign: TextAlign.center,
//               style:
//               const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
//           const SizedBox(height: 6),
//           Text(message,
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey[700])),
//           const SizedBox(height: 16),
//           ElevatedButton.icon(
//             onPressed: () => ref.read(eventsProvider.notifier).load(),
//             icon: const Icon(Icons.refresh),
//             label: const Text('Try again'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: _kPrimary,
//               foregroundColor: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ════════════════════════════════════════════════════════════════════════
// //  PILL BUTTON
// // ════════════════════════════════════════════════════════════════════════

// class _PillButton extends StatelessWidget {
//   final String label;
//   final bool selected;
//   final VoidCallback onTap;
//   const _PillButton({
//     required this.label,
//     required this.selected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(30),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 180),
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
//         decoration: BoxDecoration(
//           color: selected ? _kPrimary : Colors.transparent,
//           borderRadius: BorderRadius.circular(30),
//           border: Border.all(color: _kPrimary, width: 1.4),
//         ),
//         alignment: Alignment.center,
//         child: Text(
//           label,
//           style: TextStyle(
//             color: selected ? Colors.white : _kPrimary,
//             fontWeight: FontWeight.w700,
//             fontSize: 14,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ════════════════════════════════════════════════════════════════════════
// //  EVENT CARD (matches the screenshot)
// // ════════════════════════════════════════════════════════════════════════

// class _EventCard extends StatelessWidget {
//   final EventModel event;
//   const _EventCard({required this.event});

//   static const _monthsLong = [
//     'January','February','March','April','May','June',
//     'July','August','September','October','November','December',
//   ];
//   static const _weekdaysShort = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];

//   String _weekday(DateTime d) => _weekdaysShort[d.weekday - 1];

//   /// Produces "Wed - Wed, February 28-28, 2029" style string.
//   String _dateLine() {
//     DateTime? from, to;
//     try {
//       if (event.eventFromDate.isNotEmpty) {
//         from = DateTime.parse(event.eventFromDate);
//       }
//     } catch (_) {}
//     try {
//       if (event.eventToDate.isNotEmpty) {
//         to = DateTime.parse(event.eventToDate);
//       }
//     } catch (_) {}

//     if (from == null && to == null) return '';
//     if (from != null && to == null) {
//       return '${_weekday(from)}, ${_monthsLong[from.month - 1]} ${from.day}, ${from.year}';
//     }
//     if (from == null && to != null) {
//       return '${_weekday(to)}, ${_monthsLong[to.month - 1]} ${to.day}, ${to.year}';
//     }
//     final f = from!;
//     final t = to!;
//     if (f.year == t.year && f.month == t.month) {
//       return '${_weekday(f)} - ${_weekday(t)}, ${_monthsLong[f.month - 1]} ${f.day}-${t.day}, ${f.year}';
//     }
//     if (f.year == t.year) {
//       return '${_weekday(f)} ${_monthsLong[f.month - 1]} ${f.day} - ${_weekday(t)} ${_monthsLong[t.month - 1]} ${t.day}, ${f.year}';
//     }
//     return '${_weekday(f)} ${_monthsLong[f.month - 1]} ${f.day}, ${f.year} - ${_weekday(t)} ${_monthsLong[t.month - 1]} ${t.day}, ${t.year}';
//   }

//   /// "12:57 am" style from "00:57"
//   String _timeLine() {
//     final raw = event.eventFromTime;
//     if (raw.isEmpty) return '';
//     final parts = raw.split(':');
//     if (parts.length < 2) return raw;
//     final h = int.tryParse(parts[0]) ?? 0;
//     final m = int.tryParse(parts[1]) ?? 0;
//     final period = h >= 12 ? 'pm' : 'am';
//     final h12 = h % 12 == 0 ? 12 : h % 12;
//     return '$h12:${m.toString().padLeft(2, '0')} $period';
//   }

//   String _location() {
//     if (event.formattedAddress.isNotEmpty) return event.formattedAddress;
//     if (event.cityName.isNotEmpty) return event.cityName;
//     if (event.eventLocation.isNotEmpty) return event.eventLocation;
//     return '';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _kBorder),
//       ),
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // ── Image ──
//           Padding(
//             padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: AspectRatio(
//                 aspectRatio: 1, // square-ish like screenshot
//                 child: event.eventImage.isNotEmpty
//                     ? Image.network(
//                   event.eventImage,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => Container(
//                     color: const Color(0xFFEDE3F2),
//                     child: const Center(
//                       child: Icon(Icons.image_not_supported,
//                           size: 40, color: _kPrimary),
//                     ),
//                   ),
//                   loadingBuilder: (ctx, child, p) {
//                     if (p == null) return child;
//                     return Container(
//                       color: const Color(0xFFEDE3F2),
//                       child: const Center(
//                           child: CircularProgressIndicator()),
//                     );
//                   },
//                 )
//                     : Container(
//                   color: const Color(0xFFEDE3F2),
//                   child: const Center(
//                     child:
//                     Icon(Icons.event, size: 40, color: _kPrimary),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 14),

//           // ── Title ──
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Text(
//               event.eventName,
//               textAlign: TextAlign.center,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w800,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),

//           // ── Date + time line ──
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Text.rich(
//               TextSpan(
//                 children: [
//                   TextSpan(text: _dateLine()),
//                   if (_dateLine().isNotEmpty && _timeLine().isNotEmpty)
//                     const TextSpan(text: '    '),
//                   if (_timeLine().isNotEmpty)
//                     TextSpan(
//                       text: _timeLine(),
//                       style: const TextStyle(fontWeight: FontWeight.w700),
//                     ),
//                 ],
//               ),
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: Colors.black87,
//                 fontSize: 13.5,
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),

//           // ── Location with pin ──
//           if (_location().isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Icon(Icons.location_on, size: 16, color: _kPrimary),
//                   const SizedBox(width: 4),
//                   Flexible(
//                     child: Text(
//                       _location(),
//                       textAlign: TextAlign.center,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontSize: 13.5,
//                         color: Colors.black87,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           const SizedBox(height: 12),

//           // ── Gender / orientation flags row + avatar ──
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               children: [
//                 Expanded(child: _flagsRow(event)),
//                 Container(
//                   width: 28,
//                   height: 28,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(color: _kPrimary, width: 1.4),
//                   ),
//                   child: const Icon(Icons.person,
//                       size: 16, color: _kPrimary),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 14),

//           // ── Buy Ticket button ──
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//             child: SizedBox(
//               width: double.infinity,
//               height: 46,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   // ScaffoldMessenger.of(context).showSnackBar(
//                   //   SnackBar(
//                   //     content: Text(
//                   //       'Buy ticket for "${event.eventName}" (\$${event.eventPrice})',
//                   //     ),
//                   //   ),
//                   // );

//                     Navigator.push(
//                       context,
//                         MaterialPageRoute(
//                           builder: (_) => EventDetailScreen(eventId: event.id,),
//                         ),
//                       );
//                   },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: _kPrimary,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(26),
//                   ),
//                   elevation: 0,
//                 ),
//                 child: const Text(
//                   'Buy Ticket',
//                   style:
//                   TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _flagsRow(EventModel e) {
//     final flags = <_GenderFlag>[];
//     bool on(String v) => v == '1';

//     if (on(e.coupleMaleFemaleSwingers)) {
//       flags.add(const _GenderFlag(kind: _GenderKind.maleFemale));
//     }
//     if (on(e.coupleFemaleFemaleSwingers)) {
//       flags.add(const _GenderFlag(kind: _GenderKind.femaleFemale));
//     }
//     if (on(e.coupleMaleMaleSwingers)) {
//       flags.add(const _GenderFlag(kind: _GenderKind.maleMale));
//     }
//     if (on(e.coupleMaleSwingers)) {
//       flags.add(const _GenderFlag(kind: _GenderKind.male));
//     }
//     if (on(e.coupleFemaleSwingers)) {
//       flags.add(const _GenderFlag(kind: _GenderKind.female));
//     }
//     if (on(e.coupleTransgenderSwingers)) {
//       flags.add(const _GenderFlag(kind: _GenderKind.transgender));
//     }

//     if (flags.isEmpty) return const SizedBox.shrink();

//     return Wrap(
//       spacing: 10,
//       runSpacing: 6,
//       crossAxisAlignment: WrapCrossAlignment.center,
//       children: flags,
//     );
//   }
// }

// // ════════════════════════════════════════════════════════════════════════
// //  GENDER FLAG ICONS (couple combinations)
// // ════════════════════════════════════════════════════════════════════════

// enum _GenderKind { maleFemale, femaleFemale, maleMale, male, female, transgender }

// class _GenderFlag extends StatelessWidget {
//   final _GenderKind kind;
//   const _GenderFlag({required this.kind});

//   @override
//   Widget build(BuildContext context) {
//     switch (kind) {
//       case _GenderKind.maleFemale:
//         return Row(mainAxisSize: MainAxisSize.min, children: const [
//           Icon(Icons.male,   size: 20, color: _kBlue),
//           Icon(Icons.female, size: 20, color: _kPink),
//         ]);
//       case _GenderKind.femaleFemale:
//         return Row(mainAxisSize: MainAxisSize.min, children: const [
//           Icon(Icons.female, size: 20, color: _kPink),
//           Icon(Icons.female, size: 20, color: _kPink),
//         ]);
//       case _GenderKind.maleMale:
//         return Row(mainAxisSize: MainAxisSize.min, children: const [
//           Icon(Icons.male, size: 20, color: _kBlue),
//           Icon(Icons.male, size: 20, color: _kBlue),
//         ]);
//       case _GenderKind.male:
//         return const Icon(Icons.male, size: 20, color: _kBlue);
//       case _GenderKind.female:
//         return const Icon(Icons.female, size: 20, color: _kPink);
//       case _GenderKind.transgender:
//         return const Icon(Icons.transgender, size: 20, color: _kTrans);
//     }
//   }
// }

// // =============================================================================
// //  event_filter_widget.dart  —  Beat Flirt Event Search/Filter Dialog
// //
// //  Usage — show the filter dialog:
// //
// //    final result = await EventFilterDialog.show(context);
// //    if (result != null) {
// //      // result.keyword   → search event name
// //      // result.location  → search location
// //      // apply filters...
// //    }
// //
// //  Or use the filter icon button:
// //    EventFilterButton(
// //      onFilter: (result) {
// //        // apply result.keyword and result.location
// //      },
// //    )
// // =============================================================================

// =============================================================================
//  events_list_screen.dart  —  Beat Flirt Parties & Events List
//
//  FIXES:
//  ✅ Filter keyword sent correctly to API (matches exact payload format)
//  ✅ Search values PERSIST when reopening filter dialog
//  ✅ Location sent as keyword (API has one keyword field)
//  ✅ Filter state uses keep-alive so it never resets on navigation
//
//  Navigate:
//    Navigator.push(context, MaterialPageRoute(
//      builder: (_) => const EventsListScreen(),
//    ));
// =============================================================================

// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:beatflirt/screens/drawer_pages/event_booking_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/flutter_svg.dart';



// import 'event_detail_page.dart';
// import 'event_filter_widget.dart';

// ═════════════════════════════════════════════════════════════════════════════
// SECTION 1 — TOKEN
// ═════════════════════════════════════════════════════════════════════════════

class _Token {
  static const _key = 'auth_token';
  static Future<String> get() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_key) ?? '';
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// SECTION 2 — MODEL
// ═════════════════════════════════════════════════════════════════════════════

class EventListItem {
  final String id;
  final String eventName;
  final String eventFromDate;
  final String eventToDate;
  final String eventFromTime;
  final String eventToTime;
  final String eventType;
  final String eventImage;
  final String eventPrice;
  final String formattedAddress;
  final String cityName;
  final String eventEmail;
  final String status;

  const EventListItem({
    required this.id,
    required this.eventName,
    required this.eventFromDate,
    required this.eventToDate,
    required this.eventFromTime,
    required this.eventToTime,
    required this.eventType,
    required this.eventImage,
    required this.eventPrice,
    required this.formattedAddress,
    required this.cityName,
    required this.eventEmail,
    required this.status,
  });

  factory EventListItem.fromJson(Map<String, dynamic> j) => EventListItem(
    id: j['id']?.toString() ?? '',
    eventName: j['event_name']?.toString() ?? '',
    eventFromDate: j['event_from_date']?.toString() ?? '',
    eventToDate: j['event_to_date']?.toString() ?? '',
    eventFromTime: j['event_from_time']?.toString() ?? '',
    eventToTime: j['event_to_time']?.toString() ?? '',
    eventType: j['event_type']?.toString() ?? 'public',
    eventImage: j['event_image']?.toString() ?? '',
    eventPrice: j['event_price']?.toString() ?? '0',
    formattedAddress: j['formatted_address']?.toString() ?? '',
    cityName: j['city_name']?.toString() ?? '',
    eventEmail: j['event_email']?.toString() ?? '',
    status: j['status']?.toString() ?? '1',
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// SECTION 3 — FILTER STATE (PERSISTED — never auto-disposed)
// ═════════════════════════════════════════════════════════════════════════════

class EventFilterState {
  final String keyword; // maps to API 'keyword' field (event name search)
  final String location; // also maps to API 'keyword' (combined with name)
  final String eventType; // 'public' or 'private'

  const EventFilterState({
    this.keyword = '',
    this.location = '',
    this.eventType = 'public',
  });

  EventFilterState copyWith({
    String? keyword,
    String? location,
    String? eventType,
  }) => EventFilterState(
    keyword: keyword ?? this.keyword,
    location: location ?? this.location,
    eventType: eventType ?? this.eventType,
  );

  bool get hasActiveFilter =>
      keyword.trim().isNotEmpty || location.trim().isNotEmpty;

  /// The combined keyword sent to the API.
  /// API payload field: "keyword"
  /// If both filled → combine them so API searches both
  String get apiKeyword {
    final k = keyword.trim();
    final l = location.trim();
    if (k.isNotEmpty && l.isNotEmpty) return '$k $l';
    if (k.isNotEmpty) return k;
    if (l.isNotEmpty) return l;
    return '';
  }
}

class EventFilterNotifier extends StateNotifier<EventFilterState> {
  EventFilterNotifier() : super(const EventFilterState());

  /// Called when user taps OK in the filter dialog.
  /// Saves keyword + location — they persist across dialog open/close.
  void apply(EventFilterResult result) {
    state = state.copyWith(keyword: result.keyword, location: result.location);
    debugPrint(
      '[Filter] ✅ Applied → '
      'keyword="${result.keyword}" '
      'location="${result.location}" '
      'apiKeyword="${state.apiKeyword}"',
    );
  }

  void setEventType(String type) => state = state.copyWith(eventType: type);

  void clear() => state = EventFilterState(eventType: state.eventType);
}

// ✅ NO autoDispose — filter state lives as long as ProviderScope is alive
final eventFilterProvider =
    StateNotifierProvider<EventFilterNotifier, EventFilterState>(
      (ref) => EventFilterNotifier(),
    );

// ═════════════════════════════════════════════════════════════════════════════
// SECTION 4 — EVENTS API PROVIDER
// ═════════════════════════════════════════════════════════════════════════════

const _eventsApiUrl =
    'https://app.beatflirtevent.com/App/events/get_all_events';

/// Exact API payload (matches what you showed):
/// {
///   "event_type": "public",
///   "seach_date": "",        ← backend typo, keep it
///   "keyword": "u",
///   "lat": "0",
///   "lng": "0"
/// }
///
/// Re-fetches automatically whenever eventFilterProvider changes.
/// NOT autoDispose so the list is cached between navigations.
final eventsListProvider = FutureProvider<List<EventListItem>>((ref) async {
  // ✅ Watch filter — any change triggers re-fetch
  final filter = ref.watch(eventFilterProvider);
  final token = await _Token.get();

  // Build exact payload matching the API spec
  final payload = {
    'event_type': filter.eventType, // "public" or "private"
    'seach_date': '', // always empty (filter by date not used)
    'keyword': filter.apiKeyword, // combined name+location search
    'lat': '0',
    'lng': '0',
  };

  debugPrint('[EventsAPI] 🔵 POST $_eventsApiUrl');
  debugPrint('[EventsAPI] Payload → $payload');

  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
    'access-token': token,
  };

  // Attempt 1 — JSON body
  http.Response response = await http.post(
    Uri.parse(_eventsApiUrl),
    headers: headers,
    body: jsonEncode(payload),
  );

  debugPrint(
    '[EventsAPI] ← ${response.statusCode} | '
    '${response.body.length > 200 ? response.body.substring(0, 200) : response.body}',
  );

  Map<String, dynamic> body = jsonDecode(response.body) as Map<String, dynamic>;

  // Attempt 2 — form-encoded fallback if server rejects JSON
  if (body['status']?.toString() != '200') {
    final errMsg = (body['message'] ?? '').toString().toLowerCase();
    if (errMsg.contains('token') ||
        errMsg.contains('provide') ||
        errMsg.contains('required')) {
      debugPrint('[EventsAPI] 🟡 Retrying as form-encoded...');
      response = await http.post(
        Uri.parse(_eventsApiUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token',
          'access-token': token,
        },
        body: payload,
      );
      debugPrint(
        '[EventsAPI] form ← ${response.statusCode} | '
        '${response.body.length > 200 ? response.body.substring(0, 200) : response.body}',
      );
      body = jsonDecode(response.body) as Map<String, dynamic>;
    }
  }

  if (body['status']?.toString() == '200') {
    final data = body['data'];
    if (data is List) {
      final items = data
          .map((e) => EventListItem.fromJson(e as Map<String, dynamic>))
          .toList();
      debugPrint('[EventsAPI] ✅ ${items.length} events loaded');
      return items;
    }
  }

  debugPrint('[EventsAPI] ℹ️ No events returned');
  return [];
});

// ═════════════════════════════════════════════════════════════════════════════
// SECTION 5 — SCREEN
// ═════════════════════════════════════════════════════════════════════════════

class EventsListScreen extends ConsumerWidget {
  const EventsListScreen({super.key});

  static const Color _maroon = Color(0xFF560827);
  static const String _webBase = 'https://beatflirtevent.com/';
  static const String _apiBase = 'https://app.beatflirtevent.com/App';
  static const String _apiAssetBase = 'https://app.beatflirtevent.com/assets/';

  String _webAsset(String path) => '$_webBase$path';


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsListProvider);
    final filter = ref.watch(eventFilterProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
          iconSize: 20,
        ),
        // backgroundColor: Colors.white,
        backgroundColor: const Color(0xFFFFF0F5),
        elevation: 0.5,
        title: const Text(
          'Parties And Events',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle:true,
        actions: [
          // ── Filter button with active-dot indicator ────────────────
          // Stack(
          //   alignment: Alignment.topRight,
          //   children: [
          //     IconButton(
          //       icon: Icon(
          //         Icons.tune,
          //         color: filter.hasActiveFilter
          //             ? const Color(0xFF8B0045)
          //             : Colors.black87,
          //       ),
          //       tooltip: 'Search / Filter',
          //       onPressed: () async {
          //         // ✅ FIX 2: Pre-fill dialog with SAVED values
          //         // So reopening always shows previous search
          //         final result = await EventFilterDialog.show(
          //           context,
          //           initialKeyword: filter.keyword, // ← saved keyword
          //           initialLocation: filter.location, // ← saved location
          //         );
          //         // result is null if user dismissed without tapping OK
          //         if (result != null) {
          //           // ✅ FIX 1: apply() updates state →
          //           //    eventsListProvider re-fetches with new keyword
          //           ref.read(eventFilterProvider.notifier).apply(result);
          //         }
          //       },
          //     ),
          //     // Active filter red dot
          //     if (filter.hasActiveFilter)
          //       Positioned(
          //         right: 10,
          //         top: 10,
          //         child: Container(
          //           width: 8,
          //           height: 8,
          //           decoration: const BoxDecoration(
          //             color: Color(0xFF8B0045),
          //             shape: BoxShape.circle,
          //           ),
          //         ),
          //       ),
          //   ],
          // ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child:
          InkWell(
            onTap: () async {
                  // ✅ FIX 2: Pre-fill dialog with SAVED values
                  // So reopening always shows previous search
                  final result = await EventFilterDialog.show(
                    context,
                    initialKeyword: filter.keyword, // ← saved keyword
                    initialLocation: filter.location, // ← saved location
                  );
                  // result is null if user dismissed without tapping OK
                  if (result != null) {
                    // ✅ FIX 1: apply() updates state →
                    //    eventsListProvider re-fetches with new keyword
                    ref.read(eventFilterProvider.notifier).apply(result);
                  }
                },
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
          ),
          const SizedBox(width: 4),
        ],
      ),
  
      body: Column(
        children: [
          // ── Event Type tabs ────────────────────────────────────────
          _EventTypeTab(
            selected: filter.eventType,
            onChanged: (type) =>
                ref.read(eventFilterProvider.notifier).setEventType(type),
          ),

          // ── Active filter chips bar ────────────────────────────────
          if (filter.hasActiveFilter)
            _ActiveFilterBar(
              filter: filter,
              onClear: () => ref.read(eventFilterProvider.notifier).clear(),
            ),

          // ── Events list ────────────────────────────────────────────
          Expanded(
            child: eventsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFF8B0045)),
              ),
              error: (err, _) => _ErrorView(
                err: err,
                onRetry: () => ref.refresh(eventsListProvider),
              ),
              data: (events) {
                if (events.isEmpty) {
                  return _EmptyView(
                    hasFilter: filter.hasActiveFilter,
                    onClearFilter: () =>
                        ref.read(eventFilterProvider.notifier).clear(),
                  );
                }
                return RefreshIndicator(
                  color: const Color(0xFF8B0045),
                  onRefresh: () async => ref.refresh(eventsListProvider),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(14),
                    itemCount: events.length,
                    itemBuilder: (_, i) => _EventCard(event: events[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// SECTION 6 — WIDGETS
// ═════════════════════════════════════════════════════════════════════════════

class _EventTypeTab extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _EventTypeTab({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      color: Color(0xFFFFF0F5),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          _TabChip(
            label: 'Public Party',
            isSelected: selected == 'public',
            onTap: () => onChanged('public'),
          ),
          const SizedBox(width: 10),
          _TabChip(
            label: 'Private Party',
            isSelected: selected == 'private',
            onTap: () => onChanged('private'),
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF8B0045) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? const Color(0xFF8B0045) : Colors.grey[300]!,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.white : Colors.black54,
        ),
      ),
    ),
  );
}

class _ActiveFilterBar extends StatelessWidget {
  final EventFilterState filter;
  final VoidCallback onClear;

  const _ActiveFilterBar({required this.filter, required this.onClear});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    color: const Color(0xFF8B0045).withOpacity(0.06),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    child: Row(
      children: [
        const Icon(Icons.search, size: 14, color: Color(0xFF8B0045)),
        const SizedBox(width: 6),
        Expanded(
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              if (filter.keyword.isNotEmpty)
                _Chip(label: '📝 "${filter.keyword}"'),
              if (filter.location.isNotEmpty)
                _Chip(label: '📍 "${filter.location}"'),
            ],
          ),
        ),
        GestureDetector(
          onTap: onClear,
          child: const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              'Clear',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF8B0045),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _Chip extends StatelessWidget {
  final String label;

  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: const Color(0xFF8B0045).withOpacity(0.12),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      label,
      style: const TextStyle(fontSize: 11, color: Color(0xFF8B0045)),
    ),
  );
}

class _EventCard extends StatelessWidget {
  final EventListItem event;

  const _EventCard({required this.event});

  String _fmt(String date, String time) {
    try {
      final p = date.split('-');
      if (p.length < 3) return date;
      const m = [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      final month = int.tryParse(p[1]) ?? 0;
      final day = int.tryParse(p[2]) ?? 0;
      final tp = time.split(':');
      int h = int.tryParse(tp[0]) ?? 0;
      final min = tp.length > 1 ? tp[1] : '00';
      final per = h >= 12 ? 'pm' : 'am';
      h = h % 12;
      if (h == 0) h = 12;
      return '${m[month]} $day, ${p[0]}  $h:$min $per';
    } catch (_) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EventDetailScreen(eventId: event.id)),
    ),
    child: Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              event.eventImage,
              width: double.infinity,
              height: 170,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: double.infinity,
                height: 170,
                color: Colors.grey[200],
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
              loadingBuilder: (_, child, prog) => prog == null
                  ? child
                  : Container(
                      width: double.infinity,
                      height: 170,
                      color: Colors.grey[100],
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF8B0045),
                        ),
                      ),
                    ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + badge
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.eventName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: event.eventType == 'public'
                            ? const Color(0xFF8B0045).withOpacity(0.1)
                            : const Color(0xFF1A0A2E).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        event.eventType == 'public' ? 'Public' : 'Private',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: event.eventType == 'public'
                              ? const Color(0xFF8B0045)
                              : const Color(0xFF1A0A2E),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Date
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 12,
                      color: Colors.black45,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${_fmt(event.eventFromDate, event.eventFromTime)}  –  ${_fmt(event.eventToDate, event.eventToTime)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Location
                if (event.formattedAddress.isNotEmpty ||
                    event.cityName.isNotEmpty)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 12,
                        color: Color(0xFF8B0045),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.formattedAddress.isNotEmpty
                              ? event.formattedAddress
                              : event.cityName,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 10),

                // Price + button
                Row(
                  children: [
                    if (event.eventPrice != '0') ...[
                      const Text(
                        'From',
                        style: TextStyle(fontSize: 11, color: Colors.black45),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '\$${event.eventPrice}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B0045),
                        ),
                      ),
                    ],
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EventDetailScreen(eventId: event.id),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B0045),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      // child: const Text('View Details',
                      child: const Text(
                        'Buy Ticket',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _ErrorView extends StatelessWidget {
  final Object err;
  final VoidCallback onRetry;

  const _ErrorView({required this.err, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Color(0xFF8B0045)),
          const SizedBox(height: 16),
          const Text(
            'Failed to load events',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Text(
          //   err.toString(),
          //   textAlign: TextAlign.center,
          //   style: const TextStyle(color: Colors.grey, fontSize: 12),
          // ),
          // const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B0045),
            ),
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
            label: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ),
  );
}

class _EmptyView extends StatelessWidget {
  final bool hasFilter;
  final VoidCallback onClearFilter;

  const _EmptyView({required this.hasFilter, required this.onClearFilter});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasFilter ? Icons.search_off : Icons.event_busy_outlined,
            size: 70,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            hasFilter ? 'No events match your search' : 'No events available',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          if (hasFilter) ...[
            const SizedBox(height: 8),
            const Text(
              'Try different keywords or clear the filter',
              style: TextStyle(fontSize: 13, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onClearFilter,
              icon: const Icon(Icons.clear, color: Color(0xFF8B0045), size: 16),
              label: const Text(
                'Clear Filter',
                style: TextStyle(color: Color(0xFF8B0045)),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF8B0045)),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// FILTER RESULT MODEL
// ─────────────────────────────────────────────────────────────────────────────

class EventFilterResult {
  final String keyword;
  final String location;

  const EventFilterResult({required this.keyword, required this.location});

  bool get isEmpty => keyword.trim().isEmpty && location.trim().isEmpty;

  @override
  String toString() =>
      'EventFilterResult(keyword: "$keyword", location: "$location")';
}

// ─────────────────────────────────────────────────────────────────────────────
// DIALOG ENTRY POINT
// ─────────────────────────────────────────────────────────────────────────────

class EventFilterDialog {
  /// Shows the filter dialog.
  /// Returns [EventFilterResult] if user tapped OK,
  /// or null if dismissed/cancelled.
  static Future<EventFilterResult?> show(
    BuildContext context, {
    String initialKeyword = '',
    String initialLocation = '',
  }) {
    return showDialog<EventFilterResult>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) => _EventFilterDialogBody(
        initialKeyword: initialKeyword,
        initialLocation: initialLocation,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DIALOG BODY
// ─────────────────────────────────────────────────────────────────────────────

class _EventFilterDialogBody extends StatefulWidget {
  final String initialKeyword;
  final String initialLocation;

  const _EventFilterDialogBody({
    required this.initialKeyword,
    required this.initialLocation,
  });

  @override
  State<_EventFilterDialogBody> createState() => _EventFilterDialogBodyState();
}

class _EventFilterDialogBodyState extends State<_EventFilterDialogBody> {
  late final TextEditingController _keywordCtrl;
  late final TextEditingController _locationCtrl;
  final FocusNode _keywordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _keywordCtrl = TextEditingController(text: widget.initialKeyword);
    _locationCtrl = TextEditingController(text: widget.initialLocation);

    // Auto-focus keyword field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _keywordFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _keywordCtrl.dispose();
    _locationCtrl.dispose();
    _keywordFocus.dispose();
    super.dispose();
  }

  void _onOk() {
    Navigator.of(context).pop(
      EventFilterResult(
        keyword: _keywordCtrl.text.trim(),
        location: _locationCtrl.text.trim(),
      ),
    );
  }

  void _onClear() {
    _keywordCtrl.clear();
    _locationCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 80),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A0A2E), // dark purple bg — matches screenshot
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Search Event Name ──────────────────────────────────────
            _FilterField(
              controller: _keywordCtrl,
              focusNode: _keywordFocus,
              hint: 'Search Event Name...',
              icon: Icons.search,
              onSubmitted: (_) =>
                  _locationCtrl.selection = TextSelection.fromPosition(
                    TextPosition(offset: _locationCtrl.text.length),
                  ),
            ),

            const SizedBox(height: 8),

            // ── Search Location ────────────────────────────────────────
            _FilterField(
              controller: _locationCtrl,
              hint: 'Search Location...',
              icon: Icons.location_on_outlined,
              onSubmitted: (_) => _onOk(),
            ),

            const SizedBox(height: 8),

            // ── OK Button ──────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onOk,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Ok',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            // ── Clear (optional subtle link) ───────────────────────────
            TextButton(
              onPressed: _onClear,
              child: const Text(
                'Clear filters',
                style: TextStyle(fontSize: 12, color: Colors.white54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE FILTER FIELD
// ─────────────────────────────────────────────────────────────────────────────

class _FilterField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;

  const _FilterField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.focusNode,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.next,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: Colors.black38),
        prefixIcon: Icon(icon, size: 18, color: Colors.black38),
        suffixIcon: ListenableBuilder(
          listenable: controller,
          builder: (_, __) => controller.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    controller.clear();
                  },
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.black38,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF8B0045), width: 1.5),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CONVENIENCE FILTER ICON BUTTON — drop in your AppBar actions
// ─────────────────────────────────────────────────────────────────────────────

/// A filter icon button that opens the dialog and calls [onFilter] with result.
///
/// Example usage in AppBar:
///   actions: [
///     EventFilterButton(
///       onFilter: (result) {
///         // result.keyword, result.location
///         ref.read(eventFilterProvider.notifier).apply(result);
///       },
///     ),
///   ]
class EventFilterButton extends StatefulWidget {
  final void Function(EventFilterResult result) onFilter;
  final Color? iconColor;

  const EventFilterButton({super.key, required this.onFilter, this.iconColor});

  @override
  State<EventFilterButton> createState() => _EventFilterButtonState();
}

class _EventFilterButtonState extends State<EventFilterButton> {
  EventFilterResult _current = const EventFilterResult(
    keyword: '',
    location: '',
  );

  @override
  Widget build(BuildContext context) {
    final hasFilter = !_current.isEmpty;
    return Stack(
      alignment: Alignment.topRight,
      children: [
        IconButton(
          icon: Icon(
            Icons.tune,
            color:
                widget.iconColor ??
                (hasFilter ? const Color(0xFF8B0045) : Colors.black87),
          ),
          tooltip: 'Filter Events',
          onPressed: () async {
            final result = await EventFilterDialog.show(
              context,
              initialKeyword: _current.keyword,
              initialLocation: _current.location,
            );
            if (result != null) {
              setState(() => _current = result);
              widget.onFilter(result);
            }
          },
        ),
        // Red dot when filter is active
        if (hasFilter)
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF8B0045),
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
