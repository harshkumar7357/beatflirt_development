import 'package:flutter_riverpod/flutter_riverpod.dart';

class Celebrity {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final bool isOnline;
  final double rating;
  final String location;

  const Celebrity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    this.isOnline = false,
    this.rating = 5.0,
    required this.location,
  });
}

class CelebrityState {
  final List<Celebrity> trendingCelebrities;
  final List<Celebrity> topRatedCelebrities;
  final bool isLoading;

  const CelebrityState({
    this.trendingCelebrities = const [],
    this.topRatedCelebrities = const [],
    this.isLoading = false,
  });

  CelebrityState copyWith({
    List<Celebrity>? trendingCelebrities,
    List<Celebrity>? topRatedCelebrities,
    bool? isLoading,
  }) {
    return CelebrityState(
      trendingCelebrities: trendingCelebrities ?? this.trendingCelebrities,
      topRatedCelebrities: topRatedCelebrities ?? this.topRatedCelebrities,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CelebrityNotifier extends Notifier<CelebrityState> {
  @override
  CelebrityState build() {
    // Initial dummy data for AAA UI feel
    return const CelebrityState(
      trendingCelebrities: [
        Celebrity(
          id: '1',
          name: 'Sophia Loren',
          imageUrl: 'assets/images/notification-image1.jpg',
          category: 'Top Model',
          isOnline: true,
          location: 'New York, USA',
        ),
        Celebrity(
          id: '2',
          name: 'Marco Rossi',
          imageUrl: 'assets/images/notification-image4.jpg',
          category: 'Influencer',
          location: 'Milan, Italy',
        ),
        Celebrity(
          id: '3',
          name: 'Elena Gilbert',
          imageUrl: 'assets/images/notification-image5.jpg',
          category: 'Artist',
          isOnline: true,
          location: 'London, UK',
        ),
      ],
      topRatedCelebrities: [
        Celebrity(
          id: '4',
          name: 'James Bond',
          imageUrl: 'assets/images/notification-image4.jpg',
          category: 'Actor',
          rating: 4.9,
          location: 'Zurich, Switzerland',
        ),
        Celebrity(
          id: '5',
          name: 'Aria Stark',
          imageUrl: 'assets/images/notification-image1.jpg',
          category: 'Dancer',
          rating: 4.8,
          location: 'Winterfell',
        ),
      ],
    );
  }
}

final celebrityProvider = NotifierProvider<CelebrityNotifier, CelebrityState>(CelebrityNotifier.new);
