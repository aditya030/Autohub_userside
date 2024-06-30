import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:autohub_app/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RideCompletion extends StatefulWidget {
  const RideCompletion({super.key});

  @override
  State<RideCompletion> createState() => _RideCompletionState();
}

class _RideCompletionState extends State<RideCompletion> {
  var _razorpay = Razorpay();
  @override
  Widget build(BuildContext context) {
    double screenHeigth = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 22, right: 30,bottom: 6),
            child: Align(
              alignment: Alignment.topLeft,
              child: RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "AUTO",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryColor,
                        fontStyle: FontStyle.italic,
                      )),
                  TextSpan(
                    text: "HUB",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w200,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ]),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.only(left: 22, right: 30),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/user2.png",
                  width: 50,
                  height: 50,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "G Murugan",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Spacer(),
                Icon(
                  Icons.star_rounded,
                  color: Color(0xffFFCC00),
                  size: 35,
                ),
                Text(
                  "4.5",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    // fontStyle: FontStyle.italic
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "How was your trip?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          RatingBar.builder(
            initialRating: 5,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star_rounded,
              color: Color(0xffFFCC00),
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
          SizedBox(
            height: 25,
          ),
          SizedBox(
            width: screenWidth * 0.7, // Set the desired width
            height: 90, // Set the desired height
            child: TextField(
              decoration: InputDecoration(
                hintText: "Write the feedback",
                filled: true,
                fillColor: Color(0xffFAFAFA),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffEDEDED))),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 130, 127, 127))),
              ),
            ),
          ),
          // Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 22, right: 30),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Trip Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 7,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: screenWidth,
              decoration: BoxDecoration(
                  color: Color(0xffFAFAFA),
                  border: Border.all(
                    color: Color(0xffEDEDED),
                  )),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 22, top: 8, bottom: 8),
                        // padding: const EdgeInsets.all(8.0)
                        child: Icon(
                          Icons.person_pin_circle_rounded,
                          color: Colors.green,
                          size: 35,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Christ Medical College (CMC)",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 0, color: Color(0xffEDEDED)),
                  Row(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 22, top: 8, bottom: 8),
                        child: Icon(
                          Icons.flag_circle_rounded,
                          color: Colors.red,
                          size: 35,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "VIT",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 22),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Payment Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Trip Expense",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: 150,
                    ),
                    Text(
                      "150",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Student Discount",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: 113,
                    ),
                    Text(
                      "- 15",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: 215,
                    ),
                    Text(
                      "135",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 16,),
          Spacer(),
          Container(
            width: screenWidth * 0.85,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Navigator.of(context).pushReplacementNamed("/homepage");
                var options = {
                  'key': 'rzp_test_4ZtM3uCcmSeeED',
                  'amount': 135*100, //in the smallest currency sub-unit.
                  'name': 'Autohub',
                  // 'order_id': 'order_EMBFqjDHEEn80l', // Generate order_id using Orders API
                  'description': 'This is your total amount for the ride.',
                  'timeout': 300, // in seconds
                  'prefill': {
                    'contact': '7524011662',
                    'email': 'samarthverma1813@gmail.com'
                  }
                };
                  _razorpay.open(options);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                backgroundColor: AppColors.primaryColor,
              ),
              child: Text(
                "Payment",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.backgroundColor,
                ),
              ),
            ),
          ),
          SizedBox(height: 23),
        ],
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement dispose      
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

}
