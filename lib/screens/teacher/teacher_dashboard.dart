import 'package:flutter/material.dart';
import '../auth/login_screen.dart';
import 'generate_qr_screen.dart';
import 'noise_monitor_screen.dart';
import 'attendance_list_screen.dart';

import 'attendance_list_screen.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _currentIndex = 0;

  final List<Map<String, String>> _classes = [
    {'id': 'L01', 'name': 'Lập trình Di động (Flutter)', 'room': 'B-302', 'students': '45'},
    {'id': 'L02', 'name': 'Quản lý Dự án CNTT', 'room': 'A-105', 'students': '50'},
    {'id': 'L03', 'name': 'CSDL Nâng cao', 'room': 'Lab-02', 'students': '38'},
  ];

  // Tab 1: Danh sách lớp học
  Widget _buildClassListTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Card(
          color: Colors.teal.shade50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.class_, color: Colors.white),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Học kỳ 1 - 2026', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Chọn lớp để tạo mã QR hoặc duyệt vị trí', style: TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Lớp học đang giảng dạy', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ..._classes.map((cls) => _buildClassCard(cls)).toList(),
      ],
    );
  }

  Widget _buildClassCard(Map<String, String> cls) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(cls['name']!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.teal.shade100, borderRadius: BorderRadius.circular(6)),
                  child: Text('Phòng ${cls['room']}', style: const TextStyle(fontSize: 11, color: Colors.teal, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text('Sĩ số: ${cls['students']} sinh viên', style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const Divider(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AttendanceListScreen(
                            classId: cls['id']!,
                            className: cls['name']!
                          )
                        ),
                      );
                    },
                    icon: const Icon(Icons.location_on_outlined, size: 16),
                    label: const Text('Duyệt Vị Trí', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => TeacherQrScreen(classId: cls['id']!)),
                      );
                    },
                    icon: const Icon(Icons.qr_code, size: 16),
                    label: const Text('Tạo QR (60s)', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Tab 2: Giám sát tiếng ồn
  Widget _buildNoiseTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.graphic_eq, size: 80, color: Colors.teal),
            const SizedBox(height: 16),
            const Text(
              'Giám Sát Độ Ồn Lớp Học',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kiểm tra độ ồn thời gian thực trong giờ kiểm tra hoặc học tập',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const NoiseMonitorScreen()));
              },
              icon: const Icon(Icons.mic),
              label: const Text('Bật máy đo Decibel (dB)'),
            ),
          ],
        ),
      ),
    );
  }

  // Tab 3: Thông tin tài khoản Giảng viên
  Widget _buildProfileTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 10),
        const Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.teal,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              SizedBox(height: 12),
              Text('GV. Trần Phạm Phương Trinh', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('Khoa Công Nghệ Thông Tin', style: TextStyle(color: Colors.black54)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: const [
              ListTile(
                leading: Icon(Icons.badge_outlined, color: Colors.teal),
                title: Text('Mã giảng viên'),
                trailing: Text('GV2380602336', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.email_outlined, color: Colors.teal),
                title: Text('Email'),
                trailing: Text('trinh.tpp@hutech.edu.vn', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.verified_user_outlined, color: Colors.teal),
                title: Text('Vai trò'),
                trailing: Text('Giảng viên bộ môn', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
            icon: const Icon(Icons.logout),
            label: const Text('Đăng xuất'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [_buildClassListTab(), _buildNoiseTab(), _buildProfileTab()];
    final List<String> titles = ['Danh sách lớp', 'Đo tiếng ồn', 'Tài khoản'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.class_outlined), activeIcon: Icon(Icons.class_), label: 'Lớp học'),
          BottomNavigationBarItem(icon: Icon(Icons.mic_none), activeIcon: Icon(Icons.mic), label: 'Đo tiếng ồn'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Tài khoản'),
        ],
      ),
    );
  }
}