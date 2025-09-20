import 'package:flutter/material.dart';
import 'package:bus_saathi/utils/localization.dart';

class TrackingButton extends StatefulWidget {
  final VoidCallback onStartTracking;
  final VoidCallback onStopTracking;
  final bool isTracking;

  const TrackingButton({
    Key? key,
    required this.onStartTracking,
    required this.onStopTracking,
    this.isTracking = false,
  }) : super(key: key);

  @override
  _TrackingButtonState createState() => _TrackingButtonState();
}

class _TrackingButtonState extends State<TrackingButton> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return FloatingActionButton(
      onPressed: widget.isTracking ? widget.onStopTracking : widget.onStartTracking,
      backgroundColor: widget.isTracking ? Colors.red : Colors.green,
      child: Icon(
        widget.isTracking ? Icons.stop : Icons.directions_bus,
        color: Colors.white,
      ),
      tooltip: widget.isTracking
          ? localizations.translate('stopTracking')
          : localizations.translate('startTracking'),
    );
  }
}