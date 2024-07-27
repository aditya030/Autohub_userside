import 'dart:async';
import 'dart:convert';
import 'package:autohub_app/pages/distance_matrix_response.dart';
import 'package:autohub_app/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
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
    Uri uri = Uri.https("maps.googleapis.com", "maps/api/place/autocomplete/json", {
      "input": query,
      "key": GoogleApiKey,
    });
    String? response = await NetworkUtility.fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result = PlaceAutocompleteResponse.parseAutocompleteResult(response);
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
      PlaceDetailsResponse result = PlaceDetailsResponse.parsePlaceDetailsResult(response);
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
              ?  Center(
                  child: Image.asset('assets/icons/loading_animation.gif', width: screenHeight*0.3,),
                  )
              : GoogleMap(
                  onMapCreated: ((GoogleMapController controller) {
                    _mapController.complete(controller);
                    mapController = controller;
                  }),
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(target: _pCurrentLocation!, zoom: 13),
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
                                searchPlaceController.text = sourcePlacePredictions[index].description!;
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
                                destinationPlaceController.text = destinationPlacePredictions[index].description!;
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (_pSourceLocation != null && _pDestinationLocation != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ElevatedButton(
                      onPressed: saveRideDetails,
                      child: const Text('Confirm'),
                      
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void getLocationUpdates() async {
    bool serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (mounted) {
        setState(() {
          _pCurrentLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      }
    });
  }

  Future<void> updatePolylines() async {
    if (_pSourceLocation != null && _pDestinationLocation != null) {
      polylinesCoordinates.clear();
      polylinesCoordinates.add(_pSourceLocation!);
      polylinesCoordinates.add(_pDestinationLocation!);

      setState(() {
        polylines.clear();
        PolylineId id = PolylineId("poly");
        Polyline polyline = Polyline(
          polylineId: id,
          color: Colors.blue,
          points: polylinesCoordinates,
          width: 5,
        );
        polylines[id] = polyline;
      });

      // Calculate distance and duration
      Uri uri = Uri.https("maps.googleapis.com", "maps/api/distancematrix/json", {
        "origins": '${_pSourceLocation!.latitude},${_pSourceLocation!.longitude}',
        "destinations": '${_pDestinationLocation!.latitude},${_pDestinationLocation!.longitude}',
        "key": GoogleApiKey,
      });
      String? response = await NetworkUtility.fetchUrl(uri);
      if (response != null) {
        DistanceMatrixResponse result = DistanceMatrixResponse.parseDistanceMatrixResult(response);
        if (result.rows.isNotEmpty &&
            result.rows[0].elements.isNotEmpty &&
            result.rows[0].elements[0].status == 'OK') {
          setState(() {
            distance = result.rows[0].elements[0].distance.text;
            duration = result.rows[0].elements[0].duration.text;
          });
        }
      }
    }
  }

  Future<void> saveRideDetails() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user != null && _pSourceLocation != null && _pDestinationLocation != null) {
      await FirebaseFirestore.instance.collection('rides').doc(user.uid).set({
        'source': GeoPoint(_pSourceLocation!.latitude, _pSourceLocation!.longitude),
        'destination': GeoPoint(_pDestinationLocation!.latitude, _pDestinationLocation!.longitude),
        'distance': distance,
        'duration': duration,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ride details saved successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to save ride details. Please try again.')),
      );
      
    }
  }
}