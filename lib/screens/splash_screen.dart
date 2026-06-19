import 'package:beatflirt/beatflirt_landing_page.dart';
import 'package:beatflirt/screens/login_page.dart';
// import 'package:beatflirt/screens/main_navigation/navigation_bar2.dart';
// import 'package:beatflirt/screens/main_navigation/navigation_bar3.dart';
// import 'package:beatflirt/screens/main_navigation/navigations_bar.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import '../core/services/auth_services.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _pulseController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<Offset> _titleOffset;
  late final Animation<double> _taglineOpacity;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.68, end: 1).animate(
      CurvedAnimation(parent: _introController, curve: Curves.easeOutBack),
    );
    _logoOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _introController, curve: Curves.easeIn));
    _titleOffset = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _introController, curve: Curves.easeOutCubic),
        );
    _taglineOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.45, 1, curve: Curves.easeIn),
      ),
    );

    _introController.forward();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    try {
      print("STEP 1: Starting auth check");

      await AuthService.probeAuth(); // Trigger the auth probe
      print("STEP 2: probeAuth completed");
      final results = await Future.wait<dynamic>([
        AuthService.isLoggedIn(),
        Future<void>.delayed(const Duration(milliseconds: 2600)),
      ]);
      print("STEP 3: isLoggedIn and delay completed");
      if (!mounted) return;
      print("STEP 4: Navigator called (loggedIn: ${results.first})");
      final bool loggedIn = results.first as bool;

      // final Widget nextPage = loggedIn ? const HomePage() : const LoginPage();
      final Widget nextPage = loggedIn ? const HomePage() : const BeatFlirtLandingPage();

      // final Widget nextPage = loggedIn ? const MainNavigationPage() : const LoginPage();
      // final Widget nextPage = loggedIn ? const MainShell() : const LoginPage();
      // final Widget nextPage = loggedIn ? const HomePage1() : const LoginPage();

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => nextPage));
    } catch (_) {
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
    }
  }

  @override
  void dispose() {
    _introController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.pink.withValues(alpha: 0.92),
              Colors.pink.withValues(alpha: 0.65),
              Colors.white,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -50,
              child: _GlowOrb(
                size: 220,
                color: Colors.white.withValues(alpha: 0.26),
              ),
            ),
            Positioned(
              bottom: -70,
              left: -30,
              child: _GlowOrb(
                size: 180,
                color: Colors.pink.withValues(alpha: 0.25),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _introController,
                    _pulseController,
                  ]),
                  builder: (context, _) {
                    final glow = 0.15 + (_pulseController.value * 0.35);
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Opacity(
                          opacity: _logoOpacity.value,
                          child: Transform.scale(
                            scale: _logoScale.value,
                            child: Container(
                              width: 122,
                              height: 122,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.pink.withValues(alpha: glow),
                                    blurRadius: 42,
                                    spreadRadius: 8,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  "assets/logo/logo.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        SlideTransition(
                          position: _titleOffset,
                          child: FadeTransition(
                            opacity: _logoOpacity,
                            child: const Text(
                              'Beat Flirt',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.4,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FadeTransition(
                          opacity: _taglineOpacity,
                          child: Text(
                            // 'Connect. Vibe. Celebrate.',
                            'Flirt. Connect. Celebrate.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.95),
                              fontSize: 15,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 34),
                        FadeTransition(
                          opacity: _taglineOpacity,
                          child: SizedBox(
                            width: 170,
                            child: LinearProgressIndicator(
                              minHeight: 5,
                              borderRadius: BorderRadius.circular(999),
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.35,
                              ),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }
}
