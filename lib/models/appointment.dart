class Appointment {
  final String id;
  final String barberId;
  final String userId;
  final DateTime dateTime;
  final String service;
  final double price;
  final String status; // 'pendente', 'confirmado', 'cancelado'

  Appointment({
    required this.id,
    required this.barberId,
    required this.userId,
    required this.dateTime,
    required this.service,
    required this.price,
    required this.status,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      barberId: json['barberId'],
      userId: json['userId'],
      dateTime: DateTime.parse(json['dateTime']),
      service: json['service'],
      price: json['price'].toDouble(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barberId': barberId,
      'userId': userId,
      'dateTime': dateTime.toIso8601String(),
      'service': service,
      'price': price,
      'status': status,
    };
  }
}
