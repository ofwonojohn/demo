import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'hotel.dart';

class HotelDetailPage extends StatelessWidget {
  final Hotel hotel;

  const HotelDetailPage({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(hotel.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(hotel.image, fit: BoxFit.cover, width: double.infinity, height: 200),
            SizedBox(height: 16),
            Text(hotel.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(hotel.description),
            SizedBox(height: 16),
            FutureBuilder<double>(
              future: _calculateDistance(hotel.location),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error calculating distance: ${snapshot.error}');
                } else if (snapshot.data == null) {
                  return Text('Could not calculate distance');
                } else {
                  return Text('Distance: ${snapshot.data?.toStringAsFixed(2)} km');
                }
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _searchNearbyHotels(context, hotel.location);
                } catch (e) {
                  print('Error searching nearby hotels: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error searching nearby hotels: $e')),
                  );
                }
              },
              child: Text('Search Nearby Hotels'),
            ),
          ],
        ),
      ),
    );
  }

  Future<double> _calculateDistance(String address) async {
    try {
      if (address.isEmpty) {
        throw Exception('Address is empty');
      }

      print('Calculating distance for address: $address');
      List<Location> locations = await locationFromAddress(address);
      if (locations.isEmpty) {
        throw Exception('No locations found for the address');
      }

      Location location = locations.first;
      print('Geocoded address to: ${location.latitude}, ${location.longitude}');
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        location.latitude,
        location.longitude,
      );
      return distanceInMeters / 1000; // Convert to kilometers
    } catch (e) {
      print('Error calculating distance: $e');
      throw e;
    }
  }

  Future<void> _searchNearbyHotels(BuildContext context, String address) async {
    try {
      if (address.isEmpty) {
        throw Exception('Address is empty');
      }

      print('Searching nearby hotels for address: $address');
      final CollectionReference nearbyHotels = FirebaseFirestore.instance.collection('nearby');

      QuerySnapshot querySnapshot = await nearbyHotels.get();
      if (querySnapshot.docs.isEmpty) {
        throw Exception('No nearby hotels found');
      }

      List<QueryDocumentSnapshot> results = querySnapshot.docs;
      print('Found ${results.length} nearby hotels');

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Nearby Hotels'),
          content: SingleChildScrollView(
            child: ListBody(
              children: results.map((hotel) {
                var hotelData = hotel.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(hotelData['name']),
                  subtitle: Text(hotelData['vicinity']),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error searching nearby hotels: $e');
      throw e;
    }
  }
}
