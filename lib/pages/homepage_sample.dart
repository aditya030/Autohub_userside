import 'dart:async';
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:autohub_app/components/const.dart';
import 'package:autohub_app/components/location_list_tile.dart';
import 'package:autohub_app/components/network_utility.dart';
import 'package:autohub_app/models/autocomplete_prediction.dart';
import 'package:autohub_app/models/place_auto_complete_response.dart';
import 'package:autohub_app/models/place_details_response.dart';
import 'package:autohub_app/pages/destination_page.dart';
import 'package:autohub_app/pages/search_page.dart';
import 'package:autohub_app/pages/user_details_page.dart';
import 'package:autohub_app/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomepageSample extends StatefulWidget {
  const HomepageSample({super.key});

  @override
  State<HomepageSample> createState() => _HomepageSampleState();
}

class _HomepageSampleState extends State<HomepageSample> {
  // All the data variables and controllers
  List<AutocompletePrediction> sourcePlacePredictions = [];
  List<AutocompletePrediction> destinationPlacePredictions = [];
  TextEditingController searchPlaceController = TextEditingController();
  TextEditingController destinationPlaceController = TextEditingController();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  Location _locationController = Location();
  late GoogleMapController mapController;
  Map<PolylineId, Polyline> polylines = {};
  LatLng? _pCurrentLocation;
  bool isPremiumSelected = true;
  String distance = '';
  String duration = '';
  LatLng? _pSourceLocation;
  LatLng? _pDestinationLocation;

  // static LatLng _pSource = LatLng(12.9692, 79.1559);
  // static LatLng _pDestination = LatLng(12.9244, 79.1353);

