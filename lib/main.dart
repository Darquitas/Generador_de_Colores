import 'package:flutter/material.dart';
import 'colorsPage.dart';
import 'profilePage.dart';
import 'homePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/detail': (context) => const PeopleScreen(),
        '/profile': (context) => const UserScreen(),
      },
    );
  }
}
