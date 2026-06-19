// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class Celebrity {
//   final String id;
//   final String name;
//   final String imageUrl;
//   final String category;
//   final bool isOnline;
//   final double rating;
//   final String location;

//   const Celebrity({
//     required this.id,
//     required this.name,
//     required this.imageUrl,
//     required this.category,
//     this.isOnline = false,
//     this.rating = 5.0,
//     required this.location,
//   });
// }

// class CelebrityState {
//   final List<Celebrity> trendingCelebrities;
//   final List<Celebrity> topRatedCelebrities;
//   final bool isLoading;

//   const CelebrityState({
//     this.trendingCelebrities = const [],
//     this.topRatedCelebrities = const [],
//     this.isLoading = false,
//   });

//   CelebrityState copyWith({
//     List<Celebrity>? trendingCelebrities,
//     List<Celebrity>? topRatedCelebrities,
//     bool? isLoading,
//   }) {
//     return CelebrityState(
//       trendingCelebrities: trendingCelebrities ?? this.trendingCelebrities,
//       topRatedCelebrities: topRatedCelebrities ?? this.topRatedCelebrities,
//       isLoading: isLoading ?? this.isLoading,
//     );
//   }
// }

// class CelebrityNotifier extends Notifier<CelebrityState> {
//   @override
//   CelebrityState build() {
//     // Initial dummy data for AAA UI feel
//     return const CelebrityState(
//       trendingCelebrities: [
//         Celebrity(
//           id: '1',
//           name: 'Sophia Loren',
//           imageUrl: 'assets/images/notification-image1.jpg',
//           category: 'Top Model',
//           isOnline: true,
//           location: 'New York, USA',
//         ),
//         Celebrity(
//           id: '2',
//           name: 'Marco Rossi',
//           imageUrl: 'assets/images/notification-image4.jpg',
//           category: 'Influencer',
//           location: 'Milan, Italy',
//         ),
//         Celebrity(
//           id: '3',
//           name: 'Elena Gilbert',
//           imageUrl: 'assets/images/notification-image5.jpg',
//           category: 'Artist',
//           isOnline: true,
//           location: 'London, UK',
//         ),
//       ],
//       topRatedCelebrities: [
//         Celebrity(
//           id: '4',
//           name: 'James Bond',
//           imageUrl: 'assets/images/notification-image4.jpg',
//           category: 'Actor',
//           rating: 4.9,
//           location: 'Zurich, Switzerland',
//         ),
//         Celebrity(
//           id: '5',
//           name: 'Aria Stark',
//           imageUrl: 'assets/images/notification-image1.jpg',
//           category: 'Dancer',
//           rating: 4.8,
//           location: 'Winterfell',
//         ),
//       ],
//     );
//   }
// }

// final celebrityProvider = NotifierProvider<CelebrityNotifier, CelebrityState>(CelebrityNotifier.new);


import 'package:beatflirt/Api_services/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Celebrity {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final String location;
  final bool isOnline;
  final double rating;
  final int? pricePerMinute;
  final String? bio;

  Celebrity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.location,
    required this.isOnline,
    required this.rating,
    this.pricePerMinute,
    this.bio, required String lastSeen,
  });

  factory Celebrity.fromJson(Map<String, dynamic> json) {
    return Celebrity(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      location: json['location'],
      isOnline: json['isOnline'] ?? false,
      rating: (json['rating'] ?? 0.0).toDouble(),
      pricePerMinute: json['pricePerMinute'],
      bio: json['bio'], 
      lastSeen: json['lastSeen'],
    );
  }
}

class CelebrityState {
  final List<Celebrity> trendingCelebrities;
  final List<Celebrity> topRatedCelebrities;
  final bool isLoading;
  final String? error;

  CelebrityState({
    this.trendingCelebrities = const [],
    this.topRatedCelebrities = const [],
    this.isLoading = false,
    this.error,
  });

  CelebrityState copyWith({
    List<Celebrity>? trendingCelebrities,
    List<Celebrity>? topRatedCelebrities,
    bool? isLoading,
    String? error,
  }) {
    return CelebrityState(
      trendingCelebrities: trendingCelebrities ?? this.trendingCelebrities,
      topRatedCelebrities: topRatedCelebrities ?? this.topRatedCelebrities,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final celebrityProvider = StateNotifierProvider<CelebrityNotifier, CelebrityState>((ref) {
  return CelebrityNotifier();
});

class CelebrityNotifier extends StateNotifier<CelebrityState> {
  CelebrityNotifier() : super(CelebrityState()) {
    fetchCelebrityPanel();
  }

  Future<void> fetchCelebrityPanel() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final baseUrl = ApiServices.baseUrl;
      final response = await http.get(
        Uri.parse('$baseUrl/api/celebrities/panel'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        final trending = (data['trendingCelebrities'] as List)
            .map((celeb) => Celebrity.fromJson(celeb))
            .toList();
            
        final topRated = (data['topRatedCelebrities'] as List)
            .map((celeb) => Celebrity.fromJson(celeb))
            .toList();

        state = state.copyWith(
          trendingCelebrities: trending,
          topRatedCelebrities: topRated,
          isLoading: false,
        );
      } else {
        throw Exception('Failed to load celebrities');
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        trendingCelebrities: _getSampleTrending(),
        topRatedCelebrities: _getSampleTopRated(),
      );
    }
  }

  List<Celebrity> _getSampleTrending() {
    return [
      Celebrity(
        id: 's1',
        name: 'Sophia Loren',
        imageUrl: 'assets/images/notification-image1.jpg',
        category: 'Top Model',
        isOnline: true,
        location: 'New York, USA',
        rating: 5.0, lastSeen: '',
      ),
      Celebrity(
        id: 's2',
        name: 'Marco Rossi',
        imageUrl: 'assets/images/notification-image4.jpg',
        category: 'Influencer',
        isOnline: false,
        location: 'Milan, Italy',
        rating: 4.8, 
        lastSeen: '',
      ),
    ];
  }

  List<Celebrity> _getSampleTopRated() {
    return [
      Celebrity(
        id: 's4',
        name: 'James Bond',
        imageUrl: 'assets/images/notification-image4.jpg',
        category: 'Actor',
        isOnline: true,
        location: 'London, UK',
        rating: 4.9, 
        lastSeen: '',
      ),
    ];
  }
}