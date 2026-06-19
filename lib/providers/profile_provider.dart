// import 'dart:io';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../Api_services/api_service.dart';
// import '../model/user_profile_model.dart';

// // ─── API Service Provider ───
// final apiServiceProvider = Provider<ApiService>((ref) {
//   return ApiService();
// });

// // ─── Profile State ───
// enum ProfileStatus { initial, loading, loaded, error }

// class ProfileState {
//   final ProfileStatus status;
//   final UserProfileModel? profile;
//   final String? errorMessage;

//   const ProfileState({
//     this.status = ProfileStatus.initial,
//     this.profile,
//     this.errorMessage,
//   });

//   ProfileState copyWith({
//     ProfileStatus? status,
//     UserProfileModel? profile,
//     String? errorMessage,
//   }) {
//     return ProfileState(
//       status: status ?? this.status,
//       profile: profile ?? this.profile,
//       errorMessage: errorMessage,
//     );
//   }
// }

// // ─── Profile Notifier ───
// class ProfileNotifier extends StateNotifier<ProfileState> {
//   final ApiService _apiService;

//   ProfileNotifier(this._apiService) : super(const ProfileState()) {
//     fetchProfile();
//   }

//   Future<void> fetchProfile() async {
//     state = state.copyWith(status: ProfileStatus.loading);
//     try {
//       final profile = await _apiService.fetchUserProfile();
//       state = state.copyWith(
//         status: ProfileStatus.loaded,
//         profile: profile,
//       );
//     } on ApiException catch (e) {
//       state = state.copyWith(
//         status: ProfileStatus.error,
//         errorMessage: e.message,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         status: ProfileStatus.error,
//         errorMessage: 'An unexpected error occurred',
//       );
//     }
//   }

//   Future<void> updateProfile(Map<String, dynamic> data) async {
//     try {
//       final updated = await _apiService.updateUserProfile(data);
//       state = state.copyWith(
//         status: ProfileStatus.loaded,
//         profile: updated,
//       );
//     } on ApiException catch (e) {
//       state = state.copyWith(errorMessage: e.message);
//     }
//   }

//   void updateLocalProfile(UserProfileModel profile) {
//     state = state.copyWith(
//       status: ProfileStatus.loaded,
//       profile: profile,
//     );
//   }
// }

// final profileProvider =
//     StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
//   final apiService = ref.watch(apiServiceProvider);
//   return ProfileNotifier(apiService);
// });

// // ─── Selected Tab Provider ───
// final profileTabProvider = StateProvider<int>((ref) => 0);

// // ─── Photos State ───
// class PhotosState {
//   final bool isLoading;
//   final List<String> photos;
//   final String? error;
//   final bool isUploading;

//   const PhotosState({
//     this.isLoading = false,
//     this.photos = const [],
//     this.error,
//     this.isUploading = false,
//   });

//   PhotosState copyWith({
//     bool? isLoading,
//     List<String>? photos,
//     String? error,
//     bool? isUploading,
//   }) {
//     return PhotosState(
//       isLoading: isLoading ?? this.isLoading,
//       photos: photos ?? this.photos,
//       error: error,
//       isUploading: isUploading ?? this.isUploading,
//     );
//   }
// }

// class PhotosNotifier extends StateNotifier<PhotosState> {
//   final ApiService _apiService;

//   PhotosNotifier(this._apiService) : super(const PhotosState()) {
//     fetchPhotos();
//   }

//   Future<void> fetchPhotos() async {
//     state = state.copyWith(isLoading: true);
//     try {
//       final photos = await _apiService.fetchPhotos();
//       state = state.copyWith(isLoading: false, photos: photos);
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: 'Failed to load photos',
//       );
//     }
//   }

//   Future<void> uploadPhoto(File file) async {
//     state = state.copyWith(isUploading: true);
//     try {
//       await _apiService.uploadPhoto(file);
//       await fetchPhotos(); // Refresh
//       state = state.copyWith(isUploading: false);
//     } catch (e) {
//       state = state.copyWith(
//         isUploading: false,
//         error: 'Failed to upload photo',
//       );
//     }
//   }

//   void removePhoto(int index) {
//     final updated = List<String>.from(state.photos);
//     if (index >= 0 && index < updated.length) {
//       updated.removeAt(index);
//       state = state.copyWith(photos: updated);
//     }
//   }
// }

