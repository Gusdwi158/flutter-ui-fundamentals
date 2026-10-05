import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// Fungsi pembaca data JSON statis
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
    return MaterialApp(
      title: 'Learning Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Late initialization: dijamin diinisialisasi pada initState() sebelum build()
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Learning Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: studentFuture,
          builder: (context, snapshot) {
            // State 1: Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // State 2: Error
            if (snapshot.hasError) {
              return Center(
                child: Text('Gagal memuat data: ${snapshot.error}'),
              );
            }

            // State 3: Data Ready
            final data = snapshot.data!;
            final student = data['student'] as Map<String, dynamic>;
            final courses = (data['courses'] as List)
                .map((e) => e as Map<String, dynamic>)
                .toList();

            // Kalkulasi ringkasan dinamis dari JSON
            final int totalCourses = courses.length;
            final int totalCredits = courses.fold<int>(
              0,
              (sum, item) => sum + (item['credits'] as int),
            );
            final int completedCourses = courses
                .where((item) => item['status'] == 'done')
                .length;
            final int progressPercentage = totalCourses == 0
                ? 0
                : ((completedCourses / totalCourses) * 100).toInt();

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==========================================
                  // 1. IDENTITY & PROFILE CARD
                  // ==========================================
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 36,
                            backgroundImage: AssetImage(
                              'assets/images/profile.jpg',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'NIM: ${student['nim']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  student['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  student['prodi'] as String,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ==========================================
                  // 2. SUMMARY ROW (Reusable Widget)
                  // ==========================================
                  Row(
                    children: [
                      buildSummaryCard(
                        title: 'Total Materi',
                        value: '$totalCourses Topik',
                        icon: Icons.menu_book,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      buildSummaryCard(
                        title: 'Total Beban',
                        value: '$totalCredits SKS',
                        icon: Icons.assessment,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      buildSummaryCard(
                        title: 'Progress',
                        value: '$progressPercentage%',
                        icon: Icons.pie_chart,
                        color: Colors.green,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Daftar Materi Pembelajaran',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // ==========================================
                  // 3. EXPANDED LISTVIEW (Courses from JSON)
                  // ==========================================
                  Expanded(
                    child: ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        return buildCourseCard(courses[index]);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ==========================================
  // REUSABLE WIDGET 1: Summary Card
  // ==========================================
  Widget buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // REUSABLE WIDGET 2: Course Item Card
  // ==========================================
  Widget buildCourseCard(Map<String, dynamic> course) {
    final String status = course['status'] as String;
    final bool isDone = status == 'done';
    final bool isActive = status == 'active';

    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (isDone) {
      statusColor = Colors.green;
      statusText = 'Selesai';
      statusIcon = Icons.check_circle;
    } else if (isActive) {
      statusColor = Colors.blue;
      statusText = 'Berjalan';
      statusIcon = Icons.play_circle_fill;
    } else {
      statusColor = Colors.orange;
      statusText = 'Rencana';
      statusIcon = Icons.schedule;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(statusIcon, color: statusColor, size: 28),
        title: Text(
          course['title'] as String,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          '${course['code']} • ${course['credits']} SKS • ${course['lecturer']}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            statusText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ),
      ),
    );
  }
}
