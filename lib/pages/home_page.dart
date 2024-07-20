import 'dart:async';
import 'package:autohub_app/components/const.dart';
import 'package:autohub_app/components/text_field_style.dart';
import 'package:autohub_app/pages/user_details_page.dart';
import 'package:autohub_app/pages/search_page.dart'; // Import the search page
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

  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();

  LatLng? _pCurrentLocation;

  late GoogleMapController mapController;
  Map<PolylineId, Polyline> polylines = {};
  Location _locationController = Location();

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
                    _setMapStyle();
                  },
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(target: _pCurrentLocation!, zoom: 13),
                  markers: {
                    Marker(
                      markerId: MarkerId("_currentLocation"),
                      icon: BitmapDescriptor.defaultMarkerWithHue(90),
                      position: _pCurrentLocation!,
                    ),
                    Marker(
                      markerId: MarkerId("_sourceLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _pSource,
                    ),
                    Marker(
                      markerId: MarkerId("_destinationLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _pDestination,
                    ),
                  },
                  polylines: Set<Polyline>.of(polylines.values),
                ),
          Positioned(
            top: 50,
            left: 10,
            right: 10,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                      onChanged: (value) {
                        // Handle text change
                      },
                      onTap: () {
                        // Navigate to search page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchPage(), // Ensure SearchPage is implemented
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    // Navigate to UserDetailsPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailsPage(),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/user2.png'),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: screenWidth,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Choose your ride',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildButton('Auto', !isPremiumSelected, () {
                        setState(() {
                          isPremiumSelected = false;
                        });
                      }),
                      _buildButton('Premium Auto', isPremiumSelected, () {
                        setState(() {
                          isPremiumSelected = true;
                        });
                      }),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                        value: 'Cash',
                        items: <String>['Cash', 'Credit', 'Debit'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('Promo code'),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Handle Choose Destination
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Choose Destination',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
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

  Widget _buildButton(String text, bool isSelected, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.green : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.symmetric(vertical: 15),
        ),
        child: Column(
          children: [
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            Text(
              text == 'Auto' ? '2-3 person' : '4-5 person',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 12,
              ),
            ),
            Text(
              '₹ --',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _locationPermissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) return;
    }

    _locationPermissionGranted = await _locationController.hasPermission();
    if (_locationPermissionGranted == PermissionStatus.denied) {
      _locationPermissionGranted = await _locationController.requestPermission();
      if (_locationPermissionGranted != PermissionStatus.granted) return;
    }

    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          _pCurrentLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _updateMapLocation();
        });
      }
    });

    // Fetch polyline points after location updates
    getPolylinePoints().then((coordinates) {
      generatePolylinesFromPoints(coordinates);
    });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    // Example: Fetching a route between two locations
    List<LatLng> polylineCoordinates = [
      _pSource,
      _pDestination,
    ];

    // Fetch and parse polyline data if needed
    return polylineCoordinates;
  }

  void generatePolylinesFromPoints(List<LatLng> coordinates) {
    setState(() {
      PolylineId id = PolylineId('poly');
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blue,
        points: coordinates,
        width: 4,
      );
      polylines[id] = polyline;
    });
  }

  void _updateMapLocation() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newLatLng(_pCurrentLocation!));
  }

  void _setMapStyle() async {
    final GoogleMapController controller = await _mapController.future;
    String mapStyle = await DefaultAssetBundle.of(context).loadString('assets/map_style.txt');
    controller.setMapStyle(mapStyle);
  }
}
