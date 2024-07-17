import 'dart:async';
import 'package:autohub_app/components/const.dart';
import 'package:autohub_app/components/text_field_style.dart';
import 'package:autohub_app/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isPremiumSelected = true;

  // Static constant data
  static LatLng _pSource = LatLng(12.9692, 79.1559);
  static LatLng _pDestination = LatLng(12.9244, 79.1353);

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  LatLng? _pCurrentLocation = null;

  late GoogleMapController mapController;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylinesCoordinates = [];
  Location _locationController = Location();

  void initState() {
    super.initState();
    getLocationupdates();
    // getLocationupdates().then((_) => {
    //       getPolylinePoints().then((coordinates) => {
    //             // print(coordinates),
    //             generatePolylinesFromPoints(coordinates),
    //           }),
    //     });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          _pCurrentLocation == null
              ? const Center(
                  child: Text(
                    "Loading...",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 20,
                    ),
                  ),
                )
              : GoogleMap(
                  onMapCreated: ((GoogleMapController controller) =>
                      _mapController.complete(controller)),
                  mapType: MapType.normal,
                  initialCameraPosition:
                      CameraPosition(target: _pCurrentLocation!, zoom: 13),
                  markers: {
                    Marker(
                        markerId: MarkerId("_currentLocation"),
                        icon: BitmapDescriptor.defaultMarkerWithHue(90),
                        position: _pCurrentLocation!),
                    // Marker(
                    //     markerId: MarkerId("_sourceLocation"),
                    //     icon: BitmapDescriptor.defaultMarker,
                    //     position: _pSource),
                    // Marker(
                    //     markerId: MarkerId("_destionationLocation"),
                    //     icon: BitmapDescriptor.defaultMarker,
                    //     position: _pDestination),
                  },
                  // polylines: Set<Polyline>.of(polylines.values),
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
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: 10),
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
                        Navigator.pushNamed(context, '/ride');
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        backgroundColor: AppColors.primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          "Book this auto",
                          style: TextStyle(
                            color: AppColors.backgroundColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 18);
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  Future<void> getLocationupdates() async {
    bool _serviceEnabled;
    PermissionStatus _locationPermissionGranted;

    // If Location is disabled send a prompt saying to turn on the location.
    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
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
          _cameraToPosition(_pCurrentLocation!);
          print("Current Position: $currentLocation");
        });
      }
    });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: GoogleApiKey,
        request: PolylineRequest(
            origin: PointLatLng(_pSource.latitude, _pSource.longitude),
            destination:
                PointLatLng(_pDestination.latitude, _pDestination.longitude),
            mode: TravelMode.driving));
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolylinesFromPoints(List<LatLng> polylinesCoordinates) async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.green,
        points: polylinesCoordinates,
        width: 5);
    setState(() {
      polylines[id] = polyline;
    });
  }
}
