import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal
import 'package:supabase_flutter/supabase_flutter.dart'; // Koneksi ke Supabase
import '../models/appointment.dart'; // Import model Appointment

// Widget halaman untuk mengedit data appointment
class AppointmentEdit extends StatefulWidget {
  final Appointment appointment; // Data appointment yang akan diedit
  const AppointmentEdit({super.key, required this.appointment});

  @override
  State<AppointmentEdit> createState() => _AppointmentEditState();
}

class _AppointmentEditState extends State<AppointmentEdit> {
  final _formKey = GlobalKey<FormState>(); // Key untuk validasi form

  // Controller untuk input form
  late TextEditingController _name;
  late TextEditingController _email;
  late TextEditingController _complaint;

  // Variabel data yang akan diedit
  late DateTime _date;
  late String? _type;
  late TimeOfDay? _time;

  // Daftar treatment yang tersedia
  final List<Map<String, String>> _types = [
    {
      'name': 'Botox Inject',
      'img': 'assets/images/treatments/botox.png',
      'desc': 'Mengurangi kerutan di wajah',
      'price': 'Rp1.200k'
    },
    {
      'name': 'Chemical Peeling',
      'img': 'assets/images/treatments/peel.png',
      'desc': 'Mengangkat sel kulit mati',
      'price': 'Rp850k'
    },
    {
      'name': 'Facial',
      'img': 'assets/images/treatments/facial.png',
      'desc': 'Membersihkan dan melembapkan kulit',
      'price': 'Rp500k'
    },
    {
      'name': 'LED Light Therapy',
      'img': 'assets/images/treatments/led.png',
      'desc': 'Terapi cahaya untuk jerawat dan kulit kusam',
      'price': 'Rp600k'
    },
    {
      'name': 'Microneedling',
      'img': 'assets/images/treatments/micro.png',
      'desc': 'Peremajaan kulit dengan jarum mikro',
      'price': 'Rp1.400k'
    },
    {
      'name': 'Prime Exosome',
      'img': 'assets/images/treatments/exosome.png',
      'desc': 'Perawatan kulit dengan sel punca',
      'price': 'Rp2.000k'
    },
    {
      'name': 'Salmon DNA Inject',
      'img': 'assets/images/treatments/salmon.png',
      'desc': 'Regenerasi kulit dengan DNA ikan salmon',
      'price': 'Rp1.800k'
    },
  ];

  @override
  void initState() {
    super.initState();
    final a = widget.appointment;

    // Inisialisasi nilai input dengan data appointment yang diterima
    _name = TextEditingController(text: a.name);
    _email = TextEditingController(text: a.email);
    _complaint = TextEditingController(text: a.complaint);
    _type = a.type;
    _date = a.date;
    _time = TimeOfDay(
      hour: int.parse(a.time.split(':')[0]),
      minute: int.parse(a.time.split(':')[1]),
    );
  }

  // Fungsi untuk menyimpan perubahan ke Supabase
  Future<void> _update() async {
    if (!_formKey.currentState!.validate() || _type == null || _time == null) return;

    final client = Supabase.instance.client;

    // Kirim data ke tabel appointments berdasarkan id
    await client.from('appointments').update({
      'customer_name': _name.text,
      'email': _email.text,
      'appointment_type': _type,
      'tanggal': DateFormat('yyyy-MM-dd').format(_date),
      'waktu': _time!.format(context),
      'keluhan': _complaint.text,
    }).eq('id', widget.appointment.id);

    if (!mounted) return;

    // Tampilkan notifikasi berhasil
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Appointment updated')),
    );

    // Kembali ke halaman sebelumnya
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Appointment')), // Judul halaman
      body: Padding(
        padding: const EdgeInsets.all(16), // Jarak dari tepi layar
        child: Form(
          key: _formKey, // Form validation
          child: ListView(
            children: [
              // Input nama customer
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),

              // Input email customer
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 8), // Jarak antar input

              // Pilih treatment
              ListTile(
                title: Text(_type ?? 'Pilih Treatment'),
                trailing: const Icon(Icons.arrow_drop_down),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Pilih Treatment'),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: _types.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (_, index) {
                            final t = _types[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  t['img']!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                t['name']!,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('${t['desc']} • ${t['price']}'),
                              onTap: () {
                                setState(() => _type = t['name']); // Simpan pilihan
                                Navigator.pop(context); // Tutup dialog
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 8),

              // Pilih jam
              ListTile(
                title: Text(_time == null ? 'Pilih Waktu' : _time!.format(context)),
                trailing: const Icon(Icons.schedule),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _time!,
                  );
                  if (picked != null) setState(() => _time = picked); // Simpan waktu baru
                },
              ),

              // Input keluhan
              TextFormField(
                controller: _complaint,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Keluhan / Catatan'),
              ),

              const SizedBox(height: 24),

              // Tombol update
              FilledButton(
                onPressed: _update,
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
