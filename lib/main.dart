import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bus_saathi/app.dart';
import 'package:bus_saathi/utils/localization.dart';

import 'app.dart';
import 'screens/flutter/packages/flutter/lib/cupertino.dart';
import 'screens/flutter/packages/flutter/lib/material.dart';
import 'screens/flutter/packages/flutter/lib/painting.dart' show TextStyle;
import 'screens/flutter/packages/flutter/lib/src/material/text_theme.dart';
import 'screens/flutter/packages/flutter_localizations/lib/flutter_localizations.dart' show GlobalMaterialLocalizations;
import 'screens/flutter/packages/flutter_localizations/lib/src/cupertino_localizations.dart';
import 'screens/flutter/packages/flutter_localizations/lib/src/widgets_localizations.dart';
import 'utils/localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await LocalizationService.initialize();
  
  runApp(BusSaathiApp());
}

class BusSaathiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ਬੱਸ ਸਾਥੀ',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Punjabi',
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16.0, fontFamily: 'Punjabi'),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Punjabi'),
          displayLarge: TextStyle(fontSize: 24.0, fontFamily: 'Punjabi', fontWeight: FontWeight.bold),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.orange,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16.0, fontFamily: 'Punjabi'),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Punjabi'),
        ),
      ),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('pa', ''),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: AppScreen(),
    );
  }
}