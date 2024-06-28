import 'package:flutter/material.dart';
import 'package:autohub_app/styles/app_colors.dart';

class AccountCreatedPage extends StatelessWidget {
  const AccountCreatedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 100),
            Text(
              'Account created!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Welcome to AUTOHUB',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 40),
            Image.asset(
              'assets/images/women.png',
              height: 300,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  // Handle button press here
                   Navigator.of(context).pushReplacementNamed("/homepage");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ).copyWith(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Button text color
                ),
                child: Text('Continue'),
              ),
            ),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/lower_background_doodle.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.32),
                    BlendMode.dstATop,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}