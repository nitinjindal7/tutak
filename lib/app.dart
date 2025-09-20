import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bus_saathi/services/database_service.dart';
import 'package:bus_saathi/services/location_service.dart';
import 'package:bus_saathi/services/offline_service.dart';
import 'package:bus_saathi/screens/home_screen.dart';
import 'package:bus_saathi/utils/localization.dart';

class AppScreen extends StatefulWidget {
  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  late DatabaseService _databaseService;
  late LocationService _locationService;
  late OfflineService _offlineService;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    _databaseService = DatabaseService();
    await _databaseService.initialize();
    
    _locationService = LocationService();
    await _locationService.initialize();
    
    _offlineService = OfflineService(_databaseService, _locationService);
    
    // Load sample data if database is empty
    await _offlineService.loadSampleDataIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DatabaseService>(create: (_) => _databaseService),
        Provider<LocationService>(create: (_) => _locationService),
        Provider<OfflineService>(create: (_) => _offlineService),
      ],
      child: HomeScreen(),
    );
  }
}