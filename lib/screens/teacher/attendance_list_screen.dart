import 'package:flutter/material.dart';

class AttendanceListScreen extends StatefulWidget {
  final String classId;
  final String className;
  
  const AttendanceListScreen({
    super.key, 
    required this.classId, 
    required this.className
  });

  @override
  State<AttendanceListScreen> createState() => _AttendanceListScreenState();
}

class _AttendanceListScreenState extends State<AttendanceListScreen> {
  // Mock Data: Sinh viên điểm danh kèm vị trí
  final List<Map<String, dynamic>> _students = [
    {'name': 'Nguyễn Văn An', 'code': 'SV01', 'status': 'Hợp lệ', 'distance': '15m'},
    {'name': 'Trần Thị Bình', 'code': 'SV02', 'status': 'Hợp lệ', 'distance': '24m'},
    {'name': 'Lê Minh Anh', 'code': 'SV03', 'status': 'Gian lận', 'distance': 'Vượt quá 500m'},
    {'name': 'Phạm Quốc Bảo', 'code': 'SV04', 'status': 'Trễ', 'distance': '45m'},
    {'name': 'Võ Ngọc Chi', 'code': 'SV05', 'status': 'Vắng mặt', 'distance': '-'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Điểm danh: ${widget.className}'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _students.length,
        itemBuilder: (ctx, i) {
          final s = _students[i];
          final bool isOk = s['status'] == 'Hợp lệ';
          final bool isAbsent = s['status'] == 'Vắng mặt';
          final bool isCheat = s['status'] == 'Gian lận';

          return Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isOk ? Colors.green.shade100 : (isAbsent ? Colors.grey.shade300 : Colors.red.shade100),
                child: Icon(
                  isOk ? Icons.check : (isAbsent ? Icons.person_off : Icons.warning_amber),
                  color: isOk ? Colors.green : (isAbsent ? Colors.grey : Colors.red),
                ),
              ),
              title: Text(s['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                'MSSV: ${s['code']} • Cách phòng: ${s['distance']}',
                style: TextStyle(
                  color: isCheat ? Colors.red : Colors.black54,
                  fontWeight: isCheat ? FontWeight.bold : FontWeight.normal
                ),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isOk ? Colors.green.shade100 : (isAbsent ? Colors.grey.shade200 : Colors.orange.shade100),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  s['status'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isOk ? Colors.green.shade800 : (isAbsent ? Colors.black54 : Colors.orange.shade900),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
