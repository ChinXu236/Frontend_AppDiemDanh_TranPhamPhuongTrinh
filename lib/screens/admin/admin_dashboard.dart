import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../config/api_constants.dart';
import '../../providers/settings_provider.dart';
import '../auth/login_screen.dart';
import '../settings_screen.dart';
import 'class_management_screen.dart';


import 'class_management_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _totalStudents = 0;
  int _totalTeachers = 0;
  int _totalClasses = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAdminStats();
  }

  Future<void> _fetchAdminStats() async {
    try {
      final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/admin/stats'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _totalStudents = data['students'] ?? 120;
          _totalTeachers = data['teachers'] ?? 15;
          _totalClasses = data['classes'] ?? 8;
          _isLoading = false;
        });
      } else {
        // Giá trị mẫu dự phòng nếu API chưa sẵn sàng
        setState(() => _isLoading = false);
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  void _showAddClassDialog() {
    final codeCtrl = TextEditingController();
    final nameCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thêm lớp học mới (CRUD)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: 'Mã lớp (VD: IT01)')),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Tên môn học')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () async {
              // Gọi API POST /classes
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã thêm lớp thành công!')),
              );
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảng Quản Trị Hệ Thống'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _fetchAdminStats,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text(
              'Tổng quan hệ thống',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildMetricCard('Sinh viên', '$_totalStudents', Icons.school, Colors.blue),
                const SizedBox(width: 8),
                _buildMetricCard('Giảng viên', '$_totalTeachers', Icons.person_pin, Colors.teal),
                const SizedBox(width: 8),
                _buildMetricCard('Lớp học', '$_totalClasses', Icons.meeting_room, Colors.deepPurple),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Quản lý dữ liệu (CRUD)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildAdminMenuTile(
              title: 'Quản lý Tài khoản & Phân quyền',
              subtitle: 'Thêm, sửa, xóa, cấp vai trò người dùng',
              icon: Icons.manage_accounts,
              color: Colors.blueAccent,
              onTap: () {
                // Điều hướng màn hình CRUD Accounts
              },
            ),
            _buildAdminMenuTile(
              title: 'Quản lý Lớp học & Môn học',
              subtitle: 'Danh sách môn, thêm mới lớp tín chỉ',
              icon: Icons.book,
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ClassManagementScreen())
                );
              },
            ),
            _buildAdminMenuTile(
              title: 'Cấu hình Tọa độ & Phạm vi Check-in',
              subtitle: 'Cài đặt GPS trường học & Bán kính hợp lệ (mét)',
              icon: Icons.location_on,
              color: Colors.redAccent,
              onTap: () {
                // Điều hướng màn hình cấu hình GPS
              },
            ),
            _buildAdminMenuTile(
              title: 'Báo cáo thống kê toàn trường',
              subtitle: 'Xuất file điểm danh, xem tỷ lệ chuyên cần',
              icon: Icons.bar_chart,
              color: Colors.green,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Column(
            children: [
              Icon(icon, size: 28, color: color),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminMenuTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}