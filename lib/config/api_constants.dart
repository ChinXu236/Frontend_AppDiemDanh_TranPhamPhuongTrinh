class ApiConstants {
  // Base URL chính thức trên Somee
  static const String baseUrl = 'http://webapibaconca.somee.com/api';

  // Auth
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String me = '$baseUrl/auth/me';

  // Users info (Bổ sung từ Backend mới)
  static const String studentMe = '$baseUrl/students/me';
  static const String teacherMe = '$baseUrl/teachers/me';

  // Courses (Admin)
  static const String courses = '$baseUrl/courses';

  // Class Sessions & Attendance Sessions (Teacher)
  static const String classSessions = '$baseUrl/class-sessions';
  static const String attendanceSessions = '$baseUrl/attendance-sessions';

  // Attendance (Student & Teacher)
  static const String scanQr = '$baseUrl/attendance/scan-qr';
  static String sessionAttendance(int id) => '$baseUrl/attendance/session/$id';
}
