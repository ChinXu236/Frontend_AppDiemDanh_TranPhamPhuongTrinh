import 'dart:async';
import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';

class NoiseMonitorScreen extends StatefulWidget {
  const NoiseMonitorScreen({super.key});

  @override
  State<NoiseMonitorScreen> createState() => _NoiseMonitorScreenState();
}

class _NoiseMonitorScreenState extends State<NoiseMonitorScreen> {
  bool _isRecording = false;
  NoiseReading? _latestReading;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  NoiseMeter? _noiseMeter;

  @override
  void initState() {
    super.initState();
    _noiseMeter = NoiseMeter();
  }

  Future<void> _toggleListening() async {
    if (_isRecording) {
      _noiseSubscription?.cancel();
      setState(() => _isRecording = false);
      return;
    }

    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) return;

    try {
      _noiseSubscription = _noiseMeter?.noise.listen((NoiseReading reading) {
        setState(() => _latestReading = reading);
      });
      setState(() => _isRecording = true);
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  @override
  void dispose() {
    _noiseSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double db = _latestReading?.meanDecibel ?? 0.0;
    bool isLoud = db > 70.0; // Mức cảnh báo nếu ồn trên 70 dB

    return Scaffold(
      appBar: AppBar(title: const Text('Giám sát Tiếng ồn Lớp học')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${db.toStringAsFixed(1)} dB',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: isLoud ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            Text(isLoud ? 'CẢNH BÁO: LỚP ĐANG RẤT ỒN!' : 'Môi trường học tập yên tĩnh',
                style: TextStyle(fontSize: 18, color: isLoud ? Colors.red : Colors.black87)),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _toggleListening,
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              label: Text(_isRecording ? 'Dừng đo' : 'Bắt đầu đo tiếng ồn'),
            )
          ],
        ),
      ),
    );
  }
}