import 'package:flutter/material.dart';
import '../dashboard/admin_dashboard.dart';
import '../dashboard/helpdesk_dashboard.dart';
import '../dashboard/user_dashboard.dart';
import '../../services/api_service.dart';
import 'register_page.dart';
import 'reset_password_page.dart'; // Import Halaman Reset

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isObscure = true;

  // FR-001: Fungsi Login dengan Pengecekan Dinamis
  Future<void> _handleLogin() async {
    try {
      String email = _emailController.text.trim();
      String password = _passController.text.trim();

      print("LOGIN DITEKAN");

      final result = await ApiService.login(email, password);

      print(result);

      if (result['success'] != true) {
        _showSnackBar(
          result['message'] ?? "Login gagal",
          Colors.red,
        );
        return;
      }

      final user = result['user'];
      ApiService.currentUserId = user['id'];
      ApiService.currentUserName = user['name'];
      ApiService.currentUserEmail = user['email'];
      ApiService.currentUserRole = user['role'];

      String role = user['role'];

      print("ROLE = $role");

      if (role == 'admin') {
        _navigate(const AdminDashboard());
      } else if (role == 'helpdesk') {
        _navigate(const HelpdeskDashboard());
      } else {
        _navigate(const UserDashboard());
      }
    } catch (e) {
      print("LOGIN ERROR");
      print(e);

      _showSnackBar(
        e.toString(),
        Colors.red,
      );
    }
  }

  void _navigate(Widget page) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color, behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Gradient Full Layar
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          // 2. Konten
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.confirmation_number_outlined, size: 80, color: Colors.white),
                    const SizedBox(height: 10),
                    const Text("E-TICKET HELPDESK", 
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 40),

                    TextField(
                      controller: _emailController,
                      decoration: _inputDecoration("Email Address", Icons.email_outlined),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: _passController,
                      obscureText: _isObscure,
                      decoration: _inputDecoration("Password", Icons.lock_outline).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
                          onPressed: () => setState(() => _isObscure = !_isObscure),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    
                    // FR-004: Navigasi Lupa Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const ResetPasswordPage()));
                        },
                        child: const Text("Lupa Password?", style: TextStyle(color: Colors.white70)),
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1E3C72),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          await _handleLogin();
                        },
                        child: const Text("MASUK", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // FR-003: Navigasi Daftar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Belum punya akun?", style: TextStyle(color: Colors.white70)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage()));
                          },
                          child: const Text("Daftar Sekarang", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                    const Text("Hint: admin@mail.com | user@mail.com", 
                      style: TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white),
      ),
    );
  }
}