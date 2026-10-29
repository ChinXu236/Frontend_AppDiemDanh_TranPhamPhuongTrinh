import 'dart:async';

class ApiService {
  // Đổi thành false khi bạn cùng nhóm đã deploy xong API thật
  static const bool isMock = false;

  // 1. Giả lập đăng nhập & gửi OTP
  static Future<Map<String, dynamic>> login(String username, String password) async {
    if (isMock) {
      await Future.delayed(const Duration(milliseconds: 800)); // Giả lập độ trễ mạng
      if (username.isNotEmpty && password.isNotEmpty) {
        return {'success': true, 'userId': 'USR_12345', 'message': 'OTP đã gửi về email'};
      }
      return {'success': false, 'message': 'Vui lòng nhập đầy đủ thông tin'};
    }
    // TODO: Chỗ gọi http.post thật tới backend online
    return {};
  }

  // 2. Giả lập xác thực OTP & Trả về Role
  static Future<Map<String, dynamic>> verifyOtp(String userId, String otp) async {
    if (isMock) {
      await Future.delayed(const Duration(milliseconds: 600));

      // Phân quyền giả lập theo mã OTP bạn nhập để test cả 3 giao diện:
      // Nhập 111111 -> Ra Admin
      // Nhập 222222 -> Ra Teacher (Giáo viên)
      // Nhập số khác -> Ra Student (Sinh viên)
      String role = 'student';
      if (otp == '111111') role = 'admin';
      if (otp == '222222') role = 'teacher';

      return {
        'success': true,
        'token': 'mock_jwt_token_xyz',
        'role': role,
        'name': 'Trần Phạm Phương Trinh'
      };
    }
    return {};
  }

  // 3. Giả lập sinh viên Điểm danh (GPS + QR)
  static Future<Map<String, dynamic>> checkIn({
    required String classId,
    required double lat,
    required double lon,
  }) async {
    if (isMock) {
      await Future.delayed(const Duration(milliseconds: 700));
      return {
        'success': true,
        'message': 'Điểm danh thành công! Khoảng cách hợp lệ: 14m',
      };
    }
    return {};
  }
}