// // import 'package:flutter/material.dart';
// // import 'package:beatflirt/core/constants.dart';
// //
// // class ShimmerLoading extends StatefulWidget {
// //   final double width;
// //   final double height;
// //   final double borderRadius;
// //
// //   const ShimmerLoading({
// //     super.key,
// //     this.width = double.infinity,
// //     this.height = 20,
// //     this.borderRadius = 8,
// //   });
// //
// //   @override
// //   State<ShimmerLoading> createState() => _ShimmerLoadingState();
// // }
// //
// // class _ShimmerLoadingState extends State<ShimmerLoading>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _controller;
// //   late Animation<double> _animation;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 1500),
// //     )..repeat();
// //     _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
// //       CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return AnimatedBuilder(
// //       animation: _animation,
// //       builder: (context, child) {
// //         return Container(
// //           width: widget.width,
// //           height: widget.height,
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(widget.borderRadius),
// //             gradient: LinearGradient(
// //               begin: Alignment(_animation.value - 1, 0),
// //               end: Alignment(_animation.value, 0),
// //               colors: const [
// //                 AppColors.cardDark,
// //                 Color(0xFF2A2A3E),
// //                 AppColors.cardDark,
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }
// //
// // class AnimatedBuilder extends AnimatedWidget {
// //   final Widget Function(BuildContext, Widget?) builder;
// //
// //   const AnimatedBuilder({
// //     super.key,
// //     required super.listenable,
// //     required this.builder,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return builder(context, null);
// //   }
// // }
// //
// // class ProfileShimmer extends StatelessWidget {
// //   const ProfileShimmer({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SingleChildScrollView(
// //       padding: const EdgeInsets.all(16),
// //       child: Column(
// //         children: [
// //           const SizedBox(height: 20),
// //           // Avatar shimmer
// //           const ShimmerLoading(width: 110, height: 110, borderRadius: 55),
// //           const SizedBox(height: 16),
// //           const ShimmerLoading(width: 180, height: 24),
// //           const SizedBox(height: 8),
// //           const ShimmerLoading(width: 120, height: 16),
// //           const SizedBox(height: 24),
// //           // Card shimmer
// //           ...List.generate(3, (i) => Padding(
// //             padding: const EdgeInsets.only(bottom: 12),
// //             child: ShimmerLoading(height: 120, borderRadius: 16),
// //           )),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import '../core/constants.dart';
//
// class ShimmerLoading extends StatefulWidget {
//   final double width;
//   final double height;
//   final double borderRadius;
//
//   const ShimmerLoading({
//     super.key,
//     this.width = double.infinity,
//     this.height = 20,
//     this.borderRadius = 8,
//   });
//
//   @override
//   State<ShimmerLoading> createState() => _ShimmerLoadingState();
// }
//
// class _ShimmerLoadingState extends State<ShimmerLoading>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     )..repeat();
//     _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return Container(
//           width: widget.width,
//           height: widget.height,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(widget.borderRadius),
//             gradient: LinearGradient(
//               begin: Alignment(_animation.value - 1, 0),
//               end: Alignment(_animation.value, 0),
//               colors: const [
//                 AppColors.cardDark,
//                 Color(0xFF2A2A3E),
//                 AppColors.cardDark,
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// class ProfileShimmer extends StatelessWidget {
//   const ProfileShimmer({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           const SizedBox(height: 20),
//           // Avatar shimmer
//           const ShimmerLoading(width: 110, height: 110, borderRadius: 55),
//           const SizedBox(height: 16),
//           const ShimmerLoading(width: 180, height: 24),
//           const SizedBox(height: 8),
//           const ShimmerLoading(width: 120, height: 16),
//           const SizedBox(height: 24),
//           // Card shimmer
//           ...List.generate(
//             3,
//                 (i) => const Padding(
//               padding: EdgeInsets.only(bottom: 12),
//               child: ShimmerLoading(height: 120, borderRadius: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
