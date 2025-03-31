import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/SettingsService.dart';

class SettingsPage extends StatefulWidget {
  final ValueNotifier<bool> darkModeNotifier;

  const SettingsPage({Key? key, required this.darkModeNotifier})
    : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _displayNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // Load display name from SharedPreferences
    String name = await SettingsService.getDisplayName();
    setState(() {
      _displayNameController.text = name;
    });
  }

  // Toggle dark mode
  void _onDarkModeChanged(bool value) async {
    // 1) Update the ValueNotifier to rebuild the app's theme
    widget.darkModeNotifier.value = value;
    // 2) Save the preference
    await SettingsService.setDarkMode(value);
  }

  // Save display name whenever user finishes editing
  void _onSaveDisplayName() async {
    final name = _displayNameController.text.trim();
    await SettingsService.setDisplayName(name);
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = widget.darkModeNotifier.value;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: isDarkMode,
            onChanged: _onDarkModeChanged,
          ),
          const Divider(),
          TextField(
            controller: _displayNameController,
            decoration: const InputDecoration(labelText: 'Display Name'),
            onEditingComplete: _onSaveDisplayName,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _onSaveDisplayName,
            child: const Text('Save Display Name'),
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
