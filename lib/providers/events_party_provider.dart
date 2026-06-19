import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatflirt/Api_services/api_services.dart';
import 'package:beatflirt/core/services/auth_services.dart';

class Event {
  final String id;
  final String title;
  final String date;
  final String location;
  final String? imageUrl;
  final String? description;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    this.imageUrl,
    this.description,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['_id'] ?? map['id'] ?? '',
      title: map['title'] ?? 'Unknown Event',
      date: map['date'] ?? 'TBD',
      location: map['location'] ?? 'TBD',
      imageUrl: map['imageUrl'],
      description: map['description'],
    );
  }
}

class FeaturedEvent {
  final String id;
  final String title;
  final String location;
  final String? imageUrl;
  final String? time;

  FeaturedEvent({
    required this.id,
    required this.title,
    required this.location,
    this.imageUrl,
    this.time,
  });

  factory FeaturedEvent.fromMap(Map<String, dynamic> map) {
    return FeaturedEvent(
      id: map['_id'] ?? map['id'] ?? '',
      title: map['title'] ?? 'Featured Event',
      location: map['location'] ?? 'TBD',
      imageUrl: map['imageUrl'],
      time: map['time'],
    );
  }
}

class EventsPartyState {
  final List<Event> events;
  final FeaturedEvent? featuredEvent;
  final bool isLoading;
  final String? error;

  EventsPartyState({
    this.events = const [],
    this.featuredEvent,
    this.isLoading = false,
    this.error,
  });

  EventsPartyState copyWith({
    List<Event>? events,
    FeaturedEvent? featuredEvent,
    bool? isLoading,
    String? error,
  }) {
    return EventsPartyState(
      events: events ?? this.events,
      featuredEvent: featuredEvent ?? this.featuredEvent,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class EventsPartyNotifier extends Notifier<EventsPartyState> {
  final ApiServices _api = ApiServices();

  @override
  EventsPartyState build() {
    Future.microtask(() => fetchData());
    return EventsPartyState(isLoading: true);
  }

  Future<void> fetchData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        state = state.copyWith(isLoading: false, error: 'Unauthorized');
        return;
      }

      final results = await Future.wait([
        _api.getEvents(token: token),
        _api.getFeaturedEvent(token: token),
      ]);

      final eventsData = results[0] as List<Map<String, dynamic>>;
      final featuredEventData = results[1] as Map<String, dynamic>;

      final events = eventsData.map(Event.fromMap).toList();
      final featuredEvent = FeaturedEvent.fromMap(featuredEventData);

      state = state.copyWith(
        isLoading: false,
        events: events,
        featuredEvent: featuredEvent,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> rsvpEvent(String eventId) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return;

      await _api.rsvpEvent(token: token, eventId: eventId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }
}

final eventsPartyProvider = NotifierProvider<EventsPartyNotifier, EventsPartyState>(EventsPartyNotifier.new);
