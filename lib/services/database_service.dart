import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:bus_saathi/models/bus_model.dart';
import 'package:bus_saathi/models/route_model.dart';

class DatabaseService {
  static const _databaseName = 'bus_saathi.db';
  static const _databaseVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create buses table
    await db.execute('''
      CREATE TABLE buses (
        id TEXT PRIMARY KEY,
        number TEXT NOT NULL,
        routeId TEXT NOT NULL,
        source TEXT NOT NULL,
        destination TEXT NOT NULL,
        departureTime TEXT NOT NULL,
        arrivalTime TEXT NOT NULL,
        driverName TEXT NOT NULL,
        currentLat REAL,
        currentLng REAL,
        status TEXT NOT NULL,
        lastUpdated TEXT NOT NULL
      )
    ''');

    // Create routes table
    await db.execute('''
      CREATE TABLE routes (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        source TEXT NOT NULL,
        destination TEXT NOT NULL,
        path TEXT NOT NULL,
        schedule TEXT NOT NULL
      )
    ''');

    // Create stops table
    await db.execute('''
      CREATE TABLE stops (
        id TEXT PRIMARY KEY,
        routeId TEXT NOT NULL,
        name TEXT NOT NULL,
        lat REAL NOT NULL,
        lng REAL NOT NULL,
        sequence INTEGER NOT NULL
      )
    ''');

    // Create trip_logs table for offline tracking
    await db.execute('''
      CREATE TABLE trip_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        routeId TEXT NOT NULL,
        startTime TEXT NOT NULL,
        endTime TEXT,
        gpsPoints TEXT NOT NULL,
        synced INTEGER DEFAULT 0
      )
    ''');
  }

  // Bus methods
  Future<void> insertBus(Bus bus) async {
    final db = await database;
    await db.insert('buses', bus.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Bus>> getAllBuses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('buses');
    return List.generate(maps.length, (i) => Bus.fromJson(maps[i]));
  }

  Future<Bus?> getBus(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'buses',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Bus.fromJson(maps.first);
    }
    return null;
  }

  // Route methods
  Future<void> insertRoute(Route route) async {
    final db = await database;
    await db.insert('routes', {
      'id': route.id,
      'name': route.name,
      'source': route.source,
      'destination': route.destination,
      'path': json.encode(route.path),
      'schedule': json.encode(route.schedule),
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    // Insert stops
    for (final stop in route.stops) {
      await db.insert('stops', {
        'id': stop.id,
        'routeId': route.id,
        'name': stop.name,
        'lat': stop.lat,
        'lng': stop.lng,
        'sequence': stop.sequence,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<Route>> getAllRoutes() async {
    final db = await database;
    final List<Map<String, dynamic>> routeMaps = await db.query('routes');
    
    final List<Route> routes = [];
    for (final routeMap in routeMaps) {
      final stops = await getStopsForRoute(routeMap['id']);
      routes.add(Route(
        id: routeMap['id'],
        name: routeMap['name'],
        source: routeMap['source'],
        destination: routeMap['destination'],
        stops: stops,
        path: List<Map<String, double>>.from(json.decode(routeMap['path'])),
        schedule: Map<String, List<String>>.from(json.decode(routeMap['schedule'])),
      ));
    }
    return routes;
  }

  Future<List<RouteStop>> getStopsForRoute(String routeId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'stops',
      where: 'routeId = ?',
      whereArgs: [routeId],
      orderBy: 'sequence',
    );
    return List.generate(maps.length, (i) => RouteStop.fromJson(maps[i]));
  }

  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('buses');
    await db.delete('routes');
    await db.delete('stops');
    await db.delete('trip_logs');
  }

  Future<void> initialize() async {
    await database; // Ensure database is initialized
  }
}