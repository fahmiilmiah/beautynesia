import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_client.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/appointment_edit.dart';
import 'models/appointment.dart'; // jangan lupa import model

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.init();
  runApp(const BeautynesiaApp());
}

class BeautynesiaApp extends StatelessWidget {
  const BeautynesiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beautynesia',
      theme: ThemeData(
        colorSchemeSeed: Colors.pinkAccent,
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      // ✅ Routing edit appointment
      routes: {
        '/edit': (context) {
          final appointment = ModalRoute.of(context)!.settings.arguments as Appointment;
          return AppointmentEdit(appointment: appointment);
        },
      },
      home: const _EntryPoint(),
    );
  }
}

class _EntryPoint extends StatelessWidget {
  const _EntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (_, snapshot) {
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
