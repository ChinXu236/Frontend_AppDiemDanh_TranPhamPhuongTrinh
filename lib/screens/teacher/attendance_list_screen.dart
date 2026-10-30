import 'dart:convert';
import 'package:flutter/material.dart';
import '../../config/api_constants.dart';
import '../../services/api_service.dart';

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
  List<dynamic> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAttendanceList();
  }

  Future<void> _fetchAttendanceList() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiService.get(ApiConstants.sessionAttendance(int.tryParse(widget.classId) ?? 1));
      if (response.statusCode == 200) {
        setState(() {
          _students = jsonDecode(response.body);
        });
      }
    } catch (e) {
      // Mock Fallback
      setState(() {
        _students = [
          {'fullName': 'Nguyễn Văn An', 'studentCode': 'SV01', 'status': 'Present', 'distance': '15m'},
          {'fullName': 'Trần Thị Bình', 'studentCode': 'SV02', 'status': 'Present', 'distance': '24m'},
          {'fullName': 'Lê Minh Anh', 'studentCode': 'SV03', 'status': 'Cheat', 'distance': 'Vượt quá 500m'},
          {'fullName': 'Võ Ngọc Chi', 'studentCode': 'SV05', 'status': 'Absent', 'distance': '-'},
        ];
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _translateStatus(String status) {
    if (status == 'Present') return 'Hợp lệ';
    if (status == 'Late') return 'Trễ';
    if (status == 'Absent') return 'Vắng mặt';
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Điểm danh: ${widget.className}'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _students.length,
        itemBuilder: (ctx, i) {
          final s = _students[i];
          final String statusText = _translateStatus(s['status'] ?? '');
          final bool isOk = statusText == 'Hợp lệ';
          final bool isAbsent = statusText == 'Vắng mặt';
          final bool isCheat = s['status'] == 'Cheat';

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
              title: Text(s['fullName'] ?? 'Không rõ', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                'MSSV: ${s['studentCode']} • Cách phòng: ${s['distance'] ?? '10m'}',
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
                  statusText,
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
