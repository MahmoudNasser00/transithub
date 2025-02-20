import 'package:latlong2/latlong.dart';

double calculateDistance(LatLng start, LatLng end) {
  final Distance distance = Distance();
  return distance.as(LengthUnit.Kilometer, start, end);
}
