import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/barber_shop_provider.dart';
import '../models/appointment.dart';
import 'package:intl/intl.dart';

class AppointmentsListScreen extends StatelessWidget {
  const AppointmentsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BarberShopProvider>(
      builder: (context, provider, child) {
        final appointments = provider.appointments;

        if (appointments.isEmpty) {
          return Center(
            child: Text(
              'Nenhum agendamento encontrado',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            final barber = provider.barbers.firstWhere(
              (b) => b.id == appointment.barberId,
              orElse: () => throw Exception('Barbeiro não encontrado'),
            );

            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(barber.imageUrl),
                ),
                title: Text(barber.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Serviço: ${appointment.service}'),
                    Text(
                      'Data: ${DateFormat('dd/MM/yyyy HH:mm').format(appointment.dateTime)}',
                    ),
                    Text('Preço: R\$ ${appointment.price.toStringAsFixed(2)}'),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(appointment.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _translateStatus(appointment.status),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: appointment.status == 'pendente'
                    ? PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          switch (value) {
                            case 'edit':
                              _showEditDialog(context, provider, appointment);
                              break;
                            case 'cancel':
                              _showCancelConfirmationDialog(
                                context,
                                provider,
                                appointment,
                              );
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 20),
                                SizedBox(width: 8),
                                Text('Editar'),
                              ],
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'cancel',
                            child: Row(
                              children: [
                                Icon(Icons.cancel, size: 20, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Cancelar'),
                              ],
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
            );
          },
        );
      },
    );
  }

  String _translateStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'PENDENTE';
      case 'confirmed':
        return 'CONFIRMADO';
      case 'cancelled':
        return 'CANCELADO';
      default:
        return status.toUpperCase();
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pendente':
        return Colors.orange.shade600;
      case 'confirmado':
        return Colors.green.shade600;
      case 'cancelado':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  Future<void> _showCancelConfirmationDialog(
    BuildContext context,
    BarberShopProvider provider,
    Appointment appointment,
  ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Agendamento'),
        content: const Text('Tem certeza que deseja cancelar este agendamento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () {
              provider.cancelAppointment(appointment.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Agendamento cancelado com sucesso'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Sim', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    BarberShopProvider provider,
    Appointment appointment,
  ) async {
    final barber = provider.barbers.firstWhere(
      (b) => b.id == appointment.barberId,
    );
    
    DateTime selectedDate = appointment.dateTime;
    String selectedService = appointment.service;
    
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Editar Agendamento'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(barber.imageUrl),
                  ),
                  title: Text(barber.name),
                ),
                const SizedBox(height: 16),
                const Text('Serviço:'),
                DropdownButton<String>(
                  isExpanded: true,
                  value: selectedService,
                  items: [
                    'Corte de Cabelo',
                    'Barba',
                    'Corte + Barba',
                    'Tingimento',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedService = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                const Text('Data e Hora:'),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(selectedDate),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(selectedDate),
                      );
                      
                      if (time != null) {
                        setState(() {
                          selectedDate = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final newAppointment = Appointment(
                  id: appointment.id,
                  barberId: appointment.barberId,
                  userId: appointment.userId,
                  dateTime: selectedDate,
                  service: selectedService,
                  price: appointment.price,
                  status: 'pendente',
                );
                
                provider.updateAppointment(newAppointment);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Agendamento atualizado com sucesso'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
