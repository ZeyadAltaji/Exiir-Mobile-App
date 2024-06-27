import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

double calculateDistance(LatLng start, LatLng end) {
  const double R = 6371; // Radius of the earth in km
  final double dLat = (end.latitude - start.latitude) * pi / 180;
  final double dLon = (end.longitude - start.longitude) * pi / 180;
  final double a = 
    sin(dLat/2) * sin(dLat/2) +
    cos(start.latitude * pi / 180) * cos(end.latitude * pi / 180) * 
    sin(dLon/2) * sin(dLon/2); 
  final double c = 2 * atan2(sqrt(a), sqrt(1-a)); 
  final double distance = R * c; // Distance in km
  return distance;
}
