import 'dart:async';

import 'package:autohub_app/components/const.dart';
import 'package:autohub_app/pages/destination_page.dart';
import 'package:autohub_app/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

// import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class SampleMaps extends StatefulWidget {
  const SampleMaps({super.key});

  @override
  State<SampleMaps> createState() => _SampleMapsState();
}

class _SampleMapsState extends State<SampleMaps> {
  Location _locationController = Location();
  LatLng? _currentLocation = null;

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylinesCoordinates = [];

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  late GoogleMapController mapController;
  static LatLng _pSource = LatLng(12.9692, 79.1559);
  static LatLng _pDestination = LatLng(12.9244, 79.1353);
  @override
  void initState() {
    super.initState();
    getLocationupdates().then((_) => {
          getPolylinePoints().then((coordinates) => {
                // print(coordinates),
                generatePolylinesFromPoints(coordinates),
              }),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentLocation == null
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
              initialCameraPosition: CameraPosition(target: _pSource, zoom: 18),
              markers: {
                Marker(
                    markerId: MarkerId("_currentLocation"),
                    icon: BitmapDescriptor.defaultMarkerWithHue(90),
                    position: _currentLocation!),
                Marker(
                    markerId: MarkerId("_sourceLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _pSource),
                Marker(
                    markerId: MarkerId("_destionationLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _pDestination),
              },
              polylines: Set<Polyline>.of(polylines.values),
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
          _currentLocation =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(_currentLocation!);
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
