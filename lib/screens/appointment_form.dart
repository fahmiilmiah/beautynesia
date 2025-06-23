import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentForm extends StatefulWidget {
  const AppointmentForm({super.key});

  @override
  State<AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  // Key untuk validasi form
  final _formKey = GlobalKey<FormState>();

  // Controller input text
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _complaint = TextEditingController();

  // Nilai default tanggal hari ini
  final _date = DateTime.now();

  // Variabel untuk menyimpan pilihan treatment & waktu
  String? _type;
  TimeOfDay? _time;

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

  // Fungsi untuk menyimpan data appointment ke Supabase
  Future<void> _save() async {
    // Validasi form, pastikan semua diisi
    if (!_formKey.currentState!.validate() || _type == null || _time == null) return;

    final client = Supabase.instance.client;

    // Kirim data ke Supabase
    await client.from('appointments').insert({
      'customer_name': _name.text,
      'email': _email.text,
      'appointment_type': _type,
      'tanggal': DateFormat('yyyy-MM-dd').format(_date),
      'waktu': _time!.format(context),
      'keluhan': _complaint.text,
    });

    if (!mounted) return;

    // Tampilkan notifikasi sukses
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Appointment saved')),
    );

    // Kembali ke halaman sebelumnya
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Input Nama
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              // Input Email
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              // Pemilihan Treatment
              ListTile(
                title: Text(_type ?? 'Pilih Treatment'),
                trailing: const Icon(Icons.arrow_drop_down),
                onTap: () {
                  // Tampilkan dialog pilihan treatment
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
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
                                  // Simpan nama treatment
                                  setState(() => _type = t['name']);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 8),
              // Pilih Waktu
              ListTile(
                title: Text(_time == null ? 'Pilih Waktu' : _time!.format(context)),
                trailing: const Icon(Icons.schedule),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) setState(() => _time = picked);
                },
              ),
              // Input Keluhan atau Catatan
              TextFormField(
                controller: _complaint,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Keluhan / Catatan'),
              ),
              const SizedBox(height: 24),
              // Tombol Simpan
              FilledButton(
                onPressed: _save,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
