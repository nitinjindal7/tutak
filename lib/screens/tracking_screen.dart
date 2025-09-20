import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:bus_saathi/utils/localization.dart';
import 'package:bus_saathi/widgets/tracking_button.dart';

class TrackingScreen extends StatefulWidget {
  final String routeId;

  const TrackingScreen({Key? key, required this.routeId}) : super(key: key);

  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final MapController _mapController = MapController();
  bool _isTracking = false;
  List<LatLng> _trackedPath = [];
  LatLng _currentPosition = LatLng(31.6340, 74.8723);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('tracking')),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _currentPosition,
              zoom: 13.0,
              onPositionChanged: (position, hasGesture) {
                if (_isTracking) {
                  setState(() {
                    _currentPosition = position.center!;
                    _trackedPath.add(_currentPosition);
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _trackedPath,
                    color: Colors.blue,
                    strokeWidth: 4.0,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentPosition,
                    builder: (ctx) => Icon(Icons.location_pin, color: Colors.red, size: 40),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: TrackingButton(
              onStartTracking: _startTracking,
              onStopTracking: _stopTracking,
              isTracking: _isTracking,
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status: ${_isTracking ? 'Tracking' : 'Stopped'}'),
                    Text('Points: ${_trackedPath.length}'),
                    Text('Route: ${widget.routeId}'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startTracking() {
    setState(() {
      _isTracking = true;
      _trackedPath.clear();
      _trackedPath.add(_currentPosition);
    });
  }

  void _stopTracking() {
    setState(() {
      _isTracking = false;
    });
  }
}