import 'package:geolocator/geolocator.dart';

import 'location_capture.dart';

enum ProximityCheckResult {
  withinRadius,
  tooFar,
  locationUnavailable,
}

/// Whether the device is within [kProximityRadiusMeters] of the anchor point.
Future<ProximityCheckResult> checkWithinProximityRadius({
  required double anchorLat,
  required double anchorLng,
}) async {
  final pos = await tryGetCurrentPosition();
  if (pos == null) return ProximityCheckResult.locationUnavailable;
  final meters = Geolocator.distanceBetween(
    anchorLat,
    anchorLng,
    pos.latitude,
    pos.longitude,
  );
  if (meters <= kProximityRadiusMeters) {
    return ProximityCheckResult.withinRadius;
  }
  return ProximityCheckResult.tooFar;
}
