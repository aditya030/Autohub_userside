import 'package:autohub_app/pages/home_page.dart';
import 'package:autohub_app/pages/login_page.dart';
import 'package:autohub_app/pages/ride_completion.dart';
import 'package:autohub_app/pages/search_page.dart';
import 'package:autohub_app/styles/app_colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Lexend",
        scaffoldBackgroundColor: AppColors.backgroundColor,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/homepage': (content) => HomePage(),
        '/searchpage': (context) => SearchPage(),
        '/ridecompletion' : (context) => RideCompletion(),
      },
    );
  }
}
