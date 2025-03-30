import 'package:flutter/material.dart';
import 'package:laravel_flutter_client/ClienteScreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cliente Laravel-Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        useMaterial3: true,
      ),
      home: const ApiClientScreen(),
    );
  }
}

