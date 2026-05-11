import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../providers/note_provider.dart';

class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          _buildNotesHeader(),
          _buildNotesList(),
          const SliverPadding(padding: EdgeInsets.only(bottom: 50)),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: const Color(0xFF0F0F1A),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: const Text(
        'MY NOTES',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 16,
          letterSpacing: 2.0,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add_circle_outline, color: Colors.pinkAccent),
        ),
      ],
    );
  }

  Widget _buildNotesHeader() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFFFDD835), Color(0xFFFBC02D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Row(
          children: [
            FaIcon(FontAwesomeIcons.noteSticky, color: Colors.white, size: 40),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quick Thoughts', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('Keep track of your dating journey', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _buildNoteCard(index);
        },
        childCount: 3,
      ),
    );
  }

  Widget _buildNoteCard(int index) {
    final titles = ['Meeting with Sarah', 'Gift Ideas', 'Dream Date Locations'];
    final contents = [
      'She likes Italian food. Don\'t forget to mention the trip to Rome.',
      'Perfume, Hand-written letter, maybe flowers?',
      'Beach sunset, Rooftop cinema, Botanical garden walk.'
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(titles[index % titles.length], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              const Text('2d ago', style: TextStyle(color: Colors.white54, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 10),
          Text(contents[index % contents.length], style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(Icons.label_outline, color: Colors.pinkAccent, size: 14),
              const SizedBox(width: 5),
              Text('Dating', style: TextStyle(color: Colors.pinkAccent.withValues(alpha: 0.7), fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import '../../providers/note_provider.dart';
// // import 'providers/note_provider.dart';
//
// class NotesPage extends ConsumerWidget {
//   const NotesPage({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final notes = ref.watch(noteProvider);
//
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F0F1A),
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           _buildAppBar(context, ref),
//           _buildNotesHeader(),
//           notes.isEmpty
//               ? const SliverFillRemaining(
//             child: Center(
//               child: Text(
//                 'No notes yet.\nTap + to create one!',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.white38, fontSize: 16),
//               ),
//             ),
//           )
//               : _buildNotesList(notes, ref),
//           const SliverPadding(padding: EdgeInsets.only(bottom: 50)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAppBar(BuildContext context, WidgetRef ref) {
//     return SliverAppBar(
//       floating: true,
//       pinned: true,
//       backgroundColor: const Color(0xFF0F0F1A),
//       elevation: 0,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
//         onPressed: () => Navigator.pop(context),
//       ),
//       centerTitle: true,
//       title: const Text(
//         'MY NOTES',
//         style: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.w900,
//           fontSize: 16,
//           letterSpacing: 2.0,
//         ),
//       ),
//       actions: [
//         IconButton(
//           onPressed: () => _showCreateDialog(context, ref),
//           icon: const Icon(Icons.add_circle_outline, color: Colors.pinkAccent),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildNotesHeader() {
//     return SliverToBoxAdapter(
//       child: Container(
//         margin: const EdgeInsets.all(20),
//         padding: const EdgeInsets.all(25),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           gradient: const LinearGradient(
//             colors: [Color(0xFFFDD835), Color(0xFFFBC02D)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: const Row(
//           children: [
//             FaIcon(FontAwesomeIcons.noteSticky, color: Colors.white, size: 40),
//             SizedBox(width: 20),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Quick Thoughts',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold)),
//                   Text('Keep track of your dating journey',
//                       style: TextStyle(color: Colors.white70, fontSize: 13)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNotesList(List<Note> notes, WidgetRef ref) {
//     return SliverList(
//       delegate: SliverChildBuilderDelegate(
//             (context, index) => _buildNoteCard(notes[index], ref, context),
//         childCount: notes.length,
//       ),
//     );
//   }
//
//   Widget _buildNoteCard(Note note, WidgetRef ref, BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.05),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: note.isPinned
//               ? Colors.pinkAccent.withValues(alpha: 0.4)
//               : Colors.white.withValues(alpha: 0.1),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Row(
//                   children: [
//                     if (note.isPinned)
//                       const Padding(
//                         padding: EdgeInsets.only(right: 6),
//                         child: Icon(Icons.push_pin, color: Colors.pinkAccent, size: 14),
//                       ),
//                     Expanded(
//                       child: Text(
//                         note.title,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(note.timeAgo,
//                       style: const TextStyle(color: Colors.white54, fontSize: 11)),
//                   PopupMenuButton<String>(
//                     color: const Color(0xFF1A1A2E),
//                     icon: const Icon(Icons.more_vert, color: Colors.white54, size: 18),
//                     onSelected: (value) {
//                       if (value == 'edit') {
//                         _showEditDialog(context, ref, note);
//                       } else if (value == 'delete') {
//                         _confirmDelete(context, ref, note.id);
//                       } else if (value == 'pin') {
//                         ref.read(noteProvider.notifier).togglePin(note.id);
//                       }
//                     },
//                     itemBuilder: (context) => [
//                       PopupMenuItem(
//                         value: 'pin',
//                         child: Text(
//                           note.isPinned ? 'Unpin' : 'Pin',
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                       ),
//                       const PopupMenuItem(
//                         value: 'edit',
//                         child: Text('Edit', style: TextStyle(color: Colors.white)),
//                       ),
//                       const PopupMenuItem(
//                         value: 'delete',
//                         child: Text('Delete', style: TextStyle(color: Colors.redAccent)),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Text(
//             note.content,
//             style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
//             maxLines: 3,
//             overflow: TextOverflow.ellipsis,
//           ),
//           const SizedBox(height: 15),
//           Row(
//             children: [
//               const Icon(Icons.label_outline, color: Colors.pinkAccent, size: 14),
//               const SizedBox(width: 5),
//               Text(note.tag,
//                   style: TextStyle(
//                       color: Colors.pinkAccent.withValues(alpha: 0.7), fontSize: 11)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showCreateDialog(BuildContext context, WidgetRef ref) {
//     final titleCtrl = TextEditingController();
//     final contentCtrl = TextEditingController();
//     String selectedTag = 'Dating';
//
//     final tags = ['Dating', 'Gift Ideas', 'Locations', 'General', 'Reminders', 'Conversation'];
//
//     showDialog(
//       context: context,
//       builder: (ctx) {
//         return StatefulBuilder(
//           builder: (ctx, setInnerState) {
//             return AlertDialog(
//               backgroundColor: const Color(0xFF1A1A2E),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//               title: const Text('New Note', style: TextStyle(color: Colors.white)),
//               content: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextField(
//                       controller: titleCtrl,
//                       style: const TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         hintText: 'Title',
//                         hintStyle: const TextStyle(color: Colors.white38),
//                         filled: true,
//                         fillColor: Colors.white.withValues(alpha: 0.05),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     TextField(
//                       controller: contentCtrl,
//                       style: const TextStyle(color: Colors.white),
//                       maxLines: 4,
//                       decoration: InputDecoration(
//                         hintText: 'Content...',
//                         hintStyle: const TextStyle(color: Colors.white38),
//                         filled: true,
//                         fillColor: Colors.white.withValues(alpha: 0.05),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     DropdownButtonFormField<String>(
//                       value: selectedTag,
//                       dropdownColor: const Color(0xFF1A1A2E),
//                       style: const TextStyle(color: Colors.white, fontSize: 14),
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.white.withValues(alpha: 0.05),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       items: tags
//                           .map((t) => DropdownMenuItem(value: t, child: Text(t)))
//                           .toList(),
//                       onChanged: (val) => setInnerState(() => selectedTag = val!),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(ctx),
//                   child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
//                 ),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.pinkAccent,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   onPressed: () {
//                     if (titleCtrl.text.trim().isEmpty ||
//                         contentCtrl.text.trim().isEmpty) return;
//                     ref.read(noteProvider.notifier).createNote(
//                       title: titleCtrl.text.trim(),
//                       content: contentCtrl.text.trim(),
//                       tag: selectedTag,
//                     );
//                     Navigator.pop(ctx);
//                   },
//                   child: const Text('Save', style: TextStyle(color: Colors.white)),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _showEditDialog(BuildContext context, WidgetRef ref, Note note) {
//     final titleCtrl = TextEditingController(text: note.title);
//     final contentCtrl = TextEditingController(text: note.content);
//     String selectedTag = note.tag;
//
//     final tags = ['Dating', 'Gift Ideas', 'Locations', 'General', 'Reminders', 'Conversation'];
//
//     showDialog(
//       context: context,
//       builder: (ctx) {
//         return StatefulBuilder(
//           builder: (ctx, setInnerState) {
//             return AlertDialog(
//               backgroundColor: const Color(0xFF1A1A2E),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//               title: const Text('Edit Note', style: TextStyle(color: Colors.white)),
//               content: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextField(
//                       controller: titleCtrl,
//                       style: const TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         hintText: 'Title',
//                         hintStyle: const TextStyle(color: Colors.white38),
//                         filled: true,
//                         fillColor: Colors.white.withValues(alpha: 0.05),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     TextField(
//                       controller: contentCtrl,
//                       style: const TextStyle(color: Colors.white),
//                       maxLines: 4,
//                       decoration: InputDecoration(
//                         hintText: 'Content...',
//                         hintStyle: const TextStyle(color: Colors.white38),
//                         filled: true,
//                         fillColor: Colors.white.withValues(alpha: 0.05),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     DropdownButtonFormField<String>(
//                       value: selectedTag,
//                       dropdownColor: const Color(0xFF1A1A2E),
//                       style: const TextStyle(color: Colors.white, fontSize: 14),
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.white.withValues(alpha: 0.05),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       items: tags
//                           .map((t) => DropdownMenuItem(value: t, child: Text(t)))
//                           .toList(),
//                       onChanged: (val) => setInnerState(() => selectedTag = val!),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(ctx),
//                   child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
//                 ),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.pinkAccent,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   onPressed: () {
//                     ref.read(noteProvider.notifier).updateNote(
//                       id: note.id,
//                       title: titleCtrl.text.trim(),
//                       content: contentCtrl.text.trim(),
//                       tag: selectedTag,
//                     );
//                     Navigator.pop(ctx);
//                   },
//                   child: const Text('Update', style: TextStyle(color: Colors.white)),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _confirmDelete(BuildContext context, WidgetRef ref, String noteId) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         backgroundColor: const Color(0xFF1A1A2E),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: const Text('Delete Note?', style: TextStyle(color: Colors.white)),
//         content: const Text(
//           'This action cannot be undone.',
//           style: TextStyle(color: Colors.white70),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.redAccent,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             ),
//             onPressed: () {
//               ref.read(noteProvider.notifier).deleteNote(noteId);
//               Navigator.pop(ctx);
//             },
//             child: const Text('Delete', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
// }
