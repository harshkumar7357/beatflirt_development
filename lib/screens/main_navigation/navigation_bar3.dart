// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // import '../content/app_drawer.dart';
// import 'package:beatflirt/content/app_drawer.dart';
// import 'tabs/home_tab.dart';
// import 'tabs/chats_tab.dart';
// import 'tabs/maps_tab.dart';
// import 'tabs/profile_tab.dart';

// class MainNavigationPage extends StatefulWidget {
//   const MainNavigationPage({super.key});
//   @override
//   State<MainNavigationPage> createState() => _MainNavigationPageState();
// }

// class _MainNavigationPageState extends State<MainNavigationPage>
//     with TickerProviderStateMixin {
//   int _currentIndex = 0;

//   late final List<AnimationController> _bounceCtrs;
//   late final List<Animation<double>> _bounceAnims;
//   late final AnimationController _glowCtrl;
//   late final Animation<double> _glowAnim;
//   late final AnimationController _fadeCtrl;
//   late final Animation<double> _fadeAnim;

//   static const List<_NavItem> _items = [
//     _NavItem(Icons.home_outlined, Icons.home_rounded, 'Home'),
//     _NavItem(Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded, 'Chats'),
//     _NavItem(Icons.location_on_outlined, Icons.location_on_rounded, 'Maps'),
//     _NavItem(Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
//   ];

//   // final List<Widget> _pages = const [HomeTab(), ChatsTab(), MapsTab(), ProfileTab()];

//   @override
//   void initState() {
//     super.initState();
//     _bounceCtrs = List.generate(4, (_) =>
//         AnimationController(vsync: this, duration: const Duration(milliseconds: 400)));
//     _bounceAnims = _bounceCtrs.map((c) => TweenSequence<double>([
//       TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.88), weight: 25),
//       TweenSequenceItem(tween: Tween(begin: 0.88, end: 1.06), weight: 50),
//       TweenSequenceItem(tween: Tween(begin: 1.06, end: 1.0), weight: 25),
//     ]).animate(CurvedAnimation(parent: c, curve: Curves.easeOutCubic))).toList();

//     _glowCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))
//       ..repeat(reverse: true);
//     _glowAnim = Tween(begin: 0.2, end: 0.5).animate(
//         CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));

//     _fadeCtrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 280), value: 1.0);
//     _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeInOut);

//     _bounceCtrs[0].forward();
//   }

//   @override
//   void dispose() {
//     for (final c in _bounceCtrs) {
//       c.dispose();
//     }
//     _glowCtrl.dispose();
//     _fadeCtrl.dispose();
//     super.dispose();
//   }

//   void _onTap(int i) {
//     if (i == _currentIndex) return;
//     HapticFeedback.lightImpact();
//     _bounceCtrs[i].forward(from: 0);
//     _fadeCtrl.reverse().then((_) {
//       if (mounted) setState(() => _currentIndex = i);
//       _fadeCtrl.forward();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light,
//       child: Scaffold(
//         extendBody: true,
//         backgroundColor: const Color(0xFF0A0A14),
//         drawer: const AppDrawer(),
//         body: FadeTransition(
//           opacity: _fadeAnim,
//           child: IndexedStack(index: _currentIndex, children: _pages),
//         ),
//         bottomNavigationBar: _buildNav(),
//       ),
//     );
//   }

//   Widget _buildNav() {
//     final bp = MediaQuery.of(context).padding.bottom;
//     return Padding(
//       padding: EdgeInsets.fromLTRB(18, 0, 18, bp > 0 ? bp : 12),
//       child: ClipRRect(
//         // borderRadius: BorderRadius.circular(36),
//         borderRadius: BorderRadius.circular(30),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
//           child: AnimatedBuilder(
//             animation: _glowAnim,
//             builder: (ctx, child) => Container(
//               height: 72,
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF151522).withOpacity(0.88),
//                 borderRadius: BorderRadius.circular(36),
//                 border: Border.all(
//                     color: Colors.white.withOpacity(0.12), width: 1.2),
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.black.withOpacity(0.4),
//                       blurRadius: 28,
//                       offset: const Offset(0, 12)),
//                   BoxShadow(
//                       color: Colors.pinkAccent.withOpacity(_glowAnim.value * 0.1),
//                       blurRadius: 40,
//                       spreadRadius: -4),
//                 ],
//               ),
//               child: child,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: List.generate(4, _buildItem),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildItem(int i) {
//     final active = _currentIndex == i;
//     return GestureDetector(
//       onTap: () => _onTap(i),
//       behavior: HitTestBehavior.opaque,
//       child: ScaleTransition(
//         scale: _bounceAnims[i],
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 350),
//           curve: Curves.easeOutCubic,
//           width: active ? 110 : 52,
//           height: 52,
//           decoration: BoxDecoration(
//             gradient: active
//                 ? const LinearGradient(
//                     colors: [Colors.pinkAccent, Colors.purpleAccent],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight)
//                 : null,
//             borderRadius: BorderRadius.circular(28),
//             boxShadow: active
//                 ? [BoxShadow(
//                     color: Colors.pinkAccent.withOpacity(0.45),
//                     blurRadius: 16,
//                     offset: const Offset(0, 5))]
//                 : [],
//           ),
//           child: ClipRect(
//             child: OverflowBox(
//               maxWidth: 160,
//               alignment: Alignment.center,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   AnimatedSwitcher(
//                     duration: const Duration(milliseconds: 250),
//                     child: Icon(
//                       active ? _items[i].activeIcon : _items[i].icon,
//                       key: ValueKey(active),
//                       color: active ? Colors.white : Colors.white54,
//                       size: 24,
//                     ),
//                   ),
//                   if (active) ...[
//                     const SizedBox(width: 7),
//                     Text(
//                       _items[i].label,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 13.5,
//                         letterSpacing: 0.3,
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _NavItem {
//   final IconData icon, activeIcon;
//   final String label;
//   const _NavItem(this.icon, this.activeIcon, this.label);
// }
