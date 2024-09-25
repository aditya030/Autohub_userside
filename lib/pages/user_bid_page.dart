import 'package:flutter/material.dart';
import 'package:autohub_app/styles/app_colors.dart';

class UserBidPage extends StatefulWidget {
  const UserBidPage({super.key});

  @override
  State<UserBidPage> createState() => _UserBidPageState();
}

class _UserBidPageState extends State<UserBidPage> {
  double? minPrice;
  double? maxPrice;
  final TextEditingController _priceController = TextEditingController();
  String? errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    double price = args['price'];
    minPrice = price;
    maxPrice = price! + 100;
  }

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
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: topPadding),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                            ),
                          ),
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
                    SizedBox(height: 10),
                    if (errorMessage != null) ...[
                      Text(
                        errorMessage!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                    SizedBox(
                      width: screenWidth * 0.8,
                      child: TextField(
                        controller: _priceController,
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
                    SizedBox(height: 10),
                    Container(
                      width: screenWidth * 0.8,
                      child: Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.05),
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                "Mini Price: Rs ${minPrice?.toStringAsFixed(2) ?? '0'}",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                "Max Price: Rs ${maxPrice?.toStringAsFixed(2) ?? '0'}",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: screenWidth * 0.8,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          final enteredPrice =
                              double.tryParse(_priceController.text) ?? 0;
                          if (enteredPrice < (minPrice ?? 0)) {
                            setState(() {
                              errorMessage =
                                  'Error: The offer price is below the minimum price.';
                            });
                          } else {
                            setState(() {
                              errorMessage = null;
                            });
                            // Implement booking logic
                            Navigator.of(context)
                                .pushReplacementNamed("/bidding");
                          }
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