// final photosProvider =
//     StateNotifierProvider<PhotosNotifier, PhotosState>((ref) {
//   final apiService = ref.watch(apiServiceProvider);
//   return PhotosNotifier(apiService);
// });

// // ─── Videos State ───
// class VideosState {
//   final bool isLoading;
//   final List<String> videos;
//   final String? error;
//   final bool isUploading;

//   const VideosState({
//     this.isLoading = false,
//     this.videos = const [],
//     this.error,
//     this.isUploading = false,
//   });

//   VideosState copyWith({
//     bool? isLoading,
//     List<String>? videos,
//     String? error,
//     bool? isUploading,
//   }) {
//     return VideosState(
//       isLoading: isLoading ?? this.isLoading,
//       videos: videos ?? this.videos,
//       error: error,
//       isUploading: isUploading ?? this.isUploading,
//     );
//   }
// }

// class VideosNotifier extends StateNotifier<VideosState> {
//   final ApiService _apiService;

//   VideosNotifier(this._apiService) : super(const VideosState()) {
//     fetchVideos();
//   }

//   Future<void> fetchVideos() async {
//     state = state.copyWith(isLoading: true);
//     try {
//       final videos = await _apiService.fetchVideos();
//       state = state.copyWith(isLoading: false, videos: videos);
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: 'Failed to load videos',
//       );
//     }
//   }

//   Future<void> uploadVideo(File file) async {
//     state = state.copyWith(isUploading: true);
//     try {
//       await _apiService.uploadVideo(file);
//       await fetchVideos();
//       state = state.copyWith(isUploading: false);
//     } catch (e) {
//       state = state.copyWith(
//         isUploading: false,
//         error: 'Failed to upload video',
//       );
//     }
//   }

//   void removeVideo(int index) {
//     final updated = List<String>.from(state.videos);
//     if (index >= 0 && index < updated.length) {
//       updated.removeAt(index);
//       state = state.copyWith(videos: updated);
//     }
//   }
// }

// final videosProvider =
//     StateNotifierProvider<VideosNotifier, VideosState>((ref) {
//   final apiService = ref.watch(apiServiceProvider);
//   return VideosNotifier(apiService);
// });

// // ─── Albums State ───
// class AlbumsState {
//   final bool isLoading;
//   final List<Map<String, dynamic>> albums;
//   final String? error;

//   const AlbumsState({
//     this.isLoading = false,
//     this.albums = const [],
//     this.error,
//   });

//   AlbumsState copyWith({
//     bool? isLoading,
//     List<Map<String, dynamic>>? albums,
//     String? error,
//   }) {
//     return AlbumsState(
//       isLoading: isLoading ?? this.isLoading,
//       albums: albums ?? this.albums,
//       error: error,
//     );
//   }
// }

// class AlbumsNotifier extends StateNotifier<AlbumsState> {
//   final ApiService _apiService;

//   AlbumsNotifier(this._apiService) : super(const AlbumsState()) {
//     fetchAlbums();
//   }

//   Future<void> fetchAlbums() async {
//     state = state.copyWith(isLoading: true);
//     try {
//       final albums = await _apiService.fetchAlbums();
//       state = state.copyWith(isLoading: false, albums: albums);
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: 'Failed to load albums',
//       );
//     }
//   }

//   void createAlbum(String name) {
//     final updated = List<Map<String, dynamic>>.from(state.albums);
//     updated.add({
//       'id': DateTime.now().millisecondsSinceEpoch.toString(),
//       'name': name,
//       'photos': <String>[],
//       'created_at': DateTime.now().toIso8601String(),
//     });
//     state = state.copyWith(albums: updated);
//   }

//   void deleteAlbum(int index) {
//     final updated = List<Map<String, dynamic>>.from(state.albums);
//     if (index >= 0 && index < updated.length) {
//       updated.removeAt(index);
//       state = state.copyWith(albums: updated);
//     }
//   }
// }

// final albumsProvider =
//     StateNotifierProvider<AlbumsNotifier, AlbumsState>((ref) {
//   final apiService = ref.watch(apiServiceProvider);
//   return AlbumsNotifier(apiService);
// });

