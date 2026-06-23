// import 'dart:async';
// import 'dart:convert';
//
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class MyProfileLocationTab extends StatefulWidget {
//   const MyProfileLocationTab({super.key});
//
//   @override
//   State<MyProfileLocationTab> createState() => _MyProfileLocationTabState();
// }
//
// class _MyProfileLocationTabState extends State<MyProfileLocationTab> {
//   final TextEditingController _searchController = TextEditingController();
//   final List<_LocationSuggestion> _suggestions = [];
//   Timer? _searchDebounce;
//   bool _isLoadingCurrent = false;
//   bool _isSearching = false;
//   String _selectedLocation = 'No location selected';
//   double? _selectedLat;
//   double? _selectedLng;
//   double _distanceKm = 25;
//   bool _showOnlyNearby = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchCurrentLocation();
//   }
//
//   @override
//   void dispose() {
//     _searchDebounce?.cancel();
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: const Color(0xFFE8E0F2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Location Settings',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             'Auto-detect your location or search manually.',
//             style: TextStyle(color: Colors.grey[700]),
//           ),
//           const SizedBox(height: 14),
//           Row(
//             children: [
//               Expanded(
//                 child: OutlinedButton.icon(
//                   onPressed: _isLoadingCurrent ? null : _fetchCurrentLocation,
//                   icon: _isLoadingCurrent
//                       ? const SizedBox(
//                           width: 16,
//                           height: 16,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         )
//                       : const Icon(Icons.my_location),
//                   label: Text(_isLoadingCurrent ? 'Detecting...' : 'Use Current Location'),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           TextField(
//             controller: _searchController,
//             textInputAction: TextInputAction.search,
//             onChanged: _onSearchChanged,
//             onSubmitted: _searchLocations,
//             decoration: InputDecoration(
//               hintText: 'Search location (city, area, address)',
//               suffixIcon: IconButton(
//                 icon: _isSearching
//                     ? const SizedBox(
//                         width: 18,
//                         height: 18,
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       )
//                     : const Icon(Icons.search),
//                 onPressed: _isSearching ? null : () => _searchLocations(_searchController.text),
//               ),
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           if (_suggestions.isNotEmpty)
//             Container(
//               constraints: const BoxConstraints(maxHeight: 220),
//               decoration: BoxDecoration(
//                 border: Border.all(color: const Color(0xFFE8E0F2)),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: ListView.separated(
//                 shrinkWrap: true,
//                 itemCount: _suggestions.length,
//                 separatorBuilder: (_, __) => const Divider(height: 1),
//                 itemBuilder: (context, index) {
//                   final item = _suggestions[index];
//                   return ListTile(
//                     dense: true,
//                     leading: const Icon(Icons.location_on_outlined, size: 18),
//                     title: Text(
//                       item.name,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     onTap: () {
//                       setState(() {
//                         _selectedLocation = item.name;
//                         _selectedLat = item.lat;
//                         _selectedLng = item.lng;
//                         _suggestions.clear();
//                         _searchController.text = item.name;
//                       });
//                     },
//                   );
//                 },
//               ),
//             ),
//           const SizedBox(height: 14),
//           _infoRow(Icons.place_outlined, 'Selected', _selectedLocation),
//           _infoRow(
//             Icons.map_outlined,
//             'Coordinates',
//             _selectedLat == null ? '--' : '${_selectedLat!.toStringAsFixed(5)}, ${_selectedLng!.toStringAsFixed(5)}',
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'Match Distance: ${_distanceKm.round()} km',
//             style: const TextStyle(fontWeight: FontWeight.w600),
//           ),
//           Slider(
//             value: _distanceKm,
//             min: 5,
//             max: 200,
//             divisions: 39,
//             activeColor: const Color(0xFF220027),
//             onChanged: (v) => setState(() => _distanceKm = v),
//           ),
//           SwitchListTile(
//             value: _showOnlyNearby,
//             onChanged: (v) => setState(() => _showOnlyNearby = v),
//             contentPadding: EdgeInsets.zero,
//             title: const Text('Show only nearby matches'),
//           ),
//           const SizedBox(height: 10),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Location preferences updated')),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF220027),
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
//               ),
//               child: const Text('Save Location'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _infoRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, size: 16, color: Colors.black54),
//           const SizedBox(width: 8),
//           Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(color: Colors.grey[800]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _fetchCurrentLocation() async {
//     setState(() => _isLoadingCurrent = true);
//     try {
//       final serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         await Geolocator.openLocationSettings();
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Turn on GPS/location service and try again.')),
//         );
//         return;
//       }
//
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//       if (permission == LocationPermission.denied) {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Location permission denied. Please allow access.')),
//         );
//         return;
//       }
//       if (permission == LocationPermission.deniedForever) {
//         await Geolocator.openAppSettings();
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Location permission is permanently denied. Enable it in app settings.')),
//         );
//         return;
//       }
//
//       Position? pos;
//       try {
//         pos = await Geolocator.getCurrentPosition(
//           locationSettings: const LocationSettings(
//             accuracy: LocationAccuracy.best,
//             timeLimit: Duration(seconds: 12),
//           ),
//         );
//       } catch (_) {
//         try {
//           pos = await Geolocator.getCurrentPosition(
//             locationSettings: const LocationSettings(
//               accuracy: LocationAccuracy.low,
//               timeLimit: Duration(seconds: 12),
//             ),
//           );
//         } catch (_) {
//           pos = await Geolocator.getLastKnownPosition();
//         }
//       }
//       if (pos == null) {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Unable to get current GPS position. Move outdoors and try again.')),
//         );
//         return;
//       }
//       final currentPos = pos;
//
//       String locationLabel = 'Current location detected';
//       try {
//         final marks = await placemarkFromCoordinates(currentPos.latitude, currentPos.longitude);
//         final place = marks.isNotEmpty ? marks.first : null;
//         final label = [
//           place?.locality,
//           place?.administrativeArea,
//           place?.country,
//         ].where((e) => e != null && e!.trim().isNotEmpty).map((e) => e!.trim()).join(', ');
//         if (label.isNotEmpty) locationLabel = label;
//       } catch (_) {
//         // Keep GPS coordinates even if reverse geocoding fails.
//       }
//
//       if (!mounted) return;
//       setState(() {
//         _selectedLat = currentPos.latitude;
//         _selectedLng = currentPos.longitude;
//         _selectedLocation = locationLabel.isEmpty ? 'Current location detected' : locationLabel;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Could not fetch current location: $e')),
//       );
//     } finally {
//       if (mounted) setState(() => _isLoadingCurrent = false);
//     }
//   }
//
//   Future<void> _searchLocations(String query) async {
//     final q = query.trim();
//     if (q.length < 2) {
//       if (!mounted) return;
//       setState(() {
//         _isSearching = false;
//         _suggestions.clear();
//       });
//       return;
//     }
//     setState(() => _isSearching = true);
//     try {
//       final uri = Uri.parse(
//         'https://nominatim.openstreetmap.org/search?format=json&addressdetails=1&limit=8&q=${Uri.encodeQueryComponent(q)}',
//       );
//       final res = await http.get(uri, headers: {'User-Agent': 'beatflirt-location-search'});
//       final decoded = jsonDecode(res.body);
//       if (!mounted) return;
//       if (res.statusCode == 200 && decoded is List) {
//         final items = decoded
//             .whereType<Map>()
//             .map(
//               (m) => _LocationSuggestion(
//                 name: (m['display_name'] ?? '').toString(),
//                 lat: double.tryParse((m['lat'] ?? '').toString()) ?? 0,
//                 lng: double.tryParse((m['lon'] ?? '').toString()) ?? 0,
//               ),
//             )
//             .where((e) => e.name.isNotEmpty)
//             .toList();
//         setState(() => _suggestions
//           ..clear()
//           ..addAll(items));
//       } else {
//         setState(() => _suggestions.clear());
//       }
//     } catch (_) {
//       if (!mounted) return;
//       setState(() => _suggestions.clear());
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Location search failed')),
//       );
//     } finally {
//       if (mounted) setState(() => _isSearching = false);
//     }
//   }
//
//   void _onSearchChanged(String value) {
//     _searchDebounce?.cancel();
//     _searchDebounce = Timer(const Duration(milliseconds: 350), () {
//       _searchLocations(value);
//     });
//   }
// }
//
// class _LocationSuggestion {
//   const _LocationSuggestion({
//     required this.name,
//     required this.lat,
//     required this.lng,
//   });
//
//   final String name;
//   final double lat;
//   final double lng;
// }

import 'dart:async';
import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// --- MODEL ---
class LocationSuggestion {
  const LocationSuggestion({
    required this.name,
    required this.placeId,
  });

  final String name;
  final String placeId;
}

// --- STATE ---
class LocationTabState {
  final bool isLoadingCurrent;
  final bool isSearching;
  final List<LocationSuggestion> suggestions;
  final String selectedLocation;
  final double? selectedLat;
  final double? selectedLng;
  final double distanceKm;
  final bool showOnlyNearby;

  const LocationTabState({
    this.isLoadingCurrent = false,
    this.isSearching = false,
    this.suggestions = const [],
    this.selectedLocation = 'No location selected',
    this.selectedLat,
    this.selectedLng,
    this.distanceKm = 25,
    this.showOnlyNearby = true,
  });

  LocationTabState copyWith({
    bool? isLoadingCurrent,
    bool? isSearching,
    List<LocationSuggestion>? suggestions,
    String? selectedLocation,
    double? selectedLat,
    double? selectedLng,
    double? distanceKm,
    bool? showOnlyNearby,
  }) {
    return LocationTabState(
      isLoadingCurrent: isLoadingCurrent ?? this.isLoadingCurrent,
      isSearching: isSearching ?? this.isSearching,
      suggestions: suggestions ?? this.suggestions,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      selectedLat: selectedLat ?? this.selectedLat,
      selectedLng: selectedLng ?? this.selectedLng,
      distanceKm: distanceKm ?? this.distanceKm,
      showOnlyNearby: showOnlyNearby ?? this.showOnlyNearby,
    );
  }
}

// --- NOTIFIER ---
class LocationTabNotifier extends Notifier<LocationTabState> {
  @override
  LocationTabState build() => const LocationTabState();

  Future<void> selectSuggestion(LocationSuggestion item) async {
    state = state.copyWith(
      selectedLocation: item.name,
      suggestions: [],
    );
    try {
      final detailsUri = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=${item.placeId}&fields=geometry&key=AIzaSyDTYoTj_UeBdzy9d3_-kNngDpwqQIzKDJk',
      );
      final res = await http.get(detailsUri);
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final geometry = decoded['result']?['geometry'];
        final lat = double.tryParse(geometry?['location']?['lat']?.toString() ?? '');
        final lng = double.tryParse(geometry?['location']?['lng']?.toString() ?? '');
        if (lat != null && lng != null) {
          state = state.copyWith(
            selectedLat: lat,
            selectedLng: lng,
          );
        }
      }
    } catch (e) {
      debugPrint('Error getting place details: $e');
    }
  }

  void updateDistanceKm(double v) {
    state = state.copyWith(distanceKm: v);
  }

  void updateShowOnlyNearby(bool v) {
    state = state.copyWith(showOnlyNearby: v);
  }

  Future<String?> fetchCurrentLocation() async {
    state = state.copyWith(isLoadingCurrent: true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return 'Turn on GPS/location service and try again.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        return 'Location permission denied. Please allow access.';
      }
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        return 'Location permission is permanently denied. Enable it in app settings.';
      }

      Position? pos;
      try {
        pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            timeLimit: Duration(seconds: 12),
          ),
        );
      } catch (_) {
        try {
          pos = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.low,
              timeLimit: Duration(seconds: 12),
            ),
          );
        } catch (_) {
          pos = await Geolocator.getLastKnownPosition();
        }
      }
      if (pos == null) {
        return 'Unable to get current GPS position. Move outdoors and try again.';
      }

      String locationLabel = 'Current location detected';
      try {
        final marks = await placemarkFromCoordinates(
          pos.latitude,
          pos.longitude,
        );
        final place = marks.isNotEmpty ? marks.first : null;
        final label =
            [place?.locality, place?.administrativeArea, place?.country]
                .where((e) => e != null && e.trim().isNotEmpty)
                .map((e) => e?.trim())
                .join(', ');
        if (label.isNotEmpty) locationLabel = label;
      } catch (_) {}

      state = state.copyWith(
        selectedLat: pos.latitude,
        selectedLng: pos.longitude,
        selectedLocation: locationLabel.isEmpty
            ? 'Current location detected'
            : locationLabel,
      );
      return null;
    } catch (e) {
      return 'Could not fetch current location: $e';
    } finally {
      state = state.copyWith(isLoadingCurrent: false);
    }
  }

  Future<String?> searchLocations(String query) async {
    final q = query.trim();
    if (q.length < 2) {
      state = state.copyWith(isSearching: false, suggestions: []);
      return null;
    }
    state = state.copyWith(isSearching: true);
    try {
      final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${Uri.encodeQueryComponent(q)}&key=AIzaSyDTYoTj_UeBdzy9d3_-kNngDpwqQIzKDJk',
      );
      final res = await http.get(uri);
      final decoded = jsonDecode(res.body);
      if (res.statusCode == 200 && decoded['predictions'] is List) {
        final items = (decoded['predictions'] as List)
            .whereType<Map>()
            .map(
              (m) => LocationSuggestion(
                name: (m['description'] ?? m['name'] ?? '').toString(),
                placeId: (m['place_id'] ?? '').toString(),
              ),
            )
            .where((e) => e.name.isNotEmpty && e.placeId.isNotEmpty)
            .toList();
        state = state.copyWith(suggestions: items);
      } else {
        state = state.copyWith(suggestions: []);
      }
      return null;
    } catch (_) {
      state = state.copyWith(suggestions: []);
      return 'Location search failed';
    } finally {
      state = state.copyWith(isSearching: false);
    }
  }
}

