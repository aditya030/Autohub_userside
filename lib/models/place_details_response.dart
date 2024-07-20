// place_details_response.dart

import 'dart:convert';

class PlaceDetailsResponse {
  final PlaceResult? result;

  PlaceDetailsResponse({this.result});

  factory PlaceDetailsResponse.fromJson(Map<String, dynamic> json) {
    return PlaceDetailsResponse(
      result: json['result'] != null ? PlaceResult.fromJson(json['result']) : null,
    );
  }

  static PlaceDetailsResponse parsePlaceDetailsResult(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<String, dynamic>();
    return PlaceDetailsResponse.fromJson(parsed);
  }
}

class PlaceResult {
  final PlaceGeometry? geometry;

  PlaceResult({this.geometry});

  factory PlaceResult.fromJson(Map<String, dynamic> json) {
    return PlaceResult(
      geometry: json['geometry'] != null ? PlaceGeometry.fromJson(json['geometry']) : null,
    );
  }
}

class PlaceGeometry {
  final PlaceLocation? location;

  PlaceGeometry({this.location});

  factory PlaceGeometry.fromJson(Map<String, dynamic> json) {
    return PlaceGeometry(
      location: json['location'] != null ? PlaceLocation.fromJson(json['location']) : null,
    );
  }
}

class PlaceLocation {
  final double lat;
  final double lng;

  PlaceLocation({required this.lat, required this.lng});

  factory PlaceLocation.fromJson(Map<String, dynamic> json) {
    return PlaceLocation(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}
