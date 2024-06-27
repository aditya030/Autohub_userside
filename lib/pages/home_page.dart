import 'package:autohub_app/components/text_field_style.dart';
import 'package:autohub_app/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeigth = MediaQuery.of(context).size.height;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(
                12.9692,
                79.1559,
              ),
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'dev.vit.vellore',
              ),

              // Dynamically fetch the users current location
              // According the latitude and the longitude will be set.
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(
                      12.9692,
                      79.1559,
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 10),
            child: Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.8,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to search page
                      Navigator.pushNamed(context, '/searchpage');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Adjust border radius
                        side: BorderSide(
                          color: AppColors
                              .primaryColor, // Same color as TextField border
                        ),
                      ),
                      elevation: 0, // Remove elevation to match TextField
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(
                            width: 10), // Adjust spacing between icon and text
                        Text(
                          "Search Location",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/user2.png",
                      // width: 30,
                      // height: 30,
                      width: screenWidth * 0.12,
                      height: screenWidth * 0.12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeigth * 0.40,
              width: screenWidth,
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 29),
                    child: SizedBox(
                      height: screenHeigth * 0.055,
                      width: screenWidth,
                      child: Text(
                        "Choose your ride",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 0,
                  ),
                  SizedBox(
                    height: screenHeigth * 0.1,
                    width: screenWidth,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        backgroundColor: AppColors.offwhite,
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: screenHeigth * 0.025,
                                ),
                                Text(
                                  "Auto",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryColor),
                                ),
                                Text(
                                  "2-3 Persons",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.primaryColor),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.425,
                          ),
                          Text(
                            "Rs --",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeigth * 0.1,
                    width: screenWidth,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        backgroundColor: Color(0xff70D94C),
                      ),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: screenHeigth * 0.025,
                              ),
                              Text(
                                "Premium Auto",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryColor),
                              ),
                              Text(
                                "4-5 Persons",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.primaryColor),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: screenWidth * 0.34,
                          ),
                          Text(
                            "Rs --",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeigth * 0.02,
                  ),
                  SizedBox(
                    width: screenWidth * 0.9,
                    height: screenHeigth * 0.08,
                    child: ElevatedButton(
                        onPressed: () {
                          print("Button Clicked");
                          Navigator.pushNamed(context, '/ridecompletion');
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            backgroundColor: AppColors.primaryColor),
                        child: Row(
                          children: [
                            Text(
                              "  Choose Destination",
                              style: TextStyle(
                                color: AppColors.backgroundColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.1,
                            ),
                            CircleAvatar(
                              radius: screenWidth * 0.05,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.navigate_next_sharp,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
