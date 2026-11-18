import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:3iii_copilot/l10n/app_localizations.dart';
import 'weather_dashboard.dart';

void main() => runApp(const ThreeIiiCopilotApp());

class ThreeIiiCopilotApp extends StatelessWidget {
  const ThreeIiiCopilotApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: '3iii-Copilot',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF07111F),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF69D8D0),
            brightness: Brightness.dark,
          ),
          fontFamily: 'Roboto',
        ),
        localeListResolutionCallback: (locales, supported) {
          final deviceLocale = locales?.first;
          if (deviceLocale?.languageCode == 'th') return const Locale('th');
          return const Locale('en');
        },
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const WeatherDashboard(),
      );
}
