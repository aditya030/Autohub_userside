<<<<<<< HEAD
import 'package:autohub_app/pages/sample_maps.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
=======
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'package:autohub_app/firebase_options.dart';
import 'package:autohub_app/styles/app_colors.dart';
>>>>>>> 0a8e841 (connected the project to firebase added required files and otp verification dynmaically)
import 'package:autohub_app/pages/account_created_page.dart';
import 'package:autohub_app/pages/auto_details_page.dart';
import 'package:autohub_app/pages/bidding_page.dart';
import 'package:autohub_app/pages/destination_page.dart';
import 'package:autohub_app/pages/driver_info_page.dart';
import 'package:autohub_app/pages/home_intro_page.dart';
import 'package:autohub_app/pages/home_page.dart';
import 'package:autohub_app/pages/login_page.dart';
import 'package:autohub_app/pages/otp_page.dart';
import 'package:autohub_app/pages/map_ride_price_page.dart';
import 'package:autohub_app/pages/profile_completion_page.dart';
import 'package:autohub_app/pages/ride_completion.dart';
import 'package:autohub_app/pages/ride_confirmation_page.dart';
import 'package:autohub_app/pages/search_page.dart';
import 'package:autohub_app/pages/sign_in_page.dart';
import 'package:autohub_app/pages/sign_up_page.dart';
import 'package:autohub_app/pages/user_bid_page.dart';
import 'package:autohub_app/pages/user_details_page.dart';
<<<<<<< HEAD
import 'package:autohub_app/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
=======
>>>>>>> 0a8e841 (connected the project to firebase added required files and otp verification dynmaically)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/ride': (context) => MapRidePricePage(),
        '/homepage': (context) => HomePage(),
        '/searchpage': (context) => SearchPage(),
        '/ridecompletion': (context) => RideCompletion(),
        '/Auto_details': (context) => BookingPage(),
        '/userdetails': (context) => UserDetailsPage(),
        '/driverinfo': (context) => DriverDetailsPage(),
        '/homeintro': (context) => SplashScreen(),
        '/signin': (context) => SigninPage(),
        '/otp': (context) => OTPPage(),
        '/signup': (context) => SignupPage(),
        '/bidding': (context) => DriverListPage(),
        '/profilecompletion': (context) => ProfilePage(),
        '/accountcreation': (context) => AccountCreatedPage(),
        '/destination': (context) => DestinationPage(),
        '/rideconfirmation': (context) => RideConfirmationPage(),
        '/userbidpage': (context) => UserBidPage(),
        '/samplemap': (context) => SampleMaps(),
      },
    );
  }
}
