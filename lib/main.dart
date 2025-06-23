import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_client.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/appointment_edit.dart';
import 'models/appointment.dart'; // Import model Appointment

// Fungsi utama aplikasi (entry point)
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Inisialisasi Flutter sebelum menjalankan kode async
  await SupabaseConfig.init(); // Inisialisasi koneksi Supabase dari file config
  runApp(const BeautynesiaApp()); // Menjalankan aplikasi utama
}

// Widget utama aplikasi
class BeautynesiaApp extends StatelessWidget {
  const BeautynesiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beautynesia', // Judul aplikasi
      theme: ThemeData(
        colorSchemeSeed: Colors.pinkAccent, // Warna utama aplikasi
        fontFamily: 'Poppins', // Font default
        useMaterial3: true, // Menggunakan Material 3 design
      ),

      // Routing halaman edit appointment
      routes: {
        '/edit': (context) {
          // Mengambil argumen appointment yang dikirim dari halaman sebelumnya
          final appointment = ModalRoute.of(context)!.settings.arguments as Appointment;
          return AppointmentEdit(appointment: appointment); // Menampilkan halaman edit
        },
      },

      home: const _EntryPoint(), // Menentukan halaman pertama saat aplikasi dibuka
    );
  }
}

// Widget yang menentukan apakah pengguna langsung masuk ke HomeScreen atau LoginScreen
class _EntryPoint extends StatelessWidget {
  const _EntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange, // Mendengarkan perubahan status login
      builder: (_, snapshot) {
        final session = Supabase.instance.client.auth.currentSession; // Cek apakah ada session aktif

        if (session != null) {
          return const HomeScreen(); // Jika sudah login, arahkan ke HomeScreen
        }

        return const LoginScreen(); // Jika belum login, arahkan ke LoginScreen
      },
    );
  }
}
