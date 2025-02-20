import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<String> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // تحقق من تمكين خدمات الموقع
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'تم تعطيل خدمات الموقع.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'تم رفض إذن الموقع.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return 'تم رفض إذن الموقع بشكل دائم.';
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return '${position.latitude},${position.longitude}';
  }
}
