import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatflirt/Api_services/api_service.dart';
import 'package:beatflirt/core/services/auth_services.dart';
import 'package:beatflirt/model/notification_model.dart';

class NotificationState {
  final List<NotificationModel> notifications;
  final bool isLoading;
  final String? error;

  NotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.error,
  });

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    String? error,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class NotificationNotifier extends Notifier<NotificationState> {
  final ApiService _api = ApiService();

  @override
  NotificationState build() {
    Future.microtask(() => fetchNotifications());
    return NotificationState(isLoading: true);
  }

  Future<void> fetchNotifications() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        state = state.copyWith(isLoading: false, error: 'Unauthorized');
        return;
      }

      final notifications = await _api.getAllNotifications(token: token);
      state = state.copyWith(
        isLoading: false,
        notifications: notifications,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return;

      await _api.markNotificationRead(token: token, notificationId: id);
      
      state = state.copyWith(
        notifications: state.notifications.map((n) {
          if (n.id == id) {
            return n.copyWith(status: '0'); // '0' for read
          }
          return n;
        }).toList(),
      );
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  Future<void> clearAll() async {
    state = state.copyWith(isLoading: true);
    try {
      final token = await AuthService.getToken();
      if (token == null) return;

      await _api.clearNotifications(token: token);
      state = state.copyWith(isLoading: false, notifications: []);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final notificationProvider = NotifierProvider<NotificationNotifier, NotificationState>(NotificationNotifier.new);

