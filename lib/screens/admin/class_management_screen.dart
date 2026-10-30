import 'dart:convert';
import 'package:flutter/material.dart';
import '../../config/api_constants.dart';
import '../../services/api_service.dart';

class ClassManagementScreen extends StatefulWidget {
  const ClassManagementScreen({super.key});

  @override
  State<ClassManagementScreen> createState() => _ClassManagementScreenState();
}

class _ClassManagementScreenState extends State<ClassManagementScreen> {
  List<dynamic> courses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiService.get(ApiConstants.courses);
      if (response.statusCode == 200) {
        setState(() {
          courses = jsonDecode(response.body);
        });
      }
    } catch (e) {
      // Mock Fallback
      setState(() {
        courses = [
          {'id': 1, 'code': 'IT01', 'name': 'Lập trình Di động', 'credits': 3},
          {'id': 2, 'code': 'IT02', 'name': 'Cơ sở dữ liệu', 'credits': 3},
        ];
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showClassForm({Map<String, dynamic>? currentClass}) {
    final codeCtrl = TextEditingController(text: currentClass?['code'] ?? '');
    final nameCtrl = TextEditingController(text: currentClass?['name'] ?? '');
    final creditsCtrl = TextEditingController(text: currentClass?['credits']?.toString() ?? '3');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(currentClass == null ? 'Thêm Môn Học' : 'Cập nhật Môn Học'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: 'Mã Môn')),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Tên Môn Học')),
            TextField(controller: creditsCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Số tín chỉ')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () async {
              if (codeCtrl.text.isEmpty || nameCtrl.text.isEmpty) return;
              
              if (currentClass == null) {
                // CREATE
                await ApiService.post(ApiConstants.courses, {
                  'code': codeCtrl.text,
                  'name': nameCtrl.text,
                  'credits': int.tryParse(creditsCtrl.text) ?? 3,
                });
              } else {
                // UPDATE (Tùy chọn backend có hay chưa, tạm mock)
              }

              Navigator.pop(ctx);
              _fetchCourses();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(currentClass == null ? 'Thêm thành công' : 'Cập nhật thành công')),
              );
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _deleteClass(int index) {
    setState(() {
      courses.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa (Mock)')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Môn học (CRUD)'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: courses.length,
        itemBuilder: (ctx, i) {
          final item = courses[i];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange.shade100,
                child: Text(item['code'].toString().substring(0, 2).toUpperCase(), style: const TextStyle(color: Colors.orange)),
              ),
              title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Mã: ${item['code']} • Tín chỉ: ${item['credits'] ?? 3}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showClassForm(currentClass: item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteClass(i),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showClassForm(),
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
