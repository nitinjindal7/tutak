import 'package:bus_saathi/models/bus_model.dart';
import 'package:bus_saathi/models/route_model.dart';
import 'package:bus_saathi/services/database_service.dart';
import 'package:bus_saathi/services/location_service.dart';
import 'package:bus_saathi/utils/time_utils.dart';

class OfflineService {
  final DatabaseService _databaseService;
  final LocationService _locationService;

  OfflineService(this._databaseService, this._locationService);

  Future<void> loadSampleDataIfNeeded() async {
    final routes = await _databaseService.getAllRoutes();
    if (routes.isEmpty) {
      await _loadSampleData();
    }
  }

  Future<void> _loadSampleData() async {
    // This would load from assets/data/sample_routes.json
    // For now, we'll create some sample data
    final sampleRoute = Route(
      id: 'amritsar-ludhiana',
      name: 'Amritsar - Ludhiana',
      source: 'Amritsar',
      destination: 'Ludhiana',
      stops: [
        RouteStop(
          id: 'stop1',
          name: 'Amritsar Bus Stand',
          lat: 31.6340,
          lng: 74.8723,
          sequence: 1,
        ),
        RouteStop(
          id: 'stop2',
          name: 'Jandiala',
          lat: 31.5600,
          lng: 75.0300,
          sequence: 2,
        ),
        RouteStop(
          id: 'stop3',
          name: 'Ludhiana Bus Stand',
          lat: 30.9010,
          lng: 75.8573,
          sequence: 3,
        ),
      ],
      path: [
        {'lat': 31.6340, 'lng': 74.8723},
        {'lat': 31.5600, 'lng': 75.0300},
        {'lat': 30.9010, 'lng': 75.8573},
      ],
      schedule: {
        'weekday': ['08:00', '10:00', '14:00', '18:00'],
        'weekend': ['09:00', '13:00', '17:00'],
      },
    );

    await _databaseService.insertRoute(sampleRoute);

    // Add sample buses
    final sampleBus = Bus(
      id: 'BUS-PN01-1234',
      number: 'BUS-PN01-1234',
      routeId: 'amritsar-ludhiana',
      source: 'Amritsar',
      destination: 'Ludhiana',
      departureTime: '08:00',
      arrivalTime: '11:00',
      driverName: 'Mr. Singh',
      lastUpdated: DateTime.now(),
    );

    await _databaseService.insertBus(sampleBus);
  }

  Future<List<Bus>> getNextBuses({int limit = 5}) async {
    try {
      final position = await _locationService.getCurrentPosition();
      final allBuses = await _databaseService.getAllBuses();
      final allRoutes = await _databaseService.getAllRoutes();
      
      // Filter and sort buses based on proximity and schedule
      final now = TimeOfDay.now();
      final currentDay = DateTime.now().weekday < 6 ? 'weekday' : 'weekend';
      
      final relevantBuses = allBuses.where((bus) {
        final route = allRoutes.firstWhere((r) => r.id == bus.routeId);
        final schedule = route.schedule[currentDay] ?? [];
        
        // Check if bus is scheduled to run today
        return schedule.contains(bus.departureTime);
      }).toList();

      // Sort by proximity to user (simplified)
      relevantBuses.sort((a, b) {
        // This is a simplified calculation - in real app, you'd calculate
        // distance to bus route or next stop
        return 0; // Placeholder
      });

      return relevantBuses.take(limit).toList();
    } catch (e) {
      print('Error getting next buses: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> trackBusProgress(String busId) async {
    // This would use the current location and match it to the bus route
    // to determine progress percentage and next stops
    return {
      'progress': 0.5,
      'nextStop': 'Jandiala',
      'eta': '30 minutes',
      'currentSpeed': 45.0,
    };
  }

  Future<void> startTripTracking(String routeId) async {
    // Start tracking user's position along the route
    final positionStream = await _locationService.getPositionStream();
    // Would typically save positions to database for offline syncing
  }

  Future<void> syncOfflineData() async {
    // This would upload any locally stored trip data when online
    // and download updated schedules
  }
}