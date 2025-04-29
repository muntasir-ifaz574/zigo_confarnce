import 'package:flutter/material.dart';
import 'package:shikkha/src/views/ui/home_screen.dart';
import 'views/utils/colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF2C2C6A, colorMap)
      ),
      home: const HomeScreen(),
    );
  }
}
