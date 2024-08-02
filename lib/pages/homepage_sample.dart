import 'dart:async';
import 'dart:convert';
import 'dart:math';
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

class HomePageSample extends StatefulWidget {
  const HomePageSample({super.key});

  @override
  State<HomePageSample> createState() => _HomePageSampleState();
}

class _HomePageSampleState extends State<HomePageSample> {
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
                // const SizedBox(
                //   height: 10,
                // ),

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
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.3, right: 10),
              child: FloatingActionButton(
                onPressed: () async {
                  LocationData currentLocation =
                      await _locationController.getLocation();
                  LatLng currentLatLng = LatLng(currentLocation.latitude!,
                      currentLocation.longitude!);
                  String placeName = await getPlaceName(currentLatLng);
                  setState(() {
                    _pSourceLocation = currentLatLng;
                    searchPlaceController.text = placeName;
                  });
                  mapController.animateCamera(
                    CameraUpdate.newLatLngZoom(currentLatLng, 15),
                  );
                },
                child: const Icon(Icons.my_location),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => MapRidePricePage(distance),
                    //   ),
                    // );
                  },
                  child: const Text(
                    'Request a Ride',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getLocationUpdates() async {
    _locationController.onLocationChanged.listen((l) {
      _pCurrentLocation = LatLng(l.latitude!, l.longitude!);
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _pCurrentLocation!, zoom: 13),
        ),
      );
      setState(() {});
    });
  }

  Future<void> updatePolylines() async {
    if (_pSourceLocation != null && _pDestinationLocation != null) {
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          googleApiKey: GoogleApiKey,
          request: PolylineRequest(
              origin: PointLatLng(_pSourceLocation!.latitude,
                  _pSourceLocation!.longitude),
              destination: PointLatLng(_pDestinationLocation!.latitude,
                  _pDestinationLocation!.longitude),
              mode: TravelMode.driving));
      if (result.points.isNotEmpty) {
        polylinesCoordinates.clear();
        result.points.forEach((PointLatLng point) {
          polylinesCoordinates.add(LatLng(point.latitude, point.longitude));
        });
        PolylineId id = PolylineId('poly');
        Polyline polyline = Polyline(
          polylineId: id,
          color: Colors.blue,
          points: polylinesCoordinates,
          width: 8,
        );
        polylines[id] = polyline;

        double totalDistance = 0;
        for (int i = 0; i < polylinesCoordinates.length - 1; i++) {
          totalDistance += calculateDistance(
            polylinesCoordinates[i].latitude,
            polylinesCoordinates[i].longitude,
            polylinesCoordinates[i + 1].latitude,
            polylinesCoordinates[i + 1].longitude,
          );
        }
        setState(() {
          distance = totalDistance.toStringAsFixed(2);
          duration = (totalDistance / 50).toStringAsFixed(2);
        });
      } else {
        polylines.clear();
      }
      setState(() {});
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    const p = 0.017453292519943295;
    const c = 0.0033122705099; // Adjusted for better precision
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
