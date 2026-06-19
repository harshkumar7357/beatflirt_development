class CoupleProfile {
  final String? id;
  final String? username;
  final String? email;
  final String? text; // bio
  final String? comment;
  final String? profileImage;
  final String? location;
  final String? coupleMaleFemaleSwingers;
  final String? coupleFemaleFemaleSwingers;
  final String? coupleMaleMaleSwingers;
  final String? coupleMaleSwingers;
  final String? coupleFemaleSwingers;
  final String? coupleTransgenderSwingers;
  final String? coupleMaleFemaleHookupMeetup;
  final String? coupleFemaleFemaleHookupMeetup;
  final String? coupleMaleMaleHookupMeetup;
  final String? coupleMaleHookupMeetup;
  final String? coupleFemaleHookupMeetup;
  final String? coupleTransgenderHookupMeetup;
  // add more fields as needed from API

  CoupleProfile({
    this.id,
    this.username,
    this.email,
    this.text,
    this.comment,
    this.profileImage,
    this.location,
    this.coupleMaleFemaleSwingers,
    this.coupleFemaleFemaleSwingers,
    this.coupleMaleMaleSwingers,
    this.coupleMaleSwingers,
    this.coupleFemaleSwingers,
    this.coupleTransgenderSwingers,
    this.coupleMaleFemaleHookupMeetup,
    this.coupleFemaleFemaleHookupMeetup,
    this.coupleMaleMaleHookupMeetup,
    this.coupleMaleHookupMeetup,
    this.coupleFemaleHookupMeetup,
    this.coupleTransgenderHookupMeetup,
  });

  factory CoupleProfile.fromJson(Map<String, dynamic> json) {
    return CoupleProfile(
      id: json['id']?.toString(),
      username: json['username'],
      email: json['email'],
      text: json['text'],
      comment: json['comment'],
      profileImage: json['profile_image'],
      location: json['location'] ?? json['address'],
      coupleMaleFemaleSwingers: json['couple_male_female_swingers']?.toString(),
      coupleFemaleFemaleSwingers: json['couple_female_female_swingers']?.toString(),
      coupleMaleMaleSwingers: json['couple_male_male_swingers']?.toString(),
      coupleMaleSwingers: json['couple_male_swingers']?.toString(),
      coupleFemaleSwingers: json['couple_female_swingers']?.toString(),
      coupleTransgenderSwingers: json['couple_transgender_swingers']?.toString(),
      coupleMaleFemaleHookupMeetup: json['couple_male_female_hookup_meetup']?.toString(),
      coupleFemaleFemaleHookupMeetup: json['couple_female_female_hookup_meetup']?.toString(),
      coupleMaleMaleHookupMeetup: json['couple_male_male_hookup_meetup']?.toString(),
      coupleMaleHookupMeetup: json['couple_male_hookup_meetup']?.toString(),
      coupleFemaleHookupMeetup: json['couple_female_hookup_meetup']?.toString(),
      coupleTransgenderHookupMeetup: json['couple_transgender_hookup_meetup']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'text': text,
    'comment': comment,
    // etc
  };
}

class ProfileImage {
  final String id;
  final String profileImage;
  final String? setProfile; // "1" if main

  ProfileImage({required this.id, required this.profileImage, this.setProfile});

  factory ProfileImage.fromJson(Map<String, dynamic> json) {
    return ProfileImage(
      id: json['id'].toString(),
      profileImage: json['profile_image'] ?? '',
      setProfile: json['set_profile']?.toString(),
    );
  }
}

class ProfileVideo {
  final String id;
  final String profileVideo;

  ProfileVideo({required this.id, required this.profileVideo});

  factory ProfileVideo.fromJson(Map<String, dynamic> json) {
    return ProfileVideo(
      id: json['id'].toString(),
      profileVideo: json['profile_video'] ?? '',
    );
  }
}

class Album {
  final String id;
  final String albumName;
  final String? image; // cover image

  Album({required this.id, required this.albumName, this.image});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'].toString(),
      albumName: json['album_name'] ?? '',
      image: json['image'],
    );
  }
}

