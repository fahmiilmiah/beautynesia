class Appointment {
  // Properti untuk menyimpan data dari tabel appointments di Supabase
  final String id;            // ID unik untuk setiap appointment
  final String name;          // Nama customer
  final String email;         // Email customer
  final String type;          // Jenis treatment
  final DateTime date;        // Tanggal appointment
  final String time;          // Waktu appointment dalam format “HH:mm”
  final String? complaint;    // Keluhan (opsional)

  // Constructor untuk membuat objek Appointment baru
  Appointment({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    required this.date,
    required this.time,
    this.complaint, // Optional
  });

  // Factory constructor untuk membuat objek Appointment dari Map (misalnya dari Supabase)
  factory Appointment.fromMap(Map<String, dynamic> map) => Appointment(
        id: map['id'],                          // Ambil ID dari kolom 'id'
        name: map['customer_name'],             // Ambil nama dari kolom 'customer_name'
        email: map['email'],                    // Ambil email dari kolom 'email'
        type: map['appointment_type'],          // Ambil tipe dari kolom 'appointment_type'
        date: DateTime.parse(map['tanggal']),   // Ubah string tanggal ke DateTime
        time: map['waktu'],                     // Ambil waktu dari kolom 'waktu'
        complaint: map['keluhan'],              // Ambil keluhan dari kolom 'keluhan' (nullable)
      );

  // Fungsi untuk mengubah objek Appointment menjadi Map (untuk dikirim ke Supabase)
  Map<String, dynamic> toMap() => {
        'customer_name': name,                 // Simpan nama ke kolom 'customer_name'
        'email': email,                        // Simpan email ke kolom 'email'
        'appointment_type': type,              // Simpan tipe ke kolom 'appointment_type'
        'tanggal': date.toIso8601String(),     // Simpan tanggal dalam format ISO string
        'waktu': time,                         // Simpan waktu ke kolom 'waktu'
        'keluhan': complaint,                  // Simpan keluhan ke kolom 'keluhan'
      };
}
