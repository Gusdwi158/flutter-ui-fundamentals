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
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 46,
                        backgroundImage: AssetImage(
                          'assets/images/profile.jpg',
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        studentName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(studentId),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.phone_android),
                          SizedBox(width: 8),
                          Text('Mobile Programming Student'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          buildStatCard('8', 'Widget', Icons.widgets),
                          buildStatCard('4', 'Layout', Icons.view_quilt),
                          buildStatCard('1', 'State', Icons.sync),
                        ],
                      ),

                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 12),

                      const GreetingCard(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStatCard(String value, String label, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon),
              const SizedBox(height: 6),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}

class GreetingCard extends StatefulWidget {
  const GreetingCard({super.key});

  @override
  State<GreetingCard> createState() => _GreetingCardState();
}

class _GreetingCardState extends State<GreetingCard> {
  final TextEditingController controller = TextEditingController();
  String message = 'Belum ada pesan';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$studentId - $studentName',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Ketik pesan sambutan',
            isDense: true,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            setState(() {
              message = controller.text.trim().isEmpty
                  ? 'Input masih kosong'
                  : controller.text.trim();
            });
          },
          child: const Text('Tampilkan'),
        ),
        const SizedBox(height: 12),
        Text(
          message,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