// // ─── Edit Profile Form State ───
// class EditFormState {
//   final bool isSaving;
//   final bool isSaved;
//   final String? error;
//   final Map<String, String> formData;

//   const EditFormState({
//     this.isSaving = false,
//     this.isSaved = false,
//     this.error,
//     this.formData = const {},
//   });

//   EditFormState copyWith({
//     bool? isSaving,
//     bool? isSaved,
//     String? error,
//     Map<String, String>? formData,
//   }) {
//     return EditFormState(
//       isSaving: isSaving ?? this.isSaving,
//       isSaved: isSaved ?? this.isSaved,
//       error: error,
//       formData: formData ?? this.formData,
//     );
//   }
// }

// class EditFormNotifier extends StateNotifier<EditFormState> {
//   EditFormNotifier() : super(const EditFormState());

//   void updateField(String key, String value) {
//     final updated = Map<String, String>.from(state.formData);
//     updated[key] = value;
//     state = state.copyWith(formData: updated, isSaved: false);
//   }

//   void initFromProfile(UserProfileModel profile) {
//     final data = <String, String>{};
//     if (profile.isSingle) {
//       data['single_full_name'] = profile.singleFullName;
//     } else {
//       data['couple_full_name_from'] = profile.coupleFullNameFrom;
//       data['couple_full_name_to'] = profile.coupleFullNameTo;
//     }
//     data['person1_height'] = profile.person1Height ?? '';
//     data['person1_weight'] = profile.person1Weight ?? '';
//     data['person1_body_type'] = profile.person1BodyType ?? '';
//     data['person1_ethnic_background'] = profile.person1EthnicBackground ?? '';
//     data['person1_smoking'] = profile.person1Smoking ?? '';
//     data['person1_drinking'] = profile.person1Drinking ?? '';
//     data['person1_sexuality'] = profile.person1Sexuality ?? '';
//     data['person1_relationship_orientation'] =
//         profile.person1RelationshipOrientation ?? '';
//     data['text'] = profile.text ?? '';
//     data['comment'] = profile.comment ?? '';

//     if (profile.isCouple) {
//       data['person2_height'] = profile.person2Height ?? '';
//       data['person2_weight'] = profile.person2Weight ?? '';
//       data['person2_body_type'] = profile.person2BodyType ?? '';
//       data['person2_ethnic_background'] =
//           profile.person2EthnicBackground ?? '';
//       data['person2_smoking'] = profile.person2Smoking ?? '';
//       data['person2_drinking'] = profile.person2Drinking ?? '';
//       data['person2_sexuality'] = profile.person2Sexuality ?? '';
//       data['person2_relationship_orientation'] =
//           profile.person2RelationshipOrientation ?? '';
//     }

//     state = state.copyWith(formData: data);
//   }

//   void setSaving(bool saving) {
//     state = state.copyWith(isSaving: saving);
//   }

//   void setSaved(bool saved) {
//     state = state.copyWith(isSaved: saved);
//   }

//   void setError(String? error) {
//     state = state.copyWith(error: error);
//   }

//   void reset() {
//     state = const EditFormState();
//   }
// }

// final editFormProvider =
//     StateNotifierProvider<EditFormNotifier, EditFormState>((ref) {
//   return EditFormNotifier();
// });




import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Api_services/api_service.dart';
import '../model/user_profile_model.dart';

// ─── API Service Provider ───
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// ─── Profile State ───
enum ProfileStatus { initial, loading, loaded, error }

class ProfileState {
  final ProfileStatus status;
  final UserProfileModel? profile;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfileModel? profile,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
    );
  }
}

// ─── Profile Notifier ───
class ProfileNotifier extends Notifier<ProfileState> {
  ApiService get _apiService => ref.read(apiServiceProvider);

  @override
  ProfileState build() {
    Future.microtask(fetchProfile);
    return const ProfileState();
  }

