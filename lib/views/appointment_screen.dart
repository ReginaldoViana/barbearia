import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../controllers/barber_shop_provider.dart';
import '../models/appointment.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final services = ['Corte de Cabelo', 'Barba', 'Coloração', 'Barboterapia', 'Tratamento Facial'];
  final prices = {
    'Corte de Cabelo': 30.0,
    'Barba': 20.0,
    'Coloração': 50.0,
    'Barboterapia': 25.0,
    'Tratamento Facial': 40.0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar Horário'),
      ),
      body: Consumer<BarberShopProvider>(
        builder: (context, provider, child) {
          final barber = provider.selectedBarber;
          if (barber == null) {
            return const Center(
              child: Text('Por favor, selecione um barbeiro primeiro'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(barber.imageUrl),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          barber.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(barber.rating.toString()),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Service Selection
                Text(
                  'Selecione o Serviço',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Theme.of(context).colorScheme.primary),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: provider.selectedService,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      border: InputBorder.none,
                    ),
                    icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.primary),
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    dropdownColor: Theme.of(context).colorScheme.surface,
                    items: services.map((String service) {
                      return DropdownMenuItem<String>(
                        value: service,
                        child: Text('$service (R\$ ${prices[service]?.toStringAsFixed(2)})'),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        provider.setSelectedService(newValue);
                      }
                    },
                    hint: Text('Escolha um serviço',
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Selecione a Data',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                  onDateChanged: (date) {
                    provider.setSelectedDate(date);
                  },
                ),
                const SizedBox(height: 24),
                if (provider.selectedDate != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Horários Disponíveis',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Theme.of(context).colorScheme.primary),
                        ),
                        child: DropdownButtonFormField<DateTime>(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                            border: InputBorder.none,
                          ),
                          icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.primary),
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          items: provider
                              .getAvailableTimeSlots(barber.id, provider.selectedDate!)
                              .map((timeSlot) {
                            return DropdownMenuItem<DateTime>(
                              value: timeSlot,
                              child: Text(DateFormat('HH:mm').format(timeSlot)),
                            );
                          }).toList(),
                          onChanged: (DateTime? newValue) {
                            if (newValue != null && provider.selectedService != null) {
                              _bookAppointment(context, provider, newValue);
                            }
                          },
                          hint: Text('Escolha um horário',
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _bookAppointment(
      BuildContext context, BarberShopProvider provider, DateTime timeSlot) {
    final appointment = Appointment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      barberId: provider.selectedBarber!.id,
      userId: 'user123', // Em um app real, isso viria da autenticação
      dateTime: timeSlot,
      service: provider.selectedService!,
      price: prices[provider.selectedService!]!,
      status: 'pendente',
    );

    provider.createAppointment(appointment).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agendamento realizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao realizar agendamento: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}
