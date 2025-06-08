import 'package:flutter/material.dart';
import 'config/supabase_client.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

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
      builder: (_, snap) {
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null) return const HomeScreen();
        return const LoginScreen();
      },
    );
  }
}
