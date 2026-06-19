class UserModel {
  String uid;
  String name;
  String avatar;
  String relationshipIntent;
  bool isVerified;
  double lat;
  double lng;

  UserModel({
    required this.uid,
    required this.name,
    required this.avatar,
    this.relationshipIntent = 'Friendship',
    this.isVerified = false,
    this.lat = 0,
    this.lng = 0,
  });
}

class MessageModel {
  String senderId;
  String text;
  DateTime timestamp;

  MessageModel({required this.senderId, required this.text, required this.timestamp});
}