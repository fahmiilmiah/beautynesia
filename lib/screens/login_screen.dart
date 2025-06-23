import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'register_screen.dart'; // ⬅️ Import layar registrasi

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller untuk menangkap input email dan password dari TextField
  final _email = TextEditingController();
  final _pass = TextEditingController();

  // Variabel untuk menampilkan loading indicator dan pesan error
  bool _loading = false;
  String? _error;

  // Fungsi untuk proses login menggunakan Supabase
  Future<void> _signIn() async {
    setState(() => _loading = true); // Menyalakan indikator loading
    try {
      // Melakukan login dengan email dan password
      await Supabase.instance.client.auth.signInWithPassword(
        email: _email.text.trim(),
        password: _pass.text,
      );
    } on AuthException catch (e) {
      // Menampilkan pesan error jika login gagal
      setState(() => _error = e.message);
    } finally {
      setState(() => _loading = false); // Mematikan indikator loading
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 320, // Lebar container form
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Menampilkan logo aplikasi
              Image.asset('assets/images/logo.jpg', height: 120),

              const SizedBox(height: 24),

              // Input untuk email
              TextField(
                controller: _email,
                decoration: const InputDecoration(label: Text('Email')),
              ),

              const SizedBox(height: 12),

              // Input untuk password
              TextField(
                controller: _pass,
                decoration: const InputDecoration(label: Text('Password')),
                obscureText: true, // Menyembunyikan input password
              ),

              const SizedBox(height: 24),

              // Tombol login
              ElevatedButton(
                onPressed: _loading ? null : _signIn, // Nonaktif saat loading
                child: _loading
                    ? const CircularProgressIndicator() // Loading spinner
                    : const Text('Login'), // Teks tombol login
              ),

              // Menampilkan pesan error jika ada
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // Tombol untuk pindah ke layar registrasi
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                child: const Text("Belum punya akun? Daftar di sini"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
