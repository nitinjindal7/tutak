import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bus_saathi/services/database_service.dart';
import 'package:bus_saathi/utils/localization.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _backgroundLocation = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final databaseService = Provider.of<DatabaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('settings')),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text(localizations.translate('notifications')),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text(localizations.translate('backgroundLocation')),
            trailing: Switch(
              value: _backgroundLocation,
              onChanged: (value) {
                setState(() {
                  _backgroundLocation = value;
                });
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.download),
            title: Text(localizations.translate('downloadRoutes')),
            onTap: () {
              _downloadRoutes(databaseService);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text(localizations.translate('clearCache')),
            onTap: () {
              _clearCache(databaseService);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.language),
            title: Text(localizations.translate('language')),
            trailing: DropdownButton<String>(
              value: 'pa',
              items: [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'pa', child: Text('ਪੰਜਾਬੀ')),
              ],
              onChanged: (value) {
                // Change app language
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text(localizations.translate('help')),
            onTap: () {
              // Show help dialog
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(localizations.translate('about')),
            onTap: () {
              // Show about dialog
            },
          ),
        ],
      ),
    );
  }

  void _downloadRoutes(DatabaseService databaseService) async {
    // Implement route download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Routes downloaded successfully')),
    );
  }

  void _clearCache(DatabaseService databaseService) async {
    await databaseService.clearAllData();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cache cleared successfully')),
    );
  }
}