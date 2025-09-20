import 'package:flutter/material.dart';
import 'package:bus_saathi/models/route_model.dart';
import 'package:bus_saathi/utils/localization.dart';

class RouteDetailScreen extends StatelessWidget {
  final Route route;

  const RouteDetailScreen({Key? key, required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(route.name),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${localizations.translate('route')}: ${route.name}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('${localizations.translate('source')}: ${route.source}'),
                  Text('${localizations.translate('destination')}: ${route.destination}'),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            localizations.translate('stops'),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          ...route.stops.map((stop) => Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(stop.sequence.toString()),
              ),
              title: Text(stop.name),
              subtitle: Text('Lat: ${stop.lat.toStringAsFixed(4)}, Lng: ${stop.lng.toStringAsFixed(4)}'),
            ),
          )),
          SizedBox(height: 16),
          Text(
            localizations.translate('schedule'),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          ...route.schedule.entries.map((entry) => Card(
            child: ListTile(
              title: Text(entry.key),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: entry.value.map((time) => Text(time)).toList(),
              ),
            ),
          )),
        ],
      ),
    );
  }
}