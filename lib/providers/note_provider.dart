// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:dio/dio.dart';
// //
// // class Note {
// //   final String id;
// //   final String title;
// //   final String content;
// //   final String tag;
// //   final bool isPinned;
// //   final String timeAgo;
// //   final DateTime createdAt;
// //
// //   Note({
// //     required this.id,
// //     required this.title,
// //     required this.content,
// //     required this.tag,
// //     required this.isPinned,
// //     required this.timeAgo,
// //     required this.createdAt,
// //   });
// //
// //   factory Note.fromJson(Map<String, dynamic> json) {
// //     return Note(
// //       id: json['_id'],
// //       title: json['title'],
// //       content: json['content'],
// //       tag: json['tag'] ?? 'General',
// //       isPinned: json['isPinned'] ?? false,
// //       timeAgo: json['timeAgo'] ?? '',
// //       createdAt: DateTime.parse(json['createdAt']),
// //     );
// //   }
// // }
// //
// // class NoteNotifier extends StateNotifier<List<Note>> {
// //   final Dio _dio;
// //   final String baseUrl;
// //
// //   NoteNotifier(this._dio, this.baseUrl) : super([]) {
// //     fetchNotes();
// //   }
// //
// //   Future<void> fetchNotes() async {
// //     try {
// //       final response = await _dio.get('$baseUrl/api/notes');
// //       final List data = response.data['data'];
// //       state = data.map((e) => Note.fromJson(e)).toList();
// //     } catch (e) {
// //       print('Fetch notes error: $e');
// //     }
// //   }
// //
// //   Future<void> createNote({
// //     required String title,
// //     required String content,
// //     String tag = 'General',
// //   }) async {
// //     try {
// //       await _dio.post(
// //         '$baseUrl/api/notes',
// //         data: {'title': title, 'content': content, 'tag': tag},
// //       );
// //       await fetchNotes();
// //     } catch (e) {
// //       print('Create note error: $e');
// //     }
// //   }
// //
// //   Future<void> updateNote({
// //     required String id,
// //     String? title,
// //     String? content,
// //     String? tag,
// //   }) async {
// //     try {
// //       final body = <String, dynamic>{};
// //       if (title != null) body['title'] = title;
// //       if (content != null) body['content'] = content;
// //       if (tag != null) body['tag'] = tag;
// //
// //       await _dio.put('$baseUrl/api/notes/$id', data: body);
// //       await fetchNotes();
// //     } catch (e) {
// //       print('Update note error: $e');
// //     }
// //   }
// //
// //   Future<void> deleteNote(String id) async {
// //     try {
// //       await _dio.delete('$baseUrl/api/notes/$id');
// //       await fetchNotes();
// //     } catch (e) {
// //       print('Delete note error: $e');
// //     }
// //   }
// //
// //   Future<void> togglePin(String id) async {
// //     try {
// //       await _dio.patch('$baseUrl/api/notes/$id/pin');
// //       await fetchNotes();
// //     } catch (e) {
// //       print('Toggle pin error: $e');
// //     }
// //   }
// // }
// //
// // final noteProvider = StateNotifierProvider<NoteNotifier, List<Note>>((ref) {
// //   final dio = Dio();
// //   dio.interceptors.add(InterceptorsWrapper(
// //     onRequest: (options, handler) {
// //       // Add your token logic here
// //       // const token = 'YOUR_SAVED_TOKEN';
// //       // options.headers['Authorization'] = 'Bearer $token';
// //       return handler.next(options);
// //     },
// //   ));
// //   return NoteNotifier(dio, 'http://192.168.1.32:5001');
// // });

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:io';
// import 'dart:async';
// import '../core/services/auth_services.dart';
// import 'package:flutter_riverpod/legacy.dart';

// class Note {
//   final String id;
//   final String title;
//   final String content;
//   final String tag;
//   final bool isPinned;

//   Note({
//     required this.id,
//     required this.title,
//     required this.content,
//     required this.tag,
//     this.isPinned = false,
//   });

//   factory Note.fromJson(Map<String, dynamic> json) {
//     return Note(
//       id: json['_id'] ?? '',
//       title: json['title'] ?? '',
//       content: json['content'] ?? '',
//       tag: json['tag'] ?? 'General',
//       isPinned: json['isPinned'] ?? false,
//     );
//   }
// }

