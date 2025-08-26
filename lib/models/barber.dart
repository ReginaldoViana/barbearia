class Barber {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> specialties;
  final double rating;

  Barber({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.specialties,
    required this.rating,
  });

  factory Barber.fromJson(Map<String, dynamic> json) {
    return Barber(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      specialties: List<String>.from(json['specialties']),
      rating: json['rating'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'specialties': specialties,
      'rating': rating,
    };
  }
}
