import 'package:autohub_app/components/text_field_style.dart';
import 'package:autohub_app/styles/app_colors.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeigth = MediaQuery.of(context).size.height;
    double dynamicWidth = screenWidth * 0.9;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColor,
      body: SizedBox(
        height: screenHeigth,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/full_background_doodle.png",
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  children: [
                    // SizedBox(
                    //   height: 60,
                    // ),
                    Spacer(),
                    Image.asset(
                      "assets/icons/autohub_logo.png",
                      width: 140,
                      height: 140,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    // Spacer(),
                    Text(
                      "Login to your Account",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Enter your email and password to login",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // Spacer(),
                    Container(
                      width: dynamicWidth,
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: "Email Id",
                          border: TextFieldStyle.loginfield,
                          focusedBorder: TextFieldStyle.focussedLoginField,
                          filled: true,
                          fillColor: AppColors.backgroundColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // Spacer(),
                    Container(
                      width: dynamicWidth,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Password",
                          border: TextFieldStyle.loginfield,
                          focusedBorder: TextFieldStyle.focussedLoginField,
                          filled: true,
                          fillColor: AppColors.backgroundColor,
                        ),
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?"),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed("/signin");
                              },
                              child: Text(
                                "Click Here",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    Spacer(),
                    Container(
                      width: dynamicWidth,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed("/homepage");
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: AppColors.primaryColor,
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.backgroundColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                        // height: 40,
                        ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
