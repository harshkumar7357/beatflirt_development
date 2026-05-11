import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Album Item Model
class AlbumItem {
  const AlbumItem({
    required this.path,
    required this.approved,
    required this.title,
    this.xFile,
  });

  final String path;
  final bool approved;
  final String title;
  final XFile? xFile;

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'approved': approved,
      'title': title,
      'isLocal': xFile != null,
    };
  }

  factory AlbumItem.fromJson(Map<String, dynamic> json) {
    final path = (json['path'] ?? '').toString();
    final isLocal = json['isLocal'] == true;
    return AlbumItem(
      path: path,
      approved: json['approved'] == true,
      title: (json['title'] ?? 'Album Photo').toString(),
      xFile: isLocal && path.isNotEmpty ? XFile(path) : null,
    );
  }

  AlbumItem copyWith({
    String? path,
    bool? approved,
    String? title,
    XFile? xFile,
  }) {
    return AlbumItem(
      path: path ?? this.path,
      approved: approved ?? this.approved,
      title: title ?? this.title,
      xFile: xFile ?? this.xFile,
    );
  }
}

// Tab selection provider (approved/pending)
final albumTabProvider = StateProvider<bool>((ref) => false);

// Pending albums provider
final pendingAlbumsProvider = NotifierProvider<PendingAlbumsNotifier, List<AlbumItem>>(
  PendingAlbumsNotifier.new,
);

// Approved albums provider
final approvedAlbumsProvider = NotifierProvider<ApprovedAlbumsNotifier, List<AlbumItem>>(
  ApprovedAlbumsNotifier.new,
);

// ✅ Updated for Riverpod 3.x
class PendingAlbumsNotifier extends Notifier<List<AlbumItem>> {
  static const String _storageKey = 'profile_album_pending';

  @override
  List<AlbumItem> build() {
    _loadFromStorage();
    return [
      const AlbumItem(
        path: 'assets/images/notification-image1.jpg',
        approved: false,
        title: 'Weekend Party',
      ),
      const AlbumItem(
        path: 'assets/images/notification-image5.jpg',
        approved: false,
        title: 'Beach Night',
      ),
    ];
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return;

      final items = decoded
          .whereType<Map>()
          .map((e) => AlbumItem.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      if (items.isNotEmpty) {
        state = items;
      }
    } catch (_) {
      // Keep default state on error
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(state.map((e) => e.toJson()).toList()),
    );
  }

  void addAlbum(AlbumItem item) {
    state = [item, ...state];
    _persist();
  }

  void removeAlbum(AlbumItem item) {
    state = state.where((e) => e != item).toList();
    _persist();
  }

  void clear() {
    state = [];
    _persist();
  }
}

// ✅ Updated for Riverpod 3.x
class ApprovedAlbumsNotifier extends Notifier<List<AlbumItem>> {
  static const String _storageKey = 'profile_album_approved';

  @override
  List<AlbumItem> build() {
    _loadFromStorage();
    return [
      const AlbumItem(
        path: 'assets/images/notification-image4.jpg',
        approved: true,
        title: 'Main Album',
      ),
    ];
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return;

      final items = decoded
          .whereType<Map>()
          .map((e) => AlbumItem.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      if (items.isNotEmpty) {
        state = items;
      }
    } catch (_) {
      // Keep default state on error
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(state.map((e) => e.toJson()).toList()),
    );
  }

  void addAlbum(AlbumItem item) {
    state = [item, ...state];
    _persist();
  }

  void removeAlbum(AlbumItem item) {
    state = state.where((e) => e != item).toList();
    _persist();
  }

  void clear() {
    state = [];
    _persist();
  }
}