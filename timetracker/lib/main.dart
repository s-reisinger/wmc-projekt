import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timetracker/pages/HomeShell.dart';
import 'package:timetracker/services/SettingsService.dart';
import 'package:intl/date_symbol_data_local.dart';
//import 'package:flutter/flutter_localizations.dart';

// Import your LoginPage (wherever you put it).
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
          title: 'Flutter Login Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: isDark ? Brightness.dark : Brightness.light,
          ),
          routerConfig: _router, // use routerConfig instead of breaking it up
        );
      },
    );
  }
}

