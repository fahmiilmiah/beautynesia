class Appointment {
  final String id;
  final String name;
  final String email;
  final String type;
  final DateTime date;
  final String time;       // “HH:mm”
  final String? complaint;

  Appointment({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    required this.date,
    required this.time,
    this.complaint,
  });

  factory Appointment.fromMap(Map<String, dynamic> map) => Appointment(
        id: map['id'],
        name: map['customer_name'],
        email: map['email'],
        type: map['appointment_type'],
        date: DateTime.parse(map['tanggal']),
        time: map['waktu'],
        complaint: map['keluhan'],
      );

  Map<String, dynamic> toMap() => {
        'customer_name': name,
        'email': email,
        'appointment_type': type,
        'tanggal': date.toIso8601String(),
        'waktu': time,
        'keluhan': complaint,
      };
}
