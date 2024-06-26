// import 'package:autohub_app/components/text_field_style.dart';
import 'package:autohub_app/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeigth = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            padding: const EdgeInsets.only(top: 50, left: 15),
            child: Container(
              width: screenWidth * 0.9,
              height: 100,
              decoration: BoxDecoration(
              color: AppColors.backgroundColor.withOpacity(0.9),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: AppColors.primaryColor),
              ),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search Current Location",
                      hintStyle: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: Icon(Icons.circle, color: Colors.green, size: 15,),
                      border: InputBorder.none,
                      // enabledBorder: TextFieldStyle.SearchLocationField,
                    ),
                  ),
                  Divider(height: 0.0, ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search Destination",
                      hintStyle: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: Icon(Icons.search_outlined, color: Colors.grey, size: 20),
                      // enabledBorder: TextFieldStyle.SearchLocationField,
                      border: InputBorder.none,
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
