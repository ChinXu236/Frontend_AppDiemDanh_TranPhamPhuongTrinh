import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  double _fontSizeOffset = 0.0; // Khoảng chênh lệch (âm là nhỏ, dương là to)
  Color _appColor = Colors.teal; // Màu nền mặc định
  String _customName = ''; // Tên do người dùng tự đổi

  double get fontSizeOffset => _fontSizeOffset;
  Color get appColor => _appColor;
  String get customName => _customName;

  SettingsProvider() {
    _loadSettings();
  }

  // Khôi phục cài đặt từ máy
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _fontSizeOffset = prefs.getDouble('font_size_offset') ?? 0.0;
    
    int colorValue = prefs.getInt('app_color') ?? Colors.teal.value;
    _appColor = Color(colorValue);

    _customName = prefs.getString('custom_name') ?? '';
    notifyListeners();
  }

  // Đổi cỡ chữ
  Future<void> updateFontSize(double newOffset) async {
    _fontSizeOffset = newOffset;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('font_size_offset', newOffset);
  }

  // Đổi màu chủ đạo
  Future<void> updateAppColor(Color color) async {
    _appColor = color;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('app_color', color.value);
  }

  // Đổi tên cá nhân
  Future<void> updateCustomName(String name) async {
    _customName = name;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('custom_name', name);
  }
}
