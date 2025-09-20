import 'package:latlong2/latlong.dart';

class MapUtils {
  static double calculateDistance(LatLng point1, LatLng point2) {
    const Distance distance = Distance();
    return distance(point1, point2);
  }

  static LatLng calculateMidpoint(LatLng point1, LatLng point2) {
    return LatLng(
      (point1.latitude + point2.latitude) / 2,
      (point1.longitude + point2.longitude) / 2,
    );
  }

  static double calculateBearing(LatLng point1, LatLng point2) {
    final lat1 = point1.latitude * pi / 180;
    final lon1 = point1.longitude * pi / 180;
    final lat2 = point2.latitude * pi / 180;
    final lon2 = point2.longitude * pi / 180;

    final y = sin(lon2 - lon1) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lon2 - lon1);
    final bearing = atan2(y, x);

    return (bearing * 180 / pi + 360) % 360;
  }

  static LatLng moveAlongBearing(LatLng start, double bearing, double distance) {
    const R = 6371000.0; // Earth radius in meters
    final bearingRad = bearing * pi / 180;
    final latRad = start.latitude * pi / 180;
    final lonRad = start.longitude * pi / 180;

    final newLat = asin(sin(latRad) * cos(distance / R) +
        cos(latRad) * sin(distance / R) * cos(bearingRad));
    final newLon = lonRad + atan2(sin(bearingRad) * sin(distance / R) * cos(latRad),
        cos(distance / R) - sin(latRad) * sin(newLat));

    return LatLng(newLat * 180 / pi, newLon * 180 / pi);
  }

  static bool isPointOnPath(LatLng point, List<LatLng> path, double tolerance) {
    for (int i = 0; i < path.length - 1; i++) {
      if (distanceToSegment(point, path[i], path[i + 1]) <= tolerance) {
        return true;
      }
    }
    return false;
  }

  static double distanceToSegment(LatLng point, LatLng segmentStart, LatLng segmentEnd) {
    const Distance distance = Distance();
    
    final segmentLength = distance(segmentStart, segmentEnd);
    if (segmentLength == 0) return distance(segmentStart, point);
    
    final t = ((point.latitude - segmentStart.latitude) * (segmentEnd.latitude - segmentStart.latitude) +
              (point.longitude - segmentStart.longitude) * (segmentEnd.longitude - segmentStart.longitude)) /
             (segmentLength * segmentLength);
    
    if (t < 0) return distance(segmentStart, point);
    if (t > 1) return distance(segmentEnd, point);
    
    final projection = LatLng(
      segmentStart.latitude + t * (segmentEnd.latitude - segmentStart.latitude),
      segmentStart.longitude + t * (segmentEnd.longitude - segmentStart.longitude),
    );
    
    return distance(point, projection);
  }
}