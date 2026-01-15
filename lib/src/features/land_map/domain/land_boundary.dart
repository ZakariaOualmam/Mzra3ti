import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

class LandBoundary {
  final String id;
  String name;
  List<LatLng> coordinates; // Polygon points for the land boundary
  String? notes;
  DateTime createdAt;

  LandBoundary({
    required this.id,
    required this.name,
    required this.coordinates,
    this.notes,
    required this.createdAt,
  });

  // Calculate area in hectares (approximate)
  double get areaInHectares {
    if (coordinates.length < 3) return 0.0;
    
    double area = 0.0;
    int j = coordinates.length - 1;
    
    for (int i = 0; i < coordinates.length; i++) {
      area += (coordinates[j].longitude + coordinates[i].longitude) *
              (coordinates[j].latitude - coordinates[i].latitude);
      j = i;
    }
    
    // Convert to hectares (rough approximation)
    // 1 degree ≈ 111km at equator
    double areaInSqKm = (area.abs() / 2.0) * 111 * 111;
    return areaInSqKm * 100; // Convert to hectares
  }

  // Get center point of the land
  LatLng get center {
    if (coordinates.isEmpty) return LatLng(0, 0);
    
    double lat = 0;
    double lng = 0;
    
    for (var coord in coordinates) {
      lat += coord.latitude;
      lng += coord.longitude;
    }
    
    return LatLng(lat / coordinates.length, lng / coordinates.length);
  }

  factory LandBoundary.create({
    required String name,
    required List<LatLng> coordinates,
    String? notes,
  }) {
    return LandBoundary(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      coordinates: coordinates,
      notes: notes,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'coordinates': coordinates.map((c) => {'lat': c.latitude, 'lng': c.longitude}).toList(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory LandBoundary.fromMap(Map<String, dynamic> map) {
    return LandBoundary(
      id: map['id'] as String,
      name: map['name'] as String,
      coordinates: (map['coordinates'] as List).map((c) => LatLng(c['lat'], c['lng'])).toList(),
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());
  
  factory LandBoundary.fromJson(String source) => LandBoundary.fromMap(json.decode(source));
}
