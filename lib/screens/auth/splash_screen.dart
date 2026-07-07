import 'dart:async';
import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _startAnimation = false;

  @override
  void initState() {
    super.initState();
    
    // Mulai animasi gerakan naik setelah 200ms
    Timer(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _startAnimation = true);
    });

    // Pindah ke LoginPage setelah 3 detik
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, anim, secondaryAnim) => const LoginPage(),
            transitionsBuilder: (context, anim, secondaryAnim, child) {
              // Transisi halus (Fade) agar tidak kaget saat pindah
              return FadeTransition(opacity: anim, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gunakan Stack agar background gradient tetap diam di belakang
      body: Stack(
        children: [
          // Background Gradient (Sama persis dengan Login)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Ikon yang mengecil (dari 1.8 ke 1.0)
                    AnimatedScale(
                      scale: _startAnimation ? 1.0 : 1.8,
                      duration: const Duration(seconds: 2),
                      curve: Curves.easeInOutQuart,
                      child: const Icon(
                        Icons.confirmation_number_outlined,
                        size: 80, 
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "E-TICKET HELPDESK",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // ELEMEN KUNCI:
                    // Spacer ini akan membesar untuk mendorong logo ke atas
                    // agar posisinya sama dengan posisi logo di atas form Login.
                    AnimatedContainer(
                      duration: const Duration(seconds: 2),
                      curve: Curves.easeInOutQuart,
                      height: _startAnimation ? 280 : 0, 
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}