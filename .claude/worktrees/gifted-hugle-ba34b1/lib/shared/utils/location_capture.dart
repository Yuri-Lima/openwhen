import 'package:geolocator/geolocator.dart';

/// Product rule: opening only allowed within this distance of [senderLocation].
const double kProximityRadiusMeters = 10;

/// Returns current position, or null if services off, denied, or unavailable.
Future<Position?> tryGetCurrentPosition() async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return null;

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    return null;
  }

  return Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
    ),
  );
}
