import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TeacherQrScreen extends StatefulWidget {
  final String classId;
  const TeacherQrScreen({super.key, required this.classId});

  @override
  State<TeacherQrScreen> createState() => _TeacherQrScreenState();
}

class _TeacherQrScreenState extends State<TeacherQrScreen> {
  String _qrPayload = '';
  int _secondsRemaining = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _refreshQrToken();
    _startTimer();
  }

  void _refreshQrToken() {
    // Payload gồm ID lớp + Timestamp miliseconds hiện tại
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      _qrPayload = '${widget.classId}|$timestamp';
      _secondsRemaining = 60;
    });
  }

  void _startTimer() {
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
        child: Column(
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