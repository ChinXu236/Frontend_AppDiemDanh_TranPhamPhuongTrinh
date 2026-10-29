import 'package:flutter/material.dart';
import '../auth/login_screen.dart';
import 'scan_attendance_screen.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _attendanceHistory = [
    {'subject': 'Lập trình Di động ', 'date': '29/10/2026 08:05', 'status': 'Hợp lệ', 'distance': '12m'},
    {'subject': 'Quản lý Dự án CNTT', 'date': '28/10/2026 13:30', 'status': 'Hợp lệ', 'distance': '24m'},
    {'subject': 'CSDL Nâng cao', 'date': '26/10/2026 07:45', 'status': 'Trễ', 'distance': '15m'},
    {'subject': 'An toàn thông tin', 'date': '24/10/2026 09:10', 'status': 'Hợp lệ', 'distance': '8m'},
  ];

  // Tab 1: Quét QR & Điểm danh
  Widget _buildCheckInTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.indigo, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.blueAccent.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Điểm danh lớp học', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text(
                'Camera & GPS sẽ kích hoạt để xác minh bạn đang có mặt trong lớp học hợp lệ.',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentScanScreen()));
                },
                icon: const Icon(Icons.qr_code_scanner, size: 22),
                label: const Text('QUÉT MÃ ĐIỂM DANH', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quy định điểm danh', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                SizedBox(height: 8),
                Text('• Mã QR giảng viên hiển thị chỉ có hiệu lực trong vòng 60 giây.', style: TextStyle(fontSize: 12, color: Colors.black87)),
                SizedBox(height: 4),
                Text('• Khoảng cách check-in phải trong phạm vi giảng đường (dưới 50m).', style: TextStyle(fontSize: 12, color: Colors.black87)),
                SizedBox(height: 4),
                Text('• Thiết bị phát hiện dùng Fake GPS sẽ bị hủy kết quả tự động.', style: TextStyle(fontSize: 12, color: Colors.red)),
              ],
            ),
          ),
        )
      ],
    );
  }

  // Tab 2: Lịch sử điểm danh
  Widget _buildHistoryTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _attendanceHistory.length,
      itemBuilder: (context, index) {
        final item = _attendanceHistory[index];
        final bool isValid = item['status'] == 'Hợp lệ';

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isValid ? Colors.green.shade50 : Colors.orange.shade50,
              child: Icon(isValid ? Icons.check_circle : Icons.access_time_filled, color: isValid ? Colors.green : Colors.orange),
            ),
            title: Text(item['subject'], style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text('${item['date']} • Cách phòng: ${item['distance']}', style: const TextStyle(fontSize: 12)),
            trailing: Chip(
              label: Text(item['status'], style: TextStyle(color: isValid ? Colors.green.shade900 : Colors.orange.shade900, fontSize: 11, fontWeight: FontWeight.bold)),
              backgroundColor: isValid ? Colors.green.shade100 : Colors.orange.shade100,
            ),
          ),
        );
      },
    );
  }

  // Tab 3: Thông tin tài khoản Sinh viên
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
                backgroundColor: Colors.indigo,
                child: Icon(Icons.school, size: 48, color: Colors.white),
              ),
              SizedBox(height: 12),
              Text('Trần Phạm Phương Trinh', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('Sinh viên Ngành Công nghệ Phần mềm', style: TextStyle(color: Colors.black54)),
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
                leading: Icon(Icons.badge_outlined, color: Colors.indigo),
                title: Text('Mã số sinh viên (MSSV)'),
                trailing: Text('2380602336', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.email_outlined, color: Colors.indigo),
                title: Text('Email sinh viên'),
                trailing: Text('trinhtpp.238@hutech.edu.vn', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.groups_outlined, color: Colors.indigo),
                title: Text('Lớp sinh hoạt'),
                trailing: Text('23DTHA1', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.check_circle_outline, color: Colors.indigo),
                title: Text('Tỷ lệ có mặt'),
                trailing: Text('95%', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
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
    final List<Widget> pages = [_buildCheckInTab(), _buildHistoryTab(), _buildProfileTab()];
    final List<String> titles = ['Điểm danh', 'Lịch sử chuyên cần', 'Tài khoản cá nhân'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.indigo,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner_outlined), activeIcon: Icon(Icons.qr_code_scanner), label: 'Điểm danh'),
          BottomNavigationBarItem(icon: Icon(Icons.history_outlined), activeIcon: Icon(Icons.history), label: 'Lịch sử'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Tài khoản'),
        ],
      ),
    );
  }
}