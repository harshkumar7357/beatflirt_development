// lib/model/event_model.dart
//
// Maps the /App/events/get_all_events response items.

class EventBookingStatus {
  final String isBooking;
  final String paymentType;
  final String paymentTypeQty;
  final int totalUser;

  const EventBookingStatus({
    this.isBooking = '0',
    this.paymentType = '',
    this.paymentTypeQty = '',
    this.totalUser = 0,
  });

  factory EventBookingStatus.fromJson(Map<String, dynamic>? j) {
    if (j == null) return const EventBookingStatus();
    return EventBookingStatus(
      isBooking: (j['is_booking'] ?? '0').toString(),
      paymentType: (j['payment_type'] ?? '').toString(),
      paymentTypeQty: (j['payment_type_qty'] ?? '').toString(),
      totalUser: int.tryParse('${j['total_user'] ?? 0}') ?? 0,
    );
  }
}

class EventModel {
  final String id;
  final String eventName;
  final String eventFromDate;
  final String eventToDate;
  final String eventFromTime;
  final String eventToTime;
  final String eventType;

  // swinger / hookup flags ("0" / "1")
  final String coupleMaleFemaleSwingers;
  final String coupleFemaleFemaleSwingers;
  final String coupleMaleMaleSwingers;
  final String coupleMaleSwingers;
  final String coupleFemaleSwingers;
  final String coupleTransgenderSwingers;

  final String eventLocation;
  final String lat;
  final String lng;
  final String cityName;
  final String placeId;
  final String mapUrl;
  final String formattedAddress;

  final String eventImage;
  final String eventPrice;
  final String eventNoOfTicket;
  final String eventEmail;
  final String eventDescription; // raw HTML
  final String created;
  final String status;

  final EventBookingStatus bookingStatus;

  const EventModel({
    required this.id,
    required this.eventName,
    required this.eventFromDate,
    required this.eventToDate,
    required this.eventFromTime,
    required this.eventToTime,
    required this.eventType,
    this.coupleMaleFemaleSwingers = '0',
    this.coupleFemaleFemaleSwingers = '0',
    this.coupleMaleMaleSwingers = '0',
    this.coupleMaleSwingers = '0',
    this.coupleFemaleSwingers = '0',
    this.coupleTransgenderSwingers = '0',
    this.eventLocation = '',
    this.lat = '',
    this.lng = '',
    this.cityName = '',
    this.placeId = '',
    this.mapUrl = '',
    this.formattedAddress = '',
    this.eventImage = '',
    this.eventPrice = '',
    this.eventNoOfTicket = '',
    this.eventEmail = '',
    this.eventDescription = '',
    this.created = '',
    this.status = '',
    this.bookingStatus = const EventBookingStatus(),
  });

  factory EventModel.fromJson(Map<String, dynamic> j) {
    String s(dynamic v) => (v ?? '').toString();
    return EventModel(
      id: s(j['id']),
      eventName: s(j['event_name']),
      eventFromDate: s(j['event_from_date']),
      eventToDate: s(j['event_to_date']),
      eventFromTime: s(j['event_from_time']),
      eventToTime: s(j['event_to_time']),
      eventType: s(j['event_type']),
      coupleMaleFemaleSwingers: s(j['couple_male_female_swingers']),
      coupleFemaleFemaleSwingers: s(j['couple_female_female_swingers']),
      coupleMaleMaleSwingers: s(j['couple_male_male_swingers']),
      coupleMaleSwingers: s(j['couple_male_swingers']),
      coupleFemaleSwingers: s(j['couple_female_swingers']),
      coupleTransgenderSwingers: s(j['couple_transgender_swingers']),
      eventLocation: s(j['event_location']),
      lat: s(j['lat']),
      lng: s(j['lng']),
      cityName: s(j['city_name']),
      placeId: s(j['place_id']),
      mapUrl: s(j['map_url']),
      formattedAddress: s(j['formatted_address']),
      eventImage: s(j['event_image']),
      eventPrice: s(j['event_price']),
      eventNoOfTicket: s(j['event_no_of_ticket']),
      eventEmail: s(j['event_email']),
      eventDescription: s(j['event_description']),
      created: s(j['created']),
      status: s(j['status']),
      bookingStatus: EventBookingStatus.fromJson(
        j['booking_status'] is Map<String, dynamic>
            ? j['booking_status'] as Map<String, dynamic>
            : null,
      ),
    );
  }
}
