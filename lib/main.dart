import 'package:flutter/material.dart';
import 'package:shikkha/src/app.dart';
import 'src/views/ui/login_screen.dart';
import 'src/views/ui/signup_screen.dart';
import 'src/views/ui/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://wdntbeghhwmjeabuiuaz.supabase.co',
    anonKey:  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndkbnRiZWdoaHdtamVhYnVpdWF6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc3NDQ3NjEsImV4cCI6MjA2MzMyMDc2MX0.N229oF65Zwws2_810qN7wAnyKHopGXJYtZXBbF3yx9k',
  );

  final session = Supabase.instance.client.auth.currentSession;

  runApp(ZigoApp(initialRoute: session != null ? '/home' : '/login'));
}

