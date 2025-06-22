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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset('assets/images/logo.jpg', height: 100)),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Make your skin happy with us',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 4),
              const Center(
                child: Text(
                  'discount 50% for new customer',
                  style: TextStyle(fontSize: 13, color: Colors.pinkAccent),
                ),
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  "Here's Our Treatments",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.35,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _treatments.length,
                itemBuilder: (_, i) => _TreatmentCard(item: _treatments[i]),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                'Customer Reviews',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              const CustomerReviewSection(),
              const SizedBox(height: 24),
              Center(
                child: FilledButton.icon(
                  icon: const Icon(Icons.calendar_month),
                  label: const Text('Make Appointment'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AppointmentForm()),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
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
            height: 110,
            width: 110,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(item['img']!, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item['name']!,
            style: const TextStyle(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class CustomerReviewSection extends StatelessWidget {
  const CustomerReviewSection({super.key});

  final List<Map<String, dynamic>> reviews = const [
    {
      'name': 'Aulia',
      'photoUrl': 'assets/images/customers/Aulia.jpeg',
      'rating': 5,
      'comment': 'Pelayanannya ramah dan hasilnya memuaskan!'
    },
    {
      'name': 'Lahiliya',
      'photoUrl': 'assets/images/customers/Lahiliya.jpeg',
      'rating': 4,
      'comment': 'Salon bersih dan cepat tanggap, recommended!'
    },
    {
      'name': 'Lina',
      'photoUrl': 'assets/images/customers/Lina.jpeg',
      'rating': 5,
      'comment': 'Stylist-nya ngerti banget kebutuhan aku!'
    },
    {
      'name': 'Nana',
      'photoUrl': 'assets/images/customers/Nana.jpeg',
      'rating': 4,
      'comment': 'Mantap, pasti balik lagi!'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: reviews.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Container(
                width: 160,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(review['photoUrl']),
                      radius: 28,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      review['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < review['rating'] ? Icons.star : Icons.star_border,
                          size: 14,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      review['comment'],
                      style: const TextStyle(fontSize: 11),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
