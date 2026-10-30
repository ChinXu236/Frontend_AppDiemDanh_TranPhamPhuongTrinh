import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../config/api_constants.dart';
import '../../services/api_service.dart';
import '../admin/admin_dashboard.dart';
import '../teacher/teacher_dashboard.dart';
import '../student/student_dashboard.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xin chào ${account.displayName}!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const StudentDashboard()),
        );
      }
    } catch (error) {
      // Mock Fallback nếu chưa cấu hình SHA-1 Firebase
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mô phỏng đăng nhập Google OAuth 2.0 thành công!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StudentDashboard()),
      );
    }
  }

  Future<void> _submitLogin() async {
    final identifier = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (identifier.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tài khoản và mật khẩu')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await ApiService.post(
        ApiConstants.login,
        {
          'emailOrUsername': identifier, 
          'password': password,
        }
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Lưu Access Token mới
        await ApiService.saveToken(data['accessToken']);

        final List<dynamic> roles = data['roles'] ?? [];

        // Thành công: vào thẳng hệ thống theo role
        if (roles.contains('Admin')) {
          _navigateByRole('admin');
        } else if (roles.contains('Teacher')) {
          _navigateByRole('teacher');
        } else {
          _navigateByRole('student');
        }
      } else {
        // Sai pass hoặc lỗi
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sai tài khoản hoặc mật khẩu')),
          );
        }
      }
    } catch (e) {
      // MOCK DATA FALLBACK: Đề phòng API Somee sập/chưa update, 
      // ta vẫn cho phép giả lập đăng nhập để làm frontend
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đang dùng chế độ Demo (Bỏ qua kết nối mạng)')),
        );
      }
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Giả lập role theo tên đăng nhập
      if (identifier.toLowerCase().contains('admin')) {
        _navigateByRole('admin');
      } else if (identifier.toLowerCase().contains('teacher') || identifier.toLowerCase().contains('gv')) {
        _navigateByRole('teacher');
      } else {
        _navigateByRole('student');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateByRole(String role) {
    if (!mounted) return;
    if (role == 'admin') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminDashboard()));
    } else if (role == 'teacher') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TeacherDashboard()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StudentDashboard()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng nhập Điểm danh'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              const Icon(Icons.school, size: 70, color: Colors.indigo),
              const SizedBox(height: 10),
              const Text(
                'HỆ THỐNG ĐIỂM DANH',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 24),

              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Tên đăng nhập / Email',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitLogin,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('ĐĂNG NHẬP', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("HOẶC", style: TextStyle(color: Colors.grey))),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _handleGoogleSignIn,
                icon: const Icon(Icons.g_mobiledata, size: 28, color: Colors.red),
                label: const Text('Đăng nhập với Google (OAuth2)'),
                style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                },
                child: const Text('Chưa có tài khoản? Đăng ký ngay'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}