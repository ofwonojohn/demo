import 'package:flutter/material.dart';
import 'package:homeapp/screens/pages/hotels/hotelscreen.dart';
import 'package:homeapp/screens/pages/resultpage.dart';

class HomePage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<HomePage> {
  // List of preferences
  final List<String> _preferences = [
    'Beach',
    'Mountain',
    'City',
    'Countryside',
    'Historical',
    'Adventure',
  ];

  // Map to track selected preferences
  final Map<String, bool> _selectedPreferences = {};

  @override
  void initState() {
    super.initState();
    // Initialize selected preferences to false
    for (var pref in _preferences) {
      _selectedPreferences[pref] = false;
    }
  }

  void _searchPreferences() {
    final selectedPrefs = _selectedPreferences.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsPage(preferences: selectedPrefs, preference: '',),
      ),
    );
  }

  void _navigateToHotels() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelScreen(), // Navigate to the hotel screen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Your Preferences')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: _preferences.map((pref) {
                  return CheckboxListTile(
                    title: Text(pref),
                    value: _selectedPreferences[pref],
                    onChanged: (bool? value) {
                      setState(() {
                        _selectedPreferences[pref] = value!;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchPreferences,
              child: Text('Continue'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToHotels,
              child: Text('Hotels'),
            ),
          ],
        ),
      ),
    );
  }
}