  Future<void> fetchProfile() async {
    state = state.copyWith(status: ProfileStatus.loading);

    try {
      final profile = await _apiService.fetchUserProfile();

      state = state.copyWith(
        status: ProfileStatus.loaded,
        profile: profile,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'An unexpected error occurred',
      );
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      final updated = await _apiService.updateUserProfile(data);

      state = state.copyWith(
        status: ProfileStatus.loaded,
        profile: updated,
      );
    } on ApiException catch (e) {
      state = state.copyWith(errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(errorMessage: 'An unexpected error occurred');
    }
  }

  void updateLocalProfile(UserProfileModel profile) {
    state = state.copyWith(
      status: ProfileStatus.loaded,
      profile: profile,
    );
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(
  ProfileNotifier.new,
);

// ─── Selected Tab Provider ───
class ProfileTabNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void setTab(int index) {
    state = index;
  }
}

final profileTabProvider = NotifierProvider<ProfileTabNotifier, int>(
  ProfileTabNotifier.new,
);

// ─── Photos State ───
class PhotosState {
  final bool isLoading;
  final List<String> photos;
  final String? error;
  final bool isUploading;

  const PhotosState({
    this.isLoading = false,
    this.photos = const [],
    this.error,
    this.isUploading = false,
  });

  PhotosState copyWith({
    bool? isLoading,
    List<String>? photos,
    String? error,
    bool? isUploading,
  }) {
    return PhotosState(
      isLoading: isLoading ?? this.isLoading,
      photos: photos ?? this.photos,
      error: error,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}

class PhotosNotifier extends Notifier<PhotosState> {
  ApiService get _apiService => ref.read(apiServiceProvider);

  @override
  PhotosState build() {
    Future.microtask(fetchPhotos);
    return const PhotosState();
  }

  Future<void> fetchPhotos() async {
    state = state.copyWith(isLoading: true);

    try {
      final photos = await _apiService.fetchPhotos();

      state = state.copyWith(
        isLoading: false,
        photos: photos,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load photos',
      );
    }
  }

  Future<void> uploadPhoto(File file) async {
    state = state.copyWith(isUploading: true);

    try {
      await _apiService.uploadPhoto(file);
      await fetchPhotos();

      state = state.copyWith(isUploading: false);
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        error: 'Failed to upload photo',
      );
    }
  }

  void removePhoto(int index) {
    final updated = List<String>.from(state.photos);

    if (index >= 0 && index < updated.length) {
      updated.removeAt(index);
      state = state.copyWith(photos: updated);
    }
  }
}

final photosProvider = NotifierProvider<PhotosNotifier, PhotosState>(
  PhotosNotifier.new,
);

// ─── Videos State ───
class VideosState {
  final bool isLoading;
  final List<String> videos;
  final String? error;
  final bool isUploading;

  const VideosState({
    this.isLoading = false,
    this.videos = const [],
    this.error,
    this.isUploading = false,
  });

  VideosState copyWith({
    bool? isLoading,
    List<String>? videos,
    String? error,
    bool? isUploading,
  }) {
    return VideosState(
      isLoading: isLoading ?? this.isLoading,
      videos: videos ?? this.videos,
      error: error,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}

class VideosNotifier extends Notifier<VideosState> {
  ApiService get _apiService => ref.read(apiServiceProvider);

  @override
  VideosState build() {
    Future.microtask(fetchVideos);
    return const VideosState();
  }

  Future<void> fetchVideos() async {
    state = state.copyWith(isLoading: true);

    try {
      final videos = await _apiService.fetchVideos();

      state = state.copyWith(
        isLoading: false,
        videos: videos,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load videos',
      );
    }
  }

  Future<void> uploadVideo(File file) async {
    state = state.copyWith(isUploading: true);

    try {
      await _apiService.uploadVideo(file);
      await fetchVideos();

      state = state.copyWith(isUploading: false);
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        error: 'Failed to upload video',
      );
    }
  }

  void removeVideo(int index) {
    final updated = List<String>.from(state.videos);

    if (index >= 0 && index < updated.length) {
      updated.removeAt(index);
      state = state.copyWith(videos: updated);
    }
  }
}

final videosProvider = NotifierProvider<VideosNotifier, VideosState>(
  VideosNotifier.new,
);

// ─── Albums State ───
class AlbumsState {
  final bool isLoading;
  final List<Map<String, dynamic>> albums;
  final String? error;

  const AlbumsState({
    this.isLoading = false,
    this.albums = const [],
    this.error,
  });

  AlbumsState copyWith({
    bool? isLoading,
    List<Map<String, dynamic>>? albums,
    String? error,
  }) {
    return AlbumsState(
      isLoading: isLoading ?? this.isLoading,
      albums: albums ?? this.albums,
      error: error,
    );
  }
}

class AlbumsNotifier extends Notifier<AlbumsState> {
  ApiService get _apiService => ref.read(apiServiceProvider);

  @override
  AlbumsState build() {
    Future.microtask(fetchAlbums);
    return const AlbumsState();
  }

  Future<void> fetchAlbums() async {
    state = state.copyWith(isLoading: true);

    try {
      final albums = await _apiService.fetchAlbums();

      state = state.copyWith(
        isLoading: false,
        albums: albums,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load albums',
      );
    }
  }

  void createAlbum(String name) {
    final updated = List<Map<String, dynamic>>.from(state.albums);

    updated.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'photos': <String>[],
      'created_at': DateTime.now().toIso8601String(),
    });

    state = state.copyWith(albums: updated);
  }

  void deleteAlbum(int index) {
    final updated = List<Map<String, dynamic>>.from(state.albums);

    if (index >= 0 && index < updated.length) {
      updated.removeAt(index);
      state = state.copyWith(albums: updated);
    }
  }
}

final albumsProvider = NotifierProvider<AlbumsNotifier, AlbumsState>(
  AlbumsNotifier.new,
);

// ─── Edit Profile Form State ───
class EditFormState {
  final bool isSaving;
  final bool isSaved;
  final String? error;
  final Map<String, String> formData;

  const EditFormState({
    this.isSaving = false,
    this.isSaved = false,
    this.error,
    this.formData = const {},
  });

  EditFormState copyWith({
    bool? isSaving,
    bool? isSaved,
    String? error,
    Map<String, String>? formData,
  }) {
    return EditFormState(
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
      error: error,
      formData: formData ?? this.formData,
    );
  }
}

class EditFormNotifier extends Notifier<EditFormState> {
  @override
  EditFormState build() {
    return const EditFormState();
  }

  void updateField(String key, String value) {
    final updated = Map<String, String>.from(state.formData);
    updated[key] = value;

    state = state.copyWith(
      formData: updated,
      isSaved: false,
    );
  }

  void initFromProfile(UserProfileModel profile) {
    final data = <String, String>{};

    if (profile.isSingle) {
      data['single_full_name'] = profile.singleFullName;
    } else {
      data['couple_full_name_from'] = profile.coupleFullNameFrom;
      data['couple_full_name_to'] = profile.coupleFullNameTo;
    }

    data['person1_height'] = profile.person1Height ?? '';
    data['person1_weight'] = profile.person1Weight ?? '';
    data['person1_body_type'] = profile.person1BodyType ?? '';
    data['person1_ethnic_background'] =
        profile.person1EthnicBackground ?? '';
    data['person1_smoking'] = profile.person1Smoking ?? '';
    data['person1_drinking'] = profile.person1Drinking ?? '';
    data['person1_sexuality'] = profile.person1Sexuality ?? '';
    data['person1_relationship_orientation'] =
        profile.person1RelationshipOrientation ?? '';
    data['text'] = profile.text ?? '';
    data['comment'] = profile.comment ?? '';

    if (profile.isCouple) {
      data['person2_height'] = profile.person2Height ?? '';
      data['person2_weight'] = profile.person2Weight ?? '';
      data['person2_body_type'] = profile.person2BodyType ?? '';
      data['person2_ethnic_background'] =
          profile.person2EthnicBackground ?? '';
      data['person2_smoking'] = profile.person2Smoking ?? '';
      data['person2_drinking'] = profile.person2Drinking ?? '';
      data['person2_sexuality'] = profile.person2Sexuality ?? '';
      data['person2_relationship_orientation'] =
          profile.person2RelationshipOrientation ?? '';
    }

    state = state.copyWith(formData: data);
  }

  void setSaving(bool saving) {
    state = state.copyWith(isSaving: saving);
  }

  void setSaved(bool saved) {
    state = state.copyWith(isSaved: saved);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void reset() {
    state = const EditFormState();
  }
}

final editFormProvider = NotifierProvider<EditFormNotifier, EditFormState>(
  EditFormNotifier.new,
);