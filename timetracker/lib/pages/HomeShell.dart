import 'package:flutter/material.dart';

import 'ListPage.dart';
import 'MainPage.dart';
import 'SettingsPage.dart';

class HomeShell extends StatefulWidget {
  final ValueNotifier<bool> darkModeNotifier;
  const HomeShell({Key? key, required this.darkModeNotifier}) : super(key: key);

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 1; // default to the "Main" tab in the middle

  late final List<Widget> _pages = [
    const ListPage(),
    const TimeTrackingPage(),
    SettingsPage(darkModeNotifier: widget.darkModeNotifier),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Übersicht',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Aufzeichnung',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Einstellungen',
          ),
        ],
      ),
    );
  }
}