import 'package:beatflirt/screens/home_screen.dart';
import 'package:beatflirt/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:beatflirt/screens/login_page.dart';
import 'content/app_drawer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
        theme: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.pink,        // cursor line
              selectionColor: Colors.pink.withOpacity(0.5), // selected text bg
              selectionHandleColor: Colors.pink, // 👈 THIS changes that drop handle
            ),
        ),

      title: "Application",
      // initialRoute: AppPages.INITIAL,
      // getPages: AppPages.routes,
      // home: LoginPage()
      // home: const LoginPage(),
      home: HomePage()
    );
  }
}
