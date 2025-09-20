class Route {
  final String id;
  final String name;
  final String source;
  final String destination;
  final List<RouteStop> stops;
  final List<Map<String, double>> path; // List of {lat: x, lng: y}
  final Map<String, List<String>> schedule; // day -> list of departure times

  Route({
    required this.id,
    required this.name,
    required this.source,
    required this.destination,
    required this.stops,
    required this.path,
    required this.schedule,
  });

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      id: json['id'],
      name: json['name'],
      source: json['source'],
      destination: json['destination'],
      stops: (json['stops'] as List).map((stop) => RouteStop.fromJson(stop)).toList(),
      path: List<Map<String, double>>.from(json['path']),
      schedule: Map<String, List<String>>.from(json['schedule']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'source': source,
      'destination': destination,
      'stops': stops.map((stop) => stop.toJson()).toList(),
      'path': path,
      'schedule': schedule,
    };
  }
}

class RouteStop {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final int sequence;

  RouteStop({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.sequence,
  });

  factory RouteStop.fromJson(Map<String, dynamic> json) {
    return RouteStop(
      id: json['id'],
      name: json['name'],
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
      sequence: json['sequence'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lat': lat,
      'lng': lng,
      'sequence': sequence,
    };
  }
}