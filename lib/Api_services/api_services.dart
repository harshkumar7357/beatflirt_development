// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
//
// class ApiServices {
//   Future<void> loginUser() async {
//     try {
//       final response = await http.post(
//           Uri.parse('https://api.example.com/login'),
//   headers: <String, String>{
//     'Content-Type': 'application/json; charset=UTF-8',
//   },
//   body: jsonEncode(<String, String>{
//     'email': _emailController.toString().trim(),
//     'password': _passwordController.toString().trim(),
//   })
//       );
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print(data);
//         print(response.statusCode);
//
//         print(response.body);
//
//       }
//   }catch(err) {
//       GetSnackBar(
//         title: "Error",
//         message: "Login Failed",
//         animationDuration: Duration(seconds: 2),
//         forwardAnimationCurve: Curves.easeIn,
//         reverseAnimationCurve: Curves.easeOut,
//         backgroundColor: Colors.red,
//       );
//     }
// }
// }


