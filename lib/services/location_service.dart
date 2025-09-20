import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';

class LocationService {
  static const locationTask = "locationTask";

  Future<bool> initialize() async {
    await _requestPermission();
    await _configureBackgroundLocation();
    return true;
  }

  Future<bool> _requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    
    return true;
  }

  Future<void> _configureBackgroundLocation() async {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
    
    await Workmanager().registerPeriodicTask(
      "1",
      locationTask,
      frequency: Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
        batteryNotLow: true,
      ),
    );
  }

  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      switch (task) {
        case locationTask:
          await _handleBackgroundLocation();
          break;
      }
      return Future.value(true);
    });
  }

  static Future<void> _handleBackgroundLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      
      // Here you would typically save the location or process it
      // For example, check if user is near a bus stop and send notification
      
    } catch (e) {
      print("Background location error: $e");
    }
  }

  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<Stream<Position>> getPositionStream() {
    return Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.high,
      distanceFilter: 10, // meters
    );
  }

  Future<double> calculateDistance(double startLat, double startLng, double endLat, double endLng) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }
}