import 'dart:async';
import 'dart:convert';
import 'package:autohub_app/pages/home_page.dart';
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

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
                Container(
                  width: screenWidth * 0.9,
                  height: 98,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor.withOpacity(0.9),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    border: Border.all(color: AppColors.primaryColor),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 25),
                        child: TextField(
                          controller: searchPlaceController,
                          decoration: const InputDecoration(
                            hintText: "Search Source Location",
                            hintStyle: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: Icon(
                              Icons.circle,
                              color: Colors.green,
                              size: 15,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            placeAutocomplete(value, true);
                          },
                        ),
                      ),
                      const Divider(
                        height: 0.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 25),
                        child: TextField(
                          controller: destinationPlaceController,
                          decoration: const InputDecoration(
                            hintText: "Search Destination Location",
                            hintStyle: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: Icon(Icons.search_outlined,
                                color: Colors.grey, size: 20),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            placeAutocomplete(value, false);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                // Container to display the list of all the suggestions
                if (searchPlaceController.text.isNotEmpty)
                  Expanded(
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
                                CameraUpdate.newLatLngZoom(
                                    selectedLocation, 15),
                              );
                              await updatePolylines();
                            }
                          }),
                    ),
                  ),

                if (destinationPlaceController.text.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: destinationPlacePredictions.length,
                      itemBuilder: (context, index) => LocationListTile(
                          location:
                              destinationPlacePredictions[index].description!,
                          press: () async {
                            LatLng? selectedLocation = await getPlaceDetails(
                                destinationPlacePredictions[index].placeId!);
                            if (selectedLocation != null) {
                              setState(() {
                                _pDestinationLocation = selectedLocation;
                                destinationPlaceController.text =
                                    destinationPlacePredictions[index]
                                        .description!;
                                destinationPlacePredictions.clear();
                              });
                              mapController.animateCamera(
                                CameraUpdate.newLatLngZoom(
                                    selectedLocation, 15),
                              );
                              await updatePolylines();
                            }
                          }),
                    ),
                  ),

                // Container to display the Current Location button
                if (searchPlaceController.text.isEmpty)
                  Container(
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.05,
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
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Current Location",
                            style: TextStyle(color: AppColors.backgroundColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Add the distance and duration display
                if (distance.isNotEmpty && duration.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Distance: $distance, Duration: $duration',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Spacer(),
                Container(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.06,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      child: Text("Continue", style: TextStyle(
                        color: AppColors.backgroundColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),)),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                )
              ],
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