// class NoteNotifier extends StateNotifier<List<Note>> {
//   static const String _baseUrl = String.fromEnvironment(
//     'API_BASE_URL',
//     defaultValue: 'http://192.168.1.13:5001',
//   );
//   static const Duration _timeout = Duration(seconds: 15);

//   NoteNotifier() : super([]) {
//     fetchNotes();
//   }

//   Uri _uri(String path) => Uri.parse('$_baseUrl$path');

//   Future<Map<String, String>> _authHeaders() async {
//     final token = await AuthService.getToken();
//     return {
//       'Content-Type': 'application/json',
//       if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
//     };
//   }

//   // GET NOTES
//   Future<void> fetchNotes() async {
//     try {
//       final headers = await _authHeaders();
//       final response = await http
//           .get(_uri('/api/notes'), headers: headers)
//           .timeout(_timeout);
//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//         final data = decoded['data'] as List;
//         state = data.map((e) => Note.fromJson(e)).toList();
//       }
//     } on SocketException {
//       print('Notes fetch error: No internet or server unreachable');
//     } on TimeoutException {
//       print('Notes fetch error: Request timed out');
//     } catch (e) {
//       print('Notes fetch error: $e');
//     }
//   }

//   // CREATE NOTE
//   Future<void> createNote({
//     required String title,
//     required String content,
//     String tag = 'General',
//   }) async {
//     try {
//       final headers = await _authHeaders();
//       final response = await http
//           .post(
//             _uri('/api/notes'),
//             headers: headers,
//             body: jsonEncode({'title': title, 'content': content, 'tag': tag}),
//           )
//           .timeout(_timeout);
//       if (response.statusCode == 201 || response.statusCode == 200) {
//         await fetchNotes();
//       } else {
//         final body = jsonDecode(response.body);
//         print('Create note error: ${body['message'] ?? response.statusCode}');
//       }
//     } on SocketException {
//       print('Create note error: No internet or server unreachable');
//     } on TimeoutException {
//       print('Create note error: Request timed out');
//     } catch (e) {
//       print('Create note error: $e');
//     }
//   }

//   // UPDATE NOTE
//   Future<void> updateNote({
//     required String id,
//     String? title,
//     String? content,
//     String? tag,
//   }) async {
//     try {
//       final headers = await _authHeaders();
//       final body = <String, dynamic>{};
//       if (title != null) body['title'] = title;
//       if (content != null) body['content'] = content;
//       if (tag != null) body['tag'] = tag;

//       final response = await http
//           .put(
//             _uri('/api/notes/$id'),
//             headers: headers,
//             body: jsonEncode(body),
//           )
//           .timeout(_timeout);
//       if (response.statusCode == 200) {
//         await fetchNotes();
//       } else {
//         final decoded = jsonDecode(response.body);
//         print('Update note error: ${decoded['message'] ?? response.statusCode}');
//       }
//     } on SocketException {
//       print('Update note error: No internet or server unreachable');
//     } on TimeoutException {
//       print('Update note error: Request timed out');
//     } catch (e) {
//       print('Update note error: $e');
//     }
//   }

//   // DELETE NOTE
//   Future<void> deleteNote(String id) async {
//     try {
//       final headers = await _authHeaders();
//       final response = await http
//           .delete(_uri('/api/notes/$id'), headers: headers)
//           .timeout(_timeout);
//       if (response.statusCode == 200) {
//         await fetchNotes();
//       } else {
//         final decoded = jsonDecode(response.body);
//         print('Delete note error: ${decoded['message'] ?? response.statusCode}');
//       }
//     } on SocketException {
//       print('Delete note error: No internet or server unreachable');
//     } on TimeoutException {
//       print('Delete note error: Request timed out');
//     } catch (e) {
//       print('Delete note error: $e');
//     }
//   }

//   // TOGGLE PIN
//   Future<void> togglePin(String id) async {
//     try {
//       final headers = await _authHeaders();
//       final response = await http
//           .patch(_uri('/api/notes/$id/pin'), headers: headers)
//           .timeout(_timeout);
//       if (response.statusCode == 200) {
//         await fetchNotes();
//       } else {
//         final decoded = jsonDecode(response.body);
//         print('Toggle pin error: ${decoded['message'] ?? response.statusCode}');
//       }
//     } on SocketException {
//       print('Toggle pin error: No internet or server unreachable');
//     } on TimeoutException {
//       print('Toggle pin error: Request timed out');
//     } catch (e) {
//       print('Toggle pin error: $e');
//     }
//   }
// }

