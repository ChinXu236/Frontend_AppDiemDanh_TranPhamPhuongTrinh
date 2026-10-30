import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _nameController = TextEditingController();

  final List<Color> _colors = [
    Colors.teal,
    Colors.indigo,
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.deepPurple,
  ];

  @override
  void initState() {
    super.initState();
    // Khởi tạo text field bằng tên custom hiện tại (nếu có)
    _nameController.text = Provider.of<SettingsProvider>(context, listen: false).customName;
  }

  void _saveName() {
    Provider.of<SettingsProvider>(context, listen: false).updateCustomName(_nameController.text);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã cập nhật hồ sơ cá nhân')));
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt hệ thống')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Cập nhật hồ sơ
          const Text('CẬP NHẬT HỒ SƠ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Tên hiển thị mới',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveName,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('LƯU HỒ SƠ'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 2. Chỉnh cỡ chữ
          const Text('GIAO DIỆN (CỠ CHỮ)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kéo để thay đổi cỡ chữ: ${settings.fontSizeOffset.toStringAsFixed(1)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    value: settings.fontSizeOffset,
                    min: -2.0, // Nhỏ nhất
                    max: 4.0,  // To nhất
                    divisions: 6,
                    label: settings.fontSizeOffset.toStringAsFixed(1),
                    onChanged: (val) => settings.updateFontSize(val),
                  ),
                  const Center(child: Text('Văn bản hiển thị mẫu thử', style: TextStyle(color: Colors.black54))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 3. Chỉnh màu chủ đạo
          const Text('MÀU CHỦ ĐẠO', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _colors.map((c) {
                  return GestureDetector(
                    onTap: () => settings.updateAppColor(c),
                    child: CircleAvatar(
                      backgroundColor: c,
                      radius: 24,
                      child: settings.appColor.value == c.value
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
