import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url  = 'https://wwwocxvpegnsganyeibh.supabase.co';
  static const String anon = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind3d29jeHZwZWduc2dhbnllaWJoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg3ODYzMTIsImV4cCI6MjA2NDM2MjMxMn0.7iSoucqicmaYPCofR01gkwwe48C_jKWNKEqwh8ZAefg';

  static final SupabaseClient client = Supabase.instance.client;
  
  static Future<void> init() async {
    await Supabase.initialize(
      url: url,
      anonKey: anon,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.password,
      ),
    );
  }
}
