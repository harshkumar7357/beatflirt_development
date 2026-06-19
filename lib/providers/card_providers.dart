// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Provider family to manage expansion state for each card by index
// Changed from Provider to StateProvider so that it can be modified.
final cardExpansionProvider = StateProvider.family<bool, int>((ref, index) => false);

// Alternative: If you need to manage by card ID/title instead of index
final cardExpansionByIdProvider = StateProvider.family<bool, String>((ref, cardId) => false);
