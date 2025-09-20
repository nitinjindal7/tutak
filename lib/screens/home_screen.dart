import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bus_saathi/services/offline_service.dart';
import 'package:bus_saathi/models/bus_model.dart';
import 'package:bus_saathi/widgets/next_buses_list.dart';
import 'package:bus_saathi/utils/localization.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Bus> _nextBuses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNextBuses();
  }

  Future<void> _loadNextBuses() async {
    final offlineService = Provider.of<OfflineService>(context, listen: false);
    final buses = await offlineService.getNextBuses();
    
    setState(() {
      _nextBuses = buses;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('appTitle')),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadNextBuses,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    localizations.translate('nextBuses'),
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                Expanded(
                  child: NextBusesList(buses: _nextBuses),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: localizations.translate('home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: localizations.translate('map'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: localizations.translate('settings'),
          ),
        ],
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }
}