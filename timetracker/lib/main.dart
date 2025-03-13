import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import your LoginPage (wherever you put it).
import 'pages/LoginPage.dart';

// A simple placeholder for the "home" page
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(
        child: Text('Welcome to the Home Page!'),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // 1) Define your GoRouter, listing the routes
  static final GoRouter _router = GoRouter(
    routes: [
      // The login route at "/"
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginPage(),
      ),
      // The home route at "/home"
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    // 2) Use MaterialApp.router to wire up go_router
    return MaterialApp.router(
      title: 'Flutter Login Demo',
      routerDelegate: _router.routerDelegate,
      routeInformationParser: _router.routeInformationParser,
      routeInformationProvider: _router.routeInformationProvider,
      // Optional theme or themeMode
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
