import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timetracker/pages/HomeShell.dart';
import 'package:timetracker/services/SettingsService.dart';
import 'package:intl/date_symbol_data_local.dart';
// ADD this import:
import 'package:flutter_localizations/flutter_localizations.dart';

import 'pages/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load dark mode from SharedPreferences
  final bool initiallyDark = await SettingsService.isDarkMode();

  // This notifier holds the current Dark Mode state
  final darkModeNotifier = ValueNotifier<bool>(initiallyDark);

  await initializeDateFormatting('de_DE', null);

  runApp(MyApp(darkModeNotifier: darkModeNotifier));
}

class MyApp extends StatefulWidget {
  final ValueNotifier<bool> darkModeNotifier;
  const MyApp({Key? key, required this.darkModeNotifier}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const LoginPage()),
        GoRoute(
          path: '/home',
          builder: (context, state) =>
              HomeShell(darkModeNotifier: widget.darkModeNotifier),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.darkModeNotifier,
      builder: (context, isDark, _) {
        return MaterialApp.router(
          title: 'WMC Timetracker',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: isDark ? Brightness.dark : Brightness.light,
          ),
          // **Important**: Provide the localization delegates:
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // And specify the supported locales:
          supportedLocales: const [
            Locale('de', 'DE'), // German
            Locale('en', 'US'), // English (optional)
          ],

          routerConfig: _router,
        );
      },
    );
  }
}