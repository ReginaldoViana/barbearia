import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/barber.dart';
import '../models/appointment.dart';
import '../models/user.dart';
import '../constants/barber_avatars.dart';

class BarberShopProvider with ChangeNotifier {
  List<Barber> _barbers = [];
  List<Appointment> _appointments = [];
  Barber? _selectedBarber;
  DateTime? _selectedDate;
  String? _selectedService;
  User? _currentUser;

  List<Barber> get barbers => _barbers;
  List<Appointment> get appointments => _appointments;
  Barber? get selectedBarber => _selectedBarber;
  DateTime? get selectedDate => _selectedDate;
  String? get selectedService => _selectedService;
  User? get currentUser => _currentUser;
  bool get isUserLoggedIn => _currentUser != null;
  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    
    if (userData != null) {
      final savedUser = User.fromJson(jsonDecode(userData));
      if (savedUser.email == email && savedUser.password == password) {
        _currentUser = savedUser;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<void> registerUser(String name, String phone, String email, int age, String password) async {
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      phone: phone,
      email: email,
      age: age,
      password: password,
    );
    
    _currentUser = user;
    
    // Persist user data
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
    
    notifyListeners();
  }

  Future<bool> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    
    if (userData != null) {
      _currentUser = User.fromJson(jsonDecode(userData));
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    _currentUser = null;
    notifyListeners();
  }

  // Setters with notifications
  void setSelectedBarber(Barber barber) {
    _selectedBarber = barber;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSelectedService(String service) {
    _selectedService = service;
    notifyListeners();
  }

  // Methods to manage appointments
  Future<void> createAppointment(Appointment appointment) async {
    // Here you would typically make an API call
    _appointments.add(appointment);
    notifyListeners();
  }

  Future<void> cancelAppointment(String appointmentId) async {
    // Here you would typically make an API call
    _appointments = _appointments.map((appointment) {
      if (appointment.id == appointmentId) {
        return Appointment(
          id: appointment.id,
          barberId: appointment.barberId,
          userId: appointment.userId,
          dateTime: appointment.dateTime,
          service: appointment.service,
          price: appointment.price,
          status: 'cancelled',
        );
      }
      return appointment;
    }).toList();
    notifyListeners();
  }

  Future<void> updateAppointment(Appointment updatedAppointment) async {
    // Here you would typically make an API call
    _appointments = _appointments.map((appointment) {
      if (appointment.id == updatedAppointment.id) {
        return updatedAppointment;
      }
      return appointment;
    }).toList();
    notifyListeners();
  }

    // Method to load barbers
  Future<void> loadBarbers() async {
    _barbers = [
      Barber(
        id: '1',
        name: 'Silvio Carvalho',
        imageUrl: BarberAvatars.barber1,
        specialties: ['Corte Moderno', 'Barba Tradicional', 'Coloração'],
        rating: 4.8,
      ),
      Barber(
        id: '2',
        name: 'Leonardo Santos',
        imageUrl: BarberAvatars.barber2,
        specialties: ['Corte Clássico', 'Barboterapia', 'Hidratação'],
        rating: 4.9,
      ),
      Barber(
        id: '3',
        name: 'Marcos Silva',
        imageUrl: BarberAvatars.barber3,
        specialties: ['Corte Degradê', 'Barba Desenhada', 'Tratamento Capilar'],
        rating: 4.7,
      ),
    ];
    notifyListeners();
  }

  // Method to get available time slots
  List<DateTime> getAvailableTimeSlots(String barberId, DateTime date) {
    final List<DateTime> slots = [];
    final baseDate = DateTime(date.year, date.month, date.day, 9);

    for (int i = 0; i < 16; i++) {
      final slot = baseDate.add(Duration(minutes: 30 * i));
      if (!_isSlotBooked(barberId, slot)) {
        slots.add(slot);
      }
    }

    return slots;
  }

  bool _isSlotBooked(String barberId, DateTime slot) {
    return _appointments.any((appointment) =>
        appointment.barberId == barberId &&
        appointment.dateTime.year == slot.year &&
        appointment.dateTime.month == slot.month &&
        appointment.dateTime.day == slot.day &&
        appointment.dateTime.hour == slot.hour &&
        appointment.dateTime.minute == slot.minute);
  }

  // Initialize with sample data
  void initializeData() {
    loadBarbers();
  }
}
