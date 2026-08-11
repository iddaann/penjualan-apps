import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Sementara: langsung ke dashboard setelah 1 detik.
    // Nanti di sini kita cek status login (Step Auth) sebelum redirect.
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) context.go('/dashboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sellora', style: AppTypography.display),
            const SizedBox(height: 8),
            Text(
              'Personal Sales & Business Tracker',
              style: AppTypography.caption,
            ),
          ],
        ),
      ),
    );
  }
}