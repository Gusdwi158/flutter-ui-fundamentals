import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

const String studentName = 'I Kadek Agus Dwi Adnyana';
const String studentId = '2415051076';

// Fungsi pembaca JSON sesuai Tahap 12
Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );
  return jsonDecode(jsonString) as Map<String, dynamic>;
}

// Koleksi data topik dari Tahap 11 (tetap dipertahankan untuk tampilan UI)
final List<Map<String, dynamic>> topics = [
  {'title': 'Git & GitHub', 'subtitle': 'Version control', 'done': true},
  {'title': 'Dart Fundamentals', 'subtitle': 'Language basics', 'done': true},
  {
    'title': 'Flutter UI Fundamentals',
    'subtitle': 'Widgets & layout',
    'done': false,
  },
  {
    'title': '$studentId - $studentName',
    'subtitle': 'Pemilik aplikasi',
    'done': false,
  },
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Menguji pembacaan JSON lewat debugPrint sesuai petunjuk lembar kerja
    loadStudentData()
        .then((data) {
          debugPrint('=== HASIL BACA JSON STATIK TAHAP 12 ===');
          debugPrint('Data Mahasiswa: ${data['student']}');
          debugPrint('Total Mata Kuliah: ${(data['courses'] as List).length}');
        })
        .catchError((err) {
          debugPrint('Error membaca JSON: $err');
        });
  }

  @override
  Widget build(BuildContext context) {
    final int completed = topics.where((item) => item['done'] == true).length;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter UI Fundamentals')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Kartu Profil Lengkap
                Card(
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

                        // Statistik Reusable Widget
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

                        // Form Input Sambutan Interaktif
                        const GreetingCard(),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Ringkasan & List Informatif (Tahap 11)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '$completed dari ${topics.length} topik selesai',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: topics.length,
                  itemBuilder: (context, index) {
                    final item = topics[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(
                          item['done'] == true
                              ? Icons.check_circle
                              : Icons.schedule,
                          color: item['done'] == true
                              ? Colors.green
                              : Colors.orange,
                        ),
                        title: Text(item['title'] as String),
                        subtitle: Text(item['subtitle'] as String),
                        trailing: Text(
                          item['done'] == true ? 'Selesai' : 'Belum',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: item['done'] == true
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
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

// Reusable StatefulWidget untuk Greeting Card
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
