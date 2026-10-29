import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../../config/api_constants.dart';

class StudentScanScreen extends StatefulWidget {
  const StudentScanScreen({super.key});

  @override
  State<StudentScanScreen> createState() => _StudentScanScreenState();
}

class _StudentScanScreenState extends State<StudentScanScreen> {
  bool _isProcessing = false;

  Future<void> _handleQrScanned(String rawData) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      // 1. Phân tách dữ liệu QR (classId|timestamp)
      final parts = rawData.split('|');
      if (parts.length != 2) throw Exception('Mã QR không đúng định dạng');

      final String classId = parts[0];
      final int generatedTime = int.parse(parts[1]);
      final int currentTime = DateTime.now().millisecondsSinceEpoch;

      // 2. Kiểm tra hạn mã QR (60 giây = 60,000 ms)
      if (currentTime - generatedTime > 60000) {
        _showDialog('Lỗi', 'Mã QR đã hết hạn! Vui lòng quét mã mới trên màn hình giáo viên.');
        return;
      }

      // 3. Xin quyền và lấy tọa độ GPS
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showDialog('Lỗi', 'Cần cấp quyền vị trí để điểm danh.');
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 4. TÍNH NĂNG SÁNG TẠO: Kiểm tra Fake GPS (Mock Location)
      if (position.isMocked) {
        _showDialog('Cảnh báo gian lận', 'Hệ thống phát hiện bạn đang dùng ứng dụng giả lập vị trí (Fake GPS)!');
        return;
      }

      // 5. Gửi lên API thật trên Somee
      final response = await http.post(
        Uri.parse('http://api3conca.somee.com/api/attendance/scan-qr'),
        headers: {
          'Content-Type': 'application/json',
          // Thay yourAccessToken bằng token nhận được khi đăng nhập (nếu đã lưu SharedPreferences)
          // 'Authorization': 'Bearer $yourAccessToken',
        },
        body: jsonEncode({
          'qrToken': rawData,             // Đúng tên trường 'qrToken' trên Swagger
          'latitude': position.latitude,  // Tọa độ vĩ độ
          'longitude': position.longitude // Tọa độ kinh độ
        }),
      );

      if (response.statusCode == 200) {
        _showDialog('Thành công', 'Điểm danh thành công hợp lệ!');
      } else {
        final error = jsonDecode(response.body);
        _showDialog('Thất bại', error['message'] ?? 'Bạn đang ở ngoài phạm vi lớp học.');
      }
    } catch (e) {
      _showDialog('Lỗi', e.toString());
    } finally {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _isProcessing = false);
      });
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quét mã điểm danh')),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  _handleQrScanned(barcode.rawValue!);
                  break;
                }
              }
            },
          ),
          if (_isProcessing)
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        ],
      ),
    );
  }
}