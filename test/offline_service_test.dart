import 'package:flutter_test/flutter_test.dart';
import 'package:bus_saathi/services/offline_service.dart';
import 'package:bus_saathi/services/database_service.dart';
import 'package:bus_saathi/services/location_service.dart';
import 'package:mockito/mockito.dart';

class MockDatabaseService extends Mock implements DatabaseService {}
class MockLocationService extends Mock implements LocationService {}

void main() {
  group('OfflineService Tests', () {
    late MockDatabaseService mockDatabaseService;
    late MockLocationService mockLocationService;
    late OfflineService offlineService;

    setUp(() {
      mockDatabaseService = MockDatabaseService();
      mockLocationService = MockLocationService();
      offlineService = OfflineService(mockDatabaseService, mockLocationService);
    });

    test('Test getNextBuses with empty database', () async {
      when(mockDatabaseService.getAllBuses()).thenAnswer((_) async => []);
      when(mockDatabaseService.getAllRoutes()).thenAnswer((_) async => []);

      final result = await offlineService.getNextBuses();
      
      expect(result, isEmpty);
    });

    test('Test loadSampleDataIfNeeded with empty database', () async {
      when(mockDatabaseService.getAllRoutes()).thenAnswer((_) async => []);
      
      await offlineService.loadSampleDataIfNeeded();
      
      // Verify that sample data loading was attempted
      verify(mockDatabaseService.getAllRoutes()).called(1);
    });

    test('Test trackBusProgress returns expected structure', () async {
      final result = await offlineService.trackBusProgress('test-bus');
      
      expect(result, isMap);
      expect(result.containsKey('progress'), isTrue);
      expect(result.containsKey('nextStop'), isTrue);
      expect(result.containsKey('eta'), isTrue);
    });
  });
}