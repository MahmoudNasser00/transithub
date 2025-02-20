import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

Future<LatLng?> getLatLng(String query) async {
  try {
    final response = await http.get(
      Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=1'),
    );

    if (response.statusCode == 200) {
      final List results = json.decode(response.body);
      if (results.isNotEmpty) {
        final lat = double.parse(results[0]['lat']);
        final lon = double.parse(results[0]['lon']);
        return LatLng(lat, lon);
      }
    }
  } catch (e) {
    throw Exception('Failed to get location');
  }
  return null;
}

Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
  try {
    final response = await http.get(
      Uri.parse(
          'http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> coordinates =
          data['routes'][0]['geometry']['coordinates'];

      return coordinates.map((coord) {
        return LatLng(coord[1], coord[0]);
      }).toList();
    } else {
      throw Exception('Failed to load route');
    }
  } catch (e) {
    throw Exception('Failed to get route');
  }
}
