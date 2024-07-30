import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NearbyHotelsScreen extends StatelessWidget {
  final double latitude;
  final double longitude;

  NearbyHotelsScreen({required this.latitude, required this.longitude});

  Future<List<Map<String, dynamic>>> _searchNearbyHotels() async {
    final String apiKey = 'AIzaSyCStLIaMplo3QxZ3ufAFBeGrklwcBfzlYg';
    final String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=5000&type=hotel&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['results']);
    } else {
      throw Exception('Failed to load nearby hotels');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nearby Hotels')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _searchNearbyHotels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No nearby hotels found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final hotel = snapshot.data![index];
                return ListTile(
                  title: Text(hotel['name']),
                  subtitle: Text(hotel['vicinity']),
                );
              },
            );
          }
        },
      ),
    );
  }
}
