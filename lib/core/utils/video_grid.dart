// import 'package:beatflirt/model/couple_profile.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';


// class VideoGrid extends StatefulWidget {
//   final List<ProfileVideo> videos;
//   final Function(ProfileVideo) onDelete;

//   const VideoGrid({super.key, required this.videos, required this.onDelete});

//   @override
//   State<VideoGrid> createState() => _VideoGridState();
// }

// class _VideoGridState extends State<VideoGrid> {
//   final Map<String, VideoPlayerController> _controllers = {};

//   @override
//   void dispose() {
//     _controllers.values.forEach((c) => c.dispose());
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.videos.isEmpty) {
//       return const Center(child: Text('No videos.', style: TextStyle(color: Colors.white70)));
//     }

//     return GridView.builder(
//       padding: const EdgeInsets.all(8),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 8,
//         mainAxisSpacing: 8,
//         childAspectRatio: 1,
//       ),
//       itemCount: widget.videos.length,
//       itemBuilder: (context, index) {
//         final vid = widget.videos[index];
//         if (!_controllers.containsKey(vid.id)) {
//           _controllers[vid.id] = VideoPlayerController.networkUrl(Uri.parse(vid.profileVideo))
//             ..initialize().then((_) => setState(() {}));
//         }
//         final controller = _controllers[vid.id]!;

//         return Card(
//           color: Colors.grey[900],
//           child: Stack(
//             children: [
//               controller.value.isInitialized
//                   ? AspectRatio(
//                       aspectRatio: controller.value.aspectRatio,
//                       child: VideoPlayer(controller),
//                     )
//                   : const Center(child: CircularProgressIndicator()),
//               Positioned(
//                 bottom: 8,
//                 right: 8,
//                 child: IconButton(
//                   icon: Icon(
//                     controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//                     color: Colors.white,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       if (controller.value.isPlaying) {
//                         controller.pause();
//                       } else {
//                         controller.play();
//                       }
//                     });
//                   },
//                 ),
//               ),
//               Positioned(
//                 top: 8,
//                 right: 8,
//                 child: IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   onPressed: () => widget.onDelete(vid),
//                 ),
//               ),
//               const Positioned(
//                 top: 8,
//                 left: 8,
//                 child: Chip(
//                   label: Text('APPROVED', style: TextStyle(fontSize: 10)),
//                   backgroundColor: Colors.green,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }