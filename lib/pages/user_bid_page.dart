import 'package:autohub_app/styles/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserBidPage extends StatefulWidget {
  const UserBidPage({super.key});

  @override
  State<UserBidPage> createState() => _UserBidPageState();
}

class _UserBidPageState extends State<UserBidPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double topPadding = screenHeight * 0.35;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/full_background_doodle.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: "AUTO",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryColor,
                                fontStyle: FontStyle.italic,
                              )),
                          TextSpan(
                            text: "HUB",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w200,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: screenWidth * 0.8,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter your offer price.",
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: screenWidth * 0.8,
                      child: Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.05),
                        child: Row(
                          children: [
                            Text("Mini Price: Rs 100\t\t\t"),
                            Text("Max Price: Rs 300")
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: screenWidth * 0.8,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed("/bidding");
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: AppColors.primaryColor,
                        ),
                        child: Text(
                          "Book this ride",
                          style: TextStyle(
                            color: AppColors.backgroundColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
