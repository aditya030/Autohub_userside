import 'dart:async';
import 'dart:convert';
import 'package:autohub_app/components/const.dart';
import 'package:flutter/material.dart';
import 'package:autohub_app/styles/app_colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
class MapRidePricePage extends StatefulWidget {
  LatLng? _pSourceLocation;
  LatLng? _pDestinationLocation;
  String distance;
  MapRidePricePage(this._pSourceLocation, this._pDestinationLocation, this.distance);

  @override
  State<MapRidePricePage> createState() => _MapRidePricePageState();
}

class _MapRidePricePageState extends State<MapRidePricePage> {
  bool isPremiumSelected = true;
  final Completer<GoogleMapController> _mapController =
  Completer<GoogleMapController>();
  LatLng? _pCurrentLocation;
  LatLng? _pDestinationLocation;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylinesCoordinates = [];
  late GoogleMapController mapController;
  Location _locationController = Location();
  late double distanceInKm;
  double autoPrice = 0.0;
  double premiumPrice = 0.0;

  @override
  void initState() {
    super.initState();
    distanceInKm = double.tryParse(widget.distance.split(' ')[0]) ?? 0.0;
    calculatePrices();
  }

  void calculatePrices() {
    setState(() {
      autoPrice = distanceInKm * 10; // Rate for Auto
      premiumPrice = (distanceInKm * 12); // Rate for Premium Auto
      int _premiumPrice = premiumPrice.ceil();
      int _autoPrice = autoPrice.ceil();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          (widget._pSourceLocation == null && widget._pDestinationLocation == null)
              ? Center(
            child: Image.asset(
              'assets/icons/loading_animation.gif',
              width: screenHeight * 0.3,
            ),
          )
              : GoogleMap(
            onMapCreated: ((GoogleMapController controller) {
              _mapController.complete(controller);
              mapController = controller;
            }),
            mapType: MapType.normal,
            initialCameraPosition:
            CameraPosition(target: widget._pSourceLocation!, zoom: 13),
            markers: {
              if (widget._pSourceLocation != null)
                Marker(
                  markerId: MarkerId("_sourceLocation"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(90),
                  position: widget._pSourceLocation!,
                ),
              if (_pDestinationLocation != null)
                Marker(
                  markerId: MarkerId("_destinationLocation"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(90),
                  position: _pDestinationLocation!,
                ),
            },
            polylines: Set<Polyline>.of(polylines.values),
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
                      hintText: "CMC Ranipet Campus",
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
                        backgroundColor: !isPremiumSelected
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
                            "₹ ${autoPrice.toStringAsFixed(2)}",
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
                            "₹ ${premiumPrice.toStringAsFixed(2)}",
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
                        Navigator.pushNamed(
                          context,
                          '/userbidpage',
                          arguments: {
                            'price': isPremiumSelected ? premiumPrice : autoPrice,
                            'type': isPremiumSelected ? 'Premium Auto' : 'Auto',
                          },
                        );

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
                            "₹ ${isPremiumSelected ? premiumPrice : autoPrice.toStringAsFixed(2)}",
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
  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _locationPermissionGranted;

    // If Location is disabled send a prompt saying to turn on the location.
    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _locationPermissionGranted = await _locationController.hasPermission();
    if (_locationPermissionGranted == PermissionStatus.denied) {
      _locationPermissionGranted =
      await _locationController.requestPermission();
      if (_locationPermissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _pCurrentLocation =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          print("Current Position: $currentLocation");
        });
      }
    });
  }

  Future<List<LatLng>> getPolylinePoints_Search() async {
    List<LatLng> polylineCoordinates = [];
    if (widget._pSourceLocation != null && _pDestinationLocation != null) {
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          googleApiKey: GoogleApiKey,
          request: PolylineRequest(
              origin: PointLatLng(widget._pSourceLocation!.latitude,
                  widget._pSourceLocation!.longitude),
              destination: PointLatLng(_pDestinationLocation!.latitude,
                  _pDestinationLocation!.longitude),
              mode: TravelMode.driving));
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      } else {
        print(result.errorMessage);
      }
    }
    return polylineCoordinates;
  }

  generatePolylinesFromPoints(List<LatLng> coordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.green, points: coordinates, width: 5);
    setState(() {
      polylines[id] = polyline;
    });
  }
  LatLngBounds _getLatLngBounds(List<LatLng> coordinates) {
    LatLng southwest = coordinates.reduce((value, element) => LatLng(
        value.latitude < element.latitude ? value.latitude : element.latitude,
        value.longitude < element.longitude
            ? value.longitude
            : element.longitude));
    LatLng northeast = coordinates.reduce((value, element) => LatLng(
        value.latitude > element.latitude ? value.latitude : element.latitude,
        value.longitude > element.longitude
            ? value.longitude
            : element.longitude));
    return LatLngBounds(southwest: southwest, northeast: northeast);
  }

  Future<void> updatePolylines() async {
    List<LatLng> coordinates = await getPolylinePoints_Search();
    generatePolylinesFromPoints(coordinates);

    if (coordinates.isNotEmpty) {
      LatLngBounds bounds = _getLatLngBounds(coordinates);
      mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));

      // Fetch and display the distance and duration
      // if (widget._pSourceLocation != null && _pDestinationLocation != null) {
      //   final result = await getDistanceAndDuration(
      //       widget._pSourceLocation!, _pDestinationLocation!);
      //   setState(() {
      //     distance = result['distance'];
      //     duration = result['duration'];
      //   });
      // }
    }
  }

}