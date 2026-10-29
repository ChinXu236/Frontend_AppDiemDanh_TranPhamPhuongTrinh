import 'package:flutter/material.dart';

class ClassManagementScreen extends StatefulWidget {
  const ClassManagementScreen({super.key});

  @override
  State<ClassManagementScreen> createState() => _ClassManagementScreenState();
}

class _ClassManagementScreenState extends State<ClassManagementScreen> {
  // Mock Data (CRUD)
  List<Map<String, String>> classes = [
    {'id': '1', 'code': 'IT01', 'name': 'Lập trình Di động', 'room': 'A-101'},
    {'id': '2', 'code': 'IT02', 'name': 'Cơ sở dữ liệu', 'room': 'B-202'},
    {'id': '3', 'code': 'ENG01', 'name': 'Tiếng Anh Giao Tiếp', 'room': 'C-303'},
  ];

  void _showClassForm({Map<String, String>? currentClass, int? index}) {
    final codeCtrl = TextEditingController(text: currentClass?['code'] ?? '');
    final nameCtrl = TextEditingController(text: currentClass?['name'] ?? '');
    final roomCtrl = TextEditingController(text: currentClass?['room'] ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(currentClass == null ? 'Thêm Lớp Mới' : 'Cập nhật Lớp'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: 'Mã Lớp')),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Tên Môn Học')),
            TextField(controller: roomCtrl, decoration: const InputDecoration(labelText: 'Phòng Học')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              if (codeCtrl.text.isEmpty || nameCtrl.text.isEmpty) return;
              setState(() {
                if (currentClass == null) {
                  // CREATE
                  classes.add({
                    'id': DateTime.now().toString(),
                    'code': codeCtrl.text,
                    'name': nameCtrl.text,
                    'room': roomCtrl.text,
                  });
                } else {
                  // UPDATE
                  classes[index!] = {
                    'id': currentClass['id']!,
                    'code': codeCtrl.text,
                    'name': nameCtrl.text,
                    'room': roomCtrl.text,
                  };
                }
              });
              Navigator.pop(ctx);
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
      classes.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa lớp học')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Lớp học (CRUD)'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: classes.length,
        itemBuilder: (ctx, i) {
          final item = classes[i];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange.shade100,
                child: Text(item['code']!.substring(0, 2), style: const TextStyle(color: Colors.orange)),
              ),
              title: Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Mã: ${item['code']} • Phòng: ${item['room']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showClassForm(currentClass: item, index: i), // UPDATE
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteClass(i), // DELETE
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showClassForm(), // CREATE
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
