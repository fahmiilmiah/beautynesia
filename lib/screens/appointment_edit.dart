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

  final _types = [
    'Botox Inject',
    'Chemical Peeling',
    'Facial',
    'LED Light Therapy',
    'Microneedling',
    'Prime Exosome',
    'Salmon DNA Inject'
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
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Treatment'),
                items: _types.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _type = val),
                validator: (v) => v == null ? 'Choose one' : null,
              ),
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
