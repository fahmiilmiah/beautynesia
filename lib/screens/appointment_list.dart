import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/appointment.dart';

class AppointmentList extends StatelessWidget {
  const AppointmentList({super.key});

  @override
  Widget build(BuildContext context) {
    final stream = Supabase.instance.client
        .from('appointments')
        .stream(primaryKey: ['id'])
        .eq('email', Supabase.instance.client.auth.currentUser!.email);

    return Scaffold(
      appBar: AppBar(title: const Text('My Appointments')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: stream,
        builder: (_, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!;
          if (data.isEmpty) return const Center(child: Text('No appointments'));
          return ListView(
            children: data.map((e) {
              final a = Appointment.fromMap(e);
              return ListTile(
                title: Text(a.type),
                subtitle: Text('${a.date.toLocal().toString().split(" ").first}  •  ${a.time}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => Supabase.instance.client.from('appointments').delete().eq('id', a.id),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
