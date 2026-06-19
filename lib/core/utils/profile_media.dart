import 'dart:convert';

/// User Profile Image Model
class ProfileImage {
  final int? id;
  final String? userId;
  final String? imageName;
  final String? imagePath;
  final String? imageFullPath;
  final int? isProfile;
  final int? status;
  final String? createdAt;

  ProfileImage({
    this.id,
    this.userId,
    this.imageName,
    this.imagePath,
    this.imageFullPath,
    this.isProfile,
    this.status,
    this.createdAt,
  });

  factory ProfileImage.fromJson(Map<String, dynamic> json) {
    return ProfileImage(
      id: json['id'] as int?,
      userId: json['user_id']?.toString(),
      imageName: json['image_name'] as String?,
      imagePath: json['image_path'] as String?,
      imageFullPath: json['image_full_path'] as String?,
      isProfile: json['is_profile'] as int?,
      status: json['status'] as int?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (imageName != null) 'image_name': imageName,
      if (imagePath != null) 'image_path': imagePath,
      if (imageFullPath != null) 'image_full_path': imageFullPath,
      if (isProfile != null) 'is_profile': isProfile,
      if (status != null) 'status': status,
    };
  }
}

/// Profile Video Model
class ProfileVideo {
  final int? id;
  final String? userId;
  final String? videoName;
  final String? videoPath;
  final String? videoFullPath;
  final int? status;
  final String? createdAt;

  ProfileVideo({
    this.id,
    this.userId,
    this.videoName,
    this.videoPath,
    this.videoFullPath,
    this.status,
    this.createdAt,
  });

  factory ProfileVideo.fromJson(Map<String, dynamic> json) {
    return ProfileVideo(
      id: json['id'] as int?,
      userId: json['user_id']?.toString(),
      videoName: json['video_name'] as String?,
      videoPath: json['video_path'] as String?,
      videoFullPath: json['video_full_path'] as String?,
      status: json['status'] as int?,
      createdAt: json['created_at'] as String?,
    );
  }
}

/// Album Model
class Album {
  final int? id;
  final String? userId;
  final String? albumName;
  final String? albumPassword;
  final String? albumImage;
  final int? status;
  final List<AlbumImage>? images;
  final List<ProfileVideo>? videos;

  Album({
    this.id,
    this.userId,
    this.albumName,
    this.albumPassword,
    this.albumImage,
    this.status,
    this.images,
    this.videos,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] as int?,
      userId: json['user_id']?.toString(),
      albumName: json['album_name'] as String?,
      albumPassword: json['album_password'] as String?,
      albumImage: json['album_image'] as String?,
      status: json['status'] as int?,
      images: json['images'] != null
          ? (json['images'] as List)
              .map((e) => AlbumImage.fromJson(e))
              .toList()
          : null,
      videos: json['videos'] != null
          ? (json['videos'] as List)
              .map((e) => ProfileVideo.fromJson(e))
              .toList()
          : null,
    );
  }
}

/// Album Image Model
class AlbumImage {
  final int? id;
  final String? albumId;
  final String? imageName;
  final String? imagePath;
  final String? imageFullPath;
  final String? createdAt;

  AlbumImage({
    this.id,
    this.albumId,
    this.imageName,
    this.imagePath,
    this.imageFullPath,
    this.createdAt,
  });

  factory AlbumImage.fromJson(Map<String, dynamic> json) {
    return AlbumImage(
      id: json['id'] as int?,
      albumId: json['album_id']?.toString(),
      imageName: json['image_name'] as String?,
      imagePath: json['image_path'] as String?,
      imageFullPath: json['image_full_path'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }
}