// final noteProvider = StateNotifierProvider<NoteNotifier, List<Note>>((ref) {
//   return NoteNotifier();
// });




import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../core/services/auth_services.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final String tag;
  final bool isPinned;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.tag,
    this.isPinned = false,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      tag: json['tag']?.toString() ?? 'General',
      isPinned: json['isPinned'] == true,
    );
  }
}

class NoteNotifier extends Notifier<List<Note>> {
  static const String _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.1.13:5001',
  );

  static const Duration _timeout = Duration(seconds: 15);

  @override
  List<Note> build() {
    Future.microtask(fetchNotes);
    return const [];
  }

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  Future<Map<String, String>> _authHeaders() async {
    final token = await AuthService.getToken();

    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // GET NOTES
  Future<void> fetchNotes() async {
    try {
      final headers = await _authHeaders();

      final response = await http
          .get(
            _uri('/api/notes'),
            headers: headers,
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final rawData = decoded['data'];

        if (rawData is List) {
          state = rawData
              .map((e) => Note.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        } else {
          state = const [];
        }
      } else {
        final decoded = jsonDecode(response.body);
        print('Fetch notes error: ${decoded['message'] ?? response.statusCode}');
      }
    } on SocketException {
      print('Notes fetch error: No internet or server unreachable');
    } on TimeoutException {
      print('Notes fetch error: Request timed out');
    } catch (e) {
      print('Notes fetch error: $e');
    }
  }

  // CREATE NOTE
  Future<void> createNote({
    required String title,
    required String content,
    String tag = 'General',
  }) async {
    try {
      final headers = await _authHeaders();

      final response = await http
          .post(
            _uri('/api/notes'),
            headers: headers,
            body: jsonEncode({
              'title': title,
              'content': content,
              'tag': tag,
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 201 || response.statusCode == 200) {
        await fetchNotes();
      } else {
        final decoded = jsonDecode(response.body);
        print('Create note error: ${decoded['message'] ?? response.statusCode}');
      }
    } on SocketException {
      print('Create note error: No internet or server unreachable');
    } on TimeoutException {
      print('Create note error: Request timed out');
    } catch (e) {
      print('Create note error: $e');
    }
  }

  // UPDATE NOTE
  Future<void> updateNote({
    required String id,
    String? title,
    String? content,
    String? tag,
  }) async {
    try {
      final headers = await _authHeaders();

      final body = <String, dynamic>{};

      if (title != null) body['title'] = title;
      if (content != null) body['content'] = content;
      if (tag != null) body['tag'] = tag;

      final response = await http
          .put(
            _uri('/api/notes/$id'),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        await fetchNotes();
      } else {
        final decoded = jsonDecode(response.body);
        print('Update note error: ${decoded['message'] ?? response.statusCode}');
      }
    } on SocketException {
      print('Update note error: No internet or server unreachable');
    } on TimeoutException {
      print('Update note error: Request timed out');
    } catch (e) {
      print('Update note error: $e');
    }
  }

  // DELETE NOTE
  Future<void> deleteNote(String id) async {
    try {
      final headers = await _authHeaders();

      final response = await http
          .delete(
            _uri('/api/notes/$id'),
            headers: headers,
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        await fetchNotes();
      } else {
        final decoded = jsonDecode(response.body);
        print('Delete note error: ${decoded['message'] ?? response.statusCode}');
      }
    } on SocketException {
      print('Delete note error: No internet or server unreachable');
    } on TimeoutException {
      print('Delete note error: Request timed out');
    } catch (e) {
      print('Delete note error: $e');
    }
  }

  // TOGGLE PIN
  Future<void> togglePin(String id) async {
    try {
      final headers = await _authHeaders();

      final response = await http
          .patch(
            _uri('/api/notes/$id/pin'),
            headers: headers,
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        await fetchNotes();
      } else {
        final decoded = jsonDecode(response.body);
        print('Toggle pin error: ${decoded['message'] ?? response.statusCode}');
      }
    } on SocketException {
      print('Toggle pin error: No internet or server unreachable');
    } on TimeoutException {
      print('Toggle pin error: Request timed out');
    } catch (e) {
      print('Toggle pin error: $e');
    }
  }
}

final noteProvider = NotifierProvider<NoteNotifier, List<Note>>(
  NoteNotifier.new,
);