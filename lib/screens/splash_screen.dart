import 'package:beatflirt/main.dart';
import 'package:beatflirt/screens/login_page.dart';
import 'package:flutter/material.dart';
// import '../core/services/auth_service.dart';
import '../core/services/auth_services.dart';
import 'home_screen.dart';
// import 'login_screen.dart';
// import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  void _checkLogin() async {
    bool loggedIn = await AuthService.isLoggedIn();

    await Future.delayed(const Duration(seconds: 2));

    if (loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) =>  const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}