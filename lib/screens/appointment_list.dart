import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/appointment.dart';

class AppointmentList extends StatefulWidget {
  const AppointmentList({super.key});

  @override
  State<AppointmentList> createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  @override
  Widget build(BuildContext context) {
    final stream = Supabase.instance.client
        .from('appointments')
        .stream(primaryKey: ['id']);

    return Scaffold(
      appBar: AppBar(title: const Text('My Appointments')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: stream,
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          if (data.isEmpty) {
            return const Center(child: Text('No appointments'));
          }

          return ListView(
            children: data.map((e) {
              final a = Appointment.fromMap(e);
              return ListTile(
                title: Text(a.type),
                subtitle: Text('${a.date.toLocal().toString().split(" ").first}  •  ${a.time}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color.fromARGB(255, 226, 123, 123)),
                      onPressed: () async {
                        await Navigator.pushNamed(context, '/edit', arguments: a);
                        setState(() {}); // refresh setelah kembali dari edit
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await Supabase.instance.client
                            .from('appointments')
                            .delete()
                            .eq('id', a.id);
                        setState(() {}); // refresh setelah delete
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
