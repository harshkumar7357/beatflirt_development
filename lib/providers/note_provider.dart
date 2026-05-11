// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:dio/dio.dart';
//
// class Note {
//   final String id;
//   final String title;
//   final String content;
//   final String tag;
//   final bool isPinned;
//   final String timeAgo;
//   final DateTime createdAt;
//
//   Note({
//     required this.id,
//     required this.title,
//     required this.content,
//     required this.tag,
//     required this.isPinned,
//     required this.timeAgo,
//     required this.createdAt,
//   });
//
//   factory Note.fromJson(Map<String, dynamic> json) {
//     return Note(
//       id: json['_id'],
//       title: json['title'],
//       content: json['content'],
//       tag: json['tag'] ?? 'General',
//       isPinned: json['isPinned'] ?? false,
//       timeAgo: json['timeAgo'] ?? '',
//       createdAt: DateTime.parse(json['createdAt']),
//     );
//   }
// }
//
// class NoteNotifier extends StateNotifier<List<Note>> {
//   final Dio _dio;
//   final String baseUrl;
//
//   NoteNotifier(this._dio, this.baseUrl) : super([]) {
//     fetchNotes();
//   }
//
//   Future<void> fetchNotes() async {
//     try {
//       final response = await _dio.get('$baseUrl/api/notes');
//       final List data = response.data['data'];
//       state = data.map((e) => Note.fromJson(e)).toList();
//     } catch (e) {
//       print('Fetch notes error: $e');
//     }
//   }
//
//   Future<void> createNote({
//     required String title,
//     required String content,
//     String tag = 'General',
//   }) async {
//     try {
//       await _dio.post(
//         '$baseUrl/api/notes',
//         data: {'title': title, 'content': content, 'tag': tag},
//       );
//       await fetchNotes();
//     } catch (e) {
//       print('Create note error: $e');
//     }
//   }
//
//   Future<void> updateNote({
//     required String id,
//     String? title,
//     String? content,
//     String? tag,
//   }) async {
//     try {
//       final body = <String, dynamic>{};
//       if (title != null) body['title'] = title;
//       if (content != null) body['content'] = content;
//       if (tag != null) body['tag'] = tag;
//
//       await _dio.put('$baseUrl/api/notes/$id', data: body);
//       await fetchNotes();
//     } catch (e) {
//       print('Update note error: $e');
//     }
//   }
//
//   Future<void> deleteNote(String id) async {
//     try {
//       await _dio.delete('$baseUrl/api/notes/$id');
//       await fetchNotes();
//     } catch (e) {
//       print('Delete note error: $e');
//     }
//   }
//
//   Future<void> togglePin(String id) async {
//     try {
//       await _dio.patch('$baseUrl/api/notes/$id/pin');
//       await fetchNotes();
//     } catch (e) {
//       print('Toggle pin error: $e');
//     }
//   }
// }
//
// final noteProvider = StateNotifierProvider<NoteNotifier, List<Note>>((ref) {
//   final dio = Dio();
//   dio.interceptors.add(InterceptorsWrapper(
//     onRequest: (options, handler) {
//       // Add your token logic here
//       // const token = 'YOUR_SAVED_TOKEN';
//       // options.headers['Authorization'] = 'Bearer $token';
//       return handler.next(options);
//     },
//   ));
//   return NoteNotifier(dio, 'http://192.168.1.32:5001');
// });

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Note {
  final String id;
  final String title;
  final String content;
  final String tag;

  Note({required this.id, required this.title, required this.content, required this.tag});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      tag: json['tag'] ?? 'General',
    );
  }
}

class NoteNotifier extends StateNotifier<List<Note>> {
  final String baseUrl = 'http://192.168.1.32:5001'; // Your IP and Port

  NoteNotifier() : super([]) {
    fetchNotes();
  }

  // GET NOTES
  Future<void> fetchNotes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/notes'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        state = data.map((e) => Note.fromJson(e)).toList();
      }
    } catch (e) {
      print('Fetch error: $e');
    }
  }

  // CREATE NOTE
  Future<void> createNote({required String title, required String content, String tag = 'Dating'}) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/api/notes'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'title': title, 'content': content, 'tag': tag}),
      );
      await fetchNotes(); // refresh list
    } catch (e) {
      print('Create error: $e');
    }
  }

  // DELETE NOTE
  Future<void> deleteNote(String id) async {
    try {
      await http.delete(Uri.parse('$baseUrl/api/notes/$id'));
      await fetchNotes(); // refresh list
    } catch (e) {
      print('Delete error: $e');
    }
  }
}

final noteProvider = StateNotifierProvider<NoteNotifier, List<Note>>((ref) {
  return NoteNotifier();
});