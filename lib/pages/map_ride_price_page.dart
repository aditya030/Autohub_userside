import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:autohub_app/styles/app_colors.dart';

class MapRidePricePage extends StatefulWidget {
  const MapRidePricePage({Key? key}) : super(key: key);

  @override
  State<MapRidePricePage> createState() => _MapRidePricePageState();
}

class _MapRidePricePageState extends State<MapRidePricePage> {
  bool isPremiumSelected = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(12.9692, 79.1559),
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'dev.vit.vellore',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(12.9692, 79.1559),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 50.0,
            left: 15.0,
            child: Container(
              width: screenWidth * 0.9,
              height: 100.0,
              decoration: BoxDecoration(
                color: AppColors.backgroundColor.withOpacity(0.9),
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: AppColors.primaryColor),
              ),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Vit Main Gate",
                      hintStyle: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: Icon(
                        Icons.circle,
                        color: Colors.green,
                        size: 15,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                  Divider(height: 0.0, color: Colors.black),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Katpadi railway station",
                      hintStyle: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: Icon(
                        Icons.search_outlined,
                        color: Colors.grey,
                        size: 20,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.40,
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
                      height: screenHeight * 0.055,
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
                  Divider(height: 0),
                  SizedBox(
                    height: screenHeight * 0.1,
                    width: screenWidth,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isPremiumSelected = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        backgroundColor: isPremiumSelected
                            ? AppColors.offwhite
                            : Color(0xff70D94C),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: screenHeight * 0.025),
                                Text(
                                  "Auto",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                Text(
                                  "2-3 Persons",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Text(
                            "₹ 120",
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
                    height: screenHeight * 0.1,
                    width: screenWidth,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isPremiumSelected = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        backgroundColor: isPremiumSelected
                            ? Color(0xff70D94C)
                            : AppColors.offwhite,
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: screenHeight * 0.025),
                                Text(
                                  "Premium Auto",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                Text(
                                  "4-5 Persons",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Text(
                            "₹ 150",
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
                  SizedBox(height: screenHeight * 0.02),
                  SizedBox(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.08,
                    child: ElevatedButton(
                      onPressed: () {
                        print("Button Clicked");
                        Navigator.pushNamed(context, '/userbidpage');
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        backgroundColor: AppColors.primaryColor,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Place your offer of",
                            style: TextStyle(
                              color: AppColors.backgroundColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          Text(
                            isPremiumSelected ? "₹ 150" : "₹ 120",
                            style: TextStyle(
                              color: AppColors.backgroundColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 10),
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
                      ),
                    ),
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
