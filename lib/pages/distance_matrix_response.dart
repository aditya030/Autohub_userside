// distance_matrix_response.dart
import 'dart:convert';

class DistanceMatrixResponse {
  final List<DistanceMatrixRow> rows;

  DistanceMatrixResponse({required this.rows});

  factory DistanceMatrixResponse.fromJson(Map<String, dynamic> json) {
    return DistanceMatrixResponse(
      rows: (json['rows'] as List)
          .map((row) => DistanceMatrixRow.fromJson(row))
          .toList(),
    );
  }

  static DistanceMatrixResponse parseDistanceMatrixResult(String responseBody) {
    final parsed = jsonDecode(responseBody);
    return DistanceMatrixResponse.fromJson(parsed);
  }

  static parseDistanceMatrixResponse(json) {}
}

class DistanceMatrixRow {
  final List<DistanceMatrixElement> elements;

  DistanceMatrixRow({required this.elements});

  factory DistanceMatrixRow.fromJson(Map<String, dynamic> json) {
    return DistanceMatrixRow(
      elements: (json['elements'] as List)
          .map((element) => DistanceMatrixElement.fromJson(element))
          .toList(),
    );
  }
}

class DistanceMatrixElement {
  final DistanceMatrixValue distance;
  final DistanceMatrixValue duration;
  final String status;

  DistanceMatrixElement(
      {required this.distance, required this.duration, required this.status});

  factory DistanceMatrixElement.fromJson(Map<String, dynamic> json) {
    return DistanceMatrixElement(
      distance: DistanceMatrixValue.fromJson(json['distance']),
      duration: DistanceMatrixValue.fromJson(json['duration']),
      status: json['status'],
    );
  }
}

class DistanceMatrixValue {
  final String text;
  final int value;

  DistanceMatrixValue({required this.text, required this.value});

  factory DistanceMatrixValue.fromJson(Map<String, dynamic> json) {
    return DistanceMatrixValue(
      text: json['text'],
      value: json['value'],
    );
  }
}
