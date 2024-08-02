import 'dart:async';
import 'dart:convert';
import 'package:autohub_app/pages/destination_page.dart';
import 'package:autohub_app/pages/destination_page_sample.dart';
import 'package:autohub_app/pages/home_page.dart';
import 'package:autohub_app/pages/map_ride_price_page.dart';
import 'package:autohub_app/pages/search_page.dart';
import 'package:autohub_app/pages/user_details_page.dart';
import 'package:http/http.dart' as http;
import 'package:autohub_app/components/const.dart';
import 'package:autohub_app/components/location_list_tile.dart';
import 'package:autohub_app/components/network_utility.dart';
import 'package:autohub_app/models/autocomplete_prediction.dart';
import 'package:autohub_app/models/place_auto_complete_response.dart';
import 'package:autohub_app/models/place_details_response.dart';
import 'package:autohub_app/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<AutocompletePrediction> sourcePlacePredictions = [];
  List<AutocompletePrediction> destinationPlacePredictions = [];
  TextEditingController searchPlaceController = TextEditingController();
  TextEditingController destinationPlaceController = TextEditingController();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  LatLng? _pCurrentLocation;
  LatLng? _pSourceLocation;
  LatLng? _pDestinationLocation;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylinesCoordinates = [];
  late GoogleMapController mapController;
  Location _locationController = Location();

  String distance = '';
  String duration = '';

  bool isPremiumSelected = true;

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

  Future<String> getPlaceName(LatLng location) async {
    Uri uri = Uri.https("maps.googleapis.com", "maps/api/geocode/json", {
      "latlng": "${location.latitude},${location.longitude}",
      "key": GoogleApiKey,
    });
    String? response = await NetworkUtility.fetchUrl(uri);
    if (response != null) {
      final data = jsonDecode(response);
      if (data["results"] != null && data["results"].isNotEmpty) {
        return data["results"][0]["formatted_address"];
      }
    }
    return "";
  }

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
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _pCurrentLocation == null
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
                      CameraPosition(target: _pCurrentLocation!, zoom: 13),
                  markers: {
                    if (_pSourceLocation != null)
                      Marker(
                        markerId: MarkerId("_sourceLocation"),
                        icon: BitmapDescriptor.defaultMarkerWithHue(90),
                        position: _pSourceLocation!,
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
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
            child: Column(
              children: [
                // Top Search Bar -> Source Location and Destination Location
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        // width: screenWidth * 0.75,
                        // height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          // border: Border.all(color: AppColors.primaryColor),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: searchPlaceController,
                          decoration: const InputDecoration(
                            hintText: "Search Location",
                            hintStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 20,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            placeAutocomplete(value, true);
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

                // Container to display the list of all the suggestions
              ],
            ),
          ),
          if (searchPlaceController.text.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.15, left: 10, right: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),

                  // border: Border.all(color: Colors.blueGrey.shade100),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
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
          if (destinationPlaceController.text.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: destinationPlacePredictions.length,
                itemBuilder: (context, index) => LocationListTile(
                    location: destinationPlacePredictions[index].description!,
                    press: () async {
                      LatLng? selectedLocation = await getPlaceDetails(
                          destinationPlacePredictions[index].placeId!);
                      if (selectedLocation != null) {
                        setState(() {
                          _pDestinationLocation = selectedLocation;
                          destinationPlaceController.text =
                              destinationPlacePredictions[index].description!;
                          destinationPlacePredictions.clear();
                        });
                        mapController.animateCamera(
                          CameraUpdate.newLatLngZoom(selectedLocation, 15),
                        );
                        await updatePolylines();
                      }
                    }),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Choose your ride',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      // SizedBox(
                      //   width: screenWidth * 0.34,
                      // ),
                      // Container to display the Current Location button
                      if (searchPlaceController.text.isEmpty &&
                          destinationPlaceController.text.isEmpty)
                        Container(
                          // width: screenWidth * 0.2,
                          height: screenHeight * 0.04,
                          child: ElevatedButton(
                            onPressed: () async {
                              LocationData currentLocation =
                                  await _locationController.getLocation();
                              LatLng currentLatLng = LatLng(
                                  currentLocation.latitude!,
                                  currentLocation.longitude!);
                              String placeName =
                                  await getPlaceName(currentLatLng);
                              setState(() {
                                _pSourceLocation = currentLatLng;
                                searchPlaceController.text = placeName;
                              });
                              mapController.animateCamera(
                                CameraUpdate.newLatLngZoom(currentLatLng, 15),
                              );
                            },
                            child: const Icon(Icons.my_location, color: AppColors.primaryColor,),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey.shade50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            // child: const Icon(Icons.my_location,
                            //     color: Colors.green, size: 20),
                          ),
                        ),
                    ],
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
                      // Navigator.pop(context,{'sourceLocation': _pSourceLocation});
                      if(_pSourceLocation != null)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchPage(_pSourceLocation, _pSourceLocation),
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
