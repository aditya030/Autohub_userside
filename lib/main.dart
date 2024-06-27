import 'package:autohub_app/pages/auto_details_page.dart';
import 'package:autohub_app/pages/driver_info_page.dart';
import 'package:autohub_app/pages/home_intro_page.dart';
import 'package:autohub_app/pages/home_page.dart';
import 'package:autohub_app/pages/login_page.dart';
import 'package:autohub_app/pages/ride_completion_page.dart';
import 'package:autohub_app/pages/map_ride_price_page.dart';
import 'package:autohub_app/pages/ride_completion.dart';
import 'package:autohub_app/pages/search_page.dart';
import 'package:autohub_app/pages/user_details_page.dart';
import 'package:autohub_app/styles/app_colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Lexend",
        scaffoldBackgroundColor: AppColors.backgroundColor,
      ),
      initialRoute: '/homeintro',
      routes: {
        '/': (context) => LoginPage(),
        '/ride': (context) => MapRidePricePage(),
        '/feedback': (context) => FeedbackScreen(),
        '/homepage': (context) => HomePage(),
        '/searchpage': (context) => SearchPage(),
        '/ridecompletion': (context) => RideCompletion(),
        '/Auto_details': (context) => BookingPage(),
        '/userdetails': (context) => UserDetailsPage(),
         '/driverinfo': (context) => DriverDetailsPage(),
        '/homeintro': (context) => SplashScreen(),

      },
    );
  }
}
