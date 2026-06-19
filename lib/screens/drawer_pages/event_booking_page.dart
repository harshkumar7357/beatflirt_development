// // // // // // import 'dart:convert';

// // // // // // import 'package:flutter/foundation.dart';
// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:flutter/services.dart';
// // // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // // import 'package:http/http.dart' as http;
// // // // // import 'package:beatflirt/core/services/auth_services.dart';
// // // // // // // ════════════════════════════════════════════════════════════════════════
// // // // // // //  COLORS  (kept consistent with EventsPage)
// // // // // // // ════════════════════════════════════════════════════════════════════════

// // // // // // const _kBg = Color(0xFFF9EFF3); // page background (soft pink)
// // // // // // const _kPrimary = Color(0xFF220027); // dark purple
// // // // // // const _kBorder = Color(0xFFE8E0F2);
// // // // // // const _kPink = Color(0xFFE91E63);
// // // // // // const _kBlue = Color(0xFF2196F3);
// // // // // // const _kFieldFill = Color(0xFFF7F7FA);
// // // // // // const _kRed = Color(0xFFD93B3B);
// // // // // // const _kGreen = Color(0xFF1B873F);

// // // // // // // ════════════════════════════════════════════════════════════════════════
// // // // // // //  GUEST MODELS  (local UI state only)
// // // // // // // ════════════════════════════════════════════════════════════════════════

// // // // // // class GuestMember {
// // // // // //   String username;
// // // // // //   String fullName;
// // // // // //   String email;
// // // // // //   String phone;
// // // // // //   String? idProofPath; // local file path / name (no real upload here)

// // // // // //   GuestMember({
// // // // // //     this.username = '',
// // // // // //     this.fullName = '',
// // // // // //     this.email = '',
// // // // // //     this.phone = '',
// // // // // //     this.idProofPath,
// // // // // //   });

// // // // // //   bool get isValid =>
// // // // // //       username.trim().isNotEmpty &&
// // // // // //       fullName.trim().isNotEmpty &&
// // // // // //       email.trim().isNotEmpty &&
// // // // // //       phone.trim().isNotEmpty &&
// // // // // //       (idProofPath?.isNotEmpty ?? false);
// // // // // // }

// // // // // // enum GuestType { single, couple }

// // // // // // class GuestEntry {
// // // // // //   final String id;
// // // // // //   final GuestType type;
// // // // // //   final GuestMember member1;
// // // // // //   final GuestMember? member2; // only for couple

// // // // // //   GuestEntry({
// // // // // //     required this.id,
// // // // // //     required this.type,
// // // // // //     GuestMember? member1,
// // // // // //     GuestMember? member2,
// // // // // //   }) : member1 = member1 ?? GuestMember(),
// // // // // //        member2 = type == GuestType.couple ? (member2 ?? GuestMember()) : null;

// // // // // //   int get headCount => type == GuestType.couple ? 2 : 1;

// // // // // //   bool get isValid =>
// // // // // //       member1.isValid &&
// // // // // //       (type == GuestType.single || (member2?.isValid ?? false));
// // // // // // }

// // // // // // enum PaymentType { full, partial }

// // // // // // // ════════════════════════════════════════════════════════════════════════
// // // // // // //  STATE
// // // // // // // ════════════════════════════════════════════════════════════════════════

// // // // // // class EventBookingState {
// // // // // //   final bool isLoading;
// // // // // //   final String? error;
// // // // // //   final SingleEventDetail? detail;

// // // // // //   /// Guest forms currently being filled (before "Add Guests to the List").
// // // // // //   final List<GuestEntry> draftGuests;

// // // // // //   /// Guests committed to the list.
// // // // // //   final List<GuestEntry> savedGuests;

// // // // // //   /// roomId -> quantity
// // // // // //   final Map<String, int> roomQty;

// // // // // //   /// additionalNight date -> quantity
// // // // // //   final Map<String, int> nightQty;

// // // // // //   final PaymentType? paymentType;
// // // // // //   final String voucherCode;
// // // // // //   final double voucherDiscount;
// // // // // //   final double membershipDiscount;
// // // // // //   final bool submitting;

// // // // // //   const EventBookingState({
// // // // // //     this.isLoading = true,
// // // // // //     this.error,
// // // // // //     this.detail,
// // // // // //     this.draftGuests = const [],
// // // // // //     this.savedGuests = const [],
// // // // // //     this.roomQty = const {},
// // // // // //     this.nightQty = const {},
// // // // // //     this.paymentType,
// // // // // //     this.voucherCode = '',
// // // // // //     this.voucherDiscount = 0,
// // // // // //     this.membershipDiscount = 0,
// // // // // //     this.submitting = false,
// // // // // //   });

// // // // // //   EventBookingState copyWith({
// // // // // //     bool? isLoading,
// // // // // //     String? error,
// // // // // //     bool clearError = false,
// // // // // //     SingleEventDetail? detail,
// // // // // //     List<GuestEntry>? draftGuests,
// // // // // //     List<GuestEntry>? savedGuests,
// // // // // //     Map<String, int>? roomQty,
// // // // // //     Map<String, int>? nightQty,
// // // // // //     PaymentType? paymentType,
// // // // // //     String? voucherCode,
// // // // // //     double? voucherDiscount,
// // // // // //     double? membershipDiscount,
// // // // // //     bool? submitting,
// // // // // //   }) => EventBookingState(
// // // // // //     isLoading: isLoading ?? this.isLoading,
// // // // // //     error: clearError ? null : (error ?? this.error),
// // // // // //     detail: detail ?? this.detail,
// // // // // //     draftGuests: draftGuests ?? this.draftGuests,
// // // // // //     savedGuests: savedGuests ?? this.savedGuests,
// // // // // //     roomQty: roomQty ?? this.roomQty,
// // // // // //     nightQty: nightQty ?? this.nightQty,
// // // // // //     paymentType: paymentType ?? this.paymentType,
// // // // // //     voucherCode: voucherCode ?? this.voucherCode,
// // // // // //     voucherDiscount: voucherDiscount ?? this.voucherDiscount,
// // // // // //     membershipDiscount: membershipDiscount ?? this.membershipDiscount,
// // // // // //     submitting: submitting ?? this.submitting,
// // // // // //   );

// // // // // //   int get totalGuestHeads => savedGuests.fold(0, (sum, g) => sum + g.headCount);

// // // // // //   // ── Money calculations ────────────────────────────────────────────────

// // // // // //   /// Tickets = (event price + ... ) per guest head.
// // // // // //   double get ticketSubtotal =>
// // // // // //       (detail?.event.eventPrice ?? 0) * totalGuestHeads;

// // // // // //   double get roomsSubtotal {
// // // // // //     final rooms = detail?.rooms ?? const <RoomPackage>[];
// // // // // //     double sum = 0;
// // // // // //     for (final r in rooms) {
// // // // // //       final qty = roomQty[r.id] ?? 0;
// // // // // //       sum += (r.price + r.fee) * qty;
// // // // // //     }
// // // // // //     return sum;
// // // // // //   }

// // // // // //   double get nightsSubtotal {
// // // // // //     final price = detail?.event.additionalRoomNightPrice ?? 0;
// // // // // //     final fee = detail?.event.additionalRoomNightFee ?? 0;
// // // // // //     int totalQty = 0;
// // // // // //     nightQty.forEach((_, q) => totalQty += q);
// // // // // //     return (price + fee) * totalQty;
// // // // // //   }

// // // // // //   double get subTotal => ticketSubtotal + roomsSubtotal + nightsSubtotal;

// // // // // //   double get total {
// // // // // //     final t = subTotal - membershipDiscount - voucherDiscount;
// // // // // //     return t < 0 ? 0 : t;
// // // // // //   }
// // // // // // }

// // // // // // // ════════════════════════════════════════════════════════════════════════
// // // // // // //  NOTIFIER  (self-contained http call — no ApiService dependency)
// // // // // // // ════════════════════════════════════════════════════════════════════════

// // // // // // const _kSingleEventUrl =
// // // // // //     'https://app.beatflirtevent.com/App/events/get_single_events';

// // // // // // class EventBookingNotifier extends FamilyNotifier<EventBookingState, String> {
// // // // // //   late String _eventId;

// // // // // //   @override
// // // // // //   EventBookingState build(String eventId) {
// // // // // //     _eventId = eventId;
// // // // // //     // Kick off the load once.
// // // // // //     Future.microtask(load);
// // // // // //     return const EventBookingState();
// // // // // //   }

// // // // // //   Future<void> load() async {
// // // // // //     state = state.copyWith(isLoading: true, clearError: true);
// // // // // //     try {
// // // // // //       final token = await AuthService.getToken();
// // // // // //       final headers = {'Accept': 'application/json'};
// // // // // //       if (token != null && token.isNotEmpty) {
// // // // // //         headers['Authorization'] = 'Bearer $token';
// // // // // //       } else {
// // // // // //         // No token available, show error prompting user to provide token
// // // // // //         state = state.copyWith(isLoading: false, error: 'Please provide token');
// // // // // //         return;
// // // // // //       }
// // // // // //       final res = await http.post(
// // // // // //         Uri.parse(_kSingleEventUrl),
// // // // // //         headers: headers,
// // // // // //         body: {'event_id': _eventId},
// // // // // //       );

// // // // // //       if (res.statusCode != 200) {
// // // // // //         state = state.copyWith(
// // // // // //           isLoading: false,
// // // // // //           error: 'Server error (${res.statusCode})',
// // // // // //         );
// // // // // //         return;
// // // // // //       }

// // // // // //       final body = jsonDecode(res.body) as Map<String, dynamic>;
// // // // // //       final apiStatus = body['status']?.toString() ?? '';
// // // // // //       if (apiStatus != '200') {
// // // // // //         state = state.copyWith(
// // // // // //           isLoading: false,
// // // // // //           error: body['message']?.toString() ?? 'Failed to load event',
// // // // // //         );
// // // // // //         return;
// // // // // //       }

// // // // // //       final detail = SingleEventDetail.fromJson(body);

// // // // // //       // Seed qty maps with zeros.
// // // // // //       final roomQty = {for (final r in detail.rooms) r.id: 0};
// // // // // //       final nightQty = {for (final n in detail.additionalNights) n.date: 0};

// // // // // //       state = state.copyWith(
// // // // // //         isLoading: false,
// // // // // //         detail: detail,
// // // // // //         roomQty: roomQty,
// // // // // //         nightQty: nightQty,
// // // // // //         clearError: true,
// // // // // //       );
// // // // // //     } catch (e, st) {
// // // // // //       if (kDebugMode) debugPrint('[EventBooking] $e\n$st');
// // // // // //       state = state.copyWith(isLoading: false, error: 'Error: $e');
// // // // // //     }
// // // // // //   }

// // // // // //   // ── Draft guests ──────────────────────────────────────────────────────

// // // // // //   void addSingleDraft() {
// // // // // //     state = state.copyWith(
// // // // // //       draftGuests: [
// // // // // //         ...state.draftGuests,
// // // // // //         GuestEntry(id: UniqueKey().toString(), type: GuestType.single),
// // // // // //       ],
// // // // // //     );
// // // // // //   }

// // // // // //   void addCoupleDraft() {
// // // // // //     state = state.copyWith(
// // // // // //       draftGuests: [
// // // // // //         ...state.draftGuests,
// // // // // //         GuestEntry(id: UniqueKey().toString(), type: GuestType.couple),
// // // // // //       ],
// // // // // //     );
// // // // // //   }

// // // // // //   void removeDraft(String id) {
// // // // // //     state = state.copyWith(
// // // // // //       draftGuests: state.draftGuests.where((g) => g.id != id).toList(),
// // // // // //     );
// // // // // //   }

// // // // // //   /// Mutate a draft member field in place and refresh state reference.
// // // // // //   void updateDraftMember(
// // // // // //     String guestId, {
// // // // // //     required bool isMember2,
// // // // // //     String? username,
// // // // // //     String? fullName,
// // // // // //     String? email,
// // // // // //     String? phone,
// // // // // //     String? idProofPath,
// // // // // //   }) {
// // // // // //     final list = state.draftGuests;
// // // // // //     final idx = list.indexWhere((g) => g.id == guestId);
// // // // // //     if (idx == -1) return;
// // // // // //     final g = list[idx];
// // // // // //     final m = isMember2 ? g.member2 : g.member1;
// // // // // //     if (m == null) return;
// // // // // //     if (username != null) m.username = username;
// // // // // //     if (fullName != null) m.fullName = fullName;
// // // // // //     if (email != null) m.email = email;
// // // // // //     if (phone != null) m.phone = phone;
// // // // // //     if (idProofPath != null) m.idProofPath = idProofPath;
// // // // // //     // Reassign list to trigger rebuild (e.g. validation hints / file labels).
// // // // // //     state = state.copyWith(draftGuests: List.of(list));
// // // // // //   }

// // // // // //   /// "Click here to generate your information" — fills first single member.
// // // // // //   void generateMyInfo({
// // // // // //     required String username,
// // // // // //     required String fullName,
// // // // // //     required String email,
// // // // // //     required String phone,
// // // // // //   }) {
// // // // // //     var drafts = state.draftGuests;
// // // // // //     if (drafts.isEmpty) {
// // // // // //       drafts = [GuestEntry(id: UniqueKey().toString(), type: GuestType.single)];
// // // // // //     }
// // // // // //     final first = drafts.first;
// // // // // //     first.member1
// // // // // //       ..username = username
// // // // // //       ..fullName = fullName
// // // // // //       ..email = email
// // // // // //       ..phone = phone;
// // // // // //     state = state.copyWith(draftGuests: List.of(drafts));
// // // // // //   }

// // // // // //   /// Returns null on success, or an error message.
// // // // // //   String? commitDrafts() {
// // // // // //     if (state.draftGuests.isEmpty) {
// // // // // //       return 'Add at least one guest first.';
// // // // // //     }
// // // // // //     final invalid = state.draftGuests.where((g) => !g.isValid).toList();
// // // // // //     if (invalid.isNotEmpty) {
// // // // // //       return 'Please complete all required guest fields.';
// // // // // //     }
// // // // // //     state = state.copyWith(
// // // // // //       savedGuests: [...state.savedGuests, ...state.draftGuests],
// // // // // //       draftGuests: const [],
// // // // // //     );
// // // // // //     return null;
// // // // // //   }

// // // // // //   void removeSavedGuest(String id) {
// // // // // //     state = state.copyWith(
// // // // // //       savedGuests: state.savedGuests.where((g) => g.id != id).toList(),
// // // // // //     );
// // // // // //   }

// // // // // //   // ── Rooms / nights ────────────────────────────────────────────────────

// // // // // //   void setRoomQty(String roomId, int qty) {
// // // // // //     final map = Map<String, int>.from(state.roomQty);
// // // // // //     map[roomId] = qty;
// // // // // //     state = state.copyWith(roomQty: map);
// // // // // //   }

// // // // // //   void setNightQty(String date, int qty) {
// // // // // //     final map = Map<String, int>.from(state.nightQty);
// // // // // //     map[date] = qty;
// // // // // //     state = state.copyWith(nightQty: map);
// // // // // //   }

// // // // // //   // ── Payment / voucher ─────────────────────────────────────────────────

// // // // // //   void setPaymentType(PaymentType t) => state = state.copyWith(paymentType: t);

// // // // // //   void setVoucherCode(String code) => state = state.copyWith(voucherCode: code);

// // // // // //   /// Demo voucher logic — replace with real validate-voucher API if needed.
// // // // // //   String applyVoucher() {
// // // // // //     final code = state.voucherCode.trim();
// // // // // //     if (code.isEmpty) return 'Enter a voucher code.';
// // // // // //     // TODO: call real voucher-validation API.
// // // // // //     // Demo: "SAVE10" => 10% off subtotal.
// // // // // //     if (code.toUpperCase() == 'SAVE10') {
// // // // // //       state = state.copyWith(voucherDiscount: state.subTotal * 0.10);
// // // // // //       return 'Voucher applied: 10% off';
// // // // // //     }
// // // // // //     state = state.copyWith(voucherDiscount: 0);
// // // // // //     return 'Invalid voucher code.';
// // // // // //   }

// // // // // //   // ── Submit (stubbed) ──────────────────────────────────────────────────

// // // // // //   Future<String?> buyTicket() async {
// // // // // //     if (state.savedGuests.isEmpty) {
// // // // // //       return 'Add at least one guest to the list.';
// // // // // //     }
// // // // // //     if (state.paymentType == null) {
// // // // // //       return 'Select a payment type.';
// // // // // //     }
// // // // // //     state = state.copyWith(submitting: true);
// // // // // //     // TODO: integrate real booking/purchase endpoint here.
// // // // // //     // Build payload from: _eventId, savedGuests, roomQty, nightQty,
// // // // // //     // paymentType, voucherCode, totals, etc.
// // // // // //     await Future.delayed(const Duration(milliseconds: 700));
// // // // // //     state = state.copyWith(submitting: false);
// // // // // //     return null; // success
// // // // // //   }
// // // // // // }

// // // // // // final eventBookingProvider =
// // // // // //     NotifierProvider.family<EventBookingNotifier, EventBookingState, String>(
// // // // // //       EventBookingNotifier.new,
// // // // // //     );

// // // // // // // ════════════════════════════════════════════════════════════════════════
// // // // // // //  PAGE
// // // // // // // ════════════════════════════════════════════════════════════════════════

// // // // // // class EventBookingPage extends ConsumerWidget {
// // // // // //   final String eventId;
// // // // // //   const EventBookingPage({
// // // // // //     super.key,
// // // // // //     required this.eventId,
// // // // // //     required String event,
// // // // // //   });

// // // // // //   @override
// // // // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // // // //     final state = ref.watch(eventBookingProvider(eventId));
// // // // // //     final notifier = ref.read(eventBookingProvider(eventId).notifier);
// // // // // //     final _tokenController = TextEditingController();
// // // // // //     return Scaffold(
// // // // // //       backgroundColor: _kBg,
// // // // // //       body: SafeArea(child: _buildBody(context, ref, state, notifier)),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _buildBody(
// // // // // //     BuildContext context,
// // // // // //     WidgetRef ref,
// // // // // //     EventBookingState state,
// // // // // //     EventBookingNotifier notifier,
// // // // // //   ) {
// // // // // //     if (state.isLoading && state.detail == null) {
// // // // // //       return Column(
// // // // // //         children: [
// // // // // //           _topBar(context),
// // // // // //           const Expanded(child: Center(child: CircularProgressIndicator())),
// // // // // //         ],
// // // // // //       );
// // // // // //     }

// // // // // //     if (state.error != null && state.detail == null) {
// // // // // //       return Column(
// // // // // //         children: [
// // // // // //           _topBar(context),
// // // // // //           Expanded(
// // // // // //             child: Center(
// // // // // //               child: Padding(
// // // // // //                 padding: const EdgeInsets.all(24),
// // // // // //                 child: Column(
// // // // // //                   mainAxisSize: MainAxisSize.min,
// // // // // //                   children: [
// // // // // //                     const Icon(Icons.error_outline, size: 56, color: _kPrimary),
// // // // // //                     const SizedBox(height: 12),
// // // // // //                     Text(state.error!, textAlign: TextAlign.center),
// // // // // //                     const SizedBox(height: 16),
// // // // // //                     ElevatedButton.icon(
// // // // // //                       onPressed: notifier.load,
// // // // // //                       icon: const Icon(Icons.refresh),
// // // // // //                       label: const Text('Try again'),
// // // // // //                       style: ElevatedButton.styleFrom(
// // // // // //                         backgroundColor: _kPrimary,
// // // // // //                         foregroundColor: Colors.white,
// // // // // //                       ),
// // // // // //                     ),
// // // // // //                   ],
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       );
// // // // // //     }

// // // // // //     final detail = state.detail!;
// // // // // //     return RefreshIndicator(
// // // // // //       onRefresh: notifier.load,
// // // // // //       child: ListView(
// // // // // //         padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
// // // // // //         children: [
// // // // // //           _topBar(context),
// // // // // //           const SizedBox(height: 12),
// // // // // //           _EventHeaderCard(event: detail.event),
// // // // // //           const SizedBox(height: 16),
// // // // // //           _GuestSection(eventId: eventId),
// // // // // //           const SizedBox(height: 24),
// // // // // //           _RoomPackageSection(eventId: eventId, rooms: detail.rooms),
// // // // // //           if (detail.additionalNights.isNotEmpty) ...[
// // // // // //             const SizedBox(height: 24),
// // // // // //             _AdditionalNightsSection(
// // // // // //               eventId: eventId,
// // // // // //               nights: detail.additionalNights,
// // // // // //               price: detail.event.additionalRoomNightPrice,
// // // // // //               fee: detail.event.additionalRoomNightFee,
// // // // // //             ),
// // // // // //           ],
// // // // // //           const SizedBox(height: 24),
// // // // // //           _PaymentAndSummary(eventId: eventId),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _topBar(BuildContext context) {
// // // // // //     return Padding(
// // // // // //       padding: const EdgeInsets.only(top: 8, bottom: 4),
// // // // // //       child: Row(
// // // // // //         children: [
// // // // // //           const Expanded(
// // // // // //             child: Text(
// // // // // //               'Parties And Events',
// // // // // //               style: TextStyle(
// // // // // //                 fontSize: 22,
// // // // // //                 fontWeight: FontWeight.w800,
// // // // // //                 color: _kPrimary,
// // // // // //               ),
// // // // // //             ),
// // // // // //           ),
// // // // // //           InkWell(
// // // // // //             borderRadius: BorderRadius.circular(20),
// // // // // //             onTap: () => Navigator.maybePop(context),
// // // // // //             child: Container(
// // // // // //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// // // // // //               decoration: BoxDecoration(
// // // // // //                 gradient: const LinearGradient(
// // // // // //                   colors: [Color(0xFF8E0E4B), _kPink],
// // // // // //                 ),
// // // // // //                 borderRadius: BorderRadius.circular(20),
// // // // // //               ),
// // // // // //               child: const Row(
// // // // // //                 mainAxisSize: MainAxisSize.min,
// // // // // //                 children: [
// // // // // //                   Icon(Icons.arrow_back, color: Colors.white, size: 18),
// // // // // //                   SizedBox(width: 4),
// // // // // //                   Text(
// // // // // //                     'Back',
// // // // // //                     style: TextStyle(
// // // // // //                       color: Colors.white,
// // // // // //                       fontWeight: FontWeight.w600,
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                 ],
// // // // // //               ),
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // // ════════════════════════════════════════════════════════════════════════
// // // // // // //  EVENT HEADER CARD
// // // // // // // ════════════════════════════════════════════════════════════════════════

// // // // // // class _EventHeaderCard extends StatefulWidget {
// // // // // //   final EventDetail event;
// // // // // //   const _EventHeaderCard({required this.event});

// // // // // //   @override
// // // // // //   State<_EventHeaderCard> createState() => _EventHeaderCardState();
// // // // // // }

// // // // // // class _EventHeaderCardState extends State<_EventHeaderCard> {
// // // // // //   bool _expanded = false;

// // // // // //   static const _monthsLong = [
// // // // // //     'January',
// // // // // //     'February',
// // // // // //     'March',
// // // // // //     'April',
// // // // // //     'May',
// // // // // //     'June',
// // // // // //     'July',
// // // // // //     'August',
// // // // // //     'September',
// // // // // //     'October',
// // // // // //     'November',
// // // // // //     'December',
// // // // // //   ];
// // // // // //   static const _weekdaysLong = [
// // // // // //     'Monday',
// // // // // //     'Tuesday',
// // // // // //     'Wednesday',
// // // // // //     'Thursday',
// // // // // //     'Friday',
// // // // // //     'Saturday',
// // // // // //     'Sunday',
// // // // // //   ];

// // // // // //   String _fmtDateTime(String date, String time) {
// // // // // //     DateTime? d;
// // // // // //     try {
// // // // // //       if (date.isNotEmpty) d = DateTime.parse(date);
// // // // // //     } catch (_) {}
// // // // // //     if (d == null) return '';
// // // // // //     final wd = _weekdaysLong[d.weekday - 1];
// // // // // //     final mon = _monthsLong[d.month - 1];
// // // // // //     final base = '$wd, $mon ${d.day}, ${d.year}';
// // // // // //     final t = _fmtTime(time);
// // // // // //     return t.isEmpty ? base : '$base   $t';
// // // // // //   }

// // // // // //   String _fmtTime(String raw) {
// // // // // //     if (raw.isEmpty) return '';
// // // // // //     final parts = raw.split(':');
// // // // // //     if (parts.length < 2) return raw;
// // // // // //     final h = int.tryParse(parts[0]) ?? 0;
// // // // // //     final m = int.tryParse(parts[1]) ?? 0;
// // // // // //     final period = h >= 12 ? 'pm' : 'am';
// // // // // //     final h12 = h % 12 == 0 ? 12 : h % 12;
// // // // // //     return '$h12:${m.toString().padLeft(2, '0')} $period';
// // // // // //   }

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     final e = widget.event;
// // // // // //     final from = _fmtDateTime(e.eventFromDate, e.eventFromTime);
// // // // // //     final to = _fmtDateTime(e.eventToDate, e.eventToTime);
// // // // // //     final dateLine = (from.isNotEmpty && to.isNotEmpty)
// // // // // //         ? '$from – $to'
// // // // // //         : (from + to);

// // // // // //     final desc = e.eventDescription;
// // // // // //     final isLong = desc.length > 120;
// // // // // //     final shownDesc = (_expanded || !isLong)
// // // // // //         ? desc
// // // // // //         : '${desc.substring(0, desc.length.clamp(0, 120))}...';

// // // // // //     return _CardShell(
// // // // // //       child: Column(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //         children: [
// // // // // //           LayoutBuilder(
// // // // // //             builder: (ctx, c) {
// // // // // //               final wide = c.maxWidth > 560;
// // // // // //               final image = ClipRRect(
// // // // // //                 borderRadius: BorderRadius.circular(12),
// // // // // //                 child: AspectRatio(
// // // // // //                   aspectRatio: wide ? 1 : 16 / 10,
// // // // // //                   child: _eventImage(e.eventImage),
// // // // // //                 ),
// // // // // //               );
// // // // // //               final info = Column(
// // // // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //                 children: [
// // // // // //                   Text(
// // // // // //                     e.eventName,
// // // // // //                     style: const TextStyle(
// // // // // //                       fontSize: 22,
// // // // // //                       fontWeight: FontWeight.w800,
// // // // // //                       color: Colors.black,
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                   const SizedBox(height: 8),
// // // // // //                   if (dateLine.isNotEmpty)
// // // // // //                     Text(
// // // // // //                       dateLine,
// // // // // //                       style: TextStyle(color: Colors.grey[700], fontSize: 13.5),
// // // // // //                     ),
// // // // // //                   const SizedBox(height: 8),
// // // // // //                   if (e.formattedAddress.isNotEmpty)
// // // // // //                     Row(
// // // // // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //                       children: [
// // // // // //                         const Icon(
// // // // // //                           Icons.location_on,
// // // // // //                           size: 18,
// // // // // //                           color: _kPrimary,
// // // // // //                         ),
// // // // // //                         const SizedBox(width: 4),
// // // // // //                         Expanded(
// // // // // //                           child: Text(
// // // // // //                             e.formattedAddress,
// // // // // //                             style: const TextStyle(
// // // // // //                               fontSize: 13.5,
// // // // // //                               color: Colors.black87,
// // // // // //                             ),
// // // // // //                           ),
// // // // // //                         ),
// // // // // //                       ],
// // // // // //                     ),
// // // // // //                   const SizedBox(height: 6),
// // // // // //                   if (e.eventEmail.isNotEmpty)
// // // // // //                     Text(
// // // // // //                       'contacted by:- ${e.eventEmail}',
// // // // // //                       style: TextStyle(color: Colors.grey[600], fontSize: 12.5),
// // // // // //                     ),
// // // // // //                   const SizedBox(height: 14),
// // // // // //                   const Text(
// // // // // //                     'Description',
// // // // // //                     style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
// // // // // //                   ),
// // // // // //                   const SizedBox(height: 4),
// // // // // //                   Text(
// // // // // //                     shownDesc,
// // // // // //                     style: const TextStyle(color: _kPink, height: 1.4),
// // // // // //                   ),
// // // // // //                   if (isLong)
// // // // // //                     TextButton(
// // // // // //                       style: TextButton.styleFrom(
// // // // // //                         padding: EdgeInsets.zero,
// // // // // //                         minimumSize: const Size(0, 32),
// // // // // //                         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
// // // // // //                         alignment: Alignment.centerLeft,
// // // // // //                       ),
// // // // // //                       onPressed: () => setState(() => _expanded = !_expanded),
// // // // // //                       child: Text(
// // // // // //                         _expanded ? 'Show Less' : 'Show More...',
// // // // // //                         style: const TextStyle(
// // // // // //                           color: _kPrimary,
// // // // // //                           fontWeight: FontWeight.w600,
// // // // // //                         ),
// // // // // //                       ),
// // // // // //                     ),
// // // // // //                 ],
// // // // // //               );

// // // // // //               if (wide) {
// // // // // //                 return Row(
// // // // // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //                   children: [
// // // // // //                     SizedBox(width: 220, child: image),
// // // // // //                     const SizedBox(width: 16),
// // // // // //                     Expanded(child: info),
// // // // // //                   ],
// // // // // //                 );
// // // // // //               }
// // // // // //               return Column(
// // // // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //                 children: [image, const SizedBox(height: 14), info],
// // // // // //               );
// // // // // //             },
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _eventImage(String url) {
// // // // // //     if (url.isEmpty) {
// // // // // //       return Container(
// // // // // //         color: const Color(0xFFEDE3F2),
// // // // // //         child: const Center(
// // // // // //           child: Icon(Icons.event, size: 40, color: _kPrimary),
// // // // // //         ),
// // // // // //       );
// // // // // //     }
// // // // // //     return Image.network(
// // // // // //       url,
// // // // // //       fit: BoxFit.cover,
// // // // // //       errorBuilder: (_, __, ___) => Container(
// // // // // //         color: const Color(0xFFEDE3F2),
// // // // // //         child: const Center(
// // // // // //           child: Icon(Icons.image_not_supported, size: 40, color: _kPrimary),
// // // // // //         ),
// // // // // //       ),
// // // // // //       loadingBuilder: (ctx, child, p) {
// // // // // //         if (p == null) return child;
// // // // // //         return Container(
// // // // // //           color: const Color(0xFFEDE3F2),
// // // // // //           child: const Center(child: CircularProgressIndicator()),
// // // // // //         );
// // // // // //       },
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // // ════════════════════════════════════════════════════════════════════════
// // // // // // //  GUEST SECTION
// // // // // // // ════════════════════════════════════════════════════════════════════════

// // // // // // class _GuestSection extends ConsumerWidget {
// // // // // //   final String eventId;
// // // // // //   const _GuestSection({required this.eventId});

// // // // // //   @override
// // // // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // // // //     final state = ref.watch(eventBookingProvider(eventId));
// // // // // //     final notifier = ref.read(eventBookingProvider(eventId).notifier);

// // // // // //     return _CardShell(
// // // // // //       child: Column(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //         children: [
// // // // // //           // Generate-info checkbox.
// // // // // //           Row(
// // // // // //             children: [
// // // // // //               SizedBox(
// // // // // //                 width: 28,
// // // // // //                 child: Checkbox(
// // // // // //                   value: false,
// // // // // //                   onChanged: (v) {
// // // // // //                     if (v == true) {
// // // // // //                       // Demo prefill — wire to your logged-in user data.
// // // // // //                       notifier.generateMyInfo(
// // // // // //                         username: 'me',
// // // // // //                         fullName: 'My Name',
// // // // // //                         email: 'me@example.com',
// // // // // //                         phone: '0000000000',
// // // // // //                       );
// // // // // //                       ScaffoldMessenger.of(context).showSnackBar(
// // // // // //                         const SnackBar(
// // // // // //                           content: Text('Your information generated'),
// // // // // //                         ),
// // // // // //                       );
// // // // // //                     }
// // // // // //                   },
// // // // // //                 ),
// // // // // //               ),
// // // // // //               const Expanded(
// // // // // //                 child: Text('Click here to generate your information'),
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //           const SizedBox(height: 8),

// // // // // //           // Add guest buttons.
// // // // // //           Row(
// // // // // //             children: [
// // // // // //               const Text(
// // // // // //                 'Add Guest:',
// // // // // //                 style: TextStyle(color: _kPink, fontWeight: FontWeight.w700),
// // // // // //               ),
// // // // // //               const SizedBox(width: 12),
// // // // // //               _GuestTypeButton(
// // // // // //                 icon: Icons.person,
// // // // // //                 label: 'Single',
// // // // // //                 onTap: notifier.addSingleDraft,
// // // // // //               ),
// // // // // //               const SizedBox(width: 10),
// // // // // //               _GuestTypeButton(
// // // // // //                 icon: Icons.group,
// // // // // //                 label: 'Couple',
// // // // // //                 onTap: notifier.addCoupleDraft,
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //           const SizedBox(height: 16),

// // // // // //           // Draft guest forms.
// // // // // //           for (var i = 0; i < state.draftGuests.length; i++) ...[
// // // // // //             _GuestForm(
// // // // // //               eventId: eventId,
// // // // // //               guest: state.draftGuests[i],
// // // // // //               index: i + 1,
// // // // // //             ),
// // // // // //             const SizedBox(height: 16),
// // // // // //           ],

// // // // // //           if (state.draftGuests.isNotEmpty)
// // // // // //             Center(
// // // // // //               child: _PrimaryButton(
// // // // // //                 label: 'Add Guests to the List',
// // // // // //                 onTap: () {
// // // // // //                   final err = notifier.commitDrafts();
// // // // // //                   ScaffoldMessenger.of(context).showSnackBar(
// // // // // //                     SnackBar(
// // // // // //                       content: Text(err ?? 'Guests added to the list'),
// // // // // //                       backgroundColor: err == null ? _kGreen : _kRed,
// // // // // //                     ),
// // // // // //                   );
// // // // // //                 },
// // // // // //               ),
// // // // // //             ),

// // // // // //           // Saved guests list.
// // // // // //           if (state.savedGuests.isNotEmpty) ...[
// // // // // //             const SizedBox(height: 16),
// // // // // //             const Divider(),
// // // // // //             const SizedBox(height: 8),
// // // // // //             Text(
// // // // // //               'Guests on the list (${state.totalGuestHeads})',
// // // // // //               style: const TextStyle(fontWeight: FontWeight.w700),
// // // // // //             ),
// // // // // //             const SizedBox(height: 8),
// // // // // //             for (final g in state.savedGuests)
// // // // // //               _SavedGuestTile(
// // // // // //                 guest: g,
// // // // // //                 onRemove: () => notifier.removeSavedGuest(g.id),
// // // // // //               ),
// // // // // //           ],
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // class _SavedGuestTile extends StatelessWidget {
// // // // // //   final GuestEntry guest;
// // // // // //   final VoidCallback onRemove;
// // // // // //   const _SavedGuestTile({required this.guest, required this.onRemove});

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     final isCouple = guest.type == GuestType.couple;
// // // // // //     final title = isCouple
// // // // // //         ? '${guest.member1.fullName} & ${guest.member2?.fullName ?? ''}'
// // // // // //         : guest.member1.fullName;
// // // // // //     return Container(
// // // // // //       margin: const EdgeInsets.only(bottom: 8),
// // // // // //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// // // // // //       decoration: BoxDecoration(
// // // // // //         color: _kFieldFill,
// // // // // //         borderRadius: BorderRadius.circular(10),
// // // // // //         border: Border.all(color: _kBorder),
// // // // // //       ),
// // // // // //       child: Row(
// // // // // //         children: [
// // // // // //           Icon(
// // // // // //             isCouple ? Icons.group : Icons.person,
// // // // // //             size: 20,
// // // // // //             color: _kPrimary,
// // // // // //           ),
// // // // // //           const SizedBox(width: 10),
// // // // // //           Expanded(
// // // // // //             child: Column(
// // // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //               children: [
// // // // // //                 Text(
// // // // // //                   title.trim().isEmpty ? '(no name)' : title,
// // // // // //                   style: const TextStyle(fontWeight: FontWeight.w600),
// // // // // //                 ),
// // // // // //                 Text(
// // // // // //                   isCouple ? 'Couple' : 'Single',
// // // // // //                   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
// // // // // //                 ),
// // // // // //               ],
// // // // // //             ),
// // // // // //           ),
// // // // // //           IconButton(
// // // // // //             onPressed: onRemove,
// // // // // //             icon: const Icon(Icons.delete_outline, color: _kRed),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // class _GuestTypeButton extends StatelessWidget {
// // // // // //   final IconData icon;
// // // // // //   final String label;
// // // // // //   final VoidCallback onTap;
// // // // // //   const _GuestTypeButton({
// // // // // //     required this.icon,
// // // // // //     required this.label,
// // // // // //     required this.onTap,
// // // // // //   });

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return InkWell(
// // // // // //       borderRadius: BorderRadius.circular(8),
// // // // // //       onTap: onTap,
// // // // // //       child: Container(
// // // // // //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
// // // // // //         decoration: BoxDecoration(
// // // // // //           gradient: const LinearGradient(
// // // // // //             colors: [Color(0xFF2B0030), _kPrimary],
// // // // // //           ),
// // // // // //           borderRadius: BorderRadius.circular(8),
// // // // // //         ),
// // // // // //         child: Row(
// // // // // //           mainAxisSize: MainAxisSize.min,
// // // // // //           children: [
// // // // // //             Icon(icon, color: Colors.white, size: 16),
// // // // // //             const SizedBox(width: 6),
// // // // // //             Text(
// // // // // //               label,
// // // // // //               style: const TextStyle(
// // // // // //                 color: Colors.white,
// // // // // //                 fontWeight: FontWeight.w600,
// // // // // //               ),
// // // // // //             ),
// // // // // //           ],
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // // ── Single guest form (handles single + couple) ────────────────────────────
// // // // // // class _GuestForm extends ConsumerWidget {
// // // // // //   final String eventId;
// // // // // //   final GuestEntry guest;
// // // // // //   final int index;
// // // // // //   const _GuestForm({
// // // // // //     required this.eventId,
// // // // // //     required this.guest,
// // // // // //     required this.index,
// // // // // //   });

// // // // // //   @override
// // // // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // // // //     final notifier = ref.read(eventBookingProvider(eventId).notifier);
// // // // // //     final isCouple = guest.type == GuestType.couple;
// // // // // //     final accent = isCouple ? _kBlue : _kPrimary;

// // // // // //     return Container(
// // // // // //       padding: const EdgeInsets.all(16),
// // // // // //       decoration: BoxDecoration(
// // // // // //         color: Colors.white,
// // // // // //         borderRadius: BorderRadius.circular(12),
// // // // // //         border: Border.all(color: accent.withOpacity(0.6)),
// // // // // //       ),
// // // // // //       child: Column(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //         children: [
// // // // // //           Row(
// // // // // //             children: [
// // // // // //               Expanded(
// // // // // //                 child: Text(
// // // // // //                   isCouple
// // // // // //                       ? 'Add New Couple Guest #$index'
// // // // // //                       : 'Add New Single Guest #$index',
// // // // // //                   style: TextStyle(
// // // // // //                     fontSize: 16,
// // // // // //                     fontWeight: FontWeight.w700,
// // // // // //                     color: isCouple ? _kBlue : Colors.black,
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ),
// // // // // //               InkWell(
// // // // // //                 borderRadius: BorderRadius.circular(8),
// // // // // //                 onTap: () => notifier.removeDraft(guest.id),
// // // // // //                 child: Container(
// // // // // //                   padding: const EdgeInsets.all(8),
// // // // // //                   decoration: BoxDecoration(
// // // // // //                     color: _kRed,
// // // // // //                     borderRadius: BorderRadius.circular(8),
// // // // // //                   ),
// // // // // //                   child: const Icon(
// // // // // //                     Icons.delete,
// // // // // //                     color: Colors.white,
// // // // // //                     size: 18,
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //           const SizedBox(height: 14),

// // // // // //           _memberFields(
// // // // // //             context,
// // // // // //             ref,
// // // // // //             isMember2: false,
// // // // // //             suffix: isCouple ? ' (Member 1)' : '',
// // // // // //           ),

// // // // // //           if (isCouple) ...[
// // // // // //             const SizedBox(height: 16),
// // // // // //             const Divider(),
// // // // // //             const SizedBox(height: 8),
// // // // // //             _memberFields(context, ref, isMember2: true, suffix: ' (Member 2)'),
// // // // // //           ],
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _memberFields(
// // // // // //     BuildContext context,
// // // // // //     WidgetRef ref, {
// // // // // //     required bool isMember2,
// // // // // //     required String suffix,
// // // // // //   }) {
// // // // // //     final notifier = ref.read(eventBookingProvider(eventId).notifier);
// // // // // //     final m = isMember2 ? guest.member2! : guest.member1;

// // // // // //     void upd({
// // // // // //       String? username,
// // // // // //       String? fullName,
// // // // // //       String? email,
// // // // // //       String? phone,
// // // // // //       String? idProofPath,
// // // // // //     }) => notifier.updateDraftMember(
// // // // // //       guest.id,
// // // // // //       isMember2: isMember2,
// // // // // //       username: username,
// // // // // //       fullName: fullName,
// // // // // //       email: email,
// // // // // //       phone: phone,
// // // // // //       idProofPath: idProofPath,
// // // // // //     );

// // // // // //     return _ResponsiveFieldGrid(
// // // // // //       children: [
// // // // // //         _LabeledField(
// // // // // //           label: 'Username$suffix',
// // // // // //           hint: 'Enter Username',
// // // // // //           initial: m.username,
// // // // // //           showError: m.username.trim().isEmpty,
// // // // // //           onChanged: (v) => upd(username: v),
// // // // // //         ),
// // // // // //         _LabeledField(
// // // // // //           label: 'Full Name$suffix',
// // // // // //           hint: 'Enter Full Name',
// // // // // //           info: true,
// // // // // //           initial: m.fullName,
// // // // // //           showError: m.fullName.trim().isEmpty,
// // // // // //           onChanged: (v) => upd(fullName: v),
// // // // // //         ),
// // // // // //         _LabeledField(
// // // // // //           label: 'Email$suffix',
// // // // // //           hint: 'Enter Email',
// // // // // //           keyboardType: TextInputType.emailAddress,
// // // // // //           initial: m.email,
// // // // // //           showError: m.email.trim().isEmpty,
// // // // // //           onChanged: (v) => upd(email: v),
// // // // // //         ),
// // // // // //         _LabeledField(
// // // // // //           label: 'Phone$suffix',
// // // // // //           hint: 'Enter Phone Number',
// // // // // //           keyboardType: TextInputType.phone,
// // // // // //           inputFormatters: [FilteringTextInputFormatter.digitsOnly],
// // // // // //           initial: m.phone,
// // // // // //           showError: m.phone.trim().isEmpty,
// // // // // //           onChanged: (v) => upd(phone: v),
// // // // // //         ),
// // // // // //         _FilePickerField(
// // // // // //           label: 'Id Proof$suffix',
// // // // // //           fileName: m.idProofPath,
// // // // // //           showError: (m.idProofPath?.isEmpty ?? true),
// // // // // //           onPick: () {
// // // // // //             // NOTE: real file picking needs file_picker / image_picker.
// // // // // //             // We store a placeholder name so the flow is testable.
// // // // // //             upd(
// // // // // //               idProofPath:
// // // // // //                   'id_proof_${DateTime.now().millisecondsSinceEpoch}.jpg',
// // // // // //             );
// // // // // //             ScaffoldMessenger.of(context).showSnackBar(
// // // // // //               const SnackBar(
// // // // // //                 content: Text(
// // // // // //                   'File picker not wired — placeholder saved. Add file_picker to enable.',
// // // // // //                 ),
// // // // // //               ),
// // // // // //             );
// // // // // //           },
// // // // // //         ),
// // // // // //       ],
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // // ════════════════════════════════════════════════════════════════════════
// // // // // // //  ROOM PACKAGE SECTION
// // // // // // // ════════════════════════════════════════════════════════════════════════

// // // // // // class _RoomPackageSection extends ConsumerWidget {
// // // // // //   final String eventId;
// // // // // //   final List<RoomPackage> rooms;
// // // // // //   const _RoomPackageSection({required this.eventId, required this.rooms});

// // // // // //   @override
// // // // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // // // //     final state = ref.watch(eventBookingProvider(eventId));
// // // // // //     final notifier = ref.read(eventBookingProvider(eventId).notifier);

// // // // // //     return Column(
// // // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //       children: [
// // // // // //         const Text(
// // // // // //           'Choose Your Beat Flirt Package',
// // // // // //           style: TextStyle(
// // // // // //             fontSize: 20,
// // // // // //             fontWeight: FontWeight.w700,
// // // // // //             color: _kPrimary,
// // // // // //           ),
// // // // // //         ),
// // // // // //         const SizedBox(height: 12),
// // // // // //         _CardShell(
// // // // // //           padding: EdgeInsets.zero,
// // // // // //           child: Column(
// // // // // //             children: [
// // // // // //               const _TableHeader(firstCol: 'ROOM / PACKAGE'),
// // // // // //               for (var i = 0; i < rooms.length; i++) ...[
// // // // // //                 _RoomRow(
// // // // // //                   room: rooms[i],
// // // // // //                   qty: state.roomQty[rooms[i].id] ?? 0,
// // // // // //                   onQty: (q) => notifier.setRoomQty(rooms[i].id, q),
// // // // // //                 ),
// // // // // //                 if (i != rooms.length - 1)
// // // // // //                   const Divider(height: 1, color: _kBorder),
// // // // // //               ],
// // // // // //             ],
// // // // // //           ),
// // // // // //         ),
// // // // // //       ],
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // class _RoomRow extends StatelessWidget {
// // // // // //   final RoomPackage room;
// // // // // //   final int qty;
// // // // // //   final ValueChanged<int> onQty;
// // // // // //   const _RoomRow({required this.room, required this.qty, required this.onQty});

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     final amount = (room.price + room.fee) * qty;
// // // // // //     return Padding(
// // // // // //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
// // // // // //       child: Row(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //         children: [
// // // // // //           // QTY
// // // // // //           SizedBox(
// // // // // //             width: 64,
// // // // // //             child: _QtyDropdown(
// // // // // //               value: qty,
// // // // // //               max: room.roomAvailable > 0 ? room.roomAvailable : 10,
// // // // // //               onChanged: onQty,
// // // // // //             ),
// // // // // //           ),
// // // // // //           const SizedBox(width: 10),
// // // // // //           // Image
// // // // // //           ClipRRect(
// // // // // //             borderRadius: BorderRadius.circular(8),
// // // // // //             child: SizedBox(
// // // // // //               width: 56,
// // // // // //               height: 56,
// // // // // //               child: room.roomImage.isEmpty
// // // // // //                   ? Container(color: const Color(0xFFEDE3F2))
// // // // // //                   : Image.network(
// // // // // //                       room.roomImage,
// // // // // //                       fit: BoxFit.cover,
// // // // // //                       errorBuilder: (_, __, ___) =>
// // // // // //                           Container(color: const Color(0xFFEDE3F2)),
// // // // // //                     ),
// // // // // //             ),
// // // // // //           ),
// // // // // //           const SizedBox(width: 12),
// // // // // //           // Name + desc
// // // // // //           Expanded(
// // // // // //             child: Column(
// // // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //               children: [
// // // // // //                 Text(
// // // // // //                   room.roomName,
// // // // // //                   style: const TextStyle(
// // // // // //                     fontWeight: FontWeight.w800,
// // // // // //                     color: _kPrimary,
// // // // // //                     fontSize: 14,
// // // // // //                   ),
// // // // // //                 ),
// // // // // //                 if (room.shortDescription.isNotEmpty) ...[
// // // // // //                   const SizedBox(height: 4),
// // // // // //                   Text(
// // // // // //                     room.shortDescription,
// // // // // //                     style: TextStyle(fontSize: 12.5, color: Colors.grey[700]),
// // // // // //                   ),
// // // // // //                 ],
// // // // // //               ],
// // // // // //             ),
// // // // // //           ),
// // // // // //           const SizedBox(width: 8),
// // // // // //           // Price / fee / amount
// // // // // //           _PriceTriplet(price: room.price, fee: room.fee, amount: amount),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // // ════════════════════════════════════════════════════════════════════════
// // // // // // //  ADDITIONAL NIGHTS SECTION
// // // // // // // ════════════════════════════════════════════════════════════════════════

// // // // // // class _AdditionalNightsSection extends ConsumerWidget {
// // // // // //   final String eventId;
// // // // // //   final List<AdditionalNight> nights;
// // // // // //   final double price;
// // // // // //   final double fee;
// // // // // //   const _AdditionalNightsSection({
// // // // // //     required this.eventId,
// // // // // //     required this.nights,
// // // // // //     required this.price,
// // // // // //     required this.fee,
// // // // // //   });

// // // // // //   static const _monthsLong = [
// // // // // //     'January',
// // // // // //     'February',
// // // // // //     'March',
// // // // // //     'April',
// // // // // //     'May',
// // // // // //     'June',
// // // // // //     'July',
// // // // // //     'August',
// // // // // //     'September',
// // // // // //     'October',
// // // // // //     'November',
// // // // // //     'December',
// // // // // //   ];

// // // // // //   String _fmt(AdditionalNight n) {
// // // // // //     DateTime? d;
// // // // // //     try {
// // // // // //       d = DateTime.parse(n.date);
// // // // // //     } catch (_) {}
// // // // // //     if (d == null) return '${n.day}, ${n.date}';
// // // // // //     return '${n.day}, ${_monthsLong[d.month - 1]} ${d.day}, ${d.year}';
// // // // // //   }

// // // // // //   @override
// // // // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // // // //     final state = ref.watch(eventBookingProvider(eventId));
// // // // // //     final notifier = ref.read(eventBookingProvider(eventId).notifier);

// // // // // //     return Column(
// // // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //       children: [
// // // // // //         const Text(
// // // // // //           'Select Additional Room Night Options',
// // // // // //           style: TextStyle(
// // // // // //             fontSize: 20,
// // // // // //             fontWeight: FontWeight.w700,
// // // // // //             color: _kPrimary,
// // // // // //           ),
// // // // // //         ),
// // // // // //         const SizedBox(height: 4),
// // // // // //         const Text(
// // // // // //           'Quantity will remain the same as added to the event.',
// // // // // //           style: TextStyle(
// // // // // //             color: _kRed,
// // // // // //             fontStyle: FontStyle.italic,
// // // // // //             fontSize: 13,
// // // // // //           ),
// // // // // //         ),
// // // // // //         const SizedBox(height: 12),
// // // // // //         _CardShell(
// // // // // //           padding: EdgeInsets.zero,
// // // // // //           child: Column(
// // // // // //             children: [
// // // // // //               const _TableHeader(firstCol: 'ADDITIONAL NIGHT'),
// // // // // //               for (var i = 0; i < nights.length; i++) ...[
// // // // // //                 _NightRow(
// // // // // //                   label: _fmt(nights[i]),
// // // // // //                   qty: state.nightQty[nights[i].date] ?? 0,
// // // // // //                   price: price,
// // // // // //                   fee: fee,
// // // // // //                   onQty: (q) => notifier.setNightQty(nights[i].date, q),
// // // // // //                 ),
// // // // // //                 if (i != nights.length - 1)
// // // // // //                   const Divider(height: 1, color: _kBorder),
// // // // // //               ],
// // // // // //             ],
// // // // // //           ),
// // // // // //         ),
// // // // // //       ],
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // class _NightRow extends StatelessWidget {
// // // // // //   final String label;
// // // // // //   final int qty;
// // // // // //   final double price;
// // // // // //   final double fee;
// // // // // //   final ValueChanged<int> onQty;
// // // // // //   const _NightRow({
// // // // // //     required this.label,
// // // // // //     required this.qty,
// // // // // //     required this.price,
// // // // // //     required this.fee,
// // // // // //     required this.onQty,
// // // // // //   });

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     final amount = (price + fee) * qty;
// // // // // //     // Split "Day, rest" so the weekday is bold like the screenshot.
// // // // // //     final commaIdx = label.indexOf(',');
// // // // // //     final dayPart = commaIdx == -1 ? label : label.substring(0, commaIdx);
// // // // // //     final restPart = commaIdx == -1 ? '' : label.substring(commaIdx);

// // // // // //     return Padding(
// // // // // //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
// // // // // //       child: Row(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.center,
// // // // // //         children: [
// // // // // //           SizedBox(
// // // // // //             width: 64,
// // // // // //             child: _QtyDropdown(value: qty, max: 10, onChanged: onQty),
// // // // // //           ),
// // // // // //           const SizedBox(width: 12),
// // // // // //           Expanded(
// // // // // //             child: RichText(
// // // // // //               text: TextSpan(
// // // // // //                 style: const TextStyle(color: Colors.black87, fontSize: 14),
// // // // // //                 children: [
// // // // // //                   TextSpan(
// // // // // //                     text: dayPart,
// // // // // //                     style: const TextStyle(fontWeight: FontWeight.w700),
// // // // // //                   ),
// // // // // //                   TextSpan(text: restPart),
// // // // // //                 ],
// // // // // //               ),
// // // // // //             ),
// // // // // //           ),
// // // // // //           const SizedBox(width: 8),
// // // // // //           _PriceTriplet(price: price, fee: fee, amount: amount),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // // ════════════════════════════════════════════════════════════════════════
// // // // // // //  PAYMENT + ORDER SUMMARY
// // // // // // // ════════════════════════════════════════════════════════════════════════

// // // // // // class _PaymentAndSummary extends ConsumerWidget {
// // // // // //   final String eventId;
// // // // // //   const _PaymentAndSummary({required this.eventId});

// // // // // //   @override
// // // // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // // // //     final state = ref.watch(eventBookingProvider(eventId));
// // // // // //     final notifier = ref.read(eventBookingProvider(eventId).notifier);

// // // // // //     return LayoutBuilder(
// // // // // //       builder: (ctx, c) {
// // // // // //         final wide = c.maxWidth > 640;
// // // // // //         final payment = _PaymentTypeCard(eventId: eventId, state: state);
// // // // // //         final summary = _OrderSummaryCard(eventId: eventId);

// // // // // //         if (wide) {
// // // // // //           return Row(
// // // // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //             children: [
// // // // // //               Expanded(child: payment),
// // // // // //               const SizedBox(width: 16),
// // // // // //               Expanded(child: summary),
// // // // // //             ],
// // // // // //           );
// // // // // //         }
// // // // // //         return Column(children: [payment, const SizedBox(height: 16), summary]);
// // // // // //       },
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // class _PaymentTypeCard extends ConsumerWidget {
// // // // // //   final String eventId;
// // // // // //   final EventBookingState state;
// // // // // //   const _PaymentTypeCard({required this.eventId, required this.state});

// // // // // //   @override
// // // // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // // // //     final notifier = ref.read(eventBookingProvider(eventId).notifier);
// // // // // //     return _CardShell(
// // // // // //       child: Column(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //         children: [
// // // // // //           const Text(
// // // // // //             'Select Payment Type',
// // // // // //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
// // // // // //           ),
// // // // // //           const Divider(),
// // // // // //           Row(
// // // // // //             children: [
// // // // // //               _radio(
// // // // // //                 context,
// // // // // //                 'Full Payment',
// // // // // //                 PaymentType.full,
// // // // // //                 state.paymentType,
// // // // // //                 () => notifier.setPaymentType(PaymentType.full),
// // // // // //               ),
// // // // // //               const SizedBox(width: 24),
// // // // // //               _radio(
// // // // // //                 context,
// // // // // //                 'Partial Payment',
// // // // // //                 PaymentType.partial,
// // // // // //                 state.paymentType,
// // // // // //                 () => notifier.setPaymentType(PaymentType.partial),
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //           const SizedBox(height: 8),
// // // // // //           if (state.paymentType == PaymentType.partial)
// // // // // //             Text(
// // // // // //               'Partial: pay a deposit now, balance later.',
// // // // // //               style: TextStyle(color: Colors.grey[600], fontSize: 12.5),
// // // // // //             ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _radio(
// // // // // //     BuildContext context,
// // // // // //     String label,
// // // // // //     PaymentType value,
// // // // // //     PaymentType? group,
// // // // // //     VoidCallback onTap,
// // // // // //   ) {
// // // // // //     return InkWell(
// // // // // //       onTap: onTap,
// // // // // //       borderRadius: BorderRadius.circular(8),
// // // // // //       child: Row(
// // // // // //         mainAxisSize: MainAxisSize.min,
// // // // // //         children: [
// // // // // //           Radio<PaymentType>(
// // // // // //             value: value,
// // // // // //             groupValue: group,
// // // // // //             onChanged: (_) => onTap(),
// // // // // //             activeColor: _kPrimary,
// // // // // //           ),
// // // // // //           Text(label),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // class _OrderSummaryCard extends ConsumerStatefulWidget {
// // // // // //   final String eventId;
// // // // // //   const _OrderSummaryCard({required this.eventId});

// // // // // //   @override
// // // // // //   ConsumerState<_OrderSummaryCard> createState() => _OrderSummaryCardState();
// // // // // // }

// // // // // // class _OrderSummaryCardState extends ConsumerState<_OrderSummaryCard> {
// // // // // //   final _voucherCtrl = TextEditingController();

// // // // // //   @override
// // // // // //   void dispose() {
// // // // // //     _voucherCtrl.dispose();
// // // // // //     super.dispose();
// // // // // //   }

// // // // // //   String _money(double v) {
// // // // // //     if (v == v.roundToDouble()) return '\$${v.toInt()}';
// // // // // //     return '\$${v.toStringAsFixed(2)}';
// // // // // //   }

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     final state = ref.watch(eventBookingProvider(widget.eventId));
// // // // // //     final notifier = ref.read(eventBookingProvider(widget.eventId).notifier);

// // // // // //     return _CardShell(
// // // // // //       borderColor: _kBlue.withOpacity(0.5),
// // // // // //       child: Column(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //         children: [
// // // // // //           const Text(
// // // // // //             'Order Summary',
// // // // // //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
// // // // // //           ),
// // // // // //           const Divider(),
// // // // // //           // Voucher input + Apply.
// // // // // //           Row(
// // // // // //             children: [
// // // // // //               Expanded(
// // // // // //                 child: TextField(
// // // // // //                   controller: _voucherCtrl,
// // // // // //                   onChanged: notifier.setVoucherCode,
// // // // // //                   decoration: InputDecoration(
// // // // // //                     isDense: true,
// // // // // //                     contentPadding: const EdgeInsets.symmetric(
// // // // // //                       horizontal: 12,
// // // // // //                       vertical: 12,
// // // // // //                     ),
// // // // // //                     filled: true,
// // // // // //                     fillColor: Colors.white,
// // // // // //                     border: OutlineInputBorder(
// // // // // //                       borderRadius: BorderRadius.circular(8),
// // // // // //                       borderSide: const BorderSide(color: _kBorder),
// // // // // //                     ),
// // // // // //                     enabledBorder: OutlineInputBorder(
// // // // // //                       borderRadius: BorderRadius.circular(8),
// // // // // //                       borderSide: const BorderSide(color: _kBorder),
// // // // // //                     ),
// // // // // //                     hintText: 'Voucher code',
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ),
// // // // // //               const SizedBox(width: 8),
// // // // // //               ElevatedButton(
// // // // // //                 onPressed: () {
// // // // // //                   final msg = notifier.applyVoucher();
// // // // // //                   ScaffoldMessenger.of(
// // // // // //                     context,
// // // // // //                   ).showSnackBar(SnackBar(content: Text(msg)));
// // // // // //                 },
// // // // // //                 style: ElevatedButton.styleFrom(
// // // // // //                   backgroundColor: Colors.black,
// // // // // //                   foregroundColor: Colors.white,
// // // // // //                   shape: RoundedRectangleBorder(
// // // // // //                     borderRadius: BorderRadius.circular(8),
// // // // // //                   ),
// // // // // //                   padding: const EdgeInsets.symmetric(
// // // // // //                     horizontal: 20,
// // // // // //                     vertical: 14,
// // // // // //                   ),
// // // // // //                 ),
// // // // // //                 child: const Text('Apply'),
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //           const SizedBox(height: 16),
// // // // // //           _summaryRow('Sub Total', _money(state.subTotal), valueColor: _kBlue),
// // // // // //           _summaryRow(
// // // // // //             'Membership Discount',
// // // // // //             '-${_money(state.membershipDiscount)}',
// // // // // //             labelColor: _kRed,
// // // // // //             valueColor: _kRed,
// // // // // //           ),
// // // // // //           _summaryRow(
// // // // // //             'Voucher Discount',
// // // // // //             '-${_money(state.voucherDiscount)}',
// // // // // //             labelColor: _kGreen,
// // // // // //             valueColor: _kGreen,
// // // // // //           ),
// // // // // //           const Divider(),
// // // // // //           Row(
// // // // // //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // //             children: [
// // // // // //               const Text(
// // // // // //                 'Total',
// // // // // //                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
// // // // // //               ),
// // // // // //               Text(
// // // // // //                 _money(state.total),
// // // // // //                 style: const TextStyle(
// // // // // //                   fontSize: 22,
// // // // // //                   fontWeight: FontWeight.w800,
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //           const SizedBox(height: 16),
// // // // // //           SizedBox(
// // // // // //             width: double.infinity,
// // // // // //             height: 52,
// // // // // //             child: ElevatedButton(
// // // // // //               onPressed: state.submitting
// // // // // //                   ? null
// // // // // //                   : () async {
// // // // // //                       final err = await notifier.buyTicket();
// // // // // //                       if (!context.mounted) return;
// // // // // //                       ScaffoldMessenger.of(context).showSnackBar(
// // // // // //                         SnackBar(
// // // // // //                           content: Text(
// // // // // //                             err ??
// // // // // //                                 'Booking confirmed (stub) — total ${_money(state.total)}',
// // // // // //                           ),
// // // // // //                           backgroundColor: err == null ? _kGreen : _kRed,
// // // // // //                         ),
// // // // // //                       );
// // // // // //                     },
// // // // // //               style: ElevatedButton.styleFrom(
// // // // // //                 padding: EdgeInsets.zero,
// // // // // //                 backgroundColor: Colors.transparent,
// // // // // //                 shadowColor: Colors.transparent,
// // // // // //                 shape: RoundedRectangleBorder(
// // // // // //                   borderRadius: BorderRadius.circular(10),
// // // // // //                 ),
// // // // // //               ),
// // // // // //               child: Ink(
// // // // // //                 decoration: BoxDecoration(
// // // // // //                   gradient: const LinearGradient(
// // // // // //                     colors: [_kPink, _kPrimary],
// // // // // //                     begin: Alignment.topCenter,
// // // // // //                     end: Alignment.bottomCenter,
// // // // // //                   ),
// // // // // //                   borderRadius: BorderRadius.circular(10),
// // // // // //                 ),
// // // // // //                 child: Center(
// // // // // //                   child: state.submitting
// // // // // //                       ? const SizedBox(
// // // // // //                           width: 22,
// // // // // //                           height: 22,
// // // // // //                           child: CircularProgressIndicator(
// // // // // //                             strokeWidth: 2,
// // // // // //                             color: Colors.white,
// // // // // //                           ),
// // // // // //                         )
// // // // // //                       : const Text(
// // // // // //                           'BUY TICKET',
// // // // // //                           style: TextStyle(
// // // // // //                             color: Colors.white,
// // // // // //                             fontWeight: FontWeight.w800,
// // // // // //                             letterSpacing: 0.5,
// // // // // //                           ),
// // // // // //                         ),
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _summaryRow(
// // // // // //     String label,
// // // // // //     String value, {
// // // // // //     Color? labelColor,
// // // // // //     Color? valueColor,
// // // // // //   }) {
// // // // // //     return Padding(
// // // // // //       padding: const EdgeInsets.symmetric(vertical: 4),
// // // // // //       child: Row(
// // // // // //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // //         children: [
// // // // // //           Text(
// // // // // //             label,
// // // // // //             style: TextStyle(
// // // // // //               color: labelColor,
// // // // // //               fontStyle: labelColor != null
// // // // // //                   ? FontStyle.italic
// // // // // //                   : FontStyle.normal,
// // // // // //             ),
// // // // // //           ),
// // // // // //           Text(value, style: TextStyle(color: valueColor)),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // // ════════════════════════════════════════════════════════════════════════
// // // // // // //  REUSABLE WIDGETS
// // // // // // // ════════════════════════════════════════════════════════════════════════

// // // // // // class _CardShell extends StatelessWidget {
// // // // // //   final Widget child;
// // // // // //   final EdgeInsets padding;
// // // // // //   final Color? borderColor;
// // // // // //   const _CardShell({
// // // // // //     required this.child,
// // // // // //     this.padding = const EdgeInsets.all(16),
// // // // // //     this.borderColor,
// // // // // //   });

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return Container(
// // // // // //       width: double.infinity,
// // // // // //       padding: padding,
// // // // // //       decoration: BoxDecoration(
// // // // // //         color: Colors.white,
// // // // // //         borderRadius: BorderRadius.circular(16),
// // // // // //         border: Border.all(color: borderColor ?? _kBorder),
// // // // // //       ),
// // // // // //       child: child,
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // class _PrimaryButton extends StatelessWidget {
// // // // // //   final String label;
// // // // // //   final VoidCallback onTap;
// // // // // //   const _PrimaryButton({required this.label, required this.onTap});

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return InkWell(
// // // // // //       borderRadius: BorderRadius.circular(8),
// // // // // //       onTap: onTap,
// // // // // //       child: Container(
// // // // // //         padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
// // // // // //         decoration: BoxDecoration(
// // // // // //           gradient: const LinearGradient(
// // // // // //             colors: [Color(0xFF2B0030), _kPrimary],
// // // // // //           ),
// // // // // //           borderRadius: BorderRadius.circular(8),
// // // // // //         ),
// // // // // //         child: Text(
// // // // // //           label,
// // // // // //           style: const TextStyle(
// // // // // //             color: Colors.white,
// // // // // //             fontWeight: FontWeight.w700,
// // // // // //           ),
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // class _TableHeader extends StatelessWidget {
// // // // // //   final String firstCol;
// // // // // //   const _TableHeader({required this.firstCol});

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     const style = TextStyle(
// // // // // //       fontWeight: FontWeight.w700,
// // // // // //       color: Colors.black87,
// // // // // //       fontSize: 13,
// // // // // //     );
// // // // // //     return Container(
// // // // // //       padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
// // // // // //       decoration: const BoxDecoration(
// // // // // //         border: Border(bottom: BorderSide(color: _kBorder)),
// // // // // //       ),
// // // // // //       child: Row(
// // // // // //         children: [
// // // // // //           const SizedBox(width: 64, child: Text('QTY', style: style)),
// // // // // //           const SizedBox(width: 10),
// // // // // //           Expanded(child: Text(firstCol, style: style)),
// // // // // //           const SizedBox(
// // // // // //             width: 70,
// // // // // //             child: Text('PRICE', style: style, textAlign: TextAlign.right),
// // // // // //           ),
// // // // // //           const SizedBox(
// // // // // //             width: 56,
// // // // // //             child: Text('FEE', style: style, textAlign: TextAlign.right),
// // // // // //           ),
// // // // // //           const SizedBox(
// // // // // //             width: 70,
// // // // // //             child: Text('AMOUNT', style: style, textAlign: TextAlign.right),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // class _PriceTriplet extends StatelessWidget {
// // // // // //   final double price;
// // // // // //   final double fee;
// // // // // //   final double amount;
// // // // // //   const _PriceTriplet({
// // // // // //     required this.price,
// // // // // //     required this.fee,
// // // // // //     required this.amount,
// // // // // //   });

// // // // // //   String _m(double v) =>
// // // // // //       v == v.roundToDouble() ? '\$${v.toInt()}' : '\$${v.toStringAsFixed(2)}';

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return Row(
// // // // // //       children: [
// // // // // //         SizedBox(
// // // // // //           width: 70,
// // // // // //           child: Text(
// // // // // //             _m(price),
// // // // // //             textAlign: TextAlign.right,
// // // // // //             style: const TextStyle(fontWeight: FontWeight.w600),
// // // // // //           ),
// // // // // //         ),
// // // // // //         SizedBox(
// // // // // //           width: 56,
// // // // // //           child: Text(
// // // // // //             _m(fee),
// // // // // //             textAlign: TextAlign.right,
// // // // // //             style: const TextStyle(color: Colors.black87),
// // // // // //           ),
// // // // // //         ),
// // // // // //         SizedBox(
// // // // // //           width: 70,
// // // // // //           child: Text(
// // // // // //             _m(amount),
// // // // // //             textAlign: TextAlign.right,
// // // // // //             style: const TextStyle(fontWeight: FontWeight.w800),
// // // // // //           ),
// // // // // //         ),
// // // // // //       ],
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // class _QtyDropdown extends StatelessWidget {
// // // // // //   final int value;
// // // // // //   final int max;
// // // // // //   final ValueChanged<int> onChanged;
// // // // // //   const _QtyDropdown({
// // // // // //     required this.value,
// // // // // //     required this.max,
// // // // // //     required this.onChanged,
// // // // // //   });

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     final items = List<int>.generate(max + 1, (i) => i);
// // // // // //     return Container(
// // // // // //       padding: const EdgeInsets.symmetric(horizontal: 8),
// // // // // //       decoration: BoxDecoration(
// // // // // //         border: Border.all(color: _kBorder),
// // // // // //         borderRadius: BorderRadius.circular(8),
// // // // // //       ),
// // // // // //       child: DropdownButtonHideUnderline(
// // // // // //         child: DropdownButton<int>(
// // // // // //           value: value.clamp(0, max),
// // // // // //           isDense: true,
// // // // // //           isExpanded: true,
// // // // // //           items: items
// // // // // //               .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
// // // // // //               .toList(),
// // // // // //           onChanged: (v) => onChanged(v ?? 0),
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // /// Lays out fields 2-per-row when wide, 1-per-row when narrow.
// // // // // // class _ResponsiveFieldGrid extends StatelessWidget {
// // // // // //   final List<Widget> children;
// // // // // //   const _ResponsiveFieldGrid({required this.children});

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return LayoutBuilder(
// // // // // //       builder: (ctx, c) {
// // // // // //         final cols = c.maxWidth > 560 ? 2 : 1;
// // // // // //         const gap = 14.0;
// // // // // //         final itemWidth = cols == 2 ? (c.maxWidth - gap) / 2 : c.maxWidth;
// // // // // //         return Wrap(
// // // // // //           spacing: gap,
// // // // // //           runSpacing: gap,
// // // // // //           children: children
// // // // // //               .map((w) => SizedBox(width: itemWidth, child: w))
// // // // // //               .toList(),
// // // // // //         );
// // // // // //       },
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // class _LabeledField extends StatefulWidget {
// // // // // //   final String label;
// // // // // //   final String hint;
// // // // // //   final String initial;
// // // // // //   final bool info;
// // // // // //   final bool showError;
// // // // // //   final TextInputType? keyboardType;
// // // // // //   final List<TextInputFormatter>? inputFormatters;
// // // // // //   final ValueChanged<String> onChanged;

// // // // // //   const _LabeledField({
// // // // // //     required this.label,
// // // // // //     required this.hint,
// // // // // //     required this.onChanged,
// // // // // //     this.initial = '',
// // // // // //     this.info = false,
// // // // // //     this.showError = false,
// // // // // //     this.keyboardType,
// // // // // //     this.inputFormatters,
// // // // // //   });

// // // // // //   @override
// // // // // //   State<_LabeledField> createState() => _LabeledFieldState();
// // // // // // }

// // // // // // class _LabeledFieldState extends State<_LabeledField> {
// // // // // //   late final TextEditingController _ctrl = TextEditingController(
// // // // // //     text: widget.initial,
// // // // // //   );

// // // // // //   @override
// // // // // //   void didUpdateWidget(covariant _LabeledField old) {
// // // // // //     super.didUpdateWidget(old);
// // // // // //     // Keep external prefill (e.g. "generate my info") in sync.
// // // // // //     if (widget.initial != _ctrl.text && widget.initial.isNotEmpty) {
// // // // // //       _ctrl.text = widget.initial;
// // // // // //       _ctrl.selection = TextSelection.collapsed(offset: _ctrl.text.length);
// // // // // //     }
// // // // // //   }

// // // // // //   @override
// // // // // //   void dispose() {
// // // // // //     _ctrl.dispose();
// // // // // //     super.dispose();
// // // // // //   }

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return Column(
// // // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //       children: [
// // // // // //         Row(
// // // // // //           children: [
// // // // // //             Text(
// // // // // //               widget.label,
// // // // // //               style: const TextStyle(fontWeight: FontWeight.w700),
// // // // // //             ),
// // // // // //             if (widget.info) ...[
// // // // // //               const SizedBox(width: 4),
// // // // // //               const Icon(Icons.info, size: 14, color: Colors.black54),
// // // // // //             ],
// // // // // //           ],
// // // // // //         ),
// // // // // //         const SizedBox(height: 6),
// // // // // //         TextField(
// // // // // //           controller: _ctrl,
// // // // // //           keyboardType: widget.keyboardType,
// // // // // //           inputFormatters: widget.inputFormatters,
// // // // // //           onChanged: widget.onChanged,
// // // // // //           decoration: InputDecoration(
// // // // // //             hintText: widget.hint,
// // // // // //             isDense: true,
// // // // // //             filled: true,
// // // // // //             fillColor: _kFieldFill,
// // // // // //             contentPadding: const EdgeInsets.symmetric(
// // // // // //               horizontal: 12,
// // // // // //               vertical: 14,
// // // // // //             ),
// // // // // //             border: OutlineInputBorder(
// // // // // //               borderRadius: BorderRadius.circular(8),
// // // // // //               borderSide: const BorderSide(color: _kBorder),
// // // // // //             ),
// // // // // //             enabledBorder: OutlineInputBorder(
// // // // // //               borderRadius: BorderRadius.circular(8),
// // // // // //               borderSide: const BorderSide(color: _kBorder),
// // // // // //             ),
// // // // // //             focusedBorder: OutlineInputBorder(
// // // // // //               borderRadius: BorderRadius.circular(8),
// // // // // //               borderSide: const BorderSide(color: _kPrimary),
// // // // // //             ),
// // // // // //           ),
// // // // // //         ),
// // // // // //         if (widget.showError)
// // // // // //           const Padding(
// // // // // //             padding: EdgeInsets.only(top: 4),
// // // // // //             child: Text(
// // // // // //               'This Field is required',
// // // // // //               style: TextStyle(color: _kRed, fontSize: 12),
// // // // // //             ),
// // // // // //           ),
// // // // // //       ],
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // class _FilePickerField extends StatelessWidget {
// // // // // //   final String label;
// // // // // //   final String? fileName;
// // // // // //   final bool showError;
// // // // // //   final VoidCallback onPick;

// // // // // //   const _FilePickerField({
// // // // // //     required this.label,
// // // // // //     required this.fileName,
// // // // // //     required this.showError,
// // // // // //     required this.onPick,
// // // // // //   });

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     final hasFile = (fileName?.isNotEmpty ?? false);
// // // // // //     return Column(
// // // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //       children: [
// // // // // //         Row(
// // // // // //           children: [
// // // // // //             Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
// // // // // //             const SizedBox(width: 4),
// // // // // //             const Icon(Icons.info, size: 14, color: Colors.black54),
// // // // // //           ],
// // // // // //         ),
// // // // // //         const SizedBox(height: 6),
// // // // // //         InkWell(
// // // // // //           onTap: onPick,
// // // // // //           borderRadius: BorderRadius.circular(8),
// // // // // //           child: Container(
// // // // // //             decoration: BoxDecoration(
// // // // // //               border: Border.all(color: _kBorder),
// // // // // //               borderRadius: BorderRadius.circular(8),
// // // // // //             ),
// // // // // //             child: Row(
// // // // // //               children: [
// // // // // //                 Container(
// // // // // //                   padding: const EdgeInsets.symmetric(
// // // // // //                     horizontal: 14,
// // // // // //                     vertical: 14,
// // // // // //                   ),
// // // // // //                   decoration: const BoxDecoration(
// // // // // //                     color: Color(0xFFEFEFEF),
// // // // // //                     borderRadius: BorderRadius.only(
// // // // // //                       topLeft: Radius.circular(8),
// // // // // //                       bottomLeft: Radius.circular(8),
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                   child: const Text('Choose file'),
// // // // // //                 ),
// // // // // //                 Expanded(
// // // // // //                   child: Padding(
// // // // // //                     padding: const EdgeInsets.symmetric(horizontal: 12),
// // // // // //                     child: Text(
// // // // // //                       hasFile ? fileName! : 'No file chosen',
// // // // // //                       overflow: TextOverflow.ellipsis,
// // // // // //                       style: TextStyle(
// // // // // //                         color: hasFile ? Colors.black : Colors.grey[600],
// // // // // //                       ),
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ],
// // // // // //             ),
// // // // // //           ),
// // // // // //         ),
// // // // // //         if (showError)
// // // // // //           const Padding(
// // // // // //             padding: EdgeInsets.only(top: 4),
// // // // // //             child: Text(
// // // // // //               'This Field is required',
// // // // // //               style: TextStyle(color: _kRed, fontSize: 12),
// // // // // //             ),
// // // // // //           ),
// // // // // //       ],
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // // ════════════════════════════════════════════════════════════════════════
// // // // // // //  MODELS for  POST  /App/events/get_single_events   (event_id: "41")
// // // // // // //
// // // // // // //  Response shape:
// // // // // // //  {
// // // // // // //    "status": "200",
// // // // // // //    "data":   { ...event... },
// // // // // // //    "additional_night": [ { date, day }, ... ],
// // // // // // //    "room_list": { "status": "200", "data": [ { ...room... } ] }
// // // // // // //  }
// // // // // // // ════════════════════════════════════════════════════════════════════════

// // // // // // /// Cleans the double HTML-encoded strings the API returns
// // // // // // /// (e.g. "&amp;lt;p&amp;gt;Hello&amp;lt;/p&amp;gt;" -> "Hello").
// // // // // // String cleanHtml(String? input) {
// // // // // //   if (input == null || input.isEmpty) return '';
// // // // // //   var s = input;
// // // // // //   // Two decode passes handle the API's double-encoding.
// // // // // //   for (var i = 0; i < 2; i++) {
// // // // // //     s = s
// // // // // //         .replaceAll('&amp;', '&')
// // // // // //         .replaceAll('&lt;', '<')
// // // // // //         .replaceAll('&gt;', '>')
// // // // // //         .replaceAll('&quot;', '"')
// // // // // //         .replaceAll('&#39;', "'")
// // // // // //         .replaceAll('&nbsp;', ' ');
// // // // // //   }
// // // // // //   s = s.replaceAll(RegExp(r'<[^>]*>'), ' '); // strip tags
// // // // // //   s = s.replaceAll(RegExp(r'\s+'), ' ').trim();
// // // // // //   return s;
// // // // // // }

// // // // // // String _str(dynamic v) => v?.toString() ?? '';

// // // // // // int _int(dynamic v) => int.tryParse(_str(v)) ?? 0;

// // // // // // double _double(dynamic v) => double.tryParse(_str(v)) ?? 0;

// // // // // // // ─────────────────────────────────────────────────────────────────────────
// // // // // // //  Full response wrapper
// // // // // // // ─────────────────────────────────────────────────────────────────────────
// // // // // // class SingleEventDetail {
// // // // // //   final EventDetail event;
// // // // // //   final List<AdditionalNight> additionalNights;
// // // // // //   final List<RoomPackage> rooms;

// // // // // //   const SingleEventDetail({
// // // // // //     required this.event,
// // // // // //     this.additionalNights = const [],
// // // // // //     this.rooms = const [],
// // // // // //   });

// // // // // //   factory SingleEventDetail.fromJson(Map<String, dynamic> json) {
// // // // // //     final data = (json['data'] is Map<String, dynamic>)
// // // // // //         ? json['data'] as Map<String, dynamic>
// // // // // //         : <String, dynamic>{};

// // // // // //     final nightsRaw = json['additional_night'];
// // // // // //     final nights = (nightsRaw is List)
// // // // // //         ? nightsRaw
// // // // // //               .whereType<Map<String, dynamic>>()
// // // // // //               .map(AdditionalNight.fromJson)
// // // // // //               .toList()
// // // // // //         : <AdditionalNight>[];

// // // // // //     final roomList = json['room_list'];
// // // // // //     final roomsRaw = (roomList is Map<String, dynamic>)
// // // // // //         ? roomList['data']
// // // // // //         : null;
// // // // // //     final rooms = (roomsRaw is List)
// // // // // //         ? roomsRaw
// // // // // //               .whereType<Map<String, dynamic>>()
// // // // // //               .map(RoomPackage.fromJson)
// // // // // //               .toList()
// // // // // //         : <RoomPackage>[];

// // // // // //     return SingleEventDetail(
// // // // // //       event: EventDetail.fromJson(data),
// // // // // //       additionalNights: nights,
// // // // // //       rooms: rooms,
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // // ─────────────────────────────────────────────────────────────────────────
// // // // // // //  Event detail
// // // // // // // ─────────────────────────────────────────────────────────────────────────
// // // // // // class EventDetail {
// // // // // //   final String id;
// // // // // //   final String eventName;
// // // // // //   final String eventFromDate;
// // // // // //   final String eventToDate;
// // // // // //   final String eventFromTime;
// // // // // //   final String eventToTime;
// // // // // //   final String eventType;
// // // // // //   final double additionalRoomNightPrice;
// // // // // //   final double additionalRoomNightFee;

// // // // // //   final String coupleMaleFemaleSwingers;
// // // // // //   final String coupleFemaleFemaleSwingers;
// // // // // //   final String coupleMaleMaleSwingers;
// // // // // //   final String coupleMaleSwingers;
// // // // // //   final String coupleFemaleSwingers;
// // // // // //   final String coupleTransgenderSwingers;

// // // // // //   final String eventLocation;
// // // // // //   final String lat;
// // // // // //   final String lng;
// // // // // //   final String cityName;
// // // // // //   final String mapUrl;
// // // // // //   final String formattedAddress;
// // // // // //   final String eventImage;
// // // // // //   final double eventPrice;
// // // // // //   final int eventNoOfTicket;
// // // // // //   final String eventEmail;
// // // // // //   final String eventDescription; // already cleaned

// // // // // //   const EventDetail({
// // // // // //     this.id = '',
// // // // // //     this.eventName = '',
// // // // // //     this.eventFromDate = '',
// // // // // //     this.eventToDate = '',
// // // // // //     this.eventFromTime = '',
// // // // // //     this.eventToTime = '',
// // // // // //     this.eventType = '',
// // // // // //     this.additionalRoomNightPrice = 0,
// // // // // //     this.additionalRoomNightFee = 0,
// // // // // //     this.coupleMaleFemaleSwingers = '0',
// // // // // //     this.coupleFemaleFemaleSwingers = '0',
// // // // // //     this.coupleMaleMaleSwingers = '0',
// // // // // //     this.coupleMaleSwingers = '0',
// // // // // //     this.coupleFemaleSwingers = '0',
// // // // // //     this.coupleTransgenderSwingers = '0',
// // // // // //     this.eventLocation = '',
// // // // // //     this.lat = '',
// // // // // //     this.lng = '',
// // // // // //     this.cityName = '',
// // // // // //     this.mapUrl = '',
// // // // // //     this.formattedAddress = '',
// // // // // //     this.eventImage = '',
// // // // // //     this.eventPrice = 0,
// // // // // //     this.eventNoOfTicket = 0,
// // // // // //     this.eventEmail = '',
// // // // // //     this.eventDescription = '',
// // // // // //   });

// // // // // //   factory EventDetail.fromJson(Map<String, dynamic> j) => EventDetail(
// // // // // //     id: _str(j['id']),
// // // // // //     eventName: _str(j['event_name']),
// // // // // //     eventFromDate: _str(j['event_from_date']),
// // // // // //     eventToDate: _str(j['event_to_date']),
// // // // // //     eventFromTime: _str(j['event_from_time']),
// // // // // //     eventToTime: _str(j['event_to_time']),
// // // // // //     eventType: _str(j['event_type']),
// // // // // //     additionalRoomNightPrice: _double(j['additional_room_night_price']),
// // // // // //     additionalRoomNightFee: _double(j['additional_room_night_fee']),
// // // // // //     coupleMaleFemaleSwingers: _str(j['couple_male_female_swingers']),
// // // // // //     coupleFemaleFemaleSwingers: _str(j['couple_female_female_swingers']),
// // // // // //     coupleMaleMaleSwingers: _str(j['couple_male_male_swingers']),
// // // // // //     coupleMaleSwingers: _str(j['couple_male_swingers']),
// // // // // //     coupleFemaleSwingers: _str(j['couple_female_swingers']),
// // // // // //     coupleTransgenderSwingers: _str(j['couple_transgender_swingers']),
// // // // // //     eventLocation: _str(j['event_location']),
// // // // // //     lat: _str(j['lat']),
// // // // // //     lng: _str(j['lng']),
// // // // // //     cityName: _str(j['city_name']),
// // // // // //     mapUrl: _str(j['map_url']),
// // // // // //     formattedAddress: _str(j['formatted_address']),
// // // // // //     eventImage: _str(j['event_image']),
// // // // // //     eventPrice: _double(j['event_price']),
// // // // // //     eventNoOfTicket: _int(j['event_no_of_ticket']),
// // // // // //     eventEmail: _str(j['event_email']),
// // // // // //     eventDescription: cleanHtml(_str(j['event_description'])),
// // // // // //   );
// // // // // // }

// // // // // // // ─────────────────────────────────────────────────────────────────────────
// // // // // // //  Additional night
// // // // // // // ─────────────────────────────────────────────────────────────────────────
// // // // // // class AdditionalNight {
// // // // // //   final String date; // "2029-02-25"
// // // // // //   final String day; // "Sunday"

// // // // // //   const AdditionalNight({this.date = '', this.day = ''});

// // // // // //   factory AdditionalNight.fromJson(Map<String, dynamic> j) =>
// // // // // //       AdditionalNight(date: _str(j['date']), day: _str(j['day']));
// // // // // // }

// // // // // // // ─────────────────────────────────────────────────────────────────────────
// // // // // // //  Room / package
// // // // // // // ─────────────────────────────────────────────────────────────────────────
// // // // // // class RoomPackage {
// // // // // //   final String id;
// // // // // //   final String roomName;
// // // // // //   final double price;
// // // // // //   final double fee;
// // // // // //   final String fullDescription; // cleaned
// // // // // //   final String shortDescription; // cleaned
// // // // // //   final int roomAvailable;
// // // // // //   final String roomImage;

// // // // // //   const RoomPackage({
// // // // // //     this.id = '',
// // // // // //     this.roomName = '',
// // // // // //     this.price = 0,
// // // // // //     this.fee = 0,
// // // // // //     this.fullDescription = '',
// // // // // //     this.shortDescription = '',
// // // // // //     this.roomAvailable = 0,
// // // // // //     this.roomImage = '',
// // // // // //   });

// // // // // //   factory RoomPackage.fromJson(Map<String, dynamic> j) => RoomPackage(
// // // // // //     id: _str(j['id']),
// // // // // //     roomName: _str(j['room_name']),
// // // // // //     price: _double(j['price']),
// // // // // //     fee: _double(j['fee']),
// // // // // //     fullDescription: cleanHtml(_str(j['full_description'])),
// // // // // //     shortDescription: cleanHtml(_str(j['short_description'])),
// // // // // //     roomAvailable: _int(j['room_available']),
// // // // // //     roomImage: _str(j['room_image']),
// // // // // //   );
// // // // // // }

// // // // // // =============================================================================
// // // // // //  event_detail_page.dart
// // // // // //  Beat Flirt — Single-file merge of all models, repository, providers,
// // // // // //  screen and widgets.
// // // // // //
// // // // // //  Dependencies (pubspec.yaml):
// // // // // //    flutter_riverpod: ^2.5.1
// // // // // //    http: ^1.2.1
// // // // // //
// // // // // //  Usage:
// // // // // //    Navigator.push(context, MaterialPageRoute(
// // // // // //      builder: (_) => EventDetailScreen(eventId: '41', token: 'YOUR_TOKEN'),
// // // // // //    ));
// // // // // // =============================================================================

// // // // // import 'dart:convert';
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // import 'package:http/http.dart' as http;
// // // // // import 'package:beatflirt/core/services/auth_services.dart';

// // // // // // ═════════════════════════════════════════════════════════════════════════════
// // // // // // SECTION 1 — MODELS
// // // // // // ═════════════════════════════════════════════════════════════════════════════

// // // // // class EventDetailResponse {
// // // // //   final String status;
// // // // //   final EventData data;
// // // // //   final List<AdditionalNight> additionalNights;
// // // // //   final RoomListResponse roomList;

// // // // //   EventDetailResponse({
// // // // //     required this.status,
// // // // //     required this.data,
// // // // //     required this.additionalNights,
// // // // //     required this.roomList,
// // // // //   });

// // // // //   factory EventDetailResponse.fromJson(Map<String, dynamic> json) {
// // // // //     return EventDetailResponse(
// // // // //       status: json['status'] ?? '',
// // // // //       data: EventData.fromJson(json['data'] ?? {}),
// // // // //       additionalNights: (json['additional_night'] as List<dynamic>? ?? [])
// // // // //           .map((e) => AdditionalNight.fromJson(e))
// // // // //           .toList(),
// // // // //       roomList: RoomListResponse.fromJson(json['room_list'] ?? {}),
// // // // //     );
// // // // //   }
// // // // // }

// // // // // class EventData {
// // // // //   final String id;
// // // // //   final String eventName;
// // // // //   final String eventFromDate;
// // // // //   final String eventToDate;
// // // // //   final String eventFromTime;
// // // // //   final String eventToTime;
// // // // //   final String eventType;
// // // // //   final String additionalRoomNightPrice;
// // // // //   final String additionalRoomNightFee;
// // // // //   final String formattedAddress;
// // // // //   final String eventImage;
// // // // //   final String eventPrice;
// // // // //   final String eventNoOfTicket;
// // // // //   final String eventEmail;
// // // // //   final String eventDescription;
// // // // //   final String status;
// // // // //   final String lat;
// // // // //   final String lng;
// // // // //   final String cityName;

// // // // //   EventData({
// // // // //     required this.id,
// // // // //     required this.eventName,
// // // // //     required this.eventFromDate,
// // // // //     required this.eventToDate,
// // // // //     required this.eventFromTime,
// // // // //     required this.eventToTime,
// // // // //     required this.eventType,
// // // // //     required this.additionalRoomNightPrice,
// // // // //     required this.additionalRoomNightFee,
// // // // //     required this.formattedAddress,
// // // // //     required this.eventImage,
// // // // //     required this.eventPrice,
// // // // //     required this.eventNoOfTicket,
// // // // //     required this.eventEmail,
// // // // //     required this.eventDescription,
// // // // //     required this.status,
// // // // //     required this.lat,
// // // // //     required this.lng,
// // // // //     required this.cityName,
// // // // //   });

// // // // //   factory EventData.fromJson(Map<String, dynamic> json) {
// // // // //     return EventData(
// // // // //       id: json['id'] ?? '',
// // // // //       eventName: json['event_name'] ?? '',
// // // // //       eventFromDate: json['event_from_date'] ?? '',
// // // // //       eventToDate: json['event_to_date'] ?? '',
// // // // //       eventFromTime: json['event_from_time'] ?? '',
// // // // //       eventToTime: json['event_to_time'] ?? '',
// // // // //       eventType: json['event_type'] ?? '',
// // // // //       additionalRoomNightPrice: json['additional_room_night_price'] ?? '0',
// // // // //       additionalRoomNightFee: json['additional_room_night_fee'] ?? '0',
// // // // //       formattedAddress: json['formatted_address'] ?? '',
// // // // //       eventImage: json['event_image'] ?? '',
// // // // //       eventPrice: json['event_price'] ?? '0',
// // // // //       eventNoOfTicket: json['event_no_of_ticket'] ?? '0',
// // // // //       eventEmail: json['event_email'] ?? '',
// // // // //       eventDescription: json['event_description'] ?? '',
// // // // //       status: json['status']?.toString() ?? '',
// // // // //       lat: json['lat'] ?? '',
// // // // //       lng: json['lng'] ?? '',
// // // // //       cityName: json['city_name'] ?? '',
// // // // //     );
// // // // //   }
// // // // // }

// // // // // class AdditionalNight {
// // // // //   final String date;
// // // // //   final String day;

// // // // //   AdditionalNight({required this.date, required this.day});

// // // // //   factory AdditionalNight.fromJson(Map<String, dynamic> json) {
// // // // //     return AdditionalNight(date: json['date'] ?? '', day: json['day'] ?? '');
// // // // //   }
// // // // // }

// // // // // class RoomListResponse {
// // // // //   final String status;
// // // // //   final List<RoomData> data;

// // // // //   RoomListResponse({required this.status, required this.data});

// // // // //   factory RoomListResponse.fromJson(Map<String, dynamic> json) {
// // // // //     return RoomListResponse(
// // // // //       status: json['status']?.toString() ?? '',
// // // // //       data: (json['data'] as List<dynamic>? ?? [])
// // // // //           .map((e) => RoomData.fromJson(e))
// // // // //           .toList(),
// // // // //     );
// // // // //   }
// // // // // }

// // // // // class RoomData {
// // // // //   final String id;
// // // // //   final String roomName;
// // // // //   final String price;
// // // // //   final String fee;
// // // // //   final String fullDescription;
// // // // //   final String shortDescription;
// // // // //   final String roomAvailable;
// // // // //   final String roomImage;

// // // // //   RoomData({
// // // // //     required this.id,
// // // // //     required this.roomName,
// // // // //     required this.price,
// // // // //     required this.fee,
// // // // //     required this.fullDescription,
// // // // //     required this.shortDescription,
// // // // //     required this.roomAvailable,
// // // // //     required this.roomImage,
// // // // //   });

// // // // //   factory RoomData.fromJson(Map<String, dynamic> json) {
// // // // //     return RoomData(
// // // // //       id: json['id'] ?? '',
// // // // //       roomName: json['room_name'] ?? '',
// // // // //       price: json['price'] ?? '0',
// // // // //       fee: json['fee'] ?? '0',
// // // // //       fullDescription: json['full_description'] ?? '',
// // // // //       shortDescription: json['short_description'] ?? '',
// // // // //       roomAvailable: json['room_available'] ?? '0',
// // // // //       roomImage: json['room_image'] ?? '',
// // // // //     );
// // // // //   }
// // // // // }

// // // // // // ── Guest Models ──────────────────────────────────────────────────────────────

// // // // // enum GuestType { single, couple }

// // // // // class SingleGuest {
// // // // //   final String id;
// // // // //   String username;
// // // // //   String fullName;
// // // // //   String email;
// // // // //   String phone;
// // // // //   String? idProofPath;

// // // // //   SingleGuest({
// // // // //     required this.id,
// // // // //     this.username = '',
// // // // //     this.fullName = '',
// // // // //     this.email = '',
// // // // //     this.phone = '',
// // // // //     this.idProofPath,
// // // // //   });

// // // // //   SingleGuest copyWith({
// // // // //     String? username,
// // // // //     String? fullName,
// // // // //     String? email,
// // // // //     String? phone,
// // // // //     String? idProofPath,
// // // // //   }) {
// // // // //     return SingleGuest(
// // // // //       id: id,
// // // // //       username: username ?? this.username,
// // // // //       fullName: fullName ?? this.fullName,
// // // // //       email: email ?? this.email,
// // // // //       phone: phone ?? this.phone,
// // // // //       idProofPath: idProofPath ?? this.idProofPath,
// // // // //     );
// // // // //   }
// // // // // }

// // // // // class CoupleGuest {
// // // // //   final String id;
// // // // //   String username1;
// // // // //   String fullName1;
// // // // //   String email1;
// // // // //   String phone1;
// // // // //   String? idProofPath1;
// // // // //   String username2;
// // // // //   String fullName2;
// // // // //   String email2;
// // // // //   String phone2;
// // // // //   String? idProofPath2;

// // // // //   CoupleGuest({
// // // // //     required this.id,
// // // // //     this.username1 = '',
// // // // //     this.fullName1 = '',
// // // // //     this.email1 = '',
// // // // //     this.phone1 = '',
// // // // //     this.idProofPath1,
// // // // //     this.username2 = '',
// // // // //     this.fullName2 = '',
// // // // //     this.email2 = '',
// // // // //     this.phone2 = '',
// // // // //     this.idProofPath2,
// // // // //   });

// // // // //   CoupleGuest copyWith({
// // // // //     String? username1,
// // // // //     String? fullName1,
// // // // //     String? email1,
// // // // //     String? phone1,
// // // // //     String? idProofPath1,
// // // // //     String? username2,
// // // // //     String? fullName2,
// // // // //     String? email2,
// // // // //     String? phone2,
// // // // //     String? idProofPath2,
// // // // //   }) {
// // // // //     return CoupleGuest(
// // // // //       id: id,
// // // // //       username1: username1 ?? this.username1,
// // // // //       fullName1: fullName1 ?? this.fullName1,
// // // // //       email1: email1 ?? this.email1,
// // // // //       phone1: phone1 ?? this.phone1,
// // // // //       idProofPath1: idProofPath1 ?? this.idProofPath1,
// // // // //       username2: username2 ?? this.username2,
// // // // //       fullName2: fullName2 ?? this.fullName2,
// // // // //       email2: email2 ?? this.email2,
// // // // //       phone2: phone2 ?? this.phone2,
// // // // //       idProofPath2: idProofPath2 ?? this.idProofPath2,
// // // // //     );
// // // // //   }
// // // // // }

// // // // // // ═════════════════════════════════════════════════════════════════════════════
// // // // // // SECTION 2 — REPOSITORY
// // // // // // ═════════════════════════════════════════════════════════════════════════════

// // // // // class EventRepository {
// // // // //   static const String _baseUrl =
// // // // //       'https://app.beatflirtevent.com/App/events/get_single_events';

// // // // //   Future<EventDetailResponse> getSingleEvent({
// // // // //     required String eventId,
// // // // //     required String token,
// // // // //   }) async {
// // // // //     final response = await http.post(
// // // // //       Uri.parse(_baseUrl),
// // // // //       headers: {
// // // // //         'Content-Type': 'application/json',
// // // // //         'Authorization': 'Bearer $token',
// // // // //       },
// // // // //       body: jsonEncode({'event_id': eventId}),
// // // // //     );

// // // // //     if (response.statusCode == 200) {
// // // // //       final json = jsonDecode(response.body) as Map<String, dynamic>;
// // // // //       if (json['status']?.toString() == '200') {
// // // // //         return EventDetailResponse.fromJson(json);
// // // // //       } else {
// // // // //         throw Exception(json['message'] ?? 'Failed to load event');
// // // // //       }
// // // // //     } else {
// // // // //       throw Exception(
// // // // //         'Server error: ${response.statusCode} - ${response.reasonPhrase}',
// // // // //       );
// // // // //     }
// // // // //   }
// // // // // }

// // // // // // ═════════════════════════════════════════════════════════════════════════════
// // // // // // SECTION 3 — RIVERPOD PROVIDERS
// // // // // // ═════════════════════════════════════════════════════════════════════════════

// // // // // // ── Repository ────────────────────────────────────────────────────────────────
// // // // // final eventRepositoryProvider = Provider<EventRepository>((ref) {
// // // // //   return EventRepository();
// // // // // });

// // // // // // ── Event Detail (FutureProvider.family) ──────────────────────────────────────
// // // // // final eventDetailProvider =
// // // // //     FutureProvider.family<
// // // // //       EventDetailResponse,
// // // // //       ({String eventId, String token})
// // // // //     >((ref, params) async {
// // // // //       final repo = ref.read(eventRepositoryProvider);
// // // // //       return repo.getSingleEvent(eventId: params.eventId, token: params.token);
// // // // //     });

// // // // // // ── Room Quantity ─────────────────────────────────────────────────────────────
// // // // // class RoomQuantityNotifier extends StateNotifier<Map<String, int>> {
// // // // //   RoomQuantityNotifier() : super({});

// // // // //   void setQuantity(String roomId, int qty) {
// // // // //     state = {...state, roomId: qty};
// // // // //   }

// // // // //   int getQuantity(String roomId) => state[roomId] ?? 0;

// // // // //   double totalAmount(List<RoomData> rooms) {
// // // // //     double total = 0;
// // // // //     for (final room in rooms) {
// // // // //       final qty = state[room.id] ?? 0;
// // // // //       if (qty > 0) total += qty * (double.tryParse(room.price) ?? 0);
// // // // //     }
// // // // //     return total;
// // // // //   }
// // // // // }

// // // // // final roomQuantityProvider =
// // // // //     StateNotifierProvider<RoomQuantityNotifier, Map<String, int>>(
// // // // //       (ref) => RoomQuantityNotifier(),
// // // // //     );

// // // // // // ── Night Quantity ────────────────────────────────────────────────────────────
// // // // // class NightQuantityNotifier extends StateNotifier<Map<String, int>> {
// // // // //   NightQuantityNotifier() : super({});

// // // // //   void setQuantity(String date, int qty) {
// // // // //     state = {...state, date: qty};
// // // // //   }

// // // // //   int getQuantity(String date) => state[date] ?? 0;

// // // // //   double totalAmount(String pricePerNight) {
// // // // //     final price = double.tryParse(pricePerNight) ?? 0;
// // // // //     int totalQty = state.values.fold(0, (a, b) => a + b);
// // // // //     return totalQty * price;
// // // // //   }
// // // // // }

// // // // // final nightQuantityProvider =
// // // // //     StateNotifierProvider<NightQuantityNotifier, Map<String, int>>(
// // // // //       (ref) => NightQuantityNotifier(),
// // // // //     );

// // // // // // ── Guest List ────────────────────────────────────────────────────────────────
// // // // // class GuestListState {
// // // // //   final List<SingleGuest> singleGuests;
// // // // //   final List<CoupleGuest> coupleGuests;
// // // // //   final bool showValidation;

// // // // //   const GuestListState({
// // // // //     this.singleGuests = const [],
// // // // //     this.coupleGuests = const [],
// // // // //     this.showValidation = false,
// // // // //   });

// // // // //   GuestListState copyWith({
// // // // //     List<SingleGuest>? singleGuests,
// // // // //     List<CoupleGuest>? coupleGuests,
// // // // //     bool? showValidation,
// // // // //   }) {
// // // // //     return GuestListState(
// // // // //       singleGuests: singleGuests ?? this.singleGuests,
// // // // //       coupleGuests: coupleGuests ?? this.coupleGuests,
// // // // //       showValidation: showValidation ?? this.showValidation,
// // // // //     );
// // // // //   }
// // // // // }

// // // // // class GuestListNotifier extends StateNotifier<GuestListState> {
// // // // //   GuestListNotifier() : super(const GuestListState());

// // // // //   int _singleCounter = 0;
// // // // //   int _coupleCounter = 0;

// // // // //   void addSingleGuest() {
// // // // //     _singleCounter++;
// // // // //     state = state.copyWith(
// // // // //       singleGuests: [
// // // // //         ...state.singleGuests,
// // // // //         SingleGuest(id: 'single_$_singleCounter'),
// // // // //       ],
// // // // //     );
// // // // //   }

// // // // //   void removeSingleGuest(String id) {
// // // // //     state = state.copyWith(
// // // // //       singleGuests: state.singleGuests.where((g) => g.id != id).toList(),
// // // // //     );
// // // // //   }

// // // // //   void updateSingleGuest(String id, SingleGuest updated) {
// // // // //     state = state.copyWith(
// // // // //       singleGuests: state.singleGuests
// // // // //           .map((g) => g.id == id ? updated : g)
// // // // //           .toList(),
// // // // //     );
// // // // //   }

// // // // //   void addCoupleGuest() {
// // // // //     _coupleCounter++;
// // // // //     state = state.copyWith(
// // // // //       coupleGuests: [
// // // // //         ...state.coupleGuests,
// // // // //         CoupleGuest(id: 'couple_$_coupleCounter'),
// // // // //       ],
// // // // //     );
// // // // //   }

// // // // //   void removeCoupleGuest(String id) {
// // // // //     state = state.copyWith(
// // // // //       coupleGuests: state.coupleGuests.where((g) => g.id != id).toList(),
// // // // //     );
// // // // //   }

// // // // //   void updateCoupleGuest(String id, CoupleGuest updated) {
// // // // //     state = state.copyWith(
// // // // //       coupleGuests: state.coupleGuests
// // // // //           .map((g) => g.id == id ? updated : g)
// // // // //           .toList(),
// // // // //     );
// // // // //   }

// // // // //   void setShowValidation(bool val) =>
// // // // //       state = state.copyWith(showValidation: val);

// // // // //   bool validate() {
// // // // //     state = state.copyWith(showValidation: true);
// // // // //     for (final g in state.singleGuests) {
// // // // //       if (g.username.trim().isEmpty ||
// // // // //           g.fullName.trim().isEmpty ||
// // // // //           g.email.trim().isEmpty ||
// // // // //           g.phone.trim().isEmpty)
// // // // //         return false;
// // // // //     }
// // // // //     for (final g in state.coupleGuests) {
// // // // //       if (g.username1.trim().isEmpty ||
// // // // //           g.fullName1.trim().isEmpty ||
// // // // //           g.email1.trim().isEmpty ||
// // // // //           g.phone1.trim().isEmpty ||
// // // // //           g.fullName2.trim().isEmpty ||
// // // // //           g.email2.trim().isEmpty ||
// // // // //           g.phone2.trim().isEmpty)
// // // // //         return false;
// // // // //     }
// // // // //     return true;
// // // // //   }
// // // // // }

// // // // // final guestListProvider =
// // // // //     StateNotifierProvider<GuestListNotifier, GuestListState>(
// // // // //       (ref) => GuestListNotifier(),
// // // // //     );

// // // // // // ── Payment / Voucher / UI state ──────────────────────────────────────────────
// // // // // enum PaymentType { full, partial }

// // // // // final paymentTypeProvider = StateProvider<PaymentType?>((ref) => null);
// // // // // final voucherCodeProvider = StateProvider<String>((ref) => '');
// // // // // final voucherDiscountProvider = StateProvider<double>((ref) => 0.0);
// // // // // final membershipDiscountProvider = StateProvider<double>((ref) => 0.0);
// // // // // final descriptionExpandedProvider = StateProvider<bool>((ref) => false);

// // // // // // ═════════════════════════════════════════════════════════════════════════════
// // // // // // SECTION 4 — SCREEN
// // // // // // ═════════════════════════════════════════════════════════════════════════════

// // // // // class EventDetailScreen extends ConsumerWidget {
// // // // //   final String eventId;
// // // // //   final String token;

// // // // //   const EventDetailScreen({
// // // // //     super.key,
// // // // //     required this.eventId,
// // // // //     required this.token,
// // // // //   });

// // // // //   @override
// // // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // // //     final params = (eventId: eventId, token: token);
// // // // //     final asyncEvent = ref.watch(eventDetailProvider(params));

// // // // //     return Scaffold(
// // // // //       backgroundColor: const Color(0xFFFFF0F5),
// // // // //       appBar: AppBar(
// // // // //         backgroundColor: Colors.white,
// // // // //         elevation: 0.5,
// // // // //         leading: const SizedBox.shrink(),
// // // // //         title: const Text(
// // // // //           'Parties And Events',
// // // // //           style: TextStyle(
// // // // //             color: Colors.black,
// // // // //             fontWeight: FontWeight.bold,
// // // // //             fontSize: 18,
// // // // //           ),
// // // // //         ),
// // // // //         actions: [
// // // // //           Padding(
// // // // //             padding: const EdgeInsets.only(right: 12),
// // // // //             child: ElevatedButton.icon(
// // // // //               onPressed: () => Navigator.of(context).pop(),
// // // // //               icon: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.white),
// // // // //               label: const Text(
// // // // //                 'Back',
// // // // //                 style: TextStyle(color: Colors.white, fontSize: 13),
// // // // //               ),
// // // // //               style: ElevatedButton.styleFrom(
// // // // //                 backgroundColor: const Color(0xFF8B0045),
// // // // //                 shape: RoundedRectangleBorder(
// // // // //                   borderRadius: BorderRadius.circular(20),
// // // // //                 ),
// // // // //                 padding: const EdgeInsets.symmetric(
// // // // //                   horizontal: 14,
// // // // //                   vertical: 8,
// // // // //                 ),
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //       body: asyncEvent.when(
// // // // //         loading: () => const Center(
// // // // //           child: CircularProgressIndicator(color: Color(0xFF8B0045)),
// // // // //         ),
// // // // //         error: (err, _) => Center(
// // // // //           child: Padding(
// // // // //             padding: const EdgeInsets.all(24),
// // // // //             child: Column(
// // // // //               mainAxisAlignment: MainAxisAlignment.center,
// // // // //               children: [
// // // // //                 const Icon(
// // // // //                   Icons.error_outline,
// // // // //                   size: 60,
// // // // //                   color: Color(0xFF8B0045),
// // // // //                 ),
// // // // //                 const SizedBox(height: 16),
// // // // //                 Text(
// // // // //                   'Failed to load event',
// // // // //                   style: Theme.of(context).textTheme.titleMedium,
// // // // //                 ),
// // // // //                 const SizedBox(height: 8),
// // // // //                 Text(
// // // // //                   err.toString(),
// // // // //                   textAlign: TextAlign.center,
// // // // //                   style: const TextStyle(color: Colors.grey, fontSize: 13),
// // // // //                 ),
// // // // //                 const SizedBox(height: 20),
// // // // //                 ElevatedButton(
// // // // //                   style: ElevatedButton.styleFrom(
// // // // //                     backgroundColor: const Color(0xFF8B0045),
// // // // //                   ),
// // // // //                   onPressed: () => ref.refresh(eventDetailProvider(params)),
// // // // //                   child: const Text(
// // // // //                     'Retry',
// // // // //                     style: TextStyle(color: Colors.white),
// // // // //                   ),
// // // // //                 ),
// // // // //               ],
// // // // //             ),
// // // // //           ),
// // // // //         ),
// // // // //         data: (eventResponse) => SingleChildScrollView(
// // // // //           padding: const EdgeInsets.all(16),
// // // // //           child: Column(
// // // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // // //             children: [
// // // // //               _EventHeaderCard(event: eventResponse.data),
// // // // //               const SizedBox(height: 16),
// // // // //               const _GuestSection(),
// // // // //               const SizedBox(height: 16),
// // // // //               if (eventResponse.roomList.data.isNotEmpty) ...[
// // // // //                 _RoomPackageSection(rooms: eventResponse.roomList.data),
// // // // //                 const SizedBox(height: 16),
// // // // //               ],
// // // // //               if (eventResponse.additionalNights.isNotEmpty) ...[
// // // // //                 _AdditionalNightSection(
// // // // //                   nights: eventResponse.additionalNights,
// // // // //                   pricePerNight: eventResponse.data.additionalRoomNightPrice,
// // // // //                   feePerNight: eventResponse.data.additionalRoomNightFee,
// // // // //                 ),
// // // // //                 const SizedBox(height: 16),
// // // // //               ],
// // // // //               _OrderSummarySection(
// // // // //                 rooms: eventResponse.roomList.data,
// // // // //                 nights: eventResponse.additionalNights,
// // // // //                 pricePerNight: eventResponse.data.additionalRoomNightPrice,
// // // // //                 feePerNight: eventResponse.data.additionalRoomNightFee,
// // // // //               ),
// // // // //               const SizedBox(height: 30),
// // // // //             ],
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // // // ═════════════════════════════════════════════════════════════════════════════
// // // // // // SECTION 5 — EVENT HEADER CARD
// // // // // // ═════════════════════════════════════════════════════════════════════════════

// // // // // class _EventHeaderCard extends ConsumerWidget {
// // // // //   final EventData event;
// // // // //   const _EventHeaderCard({required this.event});

// // // // //   String _formatDate(String date, String time) {
// // // // //     try {
// // // // //       final parts = date.split('-');
// // // // //       if (parts.length < 3) return '$date $time';
// // // // //       final months = [
// // // // //         '',
// // // // //         'January',
// // // // //         'February',
// // // // //         'March',
// // // // //         'April',
// // // // //         'May',
// // // // //         'June',
// // // // //         'July',
// // // // //         'August',
// // // // //         'September',
// // // // //         'October',
// // // // //         'November',
// // // // //         'December',
// // // // //       ];
// // // // //       final year = parts[0];
// // // // //       final month = int.tryParse(parts[1]) ?? 0;
// // // // //       final day = int.tryParse(parts[2]) ?? 0;
// // // // //       final monthName = month < months.length ? months[month] : parts[1];
// // // // //       final timeParts = time.split(':');
// // // // //       int hour = int.tryParse(timeParts[0]) ?? 0;
// // // // //       final min = timeParts.length > 1 ? timeParts[1] : '00';
// // // // //       final period = hour >= 12 ? 'pm' : 'am';
// // // // //       hour = hour % 12;
// // // // //       if (hour == 0) hour = 12;
// // // // //       final dt = DateTime.tryParse(date);
// // // // //       final days = [
// // // // //         '',
// // // // //         'Monday',
// // // // //         'Tuesday',
// // // // //         'Wednesday',
// // // // //         'Thursday',
// // // // //         'Friday',
// // // // //         'Saturday',
// // // // //         'Sunday',
// // // // //       ];
// // // // //       final dayName = dt != null ? days[dt.weekday] : '';
// // // // //       return '$dayName, $monthName $day, $year  $hour:$min $period';
// // // // //     } catch (_) {
// // // // //       return '$date $time';
// // // // //     }
// // // // //   }

// // // // //   String _stripHtml(String html) {
// // // // //     return html
// // // // //         .replaceAll('&amp;lt;', '<')
// // // // //         .replaceAll('&amp;gt;', '>')
// // // // //         .replaceAll('&amp;amp;', '&')
// // // // //         .replaceAll('&amp;nbsp;', ' ')
// // // // //         .replaceAll('&lt;', '<')
// // // // //         .replaceAll('&gt;', '>')
// // // // //         .replaceAll('&amp;', '&')
// // // // //         .replaceAll('&nbsp;', ' ')
// // // // //         .replaceAll('\r\n', ' ')
// // // // //         .replaceAll(RegExp(r'<[^>]*>'), '')
// // // // //         .trim();
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // // //     final isExpanded = ref.watch(descriptionExpandedProvider);
// // // // //     final cleanDescription = _stripHtml(event.eventDescription);
// // // // //     const maxChars = 80;
// // // // //     final isLong = cleanDescription.length > maxChars;
// // // // //     final displayText = (!isExpanded && isLong)
// // // // //         ? '${cleanDescription.substring(0, maxChars)}...'
// // // // //         : cleanDescription;

// // // // //     return Container(
// // // // //       decoration: BoxDecoration(
// // // // //         color: Colors.white,
// // // // //         borderRadius: BorderRadius.circular(12),
// // // // //         boxShadow: [
// // // // //           BoxShadow(
// // // // //             color: Colors.black.withOpacity(0.06),
// // // // //             blurRadius: 8,
// // // // //             offset: const Offset(0, 2),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //       child: Padding(
// // // // //         padding: const EdgeInsets.all(16),
// // // // //         child: Column(
// // // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // // //           children: [
// // // // //             Row(
// // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // //               children: [
// // // // //                 // Event Image
// // // // //                 ClipRRect(
// // // // //                   borderRadius: BorderRadius.circular(10),
// // // // //                   child: Image.network(
// // // // //                     event.eventImage,
// // // // //                     width: 140,
// // // // //                     height: 160,
// // // // //                     fit: BoxFit.cover,
// // // // //                     errorBuilder: (_, __, ___) => Container(
// // // // //                       width: 140,
// // // // //                       height: 160,
// // // // //                       color: Colors.grey[200],
// // // // //                       child: const Icon(
// // // // //                         Icons.image_not_supported,
// // // // //                         color: Colors.grey,
// // // // //                         size: 40,
// // // // //                       ),
// // // // //                     ),
// // // // //                     loadingBuilder: (_, child, progress) {
// // // // //                       if (progress == null) return child;
// // // // //                       return Container(
// // // // //                         width: 140,
// // // // //                         height: 160,
// // // // //                         color: Colors.grey[100],
// // // // //                         child: const Center(
// // // // //                           child: CircularProgressIndicator(
// // // // //                             strokeWidth: 2,
// // // // //                             color: Color(0xFF8B0045),
// // // // //                           ),
// // // // //                         ),
// // // // //                       );
// // // // //                     },
// // // // //                   ),
// // // // //                 ),
// // // // //                 const SizedBox(width: 14),
// // // // //                 // Details
// // // // //                 Expanded(
// // // // //                   child: Column(
// // // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                     children: [
// // // // //                       Text(
// // // // //                         event.eventName,
// // // // //                         style: const TextStyle(
// // // // //                           fontSize: 18,
// // // // //                           fontWeight: FontWeight.bold,
// // // // //                           color: Colors.black87,
// // // // //                         ),
// // // // //                       ),
// // // // //                       const SizedBox(height: 8),
// // // // //                       Text(
// // // // //                         '${_formatDate(event.eventFromDate, event.eventFromTime)}  –  ${_formatDate(event.eventToDate, event.eventToTime)}',
// // // // //                         style: const TextStyle(
// // // // //                           fontSize: 12,
// // // // //                           color: Colors.black54,
// // // // //                         ),
// // // // //                       ),
// // // // //                       const SizedBox(height: 8),
// // // // //                       if (event.formattedAddress.isNotEmpty)
// // // // //                         Row(
// // // // //                           crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                           children: [
// // // // //                             const Icon(
// // // // //                               Icons.location_on,
// // // // //                               size: 15,
// // // // //                               color: Color(0xFF8B0045),
// // // // //                             ),
// // // // //                             const SizedBox(width: 4),
// // // // //                             Expanded(
// // // // //                               child: Text(
// // // // //                                 event.formattedAddress,
// // // // //                                 style: const TextStyle(
// // // // //                                   fontSize: 12,
// // // // //                                   color: Colors.black87,
// // // // //                                 ),
// // // // //                               ),
// // // // //                             ),
// // // // //                           ],
// // // // //                         ),
// // // // //                       const SizedBox(height: 8),
// // // // //                       if (event.eventEmail.isNotEmpty)
// // // // //                         Text(
// // // // //                           'contacted by:- ${event.eventEmail}',
// // // // //                           style: const TextStyle(
// // // // //                             fontSize: 12,
// // // // //                             color: Colors.black54,
// // // // //                           ),
// // // // //                         ),
// // // // //                     ],
// // // // //                   ),
// // // // //                 ),
// // // // //               ],
// // // // //             ),
// // // // //             const SizedBox(height: 14),
// // // // //             const Text(
// // // // //               'Description',
// // // // //               style: TextStyle(
// // // // //                 fontSize: 14,
// // // // //                 fontWeight: FontWeight.bold,
// // // // //                 color: Colors.black87,
// // // // //               ),
// // // // //             ),
// // // // //             const SizedBox(height: 6),
// // // // //             Text(
// // // // //               displayText,
// // // // //               style: const TextStyle(fontSize: 13, color: Color(0xFFD81B60)),
// // // // //             ),
// // // // //             if (isLong) ...[
// // // // //               const SizedBox(height: 4),
// // // // //               GestureDetector(
// // // // //                 onTap: () =>
// // // // //                     ref.read(descriptionExpandedProvider.notifier).state =
// // // // //                         !isExpanded,
// // // // //                 child: Text(
// // // // //                   isExpanded ? 'Show Less' : 'Show More...',
// // // // //                   style: const TextStyle(
// // // // //                     fontSize: 13,
// // // // //                     color: Colors.black87,
// // // // //                     fontWeight: FontWeight.w500,
// // // // //                   ),
// // // // //                 ),
// // // // //               ),
// // // // //             ],
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // // // ═════════════════════════════════════════════════════════════════════════════
// // // // // // SECTION 6 — GUEST SECTION
// // // // // // ═════════════════════════════════════════════════════════════════════════════

// // // // // class _GuestSection extends ConsumerWidget {
// // // // //   const _GuestSection();

// // // // //   @override
// // // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // // //     final guestState = ref.watch(guestListProvider);

// // // // //     return Container(
// // // // //       decoration: BoxDecoration(
// // // // //         color: Colors.white,
// // // // //         borderRadius: BorderRadius.circular(12),
// // // // //         boxShadow: [
// // // // //           BoxShadow(
// // // // //             color: Colors.black.withOpacity(0.06),
// // // // //             blurRadius: 8,
// // // // //             offset: const Offset(0, 2),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //       padding: const EdgeInsets.all(16),
// // // // //       child: Column(
// // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // //         children: [
// // // // //           // Auto-fill checkbox
// // // // //           Row(
// // // // //             children: [
// // // // //               Checkbox(
// // // // //                 value: false,
// // // // //                 activeColor: const Color(0xFF8B0045),
// // // // //                 onChanged: (_) {},
// // // // //               ),
// // // // //               const Text(
// // // // //                 'Click here to generate your information',
// // // // //                 style: TextStyle(fontSize: 13, color: Colors.black87),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //           const SizedBox(height: 8),

// // // // //           // Add Guest buttons
// // // // //           Row(
// // // // //             children: [
// // // // //               const Text(
// // // // //                 'Add Guest:',
// // // // //                 style: TextStyle(
// // // // //                   fontSize: 14,
// // // // //                   fontWeight: FontWeight.bold,
// // // // //                   color: Color(0xFFD81B60),
// // // // //                 ),
// // // // //               ),
// // // // //               const SizedBox(width: 12),
// // // // //               _GuestTypeButton(
// // // // //                 icon: Icons.person,
// // // // //                 label: 'Single',
// // // // //                 onTap: () =>
// // // // //                     ref.read(guestListProvider.notifier).addSingleGuest(),
// // // // //               ),
// // // // //               const SizedBox(width: 10),
// // // // //               _GuestTypeButton(
// // // // //                 icon: Icons.people,
// // // // //                 label: 'Couple',
// // // // //                 onTap: () =>
// // // // //                     ref.read(guestListProvider.notifier).addCoupleGuest(),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //           const SizedBox(height: 14),

// // // // //           // Single guest cards
// // // // //           ...guestState.singleGuests.asMap().entries.map(
// // // // //             (entry) => Padding(
// // // // //               padding: const EdgeInsets.only(bottom: 12),
// // // // //               child: _SingleGuestCard(
// // // // //                 guest: entry.value,
// // // // //                 index: entry.key + 1,
// // // // //                 showValidation: guestState.showValidation,
// // // // //               ),
// // // // //             ),
// // // // //           ),

// // // // //           // Couple guest cards
// // // // //           ...guestState.coupleGuests.asMap().entries.map(
// // // // //             (entry) => Padding(
// // // // //               padding: const EdgeInsets.only(bottom: 12),
// // // // //               child: _CoupleGuestCard(
// // // // //                 guest: entry.value,
// // // // //                 index: entry.key + 1,
// // // // //                 showValidation: guestState.showValidation,
// // // // //               ),
// // // // //             ),
// // // // //           ),

// // // // //           // Add Guests to List button
// // // // //           if (guestState.singleGuests.isNotEmpty ||
// // // // //               guestState.coupleGuests.isNotEmpty) ...[
// // // // //             const SizedBox(height: 8),
// // // // //             Center(
// // // // //               child: ElevatedButton(
// // // // //                 onPressed: () {
// // // // //                   final isValid = ref
// // // // //                       .read(guestListProvider.notifier)
// // // // //                       .validate();
// // // // //                   if (isValid) {
// // // // //                     ScaffoldMessenger.of(context).showSnackBar(
// // // // //                       const SnackBar(
// // // // //                         content: Text('Guests added to list!'),
// // // // //                         backgroundColor: Color(0xFF8B0045),
// // // // //                       ),
// // // // //                     );
// // // // //                   }
// // // // //                 },
// // // // //                 style: ElevatedButton.styleFrom(
// // // // //                   backgroundColor: const Color(0xFF1A0A2E),
// // // // //                   shape: RoundedRectangleBorder(
// // // // //                     borderRadius: BorderRadius.circular(8),
// // // // //                   ),
// // // // //                   padding: const EdgeInsets.symmetric(
// // // // //                     horizontal: 32,
// // // // //                     vertical: 14,
// // // // //                   ),
// // // // //                 ),
// // // // //                 child: const Text(
// // // // //                   'Add Guests to the List',
// // // // //                   style: TextStyle(color: Colors.white, fontSize: 14),
// // // // //                 ),
// // // // //               ),
// // // // //             ),
// // // // //           ],
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // // // ── Guest Type Button ─────────────────────────────────────────────────────────
// // // // // class _GuestTypeButton extends StatelessWidget {
// // // // //   final IconData icon;
// // // // //   final String label;
// // // // //   final VoidCallback onTap;

// // // // //   const _GuestTypeButton({
// // // // //     required this.icon,
// // // // //     required this.label,
// // // // //     required this.onTap,
// // // // //   });

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return ElevatedButton.icon(
// // // // //       onPressed: onTap,
// // // // //       icon: Icon(icon, size: 16, color: Colors.white),
// // // // //       label: Text(label, style: const TextStyle(color: Colors.white)),
// // // // //       style: ElevatedButton.styleFrom(
// // // // //         backgroundColor: const Color(0xFF1A0A2E),
// // // // //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
// // // // //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // // // ── Single Guest Card ─────────────────────────────────────────────────────────
// // // // // class _SingleGuestCard extends ConsumerStatefulWidget {
// // // // //   final SingleGuest guest;
// // // // //   final int index;
// // // // //   final bool showValidation;

// // // // //   const _SingleGuestCard({
// // // // //     required this.guest,
// // // // //     required this.index,
// // // // //     required this.showValidation,
// // // // //   });

// // // // //   @override
// // // // //   ConsumerState<_SingleGuestCard> createState() => _SingleGuestCardState();
// // // // // }

// // // // // class _SingleGuestCardState extends ConsumerState<_SingleGuestCard> {
// // // // //   late final TextEditingController _usernameCtrl;
// // // // //   late final TextEditingController _fullNameCtrl;
// // // // //   late final TextEditingController _emailCtrl;
// // // // //   late final TextEditingController _phoneCtrl;

// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     _usernameCtrl = TextEditingController(text: widget.guest.username);
// // // // //     _fullNameCtrl = TextEditingController(text: widget.guest.fullName);
// // // // //     _emailCtrl = TextEditingController(text: widget.guest.email);
// // // // //     _phoneCtrl = TextEditingController(text: widget.guest.phone);
// // // // //   }

// // // // //   @override
// // // // //   void dispose() {
// // // // //     _usernameCtrl.dispose();
// // // // //     _fullNameCtrl.dispose();
// // // // //     _emailCtrl.dispose();
// // // // //     _phoneCtrl.dispose();
// // // // //     super.dispose();
// // // // //   }

// // // // //   void _update() {
// // // // //     ref
// // // // //         .read(guestListProvider.notifier)
// // // // //         .updateSingleGuest(
// // // // //           widget.guest.id,
// // // // //           widget.guest.copyWith(
// // // // //             username: _usernameCtrl.text,
// // // // //             fullName: _fullNameCtrl.text,
// // // // //             email: _emailCtrl.text,
// // // // //             phone: _phoneCtrl.text,
// // // // //           ),
// // // // //         );
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     final sv = widget.showValidation;
// // // // //     return Container(
// // // // //       decoration: BoxDecoration(
// // // // //         border: Border.all(color: const Color(0xFF4FC3F7), width: 1.2),
// // // // //         borderRadius: BorderRadius.circular(10),
// // // // //       ),
// // // // //       padding: const EdgeInsets.all(14),
// // // // //       child: Column(
// // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // //         children: [
// // // // //           Row(
// // // // //             children: [
// // // // //               Expanded(
// // // // //                 child: Text(
// // // // //                   'Add New Single Guest #${widget.index}',
// // // // //                   style: const TextStyle(
// // // // //                     fontWeight: FontWeight.bold,
// // // // //                     fontSize: 14,
// // // // //                     color: Colors.black87,
// // // // //                   ),
// // // // //                 ),
// // // // //               ),
// // // // //               _DeleteButton(
// // // // //                 onTap: () => ref
// // // // //                     .read(guestListProvider.notifier)
// // // // //                     .removeSingleGuest(widget.guest.id),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //           const SizedBox(height: 14),
// // // // //           Row(
// // // // //             children: [
// // // // //               Expanded(
// // // // //                 child: _GuestField(
// // // // //                   label: 'Username',
// // // // //                   hint: 'Enter Username',
// // // // //                   controller: _usernameCtrl,
// // // // //                   onChanged: (_) => _update(),
// // // // //                   showError: sv && _usernameCtrl.text.trim().isEmpty,
// // // // //                 ),
// // // // //               ),
// // // // //               const SizedBox(width: 12),
// // // // //               Expanded(
// // // // //                 child: _GuestField(
// // // // //                   label: 'Full Name',
// // // // //                   hint: 'Enter Full Name',
// // // // //                   controller: _fullNameCtrl,
// // // // //                   onChanged: (_) => _update(),
// // // // //                   showError: sv && _fullNameCtrl.text.trim().isEmpty,
// // // // //                   showInfoIcon: true,
// // // // //                 ),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //           const SizedBox(height: 12),
// // // // //           Row(
// // // // //             children: [
// // // // //               Expanded(
// // // // //                 child: _GuestField(
// // // // //                   label: 'Email',
// // // // //                   hint: 'Email',
// // // // //                   controller: _emailCtrl,
// // // // //                   onChanged: (_) => _update(),
// // // // //                   showError: sv && _emailCtrl.text.trim().isEmpty,
// // // // //                   keyboardType: TextInputType.emailAddress,
// // // // //                 ),
// // // // //               ),
// // // // //               const SizedBox(width: 8),
// // // // //               Expanded(
// // // // //                 child: _GuestField(
// // // // //                   label: 'Phone',
// // // // //                   hint: 'Enter Phone Number',
// // // // //                   controller: _phoneCtrl,
// // // // //                   onChanged: (_) => _update(),
// // // // //                   showError: sv && _phoneCtrl.text.trim().isEmpty,
// // // // //                   keyboardType: TextInputType.phone,
// // // // //                 ),
// // // // //               ),
// // // // //               const SizedBox(width: 8),
// // // // //               Expanded(
// // // // //                 child: _IdProofPicker(
// // // // //                   showError: sv && widget.guest.idProofPath == null,
// // // // //                   filePath: widget.guest.idProofPath,
// // // // //                   onPicked: (path) {
// // // // //                     ref
// // // // //                         .read(guestListProvider.notifier)
// // // // //                         .updateSingleGuest(
// // // // //                           widget.guest.id,
// // // // //                           widget.guest.copyWith(idProofPath: path),
// // // // //                         );
// // // // //                   },
// // // // //                 ),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // // // ── Couple Guest Card ─────────────────────────────────────────────────────────
// // // // // class _CoupleGuestCard extends ConsumerStatefulWidget {
// // // // //   final CoupleGuest guest;
// // // // //   final int index;
// // // // //   final bool showValidation;

// // // // //   const _CoupleGuestCard({
// // // // //     required this.guest,
// // // // //     required this.index,
// // // // //     required this.showValidation,
// // // // //   });

// // // // //   @override
// // // // //   ConsumerState<_CoupleGuestCard> createState() => _CoupleGuestCardState();
// // // // // }

// // // // // class _CoupleGuestCardState extends ConsumerState<_CoupleGuestCard> {
// // // // //   late final TextEditingController _u1, _fn1, _e1, _p1;
// // // // //   late final TextEditingController _u2, _fn2, _e2, _p2;

// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     _u1 = TextEditingController(text: widget.guest.username1);
// // // // //     _fn1 = TextEditingController(text: widget.guest.fullName1);
// // // // //     _e1 = TextEditingController(text: widget.guest.email1);
// // // // //     _p1 = TextEditingController(text: widget.guest.phone1);
// // // // //     _u2 = TextEditingController(text: widget.guest.username2);
// // // // //     _fn2 = TextEditingController(text: widget.guest.fullName2);
// // // // //     _e2 = TextEditingController(text: widget.guest.email2);
// // // // //     _p2 = TextEditingController(text: widget.guest.phone2);
// // // // //   }

// // // // //   @override
// // // // //   void dispose() {
// // // // //     _u1.dispose();
// // // // //     _fn1.dispose();
// // // // //     _e1.dispose();
// // // // //     _p1.dispose();
// // // // //     _u2.dispose();
// // // // //     _fn2.dispose();
// // // // //     _e2.dispose();
// // // // //     _p2.dispose();
// // // // //     super.dispose();
// // // // //   }

// // // // //   void _update() {
// // // // //     ref
// // // // //         .read(guestListProvider.notifier)
// // // // //         .updateCoupleGuest(
// // // // //           widget.guest.id,
// // // // //           widget.guest.copyWith(
// // // // //             username1: _u1.text,
// // // // //             fullName1: _fn1.text,
// // // // //             email1: _e1.text,
// // // // //             phone1: _p1.text,
// // // // //             username2: _u2.text,
// // // // //             fullName2: _fn2.text,
// // // // //             email2: _e2.text,
// // // // //             phone2: _p2.text,
// // // // //           ),
// // // // //         );
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     final sv = widget.showValidation;
// // // // //     return Container(
// // // // //       decoration: BoxDecoration(
// // // // //         border: Border.all(color: const Color(0xFF4FC3F7), width: 1.2),
// // // // //         borderRadius: BorderRadius.circular(10),
// // // // //       ),
// // // // //       padding: const EdgeInsets.all(14),
// // // // //       child: Column(
// // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // //         children: [
// // // // //           Row(
// // // // //             children: [
// // // // //               Expanded(
// // // // //                 child: Text(
// // // // //                   'Add New Couple Guest #${widget.index}',
// // // // //                   style: const TextStyle(
// // // // //                     fontWeight: FontWeight.bold,
// // // // //                     fontSize: 14,
// // // // //                     color: Color(0xFF4FC3F7),
// // // // //                   ),
// // // // //                 ),
// // // // //               ),
// // // // //               _DeleteButton(
// // // // //                 onTap: () => ref
// // // // //                     .read(guestListProvider.notifier)
// // // // //                     .removeCoupleGuest(widget.guest.id),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //           const SizedBox(height: 14),

// // // // //           // ── Member 1 ──────────────────────────────────────────────────
// // // // //           const _SectionLabel(label: 'Member 1'),
// // // // //           const SizedBox(height: 8),
// // // // //           Row(
// // // // //             children: [
// // // // //               Expanded(
// // // // //                 child: _GuestField(
// // // // //                   label: 'Username (Member 1)',
// // // // //                   hint: 'Enter Username',
// // // // //                   controller: _u1,
// // // // //                   onChanged: (_) => _update(),
// // // // //                   showError: sv && _u1.text.trim().isEmpty,
// // // // //                 ),
// // // // //               ),
// // // // //               const SizedBox(width: 12),
// // // // //               Expanded(
// // // // //                 child: _GuestField(
// // // // //                   label: 'Full Name (Member 1)',
// // // // //                   hint: 'Enter Full Name',
// // // // //                   controller: _fn1,
// // // // //                   onChanged: (_) => _update(),
// // // // //                   showError: sv && _fn1.text.trim().isEmpty,
// // // // //                   showInfoIcon: true,
// // // // //                 ),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //           const SizedBox(height: 10),
// // // // //           Row(
// // // // //             children: [
// // // // //               Expanded(
// // // // //                 child: _GuestField(
// // // // //                   label: 'E-mail (Member 1)',
// // // // //                   hint: 'Enter Your E-mail',
// // // // //                   controller: _e1,
// // // // //                   onChanged: (_) => _update(),
// // // // //                   showError: sv && _e1.text.trim().isEmpty,
// // // // //                   keyboardType: TextInputType.emailAddress,
// // // // //                 ),
// // // // //               ),
// // // // //               const SizedBox(width: 8),
// // // // //               Expanded(
// // // // //                 child: _GuestField(
// // // // //                   label: 'Phone Number (Member 1)',
// // // // //                   hint: 'Enter Phone Number',
// // // // //                   controller: _p1,
// // // // //                   onChanged: (_) => _update(),
// // // // //                   showError: sv && _p1.text.trim().isEmpty,
// // // // //                   keyboardType: TextInputType.phone,
// // // // //                 ),
// // // // //               ),
// // // // //               const SizedBox(width: 8),
// // // // //               Expanded(
// // // // //                 child: _IdProofPicker(
// // // // //                   label: 'Id Proof (Member 1)',
// // // // //                   showError: sv && widget.guest.idProofPath1 == null,
// // // // //                   filePath: widget.guest.idProofPath1,
// // // // //                   onPicked: (path) {
// // // // //                     ref
// // // // //                         .read(guestListProvider.notifier)
// // // // //                         .updateCoupleGuest(
// // // // //                           widget.guest.id,
// // // // //                           widget.guest.copyWith(idProofPath1: path),
// // // // //                         );
// // // // //                   },
// // // // //                 ),
// // // // //               ),
// // // // //             ],
// // // // //           ),

// // // // //           const SizedBox(height: 16),
// // // // //           const Divider(height: 1, color: Color(0xFFEEEEEE)),
// // // // //           const SizedBox(height: 16),

// // // // //           // ── Member 2 ──────────────────────────────────────────────────
// // // // //           const _SectionLabel(label: 'Member 2'),
// // // // //           const SizedBox(height: 8),
// // // // //           Row(
// // // // //             children: [
// // // // //               Expanded(
// // // // //                 child: _GuestField(
// // // // //                   label: 'Username (Member 2)',
// // // // //                   hint: 'Username',
// // // // //                   controller: _u2,
// // // // //                   onChanged: (_) => _update(),
// // // // //                   showError: false,
// // // // //                 ),
// // // // //               ),
// // // // //               const SizedBox(width: 12),
// // // // //               Expanded(
// // // // //                 child: _GuestField(
// // // // //                   label: 'Full Name (Member 2)',
// // // // //                   hint: 'Enter Full Name',
// // // // //                   controller: _fn2,
// // // // //                   onChanged: (_) => _update(),
// // // // //                   showError: sv && _fn2.text.trim().isEmpty,
// // // // //                   showInfoIcon: true,
// // // // //                 ),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //           const SizedBox(height: 10),
// // // // //           Row(
// // // // //             children: [
// // // // //               Expanded(
// // // // //                 child: _GuestField(
// // // // //                   label: 'Email (Member 2)',
// // // // //                   hint: 'Enter Email',
// // // // //                   controller: _e2,
// // // // //                   onChanged: (_) => _update(),
// // // // //                   showError: sv && _e2.text.trim().isEmpty,
// // // // //                   keyboardType: TextInputType.emailAddress,
// // // // //                 ),
// // // // //               ),
// // // // //               const SizedBox(width: 8),
// // // // //               Expanded(
// // // // //                 child: _GuestField(
// // // // //                   label: 'Phone (Member 2)',
// // // // //                   hint: 'Enter Phone Number',
// // // // //                   controller: _p2,
// // // // //                   onChanged: (_) => _update(),
// // // // //                   showError: sv && _p2.text.trim().isEmpty,
// // // // //                   keyboardType: TextInputType.phone,
// // // // //                 ),
// // // // //               ),
// // // // //               const SizedBox(width: 8),
// // // // //               Expanded(
// // // // //                 child: _IdProofPicker(
// // // // //                   label: 'Id Proof (Member 2)',
// // // // //                   showError: sv && widget.guest.idProofPath2 == null,
// // // // //                   filePath: widget.guest.idProofPath2,
// // // // //                   onPicked: (path) {
// // // // //                     ref
// // // // //                         .read(guestListProvider.notifier)
// // // // //                         .updateCoupleGuest(
// // // // //                           widget.guest.id,
// // // // //                           widget.guest.copyWith(idProofPath2: path),
// // // // //                         );
// // // // //                   },
// // // // //                 ),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //           const SizedBox(height: 12),
// // // // //           Align(
// // // // //             alignment: Alignment.centerRight,
// // // // //             child: ElevatedButton(
// // // // //               onPressed: () => ref
// // // // //                   .read(guestListProvider.notifier)
// // // // //                   .removeCoupleGuest(widget.guest.id),
// // // // //               style: ElevatedButton.styleFrom(
// // // // //                 backgroundColor: const Color(0xFFD32F2F),
// // // // //                 shape: RoundedRectangleBorder(
// // // // //                   borderRadius: BorderRadius.circular(8),
// // // // //                 ),
// // // // //                 padding: const EdgeInsets.symmetric(
// // // // //                   horizontal: 20,
// // // // //                   vertical: 10,
// // // // //                 ),
// // // // //               ),
// // // // //               child: const Text(
// // // // //                 'Remove',
// // // // //                 style: TextStyle(color: Colors.white, fontSize: 13),
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // // // ── Shared small widgets ──────────────────────────────────────────────────────

// // // // // class _SectionLabel extends StatelessWidget {
// // // // //   final String label;
// // // // //   const _SectionLabel({required this.label});

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Text(
// // // // //       label,
// // // // //       style: const TextStyle(
// // // // //         fontSize: 12,
// // // // //         fontWeight: FontWeight.w600,
// // // // //         color: Colors.black54,
// // // // //         letterSpacing: 0.5,
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // // class _GuestField extends StatelessWidget {
// // // // //   final String label;
// // // // //   final String hint;
// // // // //   final TextEditingController controller;
// // // // //   final ValueChanged<String> onChanged;
// // // // //   final bool showError;
// // // // //   final bool showInfoIcon;
// // // // //   final TextInputType keyboardType;

// // // // //   const _GuestField({
// // // // //     required this.label,
// // // // //     required this.hint,
// // // // //     required this.controller,
// // // // //     required this.onChanged,
// // // // //     required this.showError,
// // // // //     this.showInfoIcon = false,
// // // // //     this.keyboardType = TextInputType.text,
// // // // //   });

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Column(
// // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // //       children: [
// // // // //         Row(
// // // // //           children: [
// // // // //             Text(
// // // // //               label,
// // // // //               style: const TextStyle(
// // // // //                 fontSize: 12,
// // // // //                 fontWeight: FontWeight.w600,
// // // // //                 color: Colors.black87,
// // // // //               ),
// // // // //             ),
// // // // //             if (showInfoIcon) ...[
// // // // //               const SizedBox(width: 4),
// // // // //               const Icon(Icons.info_outline, size: 14, color: Colors.black54),
// // // // //             ],
// // // // //           ],
// // // // //         ),
// // // // //         const SizedBox(height: 4),
// // // // //         TextField(
// // // // //           controller: controller,
// // // // //           onChanged: onChanged,
// // // // //           keyboardType: keyboardType,
// // // // //           style: const TextStyle(fontSize: 13),
// // // // //           decoration: InputDecoration(
// // // // //             hintText: hint,
// // // // //             hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
// // // // //             contentPadding: const EdgeInsets.symmetric(
// // // // //               horizontal: 12,
// // // // //               vertical: 10,
// // // // //             ),
// // // // //             border: OutlineInputBorder(
// // // // //               borderRadius: BorderRadius.circular(6),
// // // // //               borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
// // // // //             ),
// // // // //             enabledBorder: OutlineInputBorder(
// // // // //               borderRadius: BorderRadius.circular(6),
// // // // //               borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
// // // // //             ),
// // // // //             focusedBorder: OutlineInputBorder(
// // // // //               borderRadius: BorderRadius.circular(6),
// // // // //               borderSide: const BorderSide(
// // // // //                 color: Color(0xFF8B0045),
// // // // //                 width: 1.5,
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //         ),
// // // // //         if (showError) ...[
// // // // //           const SizedBox(height: 3),
// // // // //           const Text(
// // // // //             'This Field is required',
// // // // //             style: TextStyle(fontSize: 11, color: Color(0xFFD32F2F)),
// // // // //           ),
// // // // //         ],
// // // // //       ],
// // // // //     );
// // // // //   }
// // // // // }

// // // // // class _IdProofPicker extends StatelessWidget {
// // // // //   final String? filePath;
// // // // //   final bool showError;
// // // // //   final ValueChanged<String> onPicked;
// // // // //   final String label;

// // // // //   const _IdProofPicker({
// // // // //     required this.showError,
// // // // //     required this.onPicked,
// // // // //     this.filePath,
// // // // //     this.label = 'Id Proof',
// // // // //   });

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Column(
// // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // //       children: [
// // // // //         Row(
// // // // //           children: [
// // // // //             Text(
// // // // //               label,
// // // // //               style: const TextStyle(
// // // // //                 fontSize: 12,
// // // // //                 fontWeight: FontWeight.w600,
// // // // //                 color: Colors.black87,
// // // // //               ),
// // // // //             ),
// // // // //             const SizedBox(width: 4),
// // // // //             const Icon(Icons.info_outline, size: 14, color: Colors.black54),
// // // // //           ],
// // // // //         ),
// // // // //         const SizedBox(height: 4),
// // // // //         GestureDetector(
// // // // //           onTap: () {
// // // // //             // Replace with FilePicker.platform.pickFiles() in real app
// // // // //             onPicked('selected_file.jpg');
// // // // //           },
// // // // //           child: Container(
// // // // //             width: double.infinity,
// // // // //             decoration: BoxDecoration(
// // // // //               border: Border.all(color: const Color(0xFFCCCCCC)),
// // // // //               borderRadius: BorderRadius.circular(6),
// // // // //             ),
// // // // //             child: Row(
// // // // //               children: [
// // // // //                 Container(
// // // // //                   padding: const EdgeInsets.symmetric(
// // // // //                     horizontal: 10,
// // // // //                     vertical: 10,
// // // // //                   ),
// // // // //                   decoration: const BoxDecoration(
// // // // //                     border: Border(right: BorderSide(color: Color(0xFFCCCCCC))),
// // // // //                   ),
// // // // //                   child: const Text(
// // // // //                     'Choose file',
// // // // //                     style: TextStyle(fontSize: 12, color: Colors.black87),
// // // // //                   ),
// // // // //                 ),
// // // // //                 Expanded(
// // // // //                   child: Padding(
// // // // //                     padding: const EdgeInsets.symmetric(horizontal: 8),
// // // // //                     child: Text(
// // // // //                       filePath != null
// // // // //                           ? filePath!.split('/').last
// // // // //                           : 'No file chosen',
// // // // //                       style: const TextStyle(
// // // // //                         fontSize: 11,
// // // // //                         color: Colors.black45,
// // // // //                       ),
// // // // //                       overflow: TextOverflow.ellipsis,
// // // // //                     ),
// // // // //                   ),
// // // // //                 ),
// // // // //               ],
// // // // //             ),
// // // // //           ),
// // // // //         ),
// // // // //         if (showError) ...[
// // // // //           const SizedBox(height: 3),
// // // // //           const Text(
// // // // //             'This Field is required',
// // // // //             style: TextStyle(fontSize: 11, color: Color(0xFFD32F2F)),
// // // // //           ),
// // // // //         ],
// // // // //       ],
// // // // //     );
// // // // //   }
// // // // // }

// // // // // class _DeleteButton extends StatelessWidget {
// // // // //   final VoidCallback onTap;
// // // // //   const _DeleteButton({required this.onTap});

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return GestureDetector(
// // // // //       onTap: onTap,
// // // // //       child: Container(
// // // // //         width: 36,
// // // // //         height: 36,
// // // // //         decoration: BoxDecoration(
// // // // //           color: const Color(0xFFD32F2F),
// // // // //           borderRadius: BorderRadius.circular(6),
// // // // //         ),
// // // // //         child: const Icon(Icons.delete_outline, color: Colors.white, size: 20),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // // // ═════════════════════════════════════════════════════════════════════════════
// // // // // // SECTION 7 — ROOM PACKAGE SECTION
// // // // // // ═════════════════════════════════════════════════════════════════════════════

// // // // // class _RoomPackageSection extends ConsumerWidget {
// // // // //   final List<RoomData> rooms;
// // // // //   const _RoomPackageSection({required this.rooms});

// // // // //   @override
// // // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // // //     final quantities = ref.watch(roomQuantityProvider);

// // // // //     return Container(
// // // // //       decoration: BoxDecoration(
// // // // //         color: Colors.white,
// // // // //         borderRadius: BorderRadius.circular(12),
// // // // //         boxShadow: [
// // // // //           BoxShadow(
// // // // //             color: Colors.black.withOpacity(0.06),
// // // // //             blurRadius: 8,
// // // // //             offset: const Offset(0, 2),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //       child: Column(
// // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // //         children: [
// // // // //           const Padding(
// // // // //             padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
// // // // //             child: Text(
// // // // //               'Choose Your Beat Flirt Package',
// // // // //               style: TextStyle(
// // // // //                 fontSize: 16,
// // // // //                 fontWeight: FontWeight.bold,
// // // // //                 color: Colors.black87,
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //           _RoomTableHeader(),
// // // // //           const Divider(height: 1),
// // // // //           ...rooms.asMap().entries.map((entry) {
// // // // //             final room = entry.value;
// // // // //             final isLast = entry.key == rooms.length - 1;
// // // // //             final qty = quantities[room.id] ?? 0;
// // // // //             final amount = qty * (double.tryParse(room.price) ?? 0);
// // // // //             return Column(
// // // // //               children: [
// // // // //                 Padding(
// // // // //                   padding: const EdgeInsets.symmetric(
// // // // //                     horizontal: 12,
// // // // //                     vertical: 10,
// // // // //                   ),
// // // // //                   child: Row(
// // // // //                     crossAxisAlignment: CrossAxisAlignment.center,
// // // // //                     children: [
// // // // //                       _QuantityDropdown(
// // // // //                         value: qty,
// // // // //                         max: int.tryParse(room.roomAvailable) ?? 10,
// // // // //                         onChanged: (val) => ref
// // // // //                             .read(roomQuantityProvider.notifier)
// // // // //                             .setQuantity(room.id, val),
// // // // //                       ),
// // // // //                       const SizedBox(width: 10),
// // // // //                       ClipRRect(
// // // // //                         borderRadius: BorderRadius.circular(6),
// // // // //                         child: Image.network(
// // // // //                           room.roomImage,
// // // // //                           width: 55,
// // // // //                           height: 45,
// // // // //                           fit: BoxFit.cover,
// // // // //                           errorBuilder: (_, __, ___) => Container(
// // // // //                             width: 55,
// // // // //                             height: 45,
// // // // //                             color: Colors.grey[200],
// // // // //                             child: const Icon(
// // // // //                               Icons.bed,
// // // // //                               color: Colors.grey,
// // // // //                               size: 24,
// // // // //                             ),
// // // // //                           ),
// // // // //                         ),
// // // // //                       ),
// // // // //                       const SizedBox(width: 10),
// // // // //                       Expanded(
// // // // //                         child: Column(
// // // // //                           crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                           children: [
// // // // //                             Text(
// // // // //                               room.roomName,
// // // // //                               style: const TextStyle(
// // // // //                                 fontSize: 13,
// // // // //                                 fontWeight: FontWeight.bold,
// // // // //                                 color: Colors.black87,
// // // // //                               ),
// // // // //                             ),
// // // // //                             if (room.shortDescription.isNotEmpty)
// // // // //                               Text(
// // // // //                                 room.shortDescription,
// // // // //                                 style: const TextStyle(
// // // // //                                   fontSize: 11,
// // // // //                                   color: Colors.black54,
// // // // //                                 ),
// // // // //                                 maxLines: 2,
// // // // //                                 overflow: TextOverflow.ellipsis,
// // // // //                               ),
// // // // //                           ],
// // // // //                         ),
// // // // //                       ),
// // // // //                       SizedBox(
// // // // //                         width: 56,
// // // // //                         child: Text(
// // // // //                           '\$${room.price}',
// // // // //                           style: const TextStyle(
// // // // //                             fontSize: 13,
// // // // //                             color: Colors.black87,
// // // // //                           ),
// // // // //                           textAlign: TextAlign.center,
// // // // //                         ),
// // // // //                       ),
// // // // //                       SizedBox(
// // // // //                         width: 44,
// // // // //                         child: Text(
// // // // //                           '\$${room.fee}',
// // // // //                           style: const TextStyle(
// // // // //                             fontSize: 13,
// // // // //                             color: Colors.black87,
// // // // //                           ),
// // // // //                           textAlign: TextAlign.center,
// // // // //                         ),
// // // // //                       ),
// // // // //                       SizedBox(
// // // // //                         width: 48,
// // // // //                         child: Text(
// // // // //                           '\$${amount == 0 ? '0' : amount.toStringAsFixed(0)}',
// // // // //                           style: const TextStyle(
// // // // //                             fontSize: 13,
// // // // //                             fontWeight: FontWeight.bold,
// // // // //                             color: Colors.black87,
// // // // //                           ),
// // // // //                           textAlign: TextAlign.right,
// // // // //                         ),
// // // // //                       ),
// // // // //                     ],
// // // // //                   ),
// // // // //                 ),
// // // // //                 if (!isLast)
// // // // //                   const Divider(height: 1, indent: 12, endIndent: 12),
// // // // //               ],
// // // // //             );
// // // // //           }),
// // // // //           const SizedBox(height: 8),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // // class _RoomTableHeader extends StatelessWidget {
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Padding(
// // // // //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// // // // //       child: Row(
// // // // //         children: const [
// // // // //           SizedBox(width: 60, child: _HeaderLabel('QTY')),
// // // // //           SizedBox(width: 10),
// // // // //           Expanded(child: _HeaderLabel('ROOM / PACKAGE')),
// // // // //           SizedBox(width: 56, child: _HeaderLabel('PRICE', center: true)),
// // // // //           SizedBox(width: 44, child: _HeaderLabel('FEE', center: true)),
// // // // //           SizedBox(width: 48, child: _HeaderLabel('AMOUNT', right: true)),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // // class _HeaderLabel extends StatelessWidget {
// // // // //   final String text;
// // // // //   final bool center;
// // // // //   final bool right;

// // // // //   const _HeaderLabel(this.text, {this.center = false, this.right = false});

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Text(
// // // // //       text,
// // // // //       style: const TextStyle(
// // // // //         fontSize: 11,
// // // // //         fontWeight: FontWeight.bold,
// // // // //         color: Colors.black54,
// // // // //         letterSpacing: 0.5,
// // // // //       ),
// // // // //       textAlign: right
// // // // //           ? TextAlign.right
// // // // //           : center
// // // // //           ? TextAlign.center
// // // // //           : TextAlign.left,
// // // // //     );
// // // // //   }
// // // // // }

// // // // // class _QuantityDropdown extends StatelessWidget {
// // // // //   final int value;
// // // // //   final int max;
// // // // //   final ValueChanged<int> onChanged;

// // // // //   const _QuantityDropdown({
// // // // //     required this.value,
// // // // //     required this.max,
// // // // //     required this.onChanged,
// // // // //   });

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Container(
// // // // //       width: 52,
// // // // //       height: 34,
// // // // //       decoration: BoxDecoration(
// // // // //         border: Border.all(color: const Color(0xFFCCCCCC)),
// // // // //         borderRadius: BorderRadius.circular(6),
// // // // //         color: Colors.white,
// // // // //       ),
// // // // //       padding: const EdgeInsets.symmetric(horizontal: 4),
// // // // //       child: DropdownButtonHideUnderline(
// // // // //         child: DropdownButton<int>(
// // // // //           value: value,
// // // // //           isExpanded: true,
// // // // //           icon: const Icon(Icons.keyboard_arrow_down, size: 16),
// // // // //           style: const TextStyle(fontSize: 13, color: Colors.black87),
// // // // //           onChanged: (val) {
// // // // //             if (val != null) onChanged(val);
// // // // //           },
// // // // //           items: List.generate(
// // // // //             max + 1,
// // // // //             (i) => i,
// // // // //           ).map((i) => DropdownMenuItem(value: i, child: Text('$i'))).toList(),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // // // ═════════════════════════════════════════════════════════════════════════════
// // // // // // SECTION 8 — ADDITIONAL NIGHT SECTION
// // // // // // ═════════════════════════════════════════════════════════════════════════════

// // // // // class _AdditionalNightSection extends ConsumerWidget {
// // // // //   final List<AdditionalNight> nights;
// // // // //   final String pricePerNight;
// // // // //   final String feePerNight;

// // // // //   const _AdditionalNightSection({
// // // // //     required this.nights,
// // // // //     required this.pricePerNight,
// // // // //     required this.feePerNight,
// // // // //   });

// // // // //   String _formatDate(String dateStr) {
// // // // //     try {
// // // // //       final parts = dateStr.split('-');
// // // // //       final months = [
// // // // //         '',
// // // // //         'January',
// // // // //         'February',
// // // // //         'March',
// // // // //         'April',
// // // // //         'May',
// // // // //         'June',
// // // // //         'July',
// // // // //         'August',
// // // // //         'September',
// // // // //         'October',
// // // // //         'November',
// // // // //         'December',
// // // // //       ];
// // // // //       final year = parts[0];
// // // // //       final month = int.tryParse(parts[1]) ?? 0;
// // // // //       final day = int.tryParse(parts[2]) ?? 0;
// // // // //       final monthName = month < months.length ? months[month] : parts[1];
// // // // //       return '$monthName $day, $year';
// // // // //     } catch (_) {
// // // // //       return dateStr;
// // // // //     }
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // // //     final quantities = ref.watch(nightQuantityProvider);

// // // // //     return Container(
// // // // //       decoration: BoxDecoration(
// // // // //         color: Colors.white,
// // // // //         borderRadius: BorderRadius.circular(12),
// // // // //         boxShadow: [
// // // // //           BoxShadow(
// // // // //             color: Colors.black.withOpacity(0.06),
// // // // //             blurRadius: 8,
// // // // //             offset: const Offset(0, 2),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //       child: Column(
// // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // //         children: [
// // // // //           const Padding(
// // // // //             padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
// // // // //             child: Text(
// // // // //               'Select Additional Room Night Options',
// // // // //               style: TextStyle(
// // // // //                 fontSize: 16,
// // // // //                 fontWeight: FontWeight.bold,
// // // // //                 color: Colors.black87,
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //           const Padding(
// // // // //             padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
// // // // //             child: Text(
// // // // //               'Quantity will remain the same as added to the event.',
// // // // //               style: TextStyle(
// // // // //                 fontSize: 12,
// // // // //                 color: Color(0xFFD81B60),
// // // // //                 fontStyle: FontStyle.italic,
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //           // Table Header
// // // // //           Padding(
// // // // //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// // // // //             child: Row(
// // // // //               children: const [
// // // // //                 SizedBox(width: 70, child: _HeaderLabel('QTY')),
// // // // //                 Expanded(child: _HeaderLabel('ADDITIONAL NIGHT')),
// // // // //                 SizedBox(width: 56, child: _HeaderLabel('PRICE', center: true)),
// // // // //                 SizedBox(width: 44, child: _HeaderLabel('FEE', center: true)),
// // // // //                 SizedBox(width: 52, child: _HeaderLabel('AMOUNT', right: true)),
// // // // //               ],
// // // // //             ),
// // // // //           ),
// // // // //           const Divider(height: 1),
// // // // //           ...nights.asMap().entries.map((entry) {
// // // // //             final night = entry.value;
// // // // //             final isLast = entry.key == nights.length - 1;
// // // // //             final qty = quantities[night.date] ?? 0;
// // // // //             final price = double.tryParse(pricePerNight) ?? 0;
// // // // //             final amount = qty * price;
// // // // //             return Column(
// // // // //               children: [
// // // // //                 Padding(
// // // // //                   padding: const EdgeInsets.symmetric(
// // // // //                     horizontal: 12,
// // // // //                     vertical: 10,
// // // // //                   ),
// // // // //                   child: Row(
// // // // //                     crossAxisAlignment: CrossAxisAlignment.center,
// // // // //                     children: [
// // // // //                       _NightQtyDropdown(
// // // // //                         value: qty,
// // // // //                         onChanged: (val) => ref
// // // // //                             .read(nightQuantityProvider.notifier)
// // // // //                             .setQuantity(night.date, val),
// // // // //                       ),
// // // // //                       const SizedBox(width: 12),
// // // // //                       Expanded(
// // // // //                         child: RichText(
// // // // //                           text: TextSpan(
// // // // //                             children: [
// // // // //                               TextSpan(
// // // // //                                 text: '${night.day}, ',
// // // // //                                 style: const TextStyle(
// // // // //                                   fontSize: 13,
// // // // //                                   fontWeight: FontWeight.bold,
// // // // //                                   color: Colors.black87,
// // // // //                                 ),
// // // // //                               ),
// // // // //                               TextSpan(
// // // // //                                 text: _formatDate(night.date),
// // // // //                                 style: const TextStyle(
// // // // //                                   fontSize: 13,
// // // // //                                   color: Colors.black87,
// // // // //                                 ),
// // // // //                               ),
// // // // //                             ],
// // // // //                           ),
// // // // //                         ),
// // // // //                       ),
// // // // //                       SizedBox(
// // // // //                         width: 56,
// // // // //                         child: Text(
// // // // //                           '\$$pricePerNight',
// // // // //                           style: const TextStyle(
// // // // //                             fontSize: 13,
// // // // //                             color: Colors.black87,
// // // // //                           ),
// // // // //                           textAlign: TextAlign.center,
// // // // //                         ),
// // // // //                       ),
// // // // //                       SizedBox(
// // // // //                         width: 44,
// // // // //                         child: Text(
// // // // //                           '\$$feePerNight',
// // // // //                           style: const TextStyle(
// // // // //                             fontSize: 13,
// // // // //                             color: Colors.black87,
// // // // //                           ),
// // // // //                           textAlign: TextAlign.center,
// // // // //                         ),
// // // // //                       ),
// // // // //                       SizedBox(
// // // // //                         width: 52,
// // // // //                         child: Text(
// // // // //                           '\$${amount == 0 ? '0' : amount.toStringAsFixed(0)}',
// // // // //                           style: const TextStyle(
// // // // //                             fontSize: 13,
// // // // //                             fontWeight: FontWeight.bold,
// // // // //                             color: Colors.black87,
// // // // //                           ),
// // // // //                           textAlign: TextAlign.right,
// // // // //                         ),
// // // // //                       ),
// // // // //                     ],
// // // // //                   ),
// // // // //                 ),
// // // // //                 if (!isLast)
// // // // //                   const Divider(height: 1, indent: 12, endIndent: 12),
// // // // //               ],
// // // // //             );
// // // // //           }),
// // // // //           const SizedBox(height: 8),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // // class _NightQtyDropdown extends StatelessWidget {
// // // // //   final int value;
// // // // //   final ValueChanged<int> onChanged;

// // // // //   const _NightQtyDropdown({required this.value, required this.onChanged});

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Container(
// // // // //       width: 52,
// // // // //       height: 34,
// // // // //       decoration: BoxDecoration(
// // // // //         border: Border.all(color: const Color(0xFFCCCCCC)),
// // // // //         borderRadius: BorderRadius.circular(6),
// // // // //         color: Colors.white,
// // // // //       ),
// // // // //       padding: const EdgeInsets.symmetric(horizontal: 4),
// // // // //       child: DropdownButtonHideUnderline(
// // // // //         child: DropdownButton<int>(
// // // // //           value: value,
// // // // //           isExpanded: true,
// // // // //           icon: const Icon(Icons.keyboard_arrow_down, size: 16),
// // // // //           style: const TextStyle(fontSize: 13, color: Colors.black87),
// // // // //           onChanged: (val) {
// // // // //             if (val != null) onChanged(val);
// // // // //           },
// // // // //           items: List.generate(
// // // // //             11,
// // // // //             (i) => i,
// // // // //           ).map((i) => DropdownMenuItem(value: i, child: Text('$i'))).toList(),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // // // ═════════════════════════════════════════════════════════════════════════════
// // // // // // SECTION 9 — ORDER SUMMARY SECTION
// // // // // // ═════════════════════════════════════════════════════════════════════════════

// // // // // class _OrderSummarySection extends ConsumerStatefulWidget {
// // // // //   final List<RoomData> rooms;
// // // // //   final List<AdditionalNight> nights;
// // // // //   final String pricePerNight;
// // // // //   final String feePerNight;

// // // // //   const _OrderSummarySection({
// // // // //     required this.rooms,
// // // // //     required this.nights,
// // // // //     required this.pricePerNight,
// // // // //     required this.feePerNight,
// // // // //   });

// // // // //   @override
// // // // //   ConsumerState<_OrderSummarySection> createState() =>
// // // // //       _OrderSummarySectionState();
// // // // // }

// // // // // class _OrderSummarySectionState extends ConsumerState<_OrderSummarySection> {
// // // // //   final _voucherCtrl = TextEditingController();

// // // // //   @override
// // // // //   void dispose() {
// // // // //     _voucherCtrl.dispose();
// // // // //     super.dispose();
// // // // //   }

// // // // //   double _calcSubTotal() {
// // // // //     final roomQtys = ref.read(roomQuantityProvider);
// // // // //     final nightQtys = ref.read(nightQuantityProvider);
// // // // //     double total = 0;
// // // // //     for (final room in widget.rooms) {
// // // // //       final qty = roomQtys[room.id] ?? 0;
// // // // //       total += qty * (double.tryParse(room.price) ?? 0);
// // // // //     }
// // // // //     for (final night in widget.nights) {
// // // // //       final qty = nightQtys[night.date] ?? 0;
// // // // //       total += qty * (double.tryParse(widget.pricePerNight) ?? 0);
// // // // //     }
// // // // //     return total;
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     ref.watch(roomQuantityProvider);
// // // // //     ref.watch(nightQuantityProvider);

// // // // //     final paymentType = ref.watch(paymentTypeProvider);
// // // // //     final membershipDiscount = ref.watch(membershipDiscountProvider);
// // // // //     final voucherDiscount = ref.watch(voucherDiscountProvider);
// // // // //     final subTotal = _calcSubTotal();
// // // // //     final total = (subTotal - membershipDiscount - voucherDiscount).clamp(
// // // // //       0.0,
// // // // //       double.infinity,
// // // // //     );

// // // // //     return Column(
// // // // //       children: [
// // // // //         // ── Payment Type ──────────────────────────────────────────────────
// // // // //         Container(
// // // // //           decoration: BoxDecoration(
// // // // //             color: Colors.white,
// // // // //             borderRadius: BorderRadius.circular(12),
// // // // //             boxShadow: [
// // // // //               BoxShadow(
// // // // //                 color: Colors.black.withOpacity(0.06),
// // // // //                 blurRadius: 8,
// // // // //                 offset: const Offset(0, 2),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //           padding: const EdgeInsets.all(16),
// // // // //           child: Column(
// // // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // // //             children: [
// // // // //               const Text(
// // // // //                 'Select Payment Type',
// // // // //                 style: TextStyle(
// // // // //                   fontSize: 15,
// // // // //                   fontWeight: FontWeight.bold,
// // // // //                   color: Colors.black87,
// // // // //                 ),
// // // // //               ),
// // // // //               const SizedBox(height: 12),
// // // // //               Row(
// // // // //                 children: [
// // // // //                   _PaymentOption(
// // // // //                     label: 'Full Payment',
// // // // //                     value: PaymentType.full,
// // // // //                     groupValue: paymentType,
// // // // //                     onChanged: (val) =>
// // // // //                         ref.read(paymentTypeProvider.notifier).state = val,
// // // // //                   ),
// // // // //                   const SizedBox(width: 24),
// // // // //                   _PaymentOption(
// // // // //                     label: 'Partial Payment',
// // // // //                     value: PaymentType.partial,
// // // // //                     groupValue: paymentType,
// // // // //                     onChanged: (val) =>
// // // // //                         ref.read(paymentTypeProvider.notifier).state = val,
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //         ),

// // // // //         const SizedBox(height: 16),

// // // // //         // ── Order Summary ─────────────────────────────────────────────────
// // // // //         Container(
// // // // //           decoration: BoxDecoration(
// // // // //             color: Colors.white,
// // // // //             borderRadius: BorderRadius.circular(12),
// // // // //             border: Border.all(color: const Color(0xFF4FC3F7), width: 1.2),
// // // // //             boxShadow: [
// // // // //               BoxShadow(
// // // // //                 color: Colors.black.withOpacity(0.06),
// // // // //                 blurRadius: 8,
// // // // //                 offset: const Offset(0, 2),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //           padding: const EdgeInsets.all(16),
// // // // //           child: Column(
// // // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // // //             children: [
// // // // //               const Text(
// // // // //                 'Order Summary',
// // // // //                 style: TextStyle(
// // // // //                   fontSize: 16,
// // // // //                   fontWeight: FontWeight.bold,
// // // // //                   color: Colors.black87,
// // // // //                 ),
// // // // //               ),
// // // // //               const SizedBox(height: 14),

// // // // //               // Voucher Input
// // // // //               Row(
// // // // //                 children: [
// // // // //                   Expanded(
// // // // //                     child: TextField(
// // // // //                       controller: _voucherCtrl,
// // // // //                       onChanged: (val) =>
// // // // //                           ref.read(voucherCodeProvider.notifier).state = val,
// // // // //                       style: const TextStyle(fontSize: 13),
// // // // //                       decoration: InputDecoration(
// // // // //                         hintText: 'Enter voucher code',
// // // // //                         hintStyle: const TextStyle(
// // // // //                           fontSize: 13,
// // // // //                           color: Colors.black38,
// // // // //                         ),
// // // // //                         contentPadding: const EdgeInsets.symmetric(
// // // // //                           horizontal: 12,
// // // // //                           vertical: 10,
// // // // //                         ),
// // // // //                         border: OutlineInputBorder(
// // // // //                           borderRadius: BorderRadius.circular(6),
// // // // //                           borderSide: const BorderSide(
// // // // //                             color: Color(0xFFCCCCCC),
// // // // //                           ),
// // // // //                         ),
// // // // //                         enabledBorder: OutlineInputBorder(
// // // // //                           borderRadius: BorderRadius.circular(6),
// // // // //                           borderSide: const BorderSide(
// // // // //                             color: Color(0xFFCCCCCC),
// // // // //                           ),
// // // // //                         ),
// // // // //                         focusedBorder: OutlineInputBorder(
// // // // //                           borderRadius: BorderRadius.circular(6),
// // // // //                           borderSide: const BorderSide(
// // // // //                             color: Color(0xFF8B0045),
// // // // //                             width: 1.5,
// // // // //                           ),
// // // // //                         ),
// // // // //                       ),
// // // // //                     ),
// // // // //                   ),
// // // // //                   const SizedBox(width: 10),
// // // // //                   ElevatedButton(
// // // // //                     onPressed: () {
// // // // //                       // TODO: call voucher API
// // // // //                       ScaffoldMessenger.of(context).showSnackBar(
// // // // //                         const SnackBar(
// // // // //                           content: Text('Voucher applied!'),
// // // // //                           backgroundColor: Color(0xFF8B0045),
// // // // //                         ),
// // // // //                       );
// // // // //                     },
// // // // //                     style: ElevatedButton.styleFrom(
// // // // //                       backgroundColor: const Color(0xFF1A0A2E),
// // // // //                       shape: RoundedRectangleBorder(
// // // // //                         borderRadius: BorderRadius.circular(6),
// // // // //                       ),
// // // // //                       padding: const EdgeInsets.symmetric(
// // // // //                         horizontal: 18,
// // // // //                         vertical: 14,
// // // // //                       ),
// // // // //                     ),
// // // // //                     child: const Text(
// // // // //                       'Apply',
// // // // //                       style: TextStyle(color: Colors.white, fontSize: 13),
// // // // //                     ),
// // // // //                   ),
// // // // //                 ],
// // // // //               ),

// // // // //               const SizedBox(height: 16),
// // // // //               const Divider(height: 1),
// // // // //               const SizedBox(height: 12),

// // // // //               // Sub Total
// // // // //               Row(
// // // // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // //                 children: [
// // // // //                   const Text(
// // // // //                     'Sub Total',
// // // // //                     style: TextStyle(fontSize: 14, color: Colors.black87),
// // // // //                   ),
// // // // //                   Text(
// // // // //                     '\$${subTotal == 0 ? '0' : subTotal.toStringAsFixed(0)}',
// // // // //                     style: TextStyle(
// // // // //                       fontSize: 14,
// // // // //                       color: subTotal == 0
// // // // //                           ? const Color(0xFF4FC3F7)
// // // // //                           : Colors.black87,
// // // // //                     ),
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //               const SizedBox(height: 8),

// // // // //               // Membership Discount
// // // // //               Row(
// // // // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // //                 children: [
// // // // //                   const Text(
// // // // //                     'Membership Discount',
// // // // //                     style: TextStyle(fontSize: 14, color: Color(0xFFD81B60)),
// // // // //                   ),
// // // // //                   Text(
// // // // //                     '-\$${membershipDiscount.toStringAsFixed(0)}',
// // // // //                     style: const TextStyle(
// // // // //                       fontSize: 14,
// // // // //                       color: Color(0xFFD81B60),
// // // // //                     ),
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //               const SizedBox(height: 8),

// // // // //               // Voucher Discount
// // // // //               Row(
// // // // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // //                 children: [
// // // // //                   const Text(
// // // // //                     'Voucher Discount',
// // // // //                     style: TextStyle(fontSize: 14, color: Color(0xFF2E7D32)),
// // // // //                   ),
// // // // //                   Text(
// // // // //                     '-\$${voucherDiscount.toStringAsFixed(0)}',
// // // // //                     style: const TextStyle(
// // // // //                       fontSize: 14,
// // // // //                       color: Color(0xFF2E7D32),
// // // // //                     ),
// // // // //                   ),
// // // // //                 ],
// // // // //               ),

// // // // //               const SizedBox(height: 12),
// // // // //               const Divider(height: 1),
// // // // //               const SizedBox(height: 12),

// // // // //               // Total
// // // // //               Row(
// // // // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // //                 children: [
// // // // //                   const Text(
// // // // //                     'Total',
// // // // //                     style: TextStyle(
// // // // //                       fontSize: 18,
// // // // //                       fontWeight: FontWeight.bold,
// // // // //                       color: Colors.black87,
// // // // //                     ),
// // // // //                   ),
// // // // //                   Text(
// // // // //                     '\$${total.toStringAsFixed(0)}',
// // // // //                     style: const TextStyle(
// // // // //                       fontSize: 18,
// // // // //                       fontWeight: FontWeight.bold,
// // // // //                       color: Colors.black87,
// // // // //                     ),
// // // // //                   ),
// // // // //                 ],
// // // // //               ),

// // // // //               const SizedBox(height: 18),

// // // // //               // Buy Ticket Button
// // // // //               SizedBox(
// // // // //                 width: double.infinity,
// // // // //                 child: ElevatedButton(
// // // // //                   onPressed: () {
// // // // //                     // TODO: Handle buy ticket API
// // // // //                     ScaffoldMessenger.of(context).showSnackBar(
// // // // //                       const SnackBar(
// // // // //                         content: Text('Processing your ticket...'),
// // // // //                         backgroundColor: Color(0xFF8B0045),
// // // // //                       ),
// // // // //                     );
// // // // //                   },
// // // // //                   style: ElevatedButton.styleFrom(
// // // // //                     backgroundColor: const Color(0xFF1A0A2E),
// // // // //                     shape: RoundedRectangleBorder(
// // // // //                       borderRadius: BorderRadius.circular(8),
// // // // //                     ),
// // // // //                     padding: const EdgeInsets.symmetric(vertical: 16),
// // // // //                   ),
// // // // //                   child: const Text(
// // // // //                     'BUY TICKET',
// // // // //                     style: TextStyle(
// // // // //                       color: Colors.white,
// // // // //                       fontSize: 15,
// // // // //                       fontWeight: FontWeight.bold,
// // // // //                       letterSpacing: 1,
// // // // //                     ),
// // // // //                   ),
// // // // //                 ),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //         ),
// // // // //       ],
// // // // //     );
// // // // //   }
// // // // // }

// // // // // class _PaymentOption extends StatelessWidget {
// // // // //   final String label;
// // // // //   final PaymentType value;
// // // // //   final PaymentType? groupValue;
// // // // //   final ValueChanged<PaymentType?> onChanged;

// // // // //   const _PaymentOption({
// // // // //     required this.label,
// // // // //     required this.value,
// // // // //     required this.groupValue,
// // // // //     required this.onChanged,
// // // // //   });

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Row(
// // // // //       children: [
// // // // //         Radio<PaymentType>(
// // // // //           value: value,
// // // // //           groupValue: groupValue,
// // // // //           activeColor: const Color(0xFF8B0045),
// // // // //           onChanged: onChanged,
// // // // //         ),
// // // // //         Text(
// // // // //           label,
// // // // //           style: const TextStyle(fontSize: 14, color: Colors.black87),
// // // // //         ),
// // // // //       ],
// // // // //     );
// // // // //   }
// // // // // }
// // // // // =============================================================================
// // // // //  event_detail_page.dart
// // // // //  Beat Flirt — Complete single-file with AuthService token integration.
// // // // //
// // // // //  ✅ Token is fetched AUTOMATICALLY from SharedPreferences via AuthService.
// // // // //  ✅ You only need to pass eventId when navigating. That's it!
// // // // //
// // // // //  HOW TO NAVIGATE HERE (from any screen):
// // // // //  ─────────────────────────────────────────
// // // // //  Navigator.push(
// // // // //    context,
// // // // //    MaterialPageRoute(
// // // // //      builder: (_) => EventDetailScreen(eventId: event.id),
// // // // //    ),
// // // // //  );
// // // // //
// // // // //  Dependencies (pubspec.yaml):
// // // // //    flutter_riverpod: ^2.5.1
// // // // //    http: ^1.2.1
// // // // //    shared_preferences: ^2.2.2
// // // // // =============================================================================

// // // // import 'dart:convert';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // import 'package:http/http.dart' as http;
// // // // import 'package:shared_preferences/shared_preferences.dart';

// // // // // ═════════════════════════════════════════════════════════════════════════════
// // // // // SECTION 1 — AUTH SERVICE (reads token from SharedPreferences)
// // // // // ═════════════════════════════════════════════════════════════════════════════

// // // // /// Lightweight copy of your AuthService — only what this file needs.
// // // // /// The token is stored under the key "auth_token" in SharedPreferences,
// // // // /// saved when the user logs in. We simply read it here.
// // // // class _AuthService {
// // // //   static const String _tokenKey = 'auth_token';

// // // //   /// Returns the Bearer token saved at login time, or null if not logged in.
// // // //   static Future<String?> getToken() async {
// // // //     final prefs = await SharedPreferences.getInstance();
// // // //     return prefs.getString(_tokenKey);
// // // //   }
// // // // }

// // // // // ═════════════════════════════════════════════════════════════════════════════
// // // // // SECTION 2 — MODELS
// // // // // ═════════════════════════════════════════════════════════════════════════════

// // // // class EventDetailResponse {
// // // //   final String status;
// // // //   final EventData data;
// // // //   final List<AdditionalNight> additionalNights;
// // // //   final RoomListResponse roomList;

// // // //   EventDetailResponse({
// // // //     required this.status,
// // // //     required this.data,
// // // //     required this.additionalNights,
// // // //     required this.roomList,
// // // //   });

// // // //   factory EventDetailResponse.fromJson(Map<String, dynamic> json) {
// // // //     return EventDetailResponse(
// // // //       status: json['status'] ?? '',
// // // //       data: EventData.fromJson(json['data'] ?? {}),
// // // //       additionalNights: (json['additional_night'] as List<dynamic>? ?? [])
// // // //           .map((e) => AdditionalNight.fromJson(e))
// // // //           .toList(),
// // // //       roomList: RoomListResponse.fromJson(json['room_list'] ?? {}),
// // // //     );
// // // //   }
// // // // }

// // // // class EventData {
// // // //   final String id;
// // // //   final String eventName;
// // // //   final String eventFromDate;
// // // //   final String eventToDate;
// // // //   final String eventFromTime;
// // // //   final String eventToTime;
// // // //   final String eventType;
// // // //   final String additionalRoomNightPrice;
// // // //   final String additionalRoomNightFee;
// // // //   final String formattedAddress;
// // // //   final String eventImage;
// // // //   final String eventPrice;
// // // //   final String eventNoOfTicket;
// // // //   final String eventEmail;
// // // //   final String eventDescription;
// // // //   final String status;
// // // //   final String lat;
// // // //   final String lng;
// // // //   final String cityName;

// // // //   EventData({
// // // //     required this.id,
// // // //     required this.eventName,
// // // //     required this.eventFromDate,
// // // //     required this.eventToDate,
// // // //     required this.eventFromTime,
// // // //     required this.eventToTime,
// // // //     required this.eventType,
// // // //     required this.additionalRoomNightPrice,
// // // //     required this.additionalRoomNightFee,
// // // //     required this.formattedAddress,
// // // //     required this.eventImage,
// // // //     required this.eventPrice,
// // // //     required this.eventNoOfTicket,
// // // //     required this.eventEmail,
// // // //     required this.eventDescription,
// // // //     required this.status,
// // // //     required this.lat,
// // // //     required this.lng,
// // // //     required this.cityName,
// // // //   });

// // // //   factory EventData.fromJson(Map<String, dynamic> json) {
// // // //     return EventData(
// // // //       id: json['id'] ?? '',
// // // //       eventName: json['event_name'] ?? '',
// // // //       eventFromDate: json['event_from_date'] ?? '',
// // // //       eventToDate: json['event_to_date'] ?? '',
// // // //       eventFromTime: json['event_from_time'] ?? '',
// // // //       eventToTime: json['event_to_time'] ?? '',
// // // //       eventType: json['event_type'] ?? '',
// // // //       additionalRoomNightPrice: json['additional_room_night_price'] ?? '0',
// // // //       additionalRoomNightFee: json['additional_room_night_fee'] ?? '0',
// // // //       formattedAddress: json['formatted_address'] ?? '',
// // // //       eventImage: json['event_image'] ?? '',
// // // //       eventPrice: json['event_price'] ?? '0',
// // // //       eventNoOfTicket: json['event_no_of_ticket'] ?? '0',
// // // //       eventEmail: json['event_email'] ?? '',
// // // //       eventDescription: json['event_description'] ?? '',
// // // //       status: json['status']?.toString() ?? '',
// // // //       lat: json['lat'] ?? '',
// // // //       lng: json['lng'] ?? '',
// // // //       cityName: json['city_name'] ?? '',
// // // //     );
// // // //   }
// // // // }

// // // // class AdditionalNight {
// // // //   final String date;
// // // //   final String day;

// // // //   AdditionalNight({required this.date, required this.day});

// // // //   factory AdditionalNight.fromJson(Map<String, dynamic> json) {
// // // //     return AdditionalNight(
// // // //       date: json['date'] ?? '',
// // // //       day: json['day'] ?? '',
// // // //     );
// // // //   }
// // // // }

// // // // class RoomListResponse {
// // // //   final String status;
// // // //   final List<RoomData> data;

// // // //   RoomListResponse({required this.status, required this.data});

// // // //   factory RoomListResponse.fromJson(Map<String, dynamic> json) {
// // // //     return RoomListResponse(
// // // //       status: json['status']?.toString() ?? '',
// // // //       data: (json['data'] as List<dynamic>? ?? [])
// // // //           .map((e) => RoomData.fromJson(e))
// // // //           .toList(),
// // // //     );
// // // //   }
// // // // }

// // // // class RoomData {
// // // //   final String id;
// // // //   final String roomName;
// // // //   final String price;
// // // //   final String fee;
// // // //   final String fullDescription;
// // // //   final String shortDescription;
// // // //   final String roomAvailable;
// // // //   final String roomImage;

// // // //   RoomData({
// // // //     required this.id,
// // // //     required this.roomName,
// // // //     required this.price,
// // // //     required this.fee,
// // // //     required this.fullDescription,
// // // //     required this.shortDescription,
// // // //     required this.roomAvailable,
// // // //     required this.roomImage,
// // // //   });

// // // //   factory RoomData.fromJson(Map<String, dynamic> json) {
// // // //     return RoomData(
// // // //       id: json['id'] ?? '',
// // // //       roomName: json['room_name'] ?? '',
// // // //       price: json['price'] ?? '0',
// // // //       fee: json['fee'] ?? '0',
// // // //       fullDescription: json['full_description'] ?? '',
// // // //       shortDescription: json['short_description'] ?? '',
// // // //       roomAvailable: json['room_available'] ?? '0',
// // // //       roomImage: json['room_image'] ?? '',
// // // //     );
// // // //   }
// // // // }

// // // // // ── Guest Models ──────────────────────────────────────────────────────────────

// // // // enum GuestType { single, couple }

// // // // class SingleGuest {
// // // //   final String id;
// // // //   String username;
// // // //   String fullName;
// // // //   String email;
// // // //   String phone;
// // // //   String? idProofPath;

// // // //   SingleGuest({
// // // //     required this.id,
// // // //     this.username = '',
// // // //     this.fullName = '',
// // // //     this.email = '',
// // // //     this.phone = '',
// // // //     this.idProofPath,
// // // //   });

// // // //   SingleGuest copyWith({
// // // //     String? username,
// // // //     String? fullName,
// // // //     String? email,
// // // //     String? phone,
// // // //     String? idProofPath,
// // // //   }) {
// // // //     return SingleGuest(
// // // //       id: id,
// // // //       username: username ?? this.username,
// // // //       fullName: fullName ?? this.fullName,
// // // //       email: email ?? this.email,
// // // //       phone: phone ?? this.phone,
// // // //       idProofPath: idProofPath ?? this.idProofPath,
// // // //     );
// // // //   }
// // // // }

// // // // class CoupleGuest {
// // // //   final String id;
// // // //   String username1;
// // // //   String fullName1;
// // // //   String email1;
// // // //   String phone1;
// // // //   String? idProofPath1;
// // // //   String username2;
// // // //   String fullName2;
// // // //   String email2;
// // // //   String phone2;
// // // //   String? idProofPath2;

// // // //   CoupleGuest({
// // // //     required this.id,
// // // //     this.username1 = '',
// // // //     this.fullName1 = '',
// // // //     this.email1 = '',
// // // //     this.phone1 = '',
// // // //     this.idProofPath1,
// // // //     this.username2 = '',
// // // //     this.fullName2 = '',
// // // //     this.email2 = '',
// // // //     this.phone2 = '',
// // // //     this.idProofPath2,
// // // //   });

// // // //   CoupleGuest copyWith({
// // // //     String? username1,
// // // //     String? fullName1,
// // // //     String? email1,
// // // //     String? phone1,
// // // //     String? idProofPath1,
// // // //     String? username2,
// // // //     String? fullName2,
// // // //     String? email2,
// // // //     String? phone2,
// // // //     String? idProofPath2,
// // // //   }) {
// // // //     return CoupleGuest(
// // // //       id: id,
// // // //       username1: username1 ?? this.username1,
// // // //       fullName1: fullName1 ?? this.fullName1,
// // // //       email1: email1 ?? this.email1,
// // // //       phone1: phone1 ?? this.phone1,
// // // //       idProofPath1: idProofPath1 ?? this.idProofPath1,
// // // //       username2: username2 ?? this.username2,
// // // //       fullName2: fullName2 ?? this.fullName2,
// // // //       email2: email2 ?? this.email2,
// // // //       phone2: phone2 ?? this.phone2,
// // // //       idProofPath2: idProofPath2 ?? this.idProofPath2,
// // // //     );
// // // //   }
// // // // }

// // // // // ═════════════════════════════════════════════════════════════════════════════
// // // // // SECTION 3 — REPOSITORY
// // // // // ═════════════════════════════════════════════════════════════════════════════

// // // // class EventRepository {
// // // //   static const String _baseUrl =
// // // //       'https://app.beatflirtevent.com/App/events/get_single_events';

// // // //   /// Fetches token automatically from SharedPreferences, then calls the API.
// // // //   Future<EventDetailResponse> getSingleEvent({required String eventId}) async {
// // // //     // ✅ Get token from SharedPreferences — same source your AuthService saves to
// // // //     final token = await _AuthService.getToken();

// // // //     if (token == null || token.isEmpty) {
// // // //       throw Exception('Not authenticated. Please log in again.');
// // // //     }

// // // //     final response = await http.post(
// // // //       Uri.parse(_baseUrl),
// // // //       headers: {
// // // //         'Content-Type': 'application/json',
// // // //         'Authorization': 'Bearer $token', // ✅ Bearer token attached here
// // // //       },
// // // //       body: jsonEncode({'event_id': eventId}),
// // // //     );

// // // //     if (response.statusCode == 200) {
// // // //       final json = jsonDecode(response.body) as Map<String, dynamic>;
// // // //       if (json['status']?.toString() == '200') {
// // // //         return EventDetailResponse.fromJson(json);
// // // //       } else {
// // // //         throw Exception(json['message'] ?? 'Failed to load event');
// // // //       }
// // // //     } else {
// // // //       throw Exception(
// // // //           'Server error: ${response.statusCode} - ${response.reasonPhrase}');
// // // //     }
// // // //   }
// // // // }

// // // // // ═════════════════════════════════════════════════════════════════════════════
// // // // // SECTION 4 — RIVERPOD PROVIDERS
// // // // // ═════════════════════════════════════════════════════════════════════════════

// // // // // ── Repository ────────────────────────────────────────────────────────────────
// // // // final eventRepositoryProvider = Provider<EventRepository>((ref) {
// // // //   return EventRepository();
// // // // });

// // // // // ── Event Detail — only needs eventId now, token is fetched internally ─────────
// // // // final eventDetailProvider =
// // // //     FutureProvider.family<EventDetailResponse, String>((ref, eventId) async {
// // // //   final repo = ref.read(eventRepositoryProvider);
// // // //   return repo.getSingleEvent(eventId: eventId);
// // // // });

// // // // // ── Room Quantity ─────────────────────────────────────────────────────────────
// // // // class RoomQuantityNotifier extends StateNotifier<Map<String, int>> {
// // // //   RoomQuantityNotifier() : super({});

// // // //   void setQuantity(String roomId, int qty) =>
// // // //       state = {...state, roomId: qty};

// // // //   int getQuantity(String roomId) => state[roomId] ?? 0;

// // // //   double totalAmount(List<RoomData> rooms) {
// // // //     double total = 0;
// // // //     for (final room in rooms) {
// // // //       final qty = state[room.id] ?? 0;
// // // //       if (qty > 0) total += qty * (double.tryParse(room.price) ?? 0);
// // // //     }
// // // //     return total;
// // // //   }
// // // // }

// // // // final roomQuantityProvider =
// // // //     StateNotifierProvider<RoomQuantityNotifier, Map<String, int>>(
// // // //         (ref) => RoomQuantityNotifier());

// // // // // ── Night Quantity ────────────────────────────────────────────────────────────
// // // // class NightQuantityNotifier extends StateNotifier<Map<String, int>> {
// // // //   NightQuantityNotifier() : super({});

// // // //   void setQuantity(String date, int qty) =>
// // // //       state = {...state, date: qty};

// // // //   int getQuantity(String date) => state[date] ?? 0;

// // // //   double totalAmount(String pricePerNight) {
// // // //     final price = double.tryParse(pricePerNight) ?? 0;
// // // //     final totalQty = state.values.fold(0, (a, b) => a + b);
// // // //     return totalQty * price;
// // // //   }
// // // // }

// // // // final nightQuantityProvider =
// // // //     StateNotifierProvider<NightQuantityNotifier, Map<String, int>>(
// // // //         (ref) => NightQuantityNotifier());

// // // // // ── Guest List ────────────────────────────────────────────────────────────────
// // // // class GuestListState {
// // // //   final List<SingleGuest> singleGuests;
// // // //   final List<CoupleGuest> coupleGuests;
// // // //   final bool showValidation;

// // // //   const GuestListState({
// // // //     this.singleGuests = const [],
// // // //     this.coupleGuests = const [],
// // // //     this.showValidation = false,
// // // //   });

// // // //   GuestListState copyWith({
// // // //     List<SingleGuest>? singleGuests,
// // // //     List<CoupleGuest>? coupleGuests,
// // // //     bool? showValidation,
// // // //   }) {
// // // //     return GuestListState(
// // // //       singleGuests: singleGuests ?? this.singleGuests,
// // // //       coupleGuests: coupleGuests ?? this.coupleGuests,
// // // //       showValidation: showValidation ?? this.showValidation,
// // // //     );
// // // //   }
// // // // }

// // // // class GuestListNotifier extends StateNotifier<GuestListState> {
// // // //   GuestListNotifier() : super(const GuestListState());

// // // //   int _singleCounter = 0;
// // // //   int _coupleCounter = 0;

// // // //   void addSingleGuest() {
// // // //     _singleCounter++;
// // // //     state = state.copyWith(singleGuests: [
// // // //       ...state.singleGuests,
// // // //       SingleGuest(id: 'single_$_singleCounter')
// // // //     ]);
// // // //   }

// // // //   void removeSingleGuest(String id) => state = state.copyWith(
// // // //       singleGuests: state.singleGuests.where((g) => g.id != id).toList());

// // // //   void updateSingleGuest(String id, SingleGuest updated) =>
// // // //       state = state.copyWith(
// // // //         singleGuests:
// // // //             state.singleGuests.map((g) => g.id == id ? updated : g).toList(),
// // // //       );

// // // //   void addCoupleGuest() {
// // // //     _coupleCounter++;
// // // //     state = state.copyWith(coupleGuests: [
// // // //       ...state.coupleGuests,
// // // //       CoupleGuest(id: 'couple_$_coupleCounter')
// // // //     ]);
// // // //   }

// // // //   void removeCoupleGuest(String id) => state = state.copyWith(
// // // //       coupleGuests: state.coupleGuests.where((g) => g.id != id).toList());

// // // //   void updateCoupleGuest(String id, CoupleGuest updated) =>
// // // //       state = state.copyWith(
// // // //         coupleGuests:
// // // //             state.coupleGuests.map((g) => g.id == id ? updated : g).toList(),
// // // //       );

// // // //   void setShowValidation(bool val) =>
// // // //       state = state.copyWith(showValidation: val);

// // // //   bool validate() {
// // // //     state = state.copyWith(showValidation: true);
// // // //     for (final g in state.singleGuests) {
// // // //       if (g.username.trim().isEmpty ||
// // // //           g.fullName.trim().isEmpty ||
// // // //           g.email.trim().isEmpty ||
// // // //           g.phone.trim().isEmpty) return false;
// // // //     }
// // // //     for (final g in state.coupleGuests) {
// // // //       if (g.username1.trim().isEmpty ||
// // // //           g.fullName1.trim().isEmpty ||
// // // //           g.email1.trim().isEmpty ||
// // // //           g.phone1.trim().isEmpty ||
// // // //           g.fullName2.trim().isEmpty ||
// // // //           g.email2.trim().isEmpty ||
// // // //           g.phone2.trim().isEmpty) return false;
// // // //     }
// // // //     return true;
// // // //   }
// // // // }

// // // // final guestListProvider =
// // // //     StateNotifierProvider<GuestListNotifier, GuestListState>(
// // // //         (ref) => GuestListNotifier());

// // // // // ── Payment / Voucher / UI State ──────────────────────────────────────────────
// // // // enum PaymentType { full, partial }

// // // // final paymentTypeProvider = StateProvider<PaymentType?>((ref) => null);
// // // // final voucherCodeProvider = StateProvider<String>((ref) => '');
// // // // final voucherDiscountProvider = StateProvider<double>((ref) => 0.0);
// // // // final membershipDiscountProvider = StateProvider<double>((ref) => 0.0);
// // // // final descriptionExpandedProvider = StateProvider<bool>((ref) => false);

// // // // // ═════════════════════════════════════════════════════════════════════════════
// // // // // SECTION 5 — SCREEN
// // // // // ═════════════════════════════════════════════════════════════════════════════

// // // // /// ✅ Only pass [eventId]. Token is read automatically from SharedPreferences.
// // // // ///
// // // // /// Navigate like this (from anywhere):
// // // // /// ```dart
// // // // /// Navigator.push(context, MaterialPageRoute(
// // // // ///   builder: (_) => EventDetailScreen(eventId: event.id),
// // // // /// ));
// // // // /// ```
// // // // class EventDetailScreen extends ConsumerWidget {
// // // //   final String eventId;

// // // //   const EventDetailScreen({
// // // //     super.key,
// // // //     required this.eventId,
// // // //   });

// // // //   @override
// // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // //     final asyncEvent = ref.watch(eventDetailProvider(eventId));

// // // //     return Scaffold(
// // // //       backgroundColor: const Color(0xFFFFF0F5),
// // // //       appBar: AppBar(
// // // //         backgroundColor: Colors.white,
// // // //         elevation: 0.5,
// // // //         leading: const SizedBox.shrink(),
// // // //         title: const Text(
// // // //           'Parties And Events',
// // // //           style: TextStyle(
// // // //               color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
// // // //         ),
// // // //         actions: [
// // // //           Padding(
// // // //             padding: const EdgeInsets.only(right: 12),
// // // //             child: ElevatedButton.icon(
// // // //               onPressed: () => Navigator.of(context).pop(),
// // // //               icon: const Icon(Icons.arrow_back, size: 16, color: Colors.white),
// // // //               label: const Text('Back',
// // // //                   style: TextStyle(color: Colors.white, fontSize: 13)),
// // // //               style: ElevatedButton.styleFrom(
// // // //                 backgroundColor: const Color(0xFF8B0045),
// // // //                 shape: RoundedRectangleBorder(
// // // //                     borderRadius: BorderRadius.circular(20)),
// // // //                 padding:
// // // //                     const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
// // // //               ),
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       body: asyncEvent.when(
// // // //         loading: () => const Center(
// // // //             child: CircularProgressIndicator(color: Color(0xFF8B0045))),
// // // //         error: (err, _) => _buildError(context, ref, err),
// // // //         data: (eventResponse) => _buildContent(eventResponse),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildError(BuildContext context, WidgetRef ref, Object err) {
// // // //     final isAuthError = err.toString().contains('authenticated') ||
// // // //         err.toString().contains('log in');
// // // //     return Center(
// // // //       child: Padding(
// // // //         padding: const EdgeInsets.all(24),
// // // //         child: Column(
// // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // //           children: [
// // // //             Icon(
// // // //               isAuthError ? Icons.lock_outline : Icons.error_outline,
// // // //               size: 60,
// // // //               color: const Color(0xFF8B0045),
// // // //             ),
// // // //             const SizedBox(height: 16),
// // // //             Text(
// // // //               isAuthError ? 'Session Expired' : 'Failed to load event',
// // // //               style: const TextStyle(
// // // //                   fontSize: 18,
// // // //                   fontWeight: FontWeight.bold,
// // // //                   color: Colors.black87),
// // // //             ),
// // // //             const SizedBox(height: 8),
// // // //             Text(
// // // //               isAuthError
// // // //                   ? 'Your session has expired. Please log in again.'
// // // //                   : err.toString(),
// // // //               textAlign: TextAlign.center,
// // // //               style: const TextStyle(color: Colors.grey, fontSize: 13),
// // // //             ),
// // // //             const SizedBox(height: 20),
// // // //             ElevatedButton.icon(
// // // //               style: ElevatedButton.styleFrom(
// // // //                   backgroundColor: const Color(0xFF8B0045)),
// // // //               onPressed: () => ref.refresh(eventDetailProvider(eventId)),
// // // //               icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
// // // //               label: const Text('Retry',
// // // //                   style: TextStyle(color: Colors.white)),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildContent(EventDetailResponse eventResponse) {
// // // //     return SingleChildScrollView(
// // // //       padding: const EdgeInsets.all(16),
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //         children: [
// // // //           _EventHeaderCard(event: eventResponse.data),
// // // //           const SizedBox(height: 16),
// // // //           const _GuestSection(),
// // // //           const SizedBox(height: 16),
// // // //           if (eventResponse.roomList.data.isNotEmpty) ...[
// // // //             _RoomPackageSection(rooms: eventResponse.roomList.data),
// // // //             const SizedBox(height: 16),
// // // //           ],
// // // //           if (eventResponse.additionalNights.isNotEmpty) ...[
// // // //             _AdditionalNightSection(
// // // //               nights: eventResponse.additionalNights,
// // // //               pricePerNight: eventResponse.data.additionalRoomNightPrice,
// // // //               feePerNight: eventResponse.data.additionalRoomNightFee,
// // // //             ),
// // // //             const SizedBox(height: 16),
// // // //           ],
// // // //           _OrderSummarySection(
// // // //             rooms: eventResponse.roomList.data,
// // // //             nights: eventResponse.additionalNights,
// // // //             pricePerNight: eventResponse.data.additionalRoomNightPrice,
// // // //             feePerNight: eventResponse.data.additionalRoomNightFee,
// // // //           ),
// // // //           const SizedBox(height: 30),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // // ═════════════════════════════════════════════════════════════════════════════
// // // // // SECTION 6 — EVENT HEADER CARD
// // // // // ═════════════════════════════════════════════════════════════════════════════

// // // // class _EventHeaderCard extends ConsumerWidget {
// // // //   final EventData event;
// // // //   const _EventHeaderCard({required this.event});

// // // //   String _formatDate(String date, String time) {
// // // //     try {
// // // //       final parts = date.split('-');
// // // //       if (parts.length < 3) return '$date $time';
// // // //       final months = [
// // // //         '', 'January', 'February', 'March', 'April', 'May', 'June',
// // // //         'July', 'August', 'September', 'October', 'November', 'December'
// // // //       ];
// // // //       final year = parts[0];
// // // //       final month = int.tryParse(parts[1]) ?? 0;
// // // //       final day = int.tryParse(parts[2]) ?? 0;
// // // //       final monthName = month < months.length ? months[month] : parts[1];
// // // //       final timeParts = time.split(':');
// // // //       int hour = int.tryParse(timeParts[0]) ?? 0;
// // // //       final min = timeParts.length > 1 ? timeParts[1] : '00';
// // // //       final period = hour >= 12 ? 'pm' : 'am';
// // // //       hour = hour % 12;
// // // //       if (hour == 0) hour = 12;
// // // //       final dt = DateTime.tryParse(date);
// // // //       final days = [
// // // //         '', 'Monday', 'Tuesday', 'Wednesday', 'Thursday',
// // // //         'Friday', 'Saturday', 'Sunday'
// // // //       ];
// // // //       final dayName = dt != null ? days[dt.weekday] : '';
// // // //       return '$dayName, $monthName $day, $year  $hour:$min $period';
// // // //     } catch (_) {
// // // //       return '$date $time';
// // // //     }
// // // //   }

// // // //   String _stripHtml(String html) {
// // // //     return html
// // // //         .replaceAll('&amp;lt;', '<')
// // // //         .replaceAll('&amp;gt;', '>')
// // // //         .replaceAll('&amp;amp;', '&')
// // // //         .replaceAll('&amp;nbsp;', ' ')
// // // //         .replaceAll('&lt;', '<')
// // // //         .replaceAll('&gt;', '>')
// // // //         .replaceAll('&amp;', '&')
// // // //         .replaceAll('&nbsp;', ' ')
// // // //         .replaceAll('\r\n', ' ')
// // // //         .replaceAll(RegExp(r'<[^>]*>'), '')
// // // //         .trim();
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // //     final isExpanded = ref.watch(descriptionExpandedProvider);
// // // //     final cleanDescription = _stripHtml(event.eventDescription);
// // // //     const maxChars = 80;
// // // //     final isLong = cleanDescription.length > maxChars;
// // // //     final displayText = (!isExpanded && isLong)
// // // //         ? '${cleanDescription.substring(0, maxChars)}...'
// // // //         : cleanDescription;

// // // //     return Container(
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.white,
// // // //         borderRadius: BorderRadius.circular(12),
// // // //         boxShadow: [
// // // //           BoxShadow(
// // // //               color: Colors.black.withOpacity(0.06),
// // // //               blurRadius: 8,
// // // //               offset: const Offset(0, 2))
// // // //         ],
// // // //       ),
// // // //       child: Padding(
// // // //         padding: const EdgeInsets.all(16),
// // // //         child: Column(
// // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // //           children: [
// // // //             Row(
// // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // //               children: [
// // // //                 // Event Image
// // // //                 ClipRRect(
// // // //                   borderRadius: BorderRadius.circular(10),
// // // //                   child: Image.network(
// // // //                     event.eventImage,
// // // //                     width: 140,
// // // //                     height: 160,
// // // //                     fit: BoxFit.cover,
// // // //                     errorBuilder: (_, __, ___) => Container(
// // // //                       width: 140,
// // // //                       height: 160,
// // // //                       color: Colors.grey[200],
// // // //                       child: const Icon(Icons.image_not_supported,
// // // //                           color: Colors.grey, size: 40),
// // // //                     ),
// // // //                     loadingBuilder: (_, child, progress) {
// // // //                       if (progress == null) return child;
// // // //                       return Container(
// // // //                         width: 140,
// // // //                         height: 160,
// // // //                         color: Colors.grey[100],
// // // //                         child: const Center(
// // // //                             child: CircularProgressIndicator(
// // // //                                 strokeWidth: 2,
// // // //                                 color: Color(0xFF8B0045))),
// // // //                       );
// // // //                     },
// // // //                   ),
// // // //                 ),
// // // //                 const SizedBox(width: 14),
// // // //                 // Details
// // // //                 Expanded(
// // // //                   child: Column(
// // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // //                     children: [
// // // //                       Text(event.eventName,
// // // //                           style: const TextStyle(
// // // //                               fontSize: 18,
// // // //                               fontWeight: FontWeight.bold,
// // // //                               color: Colors.black87)),
// // // //                       const SizedBox(height: 8),
// // // //                       Text(
// // // //                         '${_formatDate(event.eventFromDate, event.eventFromTime)}  –  ${_formatDate(event.eventToDate, event.eventToTime)}',
// // // //                         style: const TextStyle(
// // // //                             fontSize: 12, color: Colors.black54),
// // // //                       ),
// // // //                       const SizedBox(height: 8),
// // // //                       if (event.formattedAddress.isNotEmpty)
// // // //                         Row(
// // // //                           crossAxisAlignment: CrossAxisAlignment.start,
// // // //                           children: [
// // // //                             const Icon(Icons.location_on,
// // // //                                 size: 15, color: Color(0xFF8B0045)),
// // // //                             const SizedBox(width: 4),
// // // //                             Expanded(
// // // //                               child: Text(event.formattedAddress,
// // // //                                   style: const TextStyle(
// // // //                                       fontSize: 12, color: Colors.black87)),
// // // //                             ),
// // // //                           ],
// // // //                         ),
// // // //                       const SizedBox(height: 8),
// // // //                       if (event.eventEmail.isNotEmpty)
// // // //                         Text('contacted by:- ${event.eventEmail}',
// // // //                             style: const TextStyle(
// // // //                                 fontSize: 12, color: Colors.black54)),
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //             const SizedBox(height: 14),
// // // //             const Text('Description',
// // // //                 style: TextStyle(
// // // //                     fontSize: 14,
// // // //                     fontWeight: FontWeight.bold,
// // // //                     color: Colors.black87)),
// // // //             const SizedBox(height: 6),
// // // //             Text(displayText,
// // // //                 style: const TextStyle(
// // // //                     fontSize: 13, color: Color(0xFFD81B60))),
// // // //             if (isLong) ...[
// // // //               const SizedBox(height: 4),
// // // //               GestureDetector(
// // // //                 onTap: () => ref
// // // //                     .read(descriptionExpandedProvider.notifier)
// // // //                     .state = !isExpanded,
// // // //                 child: Text(
// // // //                   isExpanded ? 'Show Less' : 'Show More...',
// // // //                   style: const TextStyle(
// // // //                       fontSize: 13,
// // // //                       color: Colors.black87,
// // // //                       fontWeight: FontWeight.w500),
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // // ═════════════════════════════════════════════════════════════════════════════
// // // // // SECTION 7 — GUEST SECTION
// // // // // ═════════════════════════════════════════════════════════════════════════════

// // // // class _GuestSection extends ConsumerWidget {
// // // //   const _GuestSection();

// // // //   @override
// // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // //     final guestState = ref.watch(guestListProvider);

// // // //     return Container(
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.white,
// // // //         borderRadius: BorderRadius.circular(12),
// // // //         boxShadow: [
// // // //           BoxShadow(
// // // //               color: Colors.black.withOpacity(0.06),
// // // //               blurRadius: 8,
// // // //               offset: const Offset(0, 2))
// // // //         ],
// // // //       ),
// // // //       padding: const EdgeInsets.all(16),
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //         children: [
// // // //           // Auto-fill checkbox
// // // //           Row(
// // // //             children: [
// // // //               Checkbox(
// // // //                   value: false,
// // // //                   activeColor: const Color(0xFF8B0045),
// // // //                   onChanged: (_) {}),
// // // //               const Text('Click here to generate your information',
// // // //                   style: TextStyle(fontSize: 13, color: Colors.black87)),
// // // //             ],
// // // //           ),
// // // //           const SizedBox(height: 8),

// // // //           // Add Guest buttons
// // // //           Row(
// // // //             children: [
// // // //               const Text('Add Guest:',
// // // //                   style: TextStyle(
// // // //                       fontSize: 14,
// // // //                       fontWeight: FontWeight.bold,
// // // //                       color: Color(0xFFD81B60))),
// // // //               const SizedBox(width: 12),
// // // //               _GuestTypeButton(
// // // //                 icon: Icons.person,
// // // //                 label: 'Single',
// // // //                 onTap: () =>
// // // //                     ref.read(guestListProvider.notifier).addSingleGuest(),
// // // //               ),
// // // //               const SizedBox(width: 10),
// // // //               _GuestTypeButton(
// // // //                 icon: Icons.people,
// // // //                 label: 'Couple',
// // // //                 onTap: () =>
// // // //                     ref.read(guestListProvider.notifier).addCoupleGuest(),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //           const SizedBox(height: 14),

// // // //           // Single guest cards
// // // //           ...guestState.singleGuests.asMap().entries.map(
// // // //                 (entry) => Padding(
// // // //                   padding: const EdgeInsets.only(bottom: 12),
// // // //                   child: _SingleGuestCard(
// // // //                     guest: entry.value,
// // // //                     index: entry.key + 1,
// // // //                     showValidation: guestState.showValidation,
// // // //                   ),
// // // //                 ),
// // // //               ),

// // // //           // Couple guest cards
// // // //           ...guestState.coupleGuests.asMap().entries.map(
// // // //                 (entry) => Padding(
// // // //                   padding: const EdgeInsets.only(bottom: 12),
// // // //                   child: _CoupleGuestCard(
// // // //                     guest: entry.value,
// // // //                     index: entry.key + 1,
// // // //                     showValidation: guestState.showValidation,
// // // //                   ),
// // // //                 ),
// // // //               ),

// // // //           // Add Guests to List button
// // // //           if (guestState.singleGuests.isNotEmpty ||
// // // //               guestState.coupleGuests.isNotEmpty) ...[
// // // //             const SizedBox(height: 8),
// // // //             Center(
// // // //               child: ElevatedButton(
// // // //                 onPressed: () {
// // // //                   final isValid =
// // // //                       ref.read(guestListProvider.notifier).validate();
// // // //                   if (isValid) {
// // // //                     ScaffoldMessenger.of(context).showSnackBar(
// // // //                       const SnackBar(
// // // //                         content: Text('Guests added to list!'),
// // // //                         backgroundColor: Color(0xFF8B0045),
// // // //                       ),
// // // //                     );
// // // //                   }
// // // //                 },
// // // //                 style: ElevatedButton.styleFrom(
// // // //                   backgroundColor: const Color(0xFF1A0A2E),
// // // //                   shape: RoundedRectangleBorder(
// // // //                       borderRadius: BorderRadius.circular(8)),
// // // //                   padding: const EdgeInsets.symmetric(
// // // //                       horizontal: 32, vertical: 14),
// // // //                 ),
// // // //                 child: const Text('Add Guests to the List',
// // // //                     style: TextStyle(color: Colors.white, fontSize: 14)),
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // // ── Guest Type Button ─────────────────────────────────────────────────────────
// // // // class _GuestTypeButton extends StatelessWidget {
// // // //   final IconData icon;
// // // //   final String label;
// // // //   final VoidCallback onTap;

// // // //   const _GuestTypeButton(
// // // //       {required this.icon, required this.label, required this.onTap});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return ElevatedButton.icon(
// // // //       onPressed: onTap,
// // // //       icon: Icon(icon, size: 16, color: Colors.white),
// // // //       label: Text(label, style: const TextStyle(color: Colors.white)),
// // // //       style: ElevatedButton.styleFrom(
// // // //         backgroundColor: const Color(0xFF1A0A2E),
// // // //         shape:
// // // //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
// // // //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // // ── Single Guest Card ─────────────────────────────────────────────────────────
// // // // class _SingleGuestCard extends ConsumerStatefulWidget {
// // // //   final SingleGuest guest;
// // // //   final int index;
// // // //   final bool showValidation;

// // // //   const _SingleGuestCard(
// // // //       {required this.guest,
// // // //       required this.index,
// // // //       required this.showValidation});

// // // //   @override
// // // //   ConsumerState<_SingleGuestCard> createState() => _SingleGuestCardState();
// // // // }

// // // // class _SingleGuestCardState extends ConsumerState<_SingleGuestCard> {
// // // //   late final TextEditingController _usernameCtrl;
// // // //   late final TextEditingController _fullNameCtrl;
// // // //   late final TextEditingController _emailCtrl;
// // // //   late final TextEditingController _phoneCtrl;

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _usernameCtrl = TextEditingController(text: widget.guest.username);
// // // //     _fullNameCtrl = TextEditingController(text: widget.guest.fullName);
// // // //     _emailCtrl = TextEditingController(text: widget.guest.email);
// // // //     _phoneCtrl = TextEditingController(text: widget.guest.phone);
// // // //   }

// // // //   @override
// // // //   void dispose() {
// // // //     _usernameCtrl.dispose();
// // // //     _fullNameCtrl.dispose();
// // // //     _emailCtrl.dispose();
// // // //     _phoneCtrl.dispose();
// // // //     super.dispose();
// // // //   }

// // // //   void _update() {
// // // //     ref.read(guestListProvider.notifier).updateSingleGuest(
// // // //           widget.guest.id,
// // // //           widget.guest.copyWith(
// // // //             username: _usernameCtrl.text,
// // // //             fullName: _fullNameCtrl.text,
// // // //             email: _emailCtrl.text,
// // // //             phone: _phoneCtrl.text,
// // // //           ),
// // // //         );
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final sv = widget.showValidation;
// // // //     return Container(
// // // //       decoration: BoxDecoration(
// // // //         border: Border.all(color: const Color(0xFF4FC3F7), width: 1.2),
// // // //         borderRadius: BorderRadius.circular(10),
// // // //       ),
// // // //       padding: const EdgeInsets.all(14),
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //         children: [
// // // //           Row(
// // // //             children: [
// // // //               Expanded(
// // // //                 child: Text('Add New Single Guest #${widget.index}',
// // // //                     style: const TextStyle(
// // // //                         fontWeight: FontWeight.bold,
// // // //                         fontSize: 14,
// // // //                         color: Colors.black87)),
// // // //               ),
// // // //               _DeleteButton(
// // // //                   onTap: () => ref
// // // //                       .read(guestListProvider.notifier)
// // // //                       .removeSingleGuest(widget.guest.id)),
// // // //             ],
// // // //           ),
// // // //           const SizedBox(height: 14),
// // // //           Row(
// // // //             children: [
// // // //               Expanded(
// // // //                 child: _GuestField(
// // // //                   label: 'Username',
// // // //                   hint: 'Enter Username',
// // // //                   controller: _usernameCtrl,
// // // //                   onChanged: (_) => _update(),
// // // //                   showError: sv && _usernameCtrl.text.trim().isEmpty,
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(width: 12),
// // // //               Expanded(
// // // //                 child: _GuestField(
// // // //                   label: 'Full Name',
// // // //                   hint: 'Enter Full Name',
// // // //                   controller: _fullNameCtrl,
// // // //                   onChanged: (_) => _update(),
// // // //                   showError: sv && _fullNameCtrl.text.trim().isEmpty,
// // // //                   showInfoIcon: true,
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //           const SizedBox(height: 12),
// // // //           Row(
// // // //             children: [
// // // //               Expanded(
// // // //                 child: _GuestField(
// // // //                   label: 'Email',
// // // //                   hint: 'Email',
// // // //                   controller: _emailCtrl,
// // // //                   onChanged: (_) => _update(),
// // // //                   showError: sv && _emailCtrl.text.trim().isEmpty,
// // // //                   keyboardType: TextInputType.emailAddress,
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(width: 8),
// // // //               Expanded(
// // // //                 child: _GuestField(
// // // //                   label: 'Phone',
// // // //                   hint: 'Enter Phone Number',
// // // //                   controller: _phoneCtrl,
// // // //                   onChanged: (_) => _update(),
// // // //                   showError: sv && _phoneCtrl.text.trim().isEmpty,
// // // //                   keyboardType: TextInputType.phone,
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(width: 8),
// // // //               Expanded(
// // // //                 child: _IdProofPicker(
// // // //                   showError: sv && widget.guest.idProofPath == null,
// // // //                   filePath: widget.guest.idProofPath,
// // // //                   onPicked: (path) {
// // // //                     ref.read(guestListProvider.notifier).updateSingleGuest(
// // // //                           widget.guest.id,
// // // //                           widget.guest.copyWith(idProofPath: path),
// // // //                         );
// // // //                   },
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // // ── Couple Guest Card ─────────────────────────────────────────────────────────
// // // // class _CoupleGuestCard extends ConsumerStatefulWidget {
// // // //   final CoupleGuest guest;
// // // //   final int index;
// // // //   final bool showValidation;

// // // //   const _CoupleGuestCard(
// // // //       {required this.guest,
// // // //       required this.index,
// // // //       required this.showValidation});

// // // //   @override
// // // //   ConsumerState<_CoupleGuestCard> createState() => _CoupleGuestCardState();
// // // // }

// // // // class _CoupleGuestCardState extends ConsumerState<_CoupleGuestCard> {
// // // //   late final TextEditingController _u1, _fn1, _e1, _p1;
// // // //   late final TextEditingController _u2, _fn2, _e2, _p2;

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _u1 = TextEditingController(text: widget.guest.username1);
// // // //     _fn1 = TextEditingController(text: widget.guest.fullName1);
// // // //     _e1 = TextEditingController(text: widget.guest.email1);
// // // //     _p1 = TextEditingController(text: widget.guest.phone1);
// // // //     _u2 = TextEditingController(text: widget.guest.username2);
// // // //     _fn2 = TextEditingController(text: widget.guest.fullName2);
// // // //     _e2 = TextEditingController(text: widget.guest.email2);
// // // //     _p2 = TextEditingController(text: widget.guest.phone2);
// // // //   }

// // // //   @override
// // // //   void dispose() {
// // // //     _u1.dispose(); _fn1.dispose(); _e1.dispose(); _p1.dispose();
// // // //     _u2.dispose(); _fn2.dispose(); _e2.dispose(); _p2.dispose();
// // // //     super.dispose();
// // // //   }

// // // //   void _update() {
// // // //     ref.read(guestListProvider.notifier).updateCoupleGuest(
// // // //           widget.guest.id,
// // // //           widget.guest.copyWith(
// // // //             username1: _u1.text, fullName1: _fn1.text,
// // // //             email1: _e1.text, phone1: _p1.text,
// // // //             username2: _u2.text, fullName2: _fn2.text,
// // // //             email2: _e2.text, phone2: _p2.text,
// // // //           ),
// // // //         );
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final sv = widget.showValidation;
// // // //     return Container(
// // // //       decoration: BoxDecoration(
// // // //         border: Border.all(color: const Color(0xFF4FC3F7), width: 1.2),
// // // //         borderRadius: BorderRadius.circular(10),
// // // //       ),
// // // //       padding: const EdgeInsets.all(14),
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //         children: [
// // // //           Row(
// // // //             children: [
// // // //               Expanded(
// // // //                 child: Text('Add New Couple Guest #${widget.index}',
// // // //                     style: const TextStyle(
// // // //                         fontWeight: FontWeight.bold,
// // // //                         fontSize: 14,
// // // //                         color: Color(0xFF4FC3F7))),
// // // //               ),
// // // //               _DeleteButton(
// // // //                   onTap: () => ref
// // // //                       .read(guestListProvider.notifier)
// // // //                       .removeCoupleGuest(widget.guest.id)),
// // // //             ],
// // // //           ),
// // // //           const SizedBox(height: 14),

// // // //           // ── Member 1 ──────────────────────────────────────────────────
// // // //           const _SectionLabel(label: 'Member 1'),
// // // //           const SizedBox(height: 8),
// // // //           Row(
// // // //             children: [
// // // //               Expanded(
// // // //                 child: _GuestField(
// // // //                   label: 'Username (Member 1)',
// // // //                   hint: 'Enter Username',
// // // //                   controller: _u1,
// // // //                   onChanged: (_) => _update(),
// // // //                   showError: sv && _u1.text.trim().isEmpty,
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(width: 12),
// // // //               Expanded(
// // // //                 child: _GuestField(
// // // //                   label: 'Full Name (Member 1)',
// // // //                   hint: 'Enter Full Name',
// // // //                   controller: _fn1,
// // // //                   onChanged: (_) => _update(),
// // // //                   showError: sv && _fn1.text.trim().isEmpty,
// // // //                   showInfoIcon: true,
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //           const SizedBox(height: 10),
// // // //           Row(
// // // //             children: [
// // // //               Expanded(
// // // //                 child: _GuestField(
// // // //                   label: 'E-mail (Member 1)',
// // // //                   hint: 'Enter Your E-mail',
// // // //                   controller: _e1,
// // // //                   onChanged: (_) => _update(),
// // // //                   showError: sv && _e1.text.trim().isEmpty,
// // // //                   keyboardType: TextInputType.emailAddress,
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(width: 8),
// // // //               Expanded(
// // // //                 child: _GuestField(
// // // //                   label: 'Phone Number (Member 1)',
// // // //                   hint: 'Enter Phone Number',
// // // //                   controller: _p1,
// // // //                   onChanged: (_) => _update(),
// // // //                   showError: sv && _p1.text.trim().isEmpty,
// // // //                   keyboardType: TextInputType.phone,
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(width: 8),
// // // //               Expanded(
// // // //                 child: _IdProofPicker(
// // // //                   label: 'Id Proof (Member 1)',
// // // //                   showError: sv && widget.guest.idProofPath1 == null,
// // // //                   filePath: widget.guest.idProofPath1,
// // // //                   onPicked: (path) {
// // // //                     ref.read(guestListProvider.notifier).updateCoupleGuest(
// // // //                           widget.guest.id,
// // // //                           widget.guest.copyWith(idProofPath1: path),
// // // //                         );
// // // //                   },
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),

// // // //           const SizedBox(height: 16),
// // // //           const Divider(height: 1, color: Color(0xFFEEEEEE)),
// // // //           const SizedBox(height: 16),

// // // //           // ── Member 2 ──────────────────────────────────────────────────
// // // //           const _SectionLabel(label: 'Member 2'),
// // // //           const SizedBox(height: 8),
// // // //           Row(
// // // //             children: [
// // // //               Expanded(
// // // //                 child: _GuestField(
// // // //                   label: 'Username (Member 2)',
// // // //                   hint: 'Username',
// // // //                   controller: _u2,
// // // //                   onChanged: (_) => _update(),
// // // //                   showError: false,
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(width: 12),
// // // //               Expanded(
// // // //                 child: _GuestField(
// // // //                   label: 'Full Name (Member 2)',
// // // //                   hint: 'Enter Full Name',
// // // //                   controller: _fn2,
// // // //                   onChanged: (_) => _update(),
// // // //                   showError: sv && _fn2.text.trim().isEmpty,
// // // //                   showInfoIcon: true,
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //           const SizedBox(height: 10),
// // // //           Row(
// // // //             children: [
// // // //               Expanded(
// // // //                 child: _GuestField(
// // // //                   label: 'Email (Member 2)',
// // // //                   hint: 'Enter Email',
// // // //                   controller: _e2,
// // // //                   onChanged: (_) => _update(),
// // // //                   showError: sv && _e2.text.trim().isEmpty,
// // // //                   keyboardType: TextInputType.emailAddress,
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(width: 8),
// // // //               Expanded(
// // // //                 child: _GuestField(
// // // //                   label: 'Phone (Member 2)',
// // // //                   hint: 'Enter Phone Number',
// // // //                   controller: _p2,
// // // //                   onChanged: (_) => _update(),
// // // //                   showError: sv && _p2.text.trim().isEmpty,
// // // //                   keyboardType: TextInputType.phone,
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(width: 8),
// // // //               Expanded(
// // // //                 child: _IdProofPicker(
// // // //                   label: 'Id Proof (Member 2)',
// // // //                   showError: sv && widget.guest.idProofPath2 == null,
// // // //                   filePath: widget.guest.idProofPath2,
// // // //                   onPicked: (path) {
// // // //                     ref.read(guestListProvider.notifier).updateCoupleGuest(
// // // //                           widget.guest.id,
// // // //                           widget.guest.copyWith(idProofPath2: path),
// // // //                         );
// // // //                   },
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //           const SizedBox(height: 12),
// // // //           Align(
// // // //             alignment: Alignment.centerRight,
// // // //             child: ElevatedButton(
// // // //               onPressed: () => ref
// // // //                   .read(guestListProvider.notifier)
// // // //                   .removeCoupleGuest(widget.guest.id),
// // // //               style: ElevatedButton.styleFrom(
// // // //                 backgroundColor: const Color(0xFFD32F2F),
// // // //                 shape: RoundedRectangleBorder(
// // // //                     borderRadius: BorderRadius.circular(8)),
// // // //                 padding:
// // // //                     const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// // // //               ),
// // // //               child: const Text('Remove',
// // // //                   style: TextStyle(color: Colors.white, fontSize: 13)),
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // // ── Shared small widgets ──────────────────────────────────────────────────────

// // // // class _SectionLabel extends StatelessWidget {
// // // //   final String label;
// // // //   const _SectionLabel({required this.label});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Text(label,
// // // //         style: const TextStyle(
// // // //             fontSize: 12,
// // // //             fontWeight: FontWeight.w600,
// // // //             color: Colors.black54,
// // // //             letterSpacing: 0.5));
// // // //   }
// // // // }

// // // // class _GuestField extends StatelessWidget {
// // // //   final String label;
// // // //   final String hint;
// // // //   final TextEditingController controller;
// // // //   final ValueChanged<String> onChanged;
// // // //   final bool showError;
// // // //   final bool showInfoIcon;
// // // //   final TextInputType keyboardType;

// // // //   const _GuestField({
// // // //     required this.label,
// // // //     required this.hint,
// // // //     required this.controller,
// // // //     required this.onChanged,
// // // //     required this.showError,
// // // //     this.showInfoIcon = false,
// // // //     this.keyboardType = TextInputType.text,
// // // //   });

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Column(
// // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // //       children: [
// // // //         Row(
// // // //           children: [
// // // //             Text(label,
// // // //                 style: const TextStyle(
// // // //                     fontSize: 12,
// // // //                     fontWeight: FontWeight.w600,
// // // //                     color: Colors.black87)),
// // // //             if (showInfoIcon) ...[
// // // //               const SizedBox(width: 4),
// // // //               const Icon(Icons.info_outline, size: 14, color: Colors.black54),
// // // //             ],
// // // //           ],
// // // //         ),
// // // //         const SizedBox(height: 4),
// // // //         TextField(
// // // //           controller: controller,
// // // //           onChanged: onChanged,
// // // //           keyboardType: keyboardType,
// // // //           style: const TextStyle(fontSize: 13),
// // // //           decoration: InputDecoration(
// // // //             hintText: hint,
// // // //             hintStyle:
// // // //                 const TextStyle(fontSize: 13, color: Colors.black38),
// // // //             contentPadding:
// // // //                 const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// // // //             border: OutlineInputBorder(
// // // //                 borderRadius: BorderRadius.circular(6),
// // // //                 borderSide: const BorderSide(color: Color(0xFFCCCCCC))),
// // // //             enabledBorder: OutlineInputBorder(
// // // //                 borderRadius: BorderRadius.circular(6),
// // // //                 borderSide: const BorderSide(color: Color(0xFFCCCCCC))),
// // // //             focusedBorder: OutlineInputBorder(
// // // //                 borderRadius: BorderRadius.circular(6),
// // // //                 borderSide: const BorderSide(
// // // //                     color: Color(0xFF8B0045), width: 1.5)),
// // // //           ),
// // // //         ),
// // // //         if (showError) ...[
// // // //           const SizedBox(height: 3),
// // // //           const Text('This Field is required',
// // // //               style: TextStyle(fontSize: 11, color: Color(0xFFD32F2F))),
// // // //         ],
// // // //       ],
// // // //     );
// // // //   }
// // // // }

// // // // class _IdProofPicker extends StatelessWidget {
// // // //   final String? filePath;
// // // //   final bool showError;
// // // //   final ValueChanged<String> onPicked;
// // // //   final String label;

// // // //   const _IdProofPicker({
// // // //     required this.showError,
// // // //     required this.onPicked,
// // // //     this.filePath,
// // // //     this.label = 'Id Proof',
// // // //   });

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Column(
// // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // //       children: [
// // // //         Row(
// // // //           children: [
// // // //             Text(label,
// // // //                 style: const TextStyle(
// // // //                     fontSize: 12,
// // // //                     fontWeight: FontWeight.w600,
// // // //                     color: Colors.black87)),
// // // //             const SizedBox(width: 4),
// // // //             const Icon(Icons.info_outline, size: 14, color: Colors.black54),
// // // //           ],
// // // //         ),
// // // //         const SizedBox(height: 4),
// // // //         GestureDetector(
// // // //           onTap: () {
// // // //             // 👉 Replace with: FilePicker.platform.pickFiles(type: FileType.image)
// // // //             onPicked('selected_file.jpg');
// // // //           },
// // // //           child: Container(
// // // //             width: double.infinity,
// // // //             decoration: BoxDecoration(
// // // //                 border: Border.all(color: const Color(0xFFCCCCCC)),
// // // //                 borderRadius: BorderRadius.circular(6)),
// // // //             child: Row(
// // // //               children: [
// // // //                 Container(
// // // //                   padding: const EdgeInsets.symmetric(
// // // //                       horizontal: 10, vertical: 10),
// // // //                   decoration: const BoxDecoration(
// // // //                       border: Border(
// // // //                           right: BorderSide(color: Color(0xFFCCCCCC)))),
// // // //                   child: const Text('Choose file',
// // // //                       style: TextStyle(
// // // //                           fontSize: 12, color: Colors.black87)),
// // // //                 ),
// // // //                 Expanded(
// // // //                   child: Padding(
// // // //                     padding: const EdgeInsets.symmetric(horizontal: 8),
// // // //                     child: Text(
// // // //                       filePath != null
// // // //                           ? filePath!.split('/').last
// // // //                           : 'No file chosen',
// // // //                       style: const TextStyle(
// // // //                           fontSize: 11, color: Colors.black45),
// // // //                       overflow: TextOverflow.ellipsis,
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ),
// // // //         if (showError) ...[
// // // //           const SizedBox(height: 3),
// // // //           const Text('This Field is required',
// // // //               style: TextStyle(fontSize: 11, color: Color(0xFFD32F2F))),
// // // //         ],
// // // //       ],
// // // //     );
// // // //   }
// // // // }

// // // // class _DeleteButton extends StatelessWidget {
// // // //   final VoidCallback onTap;
// // // //   const _DeleteButton({required this.onTap});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return GestureDetector(
// // // //       onTap: onTap,
// // // //       child: Container(
// // // //         width: 36,
// // // //         height: 36,
// // // //         decoration: BoxDecoration(
// // // //             color: const Color(0xFFD32F2F),
// // // //             borderRadius: BorderRadius.circular(6)),
// // // //         child:
// // // //             const Icon(Icons.delete_outline, color: Colors.white, size: 20),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // // ═════════════════════════════════════════════════════════════════════════════
// // // // // SECTION 8 — ROOM PACKAGE SECTION
// // // // // ═════════════════════════════════════════════════════════════════════════════

// // // // class _RoomPackageSection extends ConsumerWidget {
// // // //   final List<RoomData> rooms;
// // // //   const _RoomPackageSection({required this.rooms});

// // // //   @override
// // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // //     final quantities = ref.watch(roomQuantityProvider);

// // // //     return Container(
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.white,
// // // //         borderRadius: BorderRadius.circular(12),
// // // //         boxShadow: [
// // // //           BoxShadow(
// // // //               color: Colors.black.withOpacity(0.06),
// // // //               blurRadius: 8,
// // // //               offset: const Offset(0, 2))
// // // //         ],
// // // //       ),
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //         children: [
// // // //           const Padding(
// // // //             padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
// // // //             child: Text('Choose Your Beat Flirt Package',
// // // //                 style: TextStyle(
// // // //                     fontSize: 16,
// // // //                     fontWeight: FontWeight.bold,
// // // //                     color: Colors.black87)),
// // // //           ),
// // // //           _RoomTableHeader(),
// // // //           const Divider(height: 1),
// // // //           ...rooms.asMap().entries.map((entry) {
// // // //             final room = entry.value;
// // // //             final isLast = entry.key == rooms.length - 1;
// // // //             final qty = quantities[room.id] ?? 0;
// // // //             final amount = qty * (double.tryParse(room.price) ?? 0);
// // // //             return Column(
// // // //               children: [
// // // //                 Padding(
// // // //                   padding: const EdgeInsets.symmetric(
// // // //                       horizontal: 12, vertical: 10),
// // // //                   child: Row(
// // // //                     crossAxisAlignment: CrossAxisAlignment.center,
// // // //                     children: [
// // // //                       _QuantityDropdown(
// // // //                         value: qty,
// // // //                         max: int.tryParse(room.roomAvailable) ?? 10,
// // // //                         onChanged: (val) => ref
// // // //                             .read(roomQuantityProvider.notifier)
// // // //                             .setQuantity(room.id, val),
// // // //                       ),
// // // //                       const SizedBox(width: 10),
// // // //                       ClipRRect(
// // // //                         borderRadius: BorderRadius.circular(6),
// // // //                         child: Image.network(
// // // //                           room.roomImage,
// // // //                           width: 55,
// // // //                           height: 45,
// // // //                           fit: BoxFit.cover,
// // // //                           errorBuilder: (_, __, ___) => Container(
// // // //                             width: 55,
// // // //                             height: 45,
// // // //                             color: Colors.grey[200],
// // // //                             child: const Icon(Icons.bed,
// // // //                                 color: Colors.grey, size: 24),
// // // //                           ),
// // // //                         ),
// // // //                       ),
// // // //                       const SizedBox(width: 10),
// // // //                       Expanded(
// // // //                         child: Column(
// // // //                           crossAxisAlignment: CrossAxisAlignment.start,
// // // //                           children: [
// // // //                             Text(room.roomName,
// // // //                                 style: const TextStyle(
// // // //                                     fontSize: 13,
// // // //                                     fontWeight: FontWeight.bold,
// // // //                                     color: Colors.black87)),
// // // //                             if (room.shortDescription.isNotEmpty)
// // // //                               Text(room.shortDescription,
// // // //                                   style: const TextStyle(
// // // //                                       fontSize: 11, color: Colors.black54),
// // // //                                   maxLines: 2,
// // // //                                   overflow: TextOverflow.ellipsis),
// // // //                           ],
// // // //                         ),
// // // //                       ),
// // // //                       SizedBox(
// // // //                         width: 56,
// // // //                         child: Text('\$${room.price}',
// // // //                             style: const TextStyle(
// // // //                                 fontSize: 13, color: Colors.black87),
// // // //                             textAlign: TextAlign.center),
// // // //                       ),
// // // //                       SizedBox(
// // // //                         width: 44,
// // // //                         child: Text('\$${room.fee}',
// // // //                             style: const TextStyle(
// // // //                                 fontSize: 13, color: Colors.black87),
// // // //                             textAlign: TextAlign.center),
// // // //                       ),
// // // //                       SizedBox(
// // // //                         width: 48,
// // // //                         child: Text(
// // // //                           '\$${amount == 0 ? '0' : amount.toStringAsFixed(0)}',
// // // //                           style: const TextStyle(
// // // //                               fontSize: 13,
// // // //                               fontWeight: FontWeight.bold,
// // // //                               color: Colors.black87),
// // // //                           textAlign: TextAlign.right,
// // // //                         ),
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //                 if (!isLast)
// // // //                   const Divider(height: 1, indent: 12, endIndent: 12),
// // // //               ],
// // // //             );
// // // //           }),
// // // //           const SizedBox(height: 8),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // class _RoomTableHeader extends StatelessWidget {
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Padding(
// // // //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// // // //       child: Row(
// // // //         children: const [
// // // //           SizedBox(width: 60, child: _HeaderLabel('QTY')),
// // // //           SizedBox(width: 10),
// // // //           Expanded(child: _HeaderLabel('ROOM / PACKAGE')),
// // // //           SizedBox(width: 56, child: _HeaderLabel('PRICE', center: true)),
// // // //           SizedBox(width: 44, child: _HeaderLabel('FEE', center: true)),
// // // //           SizedBox(width: 48, child: _HeaderLabel('AMOUNT', right: true)),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // class _HeaderLabel extends StatelessWidget {
// // // //   final String text;
// // // //   final bool center;
// // // //   final bool right;

// // // //   const _HeaderLabel(this.text, {this.center = false, this.right = false});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Text(
// // // //       text,
// // // //       style: const TextStyle(
// // // //           fontSize: 11,
// // // //           fontWeight: FontWeight.bold,
// // // //           color: Colors.black54,
// // // //           letterSpacing: 0.5),
// // // //       textAlign:
// // // //           right ? TextAlign.right : center ? TextAlign.center : TextAlign.left,
// // // //     );
// // // //   }
// // // // }

// // // // class _QuantityDropdown extends StatelessWidget {
// // // //   final int value;
// // // //   final int max;
// // // //   final ValueChanged<int> onChanged;

// // // //   const _QuantityDropdown(
// // // //       {required this.value, required this.max, required this.onChanged});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Container(
// // // //       width: 52,
// // // //       height: 34,
// // // //       decoration: BoxDecoration(
// // // //           border: Border.all(color: const Color(0xFFCCCCCC)),
// // // //           borderRadius: BorderRadius.circular(6),
// // // //           color: Colors.white),
// // // //       padding: const EdgeInsets.symmetric(horizontal: 4),
// // // //       child: DropdownButtonHideUnderline(
// // // //         child: DropdownButton<int>(
// // // //           value: value,
// // // //           isExpanded: true,
// // // //           icon: const Icon(Icons.keyboard_arrow_down, size: 16),
// // // //           style: const TextStyle(fontSize: 13, color: Colors.black87),
// // // //           onChanged: (val) {
// // // //             if (val != null) onChanged(val);
// // // //           },
// // // //           items: List.generate(max + 1, (i) => i)
// // // //               .map((i) => DropdownMenuItem(value: i, child: Text('$i')))
// // // //               .toList(),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // // ═════════════════════════════════════════════════════════════════════════════
// // // // // SECTION 9 — ADDITIONAL NIGHT SECTION
// // // // // ═════════════════════════════════════════════════════════════════════════════

// // // // class _AdditionalNightSection extends ConsumerWidget {
// // // //   final List<AdditionalNight> nights;
// // // //   final String pricePerNight;
// // // //   final String feePerNight;

// // // //   const _AdditionalNightSection(
// // // //       {required this.nights,
// // // //       required this.pricePerNight,
// // // //       required this.feePerNight});

// // // //   String _formatDate(String dateStr) {
// // // //     try {
// // // //       final parts = dateStr.split('-');
// // // //       final months = [
// // // //         '', 'January', 'February', 'March', 'April', 'May', 'June',
// // // //         'July', 'August', 'September', 'October', 'November', 'December'
// // // //       ];
// // // //       final year = parts[0];
// // // //       final month = int.tryParse(parts[1]) ?? 0;
// // // //       final day = int.tryParse(parts[2]) ?? 0;
// // // //       final monthName = month < months.length ? months[month] : parts[1];
// // // //       return '$monthName $day, $year';
// // // //     } catch (_) {
// // // //       return dateStr;
// // // //     }
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // //     final quantities = ref.watch(nightQuantityProvider);

// // // //     return Container(
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.white,
// // // //         borderRadius: BorderRadius.circular(12),
// // // //         boxShadow: [
// // // //           BoxShadow(
// // // //               color: Colors.black.withOpacity(0.06),
// // // //               blurRadius: 8,
// // // //               offset: const Offset(0, 2))
// // // //         ],
// // // //       ),
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //         children: [
// // // //           const Padding(
// // // //             padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
// // // //             child: Text('Select Additional Room Night Options',
// // // //                 style: TextStyle(
// // // //                     fontSize: 16,
// // // //                     fontWeight: FontWeight.bold,
// // // //                     color: Colors.black87)),
// // // //           ),
// // // //           const Padding(
// // // //             padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
// // // //             child: Text(
// // // //               'Quantity will remain the same as added to the event.',
// // // //               style: TextStyle(
// // // //                   fontSize: 12,
// // // //                   color: Color(0xFFD81B60),
// // // //                   fontStyle: FontStyle.italic),
// // // //             ),
// // // //           ),
// // // //           // Table Header
// // // //           Padding(
// // // //             padding:
// // // //                 const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// // // //             child: Row(
// // // //               children: const [
// // // //                 SizedBox(width: 70, child: _HeaderLabel('QTY')),
// // // //                 Expanded(child: _HeaderLabel('ADDITIONAL NIGHT')),
// // // //                 SizedBox(width: 56, child: _HeaderLabel('PRICE', center: true)),
// // // //                 SizedBox(width: 44, child: _HeaderLabel('FEE', center: true)),
// // // //                 SizedBox(width: 52, child: _HeaderLabel('AMOUNT', right: true)),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //           const Divider(height: 1),
// // // //           ...nights.asMap().entries.map((entry) {
// // // //             final night = entry.value;
// // // //             final isLast = entry.key == nights.length - 1;
// // // //             final qty = quantities[night.date] ?? 0;
// // // //             final price = double.tryParse(pricePerNight) ?? 0;
// // // //             final amount = qty * price;
// // // //             return Column(
// // // //               children: [
// // // //                 Padding(
// // // //                   padding: const EdgeInsets.symmetric(
// // // //                       horizontal: 12, vertical: 10),
// // // //                   child: Row(
// // // //                     crossAxisAlignment: CrossAxisAlignment.center,
// // // //                     children: [
// // // //                       _NightQtyDropdown(
// // // //                         value: qty,
// // // //                         onChanged: (val) => ref
// // // //                             .read(nightQuantityProvider.notifier)
// // // //                             .setQuantity(night.date, val),
// // // //                       ),
// // // //                       const SizedBox(width: 12),
// // // //                       Expanded(
// // // //                         child: RichText(
// // // //                           text: TextSpan(
// // // //                             children: [
// // // //                               TextSpan(
// // // //                                 text: '${night.day}, ',
// // // //                                 style: const TextStyle(
// // // //                                     fontSize: 13,
// // // //                                     fontWeight: FontWeight.bold,
// // // //                                     color: Colors.black87),
// // // //                               ),
// // // //                               TextSpan(
// // // //                                 text: _formatDate(night.date),
// // // //                                 style: const TextStyle(
// // // //                                     fontSize: 13, color: Colors.black87),
// // // //                               ),
// // // //                             ],
// // // //                           ),
// // // //                         ),
// // // //                       ),
// // // //                       SizedBox(
// // // //                         width: 56,
// // // //                         child: Text('\$$pricePerNight',
// // // //                             style: const TextStyle(
// // // //                                 fontSize: 13, color: Colors.black87),
// // // //                             textAlign: TextAlign.center),
// // // //                       ),
// // // //                       SizedBox(
// // // //                         width: 44,
// // // //                         child: Text('\$$feePerNight',
// // // //                             style: const TextStyle(
// // // //                                 fontSize: 13, color: Colors.black87),
// // // //                             textAlign: TextAlign.center),
// // // //                       ),
// // // //                       SizedBox(
// // // //                         width: 52,
// // // //                         child: Text(
// // // //                           '\$${amount == 0 ? '0' : amount.toStringAsFixed(0)}',
// // // //                           style: const TextStyle(
// // // //                               fontSize: 13,
// // // //                               fontWeight: FontWeight.bold,
// // // //                               color: Colors.black87),
// // // //                           textAlign: TextAlign.right,
// // // //                         ),
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //                 if (!isLast)
// // // //                   const Divider(height: 1, indent: 12, endIndent: 12),
// // // //               ],
// // // //             );
// // // //           }),
// // // //           const SizedBox(height: 8),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // class _NightQtyDropdown extends StatelessWidget {
// // // //   final int value;
// // // //   final ValueChanged<int> onChanged;

// // // //   const _NightQtyDropdown({required this.value, required this.onChanged});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Container(
// // // //       width: 52,
// // // //       height: 34,
// // // //       decoration: BoxDecoration(
// // // //           border: Border.all(color: const Color(0xFFCCCCCC)),
// // // //           borderRadius: BorderRadius.circular(6),
// // // //           color: Colors.white),
// // // //       padding: const EdgeInsets.symmetric(horizontal: 4),
// // // //       child: DropdownButtonHideUnderline(
// // // //         child: DropdownButton<int>(
// // // //           value: value,
// // // //           isExpanded: true,
// // // //           icon: const Icon(Icons.keyboard_arrow_down, size: 16),
// // // //           style: const TextStyle(fontSize: 13, color: Colors.black87),
// // // //           onChanged: (val) {
// // // //             if (val != null) onChanged(val);
// // // //           },
// // // //           items: List.generate(11, (i) => i)
// // // //               .map((i) => DropdownMenuItem(value: i, child: Text('$i')))
// // // //               .toList(),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // // ═════════════════════════════════════════════════════════════════════════════
// // // // // SECTION 10 — ORDER SUMMARY SECTION
// // // // // ═════════════════════════════════════════════════════════════════════════════

// // // // class _OrderSummarySection extends ConsumerStatefulWidget {
// // // //   final List<RoomData> rooms;
// // // //   final List<AdditionalNight> nights;
// // // //   final String pricePerNight;
// // // //   final String feePerNight;

// // // //   const _OrderSummarySection({
// // // //     required this.rooms,
// // // //     required this.nights,
// // // //     required this.pricePerNight,
// // // //     required this.feePerNight,
// // // //   });

// // // //   @override
// // // //   ConsumerState<_OrderSummarySection> createState() =>
// // // //       _OrderSummarySectionState();
// // // // }

// // // // class _OrderSummarySectionState extends ConsumerState<_OrderSummarySection> {
// // // //   final _voucherCtrl = TextEditingController();

// // // //   @override
// // // //   void dispose() {
// // // //     _voucherCtrl.dispose();
// // // //     super.dispose();
// // // //   }

// // // //   double _calcSubTotal() {
// // // //     final roomQtys = ref.read(roomQuantityProvider);
// // // //     final nightQtys = ref.read(nightQuantityProvider);
// // // //     double total = 0;
// // // //     for (final room in widget.rooms) {
// // // //       final qty = roomQtys[room.id] ?? 0;
// // // //       total += qty * (double.tryParse(room.price) ?? 0);
// // // //     }
// // // //     for (final night in widget.nights) {
// // // //       final qty = nightQtys[night.date] ?? 0;
// // // //       total += qty * (double.tryParse(widget.pricePerNight) ?? 0);
// // // //     }
// // // //     return total;
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     ref.watch(roomQuantityProvider);
// // // //     ref.watch(nightQuantityProvider);

// // // //     final paymentType = ref.watch(paymentTypeProvider);
// // // //     final membershipDiscount = ref.watch(membershipDiscountProvider);
// // // //     final voucherDiscount = ref.watch(voucherDiscountProvider);
// // // //     final subTotal = _calcSubTotal();
// // // //     final total = (subTotal - membershipDiscount - voucherDiscount)
// // // //         .clamp(0.0, double.infinity);

// // // //     return Column(
// // // //       children: [
// // // //         // ── Payment Type ──────────────────────────────────────────────────
// // // //         Container(
// // // //           decoration: BoxDecoration(
// // // //             color: Colors.white,
// // // //             borderRadius: BorderRadius.circular(12),
// // // //             boxShadow: [
// // // //               BoxShadow(
// // // //                   color: Colors.black.withOpacity(0.06),
// // // //                   blurRadius: 8,
// // // //                   offset: const Offset(0, 2))
// // // //             ],
// // // //           ),
// // // //           padding: const EdgeInsets.all(16),
// // // //           child: Column(
// // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // //             children: [
// // // //               const Text('Select Payment Type',
// // // //                   style: TextStyle(
// // // //                       fontSize: 15,
// // // //                       fontWeight: FontWeight.bold,
// // // //                       color: Colors.black87)),
// // // //               const SizedBox(height: 12),
// // // //               Row(
// // // //                 children: [
// // // //                   _PaymentOption(
// // // //                     label: 'Full Payment',
// // // //                     value: PaymentType.full,
// // // //                     groupValue: paymentType,
// // // //                     onChanged: (val) =>
// // // //                         ref.read(paymentTypeProvider.notifier).state = val,
// // // //                   ),
// // // //                   const SizedBox(width: 24),
// // // //                   _PaymentOption(
// // // //                     label: 'Partial Payment',
// // // //                     value: PaymentType.partial,
// // // //                     groupValue: paymentType,
// // // //                     onChanged: (val) =>
// // // //                         ref.read(paymentTypeProvider.notifier).state = val,
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),

// // // //         const SizedBox(height: 16),

// // // //         // ── Order Summary ─────────────────────────────────────────────────
// // // //         Container(
// // // //           decoration: BoxDecoration(
// // // //             color: Colors.white,
// // // //             borderRadius: BorderRadius.circular(12),
// // // //             border: Border.all(color: const Color(0xFF4FC3F7), width: 1.2),
// // // //             boxShadow: [
// // // //               BoxShadow(
// // // //                   color: Colors.black.withOpacity(0.06),
// // // //                   blurRadius: 8,
// // // //                   offset: const Offset(0, 2))
// // // //             ],
// // // //           ),
// // // //           padding: const EdgeInsets.all(16),
// // // //           child: Column(
// // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // //             children: [
// // // //               const Text('Order Summary',
// // // //                   style: TextStyle(
// // // //                       fontSize: 16,
// // // //                       fontWeight: FontWeight.bold,
// // // //                       color: Colors.black87)),
// // // //               const SizedBox(height: 14),

// // // //               // Voucher Input
// // // //               Row(
// // // //                 children: [
// // // //                   Expanded(
// // // //                     child: TextField(
// // // //                       controller: _voucherCtrl,
// // // //                       onChanged: (val) =>
// // // //                           ref.read(voucherCodeProvider.notifier).state = val,
// // // //                       style: const TextStyle(fontSize: 13),
// // // //                       decoration: InputDecoration(
// // // //                         hintText: 'Enter voucher code',
// // // //                         hintStyle: const TextStyle(
// // // //                             fontSize: 13, color: Colors.black38),
// // // //                         contentPadding: const EdgeInsets.symmetric(
// // // //                             horizontal: 12, vertical: 10),
// // // //                         border: OutlineInputBorder(
// // // //                             borderRadius: BorderRadius.circular(6),
// // // //                             borderSide:
// // // //                                 const BorderSide(color: Color(0xFFCCCCCC))),
// // // //                         enabledBorder: OutlineInputBorder(
// // // //                             borderRadius: BorderRadius.circular(6),
// // // //                             borderSide:
// // // //                                 const BorderSide(color: Color(0xFFCCCCCC))),
// // // //                         focusedBorder: OutlineInputBorder(
// // // //                             borderRadius: BorderRadius.circular(6),
// // // //                             borderSide: const BorderSide(
// // // //                                 color: Color(0xFF8B0045), width: 1.5)),
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                   const SizedBox(width: 10),
// // // //                   ElevatedButton(
// // // //                     onPressed: () {
// // // //                       // TODO: call voucher validation API
// // // //                       ScaffoldMessenger.of(context).showSnackBar(
// // // //                         const SnackBar(
// // // //                             content: Text('Voucher applied!'),
// // // //                             backgroundColor: Color(0xFF8B0045)),
// // // //                       );
// // // //                     },
// // // //                     style: ElevatedButton.styleFrom(
// // // //                       backgroundColor: const Color(0xFF1A0A2E),
// // // //                       shape: RoundedRectangleBorder(
// // // //                           borderRadius: BorderRadius.circular(6)),
// // // //                       padding: const EdgeInsets.symmetric(
// // // //                           horizontal: 18, vertical: 14),
// // // //                     ),
// // // //                     child: const Text('Apply',
// // // //                         style:
// // // //                             TextStyle(color: Colors.white, fontSize: 13)),
// // // //                   ),
// // // //                 ],
// // // //               ),

// // // //               const SizedBox(height: 16),
// // // //               const Divider(height: 1),
// // // //               const SizedBox(height: 12),

// // // //               // Sub Total
// // // //               Row(
// // // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //                 children: [
// // // //                   const Text('Sub Total',
// // // //                       style:
// // // //                           TextStyle(fontSize: 14, color: Colors.black87)),
// // // //                   Text(
// // // //                     '\$${subTotal == 0 ? '0' : subTotal.toStringAsFixed(0)}',
// // // //                     style: TextStyle(
// // // //                         fontSize: 14,
// // // //                         color: subTotal == 0
// // // //                             ? const Color(0xFF4FC3F7)
// // // //                             : Colors.black87),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //               const SizedBox(height: 8),

// // // //               // Membership Discount
// // // //               Row(
// // // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //                 children: [
// // // //                   const Text('Membership Discount',
// // // //                       style: TextStyle(
// // // //                           fontSize: 14, color: Color(0xFFD81B60))),
// // // //                   Text('-\$${membershipDiscount.toStringAsFixed(0)}',
// // // //                       style: const TextStyle(
// // // //                           fontSize: 14, color: Color(0xFFD81B60))),
// // // //                 ],
// // // //               ),
// // // //               const SizedBox(height: 8),

// // // //               // Voucher Discount
// // // //               Row(
// // // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //                 children: [
// // // //                   const Text('Voucher Discount',
// // // //                       style: TextStyle(
// // // //                           fontSize: 14, color: Color(0xFF2E7D32))),
// // // //                   Text('-\$${voucherDiscount.toStringAsFixed(0)}',
// // // //                       style: const TextStyle(
// // // //                           fontSize: 14, color: Color(0xFF2E7D32))),
// // // //                 ],
// // // //               ),

// // // //               const SizedBox(height: 12),
// // // //               const Divider(height: 1),
// // // //               const SizedBox(height: 12),

// // // //               // Total
// // // //               Row(
// // // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //                 children: [
// // // //                   const Text('Total',
// // // //                       style: TextStyle(
// // // //                           fontSize: 18,
// // // //                           fontWeight: FontWeight.bold,
// // // //                           color: Colors.black87)),
// // // //                   Text('\$${total.toStringAsFixed(0)}',
// // // //                       style: const TextStyle(
// // // //                           fontSize: 18,
// // // //                           fontWeight: FontWeight.bold,
// // // //                           color: Colors.black87)),
// // // //                 ],
// // // //               ),

// // // //               const SizedBox(height: 18),

// // // //               // Buy Ticket Button
// // // //               SizedBox(
// // // //                 width: double.infinity,
// // // //                 child: ElevatedButton(
// // // //                   onPressed: () {
// // // //                     // TODO: call buy ticket API
// // // //                     ScaffoldMessenger.of(context).showSnackBar(
// // // //                       const SnackBar(
// // // //                           content: Text('Processing your ticket...'),
// // // //                           backgroundColor: Color(0xFF8B0045)),
// // // //                     );
// // // //                   },
// // // //                   style: ElevatedButton.styleFrom(
// // // //                     backgroundColor: const Color(0xFF1A0A2E),
// // // //                     shape: RoundedRectangleBorder(
// // // //                         borderRadius: BorderRadius.circular(8)),
// // // //                     padding: const EdgeInsets.symmetric(vertical: 16),
// // // //                   ),
// // // //                   child: const Text(
// // // //                     'BUY TICKET',
// // // //                     style: TextStyle(
// // // //                         color: Colors.white,
// // // //                         fontSize: 15,
// // // //                         fontWeight: FontWeight.bold,
// // // //                         letterSpacing: 1),
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }
// // // // }

// // // // class _PaymentOption extends StatelessWidget {
// // // //   final String label;
// // // //   final PaymentType value;
// // // //   final PaymentType? groupValue;
// // // //   final ValueChanged<PaymentType?> onChanged;

// // // //   const _PaymentOption({
// // // //     required this.label,
// // // //     required this.value,
// // // //     required this.groupValue,
// // // //     required this.onChanged,
// // // //   });

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Row(
// // // //       children: [
// // // //         Radio<PaymentType>(
// // // //           value: value,
// // // //           groupValue: groupValue,
// // // //           activeColor: const Color(0xFF8B0045),
// // // //           onChanged: onChanged,
// // // //         ),
// // // //         Text(label,
// // // //             style: const TextStyle(fontSize: 14, color: Colors.black87)),
// // // //       ],
// // // //     );
// // // //   }
// // // // }

// // // // =============================================================================
// // // //  event_detail_page.dart
// // // //  Beat Flirt — Complete single-file with AuthService token integration.
// // // //
// // // //  ✅ Token is fetched AUTOMATICALLY from SharedPreferences via AuthService.
// // // //  ✅ You only need to pass eventId when navigating. That's it!
// // // //
// // // //  HOW TO NAVIGATE HERE (from any screen):
// // // //  ─────────────────────────────────────────
// // // //  Navigator.push(
// // // //    context,
// // // //    MaterialPageRoute(
// // // //      builder: (_) => EventDetailScreen(eventId: event.id),
// // // //    ),
// // // //  );
// // // //
// // // //  Dependencies (pubspec.yaml):
// // // //    flutter_riverpod: ^2.5.1
// // // //    http: ^1.2.1
// // // //    shared_preferences: ^2.2.2
// // // // =============================================================================

// // // import 'dart:convert';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'package:shared_preferences/shared_preferences.dart';

// // // // ignore_for_file: avoid_print

// // // // ═════════════════════════════════════════════════════════════════════════════
// // // // SECTION 1 — AUTH SERVICE (reads token from SharedPreferences)
// // // // ═════════════════════════════════════════════════════════════════════════════

// // // /// Reads the auth token from SharedPreferences.
// // // /// Uses the SAME key as your real AuthService ("auth_token").
// // // /// Cross-check: in your AuthService → static const String _tokenKey = "auth_token"
// // // class _AuthService {
// // //   // ⚠️ Must match AuthService._tokenKey exactly
// // //   static const String _tokenKey = 'auth_token';

// // //   static Future<String?> getToken() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     final token = prefs.getString(_tokenKey);
// // //     debugPrint('[_AuthService] key="$_tokenKey" → tokenLen=${token?.length ?? 0}');
// // //     return token;
// // //   }
// // // }

// // // // ═════════════════════════════════════════════════════════════════════════════
// // // // SECTION 2 — MODELS
// // // // ═════════════════════════════════════════════════════════════════════════════

// // // class EventDetailResponse {
// // //   final String status;
// // //   final EventData data;
// // //   final List<AdditionalNight> additionalNights;
// // //   final RoomListResponse roomList;

// // //   EventDetailResponse({
// // //     required this.status,
// // //     required this.data,
// // //     required this.additionalNights,
// // //     required this.roomList,
// // //   });

// // //   factory EventDetailResponse.fromJson(Map<String, dynamic> json) {
// // //     return EventDetailResponse(
// // //       status: json['status'] ?? '',
// // //       data: EventData.fromJson(json['data'] ?? {}),
// // //       additionalNights: (json['additional_night'] as List<dynamic>? ?? [])
// // //           .map((e) => AdditionalNight.fromJson(e))
// // //           .toList(),
// // //       roomList: RoomListResponse.fromJson(json['room_list'] ?? {}),
// // //     );
// // //   }
// // // }

// // // class EventData {
// // //   final String id;
// // //   final String eventName;
// // //   final String eventFromDate;
// // //   final String eventToDate;
// // //   final String eventFromTime;
// // //   final String eventToTime;
// // //   final String eventType;
// // //   final String additionalRoomNightPrice;
// // //   final String additionalRoomNightFee;
// // //   final String formattedAddress;
// // //   final String eventImage;
// // //   final String eventPrice;
// // //   final String eventNoOfTicket;
// // //   final String eventEmail;
// // //   final String eventDescription;
// // //   final String status;
// // //   final String lat;
// // //   final String lng;
// // //   final String cityName;

// // //   EventData({
// // //     required this.id,
// // //     required this.eventName,
// // //     required this.eventFromDate,
// // //     required this.eventToDate,
// // //     required this.eventFromTime,
// // //     required this.eventToTime,
// // //     required this.eventType,
// // //     required this.additionalRoomNightPrice,
// // //     required this.additionalRoomNightFee,
// // //     required this.formattedAddress,
// // //     required this.eventImage,
// // //     required this.eventPrice,
// // //     required this.eventNoOfTicket,
// // //     required this.eventEmail,
// // //     required this.eventDescription,
// // //     required this.status,
// // //     required this.lat,
// // //     required this.lng,
// // //     required this.cityName,
// // //   });

// // //   factory EventData.fromJson(Map<String, dynamic> json) {
// // //     return EventData(
// // //       id: json['id'] ?? '',
// // //       eventName: json['event_name'] ?? '',
// // //       eventFromDate: json['event_from_date'] ?? '',
// // //       eventToDate: json['event_to_date'] ?? '',
// // //       eventFromTime: json['event_from_time'] ?? '',
// // //       eventToTime: json['event_to_time'] ?? '',
// // //       eventType: json['event_type'] ?? '',
// // //       additionalRoomNightPrice: json['additional_room_night_price'] ?? '0',
// // //       additionalRoomNightFee: json['additional_room_night_fee'] ?? '0',
// // //       formattedAddress: json['formatted_address'] ?? '',
// // //       eventImage: json['event_image'] ?? '',
// // //       eventPrice: json['event_price'] ?? '0',
// // //       eventNoOfTicket: json['event_no_of_ticket'] ?? '0',
// // //       eventEmail: json['event_email'] ?? '',
// // //       eventDescription: json['event_description'] ?? '',
// // //       status: json['status']?.toString() ?? '',
// // //       lat: json['lat'] ?? '',
// // //       lng: json['lng'] ?? '',
// // //       cityName: json['city_name'] ?? '',
// // //     );
// // //   }
// // // }

// // // class AdditionalNight {
// // //   final String date;
// // //   final String day;

// // //   AdditionalNight({required this.date, required this.day});

// // //   factory AdditionalNight.fromJson(Map<String, dynamic> json) {
// // //     return AdditionalNight(
// // //       date: json['date'] ?? '',
// // //       day: json['day'] ?? '',
// // //     );
// // //   }
// // // }

// // // class RoomListResponse {
// // //   final String status;
// // //   final List<RoomData> data;

// // //   RoomListResponse({required this.status, required this.data});

// // //   factory RoomListResponse.fromJson(Map<String, dynamic> json) {
// // //     return RoomListResponse(
// // //       status: json['status']?.toString() ?? '',
// // //       data: (json['data'] as List<dynamic>? ?? [])
// // //           .map((e) => RoomData.fromJson(e))
// // //           .toList(),
// // //     );
// // //   }
// // // }

// // // class RoomData {
// // //   final String id;
// // //   final String roomName;
// // //   final String price;
// // //   final String fee;
// // //   final String fullDescription;
// // //   final String shortDescription;
// // //   final String roomAvailable;
// // //   final String roomImage;

// // //   RoomData({
// // //     required this.id,
// // //     required this.roomName,
// // //     required this.price,
// // //     required this.fee,
// // //     required this.fullDescription,
// // //     required this.shortDescription,
// // //     required this.roomAvailable,
// // //     required this.roomImage,
// // //   });

// // //   factory RoomData.fromJson(Map<String, dynamic> json) {
// // //     return RoomData(
// // //       id: json['id'] ?? '',
// // //       roomName: json['room_name'] ?? '',
// // //       price: json['price'] ?? '0',
// // //       fee: json['fee'] ?? '0',
// // //       fullDescription: json['full_description'] ?? '',
// // //       shortDescription: json['short_description'] ?? '',
// // //       roomAvailable: json['room_available'] ?? '0',
// // //       roomImage: json['room_image'] ?? '',
// // //     );
// // //   }
// // // }

// // // // ── Guest Models ──────────────────────────────────────────────────────────────

// // // enum GuestType { single, couple }

// // // class SingleGuest {
// // //   final String id;
// // //   String username;
// // //   String fullName;
// // //   String email;
// // //   String phone;
// // //   String? idProofPath;

// // //   SingleGuest({
// // //     required this.id,
// // //     this.username = '',
// // //     this.fullName = '',
// // //     this.email = '',
// // //     this.phone = '',
// // //     this.idProofPath,
// // //   });

// // //   SingleGuest copyWith({
// // //     String? username,
// // //     String? fullName,
// // //     String? email,
// // //     String? phone,
// // //     String? idProofPath,
// // //   }) {
// // //     return SingleGuest(
// // //       id: id,
// // //       username: username ?? this.username,
// // //       fullName: fullName ?? this.fullName,
// // //       email: email ?? this.email,
// // //       phone: phone ?? this.phone,
// // //       idProofPath: idProofPath ?? this.idProofPath,
// // //     );
// // //   }
// // // }

// // // class CoupleGuest {
// // //   final String id;
// // //   String username1;
// // //   String fullName1;
// // //   String email1;
// // //   String phone1;
// // //   String? idProofPath1;
// // //   String username2;
// // //   String fullName2;
// // //   String email2;
// // //   String phone2;
// // //   String? idProofPath2;

// // //   CoupleGuest({
// // //     required this.id,
// // //     this.username1 = '',
// // //     this.fullName1 = '',
// // //     this.email1 = '',
// // //     this.phone1 = '',
// // //     this.idProofPath1,
// // //     this.username2 = '',
// // //     this.fullName2 = '',
// // //     this.email2 = '',
// // //     this.phone2 = '',
// // //     this.idProofPath2,
// // //   });

// // //   CoupleGuest copyWith({
// // //     String? username1,
// // //     String? fullName1,
// // //     String? email1,
// // //     String? phone1,
// // //     String? idProofPath1,
// // //     String? username2,
// // //     String? fullName2,
// // //     String? email2,
// // //     String? phone2,
// // //     String? idProofPath2,
// // //   }) {
// // //     return CoupleGuest(
// // //       id: id,
// // //       username1: username1 ?? this.username1,
// // //       fullName1: fullName1 ?? this.fullName1,
// // //       email1: email1 ?? this.email1,
// // //       phone1: phone1 ?? this.phone1,
// // //       idProofPath1: idProofPath1 ?? this.idProofPath1,
// // //       username2: username2 ?? this.username2,
// // //       fullName2: fullName2 ?? this.fullName2,
// // //       email2: email2 ?? this.email2,
// // //       phone2: phone2 ?? this.phone2,
// // //       idProofPath2: idProofPath2 ?? this.idProofPath2,
// // //     );
// // //   }
// // // }

// // // // ═════════════════════════════════════════════════════════════════════════════
// // // // SECTION 3 — REPOSITORY
// // // // ═════════════════════════════════════════════════════════════════════════════

// // // class EventRepository {
// // //   static const String _baseUrl =
// // //       'https://app.beatflirtevent.com/App/events/get_single_events';

// // //   /// Builds headers exactly like ApiService._buildHeaders(token: token).
// // //   /// The Beat Flirt server reads auth from:
// // //   ///   - 'Authorization': 'Bearer $token'
// // //   ///   - 'access-token': token   ← this is the one the server actually checks
// // //   static Map<String, String> _buildHeaders(String token) {
// // //     return {
// // //       'Content-Type': 'application/json',
// // //       'Accept': 'application/json',
// // //       'Authorization': 'Bearer $token',
// // //       'access-token': token, // ✅ exact key used by ApiService._buildHeaders
// // //     };
// // //   }

// // //   Future<EventDetailResponse> getSingleEvent({required String eventId}) async {
// // //     final token = await _AuthService.getToken();

// // //     if (token == null || token.isEmpty) {
// // //       throw Exception('Not authenticated. Please log in again.');
// // //     }

// // //     debugPrint('[EventRepo] →  eventId=$eventId | tokenLen=${token.length}');

// // //     // ✅ Same format as getAllEvents() in ApiService:
// // //     //    POST with JSON body + auth headers (Authorization + access-token)
// // //     final response = await http.post(
// // //       Uri.parse(_baseUrl),
// // //       headers: _buildHeaders(token),
// // //       body: jsonEncode({'event_id': eventId}),
// // //     );

// // //     debugPrint(
// // //         '[EventRepo] ← ${response.statusCode} | ${response.body.length > 250 ? response.body.substring(0, 250) : response.body}');

// // //     final jsonBody = jsonDecode(response.body) as Map<String, dynamic>;
// // //     final apiStatus = jsonBody['status']?.toString() ?? '';

// // //     if (apiStatus == '200') {
// // //       return EventDetailResponse.fromJson(jsonBody);
// // //     }

// // //     // ── Fallback: form-encoded body (same fallback as getAllEvents) ────────────
// // //     final msg = (jsonBody['message'] ?? '').toString().toLowerCase();
// // //     if (msg.contains('provide') || msg.contains('token') || msg.contains('required')) {
// // //       debugPrint('[EventRepo] JSON rejected → retrying as form-encoded');

// // //       final r2 = await http.post(
// // //         Uri.parse(_baseUrl),
// // //         headers: {
// // //           'Accept': 'application/json',
// // //           'Content-Type': 'application/x-www-form-urlencoded',
// // //           'Authorization': 'Bearer $token',
// // //           'access-token': token,
// // //         },
// // //         body: {'event_id': eventId},
// // //       );

// // //       debugPrint(
// // //           '[EventRepo] form-encoded ← ${r2.statusCode} | ${r2.body.length > 250 ? r2.body.substring(0, 250) : r2.body}');

// // //       final j2 = jsonDecode(r2.body) as Map<String, dynamic>;
// // //       if (j2['status']?.toString() == '200') {
// // //         return EventDetailResponse.fromJson(j2);
// // //       }
// // //       throw Exception(j2['message'] ?? j2['msg'] ?? 'Failed to load event');
// // //     }

// // //     throw Exception(jsonBody['message'] ?? jsonBody['msg'] ?? 'Failed to load event');
// // //   }
// // // }

// // // // ═════════════════════════════════════════════════════════════════════════════
// // // // SECTION 4 — RIVERPOD PROVIDERS
// // // // ═════════════════════════════════════════════════════════════════════════════

// // // // ── Repository ────────────────────────────────────────────────────────────────
// // // final eventRepositoryProvider = Provider<EventRepository>((ref) {
// // //   return EventRepository();
// // // });

// // // // ── Event Detail — only needs eventId now, token is fetched internally ─────────
// // // final eventDetailProvider =
// // //     FutureProvider.family<EventDetailResponse, String>((ref, eventId) async {
// // //   final repo = ref.read(eventRepositoryProvider);
// // //   return repo.getSingleEvent(eventId: eventId);
// // // });

// // // // ── Room Quantity ─────────────────────────────────────────────────────────────
// // // class RoomQuantityNotifier extends StateNotifier<Map<String, int>> {
// // //   RoomQuantityNotifier() : super({});

// // //   void setQuantity(String roomId, int qty) =>
// // //       state = {...state, roomId: qty};

// // //   int getQuantity(String roomId) => state[roomId] ?? 0;

// // //   double totalAmount(List<RoomData> rooms) {
// // //     double total = 0;
// // //     for (final room in rooms) {
// // //       final qty = state[room.id] ?? 0;
// // //       if (qty > 0) total += qty * (double.tryParse(room.price) ?? 0);
// // //     }
// // //     return total;
// // //   }
// // // }

// // // final roomQuantityProvider =
// // //     StateNotifierProvider<RoomQuantityNotifier, Map<String, int>>(
// // //         (ref) => RoomQuantityNotifier());

// // // // ── Night Quantity ────────────────────────────────────────────────────────────
// // // class NightQuantityNotifier extends StateNotifier<Map<String, int>> {
// // //   NightQuantityNotifier() : super({});

// // //   void setQuantity(String date, int qty) =>
// // //       state = {...state, date: qty};

// // //   int getQuantity(String date) => state[date] ?? 0;

// // //   double totalAmount(String pricePerNight) {
// // //     final price = double.tryParse(pricePerNight) ?? 0;
// // //     final totalQty = state.values.fold(0, (a, b) => a + b);
// // //     return totalQty * price;
// // //   }
// // // }

// // // final nightQuantityProvider =
// // //     StateNotifierProvider<NightQuantityNotifier, Map<String, int>>(
// // //         (ref) => NightQuantityNotifier());

// // // // ── Guest List ────────────────────────────────────────────────────────────────
// // // class GuestListState {
// // //   final List<SingleGuest> singleGuests;
// // //   final List<CoupleGuest> coupleGuests;
// // //   final bool showValidation;

// // //   const GuestListState({
// // //     this.singleGuests = const [],
// // //     this.coupleGuests = const [],
// // //     this.showValidation = false,
// // //   });

// // //   GuestListState copyWith({
// // //     List<SingleGuest>? singleGuests,
// // //     List<CoupleGuest>? coupleGuests,
// // //     bool? showValidation,
// // //   }) {
// // //     return GuestListState(
// // //       singleGuests: singleGuests ?? this.singleGuests,
// // //       coupleGuests: coupleGuests ?? this.coupleGuests,
// // //       showValidation: showValidation ?? this.showValidation,
// // //     );
// // //   }
// // // }

// // // class GuestListNotifier extends StateNotifier<GuestListState> {
// // //   GuestListNotifier() : super(const GuestListState());

// // //   int _singleCounter = 0;
// // //   int _coupleCounter = 0;

// // //   void addSingleGuest() {
// // //     _singleCounter++;
// // //     state = state.copyWith(singleGuests: [
// // //       ...state.singleGuests,
// // //       SingleGuest(id: 'single_$_singleCounter')
// // //     ]);
// // //   }

// // //   void removeSingleGuest(String id) => state = state.copyWith(
// // //       singleGuests: state.singleGuests.where((g) => g.id != id).toList());

// // //   void updateSingleGuest(String id, SingleGuest updated) =>
// // //       state = state.copyWith(
// // //         singleGuests:
// // //             state.singleGuests.map((g) => g.id == id ? updated : g).toList(),
// // //       );

// // //   void addCoupleGuest() {
// // //     _coupleCounter++;
// // //     state = state.copyWith(coupleGuests: [
// // //       ...state.coupleGuests,
// // //       CoupleGuest(id: 'couple_$_coupleCounter')
// // //     ]);
// // //   }

// // //   void removeCoupleGuest(String id) => state = state.copyWith(
// // //       coupleGuests: state.coupleGuests.where((g) => g.id != id).toList());

// // //   void updateCoupleGuest(String id, CoupleGuest updated) =>
// // //       state = state.copyWith(
// // //         coupleGuests:
// // //             state.coupleGuests.map((g) => g.id == id ? updated : g).toList(),
// // //       );

// // //   void setShowValidation(bool val) =>
// // //       state = state.copyWith(showValidation: val);

// // //   bool validate() {
// // //     state = state.copyWith(showValidation: true);
// // //     for (final g in state.singleGuests) {
// // //       if (g.username.trim().isEmpty ||
// // //           g.fullName.trim().isEmpty ||
// // //           g.email.trim().isEmpty ||
// // //           g.phone.trim().isEmpty) return false;
// // //     }
// // //     for (final g in state.coupleGuests) {
// // //       if (g.username1.trim().isEmpty ||
// // //           g.fullName1.trim().isEmpty ||
// // //           g.email1.trim().isEmpty ||
// // //           g.phone1.trim().isEmpty ||
// // //           g.fullName2.trim().isEmpty ||
// // //           g.email2.trim().isEmpty ||
// // //           g.phone2.trim().isEmpty) return false;
// // //     }
// // //     return true;
// // //   }
// // // }

// // // final guestListProvider =
// // //     StateNotifierProvider<GuestListNotifier, GuestListState>(
// // //         (ref) => GuestListNotifier());

// // // // ── Payment / Voucher / UI State ──────────────────────────────────────────────
// // // enum PaymentType { full, partial }

// // // final paymentTypeProvider = StateProvider<PaymentType?>((ref) => null);
// // // final voucherCodeProvider = StateProvider<String>((ref) => '');
// // // final voucherDiscountProvider = StateProvider<double>((ref) => 0.0);
// // // final membershipDiscountProvider = StateProvider<double>((ref) => 0.0);
// // // final descriptionExpandedProvider = StateProvider<bool>((ref) => false);

// // // // ═════════════════════════════════════════════════════════════════════════════
// // // // SECTION 5 — SCREEN
// // // // ═════════════════════════════════════════════════════════════════════════════

// // // /// ✅ Only pass [eventId]. Token is read automatically from SharedPreferences.
// // // ///
// // // /// Navigate like this (from anywhere):
// // // /// ```dart
// // // /// Navigator.push(context, MaterialPageRoute(
// // // ///   builder: (_) => EventDetailScreen(eventId: event.id),
// // // /// ));
// // // /// ```
// // // class EventDetailScreen extends ConsumerWidget {
// // //   final String eventId;

// // //   const EventDetailScreen({
// // //     super.key,
// // //     required this.eventId,
// // //   });

// // //   @override
// // //   Widget build(BuildContext context, WidgetRef ref) {
// // //     final asyncEvent = ref.watch(eventDetailProvider(eventId));

// // //     return Scaffold(
// // //       backgroundColor: const Color(0xFFFFF0F5),
// // //       appBar: AppBar(
// // //         backgroundColor: Colors.white,
// // //         elevation: 0.5,
// // //         leading: const SizedBox.shrink(),
// // //         title: const Text(
// // //           'Parties And Events',
// // //           style: TextStyle(
// // //               color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
// // //         ),
// // //         actions: [
// // //           Padding(
// // //             padding: const EdgeInsets.only(right: 12),
// // //             child: ElevatedButton.icon(
// // //               onPressed: () => Navigator.of(context).pop(),
// // //               icon: const Icon(Icons.arrow_back, size: 16, color: Colors.white),
// // //               label: const Text('Back',
// // //                   style: TextStyle(color: Colors.white, fontSize: 13)),
// // //               style: ElevatedButton.styleFrom(
// // //                 backgroundColor: const Color(0xFF8B0045),
// // //                 shape: RoundedRectangleBorder(
// // //                     borderRadius: BorderRadius.circular(20)),
// // //                 padding:
// // //                     const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
// // //               ),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //       body: asyncEvent.when(
// // //         loading: () => const Center(
// // //             child: CircularProgressIndicator(color: Color(0xFF8B0045))),
// // //         error: (err, _) => _buildError(context, ref, err),
// // //         data: (eventResponse) => _buildContent(eventResponse),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildError(BuildContext context, WidgetRef ref, Object err) {
// // //     final isAuthError = err.toString().contains('authenticated') ||
// // //         err.toString().contains('log in');
// // //     return Center(
// // //       child: Padding(
// // //         padding: const EdgeInsets.all(24),
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: [
// // //             Icon(
// // //               isAuthError ? Icons.lock_outline : Icons.error_outline,
// // //               size: 60,
// // //               color: const Color(0xFF8B0045),
// // //             ),
// // //             const SizedBox(height: 16),
// // //             Text(
// // //               isAuthError ? 'Session Expired' : 'Failed to load event',
// // //               style: const TextStyle(
// // //                   fontSize: 18,
// // //                   fontWeight: FontWeight.bold,
// // //                   color: Colors.black87),
// // //             ),
// // //             const SizedBox(height: 8),
// // //             Text(
// // //               isAuthError
// // //                   ? 'Your session has expired. Please log in again.'
// // //                   : err.toString(),
// // //               textAlign: TextAlign.center,
// // //               style: const TextStyle(color: Colors.grey, fontSize: 13),
// // //             ),
// // //             const SizedBox(height: 20),
// // //             ElevatedButton.icon(
// // //               style: ElevatedButton.styleFrom(
// // //                   backgroundColor: const Color(0xFF8B0045)),
// // //               onPressed: () => ref.refresh(eventDetailProvider(eventId)),
// // //               icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
// // //               label: const Text('Retry',
// // //                   style: TextStyle(color: Colors.white)),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildContent(EventDetailResponse eventResponse) {
// // //     return SingleChildScrollView(
// // //       padding: const EdgeInsets.all(16),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           _EventHeaderCard(event: eventResponse.data),
// // //           const SizedBox(height: 16),
// // //           const _GuestSection(),
// // //           const SizedBox(height: 16),
// // //           if (eventResponse.roomList.data.isNotEmpty) ...[
// // //             _RoomPackageSection(rooms: eventResponse.roomList.data),
// // //             const SizedBox(height: 16),
// // //           ],
// // //           if (eventResponse.additionalNights.isNotEmpty) ...[
// // //             _AdditionalNightSection(
// // //               nights: eventResponse.additionalNights,
// // //               pricePerNight: eventResponse.data.additionalRoomNightPrice,
// // //               feePerNight: eventResponse.data.additionalRoomNightFee,
// // //             ),
// // //             const SizedBox(height: 16),
// // //           ],
// // //           _OrderSummarySection(
// // //             rooms: eventResponse.roomList.data,
// // //             nights: eventResponse.additionalNights,
// // //             pricePerNight: eventResponse.data.additionalRoomNightPrice,
// // //             feePerNight: eventResponse.data.additionalRoomNightFee,
// // //           ),
// // //           const SizedBox(height: 30),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // // ═════════════════════════════════════════════════════════════════════════════
// // // // SECTION 6 — EVENT HEADER CARD
// // // // ═════════════════════════════════════════════════════════════════════════════

// // // class _EventHeaderCard extends ConsumerWidget {
// // //   final EventData event;
// // //   const _EventHeaderCard({required this.event});

// // //   String _formatDate(String date, String time) {
// // //     try {
// // //       final parts = date.split('-');
// // //       if (parts.length < 3) return '$date $time';
// // //       final months = [
// // //         '', 'January', 'February', 'March', 'April', 'May', 'June',
// // //         'July', 'August', 'September', 'October', 'November', 'December'
// // //       ];
// // //       final year = parts[0];
// // //       final month = int.tryParse(parts[1]) ?? 0;
// // //       final day = int.tryParse(parts[2]) ?? 0;
// // //       final monthName = month < months.length ? months[month] : parts[1];
// // //       final timeParts = time.split(':');
// // //       int hour = int.tryParse(timeParts[0]) ?? 0;
// // //       final min = timeParts.length > 1 ? timeParts[1] : '00';
// // //       final period = hour >= 12 ? 'pm' : 'am';
// // //       hour = hour % 12;
// // //       if (hour == 0) hour = 12;
// // //       final dt = DateTime.tryParse(date);
// // //       final days = [
// // //         '', 'Monday', 'Tuesday', 'Wednesday', 'Thursday',
// // //         'Friday', 'Saturday', 'Sunday'
// // //       ];
// // //       final dayName = dt != null ? days[dt.weekday] : '';
// // //       return '$dayName, $monthName $day, $year  $hour:$min $period';
// // //     } catch (_) {
// // //       return '$date $time';
// // //     }
// // //   }

// // //   String _stripHtml(String html) {
// // //     return html
// // //         .replaceAll('&amp;lt;', '<')
// // //         .replaceAll('&amp;gt;', '>')
// // //         .replaceAll('&amp;amp;', '&')
// // //         .replaceAll('&amp;nbsp;', ' ')
// // //         .replaceAll('&lt;', '<')
// // //         .replaceAll('&gt;', '>')
// // //         .replaceAll('&amp;', '&')
// // //         .replaceAll('&nbsp;', ' ')
// // //         .replaceAll('\r\n', ' ')
// // //         .replaceAll(RegExp(r'<[^>]*>'), '')
// // //         .trim();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context, WidgetRef ref) {
// // //     final isExpanded = ref.watch(descriptionExpandedProvider);
// // //     final cleanDescription = _stripHtml(event.eventDescription);
// // //     const maxChars = 80;
// // //     final isLong = cleanDescription.length > maxChars;
// // //     final displayText = (!isExpanded && isLong)
// // //         ? '${cleanDescription.substring(0, maxChars)}...'
// // //         : cleanDescription;

// // //     return Container(
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         borderRadius: BorderRadius.circular(12),
// // //         boxShadow: [
// // //           BoxShadow(
// // //               color: Colors.black.withOpacity(0.06),
// // //               blurRadius: 8,
// // //               offset: const Offset(0, 2))
// // //         ],
// // //       ),
// // //       child: Padding(
// // //         padding: const EdgeInsets.all(16),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Row(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 // Event Image
// // //                 ClipRRect(
// // //                   borderRadius: BorderRadius.circular(10),
// // //                   child: Image.network(
// // //                     event.eventImage,
// // //                     width: 140,
// // //                     height: 160,
// // //                     fit: BoxFit.cover,
// // //                     errorBuilder: (_, __, ___) => Container(
// // //                       width: 140,
// // //                       height: 160,
// // //                       color: Colors.grey[200],
// // //                       child: const Icon(Icons.image_not_supported,
// // //                           color: Colors.grey, size: 40),
// // //                     ),
// // //                     loadingBuilder: (_, child, progress) {
// // //                       if (progress == null) return child;
// // //                       return Container(
// // //                         width: 140,
// // //                         height: 160,
// // //                         color: Colors.grey[100],
// // //                         child: const Center(
// // //                             child: CircularProgressIndicator(
// // //                                 strokeWidth: 2,
// // //                                 color: Color(0xFF8B0045))),
// // //                       );
// // //                     },
// // //                   ),
// // //                 ),
// // //                 const SizedBox(width: 14),
// // //                 // Details
// // //                 Expanded(
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       Text(event.eventName,
// // //                           style: const TextStyle(
// // //                               fontSize: 18,
// // //                               fontWeight: FontWeight.bold,
// // //                               color: Colors.black87)),
// // //                       const SizedBox(height: 8),
// // //                       Text(
// // //                         '${_formatDate(event.eventFromDate, event.eventFromTime)}  –  ${_formatDate(event.eventToDate, event.eventToTime)}',
// // //                         style: const TextStyle(
// // //                             fontSize: 12, color: Colors.black54),
// // //                       ),
// // //                       const SizedBox(height: 8),
// // //                       if (event.formattedAddress.isNotEmpty)
// // //                         Row(
// // //                           crossAxisAlignment: CrossAxisAlignment.start,
// // //                           children: [
// // //                             const Icon(Icons.location_on,
// // //                                 size: 15, color: Color(0xFF8B0045)),
// // //                             const SizedBox(width: 4),
// // //                             Expanded(
// // //                               child: Text(event.formattedAddress,
// // //                                   style: const TextStyle(
// // //                                       fontSize: 12, color: Colors.black87)),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                       const SizedBox(height: 8),
// // //                       if (event.eventEmail.isNotEmpty)
// // //                         Text('contacted by:- ${event.eventEmail}',
// // //                             style: const TextStyle(
// // //                                 fontSize: 12, color: Colors.black54)),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //             const SizedBox(height: 14),
// // //             const Text('Description',
// // //                 style: TextStyle(
// // //                     fontSize: 14,
// // //                     fontWeight: FontWeight.bold,
// // //                     color: Colors.black87)),
// // //             const SizedBox(height: 6),
// // //             Text(displayText,
// // //                 style: const TextStyle(
// // //                     fontSize: 13, color: Color(0xFFD81B60))),
// // //             if (isLong) ...[
// // //               const SizedBox(height: 4),
// // //               GestureDetector(
// // //                 onTap: () => ref
// // //                     .read(descriptionExpandedProvider.notifier)
// // //                     .state = !isExpanded,
// // //                 child: Text(
// // //                   isExpanded ? 'Show Less' : 'Show More...',
// // //                   style: const TextStyle(
// // //                       fontSize: 13,
// // //                       color: Colors.black87,
// // //                       fontWeight: FontWeight.w500),
// // //                 ),
// // //               ),
// // //             ],
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // // ═════════════════════════════════════════════════════════════════════════════
// // // // SECTION 7 — GUEST SECTION
// // // // ═════════════════════════════════════════════════════════════════════════════

// // // class _GuestSection extends ConsumerWidget {
// // //   const _GuestSection();

// // //   @override
// // //   Widget build(BuildContext context, WidgetRef ref) {
// // //     final guestState = ref.watch(guestListProvider);

// // //     return Container(
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         borderRadius: BorderRadius.circular(12),
// // //         boxShadow: [
// // //           BoxShadow(
// // //               color: Colors.black.withOpacity(0.06),
// // //               blurRadius: 8,
// // //               offset: const Offset(0, 2))
// // //         ],
// // //       ),
// // //       padding: const EdgeInsets.all(16),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           // Auto-fill checkbox
// // //           Row(
// // //             children: [
// // //               Checkbox(
// // //                   value: false,
// // //                   activeColor: const Color(0xFF8B0045),
// // //                   onChanged: (_) {}),
// // //               const Text('Click here to generate your information',
// // //                   style: TextStyle(fontSize: 13, color: Colors.black87)),
// // //             ],
// // //           ),
// // //           const SizedBox(height: 8),

// // //           // Add Guest buttons
// // //           Row(
// // //             children: [
// // //               const Text('Add Guest:',
// // //                   style: TextStyle(
// // //                       fontSize: 14,
// // //                       fontWeight: FontWeight.bold,
// // //                       color: Color(0xFFD81B60))),
// // //               const SizedBox(width: 12),
// // //               _GuestTypeButton(
// // //                 icon: Icons.person,
// // //                 label: 'Single',
// // //                 onTap: () =>
// // //                     ref.read(guestListProvider.notifier).addSingleGuest(),
// // //               ),
// // //               const SizedBox(width: 10),
// // //               _GuestTypeButton(
// // //                 icon: Icons.people,
// // //                 label: 'Couple',
// // //                 onTap: () =>
// // //                     ref.read(guestListProvider.notifier).addCoupleGuest(),
// // //               ),
// // //             ],
// // //           ),
// // //           const SizedBox(height: 14),

// // //           // Single guest cards
// // //           ...guestState.singleGuests.asMap().entries.map(
// // //                 (entry) => Padding(
// // //                   padding: const EdgeInsets.only(bottom: 12),
// // //                   child: _SingleGuestCard(
// // //                     guest: entry.value,
// // //                     index: entry.key + 1,
// // //                     showValidation: guestState.showValidation,
// // //                   ),
// // //                 ),
// // //               ),

// // //           // Couple guest cards
// // //           ...guestState.coupleGuests.asMap().entries.map(
// // //                 (entry) => Padding(
// // //                   padding: const EdgeInsets.only(bottom: 12),
// // //                   child: _CoupleGuestCard(
// // //                     guest: entry.value,
// // //                     index: entry.key + 1,
// // //                     showValidation: guestState.showValidation,
// // //                   ),
// // //                 ),
// // //               ),

// // //           // Add Guests to List button
// // //           if (guestState.singleGuests.isNotEmpty ||
// // //               guestState.coupleGuests.isNotEmpty) ...[
// // //             const SizedBox(height: 8),
// // //             Center(
// // //               child: ElevatedButton(
// // //                 onPressed: () {
// // //                   final isValid =
// // //                       ref.read(guestListProvider.notifier).validate();
// // //                   if (isValid) {
// // //                     ScaffoldMessenger.of(context).showSnackBar(
// // //                       const SnackBar(
// // //                         content: Text('Guests added to list!'),
// // //                         backgroundColor: Color(0xFF8B0045),
// // //                       ),
// // //                     );
// // //                   }
// // //                 },
// // //                 style: ElevatedButton.styleFrom(
// // //                   backgroundColor: const Color(0xFF1A0A2E),
// // //                   shape: RoundedRectangleBorder(
// // //                       borderRadius: BorderRadius.circular(8)),
// // //                   padding: const EdgeInsets.symmetric(
// // //                       horizontal: 32, vertical: 14),
// // //                 ),
// // //                 child: const Text('Add Guests to the List',
// // //                     style: TextStyle(color: Colors.white, fontSize: 14)),
// // //               ),
// // //             ),
// // //           ],
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // // ── Guest Type Button ─────────────────────────────────────────────────────────
// // // class _GuestTypeButton extends StatelessWidget {
// // //   final IconData icon;
// // //   final String label;
// // //   final VoidCallback onTap;

// // //   const _GuestTypeButton(
// // //       {required this.icon, required this.label, required this.onTap});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return ElevatedButton.icon(
// // //       onPressed: onTap,
// // //       icon: Icon(icon, size: 16, color: Colors.white),
// // //       label: Text(label, style: const TextStyle(color: Colors.white)),
// // //       style: ElevatedButton.styleFrom(
// // //         backgroundColor: const Color(0xFF1A0A2E),
// // //         shape:
// // //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
// // //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
// // //       ),
// // //     );
// // //   }
// // // }

// // // // ── Single Guest Card ─────────────────────────────────────────────────────────
// // // class _SingleGuestCard extends ConsumerStatefulWidget {
// // //   final SingleGuest guest;
// // //   final int index;
// // //   final bool showValidation;

// // //   const _SingleGuestCard(
// // //       {required this.guest,
// // //       required this.index,
// // //       required this.showValidation});

// // //   @override
// // //   ConsumerState<_SingleGuestCard> createState() => _SingleGuestCardState();
// // // }

// // // class _SingleGuestCardState extends ConsumerState<_SingleGuestCard> {
// // //   late final TextEditingController _usernameCtrl;
// // //   late final TextEditingController _fullNameCtrl;
// // //   late final TextEditingController _emailCtrl;
// // //   late final TextEditingController _phoneCtrl;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _usernameCtrl = TextEditingController(text: widget.guest.username);
// // //     _fullNameCtrl = TextEditingController(text: widget.guest.fullName);
// // //     _emailCtrl = TextEditingController(text: widget.guest.email);
// // //     _phoneCtrl = TextEditingController(text: widget.guest.phone);
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _usernameCtrl.dispose();
// // //     _fullNameCtrl.dispose();
// // //     _emailCtrl.dispose();
// // //     _phoneCtrl.dispose();
// // //     super.dispose();
// // //   }

// // //   void _update() {
// // //     ref.read(guestListProvider.notifier).updateSingleGuest(
// // //           widget.guest.id,
// // //           widget.guest.copyWith(
// // //             username: _usernameCtrl.text,
// // //             fullName: _fullNameCtrl.text,
// // //             email: _emailCtrl.text,
// // //             phone: _phoneCtrl.text,
// // //           ),
// // //         );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final sv = widget.showValidation;
// // //     return Container(
// // //       decoration: BoxDecoration(
// // //         border: Border.all(color: const Color(0xFF4FC3F7), width: 1.2),
// // //         borderRadius: BorderRadius.circular(10),
// // //       ),
// // //       padding: const EdgeInsets.all(14),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Row(
// // //             children: [
// // //               Expanded(
// // //                 child: Text('Add New Single Guest #${widget.index}',
// // //                     style: const TextStyle(
// // //                         fontWeight: FontWeight.bold,
// // //                         fontSize: 14,
// // //                         color: Colors.black87)),
// // //               ),
// // //               _DeleteButton(
// // //                   onTap: () => ref
// // //                       .read(guestListProvider.notifier)
// // //                       .removeSingleGuest(widget.guest.id)),
// // //             ],
// // //           ),
// // //           const SizedBox(height: 14),
// // //           Row(
// // //             children: [
// // //               Expanded(
// // //                 child: _GuestField(
// // //                   label: 'Username',
// // //                   hint: 'Enter Username',
// // //                   controller: _usernameCtrl,
// // //                   onChanged: (_) => _update(),
// // //                   showError: sv && _usernameCtrl.text.trim().isEmpty,
// // //                 ),
// // //               ),
// // //               const SizedBox(width: 12),
// // //               Expanded(
// // //                 child: _GuestField(
// // //                   label: 'Full Name',
// // //                   hint: 'Enter Full Name',
// // //                   controller: _fullNameCtrl,
// // //                   onChanged: (_) => _update(),
// // //                   showError: sv && _fullNameCtrl.text.trim().isEmpty,
// // //                   showInfoIcon: true,
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //           const SizedBox(height: 12),
// // //           Row(
// // //             children: [
// // //               Expanded(
// // //                 child: _GuestField(
// // //                   label: 'Email',
// // //                   hint: 'Email',
// // //                   controller: _emailCtrl,
// // //                   onChanged: (_) => _update(),
// // //                   showError: sv && _emailCtrl.text.trim().isEmpty,
// // //                   keyboardType: TextInputType.emailAddress,
// // //                 ),
// // //               ),
// // //               const SizedBox(width: 8),
// // //               Expanded(
// // //                 child: _GuestField(
// // //                   label: 'Phone',
// // //                   hint: 'Enter Phone Number',
// // //                   controller: _phoneCtrl,
// // //                   onChanged: (_) => _update(),
// // //                   showError: sv && _phoneCtrl.text.trim().isEmpty,
// // //                   keyboardType: TextInputType.phone,
// // //                 ),
// // //               ),
// // //               const SizedBox(width: 8),
// // //               Expanded(
// // //                 child: _IdProofPicker(
// // //                   showError: sv && widget.guest.idProofPath == null,
// // //                   filePath: widget.guest.idProofPath,
// // //                   onPicked: (path) {
// // //                     ref.read(guestListProvider.notifier).updateSingleGuest(
// // //                           widget.guest.id,
// // //                           widget.guest.copyWith(idProofPath: path),
// // //                         );
// // //                   },
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // // ── Couple Guest Card ─────────────────────────────────────────────────────────
// // // class _CoupleGuestCard extends ConsumerStatefulWidget {
// // //   final CoupleGuest guest;
// // //   final int index;
// // //   final bool showValidation;

// // //   const _CoupleGuestCard(
// // //       {required this.guest,
// // //       required this.index,
// // //       required this.showValidation});

// // //   @override
// // //   ConsumerState<_CoupleGuestCard> createState() => _CoupleGuestCardState();
// // // }

// // // class _CoupleGuestCardState extends ConsumerState<_CoupleGuestCard> {
// // //   late final TextEditingController _u1, _fn1, _e1, _p1;
// // //   late final TextEditingController _u2, _fn2, _e2, _p2;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _u1 = TextEditingController(text: widget.guest.username1);
// // //     _fn1 = TextEditingController(text: widget.guest.fullName1);
// // //     _e1 = TextEditingController(text: widget.guest.email1);
// // //     _p1 = TextEditingController(text: widget.guest.phone1);
// // //     _u2 = TextEditingController(text: widget.guest.username2);
// // //     _fn2 = TextEditingController(text: widget.guest.fullName2);
// // //     _e2 = TextEditingController(text: widget.guest.email2);
// // //     _p2 = TextEditingController(text: widget.guest.phone2);
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _u1.dispose(); _fn1.dispose(); _e1.dispose(); _p1.dispose();
// // //     _u2.dispose(); _fn2.dispose(); _e2.dispose(); _p2.dispose();
// // //     super.dispose();
// // //   }

// // //   void _update() {
// // //     ref.read(guestListProvider.notifier).updateCoupleGuest(
// // //           widget.guest.id,
// // //           widget.guest.copyWith(
// // //             username1: _u1.text, fullName1: _fn1.text,
// // //             email1: _e1.text, phone1: _p1.text,
// // //             username2: _u2.text, fullName2: _fn2.text,
// // //             email2: _e2.text, phone2: _p2.text,
// // //           ),
// // //         );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final sv = widget.showValidation;
// // //     return Container(
// // //       decoration: BoxDecoration(
// // //         border: Border.all(color: const Color(0xFF4FC3F7), width: 1.2),
// // //         borderRadius: BorderRadius.circular(10),
// // //       ),
// // //       padding: const EdgeInsets.all(14),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Row(
// // //             children: [
// // //               Expanded(
// // //                 child: Text('Add New Couple Guest #${widget.index}',
// // //                     style: const TextStyle(
// // //                         fontWeight: FontWeight.bold,
// // //                         fontSize: 14,
// // //                         color: Color(0xFF4FC3F7))),
// // //               ),
// // //               _DeleteButton(
// // //                   onTap: () => ref
// // //                       .read(guestListProvider.notifier)
// // //                       .removeCoupleGuest(widget.guest.id)),
// // //             ],
// // //           ),
// // //           const SizedBox(height: 14),

// // //           // ── Member 1 ──────────────────────────────────────────────────
// // //           const _SectionLabel(label: 'Member 1'),
// // //           const SizedBox(height: 8),
// // //           Row(
// // //             children: [
// // //               Expanded(
// // //                 child: _GuestField(
// // //                   label: 'Username (Member 1)',
// // //                   hint: 'Enter Username',
// // //                   controller: _u1,
// // //                   onChanged: (_) => _update(),
// // //                   showError: sv && _u1.text.trim().isEmpty,
// // //                 ),
// // //               ),
// // //               const SizedBox(width: 12),
// // //               Expanded(
// // //                 child: _GuestField(
// // //                   label: 'Full Name (Member 1)',
// // //                   hint: 'Enter Full Name',
// // //                   controller: _fn1,
// // //                   onChanged: (_) => _update(),
// // //                   showError: sv && _fn1.text.trim().isEmpty,
// // //                   showInfoIcon: true,
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //           const SizedBox(height: 10),
// // //           Row(
// // //             children: [
// // //               Expanded(
// // //                 child: _GuestField(
// // //                   label: 'E-mail (Member 1)',
// // //                   hint: 'Enter Your E-mail',
// // //                   controller: _e1,
// // //                   onChanged: (_) => _update(),
// // //                   showError: sv && _e1.text.trim().isEmpty,
// // //                   keyboardType: TextInputType.emailAddress,
// // //                 ),
// // //               ),
// // //               const SizedBox(width: 8),
// // //               Expanded(
// // //                 child: _GuestField(
// // //                   label: 'Phone Number (Member 1)',
// // //                   hint: 'Enter Phone Number',
// // //                   controller: _p1,
// // //                   onChanged: (_) => _update(),
// // //                   showError: sv && _p1.text.trim().isEmpty,
// // //                   keyboardType: TextInputType.phone,
// // //                 ),
// // //               ),
// // //               const SizedBox(width: 8),
// // //               Expanded(
// // //                 child: _IdProofPicker(
// // //                   label: 'Id Proof (Member 1)',
// // //                   showError: sv && widget.guest.idProofPath1 == null,
// // //                   filePath: widget.guest.idProofPath1,
// // //                   onPicked: (path) {
// // //                     ref.read(guestListProvider.notifier).updateCoupleGuest(
// // //                           widget.guest.id,
// // //                           widget.guest.copyWith(idProofPath1: path),
// // //                         );
// // //                   },
// // //                 ),
// // //               ),
// // //             ],
// // //           ),

// // //           const SizedBox(height: 16),
// // //           const Divider(height: 1, color: Color(0xFFEEEEEE)),
// // //           const SizedBox(height: 16),

// // //           // ── Member 2 ──────────────────────────────────────────────────
// // //           const _SectionLabel(label: 'Member 2'),
// // //           const SizedBox(height: 8),
// // //           Row(
// // //             children: [
// // //               Expanded(
// // //                 child: _GuestField(
// // //                   label: 'Username (Member 2)',
// // //                   hint: 'Username',
// // //                   controller: _u2,
// // //                   onChanged: (_) => _update(),
// // //                   showError: false,
// // //                 ),
// // //               ),
// // //               const SizedBox(width: 12),
// // //               Expanded(
// // //                 child: _GuestField(
// // //                   label: 'Full Name (Member 2)',
// // //                   hint: 'Enter Full Name',
// // //                   controller: _fn2,
// // //                   onChanged: (_) => _update(),
// // //                   showError: sv && _fn2.text.trim().isEmpty,
// // //                   showInfoIcon: true,
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //           const SizedBox(height: 10),
// // //           Row(
// // //             children: [
// // //               Expanded(
// // //                 child: _GuestField(
// // //                   label: 'Email (Member 2)',
// // //                   hint: 'Enter Email',
// // //                   controller: _e2,
// // //                   onChanged: (_) => _update(),
// // //                   showError: sv && _e2.text.trim().isEmpty,
// // //                   keyboardType: TextInputType.emailAddress,
// // //                 ),
// // //               ),
// // //               const SizedBox(width: 8),
// // //               Expanded(
// // //                 child: _GuestField(
// // //                   label: 'Phone (Member 2)',
// // //                   hint: 'Enter Phone Number',
// // //                   controller: _p2,
// // //                   onChanged: (_) => _update(),
// // //                   showError: sv && _p2.text.trim().isEmpty,
// // //                   keyboardType: TextInputType.phone,
// // //                 ),
// // //               ),
// // //               const SizedBox(width: 8),
// // //               Expanded(
// // //                 child: _IdProofPicker(
// // //                   label: 'Id Proof (Member 2)',
// // //                   showError: sv && widget.guest.idProofPath2 == null,
// // //                   filePath: widget.guest.idProofPath2,
// // //                   onPicked: (path) {
// // //                     ref.read(guestListProvider.notifier).updateCoupleGuest(
// // //                           widget.guest.id,
// // //                           widget.guest.copyWith(idProofPath2: path),
// // //                         );
// // //                   },
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //           const SizedBox(height: 12),
// // //           Align(
// // //             alignment: Alignment.centerRight,
// // //             child: ElevatedButton(
// // //               onPressed: () => ref
// // //                   .read(guestListProvider.notifier)
// // //                   .removeCoupleGuest(widget.guest.id),
// // //               style: ElevatedButton.styleFrom(
// // //                 backgroundColor: const Color(0xFFD32F2F),
// // //                 shape: RoundedRectangleBorder(
// // //                     borderRadius: BorderRadius.circular(8)),
// // //                 padding:
// // //                     const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// // //               ),
// // //               child: const Text('Remove',
// // //                   style: TextStyle(color: Colors.white, fontSize: 13)),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // // ── Shared small widgets ──────────────────────────────────────────────────────

// // // class _SectionLabel extends StatelessWidget {
// // //   final String label;
// // //   const _SectionLabel({required this.label});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Text(label,
// // //         style: const TextStyle(
// // //             fontSize: 12,
// // //             fontWeight: FontWeight.w600,
// // //             color: Colors.black54,
// // //             letterSpacing: 0.5));
// // //   }
// // // }

// // // class _GuestField extends StatelessWidget {
// // //   final String label;
// // //   final String hint;
// // //   final TextEditingController controller;
// // //   final ValueChanged<String> onChanged;
// // //   final bool showError;
// // //   final bool showInfoIcon;
// // //   final TextInputType keyboardType;

// // //   const _GuestField({
// // //     required this.label,
// // //     required this.hint,
// // //     required this.controller,
// // //     required this.onChanged,
// // //     required this.showError,
// // //     this.showInfoIcon = false,
// // //     this.keyboardType = TextInputType.text,
// // //   });

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         Row(
// // //           children: [
// // //             Text(label,
// // //                 style: const TextStyle(
// // //                     fontSize: 12,
// // //                     fontWeight: FontWeight.w600,
// // //                     color: Colors.black87)),
// // //             if (showInfoIcon) ...[
// // //               const SizedBox(width: 4),
// // //               const Icon(Icons.info_outline, size: 14, color: Colors.black54),
// // //             ],
// // //           ],
// // //         ),
// // //         const SizedBox(height: 4),
// // //         TextField(
// // //           controller: controller,
// // //           onChanged: onChanged,
// // //           keyboardType: keyboardType,
// // //           style: const TextStyle(fontSize: 13),
// // //           decoration: InputDecoration(
// // //             hintText: hint,
// // //             hintStyle:
// // //                 const TextStyle(fontSize: 13, color: Colors.black38),
// // //             contentPadding:
// // //                 const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// // //             border: OutlineInputBorder(
// // //                 borderRadius: BorderRadius.circular(6),
// // //                 borderSide: const BorderSide(color: Color(0xFFCCCCCC))),
// // //             enabledBorder: OutlineInputBorder(
// // //                 borderRadius: BorderRadius.circular(6),
// // //                 borderSide: const BorderSide(color: Color(0xFFCCCCCC))),
// // //             focusedBorder: OutlineInputBorder(
// // //                 borderRadius: BorderRadius.circular(6),
// // //                 borderSide: const BorderSide(
// // //                     color: Color(0xFF8B0045), width: 1.5)),
// // //           ),
// // //         ),
// // //         if (showError) ...[
// // //           const SizedBox(height: 3),
// // //           const Text('This Field is required',
// // //               style: TextStyle(fontSize: 11, color: Color(0xFFD32F2F))),
// // //         ],
// // //       ],
// // //     );
// // //   }
// // // }

// // // class _IdProofPicker extends StatelessWidget {
// // //   final String? filePath;
// // //   final bool showError;
// // //   final ValueChanged<String> onPicked;
// // //   final String label;

// // //   const _IdProofPicker({
// // //     required this.showError,
// // //     required this.onPicked,
// // //     this.filePath,
// // //     this.label = 'Id Proof',
// // //   });

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         Row(
// // //           children: [
// // //             Text(label,
// // //                 style: const TextStyle(
// // //                     fontSize: 12,
// // //                     fontWeight: FontWeight.w600,
// // //                     color: Colors.black87)),
// // //             const SizedBox(width: 4),
// // //             const Icon(Icons.info_outline, size: 14, color: Colors.black54),
// // //           ],
// // //         ),
// // //         const SizedBox(height: 4),
// // //         GestureDetector(
// // //           onTap: () {
// // //             // 👉 Replace with: FilePicker.platform.pickFiles(type: FileType.image)
// // //             onPicked('selected_file.jpg');
// // //           },
// // //           child: Container(
// // //             width: double.infinity,
// // //             decoration: BoxDecoration(
// // //                 border: Border.all(color: const Color(0xFFCCCCCC)),
// // //                 borderRadius: BorderRadius.circular(6)),
// // //             child: Row(
// // //               children: [
// // //                 Container(
// // //                   padding: const EdgeInsets.symmetric(
// // //                       horizontal: 10, vertical: 10),
// // //                   decoration: const BoxDecoration(
// // //                       border: Border(
// // //                           right: BorderSide(color: Color(0xFFCCCCCC)))),
// // //                   child: const Text('Choose file',
// // //                       style: TextStyle(
// // //                           fontSize: 12, color: Colors.black87)),
// // //                 ),
// // //                 Expanded(
// // //                   child: Padding(
// // //                     padding: const EdgeInsets.symmetric(horizontal: 8),
// // //                     child: Text(
// // //                       filePath != null
// // //                           ? filePath!.split('/').last
// // //                           : 'No file chosen',
// // //                       style: const TextStyle(
// // //                           fontSize: 11, color: Colors.black45),
// // //                       overflow: TextOverflow.ellipsis,
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //         if (showError) ...[
// // //           const SizedBox(height: 3),
// // //           const Text('This Field is required',
// // //               style: TextStyle(fontSize: 11, color: Color(0xFFD32F2F))),
// // //         ],
// // //       ],
// // //     );
// // //   }
// // // }

// // // class _DeleteButton extends StatelessWidget {
// // //   final VoidCallback onTap;
// // //   const _DeleteButton({required this.onTap});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return GestureDetector(
// // //       onTap: onTap,
// // //       child: Container(
// // //         width: 36,
// // //         height: 36,
// // //         decoration: BoxDecoration(
// // //             color: const Color(0xFFD32F2F),
// // //             borderRadius: BorderRadius.circular(6)),
// // //         child:
// // //             const Icon(Icons.delete_outline, color: Colors.white, size: 20),
// // //       ),
// // //     );
// // //   }
// // // }

// // // // ═════════════════════════════════════════════════════════════════════════════
// // // // SECTION 8 — ROOM PACKAGE SECTION
// // // // ═════════════════════════════════════════════════════════════════════════════

// // // class _RoomPackageSection extends ConsumerWidget {
// // //   final List<RoomData> rooms;
// // //   const _RoomPackageSection({required this.rooms});

// // //   @override
// // //   Widget build(BuildContext context, WidgetRef ref) {
// // //     final quantities = ref.watch(roomQuantityProvider);

// // //     return Container(
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         borderRadius: BorderRadius.circular(12),
// // //         boxShadow: [
// // //           BoxShadow(
// // //               color: Colors.black.withOpacity(0.06),
// // //               blurRadius: 8,
// // //               offset: const Offset(0, 2))
// // //         ],
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           const Padding(
// // //             padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
// // //             child: Text('Choose Your Beat Flirt Package',
// // //                 style: TextStyle(
// // //                     fontSize: 16,
// // //                     fontWeight: FontWeight.bold,
// // //                     color: Colors.black87)),
// // //           ),
// // //           _RoomTableHeader(),
// // //           const Divider(height: 1),
// // //           ...rooms.asMap().entries.map((entry) {
// // //             final room = entry.value;
// // //             final isLast = entry.key == rooms.length - 1;
// // //             final qty = quantities[room.id] ?? 0;
// // //             final amount = qty * (double.tryParse(room.price) ?? 0);
// // //             return Column(
// // //               children: [
// // //                 Padding(
// // //                   padding: const EdgeInsets.symmetric(
// // //                       horizontal: 12, vertical: 10),
// // //                   child: Row(
// // //                     crossAxisAlignment: CrossAxisAlignment.center,
// // //                     children: [
// // //                       _QuantityDropdown(
// // //                         value: qty,
// // //                         max: int.tryParse(room.roomAvailable) ?? 10,
// // //                         onChanged: (val) => ref
// // //                             .read(roomQuantityProvider.notifier)
// // //                             .setQuantity(room.id, val),
// // //                       ),
// // //                       const SizedBox(width: 10),
// // //                       ClipRRect(
// // //                         borderRadius: BorderRadius.circular(6),
// // //                         child: Image.network(
// // //                           room.roomImage,
// // //                           width: 55,
// // //                           height: 45,
// // //                           fit: BoxFit.cover,
// // //                           errorBuilder: (_, __, ___) => Container(
// // //                             width: 55,
// // //                             height: 45,
// // //                             color: Colors.grey[200],
// // //                             child: const Icon(Icons.bed,
// // //                                 color: Colors.grey, size: 24),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       const SizedBox(width: 10),
// // //                       Expanded(
// // //                         child: Column(
// // //                           crossAxisAlignment: CrossAxisAlignment.start,
// // //                           children: [
// // //                             Text(room.roomName,
// // //                                 style: const TextStyle(
// // //                                     fontSize: 13,
// // //                                     fontWeight: FontWeight.bold,
// // //                                     color: Colors.black87)),
// // //                             if (room.shortDescription.isNotEmpty)
// // //                               Text(room.shortDescription,
// // //                                   style: const TextStyle(
// // //                                       fontSize: 11, color: Colors.black54),
// // //                                   maxLines: 2,
// // //                                   overflow: TextOverflow.ellipsis),
// // //                           ],
// // //                         ),
// // //                       ),
// // //                       SizedBox(
// // //                         width: 56,
// // //                         child: Text('\$${room.price}',
// // //                             style: const TextStyle(
// // //                                 fontSize: 13, color: Colors.black87),
// // //                             textAlign: TextAlign.center),
// // //                       ),
// // //                       SizedBox(
// // //                         width: 44,
// // //                         child: Text('\$${room.fee}',
// // //                             style: const TextStyle(
// // //                                 fontSize: 13, color: Colors.black87),
// // //                             textAlign: TextAlign.center),
// // //                       ),
// // //                       SizedBox(
// // //                         width: 48,
// // //                         child: Text(
// // //                           '\$${amount == 0 ? '0' : amount.toStringAsFixed(0)}',
// // //                           style: const TextStyle(
// // //                               fontSize: 13,
// // //                               fontWeight: FontWeight.bold,
// // //                               color: Colors.black87),
// // //                           textAlign: TextAlign.right,
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 if (!isLast)
// // //                   const Divider(height: 1, indent: 12, endIndent: 12),
// // //               ],
// // //             );
// // //           }),
// // //           const SizedBox(height: 8),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _RoomTableHeader extends StatelessWidget {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Padding(
// // //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// // //       child: Row(
// // //         children: const [
// // //           SizedBox(width: 60, child: _HeaderLabel('QTY')),
// // //           SizedBox(width: 10),
// // //           Expanded(child: _HeaderLabel('ROOM / PACKAGE')),
// // //           SizedBox(width: 56, child: _HeaderLabel('PRICE', center: true)),
// // //           SizedBox(width: 44, child: _HeaderLabel('FEE', center: true)),
// // //           SizedBox(width: 48, child: _HeaderLabel('AMOUNT', right: true)),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _HeaderLabel extends StatelessWidget {
// // //   final String text;
// // //   final bool center;
// // //   final bool right;

// // //   const _HeaderLabel(this.text, {this.center = false, this.right = false});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Text(
// // //       text,
// // //       style: const TextStyle(
// // //           fontSize: 11,
// // //           fontWeight: FontWeight.bold,
// // //           color: Colors.black54,
// // //           letterSpacing: 0.5),
// // //       textAlign:
// // //           right ? TextAlign.right : center ? TextAlign.center : TextAlign.left,
// // //     );
// // //   }
// // // }

// // // class _QuantityDropdown extends StatelessWidget {
// // //   final int value;
// // //   final int max;
// // //   final ValueChanged<int> onChanged;

// // //   const _QuantityDropdown(
// // //       {required this.value, required this.max, required this.onChanged});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       width: 52,
// // //       height: 34,
// // //       decoration: BoxDecoration(
// // //           border: Border.all(color: const Color(0xFFCCCCCC)),
// // //           borderRadius: BorderRadius.circular(6),
// // //           color: Colors.white),
// // //       padding: const EdgeInsets.symmetric(horizontal: 4),
// // //       child: DropdownButtonHideUnderline(
// // //         child: DropdownButton<int>(
// // //           value: value,
// // //           isExpanded: true,
// // //           icon: const Icon(Icons.keyboard_arrow_down, size: 16),
// // //           style: const TextStyle(fontSize: 13, color: Colors.black87),
// // //           onChanged: (val) {
// // //             if (val != null) onChanged(val);
// // //           },
// // //           items: List.generate(max + 1, (i) => i)
// // //               .map((i) => DropdownMenuItem(value: i, child: Text('$i')))
// // //               .toList(),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // // ═════════════════════════════════════════════════════════════════════════════
// // // // SECTION 9 — ADDITIONAL NIGHT SECTION
// // // // ═════════════════════════════════════════════════════════════════════════════

// // // class _AdditionalNightSection extends ConsumerWidget {
// // //   final List<AdditionalNight> nights;
// // //   final String pricePerNight;
// // //   final String feePerNight;

// // //   const _AdditionalNightSection(
// // //       {required this.nights,
// // //       required this.pricePerNight,
// // //       required this.feePerNight});

// // //   String _formatDate(String dateStr) {
// // //     try {
// // //       final parts = dateStr.split('-');
// // //       final months = [
// // //         '', 'January', 'February', 'March', 'April', 'May', 'June',
// // //         'July', 'August', 'September', 'October', 'November', 'December'
// // //       ];
// // //       final year = parts[0];
// // //       final month = int.tryParse(parts[1]) ?? 0;
// // //       final day = int.tryParse(parts[2]) ?? 0;
// // //       final monthName = month < months.length ? months[month] : parts[1];
// // //       return '$monthName $day, $year';
// // //     } catch (_) {
// // //       return dateStr;
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context, WidgetRef ref) {
// // //     final quantities = ref.watch(nightQuantityProvider);

// // //     return Container(
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         borderRadius: BorderRadius.circular(12),
// // //         boxShadow: [
// // //           BoxShadow(
// // //               color: Colors.black.withOpacity(0.06),
// // //               blurRadius: 8,
// // //               offset: const Offset(0, 2))
// // //         ],
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           const Padding(
// // //             padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
// // //             child: Text('Select Additional Room Night Options',
// // //                 style: TextStyle(
// // //                     fontSize: 16,
// // //                     fontWeight: FontWeight.bold,
// // //                     color: Colors.black87)),
// // //           ),
// // //           const Padding(
// // //             padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
// // //             child: Text(
// // //               'Quantity will remain the same as added to the event.',
// // //               style: TextStyle(
// // //                   fontSize: 12,
// // //                   color: Color(0xFFD81B60),
// // //                   fontStyle: FontStyle.italic),
// // //             ),
// // //           ),
// // //           // Table Header
// // //           Padding(
// // //             padding:
// // //                 const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// // //             child: Row(
// // //               children: const [
// // //                 SizedBox(width: 70, child: _HeaderLabel('QTY')),
// // //                 Expanded(child: _HeaderLabel('ADDITIONAL NIGHT')),
// // //                 SizedBox(width: 56, child: _HeaderLabel('PRICE', center: true)),
// // //                 SizedBox(width: 44, child: _HeaderLabel('FEE', center: true)),
// // //                 SizedBox(width: 52, child: _HeaderLabel('AMOUNT', right: true)),
// // //               ],
// // //             ),
// // //           ),
// // //           const Divider(height: 1),
// // //           ...nights.asMap().entries.map((entry) {
// // //             final night = entry.value;
// // //             final isLast = entry.key == nights.length - 1;
// // //             final qty = quantities[night.date] ?? 0;
// // //             final price = double.tryParse(pricePerNight) ?? 0;
// // //             final amount = qty * price;
// // //             return Column(
// // //               children: [
// // //                 Padding(
// // //                   padding: const EdgeInsets.symmetric(
// // //                       horizontal: 12, vertical: 10),
// // //                   child: Row(
// // //                     crossAxisAlignment: CrossAxisAlignment.center,
// // //                     children: [
// // //                       _NightQtyDropdown(
// // //                         value: qty,
// // //                         onChanged: (val) => ref
// // //                             .read(nightQuantityProvider.notifier)
// // //                             .setQuantity(night.date, val),
// // //                       ),
// // //                       const SizedBox(width: 12),
// // //                       Expanded(
// // //                         child: RichText(
// // //                           text: TextSpan(
// // //                             children: [
// // //                               TextSpan(
// // //                                 text: '${night.day}, ',
// // //                                 style: const TextStyle(
// // //                                     fontSize: 13,
// // //                                     fontWeight: FontWeight.bold,
// // //                                     color: Colors.black87),
// // //                               ),
// // //                               TextSpan(
// // //                                 text: _formatDate(night.date),
// // //                                 style: const TextStyle(
// // //                                     fontSize: 13, color: Colors.black87),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       SizedBox(
// // //                         width: 56,
// // //                         child: Text('\$$pricePerNight',
// // //                             style: const TextStyle(
// // //                                 fontSize: 13, color: Colors.black87),
// // //                             textAlign: TextAlign.center),
// // //                       ),
// // //                       SizedBox(
// // //                         width: 44,
// // //                         child: Text('\$$feePerNight',
// // //                             style: const TextStyle(
// // //                                 fontSize: 13, color: Colors.black87),
// // //                             textAlign: TextAlign.center),
// // //                       ),
// // //                       SizedBox(
// // //                         width: 52,
// // //                         child: Text(
// // //                           '\$${amount == 0 ? '0' : amount.toStringAsFixed(0)}',
// // //                           style: const TextStyle(
// // //                               fontSize: 13,
// // //                               fontWeight: FontWeight.bold,
// // //                               color: Colors.black87),
// // //                           textAlign: TextAlign.right,
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 if (!isLast)
// // //                   const Divider(height: 1, indent: 12, endIndent: 12),
// // //               ],
// // //             );
// // //           }),
// // //           const SizedBox(height: 8),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _NightQtyDropdown extends StatelessWidget {
// // //   final int value;
// // //   final ValueChanged<int> onChanged;

// // //   const _NightQtyDropdown({required this.value, required this.onChanged});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       width: 52,
// // //       height: 34,
// // //       decoration: BoxDecoration(
// // //           border: Border.all(color: const Color(0xFFCCCCCC)),
// // //           borderRadius: BorderRadius.circular(6),
// // //           color: Colors.white),
// // //       padding: const EdgeInsets.symmetric(horizontal: 4),
// // //       child: DropdownButtonHideUnderline(
// // //         child: DropdownButton<int>(
// // //           value: value,
// // //           isExpanded: true,
// // //           icon: const Icon(Icons.keyboard_arrow_down, size: 16),
// // //           style: const TextStyle(fontSize: 13, color: Colors.black87),
// // //           onChanged: (val) {
// // //             if (val != null) onChanged(val);
// // //           },
// // //           items: List.generate(11, (i) => i)
// // //               .map((i) => DropdownMenuItem(value: i, child: Text('$i')))
// // //               .toList(),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // // ═════════════════════════════════════════════════════════════════════════════
// // // // SECTION 10 — ORDER SUMMARY SECTION
// // // // ═════════════════════════════════════════════════════════════════════════════

// // // class _OrderSummarySection extends ConsumerStatefulWidget {
// // //   final List<RoomData> rooms;
// // //   final List<AdditionalNight> nights;
// // //   final String pricePerNight;
// // //   final String feePerNight;

// // //   const _OrderSummarySection({
// // //     required this.rooms,
// // //     required this.nights,
// // //     required this.pricePerNight,
// // //     required this.feePerNight,
// // //   });

// // //   @override
// // //   ConsumerState<_OrderSummarySection> createState() =>
// // //       _OrderSummarySectionState();
// // // }

// // // class _OrderSummarySectionState extends ConsumerState<_OrderSummarySection> {
// // //   final _voucherCtrl = TextEditingController();

// // //   @override
// // //   void dispose() {
// // //     _voucherCtrl.dispose();
// // //     super.dispose();
// // //   }

// // //   double _calcSubTotal() {
// // //     final roomQtys = ref.read(roomQuantityProvider);
// // //     final nightQtys = ref.read(nightQuantityProvider);
// // //     double total = 0;
// // //     for (final room in widget.rooms) {
// // //       final qty = roomQtys[room.id] ?? 0;
// // //       total += qty * (double.tryParse(room.price) ?? 0);
// // //     }
// // //     for (final night in widget.nights) {
// // //       final qty = nightQtys[night.date] ?? 0;
// // //       total += qty * (double.tryParse(widget.pricePerNight) ?? 0);
// // //     }
// // //     return total;
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     ref.watch(roomQuantityProvider);
// // //     ref.watch(nightQuantityProvider);

// // //     final paymentType = ref.watch(paymentTypeProvider);
// // //     final membershipDiscount = ref.watch(membershipDiscountProvider);
// // //     final voucherDiscount = ref.watch(voucherDiscountProvider);
// // //     final subTotal = _calcSubTotal();
// // //     final total = (subTotal - membershipDiscount - voucherDiscount)
// // //         .clamp(0.0, double.infinity);

// // //     return Column(
// // //       children: [
// // //         // ── Payment Type ──────────────────────────────────────────────────
// // //         Container(
// // //           decoration: BoxDecoration(
// // //             color: Colors.white,
// // //             borderRadius: BorderRadius.circular(12),
// // //             boxShadow: [
// // //               BoxShadow(
// // //                   color: Colors.black.withOpacity(0.06),
// // //                   blurRadius: 8,
// // //                   offset: const Offset(0, 2))
// // //             ],
// // //           ),
// // //           padding: const EdgeInsets.all(16),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               const Text('Select Payment Type',
// // //                   style: TextStyle(
// // //                       fontSize: 15,
// // //                       fontWeight: FontWeight.bold,
// // //                       color: Colors.black87)),
// // //               const SizedBox(height: 12),
// // //               Row(
// // //                 children: [
// // //                   _PaymentOption(
// // //                     label: 'Full Payment',
// // //                     value: PaymentType.full,
// // //                     groupValue: paymentType,
// // //                     onChanged: (val) =>
// // //                         ref.read(paymentTypeProvider.notifier).state = val,
// // //                   ),
// // //                   const SizedBox(width: 24),
// // //                   _PaymentOption(
// // //                     label: 'Partial Payment',
// // //                     value: PaymentType.partial,
// // //                     groupValue: paymentType,
// // //                     onChanged: (val) =>
// // //                         ref.read(paymentTypeProvider.notifier).state = val,
// // //                   ),
// // //                 ],
// // //               ),
// // //             ],
// // //           ),
// // //         ),

// // //         const SizedBox(height: 16),

// // //         // ── Order Summary ─────────────────────────────────────────────────
// // //         Container(
// // //           decoration: BoxDecoration(
// // //             color: Colors.white,
// // //             borderRadius: BorderRadius.circular(12),
// // //             border: Border.all(color: const Color(0xFF4FC3F7), width: 1.2),
// // //             boxShadow: [
// // //               BoxShadow(
// // //                   color: Colors.black.withOpacity(0.06),
// // //                   blurRadius: 8,
// // //                   offset: const Offset(0, 2))
// // //             ],
// // //           ),
// // //           padding: const EdgeInsets.all(16),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               const Text('Order Summary',
// // //                   style: TextStyle(
// // //                       fontSize: 16,
// // //                       fontWeight: FontWeight.bold,
// // //                       color: Colors.black87)),
// // //               const SizedBox(height: 14),

// // //               // Voucher Input
// // //               Row(
// // //                 children: [
// // //                   Expanded(
// // //                     child: TextField(
// // //                       controller: _voucherCtrl,
// // //                       onChanged: (val) =>
// // //                           ref.read(voucherCodeProvider.notifier).state = val,
// // //                       style: const TextStyle(fontSize: 13),
// // //                       decoration: InputDecoration(
// // //                         hintText: 'Enter voucher code',
// // //                         hintStyle: const TextStyle(
// // //                             fontSize: 13, color: Colors.black38),
// // //                         contentPadding: const EdgeInsets.symmetric(
// // //                             horizontal: 12, vertical: 10),
// // //                         border: OutlineInputBorder(
// // //                             borderRadius: BorderRadius.circular(6),
// // //                             borderSide:
// // //                                 const BorderSide(color: Color(0xFFCCCCCC))),
// // //                         enabledBorder: OutlineInputBorder(
// // //                             borderRadius: BorderRadius.circular(6),
// // //                             borderSide:
// // //                                 const BorderSide(color: Color(0xFFCCCCCC))),
// // //                         focusedBorder: OutlineInputBorder(
// // //                             borderRadius: BorderRadius.circular(6),
// // //                             borderSide: const BorderSide(
// // //                                 color: Color(0xFF8B0045), width: 1.5)),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   const SizedBox(width: 10),
// // //                   ElevatedButton(
// // //                     onPressed: () {
// // //                       // TODO: call voucher validation API
// // //                       ScaffoldMessenger.of(context).showSnackBar(
// // //                         const SnackBar(
// // //                             content: Text('Voucher applied!'),
// // //                             backgroundColor: Color(0xFF8B0045)),
// // //                       );
// // //                     },
// // //                     style: ElevatedButton.styleFrom(
// // //                       backgroundColor: const Color(0xFF1A0A2E),
// // //                       shape: RoundedRectangleBorder(
// // //                           borderRadius: BorderRadius.circular(6)),
// // //                       padding: const EdgeInsets.symmetric(
// // //                           horizontal: 18, vertical: 14),
// // //                     ),
// // //                     child: const Text('Apply',
// // //                         style:
// // //                             TextStyle(color: Colors.white, fontSize: 13)),
// // //                   ),
// // //                 ],
// // //               ),

// // //               const SizedBox(height: 16),
// // //               const Divider(height: 1),
// // //               const SizedBox(height: 12),

// // //               // Sub Total
// // //               Row(
// // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                 children: [
// // //                   const Text('Sub Total',
// // //                       style:
// // //                           TextStyle(fontSize: 14, color: Colors.black87)),
// // //                   Text(
// // //                     '\$${subTotal == 0 ? '0' : subTotal.toStringAsFixed(0)}',
// // //                     style: TextStyle(
// // //                         fontSize: 14,
// // //                         color: subTotal == 0
// // //                             ? const Color(0xFF4FC3F7)
// // //                             : Colors.black87),
// // //                   ),
// // //                 ],
// // //               ),
// // //               const SizedBox(height: 8),

// // //               // Membership Discount
// // //               Row(
// // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                 children: [
// // //                   const Text('Membership Discount',
// // //                       style: TextStyle(
// // //                           fontSize: 14, color: Color(0xFFD81B60))),
// // //                   Text('-\$${membershipDiscount.toStringAsFixed(0)}',
// // //                       style: const TextStyle(
// // //                           fontSize: 14, color: Color(0xFFD81B60))),
// // //                 ],
// // //               ),
// // //               const SizedBox(height: 8),

// // //               // Voucher Discount
// // //               Row(
// // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                 children: [
// // //                   const Text('Voucher Discount',
// // //                       style: TextStyle(
// // //                           fontSize: 14, color: Color(0xFF2E7D32))),
// // //                   Text('-\$${voucherDiscount.toStringAsFixed(0)}',
// // //                       style: const TextStyle(
// // //                           fontSize: 14, color: Color(0xFF2E7D32))),
// // //                 ],
// // //               ),

// // //               const SizedBox(height: 12),
// // //               const Divider(height: 1),
// // //               const SizedBox(height: 12),

// // //               // Total
// // //               Row(
// // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                 children: [
// // //                   const Text('Total',
// // //                       style: TextStyle(
// // //                           fontSize: 18,
// // //                           fontWeight: FontWeight.bold,
// // //                           color: Colors.black87)),
// // //                   Text('\$${total.toStringAsFixed(0)}',
// // //                       style: const TextStyle(
// // //                           fontSize: 18,
// // //                           fontWeight: FontWeight.bold,
// // //                           color: Colors.black87)),
// // //                 ],
// // //               ),

// // //               const SizedBox(height: 18),

// // //               // Buy Ticket Button
// // //               SizedBox(
// // //                 width: double.infinity,
// // //                 child: ElevatedButton(
// // //                   onPressed: () {
// // //                     // TODO: call buy ticket API
// // //                     ScaffoldMessenger.of(context).showSnackBar(
// // //                       const SnackBar(
// // //                           content: Text('Processing your ticket...'),
// // //                           backgroundColor: Color(0xFF8B0045)),
// // //                     );
// // //                   },
// // //                   style: ElevatedButton.styleFrom(
// // //                     backgroundColor: const Color(0xFF1A0A2E),
// // //                     shape: RoundedRectangleBorder(
// // //                         borderRadius: BorderRadius.circular(8)),
// // //                     padding: const EdgeInsets.symmetric(vertical: 16),
// // //                   ),
// // //                   child: const Text(
// // //                     'BUY TICKET',
// // //                     style: TextStyle(
// // //                         color: Colors.white,
// // //                         fontSize: 15,
// // //                         fontWeight: FontWeight.bold,
// // //                         letterSpacing: 1),
// // //                   ),
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // // }

// // // class _PaymentOption extends StatelessWidget {
// // //   final String label;
// // //   final PaymentType value;
// // //   final PaymentType? groupValue;
// // //   final ValueChanged<PaymentType?> onChanged;

// // //   const _PaymentOption({
// // //     required this.label,
// // //     required this.value,
// // //     required this.groupValue,
// // //     required this.onChanged,
// // //   });

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Row(
// // //       children: [
// // //         Radio<PaymentType>(
// // //           value: value,
// // //           groupValue: groupValue,
// // //           activeColor: const Color(0xFF8B0045),
// // //           onChanged: onChanged,
// // //         ),
// // //         Text(label,
// // //             style: const TextStyle(fontSize: 14, color: Colors.black87)),
// // //       ],
// // //     );
// // //   }
// // // }

// // // =============================================================================
// // //  event_detail_page.dart
// // //  Beat Flirt — Complete single-file with AuthService token integration.
// // //
// // //  ✅ Uses your REAL AuthService.getToken() directly — no duplicate code.
// // //  ✅ You only need to pass eventId when navigating. That's it!
// // //
// // //  HOW TO NAVIGATE HERE (from any screen):
// // //  ─────────────────────────────────────────
// // //  Navigator.push(
// // //    context,
// // //    MaterialPageRoute(
// // //      builder: (_) => EventDetailScreen(eventId: event.id),
// // //    ),
// // //  );
// // //
// // //  Dependencies (pubspec.yaml):
// // //    flutter_riverpod: ^2.5.1
// // //    http: ^1.2.1
// // //    shared_preferences: ^2.2.2
// // // =============================================================================

// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';

// // // ignore_for_file: avoid_print

// // // ═════════════════════════════════════════════════════════════════════════════
// // // SECTION 1 — TOKEN HELPER
// // // ═════════════════════════════════════════════════════════════════════════════
// // // We read directly from SharedPreferences using the SAME keys your real
// // // AuthService uses. This avoids any import issues with circular dependencies.
// // //
// // // Your AuthService saves token like this (we verified from your code):
// // //   static const String _tokenKey = "auth_token";
// // //   prefs.setString(_tokenKey, token);  ← in AuthService.login()
// // //
// // // So we read it back with the exact same key below.
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _TokenHelper {
// //   /// ⚠️ MUST match AuthService._tokenKey in auth_services.dart
// //   /// Your file shows: static const String _tokenKey = "auth_token";
// //   static const String _key = 'auth_token';

// //   static Future<String?> get() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final token = prefs.getString(_key);
// //     debugPrint('[TokenHelper] SharedPrefs key="$_key" found=${token != null} len=${token?.length ?? 0}');

// //     // ── Debug: print ALL keys so you can verify the exact key name ────────────
// //     // Remove this block once working:
// //     if (token == null) {
// //       final allKeys = prefs.getKeys();
// //       debugPrint('[TokenHelper] ⚠️ Token not found. All SharedPrefs keys: $allKeys');
// //       for (final k in allKeys) {
// //         if (k.toLowerCase().contains('token') || k.toLowerCase().contains('auth')) {
// //           debugPrint('[TokenHelper]   🔑 $k = "${prefs.get(k)}"');
// //         }
// //       }
// //     }
// //     return token;
// //   }
// // }

// // // ═════════════════════════════════════════════════════════════════════════════
// // // SECTION 2 — MODELS
// // // ═════════════════════════════════════════════════════════════════════════════

// // class EventDetailResponse {
// //   final String status;
// //   final EventData data;
// //   final List<AdditionalNight> additionalNights;
// //   final RoomListResponse roomList;

// //   EventDetailResponse({
// //     required this.status,
// //     required this.data,
// //     required this.additionalNights,
// //     required this.roomList,
// //   });

// //   factory EventDetailResponse.fromJson(Map<String, dynamic> json) {
// //     return EventDetailResponse(
// //       status: json['status'] ?? '',
// //       data: EventData.fromJson(json['data'] ?? {}),
// //       additionalNights: (json['additional_night'] as List<dynamic>? ?? [])
// //           .map((e) => AdditionalNight.fromJson(e))
// //           .toList(),
// //       roomList: RoomListResponse.fromJson(json['room_list'] ?? {}),
// //     );
// //   }
// // }

// // class EventData {
// //   final String id;
// //   final String eventName;
// //   final String eventFromDate;
// //   final String eventToDate;
// //   final String eventFromTime;
// //   final String eventToTime;
// //   final String eventType;
// //   final String additionalRoomNightPrice;
// //   final String additionalRoomNightFee;
// //   final String formattedAddress;
// //   final String eventImage;
// //   final String eventPrice;
// //   final String eventNoOfTicket;
// //   final String eventEmail;
// //   final String eventDescription;
// //   final String status;
// //   final String lat;
// //   final String lng;
// //   final String cityName;

// //   EventData({
// //     required this.id,
// //     required this.eventName,
// //     required this.eventFromDate,
// //     required this.eventToDate,
// //     required this.eventFromTime,
// //     required this.eventToTime,
// //     required this.eventType,
// //     required this.additionalRoomNightPrice,
// //     required this.additionalRoomNightFee,
// //     required this.formattedAddress,
// //     required this.eventImage,
// //     required this.eventPrice,
// //     required this.eventNoOfTicket,
// //     required this.eventEmail,
// //     required this.eventDescription,
// //     required this.status,
// //     required this.lat,
// //     required this.lng,
// //     required this.cityName,
// //   });

// //   factory EventData.fromJson(Map<String, dynamic> json) {
// //     return EventData(
// //       id: json['id'] ?? '',
// //       eventName: json['event_name'] ?? '',
// //       eventFromDate: json['event_from_date'] ?? '',
// //       eventToDate: json['event_to_date'] ?? '',
// //       eventFromTime: json['event_from_time'] ?? '',
// //       eventToTime: json['event_to_time'] ?? '',
// //       eventType: json['event_type'] ?? '',
// //       additionalRoomNightPrice: json['additional_room_night_price'] ?? '0',
// //       additionalRoomNightFee: json['additional_room_night_fee'] ?? '0',
// //       formattedAddress: json['formatted_address'] ?? '',
// //       eventImage: json['event_image'] ?? '',
// //       eventPrice: json['event_price'] ?? '0',
// //       eventNoOfTicket: json['event_no_of_ticket'] ?? '0',
// //       eventEmail: json['event_email'] ?? '',
// //       eventDescription: json['event_description'] ?? '',
// //       status: json['status']?.toString() ?? '',
// //       lat: json['lat'] ?? '',
// //       lng: json['lng'] ?? '',
// //       cityName: json['city_name'] ?? '',
// //     );
// //   }
// // }

// // class AdditionalNight {
// //   final String date;
// //   final String day;

// //   AdditionalNight({required this.date, required this.day});

// //   factory AdditionalNight.fromJson(Map<String, dynamic> json) {
// //     return AdditionalNight(
// //       date: json['date'] ?? '',
// //       day: json['day'] ?? '',
// //     );
// //   }
// // }

// // class RoomListResponse {
// //   final String status;
// //   final List<RoomData> data;

// //   RoomListResponse({required this.status, required this.data});

// //   factory RoomListResponse.fromJson(Map<String, dynamic> json) {
// //     return RoomListResponse(
// //       status: json['status']?.toString() ?? '',
// //       data: (json['data'] as List<dynamic>? ?? [])
// //           .map((e) => RoomData.fromJson(e))
// //           .toList(),
// //     );
// //   }
// // }

// // class RoomData {
// //   final String id;
// //   final String roomName;
// //   final String price;
// //   final String fee;
// //   final String fullDescription;
// //   final String shortDescription;
// //   final String roomAvailable;
// //   final String roomImage;

// //   RoomData({
// //     required this.id,
// //     required this.roomName,
// //     required this.price,
// //     required this.fee,
// //     required this.fullDescription,
// //     required this.shortDescription,
// //     required this.roomAvailable,
// //     required this.roomImage,
// //   });

// //   factory RoomData.fromJson(Map<String, dynamic> json) {
// //     return RoomData(
// //       id: json['id'] ?? '',
// //       roomName: json['room_name'] ?? '',
// //       price: json['price'] ?? '0',
// //       fee: json['fee'] ?? '0',
// //       fullDescription: json['full_description'] ?? '',
// //       shortDescription: json['short_description'] ?? '',
// //       roomAvailable: json['room_available'] ?? '0',
// //       roomImage: json['room_image'] ?? '',
// //     );
// //   }
// // }

// // // ── Guest Models ──────────────────────────────────────────────────────────────

// // enum GuestType { single, couple }

// // class SingleGuest {
// //   final String id;
// //   String username;
// //   String fullName;
// //   String email;
// //   String phone;
// //   String? idProofPath;

// //   SingleGuest({
// //     required this.id,
// //     this.username = '',
// //     this.fullName = '',
// //     this.email = '',
// //     this.phone = '',
// //     this.idProofPath,
// //   });

// //   SingleGuest copyWith({
// //     String? username,
// //     String? fullName,
// //     String? email,
// //     String? phone,
// //     String? idProofPath,
// //   }) {
// //     return SingleGuest(
// //       id: id,
// //       username: username ?? this.username,
// //       fullName: fullName ?? this.fullName,
// //       email: email ?? this.email,
// //       phone: phone ?? this.phone,
// //       idProofPath: idProofPath ?? this.idProofPath,
// //     );
// //   }
// // }

// // class CoupleGuest {
// //   final String id;
// //   String username1;
// //   String fullName1;
// //   String email1;
// //   String phone1;
// //   String? idProofPath1;
// //   String username2;
// //   String fullName2;
// //   String email2;
// //   String phone2;
// //   String? idProofPath2;

// //   CoupleGuest({
// //     required this.id,
// //     this.username1 = '',
// //     this.fullName1 = '',
// //     this.email1 = '',
// //     this.phone1 = '',
// //     this.idProofPath1,
// //     this.username2 = '',
// //     this.fullName2 = '',
// //     this.email2 = '',
// //     this.phone2 = '',
// //     this.idProofPath2,
// //   });

// //   CoupleGuest copyWith({
// //     String? username1,
// //     String? fullName1,
// //     String? email1,
// //     String? phone1,
// //     String? idProofPath1,
// //     String? username2,
// //     String? fullName2,
// //     String? email2,
// //     String? phone2,
// //     String? idProofPath2,
// //   }) {
// //     return CoupleGuest(
// //       id: id,
// //       username1: username1 ?? this.username1,
// //       fullName1: fullName1 ?? this.fullName1,
// //       email1: email1 ?? this.email1,
// //       phone1: phone1 ?? this.phone1,
// //       idProofPath1: idProofPath1 ?? this.idProofPath1,
// //       username2: username2 ?? this.username2,
// //       fullName2: fullName2 ?? this.fullName2,
// //       email2: email2 ?? this.email2,
// //       phone2: phone2 ?? this.phone2,
// //       idProofPath2: idProofPath2 ?? this.idProofPath2,
// //     );
// //   }
// // }

// // // ═════════════════════════════════════════════════════════════════════════════
// // // SECTION 3 — REPOSITORY
// // // ═════════════════════════════════════════════════════════════════════════════

// // class EventRepository {
// //   static const String _baseUrl =
// //       'https://app.beatflirtevent.com/App/events/get_single_events';

// //   /// Builds headers exactly like ApiService._buildHeaders(token: token).
// //   /// The Beat Flirt server reads auth from:
// //   ///   - 'Authorization': 'Bearer $token'
// //   ///   - 'access-token': token   ← this is the one the server actually checks
// //   static Map<String, String> _buildHeaders(String token) {
// //     return {
// //       'Content-Type': 'application/json',
// //       'Accept': 'application/json',
// //       'Authorization': 'Bearer $token',
// //       'access-token': token, // ✅ exact key used by ApiService._buildHeaders
// //     };
// //   }

// //   Future<EventDetailResponse> getSingleEvent({required String eventId}) async {
// //     final token = await _TokenHelper.get();

// //     if (token == null || token.isEmpty) {
// //       throw Exception('Not authenticated. Please log in again.');
// //     }

// //     debugPrint('[EventRepo] →  eventId=$eventId | tokenLen=${token.length}');

// //     // ✅ Same format as getAllEvents() in ApiService:
// //     //    POST with JSON body + auth headers (Authorization + access-token)
// //     final response = await http.post(
// //       Uri.parse(_baseUrl),
// //       headers: _buildHeaders(token),
// //       body: jsonEncode({'event_id': eventId}),
// //     );

// //     debugPrint(
// //         '[EventRepo] ← ${response.statusCode} | ${response.body.length > 250 ? response.body.substring(0, 250) : response.body}');

// //     final jsonBody = jsonDecode(response.body) as Map<String, dynamic>;
// //     final apiStatus = jsonBody['status']?.toString() ?? '';

// //     if (apiStatus == '200') {
// //       return EventDetailResponse.fromJson(jsonBody);
// //     }

// //     // ── Fallback: form-encoded body (same fallback as getAllEvents) ────────────
// //     final msg = (jsonBody['message'] ?? '').toString().toLowerCase();
// //     if (msg.contains('provide') || msg.contains('token') || msg.contains('required')) {
// //       debugPrint('[EventRepo] JSON rejected → retrying as form-encoded');

// //       final r2 = await http.post(
// //         Uri.parse(_baseUrl),
// //         headers: {
// //           'Accept': 'application/json',
// //           'Content-Type': 'application/x-www-form-urlencoded',
// //           'Authorization': 'Bearer $token',
// //           'access-token': token,
// //         },
// //         body: {'event_id': eventId},
// //       );

// //       debugPrint(
// //           '[EventRepo] form-encoded ← ${r2.statusCode} | ${r2.body.length > 250 ? r2.body.substring(0, 250) : r2.body}');

// //       final j2 = jsonDecode(r2.body) as Map<String, dynamic>;
// //       if (j2['status']?.toString() == '200') {
// //         return EventDetailResponse.fromJson(j2);
// //       }
// //       throw Exception(j2['message'] ?? j2['msg'] ?? 'Failed to load event');
// //     }

// //     throw Exception(jsonBody['message'] ?? jsonBody['msg'] ?? 'Failed to load event');
// //   }
// // }

// // // ═════════════════════════════════════════════════════════════════════════════
// // // SECTION 4 — RIVERPOD PROVIDERS
// // // ═════════════════════════════════════════════════════════════════════════════

// // // ── Repository ────────────────────────────────────────────────────────────────
// // final eventRepositoryProvider = Provider<EventRepository>((ref) {
// //   return EventRepository();
// // });

// // // ── Event Detail — only needs eventId now, token is fetched internally ─────────
// // final eventDetailProvider =
// //     FutureProvider.family<EventDetailResponse, String>((ref, eventId) async {
// //   final repo = ref.read(eventRepositoryProvider);
// //   return repo.getSingleEvent(eventId: eventId);
// // });

// // // ── Room Quantity ─────────────────────────────────────────────────────────────
// // class RoomQuantityNotifier extends StateNotifier<Map<String, int>> {
// //   RoomQuantityNotifier() : super({});

// //   void setQuantity(String roomId, int qty) =>
// //       state = {...state, roomId: qty};

// //   int getQuantity(String roomId) => state[roomId] ?? 0;

// //   double totalAmount(List<RoomData> rooms) {
// //     double total = 0;
// //     for (final room in rooms) {
// //       final qty = state[room.id] ?? 0;
// //       if (qty > 0) total += qty * (double.tryParse(room.price) ?? 0);
// //     }
// //     return total;
// //   }
// // }

// // final roomQuantityProvider =
// //     StateNotifierProvider<RoomQuantityNotifier, Map<String, int>>(
// //         (ref) => RoomQuantityNotifier());

// // // ── Night Quantity ────────────────────────────────────────────────────────────
// // class NightQuantityNotifier extends StateNotifier<Map<String, int>> {
// //   NightQuantityNotifier() : super({});

// //   void setQuantity(String date, int qty) =>
// //       state = {...state, date: qty};

// //   int getQuantity(String date) => state[date] ?? 0;

// //   double totalAmount(String pricePerNight) {
// //     final price = double.tryParse(pricePerNight) ?? 0;
// //     final totalQty = state.values.fold(0, (a, b) => a + b);
// //     return totalQty * price;
// //   }
// // }

// // final nightQuantityProvider =
// //     StateNotifierProvider<NightQuantityNotifier, Map<String, int>>(
// //         (ref) => NightQuantityNotifier());

// // // ── Guest List ────────────────────────────────────────────────────────────────
// // class GuestListState {
// //   final List<SingleGuest> singleGuests;
// //   final List<CoupleGuest> coupleGuests;
// //   final bool showValidation;

// //   const GuestListState({
// //     this.singleGuests = const [],
// //     this.coupleGuests = const [],
// //     this.showValidation = false,
// //   });

// //   GuestListState copyWith({
// //     List<SingleGuest>? singleGuests,
// //     List<CoupleGuest>? coupleGuests,
// //     bool? showValidation,
// //   }) {
// //     return GuestListState(
// //       singleGuests: singleGuests ?? this.singleGuests,
// //       coupleGuests: coupleGuests ?? this.coupleGuests,
// //       showValidation: showValidation ?? this.showValidation,
// //     );
// //   }
// // }

// // class GuestListNotifier extends StateNotifier<GuestListState> {
// //   GuestListNotifier() : super(const GuestListState());

// //   int _singleCounter = 0;
// //   int _coupleCounter = 0;

// //   void addSingleGuest() {
// //     _singleCounter++;
// //     state = state.copyWith(singleGuests: [
// //       ...state.singleGuests,
// //       SingleGuest(id: 'single_$_singleCounter')
// //     ]);
// //   }

// //   void removeSingleGuest(String id) => state = state.copyWith(
// //       singleGuests: state.singleGuests.where((g) => g.id != id).toList());

// //   void updateSingleGuest(String id, SingleGuest updated) =>
// //       state = state.copyWith(
// //         singleGuests:
// //             state.singleGuests.map((g) => g.id == id ? updated : g).toList(),
// //       );

// //   void addCoupleGuest() {
// //     _coupleCounter++;
// //     state = state.copyWith(coupleGuests: [
// //       ...state.coupleGuests,
// //       CoupleGuest(id: 'couple_$_coupleCounter')
// //     ]);
// //   }

// //   void removeCoupleGuest(String id) => state = state.copyWith(
// //       coupleGuests: state.coupleGuests.where((g) => g.id != id).toList());

// //   void updateCoupleGuest(String id, CoupleGuest updated) =>
// //       state = state.copyWith(
// //         coupleGuests:
// //             state.coupleGuests.map((g) => g.id == id ? updated : g).toList(),
// //       );

// //   void setShowValidation(bool val) =>
// //       state = state.copyWith(showValidation: val);

// //   bool validate() {
// //     state = state.copyWith(showValidation: true);
// //     for (final g in state.singleGuests) {
// //       if (g.username.trim().isEmpty ||
// //           g.fullName.trim().isEmpty ||
// //           g.email.trim().isEmpty ||
// //           g.phone.trim().isEmpty) return false;
// //     }
// //     for (final g in state.coupleGuests) {
// //       if (g.username1.trim().isEmpty ||
// //           g.fullName1.trim().isEmpty ||
// //           g.email1.trim().isEmpty ||
// //           g.phone1.trim().isEmpty ||
// //           g.fullName2.trim().isEmpty ||
// //           g.email2.trim().isEmpty ||
// //           g.phone2.trim().isEmpty) return false;
// //     }
// //     return true;
// //   }
// // }

// // final guestListProvider =
// //     StateNotifierProvider<GuestListNotifier, GuestListState>(
// //         (ref) => GuestListNotifier());

// // // ── Payment / Voucher / UI State ──────────────────────────────────────────────
// // enum PaymentType { full, partial }

// // final paymentTypeProvider = StateProvider<PaymentType?>((ref) => null);
// // final voucherCodeProvider = StateProvider<String>((ref) => '');
// // final voucherDiscountProvider = StateProvider<double>((ref) => 0.0);
// // final membershipDiscountProvider = StateProvider<double>((ref) => 0.0);
// // final descriptionExpandedProvider = StateProvider<bool>((ref) => false);

// // // ═════════════════════════════════════════════════════════════════════════════
// // // SECTION 5 — SCREEN
// // // ═════════════════════════════════════════════════════════════════════════════

// // /// ✅ Only pass [eventId]. Token is read automatically from SharedPreferences.
// // ///
// // /// Navigate like this (from anywhere):
// // /// ```dart
// // /// Navigator.push(context, MaterialPageRoute(
// // ///   builder: (_) => EventDetailScreen(eventId: event.id),
// // /// ));
// // /// ```
// // class EventDetailScreen extends ConsumerWidget {
// //   final String eventId;

// //   const EventDetailScreen({
// //     super.key,
// //     required this.eventId,
// //   });

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final asyncEvent = ref.watch(eventDetailProvider(eventId));

// //     return Scaffold(
// //       backgroundColor: const Color(0xFFFFF0F5),
// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         elevation: 0.5,
// //         leading: const SizedBox.shrink(),
// //         title: const Text(
// //           'Parties And Events',
// //           style: TextStyle(
// //               color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
// //         ),
// //         actions: [
// //           Padding(
// //             padding: const EdgeInsets.only(right: 12),
// //             child: ElevatedButton.icon(
// //               onPressed: () => Navigator.of(context).pop(),
// //               icon: const Icon(Icons.arrow_back, size: 16, color: Colors.white),
// //               label: const Text('Back',
// //                   style: TextStyle(color: Colors.white, fontSize: 13)),
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: const Color(0xFF8B0045),
// //                 shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(20)),
// //                 padding:
// //                     const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //       body: asyncEvent.when(
// //         loading: () => const Center(
// //             child: CircularProgressIndicator(color: Color(0xFF8B0045))),
// //         error: (err, _) => _buildError(context, ref, err),
// //         data: (eventResponse) => _buildContent(eventResponse),
// //       ),
// //     );
// //   }

// //   Widget _buildError(BuildContext context, WidgetRef ref, Object err) {
// //     final isAuthError = err.toString().contains('authenticated') ||
// //         err.toString().contains('log in');
// //     return Center(
// //       child: Padding(
// //         padding: const EdgeInsets.all(24),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(
// //               isAuthError ? Icons.lock_outline : Icons.error_outline,
// //               size: 60,
// //               color: const Color(0xFF8B0045),
// //             ),
// //             const SizedBox(height: 16),
// //             Text(
// //               isAuthError ? 'Session Expired' : 'Failed to load event',
// //               style: const TextStyle(
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.black87),
// //             ),
// //             const SizedBox(height: 8),
// //             Text(
// //               isAuthError
// //                   ? 'Your session has expired. Please log in again.'
// //                   : err.toString(),
// //               textAlign: TextAlign.center,
// //               style: const TextStyle(color: Colors.grey, fontSize: 13),
// //             ),
// //             const SizedBox(height: 20),
// //             ElevatedButton.icon(
// //               style: ElevatedButton.styleFrom(
// //                   backgroundColor: const Color(0xFF8B0045)),
// //               onPressed: () => ref.refresh(eventDetailProvider(eventId)),
// //               icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
// //               label: const Text('Retry',
// //                   style: TextStyle(color: Colors.white)),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildContent(EventDetailResponse eventResponse) {
// //     return SingleChildScrollView(
// //       padding: const EdgeInsets.all(16),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           _EventHeaderCard(event: eventResponse.data),
// //           const SizedBox(height: 16),
// //           const _GuestSection(),
// //           const SizedBox(height: 16),
// //           if (eventResponse.roomList.data.isNotEmpty) ...[
// //             _RoomPackageSection(rooms: eventResponse.roomList.data),
// //             const SizedBox(height: 16),
// //           ],
// //           if (eventResponse.additionalNights.isNotEmpty) ...[
// //             _AdditionalNightSection(
// //               nights: eventResponse.additionalNights,
// //               pricePerNight: eventResponse.data.additionalRoomNightPrice,
// //               feePerNight: eventResponse.data.additionalRoomNightFee,
// //             ),
// //             const SizedBox(height: 16),
// //           ],
// //           _OrderSummarySection(
// //             rooms: eventResponse.roomList.data,
// //             nights: eventResponse.additionalNights,
// //             pricePerNight: eventResponse.data.additionalRoomNightPrice,
// //             feePerNight: eventResponse.data.additionalRoomNightFee,
// //           ),
// //           const SizedBox(height: 30),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ═════════════════════════════════════════════════════════════════════════════
// // // SECTION 6 — EVENT HEADER CARD
// // // ═════════════════════════════════════════════════════════════════════════════

// // class _EventHeaderCard extends ConsumerWidget {
// //   final EventData event;
// //   const _EventHeaderCard({required this.event});

// //   String _formatDate(String date, String time) {
// //     try {
// //       final parts = date.split('-');
// //       if (parts.length < 3) return '$date $time';
// //       final months = [
// //         '', 'January', 'February', 'March', 'April', 'May', 'June',
// //         'July', 'August', 'September', 'October', 'November', 'December'
// //       ];
// //       final year = parts[0];
// //       final month = int.tryParse(parts[1]) ?? 0;
// //       final day = int.tryParse(parts[2]) ?? 0;
// //       final monthName = month < months.length ? months[month] : parts[1];
// //       final timeParts = time.split(':');
// //       int hour = int.tryParse(timeParts[0]) ?? 0;
// //       final min = timeParts.length > 1 ? timeParts[1] : '00';
// //       final period = hour >= 12 ? 'pm' : 'am';
// //       hour = hour % 12;
// //       if (hour == 0) hour = 12;
// //       final dt = DateTime.tryParse(date);
// //       final days = [
// //         '', 'Monday', 'Tuesday', 'Wednesday', 'Thursday',
// //         'Friday', 'Saturday', 'Sunday'
// //       ];
// //       final dayName = dt != null ? days[dt.weekday] : '';
// //       return '$dayName, $monthName $day, $year  $hour:$min $period';
// //     } catch (_) {
// //       return '$date $time';
// //     }
// //   }

// //   String _stripHtml(String html) {
// //     return html
// //         .replaceAll('&amp;lt;', '<')
// //         .replaceAll('&amp;gt;', '>')
// //         .replaceAll('&amp;amp;', '&')
// //         .replaceAll('&amp;nbsp;', ' ')
// //         .replaceAll('&lt;', '<')
// //         .replaceAll('&gt;', '>')
// //         .replaceAll('&amp;', '&')
// //         .replaceAll('&nbsp;', ' ')
// //         .replaceAll('\r\n', ' ')
// //         .replaceAll(RegExp(r'<[^>]*>'), '')
// //         .trim();
// //   }

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final isExpanded = ref.watch(descriptionExpandedProvider);
// //     final cleanDescription = _stripHtml(event.eventDescription);
// //     const maxChars = 80;
// //     final isLong = cleanDescription.length > maxChars;
// //     final displayText = (!isExpanded && isLong)
// //         ? '${cleanDescription.substring(0, maxChars)}...'
// //         : cleanDescription;

// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         boxShadow: [
// //           BoxShadow(
// //               color: Colors.black.withOpacity(0.06),
// //               blurRadius: 8,
// //               offset: const Offset(0, 2))
// //         ],
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Row(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 // Event Image
// //                 ClipRRect(
// //                   borderRadius: BorderRadius.circular(10),
// //                   child: Image.network(
// //                     event.eventImage,
// //                     width: 140,
// //                     height: 160,
// //                     fit: BoxFit.cover,
// //                     errorBuilder: (_, __, ___) => Container(
// //                       width: 140,
// //                       height: 160,
// //                       color: Colors.grey[200],
// //                       child: const Icon(Icons.image_not_supported,
// //                           color: Colors.grey, size: 40),
// //                     ),
// //                     loadingBuilder: (_, child, progress) {
// //                       if (progress == null) return child;
// //                       return Container(
// //                         width: 140,
// //                         height: 160,
// //                         color: Colors.grey[100],
// //                         child: const Center(
// //                             child: CircularProgressIndicator(
// //                                 strokeWidth: 2,
// //                                 color: Color(0xFF8B0045))),
// //                       );
// //                     },
// //                   ),
// //                 ),
// //                 const SizedBox(width: 14),
// //                 // Details
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(event.eventName,
// //                           style: const TextStyle(
// //                               fontSize: 18,
// //                               fontWeight: FontWeight.bold,
// //                               color: Colors.black87)),
// //                       const SizedBox(height: 8),
// //                       Text(
// //                         '${_formatDate(event.eventFromDate, event.eventFromTime)}  –  ${_formatDate(event.eventToDate, event.eventToTime)}',
// //                         style: const TextStyle(
// //                             fontSize: 12, color: Colors.black54),
// //                       ),
// //                       const SizedBox(height: 8),
// //                       if (event.formattedAddress.isNotEmpty)
// //                         Row(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             const Icon(Icons.location_on,
// //                                 size: 15, color: Color(0xFF8B0045)),
// //                             const SizedBox(width: 4),
// //                             Expanded(
// //                               child: Text(event.formattedAddress,
// //                                   style: const TextStyle(
// //                                       fontSize: 12, color: Colors.black87)),
// //                             ),
// //                           ],
// //                         ),
// //                       const SizedBox(height: 8),
// //                       if (event.eventEmail.isNotEmpty)
// //                         Text('contacted by:- ${event.eventEmail}',
// //                             style: const TextStyle(
// //                                 fontSize: 12, color: Colors.black54)),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 14),
// //             const Text('Description',
// //                 style: TextStyle(
// //                     fontSize: 14,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.black87)),
// //             const SizedBox(height: 6),
// //             Text(displayText,
// //                 style: const TextStyle(
// //                     fontSize: 13, color: Color(0xFFD81B60))),
// //             if (isLong) ...[
// //               const SizedBox(height: 4),
// //               GestureDetector(
// //                 onTap: () => ref
// //                     .read(descriptionExpandedProvider.notifier)
// //                     .state = !isExpanded,
// //                 child: Text(
// //                   isExpanded ? 'Show Less' : 'Show More...',
// //                   style: const TextStyle(
// //                       fontSize: 13,
// //                       color: Colors.black87,
// //                       fontWeight: FontWeight.w500),
// //                 ),
// //               ),
// //             ],
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ═════════════════════════════════════════════════════════════════════════════
// // // SECTION 7 — GUEST SECTION
// // // ═════════════════════════════════════════════════════════════════════════════

// // class _GuestSection extends ConsumerWidget {
// //   const _GuestSection();

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final guestState = ref.watch(guestListProvider);

// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         boxShadow: [
// //           BoxShadow(
// //               color: Colors.black.withOpacity(0.06),
// //               blurRadius: 8,
// //               offset: const Offset(0, 2))
// //         ],
// //       ),
// //       padding: const EdgeInsets.all(14),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // Auto-fill checkbox
// //           Row(
// //             children: [
// //               Checkbox(
// //                   value: false,
// //                   activeColor: const Color(0xFF8B0045),
// //                   onChanged: (_) {}),
// //               const Flexible(
// //                 child: Text('Click here to generate your information',
// //                     style: TextStyle(fontSize: 13, color: Colors.black87)),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 8),

// //           // Add Guest label + buttons — wraps on small screens
// //           Wrap(
// //             spacing: 10,
// //             runSpacing: 8,
// //             crossAxisAlignment: WrapCrossAlignment.center,
// //             children: [
// //               const Text('Add Guest:',
// //                   style: TextStyle(
// //                       fontSize: 14,
// //                       fontWeight: FontWeight.bold,
// //                       color: Color(0xFFD81B60))),
// //               _GuestTypeButton(
// //                 icon: Icons.person,
// //                 label: 'Single',
// //                 onTap: () =>
// //                     ref.read(guestListProvider.notifier).addSingleGuest(),
// //               ),
// //               _GuestTypeButton(
// //                 icon: Icons.people,
// //                 label: 'Couple',
// //                 onTap: () =>
// //                     ref.read(guestListProvider.notifier).addCoupleGuest(),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 14),

// //           // Single guest cards
// //           ...guestState.singleGuests.asMap().entries.map(
// //                 (entry) => Padding(
// //                   padding: const EdgeInsets.only(bottom: 12),
// //                   child: _SingleGuestCard(
// //                     guest: entry.value,
// //                     index: entry.key + 1,
// //                     showValidation: guestState.showValidation,
// //                   ),
// //                 ),
// //               ),

// //           // Couple guest cards
// //           ...guestState.coupleGuests.asMap().entries.map(
// //                 (entry) => Padding(
// //                   padding: const EdgeInsets.only(bottom: 12),
// //                   child: _CoupleGuestCard(
// //                     guest: entry.value,
// //                     index: entry.key + 1,
// //                     showValidation: guestState.showValidation,
// //                   ),
// //                 ),
// //               ),

// //           // Add Guests to List button
// //           if (guestState.singleGuests.isNotEmpty ||
// //               guestState.coupleGuests.isNotEmpty) ...[
// //             const SizedBox(height: 8),
// //             SizedBox(
// //               width: double.infinity,
// //               child: ElevatedButton(
// //                 onPressed: () {
// //                   final isValid =
// //                       ref.read(guestListProvider.notifier).validate();
// //                   if (isValid) {
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       const SnackBar(
// //                         content: Text('Guests added to list!'),
// //                         backgroundColor: Color(0xFF8B0045),
// //                       ),
// //                     );
// //                   }
// //                 },
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: const Color(0xFF1A0A2E),
// //                   shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(8)),
// //                   padding: const EdgeInsets.symmetric(vertical: 14),
// //                 ),
// //                 child: const Text('Add Guests to the List',
// //                     style: TextStyle(color: Colors.white, fontSize: 14)),
// //               ),
// //             ),
// //           ],
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ── Guest Type Button ─────────────────────────────────────────────────────────
// // class _GuestTypeButton extends StatelessWidget {
// //   final IconData icon;
// //   final String label;
// //   final VoidCallback onTap;

// //   const _GuestTypeButton(
// //       {required this.icon, required this.label, required this.onTap});

// //   @override
// //   Widget build(BuildContext context) {
// //     return ElevatedButton.icon(
// //       onPressed: onTap,
// //       icon: Icon(icon, size: 16, color: Colors.white),
// //       label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
// //       style: ElevatedButton.styleFrom(
// //         backgroundColor: const Color(0xFF1A0A2E),
// //         shape:
// //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
// //         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
// //       ),
// //     );
// //   }
// // }

// // // ── Single Guest Card ─────────────────────────────────────────────────────────
// // class _SingleGuestCard extends ConsumerStatefulWidget {
// //   final SingleGuest guest;
// //   final int index;
// //   final bool showValidation;

// //   const _SingleGuestCard(
// //       {required this.guest,
// //       required this.index,
// //       required this.showValidation});

// //   @override
// //   ConsumerState<_SingleGuestCard> createState() => _SingleGuestCardState();
// // }

// // class _SingleGuestCardState extends ConsumerState<_SingleGuestCard> {
// //   late final TextEditingController _usernameCtrl;
// //   late final TextEditingController _fullNameCtrl;
// //   late final TextEditingController _emailCtrl;
// //   late final TextEditingController _phoneCtrl;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _usernameCtrl = TextEditingController(text: widget.guest.username);
// //     _fullNameCtrl = TextEditingController(text: widget.guest.fullName);
// //     _emailCtrl = TextEditingController(text: widget.guest.email);
// //     _phoneCtrl = TextEditingController(text: widget.guest.phone);
// //   }

// //   @override
// //   void dispose() {
// //     _usernameCtrl.dispose();
// //     _fullNameCtrl.dispose();
// //     _emailCtrl.dispose();
// //     _phoneCtrl.dispose();
// //     super.dispose();
// //   }

// //   void _update() {
// //     ref.read(guestListProvider.notifier).updateSingleGuest(
// //           widget.guest.id,
// //           widget.guest.copyWith(
// //             username: _usernameCtrl.text,
// //             fullName: _fullNameCtrl.text,
// //             email: _emailCtrl.text,
// //             phone: _phoneCtrl.text,
// //           ),
// //         );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final sv = widget.showValidation;
// //     return Container(
// //       decoration: BoxDecoration(
// //         border: Border.all(color: const Color(0xFF4FC3F7), width: 1.2),
// //         borderRadius: BorderRadius.circular(10),
// //       ),
// //       padding: const EdgeInsets.all(12),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // Header row
// //           Row(
// //             children: [
// //               Expanded(
// //                 child: Text('Add New Single Guest #${widget.index}',
// //                     style: const TextStyle(
// //                         fontWeight: FontWeight.bold,
// //                         fontSize: 13,
// //                         color: Colors.black87)),
// //               ),
// //               _DeleteButton(
// //                   onTap: () => ref
// //                       .read(guestListProvider.notifier)
// //                       .removeSingleGuest(widget.guest.id)),
// //             ],
// //           ),
// //           const SizedBox(height: 12),
// //           // Username + Full Name — stacked on small screens
// //           _GuestField(
// //             label: 'Username',
// //             hint: 'Enter Username',
// //             controller: _usernameCtrl,
// //             onChanged: (_) => _update(),
// //             showError: sv && _usernameCtrl.text.trim().isEmpty,
// //           ),
// //           const SizedBox(height: 10),
// //           _GuestField(
// //             label: 'Full Name',
// //             hint: 'Enter Full Name',
// //             controller: _fullNameCtrl,
// //             onChanged: (_) => _update(),
// //             showError: sv && _fullNameCtrl.text.trim().isEmpty,
// //             showInfoIcon: true,
// //           ),
// //           const SizedBox(height: 10),
// //           // Email + Phone side by side
// //           Row(
// //             children: [
// //               Expanded(
// //                 child: _GuestField(
// //                   label: 'Email',
// //                   hint: 'Email',
// //                   controller: _emailCtrl,
// //                   onChanged: (_) => _update(),
// //                   showError: sv && _emailCtrl.text.trim().isEmpty,
// //                   keyboardType: TextInputType.emailAddress,
// //                 ),
// //               ),
// //               const SizedBox(width: 8),
// //               Expanded(
// //                 child: _GuestField(
// //                   label: 'Phone',
// //                   hint: 'Phone Number',
// //                   controller: _phoneCtrl,
// //                   onChanged: (_) => _update(),
// //                   showError: sv && _phoneCtrl.text.trim().isEmpty,
// //                   keyboardType: TextInputType.phone,
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 10),
// //           // ID Proof full width
// //           _IdProofPicker(
// //             showError: sv && widget.guest.idProofPath == null,
// //             filePath: widget.guest.idProofPath,
// //             onPicked: (path) {
// //               ref.read(guestListProvider.notifier).updateSingleGuest(
// //                     widget.guest.id,
// //                     widget.guest.copyWith(idProofPath: path),
// //                   );
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ── Couple Guest Card ─────────────────────────────────────────────────────────
// // class _CoupleGuestCard extends ConsumerStatefulWidget {
// //   final CoupleGuest guest;
// //   final int index;
// //   final bool showValidation;

// //   const _CoupleGuestCard(
// //       {required this.guest,
// //       required this.index,
// //       required this.showValidation});

// //   @override
// //   ConsumerState<_CoupleGuestCard> createState() => _CoupleGuestCardState();
// // }

// // class _CoupleGuestCardState extends ConsumerState<_CoupleGuestCard> {
// //   late final TextEditingController _u1, _fn1, _e1, _p1;
// //   late final TextEditingController _u2, _fn2, _e2, _p2;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _u1 = TextEditingController(text: widget.guest.username1);
// //     _fn1 = TextEditingController(text: widget.guest.fullName1);
// //     _e1 = TextEditingController(text: widget.guest.email1);
// //     _p1 = TextEditingController(text: widget.guest.phone1);
// //     _u2 = TextEditingController(text: widget.guest.username2);
// //     _fn2 = TextEditingController(text: widget.guest.fullName2);
// //     _e2 = TextEditingController(text: widget.guest.email2);
// //     _p2 = TextEditingController(text: widget.guest.phone2);
// //   }

// //   @override
// //   void dispose() {
// //     _u1.dispose(); _fn1.dispose(); _e1.dispose(); _p1.dispose();
// //     _u2.dispose(); _fn2.dispose(); _e2.dispose(); _p2.dispose();
// //     super.dispose();
// //   }

// //   void _update() {
// //     ref.read(guestListProvider.notifier).updateCoupleGuest(
// //           widget.guest.id,
// //           widget.guest.copyWith(
// //             username1: _u1.text, fullName1: _fn1.text,
// //             email1: _e1.text, phone1: _p1.text,
// //             username2: _u2.text, fullName2: _fn2.text,
// //             email2: _e2.text, phone2: _p2.text,
// //           ),
// //         );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final sv = widget.showValidation;
// //     return Container(
// //       decoration: BoxDecoration(
// //         border: Border.all(color: const Color(0xFF4FC3F7), width: 1.2),
// //         borderRadius: BorderRadius.circular(10),
// //       ),
// //       padding: const EdgeInsets.all(12),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               Expanded(
// //                 child: Text('Add New Couple Guest #${widget.index}',
// //                     style: const TextStyle(
// //                         fontWeight: FontWeight.bold,
// //                         fontSize: 13,
// //                         color: Color(0xFF4FC3F7))),
// //               ),
// //               _DeleteButton(
// //                   onTap: () => ref
// //                       .read(guestListProvider.notifier)
// //                       .removeCoupleGuest(widget.guest.id)),
// //             ],
// //           ),
// //           const SizedBox(height: 12),

// //           // ── Member 1 ──────────────────────────────────────────────────
// //           const _SectionLabel(label: 'MEMBER 1'),
// //           const SizedBox(height: 8),
// //           _GuestField(label: 'Username', hint: 'Enter Username',
// //               controller: _u1, onChanged: (_) => _update(),
// //               showError: sv && _u1.text.trim().isEmpty),
// //           const SizedBox(height: 8),
// //           _GuestField(label: 'Full Name', hint: 'Enter Full Name',
// //               controller: _fn1, onChanged: (_) => _update(),
// //               showError: sv && _fn1.text.trim().isEmpty, showInfoIcon: true),
// //           const SizedBox(height: 8),
// //           Row(children: [
// //             Expanded(child: _GuestField(label: 'Email', hint: 'E-mail',
// //                 controller: _e1, onChanged: (_) => _update(),
// //                 showError: sv && _e1.text.trim().isEmpty,
// //                 keyboardType: TextInputType.emailAddress)),
// //             const SizedBox(width: 8),
// //             Expanded(child: _GuestField(label: 'Phone', hint: 'Phone No.',
// //                 controller: _p1, onChanged: (_) => _update(),
// //                 showError: sv && _p1.text.trim().isEmpty,
// //                 keyboardType: TextInputType.phone)),
// //           ]),
// //           const SizedBox(height: 8),
// //           _IdProofPicker(
// //             label: 'Id Proof (Member 1)',
// //             showError: sv && widget.guest.idProofPath1 == null,
// //             filePath: widget.guest.idProofPath1,
// //             onPicked: (path) => ref.read(guestListProvider.notifier)
// //                 .updateCoupleGuest(widget.guest.id,
// //                     widget.guest.copyWith(idProofPath1: path)),
// //           ),

// //           const SizedBox(height: 14),
// //           const Divider(color: Color(0xFFEEEEEE)),
// //           const SizedBox(height: 10),

// //           // ── Member 2 ──────────────────────────────────────────────────
// //           const _SectionLabel(label: 'MEMBER 2'),
// //           const SizedBox(height: 8),
// //           _GuestField(label: 'Username', hint: 'Username',
// //               controller: _u2, onChanged: (_) => _update(), showError: false),
// //           const SizedBox(height: 8),
// //           _GuestField(label: 'Full Name', hint: 'Enter Full Name',
// //               controller: _fn2, onChanged: (_) => _update(),
// //               showError: sv && _fn2.text.trim().isEmpty, showInfoIcon: true),
// //           const SizedBox(height: 8),
// //           Row(children: [
// //             Expanded(child: _GuestField(label: 'Email', hint: 'E-mail',
// //                 controller: _e2, onChanged: (_) => _update(),
// //                 showError: sv && _e2.text.trim().isEmpty,
// //                 keyboardType: TextInputType.emailAddress)),
// //             const SizedBox(width: 8),
// //             Expanded(child: _GuestField(label: 'Phone', hint: 'Phone No.',
// //                 controller: _p2, onChanged: (_) => _update(),
// //                 showError: sv && _p2.text.trim().isEmpty,
// //                 keyboardType: TextInputType.phone)),
// //           ]),
// //           const SizedBox(height: 8),
// //           _IdProofPicker(
// //             label: 'Id Proof (Member 2)',
// //             showError: sv && widget.guest.idProofPath2 == null,
// //             filePath: widget.guest.idProofPath2,
// //             onPicked: (path) => ref.read(guestListProvider.notifier)
// //                 .updateCoupleGuest(widget.guest.id,
// //                     widget.guest.copyWith(idProofPath2: path)),
// //           ),
// //           const SizedBox(height: 12),
// //           Align(
// //             alignment: Alignment.centerRight,
// //             child: ElevatedButton(
// //               onPressed: () => ref
// //                   .read(guestListProvider.notifier)
// //                   .removeCoupleGuest(widget.guest.id),
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: const Color(0xFFD32F2F),
// //                 shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(8)),
// //                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //               ),
// //               child: const Text('Remove',
// //                   style: TextStyle(color: Colors.white, fontSize: 13)),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ── Shared small widgets ──────────────────────────────────────────────────────

// // class _SectionLabel extends StatelessWidget {
// //   final String label;
// //   const _SectionLabel({required this.label});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Text(label,
// //         style: const TextStyle(
// //             fontSize: 11,
// //             fontWeight: FontWeight.w700,
// //             color: Colors.black45,
// //             letterSpacing: 0.8));
// //   }
// // }

// // class _GuestField extends StatelessWidget {
// //   final String label;
// //   final String hint;
// //   final TextEditingController controller;
// //   final ValueChanged<String> onChanged;
// //   final bool showError;
// //   final bool showInfoIcon;
// //   final TextInputType keyboardType;

// //   const _GuestField({
// //     required this.label,
// //     required this.hint,
// //     required this.controller,
// //     required this.onChanged,
// //     required this.showError,
// //     this.showInfoIcon = false,
// //     this.keyboardType = TextInputType.text,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Row(
// //           children: [
// //             Flexible(
// //               child: Text(label,
// //                   style: const TextStyle(
// //                       fontSize: 12,
// //                       fontWeight: FontWeight.w600,
// //                       color: Colors.black87)),
// //             ),
// //             if (showInfoIcon) ...[
// //               const SizedBox(width: 4),
// //               const Icon(Icons.info_outline, size: 13, color: Colors.black54),
// //             ],
// //           ],
// //         ),
// //         const SizedBox(height: 4),
// //         TextField(
// //           controller: controller,
// //           onChanged: onChanged,
// //           keyboardType: keyboardType,
// //           style: const TextStyle(fontSize: 13),
// //           decoration: InputDecoration(
// //             hintText: hint,
// //             hintStyle: const TextStyle(fontSize: 12, color: Colors.black38),
// //             contentPadding:
// //                 const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
// //             border: OutlineInputBorder(
// //                 borderRadius: BorderRadius.circular(6),
// //                 borderSide: const BorderSide(color: Color(0xFFCCCCCC))),
// //             enabledBorder: OutlineInputBorder(
// //                 borderRadius: BorderRadius.circular(6),
// //                 borderSide: const BorderSide(color: Color(0xFFCCCCCC))),
// //             focusedBorder: OutlineInputBorder(
// //                 borderRadius: BorderRadius.circular(6),
// //                 borderSide: const BorderSide(color: Color(0xFF8B0045), width: 1.5)),
// //           ),
// //         ),
// //         if (showError) ...[
// //           const SizedBox(height: 3),
// //           const Text('This Field is required',
// //               style: TextStyle(fontSize: 10, color: Color(0xFFD32F2F))),
// //         ],
// //       ],
// //     );
// //   }
// // }

// // class _IdProofPicker extends StatelessWidget {
// //   final String? filePath;
// //   final bool showError;
// //   final ValueChanged<String> onPicked;
// //   final String label;

// //   const _IdProofPicker({
// //     required this.showError,
// //     required this.onPicked,
// //     this.filePath,
// //     this.label = 'Id Proof',
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Row(
// //           children: [
// //             Flexible(
// //               child: Text(label,
// //                   style: const TextStyle(
// //                       fontSize: 12,
// //                       fontWeight: FontWeight.w600,
// //                       color: Colors.black87)),
// //             ),
// //             const SizedBox(width: 4),
// //             const Icon(Icons.info_outline, size: 13, color: Colors.black54),
// //           ],
// //         ),
// //         const SizedBox(height: 4),
// //         GestureDetector(
// //           onTap: () => onPicked('selected_file.jpg'),
// //           child: Container(
// //             width: double.infinity,
// //             decoration: BoxDecoration(
// //                 border: Border.all(color: const Color(0xFFCCCCCC)),
// //                 borderRadius: BorderRadius.circular(6)),
// //             child: Row(
// //               children: [
// //                 Container(
// //                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
// //                   decoration: const BoxDecoration(
// //                       border: Border(right: BorderSide(color: Color(0xFFCCCCCC)))),
// //                   child: const Text('Choose file',
// //                       style: TextStyle(fontSize: 12, color: Colors.black87)),
// //                 ),
// //                 Expanded(
// //                   child: Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 8),
// //                     child: Text(
// //                       filePath != null ? filePath!.split('/').last : 'No file chosen',
// //                       style: const TextStyle(fontSize: 11, color: Colors.black45),
// //                       overflow: TextOverflow.ellipsis,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //         if (showError) ...[
// //           const SizedBox(height: 3),
// //           const Text('This Field is required',
// //               style: TextStyle(fontSize: 10, color: Color(0xFFD32F2F))),
// //         ],
// //       ],
// //     );
// //   }
// // }

// // class _DeleteButton extends StatelessWidget {
// //   final VoidCallback onTap;
// //   const _DeleteButton({required this.onTap});

// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         width: 34,
// //         height: 34,
// //         decoration: BoxDecoration(
// //             color: const Color(0xFFD32F2F),
// //             borderRadius: BorderRadius.circular(6)),
// //         child: const Icon(Icons.delete_outline, color: Colors.white, size: 18),
// //       ),
// //     );
// //   }
// // }

// // // ═════════════════════════════════════════════════════════════════════════════
// // // SECTION 8 — ROOM PACKAGE SECTION  (mobile-first, no overflow)
// // // ═════════════════════════════════════════════════════════════════════════════

// // class _RoomPackageSection extends ConsumerWidget {
// //   final List<RoomData> rooms;
// //   const _RoomPackageSection({required this.rooms});

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final quantities = ref.watch(roomQuantityProvider);

// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         boxShadow: [
// //           BoxShadow(
// //               color: Colors.black.withOpacity(0.06),
// //               blurRadius: 8,
// //               offset: const Offset(0, 2))
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Padding(
// //             padding: EdgeInsets.fromLTRB(14, 14, 14, 10),
// //             child: Text(
// //               'Choose Your Beat Flirt Package',
// //               style: TextStyle(
// //                   fontSize: 15,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.black87),
// //             ),
// //           ),

// //           // ── Table header ─────────────────────────────────────────────
// //           Container(
// //             color: const Color(0xFFF5F5F5),
// //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
// //             child: LayoutBuilder(builder: (ctx, c) {
// //               return Row(children: [
// //                 const SizedBox(width: 54, child: _Hlabel('QTY')),
// //                 const Expanded(child: _Hlabel('ROOM / PACKAGE')),
// //                 const SizedBox(width: 52, child: _Hlabel('PRICE', center: true)),
// //                 const SizedBox(width: 36, child: _Hlabel('FEE', center: true)),
// //                 const SizedBox(width: 38, child: _Hlabel('AMT', right: true)),
// //               ]);
// //             }),
// //           ),
// //           const Divider(height: 1),

// //           // ── Room rows ─────────────────────────────────────────────────
// //           ...rooms.asMap().entries.map((entry) {
// //             final room = entry.value;
// //             final isLast = entry.key == rooms.length - 1;
// //             final qty = quantities[room.id] ?? 0;
// //             final amount = qty * (double.tryParse(room.price) ?? 0);

// //             return Column(children: [
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
// //                 child: Row(
// //                   crossAxisAlignment: CrossAxisAlignment.center,
// //                   children: [
// //                     // QTY
// //                     SizedBox(
// //                       width: 54,
// //                       child: _QtyDropdown(
// //                         value: qty,
// //                         max: int.tryParse(room.roomAvailable) ?? 10,
// //                         onChanged: (val) => ref
// //                             .read(roomQuantityProvider.notifier)
// //                             .setQuantity(room.id, val),
// //                       ),
// //                     ),

// //                     // Room info — image top, name below (inside Expanded)
// //                     Expanded(
// //                       child: Row(
// //                         crossAxisAlignment: CrossAxisAlignment.center,
// //                         children: [
// //                           // Thumbnail
// //                           ClipRRect(
// //                             borderRadius: BorderRadius.circular(5),
// //                             child: Image.network(
// //                               room.roomImage,
// //                               width: 42,
// //                               height: 36,
// //                               fit: BoxFit.cover,
// //                               errorBuilder: (_, __, ___) => Container(
// //                                 width: 42,
// //                                 height: 36,
// //                                 color: Colors.grey[200],
// //                                 child: const Icon(Icons.bed,
// //                                     color: Colors.grey, size: 18),
// //                               ),
// //                             ),
// //                           ),
// //                           const SizedBox(width: 6),
// //                           // Name + description
// //                           Expanded(
// //                             child: Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 Text(
// //                                   room.roomName,
// //                                   style: const TextStyle(
// //                                       fontSize: 12,
// //                                       fontWeight: FontWeight.bold,
// //                                       color: Colors.black87),
// //                                   softWrap: true,
// //                                 ),
// //                                 if (room.shortDescription.isNotEmpty)
// //                                   Text(
// //                                     room.shortDescription,
// //                                     style: const TextStyle(
// //                                         fontSize: 10, color: Colors.black54),
// //                                     maxLines: 2,
// //                                     overflow: TextOverflow.ellipsis,
// //                                   ),
// //                               ],
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),

// //                     // Price
// //                     SizedBox(
// //                       width: 52,
// //                       child: Text(
// //                         '\$${room.price}',
// //                         style: const TextStyle(fontSize: 12, color: Colors.black87),
// //                         textAlign: TextAlign.center,
// //                       ),
// //                     ),
// //                     // Fee
// //                     SizedBox(
// //                       width: 36,
// //                       child: Text(
// //                         '\$${room.fee}',
// //                         style: const TextStyle(fontSize: 12, color: Colors.black87),
// //                         textAlign: TextAlign.center,
// //                       ),
// //                     ),
// //                     // Amount
// //                     SizedBox(
// //                       width: 38,
// //                       child: Text(
// //                         '\$${amount == 0 ? '0' : amount.toStringAsFixed(0)}',
// //                         style: const TextStyle(
// //                             fontSize: 12,
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.black87),
// //                         textAlign: TextAlign.right,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               if (!isLast) const Divider(height: 1, indent: 10, endIndent: 10),
// //             ]);
// //           }),
// //           const SizedBox(height: 8),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ── Header label widget ────────────────────────────────────────────────────
// // class _Hlabel extends StatelessWidget {
// //   final String text;
// //   final bool center;
// //   final bool right;
// //   const _Hlabel(this.text, {this.center = false, this.right = false});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Text(
// //       text,
// //       style: const TextStyle(
// //           fontSize: 10,
// //           fontWeight: FontWeight.bold,
// //           color: Colors.black54,
// //           letterSpacing: 0.3),
// //       textAlign:
// //           right ? TextAlign.right : center ? TextAlign.center : TextAlign.left,
// //       maxLines: 1,
// //       overflow: TextOverflow.visible,
// //     );
// //   }
// // }

// // // ── Shared quantity dropdown ───────────────────────────────────────────────
// // class _QtyDropdown extends StatelessWidget {
// //   final int value;
// //   final int max;
// //   final ValueChanged<int> onChanged;
// //   const _QtyDropdown(
// //       {required this.value, required this.max, required this.onChanged});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       height: 34,
// //       margin: const EdgeInsets.only(right: 4),
// //       decoration: BoxDecoration(
// //           border: Border.all(color: const Color(0xFFCCCCCC)),
// //           borderRadius: BorderRadius.circular(6),
// //           color: Colors.white),
// //       padding: const EdgeInsets.symmetric(horizontal: 2),
// //       child: DropdownButtonHideUnderline(
// //         child: DropdownButton<int>(
// //           value: value,
// //           isExpanded: true,
// //           icon: const Icon(Icons.keyboard_arrow_down, size: 14),
// //           style: const TextStyle(fontSize: 13, color: Colors.black87),
// //           onChanged: (val) {
// //             if (val != null) onChanged(val);
// //           },
// //           items: List.generate(max + 1, (i) => i)
// //               .map((i) => DropdownMenuItem(value: i, child: Text('$i')))
// //               .toList(),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ═════════════════════════════════════════════════════════════════════════════
// // // SECTION 9 — ADDITIONAL NIGHT SECTION  (mobile-first, no overflow)
// // // ═════════════════════════════════════════════════════════════════════════════

// // class _AdditionalNightSection extends ConsumerWidget {
// //   final List<AdditionalNight> nights;
// //   final String pricePerNight;
// //   final String feePerNight;

// //   const _AdditionalNightSection({
// //     required this.nights,
// //     required this.pricePerNight,
// //     required this.feePerNight,
// //   });

// //   String _fmt(String dateStr) {
// //     try {
// //       final p = dateStr.split('-');
// //       final months = [
// //         '', 'January', 'February', 'March', 'April', 'May', 'June',
// //         'July', 'August', 'September', 'October', 'November', 'December'
// //       ];
// //       final m = int.tryParse(p[1]) ?? 0;
// //       final d = int.tryParse(p[2]) ?? 0;
// //       return '${months[m]} $d, ${p[0]}';
// //     } catch (_) {
// //       return dateStr;
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final quantities = ref.watch(nightQuantityProvider);

// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         boxShadow: [
// //           BoxShadow(
// //               color: Colors.black.withOpacity(0.06),
// //               blurRadius: 8,
// //               offset: const Offset(0, 2))
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Padding(
// //             padding: EdgeInsets.fromLTRB(14, 14, 14, 4),
// //             child: Text(
// //               'Select Additional Room Night Options',
// //               style: TextStyle(
// //                   fontSize: 15,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.black87),
// //             ),
// //           ),
// //           const Padding(
// //             padding: EdgeInsets.fromLTRB(14, 0, 14, 10),
// //             child: Text(
// //               'Quantity will remain the same as added to the event.',
// //               style: TextStyle(
// //                   fontSize: 11,
// //                   color: Color(0xFFD81B60),
// //                   fontStyle: FontStyle.italic),
// //             ),
// //           ),

// //           // ── Table header — short single-line labels ────────────────────
// //           Container(
// //             color: const Color(0xFFF5F5F5),
// //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
// //             child: const Row(children: [
// //               SizedBox(width: 54, child: _Hlabel('QTY')),
// //               Expanded(child: _Hlabel('DATE')),
// //               SizedBox(width: 46, child: _Hlabel('PRICE', center: true)),
// //               SizedBox(width: 36, child: _Hlabel('FEE', center: true)),
// //               SizedBox(width: 38, child: _Hlabel('AMT', right: true)),
// //             ]),
// //           ),
// //           const Divider(height: 1),

// //           // ── Night rows ─────────────────────────────────────────────────
// //           ...nights.asMap().entries.map((entry) {
// //             final night = entry.value;
// //             final isLast = entry.key == nights.length - 1;
// //             final qty = quantities[night.date] ?? 0;
// //             final price = double.tryParse(pricePerNight) ?? 0;
// //             final amount = qty * price;

// //             return Column(children: [
// //               Padding(
// //                 padding:
// //                     const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
// //                 child: Row(
// //                   crossAxisAlignment: CrossAxisAlignment.center,
// //                   children: [
// //                     // QTY dropdown
// //                     SizedBox(
// //                       width: 54,
// //                       child: _QtyDropdown(
// //                         value: qty,
// //                         max: 10,
// //                         onChanged: (val) => ref
// //                             .read(nightQuantityProvider.notifier)
// //                             .setQuantity(night.date, val),
// //                       ),
// //                     ),

// //                     // Day + Date stacked — Expanded takes remaining space
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             night.day,
// //                             style: const TextStyle(
// //                                 fontSize: 12,
// //                                 fontWeight: FontWeight.bold,
// //                                 color: Colors.black87),
// //                           ),
// //                           Text(
// //                             _fmt(night.date),
// //                             style: const TextStyle(
// //                                 fontSize: 11, color: Colors.black54),
// //                           ),
// //                         ],
// //                       ),
// //                     ),

// //                     // Price
// //                     SizedBox(
// //                       width: 46,
// //                       child: Text(
// //                         '\$$pricePerNight',
// //                         style: const TextStyle(
// //                             fontSize: 12, color: Colors.black87),
// //                         textAlign: TextAlign.center,
// //                       ),
// //                     ),
// //                     // Fee
// //                     SizedBox(
// //                       width: 36,
// //                       child: Text(
// //                         '\$$feePerNight',
// //                         style: const TextStyle(
// //                             fontSize: 12, color: Colors.black87),
// //                         textAlign: TextAlign.center,
// //                       ),
// //                     ),
// //                     // Amount
// //                     SizedBox(
// //                       width: 38,
// //                       child: Text(
// //                         '\$${amount == 0 ? '0' : amount.toStringAsFixed(0)}',
// //                         style: const TextStyle(
// //                             fontSize: 12,
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.black87),
// //                         textAlign: TextAlign.right,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               if (!isLast) const Divider(height: 1, indent: 10, endIndent: 10),
// //             ]);
// //           }),
// //           const SizedBox(height: 8),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ═════════════════════════════════════════════════════════════════════════════
// // // SECTION 10 — ORDER SUMMARY SECTION
// // // ═════════════════════════════════════════════════════════════════════════════

// // class _OrderSummarySection extends ConsumerStatefulWidget {
// //   final List<RoomData> rooms;
// //   final List<AdditionalNight> nights;
// //   final String pricePerNight;
// //   final String feePerNight;

// //   const _OrderSummarySection({
// //     required this.rooms,
// //     required this.nights,
// //     required this.pricePerNight,
// //     required this.feePerNight,
// //   });

// //   @override
// //   ConsumerState<_OrderSummarySection> createState() =>
// //       _OrderSummarySectionState();
// // }

// // class _OrderSummarySectionState extends ConsumerState<_OrderSummarySection> {
// //   final _voucherCtrl = TextEditingController();

// //   @override
// //   void dispose() {
// //     _voucherCtrl.dispose();
// //     super.dispose();
// //   }

// //   double _calcSubTotal() {
// //     final roomQtys = ref.read(roomQuantityProvider);
// //     final nightQtys = ref.read(nightQuantityProvider);
// //     double total = 0;
// //     for (final room in widget.rooms) {
// //       final qty = roomQtys[room.id] ?? 0;
// //       total += qty * (double.tryParse(room.price) ?? 0);
// //     }
// //     for (final night in widget.nights) {
// //       final qty = nightQtys[night.date] ?? 0;
// //       total += qty * (double.tryParse(widget.pricePerNight) ?? 0);
// //     }
// //     return total;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     ref.watch(roomQuantityProvider);
// //     ref.watch(nightQuantityProvider);

// //     final paymentType = ref.watch(paymentTypeProvider);
// //     final membershipDiscount = ref.watch(membershipDiscountProvider);
// //     final voucherDiscount = ref.watch(voucherDiscountProvider);
// //     final subTotal = _calcSubTotal();
// //     final total = (subTotal - membershipDiscount - voucherDiscount)
// //         .clamp(0.0, double.infinity);

// //     return Column(
// //       children: [
// //         // ── Payment Type ──────────────────────────────────────────────────
// //         Container(
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(12),
// //             boxShadow: [
// //               BoxShadow(
// //                   color: Colors.black.withOpacity(0.06),
// //                   blurRadius: 8,
// //                   offset: const Offset(0, 2))
// //             ],
// //           ),
// //           padding: const EdgeInsets.all(16),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const Text('Select Payment Type',
// //                   style: TextStyle(
// //                       fontSize: 15,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.black87)),
// //               const SizedBox(height: 12),
// //               // Wrap prevents overflow on small screens
// //               Wrap(
// //                 spacing: 0,
// //                 runSpacing: 4,
// //                 children: [
// //                   _PaymentOption(
// //                     label: 'Full Payment',
// //                     value: PaymentType.full,
// //                     groupValue: paymentType,
// //                     onChanged: (val) =>
// //                         ref.read(paymentTypeProvider.notifier).state = val,
// //                   ),
// //                   _PaymentOption(
// //                     label: 'Partial Payment',
// //                     value: PaymentType.partial,
// //                     groupValue: paymentType,
// //                     onChanged: (val) =>
// //                         ref.read(paymentTypeProvider.notifier).state = val,
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),

// //         const SizedBox(height: 16),

// //         // ── Order Summary ─────────────────────────────────────────────────
// //         Container(
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(12),
// //             border: Border.all(color: const Color(0xFF4FC3F7), width: 1.2),
// //             boxShadow: [
// //               BoxShadow(
// //                   color: Colors.black.withOpacity(0.06),
// //                   blurRadius: 8,
// //                   offset: const Offset(0, 2))
// //             ],
// //           ),
// //           padding: const EdgeInsets.all(16),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const Text('Order Summary',
// //                   style: TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.black87)),
// //               const SizedBox(height: 14),

// //               // Voucher Input
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     child: TextField(
// //                       controller: _voucherCtrl,
// //                       onChanged: (val) =>
// //                           ref.read(voucherCodeProvider.notifier).state = val,
// //                       style: const TextStyle(fontSize: 13),
// //                       decoration: InputDecoration(
// //                         hintText: 'Enter voucher code',
// //                         hintStyle: const TextStyle(
// //                             fontSize: 13, color: Colors.black38),
// //                         contentPadding: const EdgeInsets.symmetric(
// //                             horizontal: 12, vertical: 10),
// //                         border: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(6),
// //                             borderSide:
// //                                 const BorderSide(color: Color(0xFFCCCCCC))),
// //                         enabledBorder: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(6),
// //                             borderSide:
// //                                 const BorderSide(color: Color(0xFFCCCCCC))),
// //                         focusedBorder: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(6),
// //                             borderSide: const BorderSide(
// //                                 color: Color(0xFF8B0045), width: 1.5)),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 10),
// //                   ElevatedButton(
// //                     onPressed: () {
// //                       // TODO: call voucher validation API
// //                       ScaffoldMessenger.of(context).showSnackBar(
// //                         const SnackBar(
// //                             content: Text('Voucher applied!'),
// //                             backgroundColor: Color(0xFF8B0045)),
// //                       );
// //                     },
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: const Color(0xFF1A0A2E),
// //                       shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(6)),
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 18, vertical: 14),
// //                     ),
// //                     child: const Text('Apply',
// //                         style:
// //                             TextStyle(color: Colors.white, fontSize: 13)),
// //                   ),
// //                 ],
// //               ),

// //               const SizedBox(height: 16),
// //               const Divider(height: 1),
// //               const SizedBox(height: 12),

// //               // Sub Total
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   const Text('Sub Total',
// //                       style:
// //                           TextStyle(fontSize: 14, color: Colors.black87)),
// //                   Text(
// //                     '\$${subTotal == 0 ? '0' : subTotal.toStringAsFixed(0)}',
// //                     style: TextStyle(
// //                         fontSize: 14,
// //                         color: subTotal == 0
// //                             ? const Color(0xFF4FC3F7)
// //                             : Colors.black87),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 8),

// //               // Membership Discount
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   const Text('Membership Discount',
// //                       style: TextStyle(
// //                           fontSize: 14, color: Color(0xFFD81B60))),
// //                   Text('-\$${membershipDiscount.toStringAsFixed(0)}',
// //                       style: const TextStyle(
// //                           fontSize: 14, color: Color(0xFFD81B60))),
// //                 ],
// //               ),
// //               const SizedBox(height: 8),

// //               // Voucher Discount
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   const Text('Voucher Discount',
// //                       style: TextStyle(
// //                           fontSize: 14, color: Color(0xFF2E7D32))),
// //                   Text('-\$${voucherDiscount.toStringAsFixed(0)}',
// //                       style: const TextStyle(
// //                           fontSize: 14, color: Color(0xFF2E7D32))),
// //                 ],
// //               ),

// //               const SizedBox(height: 12),
// //               const Divider(height: 1),
// //               const SizedBox(height: 12),

// //               // Total
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   const Text('Total',
// //                       style: TextStyle(
// //                           fontSize: 18,
// //                           fontWeight: FontWeight.bold,
// //                           color: Colors.black87)),
// //                   Text('\$${total.toStringAsFixed(0)}',
// //                       style: const TextStyle(
// //                           fontSize: 18,
// //                           fontWeight: FontWeight.bold,
// //                           color: Colors.black87)),
// //                 ],
// //               ),

// //               const SizedBox(height: 18),

// //               // Buy Ticket Button
// //               SizedBox(
// //                 width: double.infinity,
// //                 child: ElevatedButton(
// //                   onPressed: () {
// //                     // TODO: call buy ticket API
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       const SnackBar(
// //                           content: Text('Processing your ticket...'),
// //                           backgroundColor: Color(0xFF8B0045)),
// //                     );
// //                   },
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: const Color(0xFF1A0A2E),
// //                     shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(8)),
// //                     padding: const EdgeInsets.symmetric(vertical: 16),
// //                   ),
// //                   child: const Text(
// //                     'BUY TICKET',
// //                     style: TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 15,
// //                         fontWeight: FontWeight.bold,
// //                         letterSpacing: 1),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // class _PaymentOption extends StatelessWidget {
// //   final String label;
// //   final PaymentType value;
// //   final PaymentType? groupValue;
// //   final ValueChanged<PaymentType?> onChanged;

// //   const _PaymentOption({
// //     required this.label,
// //     required this.value,
// //     required this.groupValue,
// //     required this.onChanged,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     // IntrinsicWidth so Wrap can measure each item correctly — no overflow
// //     return IntrinsicWidth(
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Radio<PaymentType>(
// //             value: value,
// //             groupValue: groupValue,
// //             activeColor: const Color(0xFF8B0045),
// //             onChanged: onChanged,
// //             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
// //             visualDensity: VisualDensity.compact,
// //           ),
// //           Text(
// //             label,
// //             style: const TextStyle(fontSize: 13, color: Colors.black87),
// //           ),
// //           const SizedBox(width: 8),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // =============================================================================
// //  event_detail_page.dart
// //  Beat Flirt — Complete single-file with AuthService token integration.
// //
// //  ✅ Uses your REAL AuthService.getToken() directly — no duplicate code.
// //  ✅ You only need to pass eventId when navigating. That's it!
// //
// //  HOW TO NAVIGATE HERE (from any screen):
// //  ─────────────────────────────────────────
// //  Navigator.push(
// //    context,
// //    MaterialPageRoute(
// //      builder: (_) => EventDetailScreen(eventId: event.id),
// //    ),
// //  );
// //
// //  Dependencies (pubspec.yaml):
// //    flutter_riverpod: ^2.5.1
// //    http: ^1.2.1
// //    shared_preferences: ^2.2.2
// // =============================================================================

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// // ignore_for_file: avoid_print

// // ═════════════════════════════════════════════════════════════════════════════
// // SECTION 1 — TOKEN HELPER
// // ═════════════════════════════════════════════════════════════════════════════
// // We read directly from SharedPreferences using the SAME keys your real
// // AuthService uses. This avoids any import issues with circular dependencies.
// //
// // Your AuthService saves token like this (we verified from your code):
// //   static const String _tokenKey = "auth_token";
// //   prefs.setString(_tokenKey, token);  ← in AuthService.login()
// //
// // So we read it back with the exact same key below.
// // ─────────────────────────────────────────────────────────────────────────────

// class _TokenHelper {
//   /// ⚠️ MUST match AuthService._tokenKey in auth_services.dart
//   /// Your file shows: static const String _tokenKey = "auth_token";
//   static const String _key = 'auth_token';

//   static Future<String?> get() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString(_key);
//     debugPrint(
//       '[TokenHelper] SharedPrefs key="$_key" found=${token != null} len=${token?.length ?? 0}',
//     );

//     // ── Debug: print ALL keys so you can verify the exact key name ────────────
//     // Remove this block once working:
//     if (token == null) {
//       final allKeys = prefs.getKeys();
//       debugPrint(
//         '[TokenHelper] ⚠️ Token not found. All SharedPrefs keys: $allKeys',
//       );
//       for (final k in allKeys) {
//         if (k.toLowerCase().contains('token') ||
//             k.toLowerCase().contains('auth')) {
//           debugPrint('[TokenHelper]   🔑 $k = "${prefs.get(k)}"');
//         }
//       }
//     }
//     return token;
//   }
// }

// // ═════════════════════════════════════════════════════════════════════════════
// // SECTION 2 — MODELS
// // ═════════════════════════════════════════════════════════════════════════════

// class EventDetailResponse {
//   final String status;
//   final EventData data;
//   final List<AdditionalNight> additionalNights;
//   final RoomListResponse roomList;

//   EventDetailResponse({
//     required this.status,
//     required this.data,
//     required this.additionalNights,
//     required this.roomList,
//   });

//   factory EventDetailResponse.fromJson(Map<String, dynamic> json) {
//     return EventDetailResponse(
//       status: json['status'] ?? '',
//       data: EventData.fromJson(json['data'] ?? {}),
//       additionalNights: (json['additional_night'] as List<dynamic>? ?? [])
//           .map((e) => AdditionalNight.fromJson(e))
//           .toList(),
//       roomList: RoomListResponse.fromJson(json['room_list'] ?? {}),
//     );
//   }
// }

// class EventData {
//   final String id;
//   final String eventName;
//   final String eventFromDate;
//   final String eventToDate;
//   final String eventFromTime;
//   final String eventToTime;
//   final String eventType;
//   final String additionalRoomNightPrice;
//   final String additionalRoomNightFee;
//   final String formattedAddress;
//   final String eventImage;
//   final String eventPrice;
//   final String eventNoOfTicket;
//   final String eventEmail;
//   final String eventDescription;
//   final String status;
//   final String lat;
//   final String lng;
//   final String cityName;

//   EventData({
//     required this.id,
//     required this.eventName,
//     required this.eventFromDate,
//     required this.eventToDate,
//     required this.eventFromTime,
//     required this.eventToTime,
//     required this.eventType,
//     required this.additionalRoomNightPrice,
//     required this.additionalRoomNightFee,
//     required this.formattedAddress,
//     required this.eventImage,
//     required this.eventPrice,
//     required this.eventNoOfTicket,
//     required this.eventEmail,
//     required this.eventDescription,
//     required this.status,
//     required this.lat,
//     required this.lng,
//     required this.cityName,
//   });

//   factory EventData.fromJson(Map<String, dynamic> json) {
//     return EventData(
//       id: json['id'] ?? '',
//       eventName: json['event_name'] ?? '',
//       eventFromDate: json['event_from_date'] ?? '',
//       eventToDate: json['event_to_date'] ?? '',
//       eventFromTime: json['event_from_time'] ?? '',
//       eventToTime: json['event_to_time'] ?? '',
//       eventType: json['event_type'] ?? '',
//       additionalRoomNightPrice: json['additional_room_night_price'] ?? '0',
//       additionalRoomNightFee: json['additional_room_night_fee'] ?? '0',
//       formattedAddress: json['formatted_address'] ?? '',
//       eventImage: json['event_image'] ?? '',
//       eventPrice: json['event_price'] ?? '0',
//       eventNoOfTicket: json['event_no_of_ticket'] ?? '0',
//       eventEmail: json['event_email'] ?? '',
//       eventDescription: json['event_description'] ?? '',
//       status: json['status']?.toString() ?? '',
//       lat: json['lat'] ?? '',
//       lng: json['lng'] ?? '',
//       cityName: json['city_name'] ?? '',
//     );
//   }
// }

// class AdditionalNight {
//   final String date;
//   final String day;

//   AdditionalNight({required this.date, required this.day});

//   factory AdditionalNight.fromJson(Map<String, dynamic> json) {
//     return AdditionalNight(date: json['date'] ?? '', day: json['day'] ?? '');
//   }
// }

// class RoomListResponse {
//   final String status;
//   final List<RoomData> data;

//   RoomListResponse({required this.status, required this.data});

//   factory RoomListResponse.fromJson(Map<String, dynamic> json) {
//     return RoomListResponse(
//       status: json['status']?.toString() ?? '',
//       data: (json['data'] as List<dynamic>? ?? [])
//           .map((e) => RoomData.fromJson(e))
//           .toList(),
//     );
//   }
// }

// class RoomData {
//   final String id;
//   final String roomName;
//   final String price;
//   final String fee;
//   final String fullDescription;
//   final String shortDescription;
//   final String roomAvailable;
//   final String roomImage;

//   RoomData({
//     required this.id,
//     required this.roomName,
//     required this.price,
//     required this.fee,
//     required this.fullDescription,
//     required this.shortDescription,
//     required this.roomAvailable,
//     required this.roomImage,
//   });

//   factory RoomData.fromJson(Map<String, dynamic> json) {
//     return RoomData(
//       id: json['id'] ?? '',
//       roomName: json['room_name'] ?? '',
//       price: json['price'] ?? '0',
//       fee: json['fee'] ?? '0',
//       fullDescription: json['full_description'] ?? '',
//       shortDescription: json['short_description'] ?? '',
//       roomAvailable: json['room_available'] ?? '0',
//       roomImage: json['room_image'] ?? '',
//     );
//   }
// }

// // ── Guest Models ──────────────────────────────────────────────────────────────

// enum GuestType { single, couple }

// class SingleGuest {
//   final String id;
//   String username;
//   String fullName;
//   String email;
//   String phone;
//   String? idProofPath;

//   SingleGuest({
//     required this.id,
//     this.username = '',
//     this.fullName = '',
//     this.email = '',
//     this.phone = '',
//     this.idProofPath,
//   });

//   SingleGuest copyWith({
//     String? username,
//     String? fullName,
//     String? email,
//     String? phone,
//     String? idProofPath,
//   }) {
//     return SingleGuest(
//       id: id,
//       username: username ?? this.username,
//       fullName: fullName ?? this.fullName,
//       email: email ?? this.email,
//       phone: phone ?? this.phone,
//       idProofPath: idProofPath ?? this.idProofPath,
//     );
//   }
// }

// class CoupleGuest {
//   final String id;
//   String username1;
//   String fullName1;
//   String email1;
//   String phone1;
//   String? idProofPath1;
//   String username2;
//   String fullName2;
//   String email2;
//   String phone2;
//   String? idProofPath2;

//   CoupleGuest({
//     required this.id,
//     this.username1 = '',
//     this.fullName1 = '',
//     this.email1 = '',
//     this.phone1 = '',
//     this.idProofPath1,
//     this.username2 = '',
//     this.fullName2 = '',
//     this.email2 = '',
//     this.phone2 = '',
//     this.idProofPath2,
//   });

//   CoupleGuest copyWith({
//     String? username1,
//     String? fullName1,
//     String? email1,
//     String? phone1,
//     String? idProofPath1,
//     String? username2,
//     String? fullName2,
//     String? email2,
//     String? phone2,
//     String? idProofPath2,
//   }) {
//     return CoupleGuest(
//       id: id,
//       username1: username1 ?? this.username1,
//       fullName1: fullName1 ?? this.fullName1,
//       email1: email1 ?? this.email1,
//       phone1: phone1 ?? this.phone1,
//       idProofPath1: idProofPath1 ?? this.idProofPath1,
//       username2: username2 ?? this.username2,
//       fullName2: fullName2 ?? this.fullName2,
//       email2: email2 ?? this.email2,
//       phone2: phone2 ?? this.phone2,
//       idProofPath2: idProofPath2 ?? this.idProofPath2,
//     );
//   }
// }

// // ═════════════════════════════════════════════════════════════════════════════
// // SECTION 3 — REPOSITORY
// // ═════════════════════════════════════════════════════════════════════════════

// class EventRepository {
//   static const String _baseUrl =
//       'https://app.beatflirtevent.com/App/events/get_single_events';

//   /// Builds headers exactly like ApiService._buildHeaders(token: token).
//   /// The Beat Flirt server reads auth from:
//   ///   - 'Authorization': 'Bearer $token'
//   ///   - 'access-token': token   ← this is the one the server actually checks
//   static Map<String, String> _buildHeaders(String token) {
//     return {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//       'access-token': token, // ✅ exact key used by ApiService._buildHeaders
//     };
//   }

//   Future<EventDetailResponse> getSingleEvent({required String eventId}) async {
//     final token = await _TokenHelper.get();

//     if (token == null || token.isEmpty) {
//       throw Exception('Not authenticated. Please log in again.');
//     }

//     debugPrint('[EventRepo] →  eventId=$eventId | tokenLen=${token.length}');

//     // ✅ Same format as getAllEvents() in ApiService:
//     //    POST with JSON body + auth headers (Authorization + access-token)
//     final response = await http.post(
//       Uri.parse(_baseUrl),
//       headers: _buildHeaders(token),
//       body: jsonEncode({'event_id': eventId}),
//     );

//     debugPrint(
//       '[EventRepo] ← ${response.statusCode} | ${response.body.length > 250 ? response.body.substring(0, 250) : response.body}',
//     );

//     final jsonBody = jsonDecode(response.body) as Map<String, dynamic>;
//     final apiStatus = jsonBody['status']?.toString() ?? '';

//     if (apiStatus == '200') {
//       return EventDetailResponse.fromJson(jsonBody);
//     }

//     // ── Fallback: form-encoded body (same fallback as getAllEvents) ────────────
//     final msg = (jsonBody['message'] ?? '').toString().toLowerCase();
//     if (msg.contains('provide') ||
//         msg.contains('token') ||
//         msg.contains('required')) {
//       debugPrint('[EventRepo] JSON rejected → retrying as form-encoded');

//       final r2 = await http.post(
//         Uri.parse(_baseUrl),
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/x-www-form-urlencoded',
//           'Authorization': 'Bearer $token',
//           'access-token': token,
//         },
//         body: {'event_id': eventId},
//       );

//       debugPrint(
//         '[EventRepo] form-encoded ← ${r2.statusCode} | ${r2.body.length > 250 ? r2.body.substring(0, 250) : r2.body}',
//       );

//       final j2 = jsonDecode(r2.body) as Map<String, dynamic>;
//       if (j2['status']?.toString() == '200') {
//         return EventDetailResponse.fromJson(j2);
//       }
//       throw Exception(j2['message'] ?? j2['msg'] ?? 'Failed to load event');
//     }

//     throw Exception(
//       jsonBody['message'] ?? jsonBody['msg'] ?? 'Failed to load event',
//     );
//   }
// }

// // ═════════════════════════════════════════════════════════════════════════════
// // SECTION 4 — RIVERPOD PROVIDERS
// // ═════════════════════════════════════════════════════════════════════════════

// // ── Repository ────────────────────────────────────────────────────────────────
// final eventRepositoryProvider = Provider<EventRepository>((ref) {
//   return EventRepository();
// });

// // ── Event Detail — only needs eventId now, token is fetched internally ─────────
// final eventDetailProvider = FutureProvider.family<EventDetailResponse, String>((
//   ref,
//   eventId,
// ) async {
//   final repo = ref.read(eventRepositoryProvider);
//   return repo.getSingleEvent(eventId: eventId);
// });

// // ── Room Quantity ─────────────────────────────────────────────────────────────
// class RoomQuantityNotifier extends StateNotifier<Map<String, int>> {
//   RoomQuantityNotifier() : super({});

//   void setQuantity(String roomId, int qty) => state = {...state, roomId: qty};

//   int getQuantity(String roomId) => state[roomId] ?? 0;

//   double totalAmount(List<RoomData> rooms) {
//     double total = 0;
//     for (final room in rooms) {
//       final qty = state[room.id] ?? 0;
//       if (qty > 0) total += qty * (double.tryParse(room.price) ?? 0);
//     }
//     return total;
//   }
// }

// final roomQuantityProvider =
//     StateNotifierProvider<RoomQuantityNotifier, Map<String, int>>(
//       (ref) => RoomQuantityNotifier(),
//     );

// // ── Night Quantity ────────────────────────────────────────────────────────────
// class NightQuantityNotifier extends StateNotifier<Map<String, int>> {
//   NightQuantityNotifier() : super({});

//   void setQuantity(String date, int qty) => state = {...state, date: qty};

//   int getQuantity(String date) => state[date] ?? 0;

//   double totalAmount(String pricePerNight) {
//     final price = double.tryParse(pricePerNight) ?? 0;
//     final totalQty = state.values.fold(0, (a, b) => a + b);
//     return totalQty * price;
//   }
// }

// final nightQuantityProvider =
//     StateNotifierProvider<NightQuantityNotifier, Map<String, int>>(
//       (ref) => NightQuantityNotifier(),
//     );

// // ── Guest List ────────────────────────────────────────────────────────────────
// class GuestListState {
//   final List<SingleGuest> singleGuests;
//   final List<CoupleGuest> coupleGuests;
//   final bool showValidation;

//   const GuestListState({
//     this.singleGuests = const [],
//     this.coupleGuests = const [],
//     this.showValidation = false,
//   });

//   GuestListState copyWith({
//     List<SingleGuest>? singleGuests,
//     List<CoupleGuest>? coupleGuests,
//     bool? showValidation,
//   }) {
//     return GuestListState(
//       singleGuests: singleGuests ?? this.singleGuests,
//       coupleGuests: coupleGuests ?? this.coupleGuests,
//       showValidation: showValidation ?? this.showValidation,
//     );
//   }
// }

// class GuestListNotifier extends StateNotifier<GuestListState> {
//   GuestListNotifier() : super(const GuestListState());

//   int _singleCounter = 0;
//   int _coupleCounter = 0;

//   void addSingleGuest() {
//     _singleCounter++;
//     state = state.copyWith(
//       singleGuests: [
//         ...state.singleGuests,
//         SingleGuest(id: 'single_$_singleCounter'),
//       ],
//     );
//   }

//   void removeSingleGuest(String id) => state = state.copyWith(
//     singleGuests: state.singleGuests.where((g) => g.id != id).toList(),
//   );

//   void updateSingleGuest(String id, SingleGuest updated) =>
//       state = state.copyWith(
//         singleGuests: state.singleGuests
//             .map((g) => g.id == id ? updated : g)
//             .toList(),
//       );

//   void addCoupleGuest() {
//     _coupleCounter++;
//     state = state.copyWith(
//       coupleGuests: [
//         ...state.coupleGuests,
//         CoupleGuest(id: 'couple_$_coupleCounter'),
//       ],
//     );
//   }

//   void removeCoupleGuest(String id) => state = state.copyWith(
//     coupleGuests: state.coupleGuests.where((g) => g.id != id).toList(),
//   );

//   void updateCoupleGuest(String id, CoupleGuest updated) =>
//       state = state.copyWith(
//         coupleGuests: state.coupleGuests
//             .map((g) => g.id == id ? updated : g)
//             .toList(),
//       );

//   void setShowValidation(bool val) =>
//       state = state.copyWith(showValidation: val);

//   bool validate() {
//     state = state.copyWith(showValidation: true);
//     for (final g in state.singleGuests) {
//       if (g.username.trim().isEmpty ||
//           g.fullName.trim().isEmpty ||
//           g.email.trim().isEmpty ||
//           g.phone.trim().isEmpty)
//         return false;
//     }
//     for (final g in state.coupleGuests) {
//       if (g.username1.trim().isEmpty ||
//           g.fullName1.trim().isEmpty ||
//           g.email1.trim().isEmpty ||
//           g.phone1.trim().isEmpty ||
//           g.fullName2.trim().isEmpty ||
//           g.email2.trim().isEmpty ||
//           g.phone2.trim().isEmpty)
//         return false;
//     }
//     return true;
//   }
// }

// final guestListProvider =
//     StateNotifierProvider<GuestListNotifier, GuestListState>(
//       (ref) => GuestListNotifier(),
//     );

// // ── Payment / Voucher / UI State ──────────────────────────────────────────────
// enum PaymentType { full, partial }

// final paymentTypeProvider = StateProvider<PaymentType?>((ref) => null);
// final voucherCodeProvider = StateProvider<String>((ref) => '');
// final voucherDiscountProvider = StateProvider<double>((ref) => 0.0);
// final membershipDiscountProvider = StateProvider<double>((ref) => 0.0);
// final descriptionExpandedProvider = StateProvider<bool>((ref) => false);

// // ═════════════════════════════════════════════════════════════════════════════
// // SECTION 5 — SCREEN
// // ═════════════════════════════════════════════════════════════════════════════

// /// ✅ Only pass [eventId]. Token is read automatically from SharedPreferences.
// ///
// /// Navigate like this (from anywhere):
// /// ```dart
// /// Navigator.push(context, MaterialPageRoute(
// ///   builder: (_) => EventDetailScreen(eventId: event.id),
// /// ));
// /// ```
// class EventDetailScreen extends ConsumerWidget {
//   final String eventId;

//   const EventDetailScreen({super.key, required this.eventId});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final asyncEvent = ref.watch(eventDetailProvider(eventId));

//     return Scaffold(
//       backgroundColor: const Color(0xFFFFF0F5),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0.5,
//         leading: const SizedBox.shrink(),
//         title: const Text(
//           'Parties And Events',
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 12),
//             child: ElevatedButton.icon(
//               onPressed: () => Navigator.of(context).pop(),
//               icon: const Icon(Icons.arrow_back, size: 16, color: Colors.white),
//               label: const Text(
//                 'Back',
//                 style: TextStyle(color: Colors.white, fontSize: 13),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF8B0045),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 14,
//                   vertical: 8,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: asyncEvent.when(
//         loading: () => const Center(
//           child: CircularProgressIndicator(color: Color(0xFF8B0045)),
//         ),
//         error: (err, _) => _buildError(context, ref, err),
//         data: (eventResponse) => _buildContent(eventResponse),
//       ),
//     );
//   }

//   Widget _buildError(BuildContext context, WidgetRef ref, Object err) {
//     final isAuthError =
//         err.toString().contains('authenticated') ||
//         err.toString().contains('log in');
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               isAuthError ? Icons.lock_outline : Icons.error_outline,
//               size: 60,
//               color: const Color(0xFF8B0045),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               isAuthError ? 'Session Expired' : 'Failed to load event',
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               isAuthError
//                   ? 'Your session has expired. Please log in again.'
//                   : err.toString(),
//               textAlign: TextAlign.center,
//               style: const TextStyle(color: Colors.grey, fontSize: 13),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF8B0045),
//               ),
//               onPressed: () => ref.refresh(eventDetailProvider(eventId)),
//               icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
//               label: const Text('Retry', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildContent(EventDetailResponse eventResponse) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _EventHeaderCard(event: eventResponse.data),
//           const SizedBox(height: 16),
//           const _GuestSection(),
//           const SizedBox(height: 16),
//           if (eventResponse.roomList.data.isNotEmpty) ...[
//             _RoomPackageSection(rooms: eventResponse.roomList.data),
//             const SizedBox(height: 16),
//           ],
//           if (eventResponse.additionalNights.isNotEmpty) ...[
//             _AdditionalNightSection(
//               nights: eventResponse.additionalNights,
//               pricePerNight: eventResponse.data.additionalRoomNightPrice,
//               feePerNight: eventResponse.data.additionalRoomNightFee,
//             ),
//             const SizedBox(height: 16),
//           ],
//           _OrderSummarySection(
//             rooms: eventResponse.roomList.data,
//             nights: eventResponse.additionalNights,
//             pricePerNight: eventResponse.data.additionalRoomNightPrice,
//             feePerNight: eventResponse.data.additionalRoomNightFee,
//           ),
//           const SizedBox(height: 30),
//         ],
//       ),
//     );
//   }
// }

// // ═════════════════════════════════════════════════════════════════════════════
// // SECTION 6 — EVENT HEADER CARD
// // ═════════════════════════════════════════════════════════════════════════════

// class _EventHeaderCard extends ConsumerWidget {
//   final EventData event;
//   const _EventHeaderCard({required this.event});

//   String _formatDate(String date, String time) {
//     try {
//       final parts = date.split('-');
//       if (parts.length < 3) return '$date $time';
//       final months = [
//         '',
//         'January',
//         'February',
//         'March',
//         'April',
//         'May',
//         'June',
//         'July',
//         'August',
//         'September',
//         'October',
//         'November',
//         'December',
//       ];
//       final year = parts[0];
//       final month = int.tryParse(parts[1]) ?? 0;
//       final day = int.tryParse(parts[2]) ?? 0;
//       final monthName = month < months.length ? months[month] : parts[1];
//       final timeParts = time.split(':');
//       int hour = int.tryParse(timeParts[0]) ?? 0;
//       final min = timeParts.length > 1 ? timeParts[1] : '00';
//       final period = hour >= 12 ? 'pm' : 'am';
//       hour = hour % 12;
//       if (hour == 0) hour = 12;
//       final dt = DateTime.tryParse(date);
//       final days = [
//         '',
//         'Monday',
//         'Tuesday',
//         'Wednesday',
//         'Thursday',
//         'Friday',
//         'Saturday',
//         'Sunday',
//       ];
//       final dayName = dt != null ? days[dt.weekday] : '';
//       return '$dayName, $monthName $day, $year  $hour:$min $period';
//     } catch (_) {
//       return '$date $time';
//     }
//   }

//   String _stripHtml(String html) {
//     return html
//         .replaceAll('&amp;lt;', '<')
//         .replaceAll('&amp;gt;', '>')
//         .replaceAll('&amp;amp;', '&')
//         .replaceAll('&amp;nbsp;', ' ')
//         .replaceAll('&lt;', '<')
//         .replaceAll('&gt;', '>')
//         .replaceAll('&amp;', '&')
//         .replaceAll('&nbsp;', ' ')
//         .replaceAll('\r\n', ' ')
//         .replaceAll(RegExp(r'<[^>]*>'), '')
//         .trim();
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isExpanded = ref.watch(descriptionExpandedProvider);
//     final cleanDescription = _stripHtml(event.eventDescription);
//     const maxChars = 80;
//     final isLong = cleanDescription.length > maxChars;
//     final displayText = (!isExpanded && isLong)
//         ? '${cleanDescription.substring(0, maxChars)}...'
//         : cleanDescription;

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Event Image
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Image.network(
//                     event.eventImage,
//                     width: 140,
//                     height: 160,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => Container(
//                       width: 140,
//                       height: 160,
//                       color: Colors.grey[200],
//                       child: const Icon(
//                         Icons.image_not_supported,
//                         color: Colors.grey,
//                         size: 40,
//                       ),
//                     ),
//                     loadingBuilder: (_, child, progress) {
//                       if (progress == null) return child;
//                       return Container(
//                         width: 140,
//                         height: 160,
//                         color: Colors.grey[100],
//                         child: const Center(
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Color(0xFF8B0045),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 14),
//                 // Details
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         event.eventName,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         '${_formatDate(event.eventFromDate, event.eventFromTime)}  –  ${_formatDate(event.eventToDate, event.eventToTime)}',
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Colors.black54,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       if (event.formattedAddress.isNotEmpty)
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Icon(
//                               Icons.location_on,
//                               size: 15,
//                               color: Color(0xFF8B0045),
//                             ),
//                             const SizedBox(width: 4),
//                             Expanded(
//                               child: Text(
//                                 event.formattedAddress,
//                                 style: const TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       const SizedBox(height: 8),
//                       if (event.eventEmail.isNotEmpty)
//                         Text(
//                           'contacted by:- ${event.eventEmail}',
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.black54,
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 14),
//             const Text(
//               'Description',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               displayText,
//               style: const TextStyle(fontSize: 13, color: Color(0xFFD81B60)),
//             ),
//             if (isLong) ...[
//               const SizedBox(height: 4),
//               GestureDetector(
//                 onTap: () =>
//                     ref.read(descriptionExpandedProvider.notifier).state =
//                         !isExpanded,
//                 child: Text(
//                   isExpanded ? 'Show Less' : 'Show More...',
//                   style: const TextStyle(
//                     fontSize: 13,
//                     color: Colors.black87,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ═════════════════════════════════════════════════════════════════════════════
// // SECTION 7 — GUEST SECTION
// // ═════════════════════════════════════════════════════════════════════════════

// class _GuestSection extends ConsumerWidget {
//   const _GuestSection();

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final guestState = ref.watch(guestListProvider);

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(14),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Auto-fill checkbox
//           Row(
//             children: [
//               Checkbox(
//                 value: false,
//                 activeColor: const Color(0xFF8B0045),
//                 onChanged: (_) {},
//               ),
//               const Flexible(
//                 child: Text(
//                   'Click here to generate your information',
//                   style: TextStyle(fontSize: 13, color: Colors.black87),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),

//           // Add Guest label + buttons — wraps on small screens
//           Wrap(
//             spacing: 10,
//             runSpacing: 8,
//             crossAxisAlignment: WrapCrossAlignment.center,
//             children: [
//               const Text(
//                 'Add Guest:',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFFD81B60),
//                 ),
//               ),
//               _GuestTypeButton(
//                 icon: Icons.person,
//                 label: 'Single',
//                 onTap: () =>
//                     ref.read(guestListProvider.notifier).addSingleGuest(),
//               ),
//               _GuestTypeButton(
//                 icon: Icons.people,
//                 label: 'Couple',
//                 onTap: () =>
//                     ref.read(guestListProvider.notifier).addCoupleGuest(),
//               ),
//             ],
//           ),
//           const SizedBox(height: 14),

//           // Single guest cards
//           ...guestState.singleGuests.asMap().entries.map(
//             (entry) => Padding(
//               padding: const EdgeInsets.only(bottom: 12),
//               child: _SingleGuestCard(
//                 guest: entry.value,
//                 index: entry.key + 1,
//                 showValidation: guestState.showValidation,
//               ),
//             ),
//           ),

//           // Couple guest cards
//           ...guestState.coupleGuests.asMap().entries.map(
//             (entry) => Padding(
//               padding: const EdgeInsets.only(bottom: 12),
//               child: _CoupleGuestCard(
//                 guest: entry.value,
//                 index: entry.key + 1,
//                 showValidation: guestState.showValidation,
//               ),
//             ),
//           ),

//           // Add Guests to List button
//           if (guestState.singleGuests.isNotEmpty ||
//               guestState.coupleGuests.isNotEmpty) ...[
//             const SizedBox(height: 8),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   final isValid = ref
//                       .read(guestListProvider.notifier)
//                       .validate();
//                   if (isValid) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Guests added to list!'),
//                         backgroundColor: Color(0xFF8B0045),
//                       ),
//                     );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF1A0A2E),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                 ),
//                 child: const Text(
//                   'Add Guests to the List',
//                   style: TextStyle(color: Colors.white, fontSize: 14),
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

// // ── Guest Type Button ─────────────────────────────────────────────────────────
// class _GuestTypeButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;

//   const _GuestTypeButton({
//     required this.icon,
//     required this.label,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton.icon(
//       onPressed: onTap,
//       icon: Icon(icon, size: 16, color: Colors.white),
//       label: Text(
//         label,
//         style: const TextStyle(color: Colors.white, fontSize: 13),
//       ),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color(0xFF1A0A2E),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       ),
//     );
//   }
// }

// // ── Single Guest Card ─────────────────────────────────────────────────────────
// class _SingleGuestCard extends ConsumerStatefulWidget {
//   final SingleGuest guest;
//   final int index;
//   final bool showValidation;

//   const _SingleGuestCard({
//     required this.guest,
//     required this.index,
//     required this.showValidation,
//   });

//   @override
//   ConsumerState<_SingleGuestCard> createState() => _SingleGuestCardState();
// }

// class _SingleGuestCardState extends ConsumerState<_SingleGuestCard> {
//   late final TextEditingController _usernameCtrl;
//   late final TextEditingController _fullNameCtrl;
//   late final TextEditingController _emailCtrl;
//   late final TextEditingController _phoneCtrl;

//   @override
//   void initState() {
//     super.initState();
//     _usernameCtrl = TextEditingController(text: widget.guest.username);
//     _fullNameCtrl = TextEditingController(text: widget.guest.fullName);
//     _emailCtrl = TextEditingController(text: widget.guest.email);
//     _phoneCtrl = TextEditingController(text: widget.guest.phone);
//   }

//   @override
//   void dispose() {
//     _usernameCtrl.dispose();
//     _fullNameCtrl.dispose();
//     _emailCtrl.dispose();
//     _phoneCtrl.dispose();
//     super.dispose();
//   }

//   void _update() {
//     ref
//         .read(guestListProvider.notifier)
//         .updateSingleGuest(
//           widget.guest.id,
//           widget.guest.copyWith(
//             username: _usernameCtrl.text,
//             fullName: _fullNameCtrl.text,
//             email: _emailCtrl.text,
//             phone: _phoneCtrl.text,
//           ),
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final sv = widget.showValidation;
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: const Color(0xFF4FC3F7), width: 1.2),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header row
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   'Add New Single Guest #${widget.index}',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 13,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
//               _DeleteButton(
//                 onTap: () => ref
//                     .read(guestListProvider.notifier)
//                     .removeSingleGuest(widget.guest.id),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           // Username + Full Name — stacked on small screens
//           _GuestField(
//             label: 'Username',
//             hint: 'Enter Username',
//             controller: _usernameCtrl,
//             onChanged: (_) => _update(),
//             showError: sv && _usernameCtrl.text.trim().isEmpty,
//           ),
//           const SizedBox(height: 10),
//           _GuestField(
//             label: 'Full Name',
//             hint: 'Enter Full Name',
//             controller: _fullNameCtrl,
//             onChanged: (_) => _update(),
//             showError: sv && _fullNameCtrl.text.trim().isEmpty,
//             showInfoIcon: true,
//           ),
//           const SizedBox(height: 10),
//           // Email + Phone side by side
//           Row(
//             children: [
//               Expanded(
//                 child: _GuestField(
//                   label: 'Email',
//                   hint: 'Email',
//                   controller: _emailCtrl,
//                   onChanged: (_) => _update(),
//                   showError: sv && _emailCtrl.text.trim().isEmpty,
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: _GuestField(
//                   label: 'Phone',
//                   hint: 'Phone Number',
//                   controller: _phoneCtrl,
//                   onChanged: (_) => _update(),
//                   showError: sv && _phoneCtrl.text.trim().isEmpty,
//                   keyboardType: TextInputType.phone,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           // ID Proof full width
//           _IdProofPicker(
//             showError: sv && widget.guest.idProofPath == null,
//             filePath: widget.guest.idProofPath,
//             onPicked: (path) {
//               ref
//                   .read(guestListProvider.notifier)
//                   .updateSingleGuest(
//                     widget.guest.id,
//                     widget.guest.copyWith(idProofPath: path),
//                   );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ── Couple Guest Card ─────────────────────────────────────────────────────────
// class _CoupleGuestCard extends ConsumerStatefulWidget {
//   final CoupleGuest guest;
//   final int index;
//   final bool showValidation;

//   const _CoupleGuestCard({
//     required this.guest,
//     required this.index,
//     required this.showValidation,
//   });

//   @override
//   ConsumerState<_CoupleGuestCard> createState() => _CoupleGuestCardState();
// }

// class _CoupleGuestCardState extends ConsumerState<_CoupleGuestCard> {
//   late final TextEditingController _u1, _fn1, _e1, _p1;
//   late final TextEditingController _u2, _fn2, _e2, _p2;

//   @override
//   void initState() {
//     super.initState();
//     _u1 = TextEditingController(text: widget.guest.username1);
//     _fn1 = TextEditingController(text: widget.guest.fullName1);
//     _e1 = TextEditingController(text: widget.guest.email1);
//     _p1 = TextEditingController(text: widget.guest.phone1);
//     _u2 = TextEditingController(text: widget.guest.username2);
//     _fn2 = TextEditingController(text: widget.guest.fullName2);
//     _e2 = TextEditingController(text: widget.guest.email2);
//     _p2 = TextEditingController(text: widget.guest.phone2);
//   }

//   @override
//   void dispose() {
//     _u1.dispose();
//     _fn1.dispose();
//     _e1.dispose();
//     _p1.dispose();
//     _u2.dispose();
//     _fn2.dispose();
//     _e2.dispose();
//     _p2.dispose();
//     super.dispose();
//   }

//   void _update() {
//     ref
//         .read(guestListProvider.notifier)
//         .updateCoupleGuest(
//           widget.guest.id,
//           widget.guest.copyWith(
//             username1: _u1.text,
//             fullName1: _fn1.text,
//             email1: _e1.text,
//             phone1: _p1.text,
//             username2: _u2.text,
//             fullName2: _fn2.text,
//             email2: _e2.text,
//             phone2: _p2.text,
//           ),
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final sv = widget.showValidation;
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: const Color(0xFF4FC3F7), width: 1.2),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   'Add New Couple Guest #${widget.index}',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 13,
//                     color: Color(0xFF4FC3F7),
//                   ),
//                 ),
//               ),
//               _DeleteButton(
//                 onTap: () => ref
//                     .read(guestListProvider.notifier)
//                     .removeCoupleGuest(widget.guest.id),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),

//           // ── Member 1 ──────────────────────────────────────────────────
//           const _SectionLabel(label: 'MEMBER 1'),
//           const SizedBox(height: 8),
//           _GuestField(
//             label: 'Username',
//             hint: 'Enter Username',
//             controller: _u1,
//             onChanged: (_) => _update(),
//             showError: sv && _u1.text.trim().isEmpty,
//           ),
//           const SizedBox(height: 8),
//           _GuestField(
//             label: 'Full Name',
//             hint: 'Enter Full Name',
//             controller: _fn1,
//             onChanged: (_) => _update(),
//             showError: sv && _fn1.text.trim().isEmpty,
//             showInfoIcon: true,
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               Expanded(
//                 child: _GuestField(
//                   label: 'Email',
//                   hint: 'E-mail',
//                   controller: _e1,
//                   onChanged: (_) => _update(),
//                   showError: sv && _e1.text.trim().isEmpty,
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: _GuestField(
//                   label: 'Phone',
//                   hint: 'Phone No.',
//                   controller: _p1,
//                   onChanged: (_) => _update(),
//                   showError: sv && _p1.text.trim().isEmpty,
//                   keyboardType: TextInputType.phone,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           _IdProofPicker(
//             label: 'Id Proof (Member 1)',
//             showError: sv && widget.guest.idProofPath1 == null,
//             filePath: widget.guest.idProofPath1,
//             onPicked: (path) => ref
//                 .read(guestListProvider.notifier)
//                 .updateCoupleGuest(
//                   widget.guest.id,
//                   widget.guest.copyWith(idProofPath1: path),
//                 ),
//           ),

//           const SizedBox(height: 14),
//           const Divider(color: Color(0xFFEEEEEE)),
//           const SizedBox(height: 10),

//           // ── Member 2 ──────────────────────────────────────────────────
//           const _SectionLabel(label: 'MEMBER 2'),
//           const SizedBox(height: 8),
//           _GuestField(
//             label: 'Username',
//             hint: 'Username',
//             controller: _u2,
//             onChanged: (_) => _update(),
//             showError: false,
//           ),
//           const SizedBox(height: 8),
//           _GuestField(
//             label: 'Full Name',
//             hint: 'Enter Full Name',
//             controller: _fn2,
//             onChanged: (_) => _update(),
//             showError: sv && _fn2.text.trim().isEmpty,
//             showInfoIcon: true,
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               Expanded(
//                 child: _GuestField(
//                   label: 'Email',
//                   hint: 'E-mail',
//                   controller: _e2,
//                   onChanged: (_) => _update(),
//                   showError: sv && _e2.text.trim().isEmpty,
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: _GuestField(
//                   label: 'Phone',
//                   hint: 'Phone No.',
//                   controller: _p2,
//                   onChanged: (_) => _update(),
//                   showError: sv && _p2.text.trim().isEmpty,
//                   keyboardType: TextInputType.phone,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           _IdProofPicker(
//             label: 'Id Proof (Member 2)',
//             showError: sv && widget.guest.idProofPath2 == null,
//             filePath: widget.guest.idProofPath2,
//             onPicked: (path) => ref
//                 .read(guestListProvider.notifier)
//                 .updateCoupleGuest(
//                   widget.guest.id,
//                   widget.guest.copyWith(idProofPath2: path),
//                 ),
//           ),
//           const SizedBox(height: 12),
//           Align(
//             alignment: Alignment.centerRight,
//             child: ElevatedButton(
//               onPressed: () => ref
//                   .read(guestListProvider.notifier)
//                   .removeCoupleGuest(widget.guest.id),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFD32F2F),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 10,
//                 ),
//               ),
//               child: const Text(
//                 'Remove',
//                 style: TextStyle(color: Colors.white, fontSize: 13),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ── Shared small widgets ──────────────────────────────────────────────────────

// class _SectionLabel extends StatelessWidget {
//   final String label;
//   const _SectionLabel({required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       label,
//       style: const TextStyle(
//         fontSize: 11,
//         fontWeight: FontWeight.w700,
//         color: Colors.black45,
//         letterSpacing: 0.8,
//       ),
//     );
//   }
// }

// class _GuestField extends StatelessWidget {
//   final String label;
//   final String hint;
//   final TextEditingController controller;
//   final ValueChanged<String> onChanged;
//   final bool showError;
//   final bool showInfoIcon;
//   final TextInputType keyboardType;

//   const _GuestField({
//     required this.label,
//     required this.hint,
//     required this.controller,
//     required this.onChanged,
//     required this.showError,
//     this.showInfoIcon = false,
//     this.keyboardType = TextInputType.text,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Flexible(
//               child: Text(
//                 label,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//             if (showInfoIcon) ...[
//               const SizedBox(width: 4),
//               const Icon(Icons.info_outline, size: 13, color: Colors.black54),
//             ],
//           ],
//         ),
//         const SizedBox(height: 4),
//         TextField(
//           controller: controller,
//           onChanged: onChanged,
//           keyboardType: keyboardType,
//           style: const TextStyle(fontSize: 13),
//           decoration: InputDecoration(
//             hintText: hint,
//             hintStyle: const TextStyle(fontSize: 12, color: Colors.black38),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 10,
//               vertical: 10,
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(6),
//               borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(6),
//               borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(6),
//               borderSide: const BorderSide(
//                 color: Color(0xFF8B0045),
//                 width: 1.5,
//               ),
//             ),
//           ),
//         ),
//         if (showError) ...[
//           const SizedBox(height: 3),
//           const Text(
//             'This Field is required',
//             style: TextStyle(fontSize: 10, color: Color(0xFFD32F2F)),
//           ),
//         ],
//       ],
//     );
//   }
// }

// class _IdProofPicker extends StatelessWidget {
//   final String? filePath;
//   final bool showError;
//   final ValueChanged<String> onPicked;
//   final String label;

//   const _IdProofPicker({
//     required this.showError,
//     required this.onPicked,
//     this.filePath,
//     this.label = 'Id Proof',
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Flexible(
//               child: Text(
//                 label,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 4),
//             const Icon(Icons.info_outline, size: 13, color: Colors.black54),
//           ],
//         ),
//         const SizedBox(height: 4),
//         GestureDetector(
//           onTap: () => onPicked('selected_file.jpg'),
//           child: Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               border: Border.all(color: const Color(0xFFCCCCCC)),
//               borderRadius: BorderRadius.circular(6),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 10,
//                   ),
//                   decoration: const BoxDecoration(
//                     border: Border(right: BorderSide(color: Color(0xFFCCCCCC))),
//                   ),
//                   child: const Text(
//                     'Choose file',
//                     style: TextStyle(fontSize: 12, color: Colors.black87),
//                   ),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     child: Text(
//                       filePath != null
//                           ? filePath!.split('/').last
//                           : 'No file chosen',
//                       style: const TextStyle(
//                         fontSize: 11,
//                         color: Colors.black45,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         if (showError) ...[
//           const SizedBox(height: 3),
//           const Text(
//             'This Field is required',
//             style: TextStyle(fontSize: 10, color: Color(0xFFD32F2F)),
//           ),
//         ],
//       ],
//     );
//   }
// }

// class _DeleteButton extends StatelessWidget {
//   final VoidCallback onTap;
//   const _DeleteButton({required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 34,
//         height: 34,
//         decoration: BoxDecoration(
//           color: const Color(0xFFD32F2F),
//           borderRadius: BorderRadius.circular(6),
//         ),
//         child: const Icon(Icons.delete_outline, color: Colors.white, size: 18),
//       ),
//     );
//   }
// }

// // ═════════════════════════════════════════════════════════════════════════════
// // SECTION 8 — ROOM PACKAGE SECTION  (horizontal scrollable cards)
// // ═════════════════════════════════════════════════════════════════════════════

// class _RoomPackageSection extends ConsumerWidget {
//   final List<RoomData> rooms;
//   const _RoomPackageSection({required this.rooms});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final quantities = ref.watch(roomQuantityProvider);
//     final screenW = MediaQuery.of(context).size.width;
//     // Card width: ~75% of screen so next card peeks → user knows it scrolls
//     // Each card = 80% screen width so next card peeks by ~20%
//     final cardW = (screenW * 0.80).clamp(240.0, 340.0);

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── Section title + swipe hint ────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
//             child: Row(
//               children: const [
//                 Expanded(
//                   child: Text(
//                     'Choose Your Beat Flirt Package',
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 6),
//                 Icon(Icons.swipe, size: 16, color: Colors.black38),
//                 SizedBox(width: 3),
//                 Text(
//                   'scroll',
//                   style: TextStyle(fontSize: 11, color: Colors.black38),
//                 ),
//               ],
//             ),
//           ),

//           // ── Horizontal scrollable cards ───────────────────────────────
//           SizedBox(
//             height: 250,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               physics: const BouncingScrollPhysics(),
//               padding: const EdgeInsets.fromLTRB(14, 6, 14, 12),
//               itemCount: rooms.length,
//               itemBuilder: (context, index) {
//                 final room = rooms[index];
//                 final qty = quantities[room.id] ?? 0;
//                 final amount = qty * (double.tryParse(room.price) ?? 0);
//                 final isSelected = qty > 0;

//                 return Padding(
//                   padding: EdgeInsets.only(
//                     right: index < rooms.length - 1 ? 12 : 0,
//                   ),
//                   child: SizedBox(
//                     width: cardW,
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 200),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(
//                           color: isSelected
//                               ? const Color(0xFF8B0045)
//                               : const Color(0xFFE0E0E0),
//                           width: isSelected ? 1.8 : 1,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: isSelected
//                                 ? const Color(0xFF8B0045).withOpacity(0.10)
//                                 : Colors.black.withOpacity(0.04),
//                             blurRadius: 6,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // ── Room image (top, full width) ─────────────
//                           ClipRRect(
//                             borderRadius: const BorderRadius.vertical(
//                               top: Radius.circular(10),
//                             ),
//                             child: Image.network(
//                               room.roomImage,
//                               width: double.infinity,
//                               height: 115,
//                               fit: BoxFit.cover,
//                               errorBuilder: (_, __, ___) => Container(
//                                 width: double.infinity,
//                                 height: 115,
//                                 color: Colors.grey[200],
//                                 child: const Icon(
//                                   Icons.bed,
//                                   color: Colors.grey,
//                                   size: 36,
//                                 ),
//                               ),
//                               loadingBuilder: (_, child, prog) {
//                                 if (prog == null) return child;
//                                 return Container(
//                                   width: double.infinity,
//                                   height: 115,
//                                   color: Colors.grey[100],
//                                   child: const Center(
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       color: Color(0xFF8B0045),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),

//                           // ── Card body ────────────────────────────────
//                           // Expanded(
//                           //   child:
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // Room name
//                                 Text(
//                                   room.roomName,
//                                   style: const TextStyle(
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black87,
//                                   ),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 if (room.shortDescription.isNotEmpty) ...[
//                                   const SizedBox(height: 2),
//                                   Text(
//                                     room.shortDescription,
//                                     style: const TextStyle(
//                                       fontSize: 10,
//                                       color: Colors.black54,
//                                     ),
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ],

//                                 const SizedBox(height: 6),

//                                 // Price + Fee row
//                                 Row(
//                                   children: [
//                                     _PriceBadge(
//                                       label: 'Price',
//                                       value: '\$${room.price}',
//                                     ),
//                                     const SizedBox(width: 6),
//                                     _PriceBadge(
//                                       label: 'Fee',
//                                       value: '\$${room.fee}',
//                                       secondary: true,
//                                     ),
//                                   ],
//                                 ),

//                                 // const Spacer(),
//                                 SizedBox(height: 10),

//                                 // QTY row + Amount
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     // QTY label
//                                     Row(
//                                       children: [
//                                         const Text(
//                                           'QTY:',
//                                           style: TextStyle(
//                                             fontSize: 11,
//                                             color: Colors.black54,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                         const SizedBox(width: 6),
//                                         // Compact +/- stepper
//                                         _Stepper(
//                                           value: qty,
//                                           max:
//                                               int.tryParse(
//                                                 room.roomAvailable,
//                                               ) ??
//                                               10,
//                                           onChanged: (val) => ref
//                                               .read(
//                                                 roomQuantityProvider.notifier,
//                                               )
//                                               .setQuantity(room.id, val),
//                                         ),
//                                       ],
//                                     ),
//                                     // const Spacer(),
//                                     SizedBox(height: 10),
//                                     // Amount
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.end,
//                                       children: [
//                                         const Text(
//                                           'TOTAL',
//                                           style: TextStyle(
//                                             fontSize: 9,
//                                             color: Colors.black45,
//                                             letterSpacing: 0.3,
//                                           ),
//                                         ),
//                                         Text(
//                                           '\$${amount == 0 ? '0' : amount.toStringAsFixed(0)}',
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.bold,
//                                             color: isSelected
//                                                 ? const Color(0xFF8B0045)
//                                                 : Colors.black54,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           // ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           // ── Dot indicator ─────────────────────────────────────────────
//           _RoomDotIndicator(
//             count: rooms.length,
//             quantities: quantities,
//             rooms: rooms,
//           ),
//           const SizedBox(height: 12),
//         ],
//       ),
//     );
//   }
// }

// // ── Price badge chip ────────────────────────────────────────────────────────
// class _PriceBadge extends StatelessWidget {
//   final String label;
//   final String value;
//   final bool secondary;
//   const _PriceBadge({
//     required this.label,
//     required this.value,
//     this.secondary = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
//       decoration: BoxDecoration(
//         color: secondary
//             ? const Color(0xFFF3F3F3)
//             : const Color(0xFF8B0045).withOpacity(0.08),
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 9,
//               color: secondary ? Colors.black45 : const Color(0xFF8B0045),
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//               color: secondary ? Colors.black54 : const Color(0xFF8B0045),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ── +/- Stepper (replaces dropdown) ────────────────────────────────────────
// class _Stepper extends StatelessWidget {
//   final int value;
//   final int max;
//   final ValueChanged<int> onChanged;
//   const _Stepper({
//     required this.value,
//     required this.max,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         _StepBtn(
//           icon: Icons.remove,
//           enabled: value > 0,
//           onTap: () => onChanged(value - 1),
//         ),
//         Container(
//           width: 30,
//           alignment: Alignment.center,
//           child: Text(
//             '$value',
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//         ),
//         _StepBtn(
//           icon: Icons.add,
//           enabled: value < max,
//           onTap: () => onChanged(value + 1),
//         ),
//       ],
//     );
//   }
// }

// class _StepBtn extends StatelessWidget {
//   final IconData icon;
//   final bool enabled;
//   final VoidCallback onTap;
//   const _StepBtn({
//     required this.icon,
//     required this.enabled,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: enabled ? onTap : null,
//       child: Container(
//         width: 26,
//         height: 26,
//         decoration: BoxDecoration(
//           color: enabled
//               ? const Color(0xFF8B0045).withOpacity(0.1)
//               : Colors.grey[100],
//           borderRadius: BorderRadius.circular(5),
//           border: Border.all(
//             color: enabled
//                 ? const Color(0xFF8B0045).withOpacity(0.3)
//                 : Colors.grey[300]!,
//           ),
//         ),
//         child: Icon(
//           icon,
//           size: 14,
//           color: enabled ? const Color(0xFF8B0045) : Colors.grey[400],
//         ),
//       ),
//     );
//   }
// }

// // ── Dot indicator showing selected rooms ────────────────────────────────────
// class _RoomDotIndicator extends StatelessWidget {
//   final int count;
//   final Map<String, int> quantities;
//   final List<RoomData> rooms;
//   const _RoomDotIndicator({
//     required this.count,
//     required this.quantities,
//     required this.rooms,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 14),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: List.generate(count, (i) {
//           final selected = (quantities[rooms[i].id] ?? 0) > 0;
//           return AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             margin: const EdgeInsets.symmetric(horizontal: 3),
//             width: selected ? 18 : 6,
//             height: 6,
//             decoration: BoxDecoration(
//               color: selected ? const Color(0xFF8B0045) : Colors.grey[300],
//               borderRadius: BorderRadius.circular(3),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

// // ── Header label widget (shared with night section) ────────────────────────
// class _Hlabel extends StatelessWidget {
//   final String text;
//   final bool center;
//   final bool right;
//   const _Hlabel(this.text, {this.center = false, this.right = false});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       style: const TextStyle(
//         fontSize: 10,
//         fontWeight: FontWeight.bold,
//         color: Colors.black54,
//         letterSpacing: 0.3,
//       ),
//       textAlign: right
//           ? TextAlign.right
//           : center
//           ? TextAlign.center
//           : TextAlign.left,
//       maxLines: 1,
//       overflow: TextOverflow.visible,
//     );
//   }
// }

// // ── Shared quantity dropdown (used by night section) ───────────────────────
// class _QtyDropdown extends StatelessWidget {
//   final int value;
//   final int max;
//   final ValueChanged<int> onChanged;
//   const _QtyDropdown({
//     required this.value,
//     required this.max,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 34,
//       margin: const EdgeInsets.only(right: 4),
//       decoration: BoxDecoration(
//         border: Border.all(color: const Color(0xFFCCCCCC)),
//         borderRadius: BorderRadius.circular(6),
//         color: Colors.white,
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 2),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<int>(
//           value: value,
//           isExpanded: true,
//           icon: const Icon(Icons.keyboard_arrow_down, size: 14),
//           style: const TextStyle(fontSize: 13, color: Colors.black87),
//           onChanged: (val) {
//             if (val != null) onChanged(val);
//           },
//           items: List.generate(
//             max + 1,
//             (i) => i,
//           ).map((i) => DropdownMenuItem(value: i, child: Text('$i'))).toList(),
//         ),
//       ),
//     );
//   }
// }

// // ═════════════════════════════════════════════════════════════════════════════
// // SECTION 9 — ADDITIONAL NIGHT SECTION  (mobile-first, no overflow)
// // ═════════════════════════════════════════════════════════════════════════════

// class _AdditionalNightSection extends ConsumerWidget {
//   final List<AdditionalNight> nights;
//   final String pricePerNight;
//   final String feePerNight;

//   const _AdditionalNightSection({
//     required this.nights,
//     required this.pricePerNight,
//     required this.feePerNight,
//   });

//   String _fmt(String dateStr) {
//     try {
//       final p = dateStr.split('-');
//       final months = [
//         '',
//         'January',
//         'February',
//         'March',
//         'April',
//         'May',
//         'June',
//         'July',
//         'August',
//         'September',
//         'October',
//         'November',
//         'December',
//       ];
//       final m = int.tryParse(p[1]) ?? 0;
//       final d = int.tryParse(p[2]) ?? 0;
//       return '${months[m]} $d, ${p[0]}';
//     } catch (_) {
//       return dateStr;
//     }
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final quantities = ref.watch(nightQuantityProvider);

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Padding(
//             padding: EdgeInsets.fromLTRB(14, 14, 14, 4),
//             child: Text(
//               'Select Additional Room Night Options',
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.fromLTRB(14, 0, 14, 10),
//             child: Text(
//               'Quantity will remain the same as added to the event.',
//               style: TextStyle(
//                 fontSize: 11,
//                 color: Color(0xFFD81B60),
//                 fontStyle: FontStyle.italic,
//               ),
//             ),
//           ),

//           // ── Table header — short single-line labels ────────────────────
//           Container(
//             color: const Color(0xFFF5F5F5),
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
//             child: const Row(
//               children: [
//                 SizedBox(width: 54, child: _Hlabel('QTY')),
//                 Expanded(child: _Hlabel('DATE')),
//                 SizedBox(width: 46, child: _Hlabel('PRICE', center: true)),
//                 SizedBox(width: 36, child: _Hlabel('FEE', center: true)),
//                 SizedBox(width: 38, child: _Hlabel('AMT', right: true)),
//               ],
//             ),
//           ),
//           const Divider(height: 1),

//           // ── Night rows ─────────────────────────────────────────────────
//           ...nights.asMap().entries.map((entry) {
//             final night = entry.value;
//             final isLast = entry.key == nights.length - 1;
//             final qty = quantities[night.date] ?? 0;
//             final price = double.tryParse(pricePerNight) ?? 0;
//             final amount = qty * price;

//             return Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 10,
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       // QTY dropdown
//                       SizedBox(
//                         width: 54,
//                         child: _QtyDropdown(
//                           value: qty,
//                           max: 10,
//                           onChanged: (val) => ref
//                               .read(nightQuantityProvider.notifier)
//                               .setQuantity(night.date, val),
//                         ),
//                       ),

//                       // Day + Date stacked — Expanded takes remaining space
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               night.day,
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                             Text(
//                               _fmt(night.date),
//                               style: const TextStyle(
//                                 fontSize: 11,
//                                 color: Colors.black54,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // Price
//                       SizedBox(
//                         width: 46,
//                         child: Text(
//                           '\$$pricePerNight',
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.black87,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       // Fee
//                       SizedBox(
//                         width: 36,
//                         child: Text(
//                           '\$$feePerNight',
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.black87,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       // Amount
//                       SizedBox(
//                         width: 38,
//                         child: Text(
//                           '\$${amount == 0 ? '0' : amount.toStringAsFixed(0)}',
//                           style: const TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                           textAlign: TextAlign.right,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 if (!isLast)
//                   const Divider(height: 1, indent: 10, endIndent: 10),
//               ],
//             );
//           }),
//           const SizedBox(height: 8),
//         ],
//       ),
//     );
//   }
// }

// // ═════════════════════════════════════════════════════════════════════════════
// // SECTION 10 — ORDER SUMMARY SECTION
// // ═════════════════════════════════════════════════════════════════════════════

// class _OrderSummarySection extends ConsumerStatefulWidget {
//   final List<RoomData> rooms;
//   final List<AdditionalNight> nights;
//   final String pricePerNight;
//   final String feePerNight;

//   const _OrderSummarySection({
//     required this.rooms,
//     required this.nights,
//     required this.pricePerNight,
//     required this.feePerNight,
//   });

//   @override
//   ConsumerState<_OrderSummarySection> createState() =>
//       _OrderSummarySectionState();
// }

// class _OrderSummarySectionState extends ConsumerState<_OrderSummarySection> {
//   final _voucherCtrl = TextEditingController();

//   @override
//   void dispose() {
//     _voucherCtrl.dispose();
//     super.dispose();
//   }

//   double _calcSubTotal() {
//     final roomQtys = ref.read(roomQuantityProvider);
//     final nightQtys = ref.read(nightQuantityProvider);
//     double total = 0;
//     for (final room in widget.rooms) {
//       final qty = roomQtys[room.id] ?? 0;
//       total += qty * (double.tryParse(room.price) ?? 0);
//     }
//     for (final night in widget.nights) {
//       final qty = nightQtys[night.date] ?? 0;
//       total += qty * (double.tryParse(widget.pricePerNight) ?? 0);
//     }
//     return total;
//   }

//   @override
//   Widget build(BuildContext context) {
//     ref.watch(roomQuantityProvider);
//     ref.watch(nightQuantityProvider);

//     final paymentType = ref.watch(paymentTypeProvider);
//     final membershipDiscount = ref.watch(membershipDiscountProvider);
//     final voucherDiscount = ref.watch(voucherDiscountProvider);
//     final subTotal = _calcSubTotal();
//     final total = (subTotal - membershipDiscount - voucherDiscount).clamp(
//       0.0,
//       double.infinity,
//     );

//     return Column(
//       children: [
//         // ── Payment Type ──────────────────────────────────────────────────
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.06),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Select Payment Type',
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               // Wrap prevents overflow on small screens
//               Wrap(
//                 spacing: 0,
//                 runSpacing: 4,
//                 children: [
//                   _PaymentOption(
//                     label: 'Full Payment',
//                     value: PaymentType.full,
//                     groupValue: paymentType,
//                     onChanged: (val) =>
//                         ref.read(paymentTypeProvider.notifier).state = val,
//                   ),
//                   _PaymentOption(
//                     label: 'Partial Payment',
//                     value: PaymentType.partial,
//                     groupValue: paymentType,
//                     onChanged: (val) =>
//                         ref.read(paymentTypeProvider.notifier).state = val,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),

//         const SizedBox(height: 16),

//         // ── Order Summary ─────────────────────────────────────────────────
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: const Color(0xFF4FC3F7), width: 1.2),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.06),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Order Summary',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 14),

//               // Voucher Input
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _voucherCtrl,
//                       onChanged: (val) =>
//                           ref.read(voucherCodeProvider.notifier).state = val,
//                       style: const TextStyle(fontSize: 13),
//                       decoration: InputDecoration(
//                         hintText: 'Enter voucher code',
//                         hintStyle: const TextStyle(
//                           fontSize: 13,
//                           color: Colors.black38,
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 10,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(6),
//                           borderSide: const BorderSide(
//                             color: Color(0xFFCCCCCC),
//                           ),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(6),
//                           borderSide: const BorderSide(
//                             color: Color(0xFFCCCCCC),
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(6),
//                           borderSide: const BorderSide(
//                             color: Color(0xFF8B0045),
//                             width: 1.5,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   ElevatedButton(
//                     onPressed: () {
//                       // TODO: call voucher validation API
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Voucher applied!'),
//                           backgroundColor: Color(0xFF8B0045),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF1A0A2E),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 18,
//                         vertical: 14,
//                       ),
//                     ),
//                     child: const Text(
//                       'Apply',
//                       style: TextStyle(color: Colors.white, fontSize: 13),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 16),
//               const Divider(height: 1),
//               const SizedBox(height: 12),

//               // Sub Total
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Sub Total',
//                     style: TextStyle(fontSize: 14, color: Colors.black87),
//                   ),
//                   Text(
//                     '\$${subTotal == 0 ? '0' : subTotal.toStringAsFixed(0)}',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: subTotal == 0
//                           ? const Color(0xFF4FC3F7)
//                           : Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),

//               // Membership Discount
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Membership Discount',
//                     style: TextStyle(fontSize: 14, color: Color(0xFFD81B60)),
//                   ),
//                   Text(
//                     '-\$${membershipDiscount.toStringAsFixed(0)}',
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Color(0xFFD81B60),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),

//               // Voucher Discount
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Voucher Discount',
//                     style: TextStyle(fontSize: 14, color: Color(0xFF2E7D32)),
//                   ),
//                   Text(
//                     '-\$${voucherDiscount.toStringAsFixed(0)}',
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Color(0xFF2E7D32),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 12),
//               const Divider(height: 1),
//               const SizedBox(height: 12),

//               // Total
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Total',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   Text(
//                     '\$${total.toStringAsFixed(0)}',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 18),

//               // Buy Ticket Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // TODO: call buy ticket API
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Processing your ticket...'),
//                         backgroundColor: Color(0xFF8B0045),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF1A0A2E),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                   child: const Text(
//                     'BUY TICKET',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _PaymentOption extends StatelessWidget {
//   final String label;
//   final PaymentType value;
//   final PaymentType? groupValue;
//   final ValueChanged<PaymentType?> onChanged;

//   const _PaymentOption({
//     required this.label,
//     required this.value,
//     required this.groupValue,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // IntrinsicWidth so Wrap can measure each item correctly — no overflow
//     return IntrinsicWidth(
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Radio<PaymentType>(
//             value: value,
//             groupValue: groupValue,
//             activeColor: const Color(0xFF8B0045),
//             onChanged: onChanged,
//             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//             visualDensity: VisualDensity.compact,
//           ),
//           Text(
//             label,
//             style: const TextStyle(fontSize: 13, color: Colors.black87),
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
//     );
//   }
// }

// =============================================================================
//  event_detail_page.dart  —  Beat Flirt Event Detail  (Complete Clean File)
//
//  Navigate:
//    Navigator.push(context, MaterialPageRoute(
//      builder: (_) => EventDetailScreen(eventId: event.id),
//    ));
//
//  pubspec.yaml:
//    flutter_riverpod: ^2.5.1
//    http: ^1.2.1
//    shared_preferences: ^2.2.2
// =============================================================================

// ignore_for_file: avoid_print



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ═════════════════════════════════════════════════════════════════════════════
// SECTION 1 — TOKEN HELPER
// ═════════════════════════════════════════════════════════════════════════════

// class _TokenHelper {
//   static const String _key = 'auth_token'; // must match AuthService._tokenKey

//   static Future<String?> get() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString(_key);
//     debugPrint('[TokenHelper] key="$_key" found=${token != null} len=${token?.length ?? 0}');
//     if (token == null) {
//       final allKeys = prefs.getKeys();
//       debugPrint('[TokenHelper] ⚠️ All keys: $allKeys');
//       for (final k in allKeys) {
//         if (k.toLowerCase().contains('token') || k.toLowerCase().contains('auth')) {
//           debugPrint('[TokenHelper] 🔑 $k = "${prefs.get(k)}"');
//         }
//       }
//     }
//     return token;
//   }
// }


class _TokenHelper {
  static const String _key = 'auth_token';

  static Future<String?> get() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_key);

    debugPrint(
      '[TokenHelper] key="$_key" found=${token != null} len=${token?.length ?? 0}',
    );

    if (token == null) {
      final allKeys = prefs.getKeys();
      debugPrint('[TokenHelper] ⚠️ All keys: $allKeys');

      for (final key in allKeys) {
        if (key.toLowerCase().contains('token') ||
            key.toLowerCase().contains('auth')) {
          debugPrint('[TokenHelper] 🔑 $key = "${prefs.get(key)}"');
        }
      }
    }

    return token;
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// SECTION 2 — MODELS
// ═════════════════════════════════════════════════════════════════════════════

class EventDetailResponse {
  final String status;
  final EventData data;
  final List<AdditionalNight> additionalNights;
  final RoomListResponse roomList;
  EventDetailResponse({required this.status, required this.data,
      required this.additionalNights, required this.roomList});
  factory EventDetailResponse.fromJson(Map<String, dynamic> j) =>
      EventDetailResponse(
        status: j['status'] ?? '',
        data: EventData.fromJson(j['data'] ?? {}),
        additionalNights: (j['additional_night'] as List? ?? [])
            .map((e) => AdditionalNight.fromJson(e)).toList(),
        roomList: RoomListResponse.fromJson(j['room_list'] ?? {}),
      );
}

class EventData {
  final String id, eventName, eventFromDate, eventToDate, eventFromTime,
      eventToTime, eventType, additionalRoomNightPrice, additionalRoomNightFee,
      formattedAddress, eventImage, eventPrice, eventNoOfTicket, eventEmail,
      eventDescription, status, lat, lng, cityName;
  EventData({
    required this.id, required this.eventName, required this.eventFromDate,
    required this.eventToDate, required this.eventFromTime,
    required this.eventToTime, required this.eventType,
    required this.additionalRoomNightPrice, required this.additionalRoomNightFee,
    required this.formattedAddress, required this.eventImage,
    required this.eventPrice, required this.eventNoOfTicket,
    required this.eventEmail, required this.eventDescription,
    required this.status, required this.lat, required this.lng,
    required this.cityName,
  });
  factory EventData.fromJson(Map<String, dynamic> j) => EventData(
    id: j['id'] ?? '', eventName: j['event_name'] ?? '',
    eventFromDate: j['event_from_date'] ?? '',
    eventToDate: j['event_to_date'] ?? '',
    eventFromTime: j['event_from_time'] ?? '',
    eventToTime: j['event_to_time'] ?? '',
    eventType: j['event_type'] ?? '',
    additionalRoomNightPrice: j['additional_room_night_price'] ?? '0',
    additionalRoomNightFee: j['additional_room_night_fee'] ?? '0',
    formattedAddress: j['formatted_address'] ?? '',
    eventImage: j['event_image'] ?? '',
    eventPrice: j['event_price'] ?? '0',
    eventNoOfTicket: j['event_no_of_ticket'] ?? '0',
    eventEmail: j['event_email'] ?? '',
    eventDescription: j['event_description'] ?? '',
    status: j['status']?.toString() ?? '',
    lat: j['lat'] ?? '', lng: j['lng'] ?? '', cityName: j['city_name'] ?? '',
  );
}

class AdditionalNight {
  final String date, day;
  AdditionalNight({required this.date, required this.day});
  factory AdditionalNight.fromJson(Map<String, dynamic> j) =>
      AdditionalNight(date: j['date'] ?? '', day: j['day'] ?? '');
}

class RoomListResponse {
  final String status;
  final List<RoomData> data;
  RoomListResponse({required this.status, required this.data});
  factory RoomListResponse.fromJson(Map<String, dynamic> j) =>
      RoomListResponse(
        status: j['status']?.toString() ?? '',
        data: (j['data'] as List? ?? []).map((e) => RoomData.fromJson(e)).toList(),
      );
}

class RoomData {
  final String id, roomName, price, fee, fullDescription, shortDescription,
      roomAvailable, roomImage;
  RoomData({required this.id, required this.roomName, required this.price,
      required this.fee, required this.fullDescription,
      required this.shortDescription, required this.roomAvailable,
      required this.roomImage});
  factory RoomData.fromJson(Map<String, dynamic> j) => RoomData(
    id: j['id'] ?? '', roomName: j['room_name'] ?? '',
    price: j['price'] ?? '0', fee: j['fee'] ?? '0',
    fullDescription: j['full_description'] ?? '',
    shortDescription: j['short_description'] ?? '',
    roomAvailable: j['room_available'] ?? '0',
    roomImage: j['room_image'] ?? '',
  );
}

enum GuestType { single, couple }

class SingleGuest {
  final String id;
  String username, fullName, email, phone;
  String? idProofPath;
  SingleGuest({required this.id, this.username = '', this.fullName = '',
      this.email = '', this.phone = '', this.idProofPath});
  SingleGuest copyWith({String? username, String? fullName, String? email,
      String? phone, String? idProofPath}) =>
      SingleGuest(id: id, username: username ?? this.username,
          fullName: fullName ?? this.fullName, email: email ?? this.email,
          phone: phone ?? this.phone, idProofPath: idProofPath ?? this.idProofPath);
}

class CoupleGuest {
  final String id;
  String username1, fullName1, email1, phone1;
  String? idProofPath1;
  String username2, fullName2, email2, phone2;
  String? idProofPath2;
  CoupleGuest({required this.id,
      this.username1 = '', this.fullName1 = '', this.email1 = '', this.phone1 = '',
      this.idProofPath1,
      this.username2 = '', this.fullName2 = '', this.email2 = '', this.phone2 = '',
      this.idProofPath2});
  CoupleGuest copyWith({String? username1, String? fullName1, String? email1,
      String? phone1, String? idProofPath1, String? username2, String? fullName2,
      String? email2, String? phone2, String? idProofPath2}) =>
      CoupleGuest(id: id,
          username1: username1 ?? this.username1, fullName1: fullName1 ?? this.fullName1,
          email1: email1 ?? this.email1, phone1: phone1 ?? this.phone1,
          idProofPath1: idProofPath1 ?? this.idProofPath1,
          username2: username2 ?? this.username2, fullName2: fullName2 ?? this.fullName2,
          email2: email2 ?? this.email2, phone2: phone2 ?? this.phone2,
          idProofPath2: idProofPath2 ?? this.idProofPath2);
}

// ═════════════════════════════════════════════════════════════════════════════
// SECTION 3 — REPOSITORY
// ═════════════════════════════════════════════════════════════════════════════

class EventRepository {
  static const _baseUrl =
      'https://app.beatflirtevent.com/App/events/get_single_events';

  static Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
    'access-token': token,
  };

  Future<EventDetailResponse> getSingleEvent({required String eventId}) async {
    final token = await _TokenHelper.get();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated. Please log in again.');
    }
    debugPrint('[EventRepo] → eventId=$eventId tokenLen=${token.length}');

    // Try 1: JSON body
    final r1 = await http.post(Uri.parse(_baseUrl),
        // headers: _headers(token), body: jsonEncode({'event_id': eventId}));
        headers: _headers(token),
        body: jsonEncode({'event_id': eventId}),
    );
    debugPrint('[EventRepo] ← ${r1.statusCode} | ${r1.body.length > 200 ? r1.body.substring(0, 200) : r1.body}');
    final j1 = jsonDecode(r1.body) as Map<String, dynamic>;
    if (j1['status']?.toString() == '200') return EventDetailResponse.fromJson(j1);

    // Try 2: Form-encoded body
    final r2 = await http.post(Uri.parse(_baseUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token',
          'access-token': token,
        },
        body: {'event_id': eventId});
    debugPrint('[EventRepo] form ← ${r2.statusCode} | ${r2.body.length > 200 ? r2.body.substring(0, 200) : r2.body}');
    final j2 = jsonDecode(r2.body) as Map<String, dynamic>;
    if (j2['status']?.toString() == '200') return EventDetailResponse.fromJson(j2);

    throw Exception(j2['message'] ?? j1['message'] ?? 'Failed to load event');
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// SECTION 4 — RIVERPOD PROVIDERS
// ═════════════════════════════════════════════════════════════════════════════

// final eventRepositoryProvider = Provider<EventRepository>((ref) => EventRepository());

// final eventDetailProvider =
//     FutureProvider.family<EventDetailResponse, String>((ref, eventId) =>
//         ref.read(eventRepositoryProvider).getSingleEvent(eventId: eventId));

// // Room quantities
// class RoomQuantityNotifier extends StateNotifier<Map<String, int>> {
//   RoomQuantityNotifier() : super({});
//   void setQuantity(String id, int qty) => state = {...state, id: qty};
//   int get(String id) => state[id] ?? 0;
// }
// final roomQuantityProvider =
//     StateNotifierProvider<RoomQuantityNotifier, Map<String, int>>(
//         (_) => RoomQuantityNotifier());

// // Night quantities
// class NightQuantityNotifier extends StateNotifier<Map<String, int>> {
//   NightQuantityNotifier() : super({});
//   void setQuantity(String date, int qty) => state = {...state, date: qty};
// }
// final nightQuantityProvider =
//     StateNotifierProvider<NightQuantityNotifier, Map<String, int>>(
//         (_) => NightQuantityNotifier());

// // Guest list
// class GuestListState {
//   final List<SingleGuest> singleGuests;
//   final List<CoupleGuest> coupleGuests;
//   final bool showValidation;
//   const GuestListState({this.singleGuests = const [], this.coupleGuests = const [],
//       this.showValidation = false});
//   GuestListState copyWith({List<SingleGuest>? singleGuests,
//       List<CoupleGuest>? coupleGuests, bool? showValidation}) =>
//       GuestListState(
//           singleGuests: singleGuests ?? this.singleGuests,
//           coupleGuests: coupleGuests ?? this.coupleGuests,
//           showValidation: showValidation ?? this.showValidation);
// }

// class GuestListNotifier extends StateNotifier<GuestListState> {
//   GuestListNotifier() : super(const GuestListState());
//   int _sc = 0, _cc = 0;
//   void addSingle() { _sc++; state = state.copyWith(singleGuests: [...state.singleGuests, SingleGuest(id: 'sg$_sc')]); }
//   void removeSingle(String id) => state = state.copyWith(singleGuests: state.singleGuests.where((g) => g.id != id).toList());
//   void updateSingle(String id, SingleGuest u) => state = state.copyWith(singleGuests: state.singleGuests.map((g) => g.id == id ? u : g).toList());
//   void addCouple() { _cc++; state = state.copyWith(coupleGuests: [...state.coupleGuests, CoupleGuest(id: 'cg$_cc')]); }
//   void removeCouple(String id) => state = state.copyWith(coupleGuests: state.coupleGuests.where((g) => g.id != id).toList());
//   void updateCouple(String id, CoupleGuest u) => state = state.copyWith(coupleGuests: state.coupleGuests.map((g) => g.id == id ? u : g).toList());
//   bool validate() {
//     state = state.copyWith(showValidation: true);
//     for (final g in state.singleGuests) {
//       if (g.username.trim().isEmpty || g.fullName.trim().isEmpty ||
//           g.email.trim().isEmpty || g.phone.trim().isEmpty) return false;
//     }
//     for (final g in state.coupleGuests) {
//       if (g.username1.trim().isEmpty || g.fullName1.trim().isEmpty ||
//           g.email1.trim().isEmpty || g.phone1.trim().isEmpty ||
//           g.fullName2.trim().isEmpty || g.email2.trim().isEmpty ||
//           g.phone2.trim().isEmpty) return false;
//     }
//     return true;
//   }

// }
// // final guestListProvider =
// //     StateNotifierProvider<GuestListNotifier, GuestListState>(_ => GuestListNotifier());
// final guestListProvider = StateNotifierProvider<GuestListNotifier, GuestListState>((ref) => GuestListNotifier());

// // Payment / voucher
// enum PaymentType { full, partial }
// // final paymentTypeProvider = StateProvider<PaymentType?>(_ => null);
// final paymentTypeProvider = StateProvider<PaymentType?>((ref) => null);
// final voucherCodeProvider = StateProvider<String>((ref) => '');
// final voucherDiscountProvider = StateProvider<double>((ref) => 0.0);
// final membershipDiscountProvider = StateProvider<double>((ref) => 0.0);
// final descriptionExpandedProvider = StateProvider<bool>((ref) => false);

// ═════════════════════════════════════════════════════════════════════════════
// SECTION 4 — RIVERPOD PROVIDERS
// ═════════════════════════════════════════════════════════════════════════════

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository();
});

final eventDetailProvider =
    FutureProvider.family<EventDetailResponse, String>((ref, eventId) {
  return ref.read(eventRepositoryProvider).getSingleEvent(eventId: eventId);
});

// Room quantities
class RoomQuantityNotifier extends Notifier<Map<String, int>> {
  @override
  Map<String, int> build() {
    return {};
  }

  void setQuantity(String id, int qty) {
    state = {
      ...state,
      id: qty,
    };
  }

  int getQuantity(String id) {
    return state[id] ?? 0;
  }
}

final roomQuantityProvider =
    NotifierProvider<RoomQuantityNotifier, Map<String, int>>(
  RoomQuantityNotifier.new,
);

// Night quantities
class NightQuantityNotifier extends Notifier<Map<String, int>> {
  @override
  Map<String, int> build() {
    return {};
  }

  void setQuantity(String date, int qty) {
    state = {
      ...state,
      date: qty,
    };
  }

  int getQuantity(String date) {
    return state[date] ?? 0;
  }
}

final nightQuantityProvider =
    NotifierProvider<NightQuantityNotifier, Map<String, int>>(
  NightQuantityNotifier.new,
);

// Guest list
class GuestListState {
  final List<SingleGuest> singleGuests;
  final List<CoupleGuest> coupleGuests;
  final bool showValidation;

  const GuestListState({
    this.singleGuests = const [],
    this.coupleGuests = const [],
    this.showValidation = false,
  });

  GuestListState copyWith({
    List<SingleGuest>? singleGuests,
    List<CoupleGuest>? coupleGuests,
    bool? showValidation,
  }) {
    return GuestListState(
      singleGuests: singleGuests ?? this.singleGuests,
      coupleGuests: coupleGuests ?? this.coupleGuests,
      showValidation: showValidation ?? this.showValidation,
    );
  }
}

class GuestListNotifier extends Notifier<GuestListState> {
  int _singleCounter = 0;
  int _coupleCounter = 0;

  @override
  GuestListState build() {
    return const GuestListState();
  }

  void addSingle() {
    _singleCounter++;

    state = state.copyWith(
      singleGuests: [
        ...state.singleGuests,
        SingleGuest(id: 'sg$_singleCounter'),
      ],
    );
  }

  void removeSingle(String id) {
    state = state.copyWith(
      singleGuests: state.singleGuests.where((g) => g.id != id).toList(),
    );
  }

  void updateSingle(String id, SingleGuest updatedGuest) {
    state = state.copyWith(
      singleGuests: state.singleGuests.map((guest) {
        return guest.id == id ? updatedGuest : guest;
      }).toList(),
    );
  }

  void addCouple() {
    _coupleCounter++;

    state = state.copyWith(
      coupleGuests: [
        ...state.coupleGuests,
        CoupleGuest(id: 'cg$_coupleCounter'),
      ],
    );
  }

  void removeCouple(String id) {
    state = state.copyWith(
      coupleGuests: state.coupleGuests.where((g) => g.id != id).toList(),
    );
  }

  void updateCouple(String id, CoupleGuest updatedGuest) {
    state = state.copyWith(
      coupleGuests: state.coupleGuests.map((guest) {
        return guest.id == id ? updatedGuest : guest;
      }).toList(),
    );
  }

  bool validate() {
    state = state.copyWith(showValidation: true);

    for (final guest in state.singleGuests) {
      if (guest.username.trim().isEmpty ||
          guest.fullName.trim().isEmpty ||
          guest.email.trim().isEmpty ||
          guest.phone.trim().isEmpty) {
        return false;
      }
    }

    for (final guest in state.coupleGuests) {
      if (guest.username1.trim().isEmpty ||
          guest.fullName1.trim().isEmpty ||
          guest.email1.trim().isEmpty ||
          guest.phone1.trim().isEmpty ||
          guest.fullName2.trim().isEmpty ||
          guest.email2.trim().isEmpty ||
          guest.phone2.trim().isEmpty) {
        return false;
      }
    }

    return true;
  }
}

final guestListProvider =
    NotifierProvider<GuestListNotifier, GuestListState>(
  GuestListNotifier.new,
);

// Payment / voucher
enum PaymentType { full, partial }

class PaymentTypeNotifier extends Notifier<PaymentType?> {
  @override
  PaymentType? build() {
    return null;
  }

  void setPaymentType(PaymentType? value) {
    state = value;
  }
}

final paymentTypeProvider =
    NotifierProvider<PaymentTypeNotifier, PaymentType?>(
  PaymentTypeNotifier.new,
);

class VoucherCodeNotifier extends Notifier<String> {
  @override
  String build() {
    return '';
  }

  void setCode(String value) {
    state = value;
  }

  void clear() {
    state = '';
  }
}

final voucherCodeProvider =
    NotifierProvider<VoucherCodeNotifier, String>(
  VoucherCodeNotifier.new,
);

class VoucherDiscountNotifier extends Notifier<double> {
  @override
  double build() {
    return 0.0;
  }

  void setDiscount(double value) {
    state = value;
  }

  void clear() {
    state = 0.0;
  }
}

final voucherDiscountProvider =
    NotifierProvider<VoucherDiscountNotifier, double>(
  VoucherDiscountNotifier.new,
);

class MembershipDiscountNotifier extends Notifier<double> {
  @override
  double build() {
    return 0.0;
  }

  void setDiscount(double value) {
    state = value;
  }

  void clear() {
    state = 0.0;
  }
}

final membershipDiscountProvider =
    NotifierProvider<MembershipDiscountNotifier, double>(
  MembershipDiscountNotifier.new,
);

class DescriptionExpandedNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void toggle() {
    state = !state;
  }

  void setExpanded(bool value) {
    state = value;
  }
}

final descriptionExpandedProvider =
    NotifierProvider<DescriptionExpandedNotifier, bool>(
  DescriptionExpandedNotifier.new,
);


// ═════════════════════════════════════════════════════════════════════════════
// SECTION 5 — SCREEN
// ═════════════════════════════════════════════════════════════════════════════

class EventDetailScreen extends ConsumerWidget {
  final String eventId;
  const EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(eventDetailProvider(eventId));
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const SizedBox.shrink(),
        title: const Text('Parties And Events',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, size: 16, color: Colors.white),
              label: const Text('Back', style: TextStyle(color: Colors.white, fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B0045),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
            ),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF8B0045))),
        error: (err, _) => _ErrorView(eventId: eventId, err: err),
        data: (res) => SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _EventHeaderCard(event: res.data),
            const SizedBox(height: 14),
            const _GuestSection(),
            const SizedBox(height: 14),
            if (res.roomList.data.isNotEmpty) ...[
              _RoomPackageSection(rooms: res.roomList.data),
              const SizedBox(height: 14),
            ],
            if (res.additionalNights.isNotEmpty) ...[
              _NightSection(nights: res.additionalNights,
                  price: res.data.additionalRoomNightPrice,
                  fee: res.data.additionalRoomNightFee),
              const SizedBox(height: 14),
            ],
            _OrderSummarySection(rooms: res.roomList.data,
                nights: res.additionalNights,
                price: res.data.additionalRoomNightPrice,
                fee: res.data.additionalRoomNightFee),
            const SizedBox(height: 30),
          ]),
        ),
      ),
    );
  }
}

class _ErrorView extends ConsumerWidget {
  final String eventId;
  final Object err;
  const _ErrorView({required this.eventId, required this.err});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuth = err.toString().contains('authenticated') || err.toString().contains('log in');
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(isAuth ? Icons.lock_outline : Icons.error_outline, size: 60, color: const Color(0xFF8B0045)),
          const SizedBox(height: 16),
          Text(isAuth ? 'Session Expired' : 'Failed to load event',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(isAuth ? 'Please log in again.' : err.toString(),
              textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B0045)),
            onPressed: () => ref.refresh(eventDetailProvider(eventId)),
            icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
            label: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ]),
      ),
    );
  }
}


// ═════════════════════════════════════════════════════════════════════════════
// SECTION 6 — EVENT HEADER CARD
// ═════════════════════════════════════════════════════════════════════════════

class _EventHeaderCard extends ConsumerWidget {
  final EventData event;
  const _EventHeaderCard({required this.event});

  String _fmtDate(String date, String time) {
    try {
      final p = date.split('-');
      if (p.length < 3) return '$date $time';
      const months = ['','January','February','March','April','May','June',
          'July','August','September','October','November','December'];
      final month = int.tryParse(p[1]) ?? 0;
      final day = int.tryParse(p[2]) ?? 0;
      final tp = time.split(':');
      int h = int.tryParse(tp[0]) ?? 0;
      final m = tp.length > 1 ? tp[1] : '00';
      final per = h >= 12 ? 'pm' : 'am';
      h = h % 12; if (h == 0) h = 12;
      final dt = DateTime.tryParse(date);
      const days = ['','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
      final dn = dt != null ? days[dt.weekday] : '';
      return '$dn, ${months[month]} $day, ${p[0]}  $h:$m $per';
    } catch (_) { return '$date $time'; }
  }

  String _strip(String html) => html
      .replaceAll('&amp;lt;', '<').replaceAll('&amp;gt;', '>')
      .replaceAll('&amp;amp;', '&').replaceAll('&amp;nbsp;', ' ')
      .replaceAll('&lt;', '<').replaceAll('&gt;', '>').replaceAll('&amp;', '&')
      .replaceAll('&nbsp;', ' ').replaceAll('\r\n', ' ')
      .replaceAll(RegExp(r'<[^>]*>'), '').trim();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExp = ref.watch(descriptionExpandedProvider);
    final desc = _strip(event.eventDescription);
    final isLong = desc.length > 80;
    final display = (!isExp && isLong) ? '${desc.substring(0, 80)}...' : desc;

    return _Card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(event.eventImage, width: 130, height: 150, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(width: 130, height: 150,
                    color: Colors.grey[200], child: const Icon(Icons.image_not_supported, color: Colors.grey)),
                loadingBuilder: (_, child, prog) => prog == null ? child :
                    Container(width: 130, height: 150, color: Colors.grey[100],
                        child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF8B0045))))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(event.eventName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('${_fmtDate(event.eventFromDate, event.eventFromTime)}  –  ${_fmtDate(event.eventToDate, event.eventToTime)}',
                style: const TextStyle(fontSize: 11, color: Colors.black54)),
            const SizedBox(height: 6),
            if (event.formattedAddress.isNotEmpty)
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.location_on, size: 14, color: Color(0xFF8B0045)),
                const SizedBox(width: 3),
                Expanded(child: Text(event.formattedAddress, style: const TextStyle(fontSize: 11, color: Colors.black87))),
              ]),
            const SizedBox(height: 6),
            if (event.eventEmail.isNotEmpty)
              Text('contacted by:- ${event.eventEmail}', style: const TextStyle(fontSize: 11, color: Colors.black54)),
          ])),
        ]),
        const SizedBox(height: 12),
        const Text('Description', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(display, style: const TextStyle(fontSize: 12, color: Color(0xFFD81B60))),
        if (isLong) ...[
          const SizedBox(height: 4),
          GestureDetector(
            // onTap: () => ref.read(descriptionExpandedProvider.notifier).state = !isExp,
            onTap: () {
  ref.read(descriptionExpandedProvider.notifier).toggle();
},
            child: Text(isExp ? 'Show Less' : 'Show More...',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
          ),
        ],
      ]),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// SECTION 7 — GUEST SECTION
// ═════════════════════════════════════════════════════════════════════════════

class _GuestSection extends ConsumerWidget {
  const _GuestSection();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gs = ref.watch(guestListProvider);
    return _Card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Checkbox(value: false, activeColor: const Color(0xFF8B0045), onChanged: (_) {}),
          const Flexible(child: Text('Click here to generate your information',
              style: TextStyle(fontSize: 13))),
        ]),
        const SizedBox(height: 8),
        Wrap(spacing: 10, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
          const Text('Add Guest:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFD81B60))),
          _GuestBtn(icon: Icons.person, label: 'Single', onTap: () => ref.read(guestListProvider.notifier).addSingle()),
          _GuestBtn(icon: Icons.people, label: 'Couple', onTap: () => ref.read(guestListProvider.notifier).addCouple()),
        ]),
        const SizedBox(height: 12),
        ...gs.singleGuests.asMap().entries.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _SingleGuestCard(guest: e.value, index: e.key + 1, sv: gs.showValidation),
        )),
        ...gs.coupleGuests.asMap().entries.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _CoupleGuestCard(guest: e.value, index: e.key + 1, sv: gs.showValidation),
        )),
        if (gs.singleGuests.isNotEmpty || gs.coupleGuests.isNotEmpty) ...[
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (ref.read(guestListProvider.notifier).validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Guests added!'), backgroundColor: Color(0xFF8B0045)));
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A0A2E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 14)),
              child: const Text('Add Guests to the List', style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ),
        ],
      ]),
    );
  }
}

class _GuestBtn extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _GuestBtn({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
    onPressed: onTap,
    icon: Icon(icon, size: 15, color: Colors.white),
    label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A0A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10)),
  );
}

// ── Single Guest Card ─────────────────────────────────────────────────────────
class _SingleGuestCard extends ConsumerStatefulWidget {
  final SingleGuest guest; final int index; final bool sv;
  const _SingleGuestCard({required this.guest, required this.index, required this.sv});
  @override ConsumerState<_SingleGuestCard> createState() => _SingleGuestCardState();
}
class _SingleGuestCardState extends ConsumerState<_SingleGuestCard> {
  late final TextEditingController _u, _fn, _e, _p;
  @override void initState() { super.initState();
    _u = TextEditingController(text: widget.guest.username);
    _fn = TextEditingController(text: widget.guest.fullName);
    _e = TextEditingController(text: widget.guest.email);
    _p = TextEditingController(text: widget.guest.phone);
  }
  @override void dispose() { _u.dispose(); _fn.dispose(); _e.dispose(); _p.dispose(); super.dispose(); }
  void _upd() => ref.read(guestListProvider.notifier).updateSingle(widget.guest.id,
      widget.guest.copyWith(username: _u.text, fullName: _fn.text, email: _e.text, phone: _p.text));
  @override
  Widget build(BuildContext context) {
    final sv = widget.sv;
    return Container(
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFF4FC3F7), width: 1.2),
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('Add New Single Guest #${widget.index}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
          _DelBtn(onTap: () => ref.read(guestListProvider.notifier).removeSingle(widget.guest.id)),
        ]),
        const SizedBox(height: 10),
        _Field('Username', 'Enter Username', _u, (_) => _upd(), sv && _u.text.trim().isEmpty),
        const SizedBox(height: 8),
        _Field('Full Name', 'Enter Full Name', _fn, (_) => _upd(), sv && _fn.text.trim().isEmpty, info: true),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: _Field('Email', 'Email', _e, (_) => _upd(), sv && _e.text.trim().isEmpty, keyboard: TextInputType.emailAddress)),
          const SizedBox(width: 8),
          Expanded(child: _Field('Phone', 'Phone No.', _p, (_) => _upd(), sv && _p.text.trim().isEmpty, keyboard: TextInputType.phone)),
        ]),
        const SizedBox(height: 8),
        _FilePicker('Id Proof', sv && widget.guest.idProofPath == null, widget.guest.idProofPath,
            (path) => ref.read(guestListProvider.notifier).updateSingle(widget.guest.id, widget.guest.copyWith(idProofPath: path))),
      ]),
    );
  }
}

// ── Couple Guest Card ─────────────────────────────────────────────────────────
class _CoupleGuestCard extends ConsumerStatefulWidget {
  final CoupleGuest guest; final int index; final bool sv;
  const _CoupleGuestCard({required this.guest, required this.index, required this.sv});
  @override ConsumerState<_CoupleGuestCard> createState() => _CoupleGuestCardState();
}
class _CoupleGuestCardState extends ConsumerState<_CoupleGuestCard> {
  late final TextEditingController _u1, _fn1, _e1, _p1, _u2, _fn2, _e2, _p2;
  @override void initState() { super.initState();
    _u1 = TextEditingController(text: widget.guest.username1);
    _fn1 = TextEditingController(text: widget.guest.fullName1);
    _e1 = TextEditingController(text: widget.guest.email1);
    _p1 = TextEditingController(text: widget.guest.phone1);
    _u2 = TextEditingController(text: widget.guest.username2);
    _fn2 = TextEditingController(text: widget.guest.fullName2);
    _e2 = TextEditingController(text: widget.guest.email2);
    _p2 = TextEditingController(text: widget.guest.phone2);
  }
  @override void dispose() {
    _u1.dispose(); _fn1.dispose(); _e1.dispose(); _p1.dispose();
    _u2.dispose(); _fn2.dispose(); _e2.dispose(); _p2.dispose();
    super.dispose();
  }
  void _upd() => ref.read(guestListProvider.notifier).updateCouple(widget.guest.id,
      widget.guest.copyWith(username1: _u1.text, fullName1: _fn1.text, email1: _e1.text, phone1: _p1.text,
          username2: _u2.text, fullName2: _fn2.text, email2: _e2.text, phone2: _p2.text));
  @override
  Widget build(BuildContext context) {
    final sv = widget.sv;
    return Container(
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFF4FC3F7), width: 1.2),
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('Add New Couple Guest #${widget.index}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF4FC3F7)))),
          _DelBtn(onTap: () => ref.read(guestListProvider.notifier).removeCouple(widget.guest.id)),
        ]),
        const SizedBox(height: 10),
        const _Label('MEMBER 1'),
        const SizedBox(height: 6),
        _Field('Username', 'Enter Username', _u1, (_) => _upd(), sv && _u1.text.trim().isEmpty),
        const SizedBox(height: 6),
        _Field('Full Name', 'Enter Full Name', _fn1, (_) => _upd(), sv && _fn1.text.trim().isEmpty, info: true),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(child: _Field('Email', 'E-mail', _e1, (_) => _upd(), sv && _e1.text.trim().isEmpty, keyboard: TextInputType.emailAddress)),
          const SizedBox(width: 8),
          Expanded(child: _Field('Phone', 'Phone', _p1, (_) => _upd(), sv && _p1.text.trim().isEmpty, keyboard: TextInputType.phone)),
        ]),
        const SizedBox(height: 6),
        _FilePicker('Id Proof (Member 1)', sv && widget.guest.idProofPath1 == null, widget.guest.idProofPath1,
            (p) => ref.read(guestListProvider.notifier).updateCouple(widget.guest.id, widget.guest.copyWith(idProofPath1: p))),
        const SizedBox(height: 12),
        const Divider(color: Color(0xFFEEEEEE)),
        const SizedBox(height: 8),
        const _Label('MEMBER 2'),
        const SizedBox(height: 6),
        _Field('Username', 'Username', _u2, (_) => _upd(), false),
        const SizedBox(height: 6),
        _Field('Full Name', 'Enter Full Name', _fn2, (_) => _upd(), sv && _fn2.text.trim().isEmpty, info: true),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(child: _Field('Email', 'E-mail', _e2, (_) => _upd(), sv && _e2.text.trim().isEmpty, keyboard: TextInputType.emailAddress)),
          const SizedBox(width: 8),
          Expanded(child: _Field('Phone', 'Phone', _p2, (_) => _upd(), sv && _p2.text.trim().isEmpty, keyboard: TextInputType.phone)),
        ]),
        const SizedBox(height: 6),
        _FilePicker('Id Proof (Member 2)', sv && widget.guest.idProofPath2 == null, widget.guest.idProofPath2,
            (p) => ref.read(guestListProvider.notifier).updateCouple(widget.guest.id, widget.guest.copyWith(idProofPath2: p))),
        const SizedBox(height: 10),
        Align(alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () => ref.read(guestListProvider.notifier).removeCouple(widget.guest.id),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD32F2F),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
            child: const Text('Remove', style: TextStyle(color: Colors.white, fontSize: 13)),
          ),
        ),
      ]),
    );
  }
}

// ── Shared tiny widgets ───────────────────────────────────────────────────────
class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override Widget build(BuildContext context) => Text(text,
      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.black45, letterSpacing: 0.8));
}

class _Field extends StatelessWidget {
  final String label, hint;
  final TextEditingController ctrl;
  final ValueChanged<String> onChange;
  final bool showErr, info;
  final TextInputType keyboard;
  const _Field(this.label, this.hint, this.ctrl, this.onChange, this.showErr,
      {this.info = false, this.keyboard = TextInputType.text});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [
      Flexible(child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87))),
      if (info) const SizedBox(width: 3),
      if (info) const Icon(Icons.info_outline, size: 12, color: Colors.black45),
    ]),
    const SizedBox(height: 3),
    TextField(controller: ctrl, onChanged: onChange, keyboardType: keyboard,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: hint, hintStyle: const TextStyle(fontSize: 12, color: Colors.black38),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFFCCCCCC))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFFCCCCCC))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFF8B0045), width: 1.5)),
        )),
    if (showErr) ...[const SizedBox(height: 2), const Text('This Field is required', style: TextStyle(fontSize: 10, color: Color(0xFFD32F2F)))],
  ]);
}

class _FilePicker extends StatelessWidget {
  final String label;
  final bool showErr;
  final String? path;
  final ValueChanged<String> onPicked;
  const _FilePicker(this.label, this.showErr, this.path, this.onPicked);
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [
      Flexible(child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87))),
      const SizedBox(width: 3),
      const Icon(Icons.info_outline, size: 12, color: Colors.black45),
    ]),
    const SizedBox(height: 3),
    GestureDetector(
      onTap: () => onPicked('selected_file.jpg'),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCCCCCC)), borderRadius: BorderRadius.circular(6)),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: const BoxDecoration(border: Border(right: BorderSide(color: Color(0xFFCCCCCC)))),
            child: const Text('Choose file', style: TextStyle(fontSize: 11, color: Colors.black87)),
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(path != null ? path!.split('/').last : 'No file chosen',
                style: const TextStyle(fontSize: 11, color: Colors.black45), overflow: TextOverflow.ellipsis),
          )),
        ]),
      ),
    ),
    if (showErr) ...[const SizedBox(height: 2), const Text('This Field is required', style: TextStyle(fontSize: 10, color: Color(0xFFD32F2F)))],
  ]);
}

class _DelBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _DelBtn({required this.onTap});
  @override Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(width: 32, height: 32,
        decoration: BoxDecoration(color: const Color(0xFFD32F2F), borderRadius: BorderRadius.circular(6)),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 18)),
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// SECTION 8 — ROOM PACKAGE SECTION  (horizontal scrollable cards, NO overflow)
// ═════════════════════════════════════════════════════════════════════════════

class _RoomPackageSection extends ConsumerWidget {
  final List<RoomData> rooms;
  const _RoomPackageSection({required this.rooms});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantities = ref.watch(roomQuantityProvider);
    // 82% of screen width → next card always peeks
    final cardW = (MediaQuery.of(context).size.width * 0.82).clamp(240.0, 340.0);

    return _Card(
      padding: EdgeInsets.zero,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── Header ──────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
          child: Row(children: const [
            Expanded(child: Text('Choose Your Beat Flirt Package',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87))),
            SizedBox(width: 6),
            Icon(Icons.swipe, size: 15, color: Colors.black38),
            SizedBox(width: 2),
            Text('swipe', style: TextStyle(fontSize: 11, color: Colors.black38)),
          ]),
        ),

        // ── Scrollable cards ─────────────────────────────────────────────
        // Key insight: use IntrinsicHeight so card height = content height
        // Wrap in SingleChildScrollView(horizontal) for scroll
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rooms.asMap().entries.map((entry) {
              final room = entry.value;
              final qty = quantities[room.id] ?? 0;
              final amount = qty * (double.tryParse(room.price) ?? 0);
              final isSelected = qty > 0;

              return Padding(
                padding: EdgeInsets.only(right: entry.key < rooms.length - 1 ? 12 : 0),
                child: SizedBox(
                  width: cardW,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF8B0045) : const Color(0xFFE0E0E0),
                        width: isSelected ? 1.8 : 1.0,
                      ),
                      boxShadow: [BoxShadow(
                        color: isSelected
                            ? const Color(0xFF8B0045).withOpacity(0.12)
                            : Colors.black.withOpacity(0.05),
                        blurRadius: 8, offset: const Offset(0, 2),
                      )],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // ✅ KEY: shrink to content
                      children: [
                        // Room image
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                          child: Image.network(
                            room.roomImage,
                            width: double.infinity,
                            height: 140,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: double.infinity, height: 140, color: Colors.grey[200],
                              child: const Icon(Icons.bed, color: Colors.grey, size: 40)),
                            loadingBuilder: (_, child, prog) => prog == null ? child :
                                Container(width: double.infinity, height: 140, color: Colors.grey[100],
                                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF8B0045)))),
                          ),
                        ),

                        // Card body — all natural height, no Expanded/Spacer
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Room name
                              Text(room.roomName,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                  maxLines: 2, overflow: TextOverflow.ellipsis),
                              if (room.shortDescription.isNotEmpty) ...[
                                const SizedBox(height: 3),
                                Text(room.shortDescription,
                                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                                    maxLines: 2, overflow: TextOverflow.ellipsis),
                              ],
                              const SizedBox(height: 10),

                              // Price + Fee badges
                              Row(children: [
                                _Badge(label: 'Price', value: '\$${room.price}', primary: true),
                                const SizedBox(width: 8),
                                _Badge(label: 'Fee', value: '\$${room.fee}', primary: false),
                              ]),
                              const SizedBox(height: 12),

                              // QTY stepper + Total — mainAxisAlignment spaceBetween, NO Spacer
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Stepper
                                  Row(mainAxisSize: MainAxisSize.min, children: [
                                    const Text('QTY:', style: TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.w600)),
                                    const SizedBox(width: 6),
                                    _Stepper(
                                      value: qty,
                                      max: int.tryParse(room.roomAvailable) ?? 10,
                                      onChanged: (v) => ref.read(roomQuantityProvider.notifier).setQuantity(room.id, v),
                                    ),
                                  ]),
                                  // Total
                                  Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [
                                    const Text('TOTAL', style: TextStyle(fontSize: 9, color: Colors.black45, letterSpacing: 0.4)),
                                    Text(
                                      '\$${amount == 0 ? '0' : amount.toStringAsFixed(0)}',
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                                          color: isSelected ? const Color(0xFF8B0045) : Colors.black54),
                                    ),
                                  ]),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // ── Dot indicators ───────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rooms.asMap().entries.map((e) {
              final selected = (quantities[e.value.id] ?? 0) > 0;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: selected ? 20 : 6, height: 6,
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFF8B0045) : Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }).toList(),
          ),
        ),
      ]),
    );
  }
}

// ── Price badge ───────────────────────────────────────────────────────────────
class _Badge extends StatelessWidget {
  final String label, value;
  final bool primary;
  const _Badge({required this.label, required this.value, required this.primary});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: primary ? const Color(0xFF8B0045).withOpacity(0.08) : const Color(0xFFF3F3F3),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      Text(label, style: TextStyle(fontSize: 9, color: primary ? const Color(0xFF8B0045) : Colors.black45)),
      Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold,
          color: primary ? const Color(0xFF8B0045) : Colors.black54)),
    ]),
  );
}

// ── +/- Stepper ───────────────────────────────────────────────────────────────
class _Stepper extends StatelessWidget {
  final int value, max;
  final ValueChanged<int> onChanged;
  const _Stepper({required this.value, required this.max, required this.onChanged});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    _SBtn(Icons.remove, value > 0, () => onChanged(value - 1)),
    SizedBox(width: 28, child: Text('$value',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87))),
    _SBtn(Icons.add, value < max, () => onChanged(value + 1)),
  ]);
}

class _SBtn extends StatelessWidget {
  final IconData icon; final bool enabled; final VoidCallback onTap;
  const _SBtn(this.icon, this.enabled, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: enabled ? onTap : null,
    child: Container(
      width: 28, height: 28,
      decoration: BoxDecoration(
        color: enabled ? const Color(0xFF8B0045).withOpacity(0.10) : Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: enabled ? const Color(0xFF8B0045).withOpacity(0.3) : Colors.grey[300]!),
      ),
      child: Icon(icon, size: 14, color: enabled ? const Color(0xFF8B0045) : Colors.grey[400]),
    ),
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// SECTION 9 — ADDITIONAL NIGHT SECTION
// ═════════════════════════════════════════════════════════════════════════════

class _NightSection extends ConsumerWidget {
  final List<AdditionalNight> nights;
  final String price, fee;
  const _NightSection({required this.nights, required this.price, required this.fee});

  String _fmt(String d) {
    try {
      final p = d.split('-');
      const m = ['','January','February','March','April','May','June',
          'July','August','September','October','November','December'];
      return '${m[int.tryParse(p[1]) ?? 0]} ${int.tryParse(p[2]) ?? 0}, ${p[0]}';
    } catch (_) { return d; }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qtys = ref.watch(nightQuantityProvider);
    return _Card(
      padding: EdgeInsets.zero,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(padding: EdgeInsets.fromLTRB(14,14,14,2),
            child: Text('Select Additional Room Night Options',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87))),
        const Padding(padding: EdgeInsets.fromLTRB(14,0,14,10),
            child: Text('Quantity will remain the same as added to the event.',
                style: TextStyle(fontSize: 11, color: Color(0xFFD81B60), fontStyle: FontStyle.italic))),
        // header
        Container(color: const Color(0xFFF5F5F5),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          child: Row(children: const [
            SizedBox(width: 56, child: _Lbl('QTY')),
            Expanded(child: _Lbl('DATE')),
            SizedBox(width: 50, child: _Lbl('PRICE', center: true)),
            SizedBox(width: 38, child: _Lbl('FEE', center: true)),
            SizedBox(width: 42, child: _Lbl('AMT', right: true)),
          ]),
        ),
        const Divider(height: 1),
        ...nights.asMap().entries.map((entry) {
          final n = entry.value;
          final isLast = entry.key == nights.length - 1;
          final qty = qtys[n.date] ?? 0;
          final amt = qty * (double.tryParse(price) ?? 0);
          return Column(children: [
            Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                SizedBox(width: 56,
                    child: _QDrop(value: qty, max: 10,
                        onChanged: (v) => ref.read(nightQuantityProvider.notifier).setQuantity(n.date, v))),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, children: [
                  Text(n.day, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                  Text(_fmt(n.date), style: const TextStyle(fontSize: 11, color: Colors.black54)),
                ])),
                SizedBox(width: 50, child: Text('\$$price',
                    style: const TextStyle(fontSize: 12, color: Colors.black87), textAlign: TextAlign.center)),
                SizedBox(width: 38, child: Text('\$$fee',
                    style: const TextStyle(fontSize: 12, color: Colors.black87), textAlign: TextAlign.center)),
                SizedBox(width: 42, child: Text('\$${amt == 0 ? '0' : amt.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
              ]),
            ),
            if (!isLast) const Divider(height: 1, indent: 12, endIndent: 12),
          ]);
        }),
        const SizedBox(height: 8),
      ]),
    );
  }
}

class _Lbl extends StatelessWidget {
  final String text; final bool center, right;
  const _Lbl(this.text, {this.center = false, this.right = false});
  @override Widget build(BuildContext context) => Text(text,
      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.3),
      textAlign: right ? TextAlign.right : center ? TextAlign.center : TextAlign.left,
      maxLines: 1);
}

class _QDrop extends StatelessWidget {
  final int value, max;
  final ValueChanged<int> onChanged;
  const _QDrop({required this.value, required this.max, required this.onChanged});
  @override
  Widget build(BuildContext context) => Container(
    height: 34, margin: const EdgeInsets.only(right: 6),
    decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCCCCCC)),
        borderRadius: BorderRadius.circular(6), color: Colors.white),
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: DropdownButtonHideUnderline(child: DropdownButton<int>(
      value: value, isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down, size: 14),
      style: const TextStyle(fontSize: 13, color: Colors.black87),
      onChanged: (v) { if (v != null) onChanged(v); },
      items: List.generate(max + 1, (i) => i)
          .map((i) => DropdownMenuItem(value: i, child: Text('$i'))).toList(),
    )),
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// SECTION 10 — ORDER SUMMARY
// ═════════════════════════════════════════════════════════════════════════════

class _OrderSummarySection extends ConsumerStatefulWidget {
  final List<RoomData> rooms;
  final List<AdditionalNight> nights;
  final String price, fee;
  const _OrderSummarySection({required this.rooms, required this.nights,
      required this.price, required this.fee});
  @override ConsumerState<_OrderSummarySection> createState() => _OrderSummarySectionState();
}
class _OrderSummarySectionState extends ConsumerState<_OrderSummarySection> {
  final _vCtrl = TextEditingController();
  @override void dispose() { _vCtrl.dispose(); super.dispose(); }

  double _subTotal() {
    final rq = ref.read(roomQuantityProvider);
    final nq = ref.read(nightQuantityProvider);
    double t = 0;
    for (final r in widget.rooms) t += (rq[r.id] ?? 0) * (double.tryParse(r.price) ?? 0);
    for (final n in widget.nights) t += (nq[n.date] ?? 0) * (double.tryParse(widget.price) ?? 0);
    return t;
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(roomQuantityProvider); ref.watch(nightQuantityProvider);
    final pt = ref.watch(paymentTypeProvider);
    final md = ref.watch(membershipDiscountProvider);
    final vd = ref.watch(voucherDiscountProvider);
    final sub = _subTotal();
    final total = (sub - md - vd).clamp(0.0, double.infinity);

    return Column(children: [
      // Payment type
      _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Select Payment Type', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 10),
        Wrap(spacing: 0, runSpacing: 0, children: [
          // _PayOpt('Full Payment', PaymentType.full, pt, (v) => ref.read(paymentTypeProvider.notifier).state = v),
          // _PayOpt('Partial Payment', PaymentType.partial, pt, (v) => ref.read(paymentTypeProvider.notifier).state = v),

          _PayOpt(
  'Full Payment',
  PaymentType.full,
  pt,
  (v) => ref.read(paymentTypeProvider.notifier).setPaymentType(v),
),
_PayOpt(
  'Partial Payment',
  PaymentType.partial,
  pt,
  (v) => ref.read(paymentTypeProvider.notifier).setPaymentType(v),
),
        ]),
      ])),
      const SizedBox(height: 14),
      // Order summary
      Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF4FC3F7), width: 1.2),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))]),
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Order Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: TextField(controller: _vCtrl,
                // onChanged: (v) => ref.read(voucherCodeProvider.notifier).state = v,
                onChanged: (v) {
  ref.read(voucherCodeProvider.notifier).setCode(v);
},
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Enter voucher code',
                  hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFFCCCCCC))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFFCCCCCC))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFF8B0045), width: 1.5)),
                ))),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Voucher applied!'), backgroundColor: Color(0xFF8B0045))),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A0A2E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14)),
              child: const Text('Apply', style: TextStyle(color: Colors.white, fontSize: 13)),
            ),
          ]),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 10),
          _SumRow('Sub Total', '\$${sub == 0 ? '0' : sub.toStringAsFixed(0)}',
              valueColor: sub == 0 ? const Color(0xFF4FC3F7) : Colors.black87),
          const SizedBox(height: 6),
          _SumRow('Membership Discount', '-\$${md.toStringAsFixed(0)}',
              labelColor: const Color(0xFFD81B60), valueColor: const Color(0xFFD81B60)),
          const SizedBox(height: 6),
          _SumRow('Voucher Discount', '-\$${vd.toStringAsFixed(0)}',
              labelColor: const Color(0xFF2E7D32), valueColor: const Color(0xFF2E7D32)),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          _SumRow('Total', '\$${total.toStringAsFixed(0)}', bold: true, large: true),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity,
            child: ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Processing your ticket...'), backgroundColor: Color(0xFF8B0045))),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A0A2E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('BUY TICKET', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ),
          ),
        ]),
      ),
    ]);
  }
}

class _SumRow extends StatelessWidget {
  final String label, value;
  final Color labelColor, valueColor;
  final bool bold, large;
  const _SumRow(this.label, this.value,
      {this.labelColor = Colors.black87, this.valueColor = Colors.black87,
       this.bold = false, this.large = false});
  @override
  Widget build(BuildContext context) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(label, style: TextStyle(fontSize: large ? 17 : 14, color: labelColor,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
    Text(value, style: TextStyle(fontSize: large ? 17 : 14, color: valueColor,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
  ]);
}

class _PayOpt extends StatelessWidget {
  final String label; final PaymentType value; final PaymentType? group;
  final ValueChanged<PaymentType?> onChange;
  const _PayOpt(this.label, this.value, this.group, this.onChange);
  @override
  Widget build(BuildContext context) => IntrinsicWidth(child: Row(mainAxisSize: MainAxisSize.min, children: [
    Radio<PaymentType>(value: value, groupValue: group, activeColor: const Color(0xFF8B0045),
        onChanged: onChange, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact),
    Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87)),
    const SizedBox(width: 8),
  ]));
}

// ═════════════════════════════════════════════════════════════════════════════
// SHARED: Card container
// ═════════════════════════════════════════════════════════════════════════════

class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const _Card({required this.child, this.padding});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
    ),
    padding: padding ?? const EdgeInsets.all(14),
    child: child,
  );
}
