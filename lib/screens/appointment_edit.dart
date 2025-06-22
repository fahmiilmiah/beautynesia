import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/appointment.dart';

class AppointmentEdit extends StatefulWidget {
  final Appointment appointment;
  const AppointmentEdit({super.key, required this.appointment});

  @override
  State<AppointmentEdit> createState() => _AppointmentEditState();
}

class _AppointmentEditState extends State<AppointmentEdit> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _email;
  late TextEditingController _complaint;
  late DateTime _date;
  late String? _type;
  late TimeOfDay? _time;

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

  Future<void> _update() async {
    if (!_formKey.currentState!.validate() || _type == null || _time == null) return;
    final client = Supabase.instance.client;
    await client.from('appointments').update({
      'customer_name': _name.text,
      'email': _email.text,
      'appointment_type': _type,
      'tanggal': DateFormat('yyyy-MM-dd').format(_date),
      'waktu': _time!.format(context),
      'keluhan': _complaint.text,
    }).eq('id', widget.appointment.id);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment updated')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Name'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'Email'), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 8),
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
                                setState(() => _type = t['name']);
                                Navigator.pop(context);
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
              ListTile(
                title: Text(_time == null ? 'Choose Time' : _time!.format(context)),
                trailing: const Icon(Icons.schedule),
                onTap: () async {
                  final picked = await showTimePicker(context: context, initialTime: _time!);
                  if (picked != null) setState(() => _time = picked);
                },
              ),
              TextFormField(controller: _complaint, maxLines: 3, decoration: const InputDecoration(labelText: 'Complaint / Note')),
              const SizedBox(height: 24),
              FilledButton(onPressed: _update, child: const Text('Update')),
            ],
          ),
        ),
      ),
    );
  }
}
