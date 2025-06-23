// Import package Supabase khusus Flutter
import 'package:supabase_flutter/supabase_flutter.dart';

// Kelas konfigurasi Supabase untuk menginisialisasi koneksi ke backend Supabase
class SupabaseConfig {
  // URL project Supabase kamu (bisa dilihat dari dashboard Supabase)
  static const String url  = 'https://wwwocxvpegnsganyeibh.supabase.co';

  // Kunci anon (public API key) dari project Supabase
  static const String anon = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind3d29jeHZwZWduc2dhbnllaWJoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg3ODYzMTIsImV4cCI6MjA2NDM2MjMxMn0.7iSoucqicmaYPCofR01gkwwe48C_jKWNKEqwh8ZAefg';

  // Objek SupabaseClient yang digunakan untuk melakukan operasi (select, insert, auth, dsb)
  static final SupabaseClient client = Supabase.instance.client;

  // Fungsi async untuk menginisialisasi koneksi ke Supabase
  static Future<void> init() async {
    await Supabase.initialize(
      url: url,             // Alamat project Supabase
      anonKey: anon,        // Kunci public agar bisa akses project
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce, // Tipe otentikasi: aman untuk Flutter
      ),
    );
  }
}

