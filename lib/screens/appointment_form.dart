import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentForm extends StatefulWidget {
  const AppointmentForm({super.key});
  @override
  State<AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _complaint = TextEditingController();
  final _date = DateTime.now();
  String? _type;
  TimeOfDay? _time;

  final _types = [
    'Botox Inject',
    'Chemical Peeling',
    'Facial',
    'LED Light Therapy',
    'Microneedling',
    'Prime Exosome',
    'Salmon DNA Inject'
  ];

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _type == null || _time == null) return;
    final client = Supabase.instance.client;
    await client.from('appointments').insert({
      'customer_name': _name.text,
      'email': _email.text,
      'appointment_type': _type,
      'tanggal': DateFormat('yyyy-MM-dd').format(_date),
      'waktu': _time!.format(context),
      'keluhan': _complaint.text,
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment saved')));
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
              TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Name'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'Email'), validator: (v) => v!.isEmpty ? 'Required' : null),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Treatment'),
                items: _types.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _type = val),
                validator: (v) => v == null ? 'Choose one' : null,
              ),
              ListTile(
                title: Text(_time == null ? 'Choose Time' : _time!.format(context)),
                trailing: const Icon(Icons.schedule),
                onTap: () async {
                  final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                  if (picked != null) setState(() => _time = picked);
                },
              ),
              TextFormField(controller: _complaint, maxLines: 3, decoration: const InputDecoration(labelText: 'Complaint / Note')),
              const SizedBox(height: 24),
              FilledButton(onPressed: _save, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
