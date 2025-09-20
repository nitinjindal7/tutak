import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print('Usage: dart convert_to_app_format.dart <input_file.json>');
    exit(1);
  }

  final inputFile = File(arguments[0]);
  if (!inputFile.existsSync()) {
    print('Error: File ${arguments[0]} does not exist');
    exit(1);
  }

  try {
    final jsonData = json.decode(inputFile.readAsStringSync());
    final convertedData = _convertData(jsonData);
    
    final outputFile = File('converted_routes.json');
    outputFile.writeAsStringSync(json.encode(convertedData, indent: 2));
    
    print('Conversion successful! Output written to converted_routes.json');
  } catch (e) {
    print('Error converting data: $e');
    exit(1);
  }
}

Map<String, dynamic> _convertData(Map<String, dynamic> originalData) {
  final routes = <String, dynamic>{};
  int routeCount = 0;
  
  originalData.forEach((busId, busData) {
    final routeKey = '${busData['source']}-${busData['destination']}';
    
    if (!routes.containsKey(routeKey)) {
      routeCount++;
      routes[routeKey] = {
        'id': 'route-$routeCount',
        'name': '${busData['source']} - ${busData['destination']}',
        'source': busData['source'],
        'destination': busData['destination'],
        'stops': _generateStops(busData['source'], busData['destination']),
        'path': _generatePath(busData['source'], busData['destination']),
        'schedule': _generateSchedule(busData['departureTime']),
        'buses': []
      };
    }
    
    (routes[routeKey]['buses'] as List).add({
      'id': busId,
      'number': busData['busNumber'],
      'departureTime': busData['departureTime'],
      'arrivalTime': busData['arrivalTime'],
      'driverName': busData['driverName'],
      'status': 'scheduled'
    });
  });
  
  return {'routes': routes.values.toList()};
}

List<Map<String, dynamic>> _generateStops(String source, String destination) {
  // This is a simplified implementation
  // In a real app, you would have actual stop data
  return [
    {
      'id': 'stop-1',
      'name': '$source Bus Stand',
      'lat': _getCityCoordinates(source)['lat'] + 0.005,
      'lng': _getCityCoordinates(source)['lng'] + 0.005,
      'sequence': 1
    },
    {
      'id': 'stop-2',
      'name': 'Midway Stop',
      'lat': (_getCityCoordinates(source)['lat'] + _getCityCoordinates(destination)['lat']) / 2,
      'lng': (_getCityCoordinates(source)['lng'] + _getCityCoordinates(destination)['lng']) / 2,
      'sequence': 2
    },
    {
      'id': 'stop-3',
      'name': '$destination Bus Stand',
      'lat': _getCityCoordinates(destination)['lat'] - 0.005,
      'lng': _getCityCoordinates(destination)['lng'] - 0.005,
      'sequence': 3
    }
  ];
}

List<Map<String, double>> _generatePath(String source, String destination) {
  final sourceCoords = _getCityCoordinates(source);
  final destCoords = _getCityCoordinates(destination);
  
  return [
    {'lat': sourceCoords['lat']!, 'lng': sourceCoords['lng']!},
    {'lat': destCoords['lat']!, 'lng': destCoords['lng']!}
  ];
}

Map<String, List<String>> _generateSchedule(String departureTime) {
  return {
    'weekday': [departureTime, _addHours(departureTime, 2), _addHours(departureTime, 4)],
    'weekend': [_addHours(departureTime, 1), _addHours(departureTime, 3)]
  };
}

String _addHours(String time, int hours) {
  final parts = time.split(':');
  final hour = (int.parse(parts[0]) + hours) % 24;
  return '${hour.toString().padLeft(2, '0')}:${parts[1]}';
}

Map<String, double> _getCityCoordinates(String city) {
  final coordinates = {
    'Amritsar': {'lat': 31.6340, 'lng': 74.8723},
    'Ludhiana': {'lat': 30.9010, 'lng': 75.8573},
    'Jalandhar': {'lat': 31.3260, 'lng': 75.5762},
    'Patiala': {'lat': 30.3398, 'lng': 76.3869},
    'Moga': {'lat': 30.8165, 'lng': 75.1710},
    'Faridkot': {'lat': 30.6730, 'lng': 74.7550},
    'Bathinda': {'lat': 30.2070, 'lng': 74.9483},
    'Sangrur': {'lat': 30.2450, 'lng': 75.8450},
    'Mohali': {'lat': 30.7046, 'lng': 76.7179},
    'Ropar': {'lat': 30.9650, 'lng': 76.5330},
    'Pathankot': {'lat': 32.2740, 'lng': 75.6520},
    'Gurdaspur': {'lat': 32.0380, 'lng': 75.4050},
    'Barnala': {'lat': 30.3740, 'lng': 75.5460},
  };
  
  return coordinates[city] ?? {'lat': 31.6340, 'lng': 74.8723}; // Default to Amritsar
}