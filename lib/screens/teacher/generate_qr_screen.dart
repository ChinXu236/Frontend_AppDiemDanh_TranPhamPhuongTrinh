import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../config/api_constants.dart';
import '../../services/api_service.dart';

class TeacherQrScreen extends StatefulWidget {
  final String classId;
  const TeacherQrScreen({super.key, required this.classId});

  @override
  State<TeacherQrScreen> createState() => _TeacherQrScreenState();
}

class _TeacherQrScreenState extends State<TeacherQrScreen> {
  String _qrPayload = '';
  int _secondsRemaining = 60; // Thật ra QR trên server sống 2 phút, nhưng ta đếm 60s để tạo hiệu ứng
  int? _attendanceSessionId;
  Timer? _timer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _startSessionAndGetQr();
  }

  Future<void> _startSessionAndGetQr() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiService.post(ApiConstants.attendanceSessions, {
        'classSessionId': int.tryParse(widget.classId) ?? 1
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _attendanceSessionId = data['id'];
          _qrPayload = data['qrCode'];
          _secondsRemaining = 60;
          _isLoading = false;
        });
        _startTimer();
      } else {
        // Nếu đã có session đang mở thì cần phải fetch (tuy nhiên api chỉ cho tạo mới, mock nếu lỗi)
        _mockQr();
      }
    } catch (e) {
      _mockQr();
    }
  }

  Future<void> _refreshQrToken() async {
    if (_attendanceSessionId == null) {
      _mockQr();
      return;
    }
    try {
      final response = await ApiService.post('${ApiConstants.attendanceSessions}/$_attendanceSessionId/refresh-qr', {});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _qrPayload = data['qrCode'];
          _secondsRemaining = 60;
        });
      }
    } catch (e) {
      _mockQr();
    }
  }

  void _mockQr() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      _qrPayload = '${widget.classId}|$timestamp';
      _secondsRemaining = 60;
      _isLoading = false;
    });
    if (_timer == null || !_timer!.isActive) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 1) {
        setState(() => _secondsRemaining--);
      } else {
        _refreshQrToken(); // Hết 60s tự sinh mã mới
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mã QR Điểm Danh')),
      body: Center(
        child: _isLoading 
          ? const CircularProgressIndicator()
          : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: _qrPayload,
              version: QrVersions.auto,
              size: 260.0,
            ),
            const SizedBox(height: 20),
            Text('Mã tự động đổi sau: $_secondsRemaining giây',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
          ],
        ),
      ),
    );
  }
}