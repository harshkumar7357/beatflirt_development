import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Api_services/api_service.dart';
import '../core/services/auth_services.dart';
import 'profile_provider.dart';

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
  ApiService get _apiService => ref.read(apiServiceProvider);

  @override
  PrivacyState build() {
    _loadPrivacySettings();
    return const PrivacyState();
  }

  Future<void> _loadPrivacySettings() async {
    try {
      final profileState = ref.read(profileProvider);
      if (profileState.profile != null) {
        // Assuming privacy is part of profile data in the new model or needs a separate fetch
        // For now, let's keep it as is if it's supposed to be in the profile response
        // If it's not in UserProfileModel, we might need a specific endpoint in ApiService
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
        await _apiService.updatePrivacy(token: token, privacy: newState.toJson());
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
