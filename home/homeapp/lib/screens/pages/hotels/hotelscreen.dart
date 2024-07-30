import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeapp/screens/pages/hotels/hoteldetail.dart';
import 'hotel.dart';

//AIzaSyCStLIaMplo3QxZ3ufAFBeGrklwcBfzlYg

class HotelScreen extends StatefulWidget {
  @override
  _HotelScreenState createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  List<Hotel> hotels = [];

  @override
  void initState() {
    super.initState();
    fetchHotels();
  }
  //AIzaSyCStLIaMplo3QxZ3ufAFBeGrklwcBfzlYg

  Future<void> fetchHotels() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('hotels').get();

      List<Hotel> fetchedHotels = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        Hotel hotel = Hotel(
          name: data['name'] ?? 'Unknown Name',
          description: data['description'] ?? 'No Description',
          location: data['location'] ?? 'No Address', // Use location field
          image: data['image'] ?? 'https://via.placeholder.com/150',
          rating: data['rating']?.toDouble(),
          price: data['price']?.toDouble(),
        );
        fetchedHotels.add(hotel);
      }

      setState(() {
        hotels = fetchedHotels;
      });
    } catch (e) {
      print('Error fetching hotels: $e');
      // Handle error
    }
  }

  void _navigateToDetails(Hotel hotel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelDetailPage(hotel: hotel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hotels')),
      body: ListView.builder(
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          Hotel hotel = hotels[index];
          return ListTile(
            leading: Image.network(hotel.image, fit: BoxFit.cover, width: 50, height: 50),
            title: Text(hotel.name),
            subtitle: Text(hotel.location), // Display location (address)
            onTap: () => _navigateToDetails(hotel),
          );
        },
      ),
    );
  }
}