// --- PROVIDER ---
final locationTabProvider =
    NotifierProvider<LocationTabNotifier, LocationTabState>(
      LocationTabNotifier.new,
    );

// --- WIDGET ---
class MyProfileLocationTab extends ConsumerStatefulWidget {
  const MyProfileLocationTab({super.key});

  @override
  ConsumerState<MyProfileLocationTab> createState() =>
      _MyProfileLocationTabState();
}

class _MyProfileLocationTabState extends ConsumerState<MyProfileLocationTab> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchCurrentLocation();
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCurrentLocation();
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchCurrentLocation() async {
    final error = await ref
        .read(locationTabProvider.notifier)
        .fetchCurrentLocation();
    if (error != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _searchLocations(String query) async {
    final error = await ref
        .read(locationTabProvider.notifier)
        .searchLocations(query);
    if (error != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      _searchLocations(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(locationTabProvider);
    final notifier = ref.read(locationTabProvider.notifier);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8E0F2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Auto-detect your location or search manually.',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: state.isLoadingCurrent
                        ? null
                        : _fetchCurrentLocation,
                    icon: state.isLoadingCurrent
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location),
                    label: Text(
                      state.isLoadingCurrent
                          ? 'Detecting...'
                          : 'Use Current Location',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              onTapOutside: (_) {
                FocusManager.instance.primaryFocus!.unfocus();
              },
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onChanged: _onSearchChanged,
              onSubmitted: _searchLocations,
              decoration: InputDecoration(
                hintText: 'Search location (city, area, address)',
                suffixIcon: IconButton(
                  icon: state.isSearching
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.search),
                  onPressed: state.isSearching
                      ? null
                      : () => _searchLocations(_searchController.text),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (state.suggestions.isNotEmpty)
              Container(
                constraints: const BoxConstraints(maxHeight: 220),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE8E0F2)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: state.suggestions.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = state.suggestions[index];
                    return Material(
                      color: Colors.transparent,
                      child: ListTile(
                        dense: true,
                        leading: const Icon(Icons.location_on_outlined, size: 18),
                        title: Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          notifier.selectSuggestion(item);
                          _searchController.text = item.name;
                        },
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 14),
            _infoRow(Icons.place_outlined, 'Selected', state.selectedLocation),
            _infoRow(
              Icons.map_outlined,
              'Coordinates',
              state.selectedLat == null
                  ? '--'
                  : '${state.selectedLat!.toStringAsFixed(5)}, ${state.selectedLng!.toStringAsFixed(5)}',
            ),
            const SizedBox(height: 16),
            Text(
              'Match Distance: ${state.distanceKm.round()} km',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Slider(
              value: state.distanceKm,
              min: 5,
              max: 200,
              divisions: 39,
              activeColor: const Color(0xFF220027),
              onChanged: (v) => notifier.updateDistanceKm(v),
            ),
            Material(
              color: Colors.transparent,
              child: SwitchListTile(
                value: state.showOnlyNearby,
                onChanged: (v) => notifier.updateShowOnlyNearby(v),
                contentPadding: EdgeInsets.zero,
                title: const Text('Show only nearby matches'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Location preferences updated')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF220027),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: const Text('Save Location'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.black54),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[800])),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../providers/profile_provider.dart';
// import '../../../core/constants.dart';
//
// class LocationsTab extends ConsumerWidget {
//   const LocationsTab({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final profileState = ref.watch(profileProvider);
//     final profile = profileState.profile;
//
//     if (profile == null) {
//       return const Center(
//         child: Text(
//           'Please load your profile first',
//           style: AppTextStyles.bodyLarge,
//         ),
//       );
//     }
//
//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       child: Column(
//         children: [
//           // Map placeholder
//           _buildMapSection(profile),
//
//           // Primary Location
//           _buildLocationCard(
//             title: 'Primary Location',
//             icon: Icons.location_on,
//             city: profile.city ?? 'Not set',
//             address: profile.address ?? 'No address provided',
//             lat: profile.lat,
//             lng: profile.lng,
//             isPrimary: true,
//           ),
//
//           // Secondary Location (if available)
//           if (profile.city1 != null && profile.city1!.isNotEmpty)
//             _buildLocationCard(
//               title: 'Secondary Location',
//               icon: Icons.location_searching,
//               city: profile.city1!,
//               address: profile.address1 ?? 'No address provided',
//               lat: profile.lat1,
//               lng: profile.lng1,
//               isPrimary: false,
//             ),
//
//           // Distance info
//           if (profile.distance != null &&
//               profile.distance!.isNotEmpty &&
//               profile.distance != 'null')
//             _buildDistanceCard(profile.distance!),
//
//           // Location settings
//           _buildLocationSettings(context, ref),
//
//           const SizedBox(height: 32),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMapSection(dynamic profile) {
//     final hasValidCoords = profile.lat != null &&
//         profile.lng != null &&
//         profile.lat != '0.0' &&
//         profile.lng != '0.0' &&
//         profile.lat != 'null' &&
//         profile.lng != 'null';
//
//     return Container(
//       height: 220,
//       margin: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.cardDark,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: AppColors.divider, width: 0.5),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             // Map placeholder (Google Maps widget would go here)
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     AppColors.surface,
//                     AppColors.cardDark.withOpacity(0.8),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.map,
//                     size: 56,
//                     color: AppColors.primary.withOpacity(0.5),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     hasValidCoords
//                         ? 'Map View'
//                         : 'Location not available',
//                     style: AppTextStyles.bodyMedium,
//                   ),
//                   if (hasValidCoords) ...[
//                     const SizedBox(height: 4),
//                     Text(
//                       '${profile.lat}, ${profile.lng}',
//                       style: AppTextStyles.bodySmall,
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//
//             // Map overlay with location pin
//             if (hasValidCoords)
//               Center(
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: AppColors.primary,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: AppColors.primary.withOpacity(0.4),
//                         blurRadius: 12,
//                         spreadRadius: 2,
//                       ),
//                     ],
//                   ),
//                   child: const Icon(
//                     Icons.person_pin,
//                     color: Colors.white,
//                     size: 24,
//                   ),
//                 ),
//               ),
//
//             // Open in Google Maps button
//             if (hasValidCoords)
//               Positioned(
//                 bottom: 12,
//                 right: 12,
//                 child: Material(
//                   color: AppColors.primary,
//                   borderRadius: BorderRadius.circular(10),
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(10),
//                     onTap: () {
//                       // TODO: Open Google Maps
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 8,
//                       ),
//                       child: const Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.open_in_new,
//                               color: Colors.white, size: 14),
//                           SizedBox(width: 4),
//                           Text(
//                             'Open Maps',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLocationCard({
//     required String title,
//     required IconData icon,
//     required String city,
//     required String address,
//     String? lat,
//     String? lng,
//     required bool isPrimary,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       decoration: BoxDecoration(
//         color: AppColors.cardDark,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: isPrimary
//               ? AppColors.primary.withOpacity(0.3)
//               : AppColors.divider,
//           width: isPrimary ? 1 : 0.5,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: isPrimary
//                         ? AppColors.primary.withOpacity(0.15)
//                         : AppColors.accent.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(
//                     icon,
//                     color: isPrimary ? AppColors.primary : AppColors.accent,
//                     size: 20,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(title, style: AppTextStyles.heading3),
//                       if (isPrimary)
//                         Container(
//                           margin: const EdgeInsets.only(top: 4),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 2,
//                           ),
//                           decoration: BoxDecoration(
//                             color: AppColors.primary.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: const Text(
//                             'DEFAULT',
//                             style: TextStyle(
//                               color: AppColors.primary,
//                               fontSize: 9,
//                               fontWeight: FontWeight.bold,
//                               letterSpacing: 1,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.edit,
//                       color: AppColors.textMuted, size: 20),
//                   onPressed: () {
//                     // TODO: Edit location
//                   },
//                 ),
//               ],
//             ),
//           ),
//           const Divider(color: AppColors.divider, height: 1),
//
//           // Location details
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 _buildLocationRow(Icons.location_city, 'City', city),
//                 const SizedBox(height: 10),
//                 _buildLocationRow(Icons.place, 'Address', address),
//                 if (lat != null && lng != null && lat != 'null') ...[
//                   const SizedBox(height: 10),
//                   _buildLocationRow(
//                     Icons.my_location,
//                     'Coordinates',
//                     '$lat, $lng',
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLocationRow(IconData icon, String label, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, size: 16, color: AppColors.textMuted),
//         const SizedBox(width: 10),
//         SizedBox(
//           width: 80,
//           child: Text(
//             label,
//             style: AppTextStyles.bodySmall.copyWith(
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             style: AppTextStyles.bodyMedium.copyWith(
//               color: AppColors.textPrimary,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDistanceCard(String distance) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.cardDark,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.divider, width: 0.5),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: AppColors.warning.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Icon(
//               Icons.straighten,
//               color: AppColors.warning,
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Search Distance',
//                   style: AppTextStyles.label,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '$distance km radius',
//                   style: AppTextStyles.heading3,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLocationSettings(BuildContext context, WidgetRef ref) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       decoration: BoxDecoration(
//         color: AppColors.cardDark,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.divider, width: 0.5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Padding(
//             padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
//             child: Row(
//               children: [
//                 Icon(Icons.settings, color: AppColors.primary, size: 20),
//                 SizedBox(width: 8),
//                 Text('Location Settings', style: AppTextStyles.heading3),
//               ],
//             ),
//           ),
//           const Divider(color: AppColors.divider, height: 1),
//
//           // Update Location
//           ListTile(
//             leading: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: AppColors.success.withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Icon(
//                 Icons.my_location,
//                 color: AppColors.success,
//                 size: 20,
//               ),
//             ),
//             title: const Text('Update My Location',
//                 style: TextStyle(color: AppColors.textPrimary)),
//             subtitle: const Text('Use current GPS location',
//                 style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
//             trailing: const Icon(
//               Icons.chevron_right,
//               color: AppColors.textMuted,
//             ),
//             onTap: () {
//               _showUpdateLocationDialog(context);
//             },
//           ),
//
//           const Divider(
//             color: AppColors.divider,
//             height: 1,
//             indent: 16,
//             endIndent: 16,
//           ),
//
//           // Add Secondary Location
//           ListTile(
//             leading: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: AppColors.accent.withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Icon(
//                 Icons.add_location_alt,
//                 color: AppColors.accent,
//                 size: 20,
//               ),
//             ),
//             title: const Text('Add Secondary Location',
//                 style: TextStyle(color: AppColors.textPrimary)),
//             subtitle: const Text('Search for nearby profiles',
//                 style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
//             trailing: const Icon(
//               Icons.chevron_right,
//               color: AppColors.textMuted,
//             ),
//             onTap: () {
//               // TODO: Add secondary location
//             },
//           ),
//
//           const Divider(
//             color: AppColors.divider,
//             height: 1,
//             indent: 16,
//             endIndent: 16,
//           ),
//
//           // Privacy setting
//           SwitchListTile(
//             secondary: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: AppColors.warning.withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Icon(
//                 Icons.visibility_off,
//                 color: AppColors.warning,
//                 size: 20,
//               ),
//             ),
//             title: const Text('Hide My Location',
//                 style: TextStyle(color: AppColors.textPrimary)),
//             subtitle: const Text('Others won\'t see your exact location',
//                 style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
//             value: false,
//             activeColor: AppColors.primary,
//             onChanged: (value) {
//               // TODO: Toggle location visibility
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showUpdateLocationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: AppColors.cardDark,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Update Location',
//             style: TextStyle(color: AppColors.textPrimary)),
//         content: const Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.location_on, color: AppColors.primary, size: 48),
//             SizedBox(height: 16),
//             Text(
//               'This will update your location using your current GPS coordinates.',
//               style: TextStyle(color: AppColors.textSecondary),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // TODO: Get GPS coordinates and update
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Update'),
//           ),
//         ],
//       ),
//     );
//   }
// }
