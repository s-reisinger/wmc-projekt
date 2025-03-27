import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timetracker/pages/HomeShell.dart';
import 'package:timetracker/services/SettingsService.dart';

// Import your LoginPage (wherever you put it).
import 'pages/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load dark mode from SharedPreferences
  final bool initiallyDark = await SettingsService.isDarkMode();

  // This notifier holds the current Dark Mode state
  final darkModeNotifier = ValueNotifier<bool>(initiallyDark);

  runApp(MyApp(darkModeNotifier: darkModeNotifier));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<bool> darkModeNotifier;
  const MyApp({Key? key, required this.darkModeNotifier}) : super(key: key);

  // Build our GoRouter with two main routes: login and home
  static GoRouter _router(ValueNotifier<bool> darkModeNotifier) => GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/home',
        builder:
            (context, state) => HomeShell(darkModeNotifier: darkModeNotifier),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, isDark, _) {
        return MaterialApp.router(
          title: 'Flutter Login Demo',
          // Change the theme based on isDark
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: isDark ? Brightness.dark : Brightness.light,
          ),
          routerDelegate: _router(darkModeNotifier).routerDelegate,
          routeInformationParser:
              _router(darkModeNotifier).routeInformationParser,
          routeInformationProvider:
              _router(darkModeNotifier).routeInformationProvider,
        );
      },
    );
  }
}
