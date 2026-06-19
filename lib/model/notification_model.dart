class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String type;
  final String image;
  final String video;
  final String status;
  final bool isRead;
  final DateTime createdAt;
  final String created;
  final String notificationTime;
  final String sendMsgTime;
  final String eventFromDate;
  final String eventToDate;
  final String? eventFromTime;
  final String? eventToTime;
  final String eventName;
  final String eventImage;
  final String notificationDateTime;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.image,
    required this.video,
    required this.status,
    required this.isRead,
    required this.createdAt,
    required this.created,
    required this.notificationTime,
    required this.sendMsgTime,
    required this.eventFromDate,
    required this.eventToDate,
    this.eventFromTime,
    this.eventToTime,
    required this.eventName,
    required this.eventImage,
    required this.notificationDateTime,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final createdStr = json['created']?.toString() ?? json['notification_date_time']?.toString() ?? '';
    DateTime parsedCreated;
    try {
      parsedCreated = DateTime.parse(createdStr);
    } catch (_) {
      parsedCreated = DateTime.now();
    }

    final statusStr = json['status']?.toString() ?? '';
    final isRead = statusStr == '0' || statusStr.toLowerCase() == 'read';

    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      video: json['video']?.toString() ?? '',
      status: statusStr,
      isRead: isRead,
      createdAt: parsedCreated,
      created: json['created']?.toString() ?? '',
      notificationTime: json['notification_time']?.toString() ?? '',
      sendMsgTime: json['send_msg_time']?.toString() ?? '',
      eventFromDate: json['event_from_date']?.toString() ?? '',
      eventToDate: json['event_to_date']?.toString() ?? '',
      eventFromTime: json['event_from_time']?.toString(),
      eventToTime: json['event_to_time']?.toString(),
      eventName: json['event_name']?.toString() ?? '',
      eventImage: json['event_image']?.toString() ?? '',
      notificationDateTime: json['notification_date_time']?.toString() ?? '',
    );
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? image,
    String? video,
    String? status,
    bool? isRead,
    DateTime? createdAt,
    String? created,
    String? notificationTime,
    String? sendMsgTime,
    String? eventFromDate,
    String? eventToDate,
    String? eventFromTime,
    String? eventToTime,
    String? eventName,
    String? eventImage,
    String? notificationDateTime,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      image: image ?? this.image,
      video: video ?? this.video,
      status: status ?? this.status,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      created: created ?? this.created,
      notificationTime: notificationTime ?? this.notificationTime,
      sendMsgTime: sendMsgTime ?? this.sendMsgTime,
      eventFromDate: eventFromDate ?? this.eventFromDate,
      eventToDate: eventToDate ?? this.eventToDate,
      eventFromTime: eventFromTime ?? this.eventFromTime,
      eventToTime: eventToTime ?? this.eventToTime,
      eventName: eventName ?? this.eventName,
      eventImage: eventImage ?? this.eventImage,
      notificationDateTime: notificationDateTime ?? this.notificationDateTime,
    );
  }
}
