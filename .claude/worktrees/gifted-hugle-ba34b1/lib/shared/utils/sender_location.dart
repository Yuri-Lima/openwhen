import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

/// Optional point attached by the sender when creating a letter or capsule.
class SenderLocationData {
  final double lat;
  final double lng;
  final DateTime? capturedAt;

  const SenderLocationData({
    required this.lat,
    required this.lng,
    this.capturedAt,
  });
}

SenderLocationData? parseSenderLocationData(dynamic raw) {
  if (raw is! Map) return null;
  final lat = raw['lat'];
  final lng = raw['lng'];
  if (lat is! num || lng is! num) return null;
  final cap = raw['capturedAt'];
  return SenderLocationData(
    lat: lat.toDouble(),
    lng: lng.toDouble(),
    capturedAt: cap is Timestamp ? cap.toDate() : null,
  );
}

String googleMapsSearchUrl(double lat, double lng) =>
    'https://www.google.com/maps?q=$lat,$lng';

void copyLocationToClipboard(double lat, double lng) {
  Clipboard.setData(ClipboardData(text: googleMapsSearchUrl(lat, lng)));
}
