// import 'package:beatflirt/screens/login_page.dart';
import 'package:beatflirt/screens/splash_screen.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
// import 'package:beatflirt/beatflirt_landing_page.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
  behavior: HitTestBehavior.opaque,
  onTap: () {
    FocusManager.instance.primaryFocus!.unfocus();
  },
  child: GetMaterialApp(
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
      // home: const BeatFlirtLandingPage(),
      home: const SplashScreen(),
  )
  );
  }
}
