class ApiConstants {
  // Base URL chính thức trên Somee
  static const String baseUrl = 'http://api3conca.somee.com/api';

  // Auth & OTP
  static const String login = '$baseUrl/auth/login';
  static const String verifyOtp = '$baseUrl/auth/verify-otp';
  static const String register = '$baseUrl/auth/register';

  // Attendance
  static const String scanQr = '$baseUrl/attendance/scan-qr';
  static const String myHistory = '$baseUrl/attendance/my-history';
  static const String mySummary = '$baseUrl/attendance/my-summary';

  // Attendance Records (CRUD)
  static const String attendanceRecords = '$baseUrl/attendance/records';
}