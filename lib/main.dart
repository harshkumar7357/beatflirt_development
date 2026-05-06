import 'package:beatflirt/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.pink,
          selectionColor: Colors.pink.withValues(alpha: 0.5),
          selectionHandleColor: Colors.pink,
        ),
      ),

      title: "Application",
      // initialRoute: AppPages.INITIAL,
      // getPages: AppPages.routes,
      // home: LoginPage()
      // home: const LoginPage(),
      home: const SplashScreen(),
    );
  }
}
