// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter/foundation.dart';
// import 'package:beatflirt/Api_services/api_service.dart';
// import 'package:beatflirt/model/membership_model.dart';
// import 'package:beatflirt/model/user_membership_plan_model.dart';
// import 'package:beatflirt/core/services/auth_services.dart';
// import 'package:flutter_riverpod/legacy.dart';

// class MembershipState {
//   final List<MembershipModel> memberships;
//   final UserMembershipPlanModel? userPlan;
//   final bool isLoading;
//   final String? error;

//   MembershipState({
//     this.memberships = const [],
//     this.userPlan,
//     this.isLoading = false,
//     this.error,
//   });

//   MembershipState copyWith({
//     List<MembershipModel>? memberships,
//     UserMembershipPlanModel? userPlan,
//     bool? isLoading,
//     String? error,
//   }) {
//     return MembershipState(
//       memberships: memberships ?? this.memberships,
//       userPlan: userPlan ?? this.userPlan,
//       isLoading: isLoading ?? this.isLoading,
//       error: error ?? this.error,
//     );
//   }
// }

// class MembershipNotifier extends StateNotifier<MembershipState> {
//   final ApiService _api = ApiService();

//   MembershipNotifier() : super(MembershipState());

//   Future<void> fetchAllMemberships() async {
//     final token = await AuthService.getToken();
//     print('🔵 fetchAllMemberships token → ${token == null ? 'null' : token.length > 20 ? token.substring(0,20) + '...' : token}');
//     state = state.copyWith(isLoading: true, error: null);
//     try {
//       final memberships = await _api.getAllMemberships(token: token);
//       print('🟢 fetchAllMemberships got ${memberships.length} memberships');
//       state = state.copyWith(memberships: memberships, isLoading: false);
//     } catch (e) {
//       print('🔴 fetchAllMemberships error → $e');
//       state = state.copyWith(isLoading: false, error: e.toString());
//     }
//   }

//   Future<void> fetchUserMembershipPlan() async {
//     final token = await AuthService.getToken();
//     if (token == null) return;

//     state = state.copyWith(isLoading: true, error: null);
//     try {
//       final plan = await _api.getUserMembershipPlan(token: token);
//       state = state.copyWith(userPlan: plan, isLoading: false);
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//     }
//   }

//   Future<void> buyMembership({
//     required String membershipId,
//     required String paymentId,
//     required String amount,
//   }) async {
//     final token = await AuthService.getToken();
//     if (token == null) throw Exception('Not authenticated');

//     state = state.copyWith(isLoading: true, error: null);
//     try {
//       await _api.buyMembership(
//         token: token,
//         membershipId: membershipId,
//         paymentId: paymentId,
//         amount: amount,
//       );
//       await fetchUserMembershipPlan(); // Refresh user plan after purchase
//       state = state.copyWith(isLoading: false);
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//       rethrow;
//     }
//   }
// }

// final membershipProvider = StateNotifierProvider<MembershipNotifier, MembershipState>((ref) {
//   return MembershipNotifier();
// });


import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatflirt/Api_services/api_service.dart';
import 'package:beatflirt/core/services/auth_services.dart';
import 'package:beatflirt/model/membership_model.dart';
import 'package:beatflirt/model/user_membership_plan_model.dart';

@immutable
class MembershipState {
  final List<MembershipModel> memberships;
  final UserMembershipPlanModel? userPlan;
  final bool isLoading;
  final String? error;

  const MembershipState({
    this.memberships = const [],
    this.userPlan,
    this.isLoading = false,
    this.error,
  });

  MembershipState copyWith({
    List<MembershipModel>? memberships,
    UserMembershipPlanModel? userPlan,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return MembershipState(
      memberships: memberships ?? this.memberships,
      userPlan: userPlan ?? this.userPlan,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class MembershipNotifier extends Notifier<MembershipState> {
  final ApiService _api = ApiService();

  @override
  MembershipState build() {
    return const MembershipState();
  }

  Future<void> fetchAllMemberships() async {
    final token = await AuthService.getToken();

    debugPrint(
      '🔵 fetchAllMemberships token → '
      '${token == null ? 'null' : token.length > 20 ? '${token.substring(0, 20)}...' : token}',
    );

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final memberships = await _api.getAllMemberships(token: token);

      debugPrint('🟢 fetchAllMemberships got ${memberships.length} memberships');

      state = state.copyWith(
        memberships: memberships,
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      debugPrint('🔴 fetchAllMemberships error → $e');

      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> fetchUserMembershipPlan() async {
    final token = await AuthService.getToken();

    if (token == null) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final plan = await _api.getUserMembershipPlan(token: token);

      state = state.copyWith(
        userPlan: plan,
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> buyMembership({
    required String membershipId,
    required String paymentId,
    required String amount,
  }) async {
    final token = await AuthService.getToken();

    if (token == null) {
      throw Exception('Not authenticated');
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await _api.buyMembership(
        token: token,
        membershipId: membershipId,
        paymentId: paymentId,
        amount: amount,
      );

      await fetchUserMembershipPlan();

      state = state.copyWith(
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );

      rethrow;
    }
  }
}

final membershipProvider =
    NotifierProvider<MembershipNotifier, MembershipState>(
  MembershipNotifier.new,
);