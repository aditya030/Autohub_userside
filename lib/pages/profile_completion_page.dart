import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AUTOHUB Title
            Center(
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lexend',
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'AUTO',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'HUB',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: screenWidth * 0.14, // Adjusted based on screen width
                      backgroundImage: const AssetImage('assets/images/user2.png'),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                      },
                      child: CircleAvatar(
                        radius: screenWidth * 0.05,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.edit,
                          color: Colors.black38,
                          size: screenWidth * 0.05,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            // First Name Label
            Text(
              'First Name',
              style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold), // Adjusted based on screen width
            ),
            // First Name Text Field
            const TextField(
              decoration: InputDecoration(
                hintText: 'John',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            // Last Name Label
            Text(
              'Last Name',
              style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold), // Adjusted based on screen width
            ),
            // Last Name Text Field
            const TextField(
              decoration: InputDecoration(
                hintText: 'Doe',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            // Residence Label
            Text(
              'Residence',
              style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold), // Adjusted based on screen width
            ),
            // Residence Text Field
            const TextField(
              decoration: InputDecoration(
                hintText: 'Your Current Hostel',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            // Emergency Contact Label
            Text(
              'Emergency Contact',
              style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold), // Adjusted based on screen width
            ),
            // Emergency Contact Text Field
            const TextField(
              decoration: InputDecoration(
                hintText: '+91-XXX-XXXX-XX',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            // Complete Profile Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle button press
                   Navigator.of(context).pushReplacementNamed("/accountcreation");
                  
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.25, vertical: screenHeight * 0.03), // Adjusted based on screen size
                  textStyle: TextStyle(fontSize: screenWidth * 0.04),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Complete your profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}