import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// Fungsi pembaca file JSON statis dari folder assets (Tahap 12)
Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );
  return jsonDecode(jsonString) as Map<String, dynamic>;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardPage(),
    );
  }
}

// ==========================================
// TAHAP 13: StatefulWidget DashboardPage
// ==========================================
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Penggunaan late: menjamin variabel terisi sebelum dipakai di method build()
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    // Diinisialisasi tepat satu kali agar tidak terjadi reload berulang saat rebuild
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learning Dashboard')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          // Kondisi 1: Saat proses baca file JSON masih berlangsung
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Kondisi 2: Jika terjadi kegagalan pembacaan file
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }

          // Kondisi 3: Saat data JSON berhasil di-decode
          final data = snapshot.data!;
          final student = data['student'] as Map<String, dynamic>;
          final courses = data['courses'] as List<dynamic>;

          return Column(
            children: [
              // Identitas Mahasiswa dari objek "student"
              ListTile(
                title: Text(
                  student['name'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(student['nim'] as String),
              ),
              const Divider(height: 1),

              // Daftar Mata Kuliah dari array "courses"
              Expanded(
                child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index] as Map<String, dynamic>;
                    return ListTile(
                      leading: Icon(
                        course['status'] == 'done'
                            ? Icons.check_circle
                            : (course['status'] == 'active'
                                  ? Icons.play_circle_fill
                                  : Icons.schedule),
                        color: course['status'] == 'done'
                            ? Colors.green
                            : (course['status'] == 'active'
                                  ? Colors.blue
                                  : Colors.grey),
                      ),
                      title: Text(course['title'] as String),
                      subtitle: Text(
                        '${course['code']} • ${course['credits']} SKS',
                      ),
                      trailing: Text(
                        (course['status'] as String).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
