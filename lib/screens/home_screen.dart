import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'appointment_form.dart';
import 'appointment_list.dart';

const _treatments = [
  {
    'name': 'Botox Inject',
    'img': 'assets/images/treatments/botox.png',
    'desc': 'Mengurangi kerutan • Rp1.200k',
  },
  {
    'name': 'Chemical Peeling',
    'img': 'assets/images/treatments/peel.png',
    'desc': 'Eksfoliasi kimia • Rp800k',
  },
  {
    'name': 'Facial',
    'img': 'assets/images/treatments/facial.png',
    'desc': 'Membersihkan pori • Rp350k',
  },
  {
    'name': 'LED Light Therapy',
    'img': 'assets/images/treatments/led.png',
    'desc': 'Meredakan inflamasi • Rp600k',
  },
  {
    'name': 'Microneedling',
    'img': 'assets/images/treatments/micro.png',
    'desc': 'Regenerasi kolagen • Rp1.000k',
  },
  {
    'name': 'Prime Exosome',
    'img': 'assets/images/treatments/exosome.png',
    'desc': 'Peremajaan sel • Rp2.000k',
  },
  {
    'name': 'Salmon DNA Inject',
    'img': 'assets/images/treatments/salmon.png',
    'desc': 'Glowing boost • Rp1.800k',
  },
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beautynesia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Supabase.instance.client.auth.signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Image.asset('assets/images/logo.jpg', height: 100),
          const SizedBox(height: 8),
          const Text(
            'Make your skin happy with us',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            'discount 50% for new customer',
            style: TextStyle(fontSize: 13, color: Colors.pinkAccent),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .75,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: _treatments.length,
              itemBuilder: (_, i) => _TreatmentCard(item: _treatments[i]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FilledButton.icon(
              icon: const Icon(Icons.calendar_month),
              label: const Text('Make Appointment'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AppointmentForm()),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'list',
        child: const Icon(Icons.list),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AppointmentList()),
        ),
      ),
    );
  }
}

class _TreatmentCard extends StatelessWidget {
  final Map<String, String> item;
  const _TreatmentCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(item['name']!),
          content: Text(item['desc']!),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 120,
            width: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(item['img']!, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item['name']!,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
