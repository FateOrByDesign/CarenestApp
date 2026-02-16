import 'package:flutter/material.dart';
import 'dart:async';
import '../core/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Timer: Wait 3 seconds, then go to Login
    Timer(const Duration(seconds: 3), () {
      // We use pushReplacementNamed so the user can't "back" into the splash screen
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Use your Brand Color (Teal)
      backgroundColor: AppTheme.primary,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 2. Logo Icon (White for contrast)
            // If you have a real image, use: Image.asset('assets/images/logo_white.png', height: 100)
            Image.asset('../assets/images/logo_white.png', height: 100, errorBuilder: (context, error, stack) {
              // Fallback if logo isn't added yet
              return const Icon(Icons.favorite, size: 80, color: AppTheme.surface);
            }),

            const SizedBox(height: 24),

            // 3. App Name
            Image(image:  const AssetImage('../assets/images/typo_white.png'), height: 28, errorBuilder: (context, error, stack) {
              // Fallback if logo text isn't added yet
              return const Text(
                'CARENEST',
                style: TextStyle(
                  letterSpacing: 2.2,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.surface,
                  fontSize: 18,
                ),
              );
            }),

            const SizedBox(height: 8),

            // 4. Tagline or Slogan
            Text(
              'Care that feels closer to home',
              style: AppTheme.bodyText.copyWith(
                color: AppTheme.surface.withOpacity(0.9),
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 60),

            // 5. Loading Spinner
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.surface),
            ),
          ],
        ),
      ),
    );
  }
}