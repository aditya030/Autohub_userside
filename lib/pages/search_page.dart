import 'dart:async';
import 'dart:convert'; // Add this import
import 'package:autohub_app/components/const.dart';
import 'package:autohub_app/components/location_list_tile.dart';
import 'package:autohub_app/components/network_utility.dart';
import 'package:autohub_app/models/autocomplete_prediction.dart';
import 'package:autohub_app/models/place_auto_complete_response.dart';
import 'package:autohub_app/models/place_details_response.dart'; // Import the place details response model
import 'package:autohub_app/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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
  late GoogleMapController mapController;
  Location _locationController = Location();

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
                      TextField(
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
                      const Divider(
                        height: 0.0,
                      ),
                      TextField(
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
                            LatLng? selectedLocation =
                                await getPlaceDetails(
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
                                    selectedLocation, 13),
                              );
                            }
                          }),
                    ),
                  ),

                if (destinationPlaceController.text.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: destinationPlacePredictions.length,
                      itemBuilder: (context, index) => LocationListTile(
                          location: destinationPlacePredictions[index]
                              .description!,
                          press: () async {
                            LatLng? selectedLocation =
                                await getPlaceDetails(
                                    destinationPlacePredictions[index]
                                        .placeId!);
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
                                    selectedLocation, 13),
                              );
                            }
                          }),
                    ),
                  ),

                // Container to display the Current Location button
                if (searchPlaceController.text.isEmpty)
                  Container(
                    width: screenWidth * 0.55,
                    height: screenHeight * 0.05,
                    child: ElevatedButton(
                      onPressed: () {
                        placeAutocomplete("Dubai", true);
                      },
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
                            "Your Current Location",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
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
}
