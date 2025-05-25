import 'package:flutter/material.dart';
import 'package:shikkha/src/views/ui/home_screen.dart';
import 'package:shikkha/src/views/ui/login_screen.dart';
import 'package:shikkha/src/views/ui/signup_screen.dart';
import 'views/utils/colors.dart';

class ZigoApp extends StatelessWidget {
  final String initialRoute;

  const ZigoApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zigo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
