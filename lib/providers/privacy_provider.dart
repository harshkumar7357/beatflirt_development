import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Api_services/api_services.dart';
import '../core/services/auth_services.dart';

class PrivacyState {
  final bool showOnlineStatus;
  final bool showProfileToPublic;
  final bool allowMessagesFromStrangers;
  final bool showLastSeen;
  final bool hideFromSearch;

  const PrivacyState({
    this.showOnlineStatus = true,
    this.showProfileToPublic = true,
    this.allowMessagesFromStrangers = true,
    this.showLastSeen = true,
    this.hideFromSearch = false,
  });

  PrivacyState copyWith({
    bool? showOnlineStatus,
    bool? showProfileToPublic,
    bool? allowMessagesFromStrangers,
    bool? showLastSeen,
    bool? hideFromSearch,
  }) {
    return PrivacyState(
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      showProfileToPublic: showProfileToPublic ?? this.showProfileToPublic,
      allowMessagesFromStrangers: allowMessagesFromStrangers ?? this.allowMessagesFromStrangers,
      showLastSeen: showLastSeen ?? this.showLastSeen,
      hideFromSearch: hideFromSearch ?? this.hideFromSearch,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'showOnlineStatus': showOnlineStatus,
      'showProfileToPublic': showProfileToPublic,
      'allowMessagesFromStrangers': allowMessagesFromStrangers,
      'showLastSeen': showLastSeen,
      'hideFromSearch': hideFromSearch,
    };
  }

  factory PrivacyState.fromJson(Map<String, dynamic> json) {
    return PrivacyState(
      showOnlineStatus: json['showOnlineStatus'] ?? true,
      showProfileToPublic: json['showProfileToPublic'] ?? true,
      allowMessagesFromStrangers: json['allowMessagesFromStrangers'] ?? true,
      showLastSeen: json['showLastSeen'] ?? true,
      hideFromSearch: json['hideFromSearch'] ?? false,
    );
  }
}

class PrivacyNotifier extends Notifier<PrivacyState> {
  final ApiServices _apiServices = ApiServices();

  @override
  PrivacyState build() {
    _loadPrivacySettings();
    return const PrivacyState();
  }

  Future<void> _loadPrivacySettings() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return;
      
      final profile = await _apiServices.getProfile(token: token);
      if (profile['user'] != null && profile['user']['privacy'] != null) {
        state = PrivacyState.fromJson(profile['user']['privacy']);
      }
    } catch (e) {
      // Handle error if needed
    }
  }

  Future<void> _updatePrivacy(PrivacyState newState) async {
    state = newState;
    try {
      final token = await AuthService.getToken();
      if (token != null) {
        await _apiServices.updatePrivacy(token: token, privacy: newState.toJson());
      }
    } catch (e) {
      // Optional: Revert state or show error
    }
  }

  void toggleOnlineStatus() => _updatePrivacy(state.copyWith(showOnlineStatus: !state.showOnlineStatus));
  void toggleProfilePublic() => _updatePrivacy(state.copyWith(showProfileToPublic: !state.showProfileToPublic));
  void toggleMessages() => _updatePrivacy(state.copyWith(allowMessagesFromStrangers: !state.allowMessagesFromStrangers));
  void toggleLastSeen() => _updatePrivacy(state.copyWith(showLastSeen: !state.showLastSeen));
  void toggleSearchHide() => _updatePrivacy(state.copyWith(hideFromSearch: !state.hideFromSearch));
}

final privacyProvider = NotifierProvider<PrivacyNotifier, PrivacyState>(PrivacyNotifier.new);
