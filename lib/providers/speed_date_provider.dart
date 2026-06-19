import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatflirt/Api_services/api_services.dart';
import 'package:beatflirt/core/services/auth_services.dart';

class SpeedDateSession {
  final String id;
  final String name;
  final int activeCount;
  final String? description;

  SpeedDateSession({
    required this.id,
    required this.name,
    required this.activeCount,
    this.description,
  });

  factory SpeedDateSession.fromMap(Map<String, dynamic> map) {
    return SpeedDateSession(
      id: map['_id'] ?? map['id'] ?? '',
      name: map['name'] ?? 'Unknown Session',
      activeCount: map['activeCount'] is int ? map['activeCount'] : int.tryParse(map['activeCount']?.toString() ?? '0') ?? 0,
      description: map['description'],
    );
  }
}

class SpeedDateState {
  final List<SpeedDateSession> sessions;
  final bool isLoading;
  final String? error;

  SpeedDateState({
    this.sessions = const [],
    this.isLoading = false,
    this.error,
  });

  SpeedDateState copyWith({
    List<SpeedDateSession>? sessions,
    bool? isLoading,
    String? error,
  }) {
    return SpeedDateState(
      sessions: sessions ?? this.sessions,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class SpeedDateNotifier extends Notifier<SpeedDateState> {
  final ApiServices _api = ApiServices();

  @override
  SpeedDateState build() {
    Future.microtask(() => fetchSessions());
    return SpeedDateState(isLoading: true);
  }

  Future<void> fetchSessions() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        state = state.copyWith(isLoading: false, error: 'Unauthorized');
        return;
      }

      final sessionsData = await _api.getSpeedDateSessions(token: token);
      final sessions = sessionsData.map(SpeedDateSession.fromMap).toList();

      state = state.copyWith(
        isLoading: false,
        sessions: sessions,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> joinSession(String sessionId) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return;

      await _api.joinSpeedDateSession(token: token, sessionId: sessionId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> startSpeedMatch() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return;

      await _api.startSpeedMatch(token: token);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }
}

final speedDateProvider = NotifierProvider<SpeedDateNotifier, SpeedDateState>(SpeedDateNotifier.new);
