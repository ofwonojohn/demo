class Hotel {
  final String name;
  final String description;
  final String location; // Address field
  final String image;
  final double? rating;
  final double? price;

  Hotel({
    required this.name,
    required this.description,
    required this.location, // Use location field
    required this.image,
    this.rating,
    this.price,
  });
}
