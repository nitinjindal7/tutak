import 'package:flutter/material.dart';
import 'package:bus_saathi/models/bus_model.dart';
import 'package:bus_saathi/utils/localization.dart';

class NextBusesList extends StatelessWidget {
  final List<Bus> buses;

  const NextBusesList({Key? key, required this.buses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    if (buses.isEmpty) {
      return Center(
        child: Text(
          localizations.translate('noBusesAvailable'),
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: buses.length,
      itemBuilder: (context, index) {
        final bus = buses[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: Icon(Icons.directions_bus, color: Colors.orange),
            title: Text(
              bus.number,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${bus.source} → ${bus.destination}'),
                Text('${localizations.translate('departure')}: ${bus.departureTime}'),
                Text('${localizations.translate('driver')}: ${bus.driverName}'),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.location_on),
              onPressed: () {
                // Navigate to map with bus location
              },
            ),
          ),
        );
      },
    );
  }
}