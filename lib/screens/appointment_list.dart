import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/appointment.dart'; // Import model Appointment agar bisa mengonversi data dari Supabase

// Widget utama untuk menampilkan daftar appointment
class AppointmentList extends StatefulWidget {
  const AppointmentList({super.key});

  @override
  State<AppointmentList> createState() => _AppointmentListState();
}

// State class dari AppointmentList
class _AppointmentListState extends State<AppointmentList> {
  @override
  Widget build(BuildContext context) {
    // Mengambil stream data dari tabel 'appointments' di Supabase
    final stream = Supabase.instance.client
        .from('appointments') // nama tabel di Supabase
        .stream(primaryKey: ['id']); // stream berdasarkan primary key 'id'

    return Scaffold(
      appBar: AppBar(title: const Text('My Appointments')), // Judul di AppBar
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: stream, // menggunakan stream dari Supabase
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            // Jika data belum tersedia, tampilkan loading indicator
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          if (data.isEmpty) {
            // Jika data kosong, tampilkan pesan
            return const Center(child: Text('No appointments'));
          }

          // Jika data tersedia, tampilkan dalam ListView
          return ListView(
            children: data.map((e) {
              // Konversi Map dari Supabase ke objek Appointment
              final a = Appointment.fromMap(e);
              return ListTile(
                title: Text(a.type), // Menampilkan tipe appointment (contoh: "Facial", "Haircut", dsb)
                subtitle: Text(
                  '${a.date.toLocal().toString().split(" ").first}  •  ${a.time}'
                ), // Menampilkan tanggal dan jam
                trailing: Row(
                  mainAxisSize: MainAxisSize.min, // Supaya trailing tidak terlalu lebar
                  children: [
                    // Tombol Edit
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color.fromARGB(255, 226, 123, 123)),
                      onPressed: () async {
                        // Navigasi ke halaman edit dengan membawa data appointment sebagai argumen
                        await Navigator.pushNamed(context, '/edit', arguments: a);
                        setState(() {}); // Refresh UI setelah kembali
                      },
                    ),
                    // Tombol Delete
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        // Hapus appointment berdasarkan id
                        await Supabase.instance.client
                            .from('appointments')
                            .delete()
                            .eq('id', a.id);
                        setState(() {}); // Refresh UI setelah menghapus
                      },
                    ),
                  ],
                ),
              );
            }).toList(), // Konversi hasil map menjadi List<Widget>
          );
        },
      ),
    );
  }
}
