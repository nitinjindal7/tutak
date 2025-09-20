class Bus {
  final String id;
  final String number;
  final String routeId;
  final String source;
  final String destination;
  final String departureTime;
  final String arrivalTime;
  final String driverName;
  final double? currentLat;
  final double? currentLng;
  final String status;
  final DateTime lastUpdated;

  Bus({
    required this.id,
    required this.number,
    required this.routeId,
    required this.source,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
    required this.driverName,
    this.currentLat,
    this.currentLng,
    this.status = 'scheduled',
    required this.lastUpdated,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'],
      number: json['number'],
      routeId: json['routeId'],
      source: json['source'],
      destination: json['destination'],
      departureTime: json['departureTime'],
      arrivalTime: json['arrivalTime'],
      driverName: json['driverName'],
      currentLat: json['currentLat'],
      currentLng: json['currentLng'],
      status: json['status'] ?? 'scheduled',
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'routeId': routeId,
      'source': source,
      'destination': destination,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'driverName': driverName,
      'currentLat': currentLat,
      'currentLng': currentLng,
      'status': status,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}