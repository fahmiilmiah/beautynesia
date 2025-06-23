// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Widget Stateful untuk halaman registrasi
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller untuk mengambil nilai dari TextField
  final _email = TextEditingController();
  final _pass  = TextEditingController();

  // Variabel loading untuk menandai proses pendaftaran sedang berjalan
  bool _loading = false;

  // Menyimpan pesan error jika terjadi kesalahan saat pendaftaran
  String? _error;

  // Fungsi untuk melakukan pendaftaran akun ke Supabase
  Future<void> _signUp() async {
    setState(() => _loading = true); // Menampilkan loading spinner

    try {
      // Proses pendaftaran ke Supabase dengan email dan password
      final res = await Supabase.instance.client.auth.signUp(
        email: _email.text.trim(),
        password: _pass.text,
      );

      // Jika user berhasil dibuat
      if (res.user != null) {
        if (!mounted) return;
        // Menampilkan notifikasi berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check your email to confirm account!')),
        );
        // Kembali ke halaman login
        Navigator.pop(context);
      }
    } on AuthException catch (e) {
      // Tangkap dan tampilkan pesan error dari Supabase
      setState(() => _error = e.message);
    } finally {
      // Hentikan loading setelah proses selesai
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar di bagian atas layar
      appBar: AppBar(title: const Text('Register')),

      // Konten utama halaman register
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Input email
            TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
            ),

            const SizedBox(height: 12),

            // Input password
            TextField(
              controller: _pass,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true, // Menyembunyikan teks password
            ),

            const SizedBox(height: 24),

            // Tombol daftar
            FilledButton(
              onPressed: _loading ? null : _signUp, // Nonaktif jika loading
              child: _loading
                  ? const CircularProgressIndicator() // Tampilkan loading saat proses
                  : const Text('Daftar'),
            ),

            // Menampilkan pesan error jika ada
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
