import 'package:flutter/material.dart';
import 'package:laravel_flutter_client/ClienteScreen.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // await dotenv.load(fileName: ".env");
  print("init");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cliente Laravel-Flutter',
      debugShowCheckedModeBanner: false, // Add this line
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        useMaterial3: true,
      ),
      home: const ApiClientScreen(),
    );
  }
}

