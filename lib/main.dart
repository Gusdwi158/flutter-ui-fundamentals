import 'package:flutter/material.dart';

const String studentName = 'I Kadek Agus Dwi Adnyana';
const String studentId = '2415051076';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter UI Fundamentals')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$studentId - $studentName'),
              const SizedBox(height: 12),
              const Text('Belajar Widget Tree'),
              const SizedBox(height: 12),
              const Icon(Icons.widgets, size: 48),
            ],
          ),
        ),
      ),
    );
  }
}