  // Autocomplete recommendations for Search bar
  Future<void> placeAutocomplete(String query, bool isSource) async {
    Uri uri =
        Uri.https("maps.googleapis.com", "maps/api/place/autocomplete/json", {
      "input": query,
      "key": GoogleApiKey,
    });
    String? response = await NetworkUtility.fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          if (isSource) {
            sourcePlacePredictions = result.predictions!;
          } else {
            destinationPlacePredictions = result.predictions!;
          }
        });
      }
    }
  }

  // To get the place details i.e., Latitude and Longitude details.
  Future<LatLng?> getPlaceDetails(String placeId) async {
    Uri uri = Uri.https("maps.googleapis.com", "maps/api/place/details/json", {
      "place_id": placeId,
      "key": GoogleApiKey,
    });
    String? response = await NetworkUtility.fetchUrl(uri);
    if (response != null) {
      PlaceDetailsResponse result =
          PlaceDetailsResponse.parsePlaceDetailsResult(response);
      if (result.result != null) {
        final location = result.result!.geometry!.location;
        return LatLng(location!.lat, location.lng);
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
    // getLocationUpdates().then((_) => {
    //       getPolylinePoints().then((coordinates) => {
    //             // print(coordinates),
    //             generatePolylinesFromPoints(coordinates),
    //           }),
    //     });
  }

  @override
  Widget build(BuildContext context) {
    // Screen Dimensions - MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          // If LOCATION is ON and the app has the permission then Map will be displayed otherwise Animation will be played.
          _pCurrentLocation == null
              ? Center(
                  child: Image.asset(
                    'assets/icons/loading_animation.gif',
                    width: screenHeight * 0.3,
                  ),
                )
              : GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
                    // _setMapStyle();
                  },
                  mapType: MapType.normal,
                  initialCameraPosition:
                      CameraPosition(target: _pCurrentLocation!, zoom: 13),
                  markers: {
                    // Marker will show the current location
                    // if(_pSourceLocation == null)
                    // Marker(
                    //     markerId: MarkerId("_currentLocation"),
                    //     icon: BitmapDescriptor.defaultMarkerWithHue(90),
                    //     position: _pCurrentLocation!),
                    if (_pSourceLocation != null)
                      Marker(
                        markerId: MarkerId("_sourceLocation"),
                        icon: BitmapDescriptor.defaultMarkerWithHue(90),
                        position: _pSourceLocation!,
                      ),
                    // Marker(
                    //     markerId: MarkerId("_destionationLocation"),
                    //     icon: BitmapDescriptor.defaultMarker,
                    //     position: _pDestination),
                  },
                  polylines: Set<Polyline>.of(polylines.values),
                ),
          Positioned(
            top: 50,
            left: 15,
            right: 15,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(30),
                          // border: Border.all(
                          //   // color: Colors.black,
                          // ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: searchPlaceController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search Location',
                            hintStyle: TextStyle(
                                color: AppColors.primaryColor, fontSize: 18),
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppColors.primaryColor,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                          ),
                          onChanged: (value) {
                            // Handle text change
                            placeAutocomplete(value, true);
                          },
                          onTap: () {
                            // Navigate to search page
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         SearchPage(), // Ensure SearchPage is implemented
                            //   ),
                            // );
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
                        radius: 23,
                        backgroundImage: AssetImage('assets/images/user2.png'),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                if (searchPlaceController.text.isEmpty)
                  Container(
                    width: screenWidth * 0.40,
                    height: screenHeight * 0.04,
                    child: ElevatedButton(
                      onPressed: () {
                        placeAutocomplete("Dubai", true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.my_location,
                            color: Colors.green,
                            size: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Current Location",
                            style: TextStyle(
                                color: AppColors.backgroundColor, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (searchPlaceController.text.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.1),
              child: Expanded(
                child: ListView.builder(
                  itemCount: sourcePlacePredictions.length,
                  itemBuilder: (context, index) => LocationListTile(
                      location: sourcePlacePredictions[index].description!,
                      press: () async {
                        LatLng? selectedLocation = await getPlaceDetails(
                            sourcePlacePredictions[index].placeId!);
                        if (selectedLocation != null) {
                          setState(() {
                            _pSourceLocation = selectedLocation;
                            searchPlaceController.text =
                                sourcePlacePredictions[index].description!;
                            sourcePlacePredictions.clear();
                          });
                          mapController.animateCamera(
                            CameraUpdate.newLatLngZoom(selectedLocation, 15),
                          );
              
                          await updatePolylines();
                        }
                      }),
                ),
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
                      SizedBox(
                        width: 10,
                      ),
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
                        items: <String>['Cash', 'UPI'].map((String value) {
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DestinationPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
          backgroundColor: isSelected ? Colors.green : Colors.blueGrey.shade50,
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

  void _updateMapLocation() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newLatLng(_pCurrentLocation!));
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
    if (_pSourceLocation != null && _pDestinationLocation != null) {
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          googleApiKey: GoogleApiKey,
          request: PolylineRequest(
              origin: PointLatLng(
                  _pSourceLocation!.latitude, _pSourceLocation!.longitude),
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

  Future<void> updatePolylines() async {
    List<LatLng> coordinates = await getPolylinePoints_Search();
    generatePolylinesFromPoints(coordinates);

    if (coordinates.isNotEmpty) {
      LatLngBounds bounds = _getLatLngBounds(coordinates);
      mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));

      // Fetch and display the distance and duration
      if (_pSourceLocation != null && _pDestinationLocation != null) {
        final result = await getDistanceAndDuration(
            _pSourceLocation!, _pDestinationLocation!);
        setState(() {
          distance = result['distance'];
          duration = result['duration'];
        });
      }
    }
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

  Future<Map<String, dynamic>> getDistanceAndDuration(
      LatLng origin, LatLng destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?origins=${origin.latitude},${origin.longitude}&destinations=${destination.latitude},${destination.longitude}&key=$GoogleApiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['rows'].isNotEmpty) {
        final elements = data['rows'][0]['elements'][0];

        final distanceText = elements['distance']['text'];
        final durationText = elements['duration']['text'];

        return {
          'distance': distanceText,
          'duration': durationText,
        };
      }
    }
    return {
      'distance': 'N/A',
      'duration': 'N/A',
    };
  }
}
